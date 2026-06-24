# 酒店管理系统数据库升级总方案

## 1. 二次开发目标

本项目在原有酒店预订系统基础上，升级为面向酒店日常运营的综合数据库应用系统。系统重点不放在复杂前端，而是突出数据库设计、复杂查询、视图、存储过程、触发器和数据一致性控制。

升级后的核心业务包括：

- 酒店信息维护：维护酒店基础资料、联系方式、服务介绍和公告。
- 客房资源管理：维护房型、房间目录、具体房间、房态和价格策略。
- 客户与员工管理：维护客户档案、员工资料、角色登录和操作记录。
- 预订管理：支持客户预订、预订状态流转、库存占用和取消恢复。
- 入住管理：支持入住安排、入住人登记、退房结算和房态释放。
- 财务管理：支持账单生成、支付记录、退款记录和收入统计。
- 评价与收藏：支持客户收藏、酒店评价、客房评价和评分统计。

## 2. 现有表英文命名方案

| 原表名 | 新表名 | 功能说明 |
| --- | --- | --- |
| `config` | `system_config` | 系统配置、轮播图、人脸识别配置等 |
| `users` | `admin_user` | 后台管理员账户 |
| `token` | `auth_token` | 登录令牌与过期时间 |
| `yonghu` | `customer` | 前台客户信息 |
| `yuangong` | `employee` | 酒店员工信息 |
| `jiudianjianjie` | `hotel_profile` | 酒店简介与基础资料 |
| `jiudiankefang` | `room_catalog` | 客房/房型展示目录 |
| `kefangleixing` | `room_category` | 客房类型字典 |
| `kefangyuding` | `booking_order` | 客房预订订单 |
| `ruzhuanpai` | `checkin_assignment` | 入住安排 |
| `storeup` | `favorite` | 收藏记录 |
| `news` | `notice` | 酒店公告资讯 |
| `discussjiudianjianjie` | `hotel_review` | 酒店评论 |
| `discussjiudiankefang` | `room_review` | 客房评论 |

说明：本次优先统一数据库表名、接口路径、前端请求路径和菜单路由中的表名。Java 类名暂时保留原生成器名称，避免一次性改动过大导致 Mapper、Service、Controller 的 import 链条失稳。后续如时间充足，可再进行类名级重构。

## 3. 建议新增核心表

为满足“不少于 10 个表”和“复杂数据库操作”的课程设计要求，建议在现有 14 张表基础上新增以下业务表，使系统达到 24 张左右的规模。

| 新表名 | 功能说明 | 关键字段建议 |
| --- | --- | --- |
| `room_instance` | 具体房间资源，例如 801、802 | `id`, `room_no`, `room_catalog_id`, `floor_no`, `status`, `created_at` |
| `room_status_log` | 房态变更日志 | `id`, `room_id`, `old_status`, `new_status`, `source_type`, `operator_id`, `created_at` |
| `booking_status_log` | 预订状态流转日志 | `id`, `booking_id`, `old_status`, `new_status`, `operator_id`, `remark`, `created_at` |
| `checkin_record` | 入住主记录 | `id`, `booking_id`, `room_id`, `customer_id`, `checkin_time`, `checkout_time`, `status` |
| `checkin_guest` | 入住人明细 | `id`, `checkin_id`, `guest_name`, `id_card_no`, `phone`, `is_primary` |
| `bill` | 账单主表 | `id`, `booking_id`, `checkin_id`, `customer_id`, `room_amount`, `service_amount`, `discount_amount`, `payable_amount`, `status` |
| `payment_record` | 支付记录 | `id`, `bill_id`, `payment_no`, `pay_method`, `pay_amount`, `pay_status`, `paid_at` |
| `refund_record` | 退款记录 | `id`, `payment_id`, `refund_no`, `refund_amount`, `refund_reason`, `refund_status`, `created_at` |
| `price_policy` | 房价策略 | `id`, `room_catalog_id`, `policy_name`, `start_date`, `end_date`, `price_multiplier`, `priority` |
| `operation_log` | 员工操作日志 | `id`, `operator_type`, `operator_id`, `business_type`, `business_id`, `action`, `created_at` |

## 4. 逻辑模型关系

主要实体关系建议如下：

- `room_category` 1:N `room_catalog`
- `room_catalog` 1:N `room_instance`
- `customer` 1:N `booking_order`
- `booking_order` 1:N `booking_status_log`
- `booking_order` 1:1 或 1:N `checkin_record`
- `checkin_record` 1:N `checkin_guest`
- `room_instance` 1:N `room_status_log`
- `checkin_record` 1:1 `bill`
- `bill` 1:N `payment_record`
- `payment_record` 1:N `refund_record`
- `room_catalog` 1:N `room_review`
- `hotel_profile` 1:N `hotel_review`
- `customer` 1:N `favorite`
- `employee` 1:N `operation_log`

