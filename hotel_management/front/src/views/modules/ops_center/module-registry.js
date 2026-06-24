const yesNoOptions = [
  { label: '启用', value: 1 },
  { label: '停用', value: 0 }
]

const genderOptions = [
  { label: '未知', value: 'unknown' },
  { label: '男', value: 'male' },
  { label: '女', value: 'female' }
]

const roomStatusOptions = [
  { label: '可预订', value: 'available' },
  { label: '已预订', value: 'reserved' },
  { label: '入住中', value: 'occupied' },
  { label: '清扫中', value: 'cleaning' },
  { label: '维修中', value: 'maintenance' }
]

const bookingStatusOptions = [
  { label: '已创建', value: 'created' },
  { label: '已入住', value: 'checked_in' },
  { label: '已取消', value: 'cancelled' },
  { label: '已完成', value: 'completed' }
]

const payStatusOptions = [
  { label: '未支付', value: 'unpaid' },
  { label: '部分支付', value: 'partial' },
  { label: '已支付', value: 'paid' },
  { label: '已退款', value: 'refunded' }
]

const paymentMethodOptions = [
  { label: '现金', value: 'cash' },
  { label: '银行卡', value: 'card' },
  { label: '支付宝', value: 'alipay' },
  { label: '微信', value: 'wechat' }
]

const paymentRecordStatusOptions = [
  { label: '成功', value: 'success' },
  { label: '失败', value: 'failed' },
  { label: '已取消', value: 'cancelled' }
]

const housekeepingTypeOptions = [
  { label: '日常清扫', value: 'daily_cleaning' },
  { label: '退房清扫', value: 'checkout_cleaning' },
  { label: '深度清扫', value: 'deep_cleaning' }
]

const housekeepingStatusOptions = [
  { label: '待处理', value: 'pending' },
  { label: '已分配', value: 'assigned' },
  { label: '进行中', value: 'in_progress' },
  { label: '已完成', value: 'completed' },
  { label: '已取消', value: 'cancelled' }
]

const maintenanceStatusOptions = [
  { label: '已上报', value: 'reported' },
  { label: '处理中', value: 'processing' },
  { label: '已完成', value: 'completed' },
  { label: '已取消', value: 'cancelled' }
]

const checkinStatusOptions = [
  { label: '入住中', value: 'checked_in' },
  { label: '已退房', value: 'checked_out' },
  { label: '已取消', value: 'cancelled' }
]

const performanceGradeOptions = [
  { label: 'A', value: 'A' },
  { label: 'B', value: 'B' },
  { label: 'C', value: 'C' },
  { label: 'D', value: 'D' }
]

const reviewScoreOptions = [1, 2, 3, 4, 5].map(item => ({ label: `${item} 分`, value: item }))

function relation(label, optionSource, optionLabelFields, extra = {}) {
  return Object.assign({
    label,
    type: 'select',
    optionSource,
    optionValueField: 'id',
    optionLabelFields
  }, extra)
}

