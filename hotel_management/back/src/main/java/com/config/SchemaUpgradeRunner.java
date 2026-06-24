package com.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class SchemaUpgradeRunner implements ApplicationRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) {
        ensureBookingGuestTable();
        ensureReviewScoreColumn("room_review");
        ensureReviewScoreColumn("hotel_review");
        backfillBookingGuests();
        syncRoomUpdateTimesFromPayments();
        ensureSearchAvailableRoomsProcedure();
        ensureBatchUpdateRoomStatusProcedure();
        ensureEmployeePerformanceReportProcedure();
    }

    private void ensureBookingGuestTable() {
        jdbcTemplate.execute(
                "CREATE TABLE IF NOT EXISTS `booking_guest` (" +
                        "`id` bigint NOT NULL AUTO_INCREMENT," +
                        "`booking_id` bigint NOT NULL," +
                        "`guest_name` varchar(100) NOT NULL," +
                        "`id_card_no` varchar(30) DEFAULT NULL," +
                        "`phone` varchar(30) DEFAULT NULL," +
                        "`is_primary` tinyint(1) NOT NULL DEFAULT 0," +
                        "`created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP," +
                        "`updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
                        "PRIMARY KEY (`id`)," +
                        "KEY `idx_booking_guest_booking` (`booking_id`)," +
                        "CONSTRAINT `fk_booking_guest_booking` FOREIGN KEY (`booking_id`) REFERENCES `booking_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE" +
                        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
        );
    }

    private void ensureReviewScoreColumn(String tableName) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM information_schema.COLUMNS " +
                        "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = 'score'",
                Integer.class,
                tableName
        );
        if (count == null || count == 0) {
            jdbcTemplate.execute("ALTER TABLE `" + tableName + "` ADD COLUMN `score` int DEFAULT 5");
        }
        jdbcTemplate.update("UPDATE `" + tableName + "` SET `score` = 5 WHERE `score` IS NULL");
    }

    private void backfillBookingGuests() {
        jdbcTemplate.update(
                "INSERT INTO `booking_guest` (`booking_id`, `guest_name`, `id_card_no`, `phone`, `is_primary`) " +
                        "SELECT bo.id, COALESCE(NULLIF(bo.xingming,''), bo.customerming), NULL, bo.shoujihao, 1 " +
                        "FROM `booking_order` bo " +
                        "WHERE NOT EXISTS (" +
                        "  SELECT 1 FROM `booking_guest` bg WHERE bg.booking_id = bo.id AND bg.is_primary = 1" +
                        ")"
        );
    }

    private void syncRoomUpdateTimesFromPayments() {
        jdbcTemplate.update(
                "UPDATE `room_instance` ri " +
                        "JOIN `booking_room` br ON br.`room_id` = ri.`id` " +
                        "JOIN `bill` b ON b.`booking_id` = br.`booking_id` " +
                        "JOIN (" +
                        "  SELECT `bill_id`, MAX(`paid_at`) AS `last_paid_at` " +
                        "  FROM `payment_record` " +
                        "  WHERE `pay_status` = 'success' " +
                        "  GROUP BY `bill_id`" +
                        ") pr ON pr.`bill_id` = b.`id` " +
                        "SET ri.`updated_at` = pr.`last_paid_at` " +
                        "WHERE pr.`last_paid_at` IS NOT NULL " +
                        "AND ri.`updated_at` < pr.`last_paid_at`"
        );
    }

    private void ensureEmployeePerformanceReportProcedure() {
        jdbcTemplate.execute("DROP PROCEDURE IF EXISTS `sp_employee_performance_report`");
        jdbcTemplate.execute(
                "CREATE PROCEDURE `sp_employee_performance_report`(IN p_employee_id bigint, IN p_start_date date, IN p_end_date date) " +
                        "BEGIN " +
                        "DECLARE v_start date; " +
                        "DECLARE v_end date; " +
                        "SET v_start=IFNULL(p_start_date,'2000-01-01'); " +
                        "SET v_end=IFNULL(p_end_date,CURDATE()); " +
                        "SELECT e.id AS employee_id, e.employeegonghao AS employee_no, e.employeexingming AS employee_name, " +
                        "       COALESCE(cr.checkin_count,0) AS checkin_count, " +
                        "       COALESCE(bp.bill_count,0) AS bill_count, " +
                        "       COALESCE(bp.payment_count,0) AS payment_count, " +
                        "       COALESCE(ht.cleaning_count,0) AS cleaning_count, " +
                        "       COALESCE(mr.maintenance_count,0) AS maintenance_count, " +
                        "       COALESCE(bp.handled_payment_amount,0) AS handled_payment_amount, " +
                        "       COALESCE(ol.operation_count,0) AS operation_count, " +
                        "       ep.latest_assessment_score AS latest_assessment_score, " +
                        "       ep.latest_assessment_grade AS latest_assessment_grade, " +
                        "       COALESCE(ol.confirm_checkin_actions,0) AS confirm_checkin_actions, " +
                        "       COALESCE(ol.checkout_actions,0) AS checkout_actions, " +
                        "       COALESCE(ol.payment_actions,0) AS payment_actions, " +
                        "       ol.last_operation_time AS last_operation_time " +
                        "FROM `employee` e " +
                        "LEFT JOIN ( " +
                        "  SELECT employee_id, COUNT(DISTINCT id) AS checkin_count " +
                        "  FROM `checkin_record` " +
                        "  WHERE DATE(checkin_time) BETWEEN v_start AND v_end " +
                        "  GROUP BY employee_id " +
                        ") cr ON cr.employee_id=e.id " +
                        "LEFT JOIN ( " +
                        "  SELECT cr2.employee_id, COUNT(DISTINCT b.id) AS bill_count, COUNT(DISTINCT pr.id) AS payment_count, " +
                        "         COALESCE(SUM(CASE WHEN pr.pay_status='success' THEN pr.pay_amount ELSE 0 END),0) AS handled_payment_amount " +
                        "  FROM `checkin_record` cr2 " +
                        "  LEFT JOIN `bill` b ON b.checkin_id=cr2.id " +
                        "  LEFT JOIN `payment_record` pr ON pr.bill_id=b.id " +
                        "  WHERE DATE(cr2.checkin_time) BETWEEN v_start AND v_end " +
                        "  GROUP BY cr2.employee_id " +
                        ") bp ON bp.employee_id=e.id " +
                        "LEFT JOIN ( " +
                        "  SELECT assigned_employee_id AS employee_id, COUNT(DISTINCT id) AS cleaning_count " +
                        "  FROM `housekeeping_task` " +
                        "  WHERE task_status='completed' AND completed_time IS NOT NULL AND DATE(completed_time) BETWEEN v_start AND v_end " +
                        "  GROUP BY assigned_employee_id " +
                        ") ht ON ht.employee_id=e.id " +
                        "LEFT JOIN ( " +
                        "  SELECT handled_by_employee_id AS employee_id, COUNT(DISTINCT id) AS maintenance_count " +
                        "  FROM `maintenance_record` " +
                        "  WHERE maintenance_status='completed' AND end_time IS NOT NULL AND DATE(end_time) BETWEEN v_start AND v_end " +
                        "  GROUP BY handled_by_employee_id " +
                        ") mr ON mr.employee_id=e.id " +
                        "LEFT JOIN ( " +
                        "  SELECT employee_id, MAX(total_score) AS latest_assessment_score, MAX(grade) AS latest_assessment_grade " +
                        "  FROM `employee_performance` " +
                        "  WHERE period_start>=v_start AND period_end<=v_end " +
                        "  GROUP BY employee_id " +
                        ") ep ON ep.employee_id=e.id " +
                        "LEFT JOIN ( " +
                        "  SELECT operator_id AS employee_id, COUNT(DISTINCT id) AS operation_count, " +
                        "         SUM(CASE WHEN action='confirm_checkin' THEN 1 ELSE 0 END) AS confirm_checkin_actions, " +
                        "         SUM(CASE WHEN action='generate_checkout_bill' THEN 1 ELSE 0 END) AS checkout_actions, " +
                        "         SUM(CASE WHEN action='pay_bill' THEN 1 ELSE 0 END) AS payment_actions, " +
                        "         MAX(created_at) AS last_operation_time " +
                        "  FROM `operation_log` " +
                        "  WHERE operator_type='employee' AND DATE(created_at) BETWEEN v_start AND v_end " +
                        "  GROUP BY operator_id " +
                        ") ol ON ol.employee_id=e.id " +
                        "WHERE p_employee_id IS NULL OR e.id=p_employee_id " +
                        "ORDER BY handled_payment_amount DESC, operation_count DESC; " +
                        "END"
        );
    }

    private void ensureSearchAvailableRoomsProcedure() {
        jdbcTemplate.execute("DROP PROCEDURE IF EXISTS `sp_search_available_rooms`");
        jdbcTemplate.execute(
                "CREATE PROCEDURE `sp_search_available_rooms`(IN p_room_category varchar(200), IN p_start_date date, IN p_end_date date, IN p_min_price decimal(10,2), IN p_max_price decimal(10,2)) " +
                        "BEGIN " +
                        "DECLARE v_start date; " +
                        "DECLARE v_end date; " +
                        "SET v_start = IFNULL(p_start_date, CURDATE()); " +
                        "SET v_end = IFNULL(p_end_date, DATE_ADD(v_start, INTERVAL 1 DAY)); " +
                        "IF v_end <= v_start THEN " +
                        "  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'end date must be greater than start date'; " +
                        "END IF; " +
                        "SELECT ri.id AS room_id, ri.room_no, ri.floor_no, rc.id AS room_catalog_id, " +
                        "       rc.kefangmingcheng AS room_name, rc.room_category, rc.kefangjiage AS base_price, " +
                        "       ROUND(rc.kefangjiage * COALESCE(MAX(pp.price_multiplier),1),2) AS final_price, " +
                        "       rc.jiudianmingcheng AS hotel_name, rc.jiudiandizhi AS hotel_address " +
                        "FROM `room_instance` ri " +
                        "JOIN `room_catalog` rc ON rc.id=ri.room_catalog_id " +
                        "LEFT JOIN `price_policy` pp ON pp.room_catalog_id=rc.id AND pp.enabled=1 AND v_start BETWEEN pp.start_date AND pp.end_date " +
                        "WHERE ri.status=CONVERT('available' USING utf8mb4) COLLATE utf8mb4_0900_ai_ci " +
                        "  AND (p_room_category IS NULL OR TRIM(p_room_category)='' OR rc.room_category=CONVERT(p_room_category USING utf8mb4) COLLATE utf8mb4_0900_ai_ci) " +
                        "  AND (p_min_price IS NULL OR rc.kefangjiage>=p_min_price) " +
                        "  AND (p_max_price IS NULL OR p_max_price=0 OR rc.kefangjiage<=p_max_price) " +
                        "  AND NOT EXISTS ( " +
                        "      SELECT 1 " +
                        "      FROM `booking_room` br " +
                        "      JOIN `booking_order` bo ON bo.id=br.booking_id " +
                        "      WHERE br.room_id=ri.id " +
                        "        AND br.room_status IN ('reserved','checked_in') " +
                        "        AND bo.booking_status NOT IN ('cancelled','completed') " +
                        "        AND br.stay_start_date < v_end " +
                        "        AND br.stay_end_date > v_start " +
                        "  ) " +
                        "  AND NOT EXISTS ( " +
                        "      SELECT 1 " +
                        "      FROM `maintenance_record` mr " +
                        "      WHERE mr.room_id=ri.id AND mr.maintenance_status IN ('reported','processing') " +
                        "  ) " +
                        "GROUP BY ri.id, ri.room_no, ri.floor_no, rc.id, rc.kefangmingcheng, rc.room_category, rc.kefangjiage, rc.jiudianmingcheng, rc.jiudiandizhi " +
                        "ORDER BY final_price ASC, ri.room_no ASC; " +
                        "END"
        );
    }

    private void ensureBatchUpdateRoomStatusProcedure() {
        jdbcTemplate.execute("DROP PROCEDURE IF EXISTS `sp_batch_update_room_status`");
        jdbcTemplate.execute(
                "CREATE PROCEDURE `sp_batch_update_room_status`(IN p_room_category varchar(200), IN p_old_status varchar(30), IN p_new_status varchar(30), IN p_operator_id bigint, IN p_remark varchar(500)) " +
                        "BEGIN " +
                        "DECLARE v_changed_count int DEFAULT 0; " +
                        "IF p_new_status IS NULL OR TRIM(p_new_status)='' THEN " +
                        "  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'new status is required'; " +
                        "END IF; " +
                        "INSERT INTO `room_status_log`(`room_id`,`old_status`,`new_status`,`source_type`,`source_id`,`operator_id`,`remark`) " +
                        "SELECT ri.id, ri.status, p_new_status, 'batch_update', NULL, p_operator_id, p_remark " +
                        "FROM `room_instance` ri JOIN `room_catalog` rc ON rc.id=ri.room_catalog_id " +
                        "WHERE (p_room_category IS NULL OR TRIM(p_room_category)='' OR rc.room_category=CONVERT(p_room_category USING utf8mb4) COLLATE utf8mb4_0900_ai_ci) " +
                        "  AND (p_old_status IS NULL OR TRIM(p_old_status)='' OR ri.status=CONVERT(p_old_status USING utf8mb4) COLLATE utf8mb4_0900_ai_ci) " +
                        "  AND ri.status<>CONVERT(p_new_status USING utf8mb4) COLLATE utf8mb4_0900_ai_ci; " +
                        "SET v_changed_count = ROW_COUNT(); " +
                        "UPDATE `room_instance` ri JOIN `room_catalog` rc ON rc.id=ri.room_catalog_id " +
                        "   SET ri.status=p_new_status, ri.updated_at=NOW() " +
                        "WHERE (p_room_category IS NULL OR TRIM(p_room_category)='' OR rc.room_category=CONVERT(p_room_category USING utf8mb4) COLLATE utf8mb4_0900_ai_ci) " +
                        "  AND (p_old_status IS NULL OR TRIM(p_old_status)='' OR ri.status=CONVERT(p_old_status USING utf8mb4) COLLATE utf8mb4_0900_ai_ci) " +
                        "  AND ri.status<>CONVERT(p_new_status USING utf8mb4) COLLATE utf8mb4_0900_ai_ci; " +
                        "INSERT INTO `operation_log`(`operator_type`,`operator_id`,`business_type`,`business_id`,`action`,`remark`) " +
                        "VALUES('employee',p_operator_id,'room_instance',NULL,'batch_update_room_status',CONCAT('changed rooms: ',v_changed_count)); " +
                        "SELECT v_changed_count AS changed_count; " +
                        "END"
        );
    }
}