## 5. 视图设计规划

四名成员每人至少 2 个视图，共 8 个视图。每个视图应包含多表连接、聚合、分组、条件判断或日期计算。

| 成员 | 视图名 | 查询目标 |
| --- | --- | --- |
| A | `v_room_inventory_overview` | 按酒店、房型统计总房间数、空闲数、已预订数、入住中数量 |
| A | `v_room_daily_status` | 查询指定日期维度下的房间状态、预订和入住占用情况 |
| B | `v_booking_detail` | 汇总客户、房型、预订金额、支付状态和入住安排 |
| B | `v_checkin_guest_detail` | 汇总入住记录、房间号、主入住人、同住人数量 |
| C | `v_bill_payment_summary` | 统计账单金额、已支付金额、退款金额和未结清金额 |
| C | `v_monthly_revenue_report` | 按月份、房型、支付方式统计收入 |
| D | `v_employee_operation_summary` | 按员工统计办理预订、入住、退房、退款等操作量 |
| D | `v_customer_value_profile` | 按客户统计预订次数、消费金额、收藏数、评价数 |

## 6. 存储过程设计规划

四名成员每人至少 2 个存储过程，共 8 个存储过程。建议每个过程包含参数校验、事务、异常处理和多表操作。

| 成员 | 存储过程名 | 功能 |
| --- | --- | --- |
| A | `sp_search_available_rooms` | 根据房型、日期、价格区间查询可订房间 |
| A | `sp_batch_update_room_status` | 批量维护房态并写入房态日志 |
| B | `sp_create_booking_order` | 创建预订、计算价格、占用库存、写状态日志 |
| B | `sp_confirm_checkin` | 办理入住、分配房间、写入住记录和房态日志 |
| C | `sp_generate_checkout_bill` | 退房时生成账单，计算房费、服务费和优惠 |
| C | `sp_pay_bill` | 支付账单，写支付记录并更新账单状态 |
| D | `sp_customer_consumption_report` | 生成客户消费统计结果 |
| D | `sp_employee_performance_report` | 生成员工办理业务绩效统计 |

## 7. 触发器设计规划

四名成员每人至少 2 个触发器，共 8 个触发器。触发器主要用于保证派生数据、日志和状态一致性。

| 成员 | 触发器名 | 触发时机 |
| --- | --- | --- |
| A | `trg_booking_after_insert_lock_room` | 新增预订后锁定库存或写入预订状态日志 |
| A | `trg_booking_after_update_release_room` | 预订取消后恢复库存或房态 |
| B | `trg_checkin_after_insert_room_occupied` | 新增入住记录后将房间状态改为入住中 |
| B | `trg_checkin_after_update_room_available` | 退房后将房间状态改为空闲/待清洁 |
| C | `trg_payment_after_insert_update_bill` | 支付成功后更新账单已付金额和状态 |
| C | `trg_refund_after_insert_update_payment` | 退款后更新支付记录和账单状态 |
| D | `trg_room_review_after_insert_update_score` | 客房评价后更新房型评分统计 |
| D | `trg_operation_after_insert_audit` | 关键业务操作后写审计辅助信息 |

## 8. 前后台实现策略

前端不作为重点，只保留必要交互：

- 管理员登录后维护客房、房型、员工、公告。
- 员工登录后处理预订、入住安排和退房账单。
- 客户登录后浏览酒店、浏览客房、发起预订、支付订单和查看评价。
- 后续新增的复杂数据库能力可以通过少量统计页面展示，例如房态总览、收入月报、客户价值统计。

后端建议继续使用现有 Spring Boot + MyBatis-Plus 结构：

- 旧 CRUD 接口继续保留。
- 新增复杂业务接口时，优先调用存储过程。
- 统计页面优先查询数据库视图。
- 对库存、房态、账单状态等一致性要求高的逻辑，交给触发器和事务控制。

## 9. 后续实施顺序

1. 完成表名英文化与现有代码引用更新。
2. 新建 `hotel_management_upgrade.sql`，在保留原始数据表的基础上追加新增表。
3. 编写 8 个复杂视图。
4. 编写 8 个存储过程。
5. 编写 8 个触发器。
6. 补充测试数据，覆盖预订、入住、退房、支付、退款、评价。
7. 增加少量后端接口和前端统计页面。
8. 整理需求分析、数据流图、数据字典、逻辑模型、物理模型和运行截图。
