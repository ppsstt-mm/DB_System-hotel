package com.controller;

import com.utils.PageUtils;
import com.utils.R;
import com.service.BookingFlowQueryService;
import com.service.BookingLifecycleService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/ops")
public class OperationalController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private BookingFlowQueryService bookingFlowQueryService;

    @Autowired
    private BookingLifecycleService bookingLifecycleService;

    private static final Map<String, List<String>> TABLE_COLUMNS = new LinkedHashMap<>();
    private static final List<String> READONLY_OBJECTS = Arrays.asList(
            "v_room_inventory_overview", "v_room_daily_status", "v_booking_detail",
            "v_checkin_guest_detail", "v_bill_payment_summary", "v_monthly_revenue_report",
            "v_employee_operation_summary", "v_customer_value_profile",
            "v_housekeeping_task_detail", "v_employee_performance_detail"
    );

    static {
        TABLE_COLUMNS.put("system_config", Arrays.asList("id", "name", "value"));
        TABLE_COLUMNS.put("hotel_profile", Arrays.asList("id", "addtime", "jiudianmingcheng", "leibie", "xingji", "jiudiantupian", "jiudiandizhi", "fuwurexian", "jiudianjieshao", "review_count", "avg_score"));
        TABLE_COLUMNS.put("notice", Arrays.asList("id", "addtime", "title", "introduction", "picture", "content"));
        TABLE_COLUMNS.put("customer", Arrays.asList("id", "addtime", "customerming", "xingming", "mima", "xingbie", "nianling", "shoujihao"));
        TABLE_COLUMNS.put("employee", Arrays.asList("id", "addtime", "employeegonghao", "employeexingming", "mima", "xingbie", "lianxidianhua", "touxiang", "ruzhishijian", "zhiwei"));
        TABLE_COLUMNS.put("room_category", Arrays.asList("id", "addtime", "room_category"));
        TABLE_COLUMNS.put("room_catalog", Arrays.asList("id", "addtime", "kefangmingcheng", "room_category", "kefangtupian", "kefangjiage", "shuliang", "jiudianmingcheng", "jiudiandizhi", "kefangsheshi", "kefangjieshao", "clicknum", "hotel_profile_id", "room_category_id", "review_count", "avg_score"));
        TABLE_COLUMNS.put("booking_order", Arrays.asList("id", "addtime", "yudingbianhao", "kefangmingcheng", "room_category", "kefangjiage", "shuliang", "zongjine", "kefangtupian", "jiudianmingcheng", "jiudiandizhi", "customerming", "xingming", "shoujihao", "yudingriqi", "ispay", "customer_id", "room_catalog_id", "expected_checkin_date", "expected_checkout_date", "booking_status", "room_instance_id"));
        TABLE_COLUMNS.put("checkin_assignment", Arrays.asList("id", "addtime", "yudingbianhao", "jiudianmingcheng", "fangjianleixing", "shuliang", "kefangtupian", "customerming", "xingming", "shoujihao", "fangjianhao", "crossuserid", "crossrefid"));
        TABLE_COLUMNS.put("hotel_review", Arrays.asList("id", "addtime", "refid", "userid", "nickname", "content", "reply", "score"));
        TABLE_COLUMNS.put("room_review", Arrays.asList("id", "addtime", "refid", "userid", "nickname", "content", "reply", "score"));
        TABLE_COLUMNS.put("room_instance", Arrays.asList("id", "room_catalog_id", "room_no", "floor_no", "status", "created_at", "updated_at"));
        TABLE_COLUMNS.put("price_policy", Arrays.asList("id", "room_catalog_id", "policy_name", "start_date", "end_date", "price_multiplier", "priority", "enabled"));
        TABLE_COLUMNS.put("operation_log", Arrays.asList("id", "operator_type", "operator_id", "business_type", "business_id", "action", "remark", "created_at"));
        TABLE_COLUMNS.put("room_status_log", Arrays.asList("id", "room_id", "old_status", "new_status", "source_type", "source_id", "operator_id", "remark", "created_at"));
        TABLE_COLUMNS.put("booking_status_log", Arrays.asList("id", "booking_id", "old_status", "new_status", "operator_id", "remark", "created_at"));
        TABLE_COLUMNS.put("booking_room", Arrays.asList("id", "booking_id", "room_id", "room_price", "stay_start_date", "stay_end_date", "room_status", "created_at"));
        TABLE_COLUMNS.put("booking_guest", Arrays.asList("id", "booking_id", "guest_name", "id_card_no", "phone", "is_primary", "created_at", "updated_at"));
        TABLE_COLUMNS.put("checkin_record", Arrays.asList("id", "booking_id", "room_id", "customer_id", "employee_id", "checkin_time", "checkout_time", "status", "remark"));
        TABLE_COLUMNS.put("checkin_guest", Arrays.asList("id", "checkin_id", "guest_name", "id_card_no", "phone", "is_primary", "created_at"));
        TABLE_COLUMNS.put("bill", Arrays.asList("id", "booking_id", "checkin_id", "customer_id", "room_amount", "service_amount", "discount_amount", "payable_amount", "paid_amount", "refund_amount", "status", "created_at", "updated_at"));
        TABLE_COLUMNS.put("payment_record", Arrays.asList("id", "bill_id", "payment_no", "pay_method", "pay_amount", "pay_status", "paid_at", "remark"));
        TABLE_COLUMNS.put("refund_record", Arrays.asList("id", "payment_id", "refund_no", "refund_amount", "refund_reason", "refund_status", "created_at"));
        TABLE_COLUMNS.put("favorite", Arrays.asList("id", "addtime", "userid", "refid", "tablename", "name", "picture", "type", "inteltype"));
        TABLE_COLUMNS.put("housekeeping_task", Arrays.asList("id", "room_id", "checkin_id", "assigned_employee_id", "task_type", "task_status", "scheduled_time", "completed_time", "remark", "created_at", "updated_at"));
        TABLE_COLUMNS.put("maintenance_record", Arrays.asList("id", "room_id", "reported_by_employee_id", "handled_by_employee_id", "issue_desc", "maintenance_status", "start_time", "end_time", "cost_amount", "remark"));
        TABLE_COLUMNS.put("employee_performance", Arrays.asList("id", "employee_id", "assessor_id", "period_start", "period_end", "checkin_count", "bill_count", "payment_count", "cleaning_count", "maintenance_count", "operation_count", "manager_score", "total_score", "grade", "remark", "created_at"));
    }

    @RequestMapping("/{tableName}/page")
    public R page(@PathVariable String tableName, @RequestParam Map<String, Object> params, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        String objectName = checkedObject(tableName);
        int page = intParam(params.get("page"), 1);
        int limit = intParam(params.get("limit"), 10);
        int offset = Math.max(0, (page - 1) * limit);
        QueryParts parts = buildWhere(objectName, params, request);
        String orderBy = buildOrderBy(objectName, params);
        Integer total = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM `" + objectName + "`" + parts.whereSql, parts.args.toArray(), Integer.class);
        List<Object> listArgs = new ArrayList<>(parts.args);
        listArgs.add(offset);
        listArgs.add(limit);
        List<Map<String, Object>> list = jdbcTemplate.queryForList("SELECT * FROM `" + objectName + "`" + parts.whereSql + orderBy + " LIMIT ?,?", listArgs.toArray());
        return R.ok().put("data", new PageUtils(list, total == null ? 0 : total, limit, page));
    }

    @RequestMapping("/{tableName}/list")
    public R list(@PathVariable String tableName, @RequestParam Map<String, Object> params, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        String objectName = checkedObject(tableName);
        QueryParts parts = buildWhere(objectName, params, request);
        String orderBy = buildOrderBy(objectName, params);
        return R.ok().put("data", jdbcTemplate.queryForList("SELECT * FROM `" + objectName + "`" + parts.whereSql + orderBy, parts.args.toArray()));
    }

    @RequestMapping("/{tableName}/info/{id}")
    public R info(@PathVariable String tableName, @PathVariable Long id, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        return one(tableName, id, request);
    }

    @RequestMapping("/{tableName}/detail/{id}")
    public R detail(@PathVariable String tableName, @PathVariable Long id, HttpServletRequest request) {
        bookingLifecycleService.expireUnpaidBookings();
        return one(tableName, id, request);
    }

    @RequestMapping("/{tableName}/save")
    public R save(@PathVariable String tableName, @RequestBody Map<String, Object> row, HttpServletRequest request) {
        return insert(tableName, row, request);
    }

    @RequestMapping("/{tableName}/add")
    public R add(@PathVariable String tableName, @RequestBody Map<String, Object> row, HttpServletRequest request) {
        return insert(tableName, row, request);
    }

    @RequestMapping("/{tableName}/update")
    public R update(@PathVariable String tableName, @RequestBody Map<String, Object> row, HttpServletRequest request) {
        String table = checkedTable(tableName);
        if ("checkin_record".equals(table)) {
            return updateCheckinRecord(row, request);
        }
        Object id = row.get("id");
        if (id == null || StringUtils.isBlank(String.valueOf(id))) {
            return R.error("missing primary key id");
        }
        List<String> columns = TABLE_COLUMNS.get(table);
        List<String> setColumns = columns.stream()
                .filter(column -> !"id".equals(column) && row.containsKey(column))
                .collect(Collectors.toList());
        if (setColumns.isEmpty()) {
            return R.ok();
        }
        List<Object> args = setColumns.stream().map(row::get).collect(Collectors.toList());
        args.add(id);
        String setSql = setColumns.stream().map(column -> "`" + column + "`=?").collect(Collectors.joining(","));
        jdbcTemplate.update("UPDATE `" + table + "` SET " + setSql + " WHERE `id`=?", args.toArray());
        return R.ok();
    }

    @RequestMapping("/{tableName}/delete")
    public R delete(@PathVariable String tableName, @RequestBody Long[] ids) {
        String table = checkedTable(tableName);
        if (ids == null || ids.length == 0) {
            return R.ok();
        }
        String placeholders = Arrays.stream(ids).map(id -> "?").collect(Collectors.joining(","));
        jdbcTemplate.update("DELETE FROM `" + table + "` WHERE `id` IN (" + placeholders + ")", (Object[]) ids);
        return R.ok();
    }

    @RequestMapping("/dbops/availableRooms")
    public R availableRooms(@RequestBody(required = false) Map<String, Object> params) {
        Object startDate = value(params, "startDate");
        Object endDate = value(params, "endDate");
        if (startDate == null || endDate == null) {
            return R.error(400, "可用房源检索需要选择入住日期和离店日期");
        }
        if (String.valueOf(endDate).compareTo(String.valueOf(startDate)) <= 0) {
            return R.error(400, "离店日期必须晚于入住日期");
        }
        Object minPrice = value(params, "minPrice");
        Object maxPrice = value(params, "maxPrice");
        BigDecimal min = toBigDecimal(minPrice);
        BigDecimal max = toBigDecimal(maxPrice);
        if ((minPrice != null && min == null) || (maxPrice != null && max == null)) {
            return R.error(400, "价格范围必须是数字");
        }
        if ((min != null && min.compareTo(BigDecimal.ZERO) < 0) || (max != null && max.compareTo(BigDecimal.ZERO) < 0)) {
            return R.error(400, "价格范围不能为负数");
        }
        if (min != null && max != null && max.compareTo(BigDecimal.ZERO) > 0 && max.compareTo(min) < 0) {
            return R.error(400, "最高价格不能低于最低价格");
        }
        return callProcedure(
                "CALL sp_search_available_rooms(?,?,?,?,?)",
                value(params, "roomCategory"), value(params, "startDate"), value(params, "endDate"),
                value(params, "minPrice"), value(params, "maxPrice"));
    }

    @RequestMapping("/dbops/createBooking")
    public R createBooking(@RequestBody(required = false) Map<String, Object> params) {
        Object customerId = value(params, "customerId");
        Object roomCatalogId = value(params, "roomCatalogId");
        Object quantity = value(params, "quantity");
        Object bookingDate = value(params, "bookingDate");
        Object operatorId = value(params, "operatorId");
        if (!customerExists(customerId)) {
            return R.error(400, "客户不存在，请填写有效客户ID，例如 4001");
        }
        if (!roomCatalogExists(roomCatalogId)) {
            return R.error(400, "客房目录不存在，请填写有效客房目录ID，例如 3002");
        }
        if (!isPositiveInteger(quantity)) {
            return R.error(400, "预订数量必须大于 0");
        }
        if (bookingDate == null) {
            return R.error(400, "创建预订需要填写预订日期");
        }
        if (!employeeExists(operatorId)) {
            return R.error(400, "操作人不存在，请填写有效员工ID，例如 5001");
        }
        return callProcedure(
                "CALL sp_create_booking_order(?,?,?,?,?)",
                customerId, roomCatalogId, quantity, bookingDate, operatorId);
    }

    @RequestMapping("/dbops/batchUpdateRoomStatus")
    public R batchUpdateRoomStatus(@RequestBody(required = false) Map<String, Object> params) {
        Object oldStatus = value(params, "oldStatus");
        Object newStatus = value(params, "newStatus");
        Object operatorId = value(params, "operatorId");
        if (!isKnownRoomStatus(newStatus)) {
            return R.error(400, "新状态无效，请选择 available、reserved、occupied、cleaning 或 maintenance");
        }
        if (oldStatus != null && !isKnownRoomStatus(oldStatus)) {
            return R.error(400, "原状态无效，请选择 available、reserved、occupied、cleaning 或 maintenance");
        }
        if (oldStatus != null && String.valueOf(oldStatus).equals(String.valueOf(newStatus))) {
            return R.error(400, "新状态不能和原状态相同");
        }
        if (!employeeExists(operatorId)) {
            return R.error(400, "操作人不存在，请填写有效员工ID，例如 5001");
        }
        return callProcedure(
                "CALL sp_batch_update_room_status(?,?,?,?,?)",
                value(params, "roomCategory"), value(params, "oldStatus"), value(params, "newStatus"),
                value(params, "operatorId"), value(params, "remark"));
    }

    @RequestMapping("/dbops/confirmCheckin")
    public R confirmCheckin(@RequestBody(required = false) Map<String, Object> params) {
        Object bookingId = value(params, "bookingId");
        Object employeeId = value(params, "employeeId");
        Object guestName = value(params, "guestName");
        if (!bookingExists(bookingId)) {
            return R.error(400, "订单不存在，请填写有效订单ID");
        }
        if (!employeeExists(employeeId)) {
            return R.error(400, "员工不存在，请填写有效员工ID，例如 5001");
        }
        if (guestName == null) {
            return R.error(400, "办理入住需要填写主入住人");
        }
        R result = callProcedure(
                "CALL sp_confirm_checkin(?,?,?,?,?)",
                bookingId, employeeId, guestName, value(params, "idCardNo"), value(params, "phone"));
        if (isOk(result)) {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> data = (List<Map<String, Object>>) result.get("data");
            if (data != null && !data.isEmpty() && data.get(0).get("checkin_id") != null) {
                Long checkinId = Long.valueOf(String.valueOf(data.get(0).get("checkin_id")));
                Long parsedBookingId = toLong(bookingId);
                if (parsedBookingId != null) {
                    syncCheckinGuestsFromBooking(parsedBookingId, checkinId);
                }
            }
        }
        return result;
    }

    @RequestMapping("/dbops/generateCheckoutBill")
    public R generateCheckoutBill(@RequestBody(required = false) Map<String, Object> params) {
        Object checkinId = value(params, "checkinId");
        Object employeeId = value(params, "employeeId");
        if (!checkinExists(checkinId)) {
            return R.error(400, "入住记录不存在，请填写有效入住ID");
        }
        if (!isNonNegativeAmount(value(params, "serviceAmount")) || !isNonNegativeAmount(value(params, "discountAmount"))) {
            return R.error(400, "服务费和优惠金额不能为负数");
        }
        if (!employeeExists(employeeId)) {
            return R.error(400, "员工不存在，请填写有效员工ID，例如 5001");
        }
        return callProcedure(
                "CALL sp_generate_checkout_bill(?,?,?,?)",
                value(params, "checkinId"), value(params, "serviceAmount"), value(params, "discountAmount"),
                value(params, "employeeId"));
    }

    @RequestMapping("/dbops/payBill")
    public R payBill(@RequestBody(required = false) Map<String, Object> params) {
        Object billId = value(params, "billId");
        Object payMethod = value(params, "payMethod");
        Object payAmountValue = value(params, "payAmount");
        Object employeeId = value(params, "employeeId");
        BigDecimal payAmount = toBigDecimal(payAmountValue);
        if (!billExists(billId)) {
            return R.error(400, "账单不存在，请填写有效账单ID");
        }
        if (!isKnownPayMethod(payMethod)) {
            return R.error(400, "支付方式无效，请选择 cash、card、alipay 或 wechat");
        }
        if (payAmount == null || payAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return R.error(400, "支付金额必须大于 0");
        }
        BigDecimal remainingAmount = remainingBillAmount(billId);
        if (remainingAmount != null && remainingAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return R.error(400, "该账单已经结清，无需重复收款");
        }
        if (remainingAmount != null && payAmount.compareTo(remainingAmount) > 0) {
            return R.error(400, "支付金额不能超过账单剩余应收金额 " + remainingAmount);
        }
        if (!employeeExists(employeeId)) {
            return R.error(400, "员工不存在，请填写有效员工ID，例如 5001");
        }
        return callProcedure(
                "CALL sp_pay_bill(?,?,?,?)",
                billId, payMethod, payAmountValue, employeeId);
    }

    @RequestMapping("/dbops/customerConsumptionReport")
    public R customerConsumptionReport(@RequestBody(required = false) Map<String, Object> params) {
        Object customerId = value(params, "customerId");
        Object startDate = value(params, "startDate");
        Object endDate = value(params, "endDate");
        if (customerId != null && !customerExists(customerId)) {
            return R.error(400, "客户不存在，请填写有效客户ID，例如 4001");
        }
        if (!dateRangeValid(startDate, endDate)) {
            return R.error(400, "结束日期不能早于开始日期");
        }
        return callProcedure(
                "CALL sp_customer_consumption_report(?,?,?)",
                customerId, startDate, endDate);
    }

    @RequestMapping("/dbops/employeePerformanceReport")
    public R employeePerformanceReport(@RequestBody(required = false) Map<String, Object> params) {
        Object employeeId = value(params, "employeeId");
        Object startDate = value(params, "startDate");
        Object endDate = value(params, "endDate");
        if (employeeId != null && !employeeExists(employeeId)) {
            return R.error(400, "员工不存在，请填写有效员工ID，例如 5001");
        }
        if (!dateRangeValid(startDate, endDate)) {
            return R.error(400, "结束日期不能早于开始日期");
        }
        return callProcedure(
                "CALL sp_employee_performance_report(?,?,?)",
                employeeId, startDate, endDate);
    }

    @RequestMapping("/dbops/createHousekeepingTask")
    public R createHousekeepingTask(@RequestBody(required = false) Map<String, Object> params) {
        Object roomId = value(params, "roomId");
        Object employeeId = value(params, "employeeId");
        Object taskType = value(params, "taskType");
        if (!roomExists(roomId)) {
            return R.error(400, "房间不存在，请填写有效房间ID");
        }
        if (!employeeExists(employeeId)) {
            return R.error(400, "员工不存在，请填写有效员工ID，例如 5001");
        }
        if (!isKnownTaskType(taskType)) {
            return R.error(400, "任务类型无效，请选择 daily_cleaning、checkout_cleaning 或 deep_cleaning");
        }
        return callProcedure(
                "CALL sp_create_housekeeping_task(?,?,?,?)",
                value(params, "roomId"), value(params, "employeeId"), value(params, "taskType"),
                value(params, "remark"));
    }

    @RequestMapping("/dbops/reportMaintenance")
    public R reportMaintenance(@RequestBody(required = false) Map<String, Object> params) {
        Object roomId = value(params, "roomId");
        Object reportEmployeeId = value(params, "reportEmployeeId");
        Object handleEmployeeId = value(params, "handleEmployeeId");
        Object issueDesc = value(params, "issueDesc");
        if (!roomExists(roomId)) {
            return R.error(400, "房间不存在，请填写有效房间ID");
        }
        if (!employeeExists(reportEmployeeId)) {
            return R.error(400, "上报员工不存在，请填写有效员工ID，例如 5001");
        }
        if (!employeeExists(handleEmployeeId)) {
            return R.error(400, "处理员工不存在，请填写有效员工ID，例如 5002");
        }
        if (issueDesc == null) {
            return R.error(400, "故障描述不能为空");
        }
        return callProcedure(
                "CALL sp_report_room_maintenance(?,?,?,?)",
                roomId, reportEmployeeId, handleEmployeeId, issueDesc);
    }

    @RequestMapping("/dbops/generateEmployeeAssessment")
    public R generateEmployeeAssessment(@RequestBody(required = false) Map<String, Object> params) {
        Object employeeId = value(params, "employeeId");
        Object startDate = value(params, "startDate");
        Object endDate = value(params, "endDate");
        Object assessorId = value(params, "assessorId");
        if (employeeId == null) {
            return R.error(400, "员工考核生成需要填写员工ID，例如 5001");
        }
        if (startDate == null || endDate == null) {
            return R.error(400, "员工考核生成需要选择开始日期和结束日期");
        }
        if (String.valueOf(endDate).compareTo(String.valueOf(startDate)) < 0) {
            return R.error(400, "结束日期不能早于开始日期");
        }
        if (!employeeExists(employeeId)) {
            return R.error(400, "员工不存在，请填写有效员工ID，例如 5001");
        }
        if (assessorId != null && !employeeExists(assessorId)) {
            return R.error(400, "考核人不存在，请填写有效考核人ID，例如 5002");
        }
        if (!isNonNegativeAmount(value(params, "managerScore"))) {
            return R.error(400, "管理加分不能为负数");
        }
        return callProcedure(
                "CALL sp_generate_employee_assessment(?,?,?,?,?)",
                employeeId, startDate, endDate,
                assessorId, value(params, "managerScore"));
    }

    @RequestMapping("/report/meta")
    public R reportMeta() {
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("customerIdRange", idRange("customer"));
        data.put("employeeIdRange", idRange("employee"));
        data.put("bookingIdRange", idRange("booking_order"));
        data.put("bookingNoRule", "BKYYYYMMDDNNNN");
        data.put("demoHighlights", new ArrayList<>());
        data.put("views", buildViewMetadata());
        return R.ok().put("data", data);
    }

    @RequestMapping("/bookingFlow/detail")
    public R bookingFlowDetail(@RequestParam Map<String, Object> params) {
        bookingLifecycleService.expireUnpaidBookings();
        Long bookingId = value(params, "bookingId") == null ? null : Long.valueOf(String.valueOf(value(params, "bookingId")));
        String bookingNo = value(params, "bookingNo") == null ? null : String.valueOf(value(params, "bookingNo"));
        Map<String, Object> data = bookingFlowQueryService.getBookingFlow(bookingId, bookingNo);
        if (data == null) {
            return R.error("未找到对应订单");
        }
        return R.ok().put("data", data);
    }

    private R one(String tableName, Long id, HttpServletRequest request) {
        String objectName = checkedObject(tableName);
        Map<String, Object> params = new LinkedHashMap<>();
        params.put(resolvePrimaryKey(objectName), id);
        QueryParts parts = buildWhere(objectName, params, request);
        List<Map<String, Object>> rows = jdbcTemplate.queryForList("SELECT * FROM `" + objectName + "`" + parts.whereSql + " LIMIT 1", parts.args.toArray());
        return R.ok().put("data", rows.isEmpty() ? null : rows.get(0));
    }

    private R insert(String tableName, Map<String, Object> row, HttpServletRequest request) {
        String table = checkedTable(tableName);
        if ("checkin_record".equals(table)) {
            return insertCheckinRecord(row, request);
        }
        List<String> columns = TABLE_COLUMNS.get(table).stream()
                .filter(column -> row.containsKey(column) && row.get(column) != null && StringUtils.isNotBlank(String.valueOf(row.get(column))))
                .collect(Collectors.toList());
        if (columns.isEmpty()) {
            return R.error("no writable fields provided");
        }
        String columnSql = columns.stream().map(column -> "`" + column + "`").collect(Collectors.joining(","));
        String placeholders = columns.stream().map(column -> "?").collect(Collectors.joining(","));
        Object[] args = columns.stream().map(row::get).toArray();
        jdbcTemplate.update("INSERT INTO `" + table + "` (" + columnSql + ") VALUES (" + placeholders + ")", args);
        return R.ok();
    }

    private R insertCheckinRecord(Map<String, Object> row, HttpServletRequest request) {
        Long bookingId = parseLong(row.get("booking_id"));
        Long roomId = parseLong(row.get("room_id"));
        Long customerId = parseLong(row.get("customer_id"));
        Long employeeId = parseLong(row.get("employee_id"));
        String status = StringUtils.defaultIfBlank(stringValue(row.get("status")), "checked_in");
        String remark = stringValue(row.get("remark"));
        String checkinTime = stringValue(row.get("checkin_time"));
        String checkoutTime = stringValue(row.get("checkout_time"));

        Map<String, Object> booking = null;
        if (bookingId != null) {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                    "SELECT id, yudingbianhao, booking_status, customer_id, room_instance_id FROM booking_order WHERE id=? LIMIT 1",
                    bookingId
            );
            booking = rows.isEmpty() ? null : rows.get(0);
        }
        if (booking != null) {
            if (customerId == null && booking.get("customer_id") != null) {
                customerId = ((Number) booking.get("customer_id")).longValue();
            }
            if (roomId == null && booking.get("room_instance_id") != null) {
                roomId = ((Number) booking.get("room_instance_id")).longValue();
            }
        }
        if (roomId == null) {
            return R.error("missing room id");
        }

        KeyHolder keyHolder = new GeneratedKeyHolder();
        final Long finalBookingId = bookingId;
        final Long finalRoomId = roomId;
        final Long finalCustomerId = customerId;
        final Long finalEmployeeId = employeeId;
        final String finalStatus = status;
        final String finalRemark = remark;
        final String finalCheckinTime = StringUtils.defaultIfBlank(checkinTime,
                new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()));
        final String finalCheckoutTime = checkoutTime;

        jdbcTemplate.update(connection -> {
            PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO `checkin_record` (`booking_id`,`room_id`,`customer_id`,`employee_id`,`checkin_time`,`checkout_time`,`status`,`remark`) VALUES (?,?,?,?,?,?,?,?)",
                    Statement.RETURN_GENERATED_KEYS
            );
            if (finalBookingId == null) {
                statement.setObject(1, null);
            } else {
                statement.setLong(1, finalBookingId);
            }
            statement.setLong(2, finalRoomId);
            if (finalCustomerId == null) {
                statement.setObject(3, null);
            } else {
                statement.setLong(3, finalCustomerId);
            }
            if (finalEmployeeId == null) {
                statement.setObject(4, null);
            } else {
                statement.setLong(4, finalEmployeeId);
            }
            statement.setString(5, finalCheckinTime);
            if (StringUtils.isBlank(finalCheckoutTime)) {
                statement.setObject(6, null);
            } else {
                statement.setString(6, finalCheckoutTime);
            }
            statement.setString(7, finalStatus);
            statement.setString(8, finalRemark);
            return statement;
        }, keyHolder);

        Number key = keyHolder.getKey();
        Long checkinId = key == null ? null : key.longValue();
        if (checkinId == null) {
            return R.error("入住记录创建失败");
        }

        if (bookingId != null) {
            syncCheckinGuestsFromBooking(bookingId, checkinId);
            syncBookingStatusForCheckin(bookingId, roomId, employeeId, booking);
        }
        jdbcTemplate.update("UPDATE room_instance SET status='occupied', updated_at=NOW() WHERE id=?", roomId);
        if (employeeId != null) {
            jdbcTemplate.update(
                    "INSERT INTO operation_log (operator_type, operator_id, business_type, business_id, action, remark, created_at) VALUES (?,?,?,?,?,?,NOW())",
                    resolveOperatorType(request), employeeId, "checkin_record", checkinId, "create_checkin_record",
                    bookingId == null ? "manual checkin" : ("booking " + bookingId)
            );
        }

        return R.ok().put("data", one("checkin_record", checkinId, request).get("data"));
    }

    private R updateCheckinRecord(Map<String, Object> row, HttpServletRequest request) {
        Long checkinId = parseLong(row.get("id"));
        if (checkinId == null) {
            return R.error("missing primary key id");
        }

        List<Map<String, Object>> existingRows = jdbcTemplate.queryForList(
                "SELECT id, booking_id, room_id, customer_id, employee_id, checkin_time, checkout_time, status, remark FROM checkin_record WHERE id=? LIMIT 1",
                checkinId
        );
        if (existingRows.isEmpty()) {
            return R.error("入住记录不存在");
        }
        Map<String, Object> existing = existingRows.get(0);

        Long bookingId = parseLong(row.get("booking_id"));
        if (bookingId == null) {
            bookingId = parseLong(existing.get("booking_id"));
        }
        Long roomId = parseLong(row.get("room_id"));
        if (roomId == null) {
            roomId = parseLong(existing.get("room_id"));
        }
        Long employeeId = parseLong(row.get("employee_id"));
        if (employeeId == null) {
            employeeId = parseLong(existing.get("employee_id"));
        }

        String status = stringValue(row.get("status"));
        String checkoutTime = stringValue(row.get("checkout_time"));
        if (StringUtils.isNotBlank(checkoutTime) && StringUtils.isBlank(status)) {
            row.put("status", "checked_out");
        }
        if ("checked_out".equals(stringValue(row.get("status"))) && StringUtils.isBlank(checkoutTime)) {
            row.put("checkout_time", nowString());
        }

        List<String> columns = TABLE_COLUMNS.get("checkin_record");
        List<String> setColumns = columns.stream()
                .filter(column -> !"id".equals(column) && row.containsKey(column))
                .collect(Collectors.toList());
        if (!setColumns.isEmpty()) {
            List<Object> args = setColumns.stream().map(row::get).collect(Collectors.toList());
            args.add(checkinId);
            String setSql = setColumns.stream().map(column -> "`" + column + "`=?").collect(Collectors.joining(","));
            jdbcTemplate.update("UPDATE `checkin_record` SET " + setSql + " WHERE `id`=?", args.toArray());
        }

        List<Map<String, Object>> updatedRows = jdbcTemplate.queryForList(
                "SELECT id, booking_id, room_id, customer_id, employee_id, checkin_time, checkout_time, status, remark FROM checkin_record WHERE id=? LIMIT 1",
                checkinId
        );
        Map<String, Object> updated = updatedRows.get(0);
        bookingId = parseLong(updated.get("booking_id"));
        roomId = parseLong(updated.get("room_id"));
        employeeId = parseLong(updated.get("employee_id"));

        String oldCheckinStatus = stringValue(existing.get("status"));
        String newCheckinStatus = stringValue(updated.get("status"));
        String oldCheckoutTime = stringValue(existing.get("checkout_time"));
        String newCheckoutTime = stringValue(updated.get("checkout_time"));

        Map<String, Object> booking = null;
        String oldBookingStatus = null;
        if (bookingId != null) {
            List<Map<String, Object>> bookingRows = jdbcTemplate.queryForList(
                    "SELECT id, booking_status FROM booking_order WHERE id=? LIMIT 1",
                    bookingId
            );
            booking = bookingRows.isEmpty() ? null : bookingRows.get(0);
            oldBookingStatus = booking == null ? null : stringValue(booking.get("booking_status"));
        }

        String oldRoomStatus = null;
        if (roomId != null) {
            List<Map<String, Object>> roomRows = jdbcTemplate.queryForList(
                    "SELECT status FROM room_instance WHERE id=? LIMIT 1",
                    roomId
            );
            if (!roomRows.isEmpty()) {
                oldRoomStatus = stringValue(roomRows.get(0).get("status"));
            }
        }

        boolean becameCheckedIn = "checked_in".equals(newCheckinStatus) && !"checked_in".equals(oldCheckinStatus);
        boolean becameCheckedOut = "checked_out".equals(newCheckinStatus) && !"checked_out".equals(oldCheckinStatus);
        boolean checkoutCompletedByTime = StringUtils.isBlank(oldCheckoutTime) && StringUtils.isNotBlank(newCheckoutTime);

        if (becameCheckedIn && bookingId != null) {
            syncCheckinGuestsFromBooking(bookingId, checkinId);
            syncBookingStatusForCheckin(bookingId, roomId, employeeId, booking);
            if (roomId != null) {
                jdbcTemplate.update("UPDATE room_instance SET status='occupied', updated_at=NOW() WHERE id=?", roomId);
            }
        }

        if (becameCheckedOut || checkoutCompletedByTime) {
            syncCheckoutLifecycle(checkinId, bookingId, roomId, employeeId, oldBookingStatus, oldRoomStatus, request);
        }

        return R.ok().put("data", one("checkin_record", checkinId, request).get("data"));
    }

    private void syncCheckinGuestsFromBooking(Long bookingId, Long checkinId) {
        jdbcTemplate.update("DELETE FROM checkin_guest WHERE checkin_id=?", checkinId);
        Integer copied = jdbcTemplate.update(
                "INSERT INTO checkin_guest (checkin_id, guest_name, id_card_no, phone, is_primary, created_at) " +
                        "SELECT ?, guest_name, id_card_no, phone, is_primary, NOW() FROM booking_guest WHERE booking_id=?",
                checkinId, bookingId
        );
        if (copied > 0) {
            return;
        }
        List<Map<String, Object>> bookingRows = jdbcTemplate.queryForList(
                "SELECT xingming, shoujihao FROM booking_order WHERE id=? LIMIT 1",
                bookingId
        );
        if (bookingRows.isEmpty()) {
            return;
        }
        Map<String, Object> booking = bookingRows.get(0);
        jdbcTemplate.update(
                "INSERT INTO checkin_guest (checkin_id, guest_name, id_card_no, phone, is_primary, created_at) VALUES (?,?,?,?,1,NOW())",
                checkinId, booking.get("xingming"), null, booking.get("shoujihao")
        );
    }

    private void syncBookingStatusForCheckin(Long bookingId, Long roomId, Long employeeId, Map<String, Object> booking) {
        String oldStatus = booking == null ? null : stringValue(booking.get("booking_status"));
        jdbcTemplate.update("UPDATE booking_order SET booking_status='checked_in' WHERE id=?", bookingId);
        if (roomId != null) {
            jdbcTemplate.update("UPDATE booking_room SET room_status='checked_in' WHERE booking_id=? AND room_id=?", bookingId, roomId);
        } else {
            jdbcTemplate.update("UPDATE booking_room SET room_status='checked_in' WHERE booking_id=?", bookingId);
        }
        if (!"checked_in".equals(oldStatus)) {
            jdbcTemplate.update(
                    "INSERT INTO booking_status_log (booking_id, old_status, new_status, operator_id, remark, created_at) VALUES (?,?,?,?,?,NOW())",
                    bookingId, oldStatus, "checked_in", employeeId, "入住办理同步订单状态"
            );
        }
    }

    private void syncCheckoutLifecycle(Long checkinId, Long bookingId, Long roomId, Long employeeId,
                                       String oldBookingStatus, String oldRoomStatus, HttpServletRequest request) {
        if (bookingId != null) {
            jdbcTemplate.update("UPDATE booking_order SET booking_status='completed' WHERE id=?", bookingId);
            if (roomId != null) {
                jdbcTemplate.update("UPDATE booking_room SET room_status='completed' WHERE booking_id=? AND room_id=?", bookingId, roomId);
            } else {
                jdbcTemplate.update("UPDATE booking_room SET room_status='completed' WHERE booking_id=?", bookingId);
            }
            Integer completedLogCount = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM booking_status_log WHERE booking_id=? AND new_status='completed'",
                    Integer.class,
                    bookingId
            );
            if (!"completed".equals(oldBookingStatus) && (completedLogCount == null || completedLogCount == 0)) {
                jdbcTemplate.update(
                        "INSERT INTO booking_status_log (booking_id, old_status, new_status, operator_id, remark, created_at) VALUES (?,?,?,?,?,NOW())",
                        bookingId, oldBookingStatus, "completed", employeeId, "退房办理同步订单完成"
                );
            }
        }

        if (roomId != null) {
            String currentRoomStatus = oldRoomStatus;
            List<Map<String, Object>> roomRows = jdbcTemplate.queryForList(
                    "SELECT status FROM room_instance WHERE id=? LIMIT 1",
                    roomId
            );
            if (!roomRows.isEmpty()) {
                currentRoomStatus = stringValue(roomRows.get(0).get("status"));
            }
            if (!"cleaning".equals(currentRoomStatus)) {
                jdbcTemplate.update("UPDATE room_instance SET status='cleaning', updated_at=NOW() WHERE id=?", roomId);
            }
            if (!"cleaning".equals(oldRoomStatus) && !"cleaning".equals(currentRoomStatus)) {
                jdbcTemplate.update(
                        "INSERT INTO room_status_log (room_id, old_status, new_status, source_type, source_id, operator_id, remark, created_at) VALUES (?,?,?,?,?,?,?,NOW())",
                        roomId, oldRoomStatus, "cleaning", "checkin_record", checkinId, employeeId, "退房后待清扫"
                );
            }

            Integer activeTaskCount = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM housekeeping_task WHERE room_id=? AND checkin_id=? AND task_type='checkout_cleaning' AND task_status IN ('pending','assigned','in_progress')",
                    Integer.class,
                    roomId, checkinId
            );
            if (activeTaskCount == null || activeTaskCount == 0) {
                jdbcTemplate.update(
                        "INSERT INTO housekeeping_task (room_id, checkin_id, assigned_employee_id, task_type, task_status, scheduled_time, remark, created_at, updated_at) VALUES (?,?,?,?,?,NOW(),?,NOW(),NOW())",
                        roomId, checkinId, employeeId, "checkout_cleaning", "assigned", "退房后自动创建清扫任务"
                );
            }
        }

        if (employeeId != null) {
            Integer checkoutLogCount = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM operation_log WHERE business_type='checkin_record' AND business_id=? AND action='checkout_updated'",
                    Integer.class,
                    checkinId
            );
            if (checkoutLogCount == null || checkoutLogCount == 0) {
                jdbcTemplate.update(
                        "INSERT INTO operation_log (operator_type, operator_id, business_type, business_id, action, remark, created_at) VALUES (?,?,?,?,?,?,NOW())",
                        resolveOperatorType(request), employeeId, "checkin_record", checkinId, "checkout_updated", "退房完成并切换房态"
                );
            }
        }
    }

    private QueryParts buildWhere(String objectName, Map<String, Object> params, HttpServletRequest request) {
        List<String> columns = columnsOf(objectName);
        List<String> conditions = new ArrayList<>();
        List<Object> args = new ArrayList<>();
        for (String column : columns) {
            Object value = params.get(column);
            if (value == null || StringUtils.isBlank(String.valueOf(value))) {
                continue;
            }
            String text = String.valueOf(value);
            if (text.contains("%")) {
                conditions.add("`" + column + "` LIKE ?");
                args.add(text);
            } else {
                conditions.add("`" + column + "` = ?");
                args.add(value);
            }
        }
        for (String key : params.keySet()) {
            if (key.endsWith("_start")) {
                String column = key.substring(0, key.length() - 6);
                if (columns.contains(column) && StringUtils.isNotBlank(String.valueOf(params.get(key)))) {
                    conditions.add("`" + column + "` >= ?");
                    args.add(params.get(key));
                }
            }
            if (key.endsWith("_end")) {
                String column = key.substring(0, key.length() - 4);
                if (columns.contains(column) && StringUtils.isNotBlank(String.valueOf(params.get(key)))) {
                    conditions.add("`" + column + "` <= ?");
                    args.add(params.get(key));
                }
            }
        }
        appendRoleScope(objectName, conditions, args, request);
        return new QueryParts(conditions.isEmpty() ? "" : " WHERE " + String.join(" AND ", conditions), args);
    }

    private void appendRoleScope(String objectName, List<String> conditions, List<Object> args, HttpServletRequest request) {
        if (request == null || request.getSession() == null) {
            return;
        }
        Object role = request.getSession().getAttribute("role");
        Object userId = request.getSession().getAttribute("userId");
        if (!"员工".equals(String.valueOf(role)) || userId == null) {
            return;
        }
        Long employeeId = Long.valueOf(String.valueOf(userId));
        if ("employee".equals(objectName)) {
            conditions.add("`id` = ?");
            args.add(employeeId);
            return;
        }
        if ("v_employee_operation_summary".equals(objectName)
                || "v_employee_performance_detail".equals(objectName)
                || "employee_performance".equals(objectName)) {
            conditions.add("`employee_id` = ?");
            args.add(employeeId);
        }
    }

    private String resolvePrimaryKey(String objectName) {
        if ("v_customer_value_profile".equals(objectName)) {
            return "customer_id";
        }
        if ("v_booking_detail".equals(objectName)) {
            return "booking_id";
        }
        if ("v_checkin_guest_detail".equals(objectName)) {
            return "checkin_id";
        }
        if ("v_housekeeping_task_detail".equals(objectName)) {
            return "task_id";
        }
        if ("v_employee_performance_detail".equals(objectName)) {
            return "performance_id";
        }
        return "id";
    }

    private String buildOrderBy(String objectName, Map<String, Object> params) {
        List<String> columns = columnsOf(objectName);
        String sort = String.valueOf(params.getOrDefault("sort", "id"));
        if (!columns.contains(sort)) {
            sort = columns.contains("id") ? "id" : columns.get(0);
        }
        String order = "desc".equalsIgnoreCase(String.valueOf(params.get("order"))) ? " DESC" : " ASC";
        return " ORDER BY `" + sort + "`" + order;
    }

    private String checkedObject(String objectName) {
        if (TABLE_COLUMNS.containsKey(objectName) || READONLY_OBJECTS.contains(objectName)) {
            return objectName;
        }
        throw new IllegalArgumentException("Unsupported database object: " + objectName);
    }

    private String checkedTable(String tableName) {
        if (TABLE_COLUMNS.containsKey(tableName)) {
            return tableName;
        }
        throw new IllegalArgumentException("Unsupported writable table: " + tableName);
    }

    private List<String> columnsOf(String objectName) {
        if (TABLE_COLUMNS.containsKey(objectName)) {
            return TABLE_COLUMNS.get(objectName);
        }
        List<Map<String, Object>> sampleRows = jdbcTemplate.queryForList("SELECT * FROM `" + objectName + "` LIMIT 1");
        if (!sampleRows.isEmpty()) {
            return new ArrayList<>(sampleRows.get(0).keySet());
        }
        return jdbcTemplate.queryForList("SHOW COLUMNS FROM `" + objectName + "`").stream()
                .map(row -> String.valueOf(row.get("Field")))
                .collect(Collectors.toList());
    }

    private int intParam(Object value, int defaultValue) {
        if (value == null || StringUtils.isBlank(String.valueOf(value))) {
            return defaultValue;
        }
        return Integer.parseInt(String.valueOf(value));
    }

    private Long parseLong(Object value) {
        if (value == null || StringUtils.isBlank(String.valueOf(value))) {
            return null;
        }
        if (value instanceof Number) {
            return ((Number) value).longValue();
        }
        return Long.valueOf(String.valueOf(value));
    }

    private String stringValue(Object value) {
        return value == null || StringUtils.isBlank(String.valueOf(value)) ? null : String.valueOf(value);
    }

    private String nowString() {
        return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
    }

    private String resolveOperatorType(HttpServletRequest request) {
        if (request == null || request.getSession() == null) {
            return "admin";
        }
        Object role = request.getSession().getAttribute("role");
        if (role == null) {
            return "admin";
        }
        String roleText = String.valueOf(role);
        if ("员工".equals(roleText)) {
            return "employee";
        }
        if ("用户".equals(roleText) || "客户".equals(roleText)) {
            return "customer";
        }
        return "admin";
    }

    private R callProcedure(String sql, Object... args) {
        try {
            return R.ok().put("data", jdbcTemplate.queryForList(sql, args));
        } catch (Exception e) {
            return R.error(400, dbErrorMessage(e));
        }
    }

    private boolean isOk(R result) {
        return result != null && "0".equals(String.valueOf(result.get("code")));
    }

    private String dbErrorMessage(Exception e) {
        Throwable root = e;
        while (root.getCause() != null) {
            root = root.getCause();
        }
        String message = root.getMessage();
        if (StringUtils.isBlank(message)) {
            message = e.getMessage();
        }
        message = StringUtils.defaultIfBlank(message, "存储过程执行失败")
                .replace("Data truncation: ", "")
                .replaceAll("\\s+", " ");
        return StringUtils.abbreviate(message, 180);
    }

    private boolean dateRangeValid(Object startDate, Object endDate) {
        if (startDate == null || endDate == null) {
            return true;
        }
        return String.valueOf(endDate).compareTo(String.valueOf(startDate)) >= 0;
    }

    private boolean isPositiveInteger(Object value) {
        Long number = toLong(value);
        return number != null && number > 0;
    }

    private boolean isNonNegativeAmount(Object value) {
        if (value == null) {
            return true;
        }
        BigDecimal amount = toBigDecimal(value);
        return amount != null && amount.compareTo(BigDecimal.ZERO) >= 0;
    }

    private boolean isKnownRoomStatus(Object value) {
        if (value == null) {
            return false;
        }
        return Arrays.asList("available", "reserved", "occupied", "cleaning", "maintenance")
                .contains(String.valueOf(value));
    }

    private boolean isKnownPayMethod(Object value) {
        if (value == null) {
            return false;
        }
        return Arrays.asList("cash", "card", "alipay", "wechat").contains(String.valueOf(value));
    }

    private boolean isKnownTaskType(Object value) {
        if (value == null) {
            return false;
        }
        return Arrays.asList("daily_cleaning", "checkout_cleaning", "deep_cleaning").contains(String.valueOf(value));
    }

    private BigDecimal remainingBillAmount(Object billId) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT `payable_amount`, `paid_amount` FROM `bill` WHERE `id`=? LIMIT 1",
                toLong(billId)
        );
        if (rows.isEmpty()) {
            return null;
        }
        BigDecimal payableAmount = toBigDecimal(rows.get(0).get("payable_amount"));
        BigDecimal paidAmount = toBigDecimal(rows.get(0).get("paid_amount"));
        if (payableAmount == null) {
            return null;
        }
        return payableAmount.subtract(paidAmount == null ? BigDecimal.ZERO : paidAmount);
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value == null || StringUtils.isBlank(String.valueOf(value))) {
            return null;
        }
        if (value instanceof BigDecimal) {
            return (BigDecimal) value;
        }
        try {
            return new BigDecimal(String.valueOf(value));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Long toLong(Object value) {
        if (value == null || StringUtils.isBlank(String.valueOf(value))) {
            return null;
        }
        if (value instanceof Number) {
            return ((Number) value).longValue();
        }
        try {
            return Long.valueOf(String.valueOf(value));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Object value(Map<String, Object> params, String key) {
        if (params == null) {
            return null;
        }
        Object value = params.get(key);
        return value == null || StringUtils.isBlank(String.valueOf(value)) ? null : value;
    }

    private boolean employeeExists(Object employeeId) {
        return existsById("employee", employeeId);
    }

    private boolean customerExists(Object customerId) {
        return existsById("customer", customerId);
    }

    private boolean roomCatalogExists(Object roomCatalogId) {
        return existsById("room_catalog", roomCatalogId);
    }

    private boolean bookingExists(Object bookingId) {
        return existsById("booking_order", bookingId);
    }

    private boolean checkinExists(Object checkinId) {
        return existsById("checkin_record", checkinId);
    }

    private boolean billExists(Object billId) {
        return existsById("bill", billId);
    }

    private boolean roomExists(Object roomId) {
        return existsById("room_instance", roomId);
    }

    private boolean existsById(String tableName, Object id) {
        Long idValue = toLong(id);
        if (idValue == null) {
            return false;
        }
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM `" + tableName + "` WHERE `id`=?",
                Integer.class,
                idValue
        );
        return count != null && count > 0;
    }

    private String idRange(String tableName) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT MIN(`id`) AS min_id, MAX(`id`) AS max_id FROM `" + tableName + "`");
        if (rows.isEmpty()) {
            return "";
        }
        Map<String, Object> row = rows.get(0);
        Object min = row.get("min_id");
        Object max = row.get("max_id");
        if (min == null || max == null) {
            return "";
        }
        return min + " - " + max;
    }

    private List<Map<String, Object>> buildViewMetadata() {
        List<Map<String, Object>> views = new ArrayList<>();
        views.add(viewMeta("v_room_inventory_overview", "客房库存总览", "按客房目录汇总总房数、可预订数、已预订数、入住数、清扫数和维修数。"));
        views.add(viewMeta("v_room_daily_status", "客房日常状态", "展示每间实体客房的当前房态、关联订单、入住、清扫和维修状态。"));
        views.add(viewMeta("v_booking_detail", "预订明细", "整合顾客、订单、房型和房号信息，支持查看一客多单和一单多房。"));
        views.add(viewMeta("v_checkin_guest_detail", "入住客人明细", "展示入住记录、同住人、办理员工和对应房间信息。"));
        views.add(viewMeta("v_bill_payment_summary", "账单支付汇总", "展示账单应收、实收、退款和支付状态。"));
        views.add(viewMeta("v_monthly_revenue_report", "月度营收报表", "按月份统计订单金额、账单收入和实际回款。"));
        views.add(viewMeta("v_employee_operation_summary", "员工业务汇总", "统计员工在入住、清扫、维修、账务流程中的业务量。"));
        views.add(viewMeta("v_customer_value_profile", "顾客价值画像", "统计顾客订单数、入住次数、消费金额和客户活跃情况。"));
        views.add(viewMeta("v_housekeeping_task_detail", "清扫任务明细", "展示清扫任务、房号、房型、执行员工与任务状态。"));
        views.add(viewMeta("v_employee_performance_detail", "员工考核明细", "展示员工考核周期、业务指标、总分和等级。"));
        return views;
    }

    private Map<String, Object> viewMeta(String name, String title, String description) {
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("name", name);
        row.put("title", title);
        row.put("description", description);
        return row;
    }

    private static class QueryParts {
        private final String whereSql;
        private final List<Object> args;

        private QueryParts(String whereSql, List<Object> args) {
            this.whereSql = whereSql;
            this.args = args;
        }
    }
}

