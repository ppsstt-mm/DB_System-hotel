package com.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class BookingFlowQueryService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private BookingLifecycleService bookingLifecycleService;

    public Map<String, Object> getBookingFlow(Long bookingId, String bookingNo) {
        bookingLifecycleService.expireUnpaidBookings();
        Map<String, Object> booking = loadBooking(bookingId, bookingNo);
        if (booking == null) {
            return null;
        }

        Long id = ((Number) booking.get("id")).longValue();
        Map<String, Object> flow = new LinkedHashMap<>();
        flow.put("booking", booking);
        flow.put("bookingRooms", query(
                "SELECT br.id, br.room_price, br.stay_start_date, br.stay_end_date, br.room_status, " +
                        "ri.id AS room_id, ri.room_no, ri.floor_no, ri.status AS room_current_status, " +
                        "rc.kefangmingcheng AS room_name, rc.room_category " +
                        "FROM booking_room br " +
                        "LEFT JOIN room_instance ri ON ri.id = br.room_id " +
                        "LEFT JOIN room_catalog rc ON rc.id = ri.room_catalog_id " +
                        "WHERE br.booking_id = ? ORDER BY ri.room_no ASC, br.id ASC",
                id
        ));
        flow.put("bookingGuests", query(
                "SELECT id, booking_id, guest_name, id_card_no, phone, is_primary, created_at, updated_at " +
                        "FROM booking_guest WHERE booking_id = ? ORDER BY is_primary DESC, id ASC",
                id
        ));
        flow.put("statusLogs", query(
                "SELECT id, booking_id, old_status, new_status, operator_id, remark, created_at " +
                        "FROM booking_status_log WHERE booking_id = ? ORDER BY created_at ASC, id ASC",
                id
        ));
        flow.put("billSummary", one(
                "SELECT * FROM v_bill_payment_summary WHERE booking_id = ? ORDER BY bill_id DESC LIMIT 1",
                id
        ));
        flow.put("paymentRecords", query(
                "SELECT pr.id, pr.bill_id, pr.payment_no, pr.pay_method, pr.pay_amount, pr.pay_status, pr.paid_at, pr.remark " +
                        "FROM payment_record pr " +
                        "JOIN bill b ON b.id = pr.bill_id " +
                        "WHERE b.booking_id = ? ORDER BY pr.paid_at ASC, pr.id ASC",
                id
        ));
        flow.put("refundRecords", query(
                "SELECT rr.id, rr.payment_id, rr.refund_no, rr.refund_amount, rr.refund_reason, rr.refund_status, rr.created_at " +
                        "FROM refund_record rr " +
                        "JOIN payment_record pr ON pr.id = rr.payment_id " +
                        "JOIN bill b ON b.id = pr.bill_id " +
                        "WHERE b.booking_id = ? ORDER BY rr.created_at ASC, rr.id ASC",
                id
        ));
        flow.put("checkinRecord", one(
                "SELECT cr.id, cr.booking_id, cr.room_id, cr.customer_id, cr.employee_id, cr.checkin_time, cr.checkout_time, cr.status, cr.remark, " +
                        "ri.room_no, rc.kefangmingcheng AS room_name, rc.room_category, e.employeexingming AS employee_name " +
                        "FROM checkin_record cr " +
                        "LEFT JOIN room_instance ri ON ri.id = cr.room_id " +
                        "LEFT JOIN room_catalog rc ON rc.id = ri.room_catalog_id " +
                        "LEFT JOIN employee e ON e.id = cr.employee_id " +
                        "WHERE cr.booking_id = ? ORDER BY cr.id DESC LIMIT 1",
                id
        ));

        Map<String, Object> checkinRecord = castMap(flow.get("checkinRecord"));
        if (checkinRecord != null && checkinRecord.get("id") != null) {
            flow.put("checkinGuests", query(
                    "SELECT id, checkin_id, guest_name, id_card_no, phone, is_primary, created_at " +
                            "FROM checkin_guest WHERE checkin_id = ? ORDER BY is_primary DESC, id ASC",
                    ((Number) checkinRecord.get("id")).longValue()
            ));
        } else {
            flow.put("checkinGuests", new ArrayList<>());
        }

        String stageCode = resolveCurrentStageCode(booking, checkinRecord);
        flow.put("currentStageCode", stageCode);
        flow.put("currentStage", stageLabel(stageCode));
        flow.put("timeline", buildTimeline(flow));
        return flow;
    }

    private Map<String, Object> loadBooking(Long bookingId, String bookingNo) {
        if (bookingId != null) {
            return one("SELECT * FROM booking_order WHERE id = ? LIMIT 1", bookingId);
        }
        if (bookingNo != null && !bookingNo.trim().isEmpty()) {
            return one("SELECT * FROM booking_order WHERE yudingbianhao = ? LIMIT 1", bookingNo.trim());
        }
        return null;
    }

    private List<Map<String, Object>> buildTimeline(Map<String, Object> flow) {
        List<Map<String, Object>> events = new ArrayList<>();
        Map<String, Object> booking = castMap(flow.get("booking"));
        Map<String, Object> billSummary = castMap(flow.get("billSummary"));
        Map<String, Object> checkinRecord = castMap(flow.get("checkinRecord"));

        if (booking != null) {
            events.add(event(
                    "created",
                    "预订已创建",
                    booking.get("addtime"),
                    "订单已生成，等待支付和入住办理。"
            ));
        }

        for (Map<String, Object> record : castList(flow.get("paymentRecords"))) {
            events.add(event(
                    "payment",
                    "完成支付",
                    record.get("paid_at"),
                    "支付单号：" + safe(record.get("payment_no")) + "，支付方式：" + payMethodLabel(record.get("pay_method"))
            ));
        }

        if (checkinRecord != null && checkinRecord.get("checkin_time") != null) {
            events.add(event(
                    "checkin",
                    "已办理入住",
                    checkinRecord.get("checkin_time"),
                    "房号：" + safe(checkinRecord.get("room_no")) + "，办理员工：" + safe(checkinRecord.get("employee_name"))
            ));
        }

        if (checkinRecord != null && checkinRecord.get("checkout_time") != null) {
            events.add(event(
                    "checkout",
                    "已办理离店",
                    checkinRecord.get("checkout_time"),
                    "入住记录已退房，房间已回收。"
            ));
        }

        for (Map<String, Object> row : castList(flow.get("statusLogs"))) {
            String newStatus = safe(row.get("new_status"));
            if ("cancelled".equals(newStatus)) {
                events.add(event("cancelled", "订单已取消", row.get("created_at"), safe(row.get("remark"))));
            } else if ("completed".equals(newStatus)) {
                events.add(event("completed", "订单已完成", row.get("created_at"), safe(row.get("remark"))));
            }
        }

        for (Map<String, Object> row : castList(flow.get("refundRecords"))) {
            events.add(event(
                    "refund",
                    "已发起退款",
                    row.get("created_at"),
                    "退款单号：" + safe(row.get("refund_no")) + "，退款金额：" + safe(row.get("refund_amount"))
            ));
        }

        events.sort(Comparator.comparing(row -> String.valueOf(row.get("time") == null ? "" : row.get("time"))));
        return events;
    }

    private String resolveCurrentStageCode(Map<String, Object> booking, Map<String, Object> checkinRecord) {
        String bookingStatus = safe(booking.get("booking_status"));
        String payStatus = safe(booking.get("ispay"));

        if ("cancelled".equals(bookingStatus)) {
            return "cancelled";
        }
        if ("completed".equals(bookingStatus)) {
            return "completed";
        }
        if (checkinRecord != null && "checked_in".equals(safe(checkinRecord.get("status")))) {
            return "checked_in";
        }
        if ("paid".equals(payStatus) || "partial".equals(payStatus)) {
            return "paid";
        }
        return "created";
    }

    private String stageLabel(String stageCode) {
        if ("cancelled".equals(stageCode)) {
            return "已取消";
        }
        if ("completed".equals(stageCode)) {
            return "已离店";
        }
        if ("checked_in".equals(stageCode)) {
            return "入住中";
        }
        if ("paid".equals(stageCode)) {
            return "待入住";
        }
        return "预订中";
    }

    private String payMethodLabel(Object value) {
        String method = safe(value);
        if ("wechat".equals(method)) {
            return "微信";
        }
        if ("alipay".equals(method)) {
            return "支付宝";
        }
        if ("card".equals(method)) {
            return "银行卡";
        }
        if ("cash".equals(method)) {
            return "现金";
        }
        return method;
    }

    private BigDecimal decimalValue(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }
        return new BigDecimal(String.valueOf(value));
    }

    private Map<String, Object> event(String key, String title, Object time, String description) {
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("key", key);
        row.put("title", title);
        row.put("time", time);
        row.put("description", description);
        return row;
    }

    private String safe(Object value) {
        return value == null ? "-" : String.valueOf(value);
    }

    private Map<String, Object> one(String sql, Object... args) {
        List<Map<String, Object>> rows = query(sql, args);
        return rows.isEmpty() ? null : rows.get(0);
    }

    private List<Map<String, Object>> query(String sql, Object... args) {
        return jdbcTemplate.queryForList(sql, args);
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> castMap(Object value) {
        return value == null ? null : (Map<String, Object>) value;
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> castList(Object value) {
        return value == null ? new ArrayList<>() : (List<Map<String, Object>>) value;
    }
}