const modules = {
  hotel_profile: {
    title: '酒店简介',
    description: '维护酒店基本资料、星级、地址、服务电话与对外展示介绍。',
    searchFields: ['jiudianmingcheng', 'leibie', 'xingji'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      { prop: 'addtime', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'jiudianmingcheng', label: '酒店名称', required: true },
      { prop: 'leibie', label: '类别', required: true },
      { prop: 'xingji', label: '星级', required: true },
      { prop: 'jiudiantupian', label: '酒店图片', type: 'image' },
      { prop: 'jiudiandizhi', label: '酒店地址' },
      { prop: 'fuwurexian', label: '服务热线' },
      { prop: 'jiudianjieshao', label: '酒店介绍', type: 'textarea', tableWidth: 260 },
      { prop: 'review_count', label: '评论数', type: 'number', readonly: true },
      { prop: 'avg_score', label: '平均评分', type: 'number', readonly: true }
    ]
  },
  notice: {
    title: '酒店公告',
    description: '维护后台公告、服务通知和运营提示信息。',
    searchFields: ['title'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      { prop: 'addtime', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'title', label: '标题', required: true },
      { prop: 'introduction', label: '简介', type: 'textarea', tableWidth: 220 },
      { prop: 'picture', label: '封面图片', type: 'image' },
      { prop: 'content', label: '公告内容', type: 'textarea', required: true, tableWidth: 280 }
    ]
  },
  system_config: {
    title: '系统参数',
    description: '维护轮播图与系统级配置项。',
    searchFields: ['name'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      { prop: 'name', label: '参数名', required: true },
      { prop: 'value', label: '参数值', required: true, tableWidth: 260 }
    ]
  },
  customer: {
    title: '客户档案',
    description: '管理客户账号、实名信息、联系方式与基础画像。',
    extraPageActions: [
      {
        key: 'customer-report',
        label: '客户消费统计',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'report', tool: 'customerConsumptionReport' }
      }
    ],
    searchFields: ['customerming', 'xingming', 'shoujihao'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      { prop: 'addtime', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'customerming', label: '客户账号', required: true },
      { prop: 'xingming', label: '姓名', required: true },
      { prop: 'mima', label: '密码', type: 'password', required: true, table: false },
      { prop: 'xingbie', label: '性别', type: 'select', options: genderOptions },
      { prop: 'nianling', label: '年龄', type: 'number' },
      { prop: 'shoujihao', label: '手机号' }
    ]
  },
  employee: {
    title: '员工档案',
    description: '维护前台、客房与维修人员档案，为入住、清扫、维修和考核流程提供基础数据。',
    extraPageActions: [
      {
        key: 'employee-performance-report',
        label: '员工绩效统计',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'report', tool: 'employeePerformanceReport' }
      },
      {
        key: 'employee-assessment',
        label: '生成员工考核',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'report', tool: 'generateEmployeeAssessment' }
      }
    ],
    searchFields: ['employeegonghao', 'employeexingming', 'zhiwei'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      { prop: 'addtime', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'employeegonghao', label: '员工工号', required: true },
      { prop: 'employeexingming', label: '员工姓名', required: true },
      { prop: 'mima', label: '密码', type: 'password', required: true, table: false },
      { prop: 'xingbie', label: '性别', type: 'select', options: genderOptions },
      { prop: 'lianxidianhua', label: '联系电话' },
      { prop: 'touxiang', label: '头像', type: 'image' },
      { prop: 'ruzhishijian', label: '入职时间', type: 'date' },
      { prop: 'zhiwei', label: '职位' }
    ]
  },
  room_category: {
    title: '客房类型',
    description: '维护标准间、套房等客房类型，用于客房目录与价格策略。',
    searchFields: ['room_category'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      { prop: 'addtime', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'room_category', label: '客房类型', required: true }
    ]
  },
  room_catalog: {
    title: '客房目录',
    description: '维护客房商品层信息，包括房型、价格、酒店归属、设施与展示内容。',
    extraPageActions: [
      {
        key: 'available-rooms',
        label: '可用房源检索',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'booking', tool: 'availableRooms' }
      },
      {
        key: 'create-booking',
        label: '存储过程创建预订',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'booking', tool: 'createBooking' }
      }
    ],
    searchFields: ['kefangmingcheng', 'room_category', 'jiudianmingcheng'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      { prop: 'addtime', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'kefangmingcheng', label: '客房名称', required: true },
      { prop: 'room_category', label: '客房类型名称', required: true },
      relation('客房类型ID', 'room_category', ['room_category'], { prop: 'room_category_id', required: true }),
      relation('所属酒店', 'hotel_profile', ['jiudianmingcheng'], { prop: 'hotel_profile_id' }),
      { prop: 'kefangtupian', label: '客房图片', type: 'image', required: true },
      { prop: 'kefangjiage', label: '基础价格', type: 'number', required: true },
      { prop: 'shuliang', label: '房间数量', type: 'number' },
      { prop: 'jiudianmingcheng', label: '酒店名称' },
      { prop: 'jiudiandizhi', label: '酒店地址' },
      { prop: 'kefangsheshi', label: '客房设施', type: 'textarea', tableWidth: 240 },
      { prop: 'kefangjieshao', label: '客房介绍', type: 'textarea', tableWidth: 260 },
      { prop: 'clicknum', label: '点击量', type: 'number' },
      { prop: 'review_count', label: '评论数', type: 'number', readonly: true },
      { prop: 'avg_score', label: '平均评分', type: 'number', readonly: true }
    ]
  },
  room_instance: {
    title: '实体客房',
    description: '维护具体房号、楼层和当前房态，是预约、入住、清扫与维修的核心资源表。',
    sort: 'updated_at',
    extraPageActions: [
      {
        key: 'batch-room-status',
        label: '批量房态调整',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'service', tool: 'batchUpdateRoomStatus' }
      },
      {
        key: 'create-housekeeping',
        label: '创建清扫任务',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'service', tool: 'createHousekeepingTask' }
      },
      {
        key: 'report-maintenance',
        label: '上报维修',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'service', tool: 'reportMaintenance' }
      }
    ],
    searchFields: ['room_no', 'status'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('客房目录', 'room_catalog', ['kefangmingcheng', 'room_category'], { prop: 'room_catalog_id', required: true }),
      { prop: 'room_no', label: '房号', required: true },
      { prop: 'floor_no', label: '楼层', type: 'number', required: true },
      { prop: 'status', label: '房态', type: 'select', options: roomStatusOptions, required: true },
      { prop: 'created_at', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'updated_at', label: '更新时间', type: 'datetime', readonly: true }
    ]
  },
  price_policy: {
    title: '价格策略',
    description: '维护不同日期区间下的房价策略与倍率，支持动态定价演示。',
    searchFields: ['policy_name'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('客房目录', 'room_catalog', ['kefangmingcheng', 'room_category'], { prop: 'room_catalog_id', required: true }),
      { prop: 'policy_name', label: '策略名称', required: true },
      { prop: 'start_date', label: '开始日期', type: 'date', required: true },
      { prop: 'end_date', label: '结束日期', type: 'date', required: true },
      { prop: 'price_multiplier', label: '价格倍率', type: 'number', required: true },
      { prop: 'priority', label: '优先级', type: 'number' },
      { prop: 'enabled', label: '启用状态', type: 'select', options: yesNoOptions, required: true }
    ]
  },
  room_status_log: {
    title: '房态日志',
    description: '记录房态流转的前后状态、业务来源和处理说明。',
    readonlyModule: true,
    searchFields: ['new_status', 'source_type'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('房间', 'room_instance', ['room_no'], { prop: 'room_id', readonly: true }),
      { prop: 'old_status', label: '原状态', type: 'select', options: roomStatusOptions, readonly: true },
      { prop: 'new_status', label: '新状态', type: 'select', options: roomStatusOptions, readonly: true },
      { prop: 'source_type', label: '来源业务', readonly: true },
      { prop: 'source_id', label: '来源编号', readonly: true },
      relation('操作员工', 'employee', ['employeegonghao', 'employeexingming'], { prop: 'operator_id', readonly: true }),
      { prop: 'remark', label: '备注', type: 'textarea', readonly: true, tableWidth: 260 },
      { prop: 'created_at', label: '记录时间', type: 'datetime', readonly: true }
    ]
  },
  booking_order: {
    title: '预订订单',
    description: '查看客户预订主单、支付状态、计划入住离店日期和订单状态。',
    readonlyModule: true,
    extraPageActions: [
      {
        key: 'proc-create-booking',
        label: '存储过程创建预订',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'booking', tool: 'createBooking' }
      },
      {
        key: 'proc-confirm-checkin',
        label: '存储过程办理入住',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'checkin', tool: 'confirmCheckin' }
      }
    ],
    extraRowActions: [
      {
        key: 'flow',
        label: '订单与入住人',
        type: 'warning',
        routeName: 'booking_flow',
        buildQuery: row => ({
          bookingId: row.id,
          bookingNo: row.yudingbianhao
        })
      },
      {
        key: 'proc-checkin',
        label: '存储过程入住',
        type: 'warning',
        routeName: 'procedure_center',
        buildQuery: row => ({
          tab: 'checkin',
          tool: 'confirmCheckin',
          bookingId: row.id,
          guestName: row.xingming,
          phone: row.shoujihao
        })
      }
    ],
    searchFields: ['yudingbianhao', 'customerming', 'room_category', 'booking_status'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      { prop: 'addtime', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'yudingbianhao', label: '预订编号', readonly: true },
      { prop: 'kefangmingcheng', label: '客房名称', readonly: true },
      { prop: 'room_category', label: '客房类型', readonly: true },
      { prop: 'kefangjiage', label: '单价', type: 'number', readonly: true },
      { prop: 'shuliang', label: '数量', type: 'number', readonly: true },
      { prop: 'zongjine', label: '总金额', type: 'number', readonly: true },
      { prop: 'jiudianmingcheng', label: '酒店名称', readonly: true },
      { prop: 'customerming', label: '客户账号', readonly: true },
      { prop: 'xingming', label: '客户姓名', readonly: true },
      { prop: 'shoujihao', label: '手机号', readonly: true },
      relation('客户ID', 'customer', ['customerming', 'xingming'], { prop: 'customer_id', readonly: true }),
      relation('客房目录', 'room_catalog', ['kefangmingcheng', 'room_category'], { prop: 'room_catalog_id', readonly: true }),
      relation('锁定房间', 'room_instance', ['room_no'], { prop: 'room_instance_id', readonly: true }),
      { prop: 'yudingriqi', label: '预订日期', type: 'date', readonly: true },
      { prop: 'expected_checkin_date', label: '预计入住', type: 'date', readonly: true },
      { prop: 'expected_checkout_date', label: '预计离店', type: 'date', readonly: true },
      { prop: 'ispay', label: '支付状态', type: 'select', options: payStatusOptions, readonly: true },
      { prop: 'booking_status', label: '订单状态', type: 'select', options: bookingStatusOptions, readonly: true },
      { prop: 'kefangtupian', label: '客房图片', type: 'image', readonly: true, table: false },
      { prop: 'jiudiandizhi', label: '酒店地址', readonly: true, table: false }
    ]
  },
  booking_room: {
    title: '订单房间明细',
    description: '展示一个订单拆分出的具体房间明细，支撑一客多单、一单多房演示。',
    readonlyModule: true,
    searchFields: ['room_status'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('订单', 'booking_order', ['yudingbianhao'], { prop: 'booking_id', readonly: true }),
      relation('房间', 'room_instance', ['room_no'], { prop: 'room_id', readonly: true }),
      { prop: 'room_price', label: '锁定单价', type: 'number', readonly: true },
      { prop: 'stay_start_date', label: '入住日期', type: 'date', readonly: true },
      { prop: 'stay_end_date', label: '离店日期', type: 'date', readonly: true },
      { prop: 'room_status', label: '房间状态', type: 'select', options: bookingStatusOptions, readonly: true },
      { prop: 'created_at', label: '创建时间', type: 'datetime', readonly: true }
    ]
  },
  booking_guest: {
    title: '预订入住人',
    description: '维护订单下计划入住的主入住人和同行人身份信息，支撑预订到入住的实名链路。',
    searchFields: ['guest_name', 'phone'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('订单', 'booking_order', ['yudingbianhao'], { prop: 'booking_id', required: true }),
      { prop: 'guest_name', label: '入住人姓名', required: true },
      { prop: 'id_card_no', label: '身份证号' },
      { prop: 'phone', label: '联系电话' },
      { prop: 'is_primary', label: '主入住人', type: 'select', options: yesNoOptions, required: true },
      { prop: 'created_at', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'updated_at', label: '更新时间', type: 'datetime', readonly: true }
    ]
  },
  checkin_assignment: {
    title: '入住安排',
    description: '保留原型中的入住安排清单，用于和规范化入住记录进行对照演示。',
    readonlyModule: true,
    searchFields: ['yudingbianhao', 'customerming', 'fangjianhao'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      { prop: 'addtime', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'yudingbianhao', label: '预订编号', readonly: true },
      { prop: 'jiudianmingcheng', label: '酒店名称', readonly: true },
      { prop: 'fangjianleixing', label: '房间类型', readonly: true },
      { prop: 'shuliang', label: '数量', type: 'number', readonly: true },
      { prop: 'customerming', label: '客户账号', readonly: true },
      { prop: 'xingming', label: '客户姓名', readonly: true },
      { prop: 'shoujihao', label: '手机号', readonly: true },
      { prop: 'fangjianhao', label: '房间号', readonly: true },
      { prop: 'crossuserid', label: '关联客户ID', readonly: true },
      { prop: 'crossrefid', label: '关联订单ID', readonly: true }
    ]
  },
  checkin_record: {
    title: '入住记录',
    description: '维护实际入住流水，记录订单、房间、客户、办理员工与入住状态。',
    extraPageActions: [
      {
        key: 'proc-confirm-checkin-page',
        label: '存储过程办理入住',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'checkin', tool: 'confirmCheckin' }
      },
      {
        key: 'proc-checkout-page',
        label: '生成退房账单',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'checkin', tool: 'generateCheckoutBill' }
      }
    ],
    extraRowActions: [
      {
        key: 'proc-checkout',
        label: '退房结算',
        type: 'warning',
        routeName: 'procedure_center',
        buildQuery: row => ({
          tab: 'checkin',
          tool: 'generateCheckoutBill',
          checkinId: row.id,
          employeeId: row.employee_id
        })
      }
    ],
    searchFields: ['status'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('订单', 'booking_order', ['yudingbianhao'], { prop: 'booking_id' }),
      relation('房间', 'room_instance', ['room_no'], { prop: 'room_id', required: true }),
      relation('客户', 'customer', ['customerming', 'xingming'], { prop: 'customer_id' }),
      relation('办理员工', 'employee', ['employeegonghao', 'employeexingming'], { prop: 'employee_id' }),
      { prop: 'checkin_time', label: '入住时间', type: 'datetime', required: true },
      { prop: 'checkout_time', label: '离店时间', type: 'datetime' },
      { prop: 'status', label: '状态', type: 'select', options: checkinStatusOptions, required: true },
      { prop: 'remark', label: '备注', type: 'textarea', tableWidth: 240 }
    ]
  },
  checkin_guest: {
    title: '同住人信息',
    description: '维护入住记录下的同住人实名信息和主客标记。',
    searchFields: ['guest_name', 'phone'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('入住记录', 'checkin_record', ['id'], { prop: 'checkin_id', required: true }),
      { prop: 'guest_name', label: '入住人姓名', required: true },
      { prop: 'id_card_no', label: '身份证号' },
      { prop: 'phone', label: '联系电话' },
      { prop: 'is_primary', label: '主入住人', type: 'select', options: yesNoOptions, required: true },
      { prop: 'created_at', label: '创建时间', type: 'datetime', readonly: true }
    ]
  },
  bill: {
    title: '账单台账',
    description: '查看入住与退房环节产生的账单、应收、实收与退款信息。',
    readonlyModule: true,
    extraPageActions: [
      {
        key: 'proc-pay-bill-page',
        label: '登记收款',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'checkin', tool: 'payBill' }
      }
    ],
    extraRowActions: [
      {
        key: 'proc-pay-bill',
        label: '登记收款',
        type: 'warning',
        routeName: 'procedure_center',
        buildQuery: row => ({
          tab: 'checkin',
          tool: 'payBill',
          billId: row.id,
          payAmount: Math.max(Number(row.payable_amount || 0) - Number(row.paid_amount || 0), 0)
        })
      }
    ],
    searchFields: ['status'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('订单', 'booking_order', ['yudingbianhao'], { prop: 'booking_id', readonly: true }),
      relation('入住记录', 'checkin_record', ['id'], { prop: 'checkin_id', readonly: true }),
      relation('客户', 'customer', ['customerming', 'xingming'], { prop: 'customer_id', readonly: true }),
      { prop: 'room_amount', label: '房费', type: 'number', readonly: true },
      { prop: 'service_amount', label: '服务费', type: 'number', readonly: true },
      { prop: 'discount_amount', label: '优惠金额', type: 'number', readonly: true },
      { prop: 'payable_amount', label: '应收金额', type: 'number', readonly: true },
      { prop: 'paid_amount', label: '实收金额', type: 'number', readonly: true },
      { prop: 'refund_amount', label: '退款金额', type: 'number', readonly: true },
      { prop: 'status', label: '账单状态', type: 'select', options: payStatusOptions, readonly: true },
      { prop: 'created_at', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'updated_at', label: '更新时间', type: 'datetime', readonly: true }
    ]
  },
  payment_record: {
    title: '支付记录',
    description: '维护账单支付流水，支持现金、银行卡、支付宝和微信等方式。',
    readonlyModule: true,
    searchFields: ['payment_no', 'pay_method', 'pay_status'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('账单', 'bill', ['id'], { prop: 'bill_id', readonly: true }),
      { prop: 'payment_no', label: '支付单号', readonly: true },
      { prop: 'pay_method', label: '支付方式', type: 'select', options: paymentMethodOptions, readonly: true },
      { prop: 'pay_amount', label: '支付金额', type: 'number', readonly: true },
      { prop: 'pay_status', label: '支付状态', type: 'select', options: paymentRecordStatusOptions, readonly: true },
      { prop: 'paid_at', label: '支付时间', type: 'datetime', readonly: true },
      { prop: 'remark', label: '备注', type: 'textarea', readonly: true, tableWidth: 240 }
    ]
  },
  refund_record: {
    title: '退款记录',
    description: '查看支付退款流水、退款原因与处理状态。',
    readonlyModule: true,
    searchFields: ['refund_no', 'refund_status'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('支付记录', 'payment_record', ['payment_no'], { prop: 'payment_id', readonly: true }),
      { prop: 'refund_no', label: '退款单号', readonly: true },
      { prop: 'refund_amount', label: '退款金额', type: 'number', readonly: true },
      { prop: 'refund_reason', label: '退款原因', type: 'textarea', readonly: true, tableWidth: 240 },
      { prop: 'refund_status', label: '退款状态', type: 'select', options: paymentRecordStatusOptions, readonly: true },
      { prop: 'created_at', label: '创建时间', type: 'datetime', readonly: true }
    ]
  },
  favorite: {
    title: '收藏记录',
    description: '查看客户收藏的客房和酒店条目，支撑前台“我的收藏”功能。',
    searchFields: ['tablename', 'name', 'type'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      { prop: 'addtime', label: '收藏时间', type: 'datetime', readonly: true },
      relation('客户', 'customer', ['customerming', 'xingming'], { prop: 'userid', readonly: true }),
      { prop: 'tablename', label: '收藏对象表', readonly: true },
      { prop: 'refid', label: '对象ID', readonly: true },
      { prop: 'name', label: '收藏名称', readonly: true, tableWidth: 220 },
      { prop: 'picture', label: '封面图片', type: 'image', readonly: true },
      { prop: 'type', label: '收藏类型', readonly: true },
      { prop: 'inteltype', label: '补充标记', readonly: true }
    ]
  },
  housekeeping_task: {
    title: '清扫任务',
    description: '管理客房清扫任务、执行员工、计划时间与完成状态。',
    extraPageActions: [
      {
        key: 'proc-housekeeping-page',
        label: '创建清扫任务',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'service', tool: 'createHousekeepingTask' }
      }
    ],
    extraRowActions: [
      {
        key: 'proc-housekeeping',
        label: '新建同类任务',
        type: 'warning',
        routeName: 'procedure_center',
        buildQuery: row => ({
          tab: 'service',
          tool: 'createHousekeepingTask',
          roomId: row.room_id,
          employeeId: row.assigned_employee_id,
          taskType: row.task_type
        })
      }
    ],
    searchFields: ['task_type', 'task_status'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('房间', 'room_instance', ['room_no'], { prop: 'room_id', required: true }),
      relation('来源入住', 'checkin_record', ['id'], { prop: 'checkin_id' }),
      relation('执行员工', 'employee', ['employeegonghao', 'employeexingming'], { prop: 'assigned_employee_id' }),
      { prop: 'task_type', label: '任务类型', type: 'select', options: housekeepingTypeOptions, required: true },
      { prop: 'task_status', label: '任务状态', type: 'select', options: housekeepingStatusOptions, required: true },
      { prop: 'scheduled_time', label: '计划时间', type: 'datetime' },
      { prop: 'completed_time', label: '完成时间', type: 'datetime' },
      { prop: 'remark', label: '备注', type: 'textarea', tableWidth: 240 },
      { prop: 'created_at', label: '创建时间', type: 'datetime', readonly: true },
      { prop: 'updated_at', label: '更新时间', type: 'datetime', readonly: true }
    ]
  },
  maintenance_record: {
    title: '维修记录',
    description: '管理房间报修、处理员工、维修状态、维修成本与备注。',
    extraPageActions: [
      {
        key: 'proc-maintenance-page',
        label: '上报维修',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'service', tool: 'reportMaintenance' }
      }
    ],
    searchFields: ['maintenance_status', 'issue_desc'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('房间', 'room_instance', ['room_no'], { prop: 'room_id', required: true }),
      relation('报修员工', 'employee', ['employeegonghao', 'employeexingming'], { prop: 'reported_by_employee_id' }),
      relation('处理员工', 'employee', ['employeegonghao', 'employeexingming'], { prop: 'handled_by_employee_id' }),
      { prop: 'issue_desc', label: '故障描述', type: 'textarea', required: true, tableWidth: 260 },
      { prop: 'maintenance_status', label: '维修状态', type: 'select', options: maintenanceStatusOptions, required: true },
      { prop: 'start_time', label: '开始时间', type: 'datetime', required: true },
      { prop: 'end_time', label: '结束时间', type: 'datetime' },
      { prop: 'cost_amount', label: '维修成本', type: 'number' },
      { prop: 'remark', label: '备注', type: 'textarea', tableWidth: 240 }
    ]
  },
  employee_performance: {
    title: '员工考核',
    description: '展示员工在考核周期内的业务量、管理加分、总分与等级。',
    readonlyModule: true,
    extraPageActions: [
      {
        key: 'proc-performance-report-page',
        label: '员工绩效统计',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'report', tool: 'employeePerformanceReport' }
      },
      {
        key: 'proc-assessment-page',
        label: '生成员工考核',
        type: 'warning',
        routeName: 'procedure_center',
        query: { tab: 'report', tool: 'generateEmployeeAssessment' }
      }
    ],
    searchFields: ['grade'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('员工', 'employee', ['employeegonghao', 'employeexingming'], { prop: 'employee_id', readonly: true }),
      relation('考核人', 'employee', ['employeegonghao', 'employeexingming'], { prop: 'assessor_id', readonly: true }),
      { prop: 'period_start', label: '开始日期', type: 'date', readonly: true },
      { prop: 'period_end', label: '结束日期', type: 'date', readonly: true },
      { prop: 'checkin_count', label: '入住办理', type: 'number', readonly: true },
      { prop: 'bill_count', label: '账单数', type: 'number', readonly: true },
      { prop: 'payment_count', label: '支付数', type: 'number', readonly: true },
      { prop: 'cleaning_count', label: '清扫数', type: 'number', readonly: true },
      { prop: 'maintenance_count', label: '维修数', type: 'number', readonly: true },
      { prop: 'operation_count', label: '操作数', type: 'number', readonly: true },
      { prop: 'manager_score', label: '管理加分', type: 'number', readonly: true },
      { prop: 'total_score', label: '总分', type: 'number', readonly: true },
      { prop: 'grade', label: '等级', type: 'select', options: performanceGradeOptions, readonly: true },
      { prop: 'remark', label: '备注', type: 'textarea', readonly: true, tableWidth: 240 },
      { prop: 'created_at', label: '创建时间', type: 'datetime', readonly: true }
    ]
  },
  booking_status_log: {
    title: '订单状态日志',
    description: '记录预订订单在创建、入住、取消、完成等生命周期中的状态变化。',
    readonlyModule: true,
    searchFields: ['new_status'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('订单', 'booking_order', ['yudingbianhao'], { prop: 'booking_id', readonly: true }),
      { prop: 'old_status', label: '原状态', type: 'select', options: bookingStatusOptions, readonly: true },
      { prop: 'new_status', label: '新状态', type: 'select', options: bookingStatusOptions, readonly: true },
      relation('操作员工', 'employee', ['employeegonghao', 'employeexingming'], { prop: 'operator_id', readonly: true }),
      { prop: 'remark', label: '备注', type: 'textarea', readonly: true, tableWidth: 240 },
      { prop: 'created_at', label: '记录时间', type: 'datetime', readonly: true }
    ]
  },
  operation_log: {
    title: '操作日志',
    description: '记录系统初始化、客房、预订、清扫、维修等关键业务动作。',
    readonlyModule: true,
    searchFields: ['operator_type', 'business_type', 'action'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      { prop: 'operator_type', label: '操作方类型', readonly: true },
      { prop: 'operator_id', label: '操作方ID', readonly: true },
      { prop: 'business_type', label: '业务类型', readonly: true },
      { prop: 'business_id', label: '业务编号', readonly: true },
      { prop: 'action', label: '动作', readonly: true },
      { prop: 'remark', label: '备注', type: 'textarea', readonly: true, tableWidth: 240 },
      { prop: 'created_at', label: '记录时间', type: 'datetime', readonly: true }
    ]
  },
  hotel_review: {
    title: '酒店评价',
    description: '查看客户对酒店简介的评价、回复与评分。',
    searchFields: ['nickname'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('酒店', 'hotel_profile', ['jiudianmingcheng'], { prop: 'refid', readonly: true }),
      relation('用户', 'customer', ['customerming', 'xingming'], { prop: 'userid', readonly: true }),
      { prop: 'nickname', label: '评价账号', readonly: true },
      { prop: 'content', label: '评价内容', type: 'textarea', readonly: true, tableWidth: 260 },
      { prop: 'reply', label: '回复内容', type: 'textarea', tableWidth: 240 },
      { prop: 'score', label: '评分', type: 'select', options: reviewScoreOptions, readonly: true },
      { prop: 'addtime', label: '创建时间', type: 'datetime', readonly: true }
    ]
  },
  room_review: {
    title: '客房评价',
    description: '查看客户对客房的评价、回复与评分。',
    searchFields: ['nickname'],
    fields: [
      { prop: 'id', label: 'ID', tableWidth: 80, readonly: true },
      relation('客房目录', 'room_catalog', ['kefangmingcheng', 'room_category'], { prop: 'refid', readonly: true }),
      relation('用户', 'customer', ['customerming', 'xingming'], { prop: 'userid', readonly: true }),
      { prop: 'nickname', label: '评价账号', readonly: true },
      { prop: 'content', label: '评价内容', type: 'textarea', readonly: true, tableWidth: 260 },
      { prop: 'reply', label: '回复内容', type: 'textarea', tableWidth: 240 },
      { prop: 'score', label: '评分', type: 'select', options: reviewScoreOptions, readonly: true },
      { prop: 'addtime', label: '创建时间', type: 'datetime', readonly: true }
    ]
  }
}

