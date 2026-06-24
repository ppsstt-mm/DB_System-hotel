package com.controller;

import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.entity.KefangyudingEntity;
import com.entity.TokenEntity;
import com.entity.view.KefangyudingView;
import com.service.BookingFlowQueryService;
import com.service.BookingLifecycleService;
import com.service.KefangyudingService;
import com.service.TokenService;
import com.utils.MPUtil;
import com.utils.PageUtils;
import com.utils.R;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/booking_order")
public class KefangyudingController {

    @Autowired
    private KefangyudingService bookingOrderService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private BookingFlowQueryService bookingFlowQueryService;

    @Autowired
    private BookingLifecycleService bookingLifecycleService;

    private TokenEntity currentToken(HttpServletRequest request) {
        String token = request.getHeader("Token");
        if (StringUtils.isBlank(token)) {
            return null;
        }
        return tokenService.getTokenEntity(token);
    }

    private boolean isCustomer(HttpServletRequest request) {
        Object tableName = request.getSession().getAttribute("tableName");
        if (tableName != null) {
            return "customer".equals(String.valueOf(tableName));
        }
        TokenEntity tokenEntity = currentToken(request);
        return tokenEntity != null && "customer".equals(tokenEntity.getTablename());
    }

    private String currentUsername(HttpServletRequest request) {
        Object username = request.getSession().getAttribute("username");
        if (username != null) {
            return String.valueOf(username);
        }
        TokenEntity tokenEntity = currentToken(request);
        return tokenEntity == null ? null : tokenEntity.getUsername();
    }

    private Long currentUserId(HttpServletRequest request) {
        Object userId = request.getSession().getAttribute("userId");
        if (userId != null) {
            if (userId instanceof Long) {
                return (Long) userId;
            }
            return Long.valueOf(String.valueOf(userId));
        }
        TokenEntity tokenEntity = currentToken(request);
        return tokenEntity == null ? null : tokenEntity.getUserid();
    }

    private boolean ownsBooking(KefangyudingEntity bookingOrder, HttpServletRequest request) {
        if (bookingOrder == null) {
            return false;
        }
        if (!isCustomer(request)) {
            return true;
        }
        String username = currentUsername(request);
        Long userId = currentUserId(request);
        return (StringUtils.isNotBlank(username) && username.equals(bookingOrder.getCustomerming()))
                || (userId != null && userId.equals(bookingOrder.getCustomer_id()));
    }

