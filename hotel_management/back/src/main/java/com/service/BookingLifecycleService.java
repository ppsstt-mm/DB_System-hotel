package com.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class BookingLifecycleService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public int expireUnpaidBookings() {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT id, yudingbianhao, booking_status, ispay " +
                        "FROM booking_order " +
                        "WHERE booking_status='created' AND ispay='unpaid' " +
                        "AND addtime <= DATE_SUB(NOW(), INTERVAL 3 MINUTE)"
        );
        int count = 0;
        for (Map<String, Object> row : rows) {
            Long bookingId = ((Number) row.get("id")).longValue();
            String bookingNo = row.get("yudingbianhao") == null ? null : String.valueOf(row.get("yudingbianhao"));
            jdbcTemplate.update(
                    "UPDATE booking_order SET booking_status='cancelled' WHERE id=? AND booking_status='created' AND ispay='unpaid'",
                    bookingId
            );
            jdbcTemplate.update(
                    "INSERT INTO operation_log (operator_type, operator_id, business_type, business_id, action, remark, created_at) " +
                            "VALUES ('system', NULL, 'booking_order', ?, 'expire_unpaid_booking', ?, NOW())",
                    bookingId,
                    bookingNo == null ? "3 minutes unpaid auto cancel" : ("3 minutes unpaid auto cancel: " + bookingNo)
            );
            count++;
        }
        return count;
    }

    @Scheduled(fixedDelay = 30000L, initialDelay = 30000L)
    public void scheduledExpireUnpaidBookings() {
        expireUnpaidBookings();
    }
}