Object.assign(modules, {
  v_bill_payment_summary: {
    title: '账单支付汇总',
    description: '查看账单应收、实收、退款与最近支付时间。',
    readonlyModule: true,
    searchFields: ['customer_name', 'bill_status'],
    fields: [
      { prop: 'bill_id', label: '账单ID', tableWidth: 90, readonly: true },
      { prop: 'booking_id', label: '订单ID', tableWidth: 90, readonly: true },
      { prop: 'checkin_id', label: '入住ID', tableWidth: 90, readonly: true },
      { prop: 'customer_id', label: '客户ID', tableWidth: 90, readonly: true },
      { prop: 'customer_name', label: '客户姓名', readonly: true },
      { prop: 'room_amount', label: '房费金额', type: 'number', readonly: true },
      { prop: 'service_amount', label: '服务费', type: 'number', readonly: true },
      { prop: 'discount_amount', label: '优惠金额', type: 'number', readonly: true },
      { prop: 'payable_amount', label: '应收金额', type: 'number', readonly: true },
      { prop: 'actual_paid_amount', label: '实收金额', type: 'number', readonly: true },
      { prop: 'actual_refund_amount', label: '退款金额', type: 'number', readonly: true },
      { prop: 'bill_status', label: '账单状态', type: 'select', options: payStatusOptions, readonly: true },
      { prop: 'last_paid_at', label: '最近支付时间', type: 'datetime', tableWidth: 168, readonly: true },
      { prop: 'created_at', label: '创建时间', type: 'datetime', tableWidth: 168, readonly: true }
    ]
  },
  v_booking_detail: {
    title: '预订明细',
    description: '按客户、订单和房型查看预订明细与计划入住时间。',
    readonlyModule: true,
    searchFields: ['booking_no', 'customer_login_name', 'customer_real_name', 'room_category', 'booking_status'],
    fields: [
      { prop: 'booking_id', label: '订单ID', tableWidth: 90, readonly: true },
      { prop: 'booking_no', label: '订单单号', tableWidth: 160, readonly: true },
      { prop: 'booking_time', label: '下单时间', type: 'datetime', tableWidth: 168, readonly: true },
      { prop: 'customer_login_name', label: '客户账号', readonly: true },
      { prop: 'customer_real_name', label: '客户姓名', readonly: true },
      { prop: 'customer_phone', label: '手机号', readonly: true },
      { prop: 'room_name', label: '客房名称', readonly: true },
      { prop: 'room_category', label: '房型', readonly: true },
      { prop: 'room_numbers', label: '房号', tableWidth: 180, readonly: true },
      { prop: 'expected_checkin_date', label: '预计入住', type: 'date', readonly: true },
      { prop: 'expected_checkout_date', label: '预计离店', type: 'date', readonly: true },
      { prop: 'unit_price', label: '单价', type: 'number', readonly: true },
      { prop: 'quantity', label: '数量', type: 'number', readonly: true },
      { prop: 'total_amount', label: '总金额', type: 'number', readonly: true },
      { prop: 'old_payment_status', label: '支付状态', type: 'select', options: payStatusOptions, readonly: true },
      { prop: 'booking_status', label: '订单状态', type: 'select', options: bookingStatusOptions, readonly: true },
      { prop: 'status_change_count', label: '状态变更次数', type: 'number', readonly: true },
      { prop: 'last_status_time', label: '最近状态时间', type: 'datetime', tableWidth: 168, readonly: true }
    ]
  },
  v_checkin_guest_detail: {
    title: '入住客人明细',
    description: '查看客户入住、退房和同住人情况。',
    readonlyModule: true,
    searchFields: ['customer_name', 'room_no', 'checkin_status'],
    fields: [
      { prop: 'checkin_id', label: '入住ID', tableWidth: 90, readonly: true },
      { prop: 'booking_id', label: '订单ID', tableWidth: 90, readonly: true },
      { prop: 'customer_id', label: '客户ID', tableWidth: 90, readonly: true },
      { prop: 'customer_name', label: '客户姓名', readonly: true },
      { prop: 'room_no', label: '房号', readonly: true },
      { prop: 'room_name', label: '客房名称', readonly: true },
      { prop: 'room_category', label: '房型', readonly: true },
      { prop: 'checkin_time', label: '入住时间', type: 'datetime', tableWidth: 168, readonly: true },
      { prop: 'checkout_time', label: '离店时间', type: 'datetime', tableWidth: 168, readonly: true },
      { prop: 'checkin_status', label: '入住状态', type: 'select', options: checkinStatusOptions, readonly: true },
      { prop: 'primary_guest_name', label: '主入住人', readonly: true },
      { prop: 'guest_count', label: '入住人数', type: 'number', readonly: true },
      { prop: 'employee_name', label: '办理员工', readonly: true }
    ]
  },
  v_customer_value_profile: {
    title: '客户画像',
    description: '查看客户预订次数、入住次数、消费金额与最近下单时间。',
    readonlyModule: true,
    searchFields: ['customer_login_name', 'customer_name', 'customer_phone'],
    fields: [
      { prop: 'customer_id', label: '客户ID', tableWidth: 90, readonly: true },
      { prop: 'customer_login_name', label: '客户账号', readonly: true },
      { prop: 'customer_name', label: '客户姓名', readonly: true },
      { prop: 'customer_phone', label: '手机号', readonly: true },
      { prop: 'booking_count', label: '订单数', type: 'number', readonly: true },
      { prop: 'checkin_count', label: '入住次数', type: 'number', readonly: true },
      { prop: 'total_payable_amount', label: '累计应收', type: 'number', readonly: true },
      { prop: 'total_paid_amount', label: '累计实收', type: 'number', readonly: true },
      { prop: 'favorite_count', label: '收藏数', type: 'number', readonly: true },
      { prop: 'room_review_count', label: '客房评价数', type: 'number', readonly: true },
      { prop: 'hotel_review_count', label: '酒店评价数', type: 'number', readonly: true },
      { prop: 'last_booking_time', label: '最近下单时间', type: 'datetime', tableWidth: 168, readonly: true }
    ]
  },
  v_housekeeping_task_detail: {
    title: '清扫任务明细',
    description: '按房号查看清扫任务、计划时间和完成情况。',
    readonlyModule: true,
    searchFields: ['task_type', 'task_status', 'room_no'],
    fields: [
      { prop: 'task_id', label: '任务ID', tableWidth: 90, readonly: true },
      { prop: 'task_type', label: '任务类型', type: 'select', options: housekeepingTypeOptions, readonly: true },
      { prop: 'task_status', label: '任务状态', type: 'select', options: housekeepingStatusOptions, readonly: true },
      { prop: 'scheduled_time', label: '计划时间', type: 'datetime', tableWidth: 168, readonly: true },
      { prop: 'completed_time', label: '完成时间', type: 'datetime', tableWidth: 168, readonly: true },
      { prop: 'room_no', label: '房号', readonly: true },
      { prop: 'room_status', label: '房态', type: 'select', options: roomStatusOptions, readonly: true },
      { prop: 'room_name', label: '客房名称', readonly: true },
      { prop: 'room_category', label: '房型', readonly: true },
      { prop: 'booking_id', label: '关联订单', tableWidth: 100, readonly: true },
      { prop: 'assigned_employee_name', label: '执行员工', readonly: true },
      { prop: 'remark', label: '备注', type: 'textarea', tableWidth: 240, readonly: true },
      { prop: 'created_at', label: '创建时间', type: 'datetime', tableWidth: 168, readonly: true }
    ]
  }
})

export function getModuleConfig(moduleKey) {
  const module = modules[moduleKey]
  if (!module) {
    return null
  }
  return {
    tableName: moduleKey,
    sort: 'id',
    pageSize: 10,
    ...module
  }
}

export function getOptionLabel(row, labelFields = []) {
  if (!row) {
    return ''
  }
  const values = labelFields
    .map(field => row[field])
    .filter(value => value !== undefined && value !== null && value !== '')
  return values.length ? values.join(' / ') : String(row.id || '')
}

export default modules