    private String generateBookingNo() {
        String prefix = "BK" + new SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM booking_order WHERE yudingbianhao LIKE ?",
                Integer.class,
                prefix + "%"
        );
        return prefix + String.format("%04d", (count == null ? 0 : count) + 1);
    }

    private Map<String, Object> loadCustomer(Long customerId) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT id, customerming, xingming, shoujihao FROM customer WHERE id=? LIMIT 1",
                customerId
        );
        return rows.isEmpty() ? null : rows.get(0);
    }

    private Map<String, Object> loadRoomCatalog(Long roomCatalogId) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT id, kefangmingcheng, room_category, kefangjiage, kefangtupian, jiudianmingcheng, jiudiandizhi " +
                        "FROM room_catalog WHERE id=? LIMIT 1",
                roomCatalogId
        );
        return rows.isEmpty() ? null : rows.get(0);
    }

    private java.util.Date parseDateValue(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof java.util.Date) {
            return (java.util.Date) value;
        }
        String text = String.valueOf(value).trim();
        if (text.isEmpty() || "null".equalsIgnoreCase(text)) {
            return null;
        }
        if (text.length() >= 10) {
            return Date.valueOf(text.substring(0, 10));
        }
        return null;
    }

    private Long parseLong(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof Number) {
            return ((Number) value).longValue();
        }
        String text = String.valueOf(value).trim();
        if (text.isEmpty() || "null".equalsIgnoreCase(text)) {
            return null;
        }
        return Long.valueOf(text);
    }

    private int parseInt(Object value, int defaultValue) {
        if (value == null) {
            return defaultValue;
        }
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        String text = String.valueOf(value).trim();
        if (text.isEmpty() || "null".equalsIgnoreCase(text)) {
            return defaultValue;
        }
        return Integer.parseInt(text);
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> parseGuests(Object rawGuests) {
        List<Map<String, Object>> result = new ArrayList<>();
        if (!(rawGuests instanceof List)) {
            return result;
        }
        for (Object item : (List<Object>) rawGuests) {
            if (!(item instanceof Map)) {
                continue;
            }
            Map<String, Object> source = (Map<String, Object>) item;
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("guest_name", cleanString(source.get("guest_name")));
            row.put("id_card_no", cleanString(source.get("id_card_no")));
            row.put("phone", cleanString(source.get("phone")));
            row.put("is_primary", parseBoolean(source.get("is_primary")) ? 1 : 0);
            if (StringUtils.isBlank((String) row.get("guest_name"))
                    && StringUtils.isBlank((String) row.get("id_card_no"))
                    && StringUtils.isBlank((String) row.get("phone"))) {
                continue;
            }
            result.add(row);
        }
        return result;
    }

    private String cleanString(Object value) {
        String text = value == null ? null : String.valueOf(value).trim();
        return StringUtils.isBlank(text) || "null".equalsIgnoreCase(text) ? null : text;
    }

    private boolean parseBoolean(Object value) {
        if (value == null) {
            return false;
        }
        if (value instanceof Boolean) {
            return (Boolean) value;
        }
        if (value instanceof Number) {
            return ((Number) value).intValue() == 1;
        }
        String text = String.valueOf(value).trim();
        return "1".equals(text) || "true".equalsIgnoreCase(text) || "yes".equalsIgnoreCase(text);
    }

    private List<Long> findAvailableRoomIds(Long roomCatalogId, java.util.Date startDate, java.util.Date endDate, int quantity, Long excludeBookingId) {
        String sql =
                "SELECT ri.id " +
                        "FROM room_instance ri " +
                        "WHERE ri.room_catalog_id=? " +
                        "  AND ri.status IN ('available','reserved') " +
                        "  AND NOT EXISTS ( " +
                        "      SELECT 1 FROM booking_room br " +
                        "      JOIN booking_order bo ON bo.id=br.booking_id " +
                        "      WHERE br.room_id=ri.id " +
                        "        AND br.room_status IN ('reserved','checked_in') " +
                        "        AND bo.booking_status NOT IN ('cancelled','completed') " +
                        "        AND (? IS NULL OR bo.id<>?) " +
                        "        AND br.stay_start_date < ? " +
                        "        AND br.stay_end_date > ? " +
                        "  ) " +
                        "  AND NOT EXISTS ( " +
                        "      SELECT 1 FROM checkin_record cr " +
                        "      WHERE cr.room_id=ri.id AND cr.status='checked_in' " +
                        "  ) " +
                        "ORDER BY ri.room_no ASC " +
                        "LIMIT ?";
        return jdbcTemplate.query(
                sql,
                (rs, rowNum) -> rs.getLong(1),
                roomCatalogId,
                excludeBookingId, excludeBookingId,
                new Date(endDate.getTime()),
                new Date(startDate.getTime()),
                quantity
        );
    }

    private void releaseRoomIfFree(Long roomId) {
        Integer activeBookingCount = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM booking_room br " +
                        "JOIN booking_order bo ON bo.id=br.booking_id " +
                        "WHERE br.room_id=? AND br.room_status IN ('reserved','checked_in') " +
                        "AND bo.booking_status NOT IN ('cancelled','completed')",
                Integer.class,
                roomId
        );
        Integer activeCheckinCount = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM checkin_record WHERE room_id=? AND status='checked_in'",
                Integer.class,
                roomId
        );
        if ((activeBookingCount == null || activeBookingCount == 0)
                && (activeCheckinCount == null || activeCheckinCount == 0)) {
            jdbcTemplate.update("UPDATE room_instance SET status='available', updated_at=NOW() WHERE id=?", roomId);
        }
    }

    private void reserveRooms(List<Long> roomIds) {
        for (Long roomId : roomIds) {
            jdbcTemplate.update("UPDATE room_instance SET status='reserved', updated_at=NOW() WHERE id=?", roomId);
        }
    }

    private void touchBookingRooms(Long bookingId) {
        jdbcTemplate.update(
                "UPDATE room_instance ri " +
                        "JOIN booking_room br ON br.room_id=ri.id " +
                        "SET ri.updated_at=NOW() " +
                        "WHERE br.booking_id=?",
                bookingId
        );
    }

    private Long ensureBill(Long bookingId) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT id FROM bill WHERE booking_id=? ORDER BY id DESC LIMIT 1",
                bookingId
        );
        if (!rows.isEmpty()) {
            return ((Number) rows.get(0).get("id")).longValue();
        }
        Map<String, Object> booking = jdbcTemplate.queryForMap(
                "SELECT id, customer_id, zongjine FROM booking_order WHERE id=?",
                bookingId
        );
        BigDecimal roomAmount = new BigDecimal(String.valueOf(booking.get("zongjine") == null ? "0" : booking.get("zongjine")));
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO bill (booking_id, checkin_id, customer_id, room_amount, service_amount, discount_amount, payable_amount, paid_amount, refund_amount, status, created_at, updated_at) " +
                            "VALUES (?, NULL, ?, ?, 0, 0, ?, 0, 0, 'unpaid', NOW(), NOW())",
                    Statement.RETURN_GENERATED_KEYS
            );
            statement.setLong(1, bookingId);
            statement.setObject(2, booking.get("customer_id"));
            statement.setBigDecimal(3, roomAmount);
            statement.setBigDecimal(4, roomAmount);
            return statement;
        }, keyHolder);
        Number key = keyHolder.getKey();
        return key == null ? null : key.longValue();
    }

    private Map<String, Object> billSummary(Long bookingId) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT * FROM v_bill_payment_summary WHERE booking_id=? ORDER BY bill_id DESC LIMIT 1",
                bookingId
        );
        return rows.isEmpty() ? null : rows.get(0);
    }

    private BigDecimal refundedAmount(Long billId) {
        BigDecimal value = jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(refund_amount),0) FROM refund_record WHERE payment_id IN (SELECT id FROM payment_record WHERE bill_id=?) AND refund_status='success'",
                BigDecimal.class,
                billId
        );
        return value == null ? BigDecimal.ZERO : value;
    }

    private void insertBookingStatusLog(Long bookingId, String oldStatus, String newStatus, Long operatorId, String remark) {
        jdbcTemplate.update(
                "INSERT INTO booking_status_log (booking_id, old_status, new_status, operator_id, remark, created_at) VALUES (?,?,?,?,?,NOW())",
                bookingId, oldStatus, newStatus, operatorId, remark
        );
    }

    private void insertOperationLog(String operatorType, Long operatorId, String action, Long bookingId, String remark) {
        jdbcTemplate.update(
                "INSERT INTO operation_log (operator_type, operator_id, business_type, business_id, action, remark, created_at) VALUES (?,?,?,?,?,?,NOW())",
                operatorType, operatorId, "booking_order", bookingId, action, remark
        );
    }

    private void replaceBookingGuests(Long bookingId, List<Map<String, Object>> guests, Map<String, Object> customer) {
        List<Map<String, Object>> normalized = new ArrayList<>();
        boolean hasPrimary = false;
        for (Map<String, Object> row : guests) {
            String guestName = cleanString(row.get("guest_name"));
            String idCardNo = cleanString(row.get("id_card_no"));
            String phone = cleanString(row.get("phone"));
            boolean primary = parseBoolean(row.get("is_primary"));
            if (StringUtils.isBlank(guestName) && StringUtils.isBlank(idCardNo) && StringUtils.isBlank(phone)) {
                continue;
            }
            Map<String, Object> cleanRow = new LinkedHashMap<>();
            cleanRow.put("guest_name", StringUtils.defaultIfBlank(guestName, String.valueOf(customer.get("xingming"))));
            cleanRow.put("id_card_no", idCardNo);
            cleanRow.put("phone", StringUtils.defaultIfBlank(phone, String.valueOf(customer.get("shoujihao"))));
            cleanRow.put("is_primary", primary ? 1 : 0);
            normalized.add(cleanRow);
            if (primary) {
                hasPrimary = true;
            }
        }

        if (normalized.isEmpty()) {
            Map<String, Object> primaryGuest = new LinkedHashMap<>();
            primaryGuest.put("guest_name", String.valueOf(customer.get("xingming")));
            primaryGuest.put("id_card_no", null);
            primaryGuest.put("phone", String.valueOf(customer.get("shoujihao")));
            primaryGuest.put("is_primary", 1);
            normalized.add(primaryGuest);
        } else if (!hasPrimary) {
            Map<String, Object> primaryGuest = new LinkedHashMap<>();
            primaryGuest.put("guest_name", String.valueOf(customer.get("xingming")));
            primaryGuest.put("id_card_no", null);
            primaryGuest.put("phone", String.valueOf(customer.get("shoujihao")));
            primaryGuest.put("is_primary", 1);
            normalized.add(0, primaryGuest);
        }

        jdbcTemplate.update("DELETE FROM booking_guest WHERE booking_id=?", bookingId);
        for (Map<String, Object> row : normalized) {
            jdbcTemplate.update(
                    "INSERT INTO booking_guest (booking_id, guest_name, id_card_no, phone, is_primary, created_at, updated_at) VALUES (?,?,?,?,?,NOW(),NOW())",
                    bookingId,
                    row.get("guest_name"),
                    row.get("id_card_no"),
                    row.get("phone"),
                    row.get("is_primary")
            );
        }
    }

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, KefangyudingEntity bookingOrder, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        if (isCustomer(request)) {
            bookingOrder.setCustomerming(currentUsername(request));
        }
        EntityWrapper<KefangyudingEntity> ew = new EntityWrapper<>();
        PageUtils page = bookingOrderService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, bookingOrder), params), params));
        return R.ok().put("data", page);
    }

    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params, KefangyudingEntity bookingOrder, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        EntityWrapper<KefangyudingEntity> ew = new EntityWrapper<>();
        if (isCustomer(request)) {
            bookingOrder.setCustomerming(currentUsername(request));
        }
        PageUtils page = bookingOrderService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, bookingOrder), params), params));
        return R.ok().put("data", page);
    }

    @RequestMapping("/lists")
    public R lists(KefangyudingEntity bookingOrder) {
        EntityWrapper<KefangyudingEntity> ew = new EntityWrapper<>();
        ew.allEq(MPUtil.allEQMapPre(bookingOrder, "booking_order"));
        return R.ok().put("data", bookingOrderService.selectListView(ew));
    }

    @RequestMapping("/query")
    public R query(KefangyudingEntity bookingOrder) {
        EntityWrapper<KefangyudingEntity> ew = new EntityWrapper<>();
        ew.allEq(MPUtil.allEQMapPre(bookingOrder, "booking_order"));
        KefangyudingView bookingOrderView = bookingOrderService.selectView(ew);
        return R.ok("booking query success").put("data", bookingOrderView);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        KefangyudingEntity bookingOrder = bookingOrderService.selectById(id);
        if (!ownsBooking(bookingOrder, request)) {
            return R.error("can only view your own booking");
        }
        return R.ok().put("data", bookingOrder);
    }

    @RequestMapping("/detail/{id}")
    public R detail(@PathVariable("id") Long id, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        KefangyudingEntity bookingOrder = bookingOrderService.selectById(id);
        if (!ownsBooking(bookingOrder, request)) {
            return R.error("can only view your own booking");
        }
        return R.ok().put("data", bookingOrder);
    }

    @RequestMapping("/flow/{id}")
    public R flow(@PathVariable("id") Long id, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        KefangyudingEntity bookingOrder = bookingOrderService.selectById(id);
        if (!ownsBooking(bookingOrder, request)) {
            return R.error("can only view your own booking");
        }
        return R.ok().put("data", bookingFlowQueryService.getBookingFlow(id, null));
    }

    @RequestMapping("/billSummary/{id}")
    public R billSummary(@PathVariable("id") Long id, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        KefangyudingEntity bookingOrder = bookingOrderService.selectById(id);
        if (!ownsBooking(bookingOrder, request)) {
            return R.error("can only view your own booking");
        }
        return R.ok().put("data", billSummary(id));
    }

    @RequestMapping("/guests/{id}")
    public R guests(@PathVariable("id") Long id, HttpServletRequest request) {
        KefangyudingEntity bookingOrder = bookingOrderService.selectById(id);
        if (!ownsBooking(bookingOrder, request)) {
            return R.error("can only view your own booking");
        }
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT id, booking_id, guest_name, id_card_no, phone, is_primary, created_at, updated_at " +
                        "FROM booking_guest WHERE booking_id=? ORDER BY is_primary DESC, id ASC",
                id
        );
        return R.ok().put("data", rows);
    }

    @Transactional
    @RequestMapping("/guests/save/{id}")
    public R saveGuests(@PathVariable("id") Long id, @RequestBody Map<String, Object> payload, HttpServletRequest request) {
        KefangyudingEntity bookingOrder = bookingOrderService.selectById(id);
        if (bookingOrder == null) {
            return R.error("booking not found");
        }
        if (!ownsBooking(bookingOrder, request)) {
            return R.error("can only manage your own booking guests");
        }
        if ("cancelled".equals(bookingOrder.getBooking_status()) || "completed".equals(bookingOrder.getBooking_status())) {
            return R.error("current booking status does not allow guest updates");
        }
        Map<String, Object> customer = loadCustomer(bookingOrder.getCustomer_id());
        if (customer == null) {
            return R.error("booking customer not found");
        }
        replaceBookingGuests(id, parseGuests(payload.get("guests")), customer);
        insertOperationLog(isCustomer(request) ? "customer" : "admin", currentUserId(request), "update_booking_guests", id, bookingOrder.getYudingbianhao());
        return R.ok("booking guests updated").put("data", bookingFlowQueryService.getBookingFlow(id, null));
    }

    @Transactional
    @RequestMapping("/save")
    public R save(@RequestBody Map<String, Object> payload, HttpServletRequest request) {
        return add(payload, request);
    }

    @Transactional
    @RequestMapping("/add")
    public R add(@RequestBody Map<String, Object> payload, HttpServletRequest request) {
        if (!isCustomer(request)) {
            return R.error(401, "please log in as a customer first");
        }
        Long customerId = currentUserId(request);
        Map<String, Object> customer = loadCustomer(customerId);
        if (customer == null) {
            return R.error("current customer not found");
        }

        Long roomCatalogId = parseLong(payload.get("room_catalog_id"));
        if (roomCatalogId == null) {
            return R.error("missing room info");
        }
        Map<String, Object> roomCatalog = loadRoomCatalog(roomCatalogId);
        if (roomCatalog == null) {
            return R.error("room not found");
        }

        java.util.Date startDate = parseDateValue(payload.get("expected_checkin_date"));
        java.util.Date endDate = parseDateValue(payload.get("expected_checkout_date"));
        if (startDate == null || endDate == null) {
            return R.error("select expected check-in and check-out dates");
        }
        if (!endDate.after(startDate)) {
            return R.error("check-out date must be after check-in date");
        }

        int requestedQuantity = parseInt(payload.get("shuliang"), 1);
        if (requestedQuantity < 1) {
            requestedQuantity = 1;
        }
        final int quantity = requestedQuantity;
        List<Long> roomIds = findAvailableRoomIds(roomCatalogId, startDate, endDate, quantity, null);
        if (roomIds.size() < quantity) {
            return R.error("insufficient available rooms for the selected dates");
        }

        BigDecimal unitPrice = new BigDecimal(String.valueOf(roomCatalog.get("kefangjiage")));
        BigDecimal totalAmount = unitPrice.multiply(BigDecimal.valueOf(quantity));
        KeyHolder keyHolder = new GeneratedKeyHolder();
        String bookingNo = generateBookingNo();

        jdbcTemplate.update(connection -> {
            PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO booking_order (" +
                            "yudingbianhao, kefangmingcheng, room_category, kefangjiage, shuliang, zongjine, " +
                            "kefangtupian, jiudianmingcheng, jiudiandizhi, customerming, xingming, shoujihao, " +
                            "yudingriqi, ispay, customer_id, room_catalog_id, expected_checkin_date, expected_checkout_date, booking_status, room_instance_id" +
                            ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                    Statement.RETURN_GENERATED_KEYS
            );
            statement.setString(1, bookingNo);
            statement.setString(2, String.valueOf(roomCatalog.get("kefangmingcheng")));
            statement.setString(3, String.valueOf(roomCatalog.get("room_category")));
            statement.setBigDecimal(4, unitPrice);
            statement.setInt(5, quantity);
            statement.setBigDecimal(6, totalAmount);
            statement.setString(7, String.valueOf(roomCatalog.get("kefangtupian")));
            statement.setString(8, String.valueOf(roomCatalog.get("jiudianmingcheng")));
            statement.setString(9, String.valueOf(roomCatalog.get("jiudiandizhi")));
            statement.setString(10, String.valueOf(customer.get("customerming")));
            statement.setString(11, String.valueOf(customer.get("xingming")));
            statement.setString(12, String.valueOf(customer.get("shoujihao")));
            statement.setDate(13, new Date(startDate.getTime()));
            statement.setString(14, "unpaid");
            statement.setLong(15, customerId);
            statement.setLong(16, roomCatalogId);
            statement.setDate(17, new Date(startDate.getTime()));
            statement.setDate(18, new Date(endDate.getTime()));
            statement.setString(19, "created");
            statement.setLong(20, roomIds.get(0));
            return statement;
        }, keyHolder);

        Number key = keyHolder.getKey();
        if (key == null) {
            return R.error("booking creation failed");
        }
        Long bookingId = key.longValue();

        for (Long roomId : roomIds) {
            jdbcTemplate.update(
                    "INSERT INTO booking_room (booking_id, room_id, room_price, stay_start_date, stay_end_date, room_status, created_at) VALUES (?,?,?,?,?,'reserved',NOW())",
                    bookingId, roomId, unitPrice, new Date(startDate.getTime()), new Date(endDate.getTime())
            );
        }
        reserveRooms(roomIds);
        replaceBookingGuests(bookingId, parseGuests(payload.get("guests")), customer);
        ensureBill(bookingId);
        insertBookingStatusLog(bookingId, null, "created", customerId, "customer submitted booking from front desk");
        insertOperationLog("customer", customerId, "create_booking", bookingId, bookingNo);

        return R.ok("booking submitted")
                .put("data", bookingOrderService.selectById(bookingId))
                .put("flow", bookingFlowQueryService.getBookingFlow(bookingId, null));
    }

    @RequestMapping("/update")
    public R update(@RequestBody KefangyudingEntity bookingOrder, HttpServletRequest request) {
        KefangyudingEntity current = bookingOrderService.selectById(bookingOrder.getId());
        if (!ownsBooking(current, request)) {
            return R.error("can only update your own booking");
        }
        bookingOrderService.updateById(bookingOrder);
        return R.ok();
    }

    @Transactional
    @RequestMapping("/pay/{id}")
    public R pay(@PathVariable("id") Long id,
                 @RequestParam(value = "payMethod", required = false) String payMethod,
                 HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        KefangyudingEntity bookingOrder = bookingOrderService.selectById(id);
        if (bookingOrder == null) {
            return R.error("booking not found");
        }
        if (!ownsBooking(bookingOrder, request)) {
            return R.error("can only pay your own booking");
        }
        if ("paid".equals(bookingOrder.getIspay())) {
            return R.ok("booking already paid")
                    .put("data", bookingOrder)
                    .put("bill", billSummary(id))
                    .put("flow", bookingFlowQueryService.getBookingFlow(id, null));
        }
        if ("cancelled".equals(bookingOrder.getBooking_status())) {
            return R.error("booking is already cancelled or expired");
        }

        Long billId = ensureBill(id);
        Map<String, Object> billRow = jdbcTemplate.queryForMap(
                "SELECT payable_amount, paid_amount FROM bill WHERE id=?",
                billId
        );
        BigDecimal payable = new BigDecimal(String.valueOf(billRow.get("payable_amount")));
        BigDecimal paid = new BigDecimal(String.valueOf(billRow.get("paid_amount")));
        BigDecimal payAmount = payable.subtract(paid);
        if (payAmount.compareTo(BigDecimal.ZERO) <= 0) {
            payAmount = payable;
        }

        String paymentNo = "PAY" + new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()) + String.format("%04d", billId);
        jdbcTemplate.update(
                "INSERT INTO payment_record (bill_id, payment_no, pay_method, pay_amount, pay_status, paid_at, remark) VALUES (?,?,?,?, 'success', NOW(), ?)",
                billId, paymentNo, StringUtils.defaultIfBlank(payMethod, "wechat"), payAmount, "customer paid booking in front"
        );
        jdbcTemplate.update(
                "UPDATE bill SET paid_amount = paid_amount + ?, status = CASE WHEN paid_amount + ? >= payable_amount THEN 'paid' ELSE 'partial' END, updated_at = NOW() WHERE id=?",
                payAmount, payAmount, billId
        );
        jdbcTemplate.update("UPDATE booking_order SET ispay='paid' WHERE id=?", id);
        touchBookingRooms(id);

        Long operatorId = currentUserId(request);
        insertOperationLog(isCustomer(request) ? "customer" : "admin", operatorId, "pay_booking", id, paymentNo);

        return R.ok("payment successful")
                .put("data", bookingOrderService.selectById(id))
                .put("bill", billSummary(id))
                .put("flow", bookingFlowQueryService.getBookingFlow(id, null));
    }

    @Transactional
    @RequestMapping("/cancel/{id}")
    public R cancel(@PathVariable("id") Long id, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        KefangyudingEntity bookingOrder = bookingOrderService.selectById(id);
        if (bookingOrder == null) {
            return R.error("booking not found");
        }
        if (!ownsBooking(bookingOrder, request)) {
            return R.error("can only cancel your own booking");
        }
        if ("checked_in".equals(bookingOrder.getBooking_status()) || "completed".equals(bookingOrder.getBooking_status())) {
            return R.error("current booking cannot be cancelled");
        }

        List<Long> roomIds = jdbcTemplate.query(
                "SELECT room_id FROM booking_room WHERE booking_id=?",
                (rs, rowNum) -> rs.getLong(1),
                id
        );
        jdbcTemplate.update("UPDATE booking_order SET booking_status='cancelled' WHERE id=?", id);
        jdbcTemplate.update("UPDATE booking_room SET room_status='cancelled' WHERE booking_id=?", id);
        for (Long roomId : roomIds) {
            releaseRoomIfFree(roomId);
        }
        insertBookingStatusLog(id, bookingOrder.getBooking_status(), "cancelled", currentUserId(request), "customer cancelled booking in front");
        insertOperationLog(isCustomer(request) ? "customer" : "admin", currentUserId(request), "cancel_booking", id, bookingOrder.getYudingbianhao());
        return R.ok("booking cancelled")
                .put("data", bookingOrderService.selectById(id))
                .put("flow", bookingFlowQueryService.getBookingFlow(id, null));
    }

    @Transactional
    @RequestMapping("/reschedule/{id}")
    public R reschedule(@PathVariable("id") Long id, @RequestBody Map<String, Object> payload, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        KefangyudingEntity bookingOrder = bookingOrderService.selectById(id);
        if (bookingOrder == null) {
            return R.error("booking not found");
        }
        if (!ownsBooking(bookingOrder, request)) {
            return R.error("can only reschedule your own booking");
        }
        if ("checked_in".equals(bookingOrder.getBooking_status())
                || "completed".equals(bookingOrder.getBooking_status())
                || "cancelled".equals(bookingOrder.getBooking_status())) {
            return R.error("current booking cannot be rescheduled");
        }
        if (!"paid".equals(bookingOrder.getIspay())) {
            return R.error("complete payment before rescheduling");
        }

        java.util.Date startDate = parseDateValue(payload.get("expected_checkin_date"));
        java.util.Date endDate = parseDateValue(payload.get("expected_checkout_date"));
        if (startDate == null || endDate == null) {
            return R.error("select new check-in and check-out dates");
        }
        if (!endDate.after(startDate)) {
            return R.error("check-out date must be after check-in date");
        }

        int quantity = bookingOrder.getShuliang() == null || bookingOrder.getShuliang() < 1 ? 1 : bookingOrder.getShuliang();
        List<Long> oldRoomIds = jdbcTemplate.query(
                "SELECT room_id FROM booking_room WHERE booking_id=?",
                (rs, rowNum) -> rs.getLong(1),
                id
        );
        List<Long> newRoomIds = findAvailableRoomIds(bookingOrder.getRoom_catalog_id(), startDate, endDate, quantity, id);
        if (newRoomIds.size() < quantity) {
            return R.error("insufficient rooms for the new dates");
        }

        jdbcTemplate.update(
                "UPDATE booking_order SET expected_checkin_date=?, expected_checkout_date=?, yudingriqi=?, room_instance_id=? WHERE id=?",
                new Date(startDate.getTime()), new Date(endDate.getTime()), new Date(startDate.getTime()), newRoomIds.get(0), id
        );
        jdbcTemplate.update("DELETE FROM booking_room WHERE booking_id=?", id);
        for (Long roomId : newRoomIds) {
            jdbcTemplate.update(
                    "INSERT INTO booking_room (booking_id, room_id, room_price, stay_start_date, stay_end_date, room_status, created_at) VALUES (?,?,?,?,?,'reserved',NOW())",
                    id, roomId, bookingOrder.getKefangjiage(), new Date(startDate.getTime()), new Date(endDate.getTime())
            );
        }
        reserveRooms(newRoomIds);
        for (Long roomId : oldRoomIds) {
            releaseRoomIfFree(roomId);
        }
        insertOperationLog(isCustomer(request) ? "customer" : "admin", currentUserId(request), "reschedule_booking", id, bookingOrder.getYudingbianhao());
        return R.ok("booking rescheduled")
                .put("data", bookingOrderService.selectById(id))
                .put("flow", bookingFlowQueryService.getBookingFlow(id, null));
    }

    @Transactional
    @RequestMapping("/refund/{id}")
    public R refund(@PathVariable("id") Long id, @RequestBody(required = false) Map<String, Object> payload, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        KefangyudingEntity bookingOrder = bookingOrderService.selectById(id);
        if (bookingOrder == null) {
            return R.error("booking not found");
        }
        if (!ownsBooking(bookingOrder, request)) {
            return R.error("can only handle your own booking");
        }
        if (!"paid".equals(bookingOrder.getIspay())) {
            return R.error("refund is only available for paid bookings");
        }
        if ("checked_in".equals(bookingOrder.getBooking_status()) || "completed".equals(bookingOrder.getBooking_status())) {
            return R.error("current booking status does not support refund");
        }

        Long billId = ensureBill(id);
        Map<String, Object> billRow = jdbcTemplate.queryForMap(
                "SELECT id, paid_amount FROM bill WHERE id=?",
                billId
        );
        BigDecimal paidAmount = new BigDecimal(String.valueOf(billRow.get("paid_amount") == null ? "0" : billRow.get("paid_amount")));
        BigDecimal refundAmount = paidAmount.subtract(refundedAmount(billId));
        if (refundAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return R.error("no refundable amount is available");
        }

        List<Map<String, Object>> paymentRows = jdbcTemplate.queryForList(
                "SELECT id, payment_no FROM payment_record WHERE bill_id=? AND pay_status='success' ORDER BY paid_at DESC, id DESC LIMIT 1",
                billId
        );
        if (paymentRows.isEmpty()) {
            return R.error("payment record for refund was not found");
        }
        Long paymentId = ((Number) paymentRows.get(0).get("id")).longValue();
        String refundReason = payload == null ? null : cleanString(payload.get("reason"));
        if (StringUtils.isBlank(refundReason)) {
            refundReason = "customer requested a refund before check-in";
        }
        String refundNo = "RF" + new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()) + String.format("%04d", billId);
        jdbcTemplate.update(
                "INSERT INTO refund_record (payment_id, refund_no, refund_amount, refund_reason, refund_status, created_at) VALUES (?,?,?,?, 'success', NOW())",
                paymentId, refundNo, refundAmount, refundReason
        );
        jdbcTemplate.update("UPDATE booking_order SET ispay='refunded', booking_status='cancelled' WHERE id=?", id);
        insertBookingStatusLog(id, bookingOrder.getBooking_status(), "cancelled", currentUserId(request), "customer refund cancelled booking");
        insertOperationLog(isCustomer(request) ? "customer" : "admin", currentUserId(request), "refund_booking", id, refundNo);

        return R.ok("refund successful")
                .put("data", bookingOrderService.selectById(id))
                .put("bill", billSummary(id))
                .put("flow", bookingFlowQueryService.getBookingFlow(id, null));
    }
    @RequestMapping("/delete")
    public R delete(@RequestBody Long[] ids) {
        bookingOrderService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    @RequestMapping("/remind/{columnName}/{type}")
    public R remindCount(@PathVariable("columnName") String columnName,
                         HttpServletRequest request,
                         @PathVariable("type") String type,
                         @RequestParam Map<String, Object> map) {
        map.put("column", columnName);
        map.put("type", type);

        if ("2".equals(type)) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Calendar c = Calendar.getInstance();
            if (map.get("remindstart") != null) {
                Integer remindStart = Integer.parseInt(map.get("remindstart").toString());
                c.setTime(new java.util.Date());
                c.add(Calendar.DAY_OF_MONTH, remindStart);
                map.put("remindstart", sdf.format(c.getTime()));
            }
            if (map.get("remindend") != null) {
                Integer remindEnd = Integer.parseInt(map.get("remindend").toString());
                c.setTime(new java.util.Date());
                c.add(Calendar.DAY_OF_MONTH, remindEnd);
                map.put("remindend", sdf.format(c.getTime()));
            }
        }

        Wrapper<KefangyudingEntity> wrapper = new EntityWrapper<>();
        if (map.get("remindstart") != null) {
            wrapper.ge(columnName, map.get("remindstart"));
        }
        if (map.get("remindend") != null) {
            wrapper.le(columnName, map.get("remindend"));
        }
        if (isCustomer(request)) {
            wrapper.eq("customerming", currentUsername(request));
        }

        int count = bookingOrderService.selectCount(wrapper);
        return R.ok().put("count", count);
    }
}
