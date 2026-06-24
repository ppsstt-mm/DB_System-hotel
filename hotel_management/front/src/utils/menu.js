const menu = {
  list() {
    return [{
      roleName: '管理员',
      tableName: 'admin_user',
      hasBackLogin: '是',
      hasBackRegister: '否',
      hasFrontLogin: '否',
      hasFrontRegister: '否',
      frontMenu: [],
      backMenu: [{
        menu: '基础资料管理',
        child: [
          { appFrontIcon: 'cuIcon-circle', buttons: ['新增', '查看', '修改', '删除'], menu: '酒店简介', tableName: 'hotel_profile' },
          { appFrontIcon: 'cuIcon-notice', buttons: ['新增', '查看', '修改', '删除'], menu: '酒店公告', tableName: 'notice' },
          { appFrontIcon: 'cuIcon-attentionfavor', buttons: ['新增', '查看', '修改', '删除'], menu: '系统参数', tableName: 'system_config' },
          { appFrontIcon: 'cuIcon-similar', buttons: ['新增', '查看', '修改', '删除'], menu: '员工档案', tableName: 'employee' }
        ]
      }, {
        menu: '客户运营',
        child: [
          { appFrontIcon: 'cuIcon-wenzi', buttons: ['新增', '查看', '修改', '删除'], menu: '客户档案', tableName: 'customer' },
          { appFrontIcon: 'cuIcon-favorfill', buttons: ['查看', '删除'], menu: '收藏记录', tableName: 'favorite' },
          { appFrontIcon: 'cuIcon-group', buttons: ['查看'], menu: '客户画像', tableName: 'v_customer_value_profile' },
          { appFrontIcon: 'cuIcon-form', buttons: ['查看'], menu: '预订明细', tableName: 'v_booking_detail' },
          { appFrontIcon: 'cuIcon-peoplefill', buttons: ['查看'], menu: '入住客人明细', tableName: 'v_checkin_guest_detail' }
        ]
      }, {
        menu: '客房资源管理',
        child: [
          { appFrontIcon: 'cuIcon-flashlightopen', buttons: ['新增', '查看', '修改', '删除'], menu: '客房类型', tableName: 'room_category' },
          { appFrontIcon: 'cuIcon-keyboard', buttons: ['新增', '查看', '修改', '删除'], menu: '客房目录', tableName: 'room_catalog' },
          { appFrontIcon: 'cuIcon-rank', buttons: ['新增', '查看', '修改', '删除'], menu: '实体客房', tableName: 'room_instance' },
          { appFrontIcon: 'cuIcon-present', buttons: ['新增', '查看', '修改', '删除'], menu: '价格策略', tableName: 'price_policy' },
          { appFrontIcon: 'cuIcon-time', buttons: ['查看'], menu: '房态日志', tableName: 'room_status_log' }
        ]
      }, {
        menu: '预订入住管理',
        child: [
          { appFrontIcon: 'cuIcon-form', buttons: ['查看'], menu: '预订订单', tableName: 'booking_order' },
          { appFrontIcon: 'cuIcon-searchlist', buttons: ['查看'], menu: '订单与入住人', tableName: 'booking_flow' },
          { appFrontIcon: 'cuIcon-command', buttons: ['查看'], menu: '业务过程工具', tableName: 'procedure_center' },
          { appFrontIcon: 'cuIcon-copy', buttons: ['查看'], menu: '订单房间明细', tableName: 'booking_room' },
          { appFrontIcon: 'cuIcon-vip', buttons: ['新增', '查看', '修改', '删除'], menu: '入住记录', tableName: 'checkin_record' }
        ]
      }, {
        menu: '房态与服务管理',
        child: [
          { appFrontIcon: 'cuIcon-service', buttons: ['新增', '查看', '修改', '删除'], menu: '清扫任务', tableName: 'housekeeping_task' },
          { appFrontIcon: 'cuIcon-sort', buttons: ['查看'], menu: '清扫任务明细', tableName: 'v_housekeeping_task_detail' },
          { appFrontIcon: 'cuIcon-repair', buttons: ['新增', '查看', '修改', '删除'], menu: '维修记录', tableName: 'maintenance_record' },
          { appFrontIcon: 'cuIcon-group_fill', buttons: ['查看'], menu: '员工考核', tableName: 'employee_performance' }
        ]
      }, {
        menu: '财务结算管理',
        child: [
          { appFrontIcon: 'cuIcon-pay', buttons: ['查看'], menu: '账单台账', tableName: 'bill' },
          { appFrontIcon: 'cuIcon-moneybag', buttons: ['查看'], menu: '账单支付汇总', tableName: 'v_bill_payment_summary' },
          { appFrontIcon: 'cuIcon-cardboard', buttons: ['查看'], menu: '支付记录', tableName: 'payment_record' },
          { appFrontIcon: 'cuIcon-refund', buttons: ['查看'], menu: '退款记录', tableName: 'refund_record' }
        ]
      }, {
        menu: '评价与日志',
        child: [
          { appFrontIcon: 'cuIcon-comment', buttons: ['查看', '修改'], menu: '酒店评价', tableName: 'hotel_review' },
          { appFrontIcon: 'cuIcon-message', buttons: ['查看', '修改'], menu: '客房评价', tableName: 'room_review' },
          { appFrontIcon: 'cuIcon-time', buttons: ['查看'], menu: '订单状态日志', tableName: 'booking_status_log' },
          { appFrontIcon: 'cuIcon-record', buttons: ['查看'], menu: '操作日志', tableName: 'operation_log' }
        ]
      }, {
        menu: '报表管理',
        child: [
          { appFrontIcon: 'cuIcon-countdownfill', buttons: ['查看'], menu: '财务报表', tableName: 'operations_report', routeQuery: { tab: 'finance' } },
          { appFrontIcon: 'cuIcon-home', buttons: ['查看'], menu: '房态报表', tableName: 'operations_report', routeQuery: { tab: 'room' } },
          { appFrontIcon: 'cuIcon-group_fill', buttons: ['查看'], menu: '员工考核报表', tableName: 'operations_report', routeQuery: { tab: 'employee' } }
        ]
      }]
    }, {
      roleName: '员工',
      tableName: 'employee',
      hasBackLogin: '是',
      hasBackRegister: '否',
      hasFrontLogin: '否',
      hasFrontRegister: '否',
      frontMenu: [],
      backMenu: [{
        menu: '客房资源',
        child: [
          { appFrontIcon: 'cuIcon-keyboard', buttons: ['查看'], menu: '客房目录', tableName: 'room_catalog' },
          { appFrontIcon: 'cuIcon-rank', buttons: ['查看', '修改'], menu: '实体客房', tableName: 'room_instance' }
        ]
      }, {
        menu: '入住服务',
        child: [
          { appFrontIcon: 'cuIcon-form', buttons: ['查看'], menu: '预订订单', tableName: 'booking_order' },
          { appFrontIcon: 'cuIcon-searchlist', buttons: ['查看'], menu: '订单与入住人', tableName: 'booking_flow' },
          { appFrontIcon: 'cuIcon-command', buttons: ['查看'], menu: '业务过程工具', tableName: 'procedure_center' },
          { appFrontIcon: 'cuIcon-copy', buttons: ['查看'], menu: '预订明细', tableName: 'v_booking_detail' },
          { appFrontIcon: 'cuIcon-vip', buttons: ['新增', '查看', '修改'], menu: '入住记录', tableName: 'checkin_record' },
          { appFrontIcon: 'cuIcon-service', buttons: ['新增', '查看', '修改'], menu: '清扫任务', tableName: 'housekeeping_task' },
          { appFrontIcon: 'cuIcon-sort', buttons: ['查看'], menu: '清扫任务明细', tableName: 'v_housekeeping_task_detail' },
          { appFrontIcon: 'cuIcon-repair', buttons: ['新增', '查看', '修改'], menu: '维修记录', tableName: 'maintenance_record' }
        ]
      }, {
        menu: '报表管理',
        child: [
          { appFrontIcon: 'cuIcon-home', buttons: ['查看'], menu: '房态报表', tableName: 'operations_report', routeQuery: { tab: 'room' } },
          { appFrontIcon: 'cuIcon-group_fill', buttons: ['查看'], menu: '员工考核报表', tableName: 'operations_report', routeQuery: { tab: 'employee' } }
        ]
      }]
    }, {
      roleName: '用户',
      tableName: 'customer',
      hasBackLogin: '否',
      hasBackRegister: '否',
      hasFrontLogin: '是',
      hasFrontRegister: '是',
      frontMenu: [],
      backMenu: []
    }]
  }
}

export default menu
