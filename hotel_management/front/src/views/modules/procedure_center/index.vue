<template>
  <div class="procedure-page">
    <div class="page-head">
      <div>
        <h2>业务过程工具</h2>
        <p>把数据库中的存储过程映射成可直接操作的业务工具，覆盖房源检索、预订、入住、退房、收款、清扫、维修和统计分析。</p>
      </div>
    </div>

    <div class="page-panel">
      <el-tabs v-model="activeTab">
        <el-tab-pane label="房源与预订" name="booking">
          <el-row :gutter="16">
            <el-col :xs="24" :lg="12">
              <div class="tool-card">
                <div class="tool-title">可用房源检索</div>
                <el-form :model="availableForm" label-width="104px" size="small">
                  <el-form-item label="房型">
                    <el-input v-model.trim="availableForm.roomCategory" placeholder="可留空" />
                  </el-form-item>
                  <el-form-item label="入住日期">
                    <el-date-picker v-model="availableForm.startDate" type="date" value-format="yyyy-MM-dd" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="离店日期">
                    <el-date-picker v-model="availableForm.endDate" type="date" value-format="yyyy-MM-dd" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="最低价格">
                    <el-input-number v-model="availableForm.minPrice" :min="0" :controls="false" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="最高价格">
                    <el-input-number v-model="availableForm.maxPrice" :min="0" :controls="false" style="width:100%;" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" @click="runProcedure('availableRooms')">查询房源</el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-col>
            <el-col :xs="24" :lg="12">
              <div class="tool-card">
                <div class="tool-title">存储过程创建预订</div>
                <el-form :model="createBookingForm" label-width="104px" size="small">
                  <el-form-item label="客户ID">
                    <el-input v-model.trim="createBookingForm.customerId" />
                  </el-form-item>
                  <el-form-item label="客房目录ID">
                    <el-input v-model.trim="createBookingForm.roomCatalogId" />
                  </el-form-item>
                  <el-form-item label="数量">
                    <el-input-number v-model="createBookingForm.quantity" :min="1" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="预订日期">
                    <el-date-picker v-model="createBookingForm.bookingDate" type="date" value-format="yyyy-MM-dd" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="操作人ID">
                    <el-input v-model.trim="createBookingForm.operatorId" placeholder="管理员或员工ID" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" @click="runProcedure('createBooking')">创建预订</el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-col>
          </el-row>
        </el-tab-pane>

        <el-tab-pane label="入住与结算" name="checkin">
          <el-row :gutter="16">
            <el-col :xs="24" :lg="8">
              <div class="tool-card">
                <div class="tool-title">办理入住</div>
                <el-form :model="checkinForm" label-width="96px" size="small">
                  <el-form-item label="订单ID">
                    <el-input v-model.trim="checkinForm.bookingId" />
                  </el-form-item>
                  <el-form-item label="员工ID">
                    <el-input v-model.trim="checkinForm.employeeId" />
                  </el-form-item>
                  <el-form-item label="主入住人">
                    <el-input v-model.trim="checkinForm.guestName" />
                  </el-form-item>
                  <el-form-item label="身份证号">
                    <el-input v-model.trim="checkinForm.idCardNo" />
                  </el-form-item>
                  <el-form-item label="联系电话">
                    <el-input v-model.trim="checkinForm.phone" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" @click="runProcedure('confirmCheckin')">办理入住</el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-col>
            <el-col :xs="24" :lg="8">
              <div class="tool-card">
                <div class="tool-title">退房结算</div>
                <el-form :model="checkoutForm" label-width="96px" size="small">
                  <el-form-item label="入住ID">
                    <el-input v-model.trim="checkoutForm.checkinId" />
                  </el-form-item>
                  <el-form-item label="服务费">
                    <el-input-number v-model="checkoutForm.serviceAmount" :min="0" :controls="false" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="优惠金额">
                    <el-input-number v-model="checkoutForm.discountAmount" :min="0" :controls="false" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="员工ID">
                    <el-input v-model.trim="checkoutForm.employeeId" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" @click="runProcedure('generateCheckoutBill')">生成退房账单</el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-col>
            <el-col :xs="24" :lg="8">
              <div class="tool-card">
                <div class="tool-title">账单收款</div>
                <el-form :model="payBillForm" label-width="96px" size="small">
                  <el-form-item label="账单ID">
                    <el-input v-model.trim="payBillForm.billId" />
                  </el-form-item>
                  <el-form-item label="支付方式">
                    <el-select v-model="payBillForm.payMethod" style="width:100%;">
                      <el-option label="现金" value="cash" />
                      <el-option label="银行卡" value="card" />
                      <el-option label="支付宝" value="alipay" />
                      <el-option label="微信" value="wechat" />
                    </el-select>
                  </el-form-item>
                  <el-form-item label="支付金额">
                    <el-input-number v-model="payBillForm.payAmount" :min="0" :controls="false" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="员工ID">
                    <el-input v-model.trim="payBillForm.employeeId" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" @click="runProcedure('payBill')">登记收款</el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-col>
          </el-row>
        </el-tab-pane>

        <el-tab-pane label="房态与服务" name="service">
          <el-row :gutter="16">
            <el-col :xs="24" :lg="8">
              <div class="tool-card">
                <div class="tool-title">批量房态调整</div>
                <el-form :model="batchRoomStatusForm" label-width="104px" size="small">
                  <el-form-item label="房型">
                    <el-input v-model.trim="batchRoomStatusForm.roomCategory" placeholder="例如 豪华大床房" />
                  </el-form-item>
                  <el-form-item label="原状态">
                    <el-select v-model="batchRoomStatusForm.oldStatus" style="width:100%;">
                      <el-option label="可预订" value="available" />
                      <el-option label="已预订" value="reserved" />
                      <el-option label="入住中" value="occupied" />
                      <el-option label="清扫中" value="cleaning" />
                      <el-option label="维修中" value="maintenance" />
                    </el-select>
                  </el-form-item>
                  <el-form-item label="新状态">
                    <el-select v-model="batchRoomStatusForm.newStatus" style="width:100%;">
                      <el-option label="可预订" value="available" />
                      <el-option label="已预订" value="reserved" />
                      <el-option label="入住中" value="occupied" />
                      <el-option label="清扫中" value="cleaning" />
                      <el-option label="维修中" value="maintenance" />
                    </el-select>
                  </el-form-item>
                  <el-form-item label="操作人ID">
                    <el-input v-model.trim="batchRoomStatusForm.operatorId" />
                  </el-form-item>
                  <el-form-item label="备注">
                    <el-input v-model.trim="batchRoomStatusForm.remark" type="textarea" :rows="2" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" @click="runProcedure('batchUpdateRoomStatus')">执行调整</el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-col>
            <el-col :xs="24" :lg="8">
              <div class="tool-card">
                <div class="tool-title">创建清扫任务</div>
                <el-form :model="housekeepingForm" label-width="96px" size="small">
                  <el-form-item label="房间ID">
                    <el-input v-model.trim="housekeepingForm.roomId" />
                  </el-form-item>
                  <el-form-item label="员工ID">
                    <el-input v-model.trim="housekeepingForm.employeeId" />
                  </el-form-item>
                  <el-form-item label="任务类型">
                    <el-select v-model="housekeepingForm.taskType" style="width:100%;">
                      <el-option label="日常清扫" value="daily_cleaning" />
                      <el-option label="退房清扫" value="checkout_cleaning" />
                      <el-option label="深度清扫" value="deep_cleaning" />
                    </el-select>
                  </el-form-item>
                  <el-form-item label="备注">
                    <el-input v-model.trim="housekeepingForm.remark" type="textarea" :rows="2" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" @click="runProcedure('createHousekeepingTask')">创建任务</el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-col>
            <el-col :xs="24" :lg="8">
              <div class="tool-card">
                <div class="tool-title">上报维修</div>
                <el-form :model="maintenanceForm" label-width="96px" size="small">
                  <el-form-item label="房间ID">
                    <el-input v-model.trim="maintenanceForm.roomId" />
                  </el-form-item>
                  <el-form-item label="上报员工">
                    <el-input v-model.trim="maintenanceForm.reportEmployeeId" />
                  </el-form-item>
                  <el-form-item label="处理员工">
                    <el-input v-model.trim="maintenanceForm.handleEmployeeId" />
                  </el-form-item>
                  <el-form-item label="故障描述">
                    <el-input v-model.trim="maintenanceForm.issueDesc" type="textarea" :rows="3" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" @click="runProcedure('reportMaintenance')">提交维修</el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-col>
          </el-row>
        </el-tab-pane>

        <el-tab-pane label="统计分析" name="report">
          <el-row :gutter="16">
            <el-col :xs="24" :lg="8">
              <div class="tool-card">
                <div class="tool-title">客户消费统计</div>
                <el-form :model="customerReportForm" label-width="96px" size="small">
                  <el-form-item label="客户ID">
                    <el-input v-model.trim="customerReportForm.customerId" />
                  </el-form-item>
                  <el-form-item label="开始日期">
                    <el-date-picker v-model="customerReportForm.startDate" type="date" value-format="yyyy-MM-dd" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="结束日期">
                    <el-date-picker v-model="customerReportForm.endDate" type="date" value-format="yyyy-MM-dd" style="width:100%;" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" @click="runProcedure('customerConsumptionReport')">生成统计</el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-col>
            <el-col :xs="24" :lg="8">
              <div class="tool-card">
                <div class="tool-title">员工绩效统计</div>
                <el-form :model="employeeReportForm" label-width="96px" size="small">
                  <el-form-item label="员工ID">
                    <el-input v-model.trim="employeeReportForm.employeeId" />
                  </el-form-item>
                  <el-form-item label="开始日期">
                    <el-date-picker v-model="employeeReportForm.startDate" type="date" value-format="yyyy-MM-dd" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="结束日期">
                    <el-date-picker v-model="employeeReportForm.endDate" type="date" value-format="yyyy-MM-dd" style="width:100%;" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" @click="runProcedure('employeePerformanceReport')">生成统计</el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-col>
            <el-col :xs="24" :lg="8">
              <div class="tool-card">
                <div class="tool-title">员工考核生成</div>
                <el-form :model="assessmentForm" label-width="96px" size="small">
                  <el-form-item label="员工ID">
                    <el-input v-model.trim="assessmentForm.employeeId" />
                  </el-form-item>
                  <el-form-item label="开始日期">
                    <el-date-picker v-model="assessmentForm.startDate" type="date" value-format="yyyy-MM-dd" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="结束日期">
                    <el-date-picker v-model="assessmentForm.endDate" type="date" value-format="yyyy-MM-dd" style="width:100%;" />
                  </el-form-item>
                  <el-form-item label="考核人ID">
                    <el-input v-model.trim="assessmentForm.assessorId" />
                  </el-form-item>
                  <el-form-item label="管理加分">
                    <el-input-number v-model="assessmentForm.managerScore" :min="0" :controls="false" style="width:100%;" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" @click="runProcedure('generateEmployeeAssessment')">生成考核</el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-col>
          </el-row>
        </el-tab-pane>
      </el-tabs>
    </div>

    <div class="page-panel">
      <div class="result-head">
        <div>
          <h3>{{ resultTitle }}</h3>
        </div>
        <el-button size="small" @click="clearResult">清空结果</el-button>
      </div>
      <el-table v-if="resultRows.length" :data="resultRows" border size="small">
        <el-table-column
          v-for="column in resultColumns"
          :key="column"
          :prop="column"
          :label="column"
          min-width="140"
          show-overflow-tooltip
        />
      </el-table>
      <el-empty v-else description="还没有执行存储过程" />
    </div>
  </div>
</template>

<script>
export default {
  watch: {
    '$route.query': {
      immediate: true,
      handler() {
        this.applyRouteContext()
      }
    }
  },
  data() {
    const todayDate = new Date()
    const today = this.formatDate(todayDate)
    const addDays = days => {
      const date = new Date(todayDate)
      date.setDate(date.getDate() + days)
      return this.formatDate(date)
    }
    const demoStart = addDays(7)
    const demoEnd = addDays(8)
    const reportStartDate = new Date()
    reportStartDate.setDate(reportStartDate.getDate() - 60)
    const reportStart = this.formatDate(reportStartDate)
    return {
      activeTab: 'booking',
      loading: false,
      resultTitle: '最近一次执行结果',
      resultRows: [],
      resultColumns: [],
      availableForm: {
        roomCategory: 'RoomType2',
        startDate: demoStart,
        endDate: demoEnd,
        minPrice: 0,
        maxPrice: 1000
      },
      createBookingForm: {
        customerId: '4001',
        roomCatalogId: '3002',
        quantity: 1,
        bookingDate: demoStart,
        operatorId: '5001'
      },
      checkinForm: {
        bookingId: '6012',
        employeeId: '5001',
        guestName: 'Customer1',
        idCardNo: '110101199001011234',
        phone: '13800000001'
      },
      checkoutForm: {
        checkinId: '9303',
        serviceAmount: 20,
        discountAmount: 5,
        employeeId: '5001'
      },
      payBillForm: {
        billId: '9503',
        payMethod: 'wechat',
        payAmount: 137,
        employeeId: '5001'
      },
      batchRoomStatusForm: {
        roomCategory: 'RoomType6',
        oldStatus: 'available',
        newStatus: 'cleaning',
        operatorId: '5001',
        remark: '演示批量房态调整'
      },
      housekeepingForm: {
        roomId: '8004',
        employeeId: '5001',
        taskType: 'daily_cleaning',
        remark: '演示清扫任务'
      },
      maintenanceForm: {
        roomId: '8005',
        reportEmployeeId: '5001',
        handleEmployeeId: '5002',
        issueDesc: '演示维修：空调异常'
      },
      customerReportForm: {
        customerId: '4001',
        startDate: reportStart,
        endDate: today
      },
      employeeReportForm: {
        employeeId: '5001',
        startDate: reportStart,
        endDate: today
      },
      assessmentForm: {
        employeeId: '5001',
        startDate: reportStart,
        endDate: today,
        assessorId: '5002',
        managerScore: 10
      }
    }
  },
  methods: {
    applyRouteContext() {
      const query = this.$route.query || {}
      if (query.tab) {
        this.activeTab = query.tab
      }
      const assignIfPresent = (form, mapping) => {
        Object.keys(mapping).forEach(key => {
          const queryKey = mapping[key]
          if (query[queryKey] !== undefined && query[queryKey] !== null && query[queryKey] !== '') {
            form[key] = this.normalizeQueryValue(query[queryKey], form[key])
          }
        })
      }
      const tool = query.tool
      if (!tool) {
        return
      }
      const toolMap = {
        availableRooms: [this.availableForm, { roomCategory: 'roomCategory', startDate: 'startDate', endDate: 'endDate', minPrice: 'minPrice', maxPrice: 'maxPrice' }],
        createBooking: [this.createBookingForm, { customerId: 'customerId', roomCatalogId: 'roomCatalogId', quantity: 'quantity', bookingDate: 'bookingDate', operatorId: 'operatorId' }],
        batchUpdateRoomStatus: [this.batchRoomStatusForm, { roomCategory: 'roomCategory', oldStatus: 'oldStatus', newStatus: 'newStatus', operatorId: 'operatorId', remark: 'remark' }],
        confirmCheckin: [this.checkinForm, { bookingId: 'bookingId', employeeId: 'employeeId', guestName: 'guestName', idCardNo: 'idCardNo', phone: 'phone' }],
        generateCheckoutBill: [this.checkoutForm, { checkinId: 'checkinId', serviceAmount: 'serviceAmount', discountAmount: 'discountAmount', employeeId: 'employeeId' }],
        payBill: [this.payBillForm, { billId: 'billId', payMethod: 'payMethod', payAmount: 'payAmount', employeeId: 'employeeId' }],
        createHousekeepingTask: [this.housekeepingForm, { roomId: 'roomId', employeeId: 'employeeId', taskType: 'taskType', remark: 'remark' }],
        reportMaintenance: [this.maintenanceForm, { roomId: 'roomId', reportEmployeeId: 'reportEmployeeId', handleEmployeeId: 'handleEmployeeId', issueDesc: 'issueDesc' }],
        customerConsumptionReport: [this.customerReportForm, { customerId: 'customerId', startDate: 'startDate', endDate: 'endDate' }],
        employeePerformanceReport: [this.employeeReportForm, { employeeId: 'employeeId', startDate: 'startDate', endDate: 'endDate' }],
        generateEmployeeAssessment: [this.assessmentForm, { employeeId: 'employeeId', startDate: 'startDate', endDate: 'endDate', assessorId: 'assessorId', managerScore: 'managerScore' }]
      }
      if (toolMap[tool]) {
        assignIfPresent(toolMap[tool][0], toolMap[tool][1])
      }
    },
    normalizeQueryValue(value, currentValue) {
      if (typeof currentValue === 'number') {
        const numberValue = Number(value)
        return Number.isNaN(numberValue) ? currentValue : numberValue
      }
      return value
    },
    formatDate(date) {
      const pad = item => String(item).padStart(2, '0')
      return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`
    },
    getProcedureConfig(key) {
      return {
        availableRooms: {
          title: '可用房源检索',
          url: 'ops/dbops/availableRooms',
          payload: this.availableForm
        },
        createBooking: {
          title: '存储过程创建预订',
          url: 'ops/dbops/createBooking',
          payload: this.createBookingForm
        },
        batchUpdateRoomStatus: {
          title: '批量房态调整',
          url: 'ops/dbops/batchUpdateRoomStatus',
          payload: this.batchRoomStatusForm
        },
        confirmCheckin: {
          title: '办理入住',
          url: 'ops/dbops/confirmCheckin',
          payload: this.checkinForm
        },
        generateCheckoutBill: {
          title: '退房结算',
          url: 'ops/dbops/generateCheckoutBill',
          payload: this.checkoutForm
        },
        payBill: {
          title: '账单收款',
          url: 'ops/dbops/payBill',
          payload: this.payBillForm
        },
        createHousekeepingTask: {
          title: '创建清扫任务',
          url: 'ops/dbops/createHousekeepingTask',
          payload: this.housekeepingForm
        },
        reportMaintenance: {
          title: '上报维修',
          url: 'ops/dbops/reportMaintenance',
          payload: this.maintenanceForm
        },
        customerConsumptionReport: {
          title: '客户消费统计',
          url: 'ops/dbops/customerConsumptionReport',
          payload: this.customerReportForm
        },
        employeePerformanceReport: {
          title: '员工绩效统计',
          url: 'ops/dbops/employeePerformanceReport',
          payload: this.employeeReportForm
        },
        generateEmployeeAssessment: {
          title: '员工考核生成',
          url: 'ops/dbops/generateEmployeeAssessment',
          payload: this.assessmentForm
        }
      }[key]
    },
    normalizeRows(data) {
      if (Array.isArray(data)) {
        return data
      }
      if (data && typeof data === 'object') {
        return [data]
      }
      return []
    },
    validateProcedure(key, payload) {
      const warn = message => {
        this.$message.warning(message)
        return false
      }
      const missing = (field, label) => {
        if (payload[field] === undefined || payload[field] === null || payload[field] === '') {
          return warn(`${label}不能为空`)
        }
        return true
      }
      const nonNegative = (field, label) => {
        const value = Number(payload[field])
        if (Number.isNaN(value) || value < 0) {
          return warn(`${label}不能为负数`)
        }
        return true
      }
      const positive = (field, label) => {
        const value = Number(payload[field])
        if (Number.isNaN(value) || value <= 0) {
          return warn(`${label}必须大于 0`)
        }
        return true
      }
      const dateRange = (startField, endField, strictEnd) => {
        if (!payload[startField] || !payload[endField]) {
          return warn('请选择开始日期和结束日期')
        }
        if (strictEnd ? payload[endField] <= payload[startField] : payload[endField] < payload[startField]) {
          return warn(strictEnd ? '离店日期必须晚于入住日期' : '结束日期不能早于开始日期')
        }
        return true
      }

      if (key === 'availableRooms') {
        if (!dateRange('startDate', 'endDate', true)) {
          return false
        }
        if (!nonNegative('minPrice', '最低价格') || !nonNegative('maxPrice', '最高价格')) {
          return false
        }
        if (Number(payload.maxPrice) > 0 && Number(payload.maxPrice) < Number(payload.minPrice)) {
          return warn('最高价格不能低于最低价格')
        }
      }
      if (key === 'createBooking') {
        if (!missing('customerId', '客户ID') || !missing('roomCatalogId', '客房目录ID') || !positive('quantity', '数量') || !missing('bookingDate', '预订日期') || !missing('operatorId', '操作人ID')) {
          return false
        }
      }
      if (key === 'confirmCheckin') {
        if (!missing('bookingId', '订单ID') || !missing('employeeId', '员工ID') || !missing('guestName', '主入住人')) {
          return false
        }
      }
      if (key === 'generateCheckoutBill') {
        if (!missing('checkinId', '入住ID') || !nonNegative('serviceAmount', '服务费') || !nonNegative('discountAmount', '优惠金额') || !missing('employeeId', '员工ID')) {
          return false
        }
      }
      if (key === 'payBill') {
        if (!missing('billId', '账单ID') || !missing('payMethod', '支付方式') || !positive('payAmount', '支付金额') || !missing('employeeId', '员工ID')) {
          return false
        }
      }
      if (key === 'batchUpdateRoomStatus') {
        if (!missing('newStatus', '新状态') || !missing('operatorId', '操作人ID')) {
          return false
        }
        if (payload.oldStatus && payload.oldStatus === payload.newStatus) {
          return warn('新状态不能和原状态相同')
        }
      }
      if (key === 'createHousekeepingTask') {
        if (!missing('roomId', '房间ID') || !missing('employeeId', '员工ID') || !missing('taskType', '任务类型')) {
          return false
        }
      }
      if (key === 'reportMaintenance') {
        if (!missing('roomId', '房间ID') || !missing('reportEmployeeId', '上报员工') || !missing('handleEmployeeId', '处理员工') || !missing('issueDesc', '故障描述')) {
          return false
        }
      }
      if (key === 'customerConsumptionReport' || key === 'employeePerformanceReport' || key === 'generateEmployeeAssessment') {
        if (!dateRange('startDate', 'endDate', false)) {
          return false
        }
      }
      if (key === 'generateEmployeeAssessment') {
        if (!missing('employeeId', '员工ID') || !missing('assessorId', '考核人ID') || !nonNegative('managerScore', '管理加分')) {
          return false
        }
      }
      return true
    },
    async runProcedure(key) {
      const config = this.getProcedureConfig(key)
      if (!config) {
        return
      }
      if (!this.validateProcedure(key, config.payload)) {
        return
      }
      this.loading = true
      try {
        const { data } = await this.$http({
          url: config.url,
          method: 'post',
          data: config.payload
        })
        if (data && data.code === 0) {
          const rows = this.normalizeRows(data.data)
          this.resultTitle = config.title
          this.resultRows = rows
          this.resultColumns = rows.length ? Object.keys(rows[0]) : []
          this.$message.success(`${config.title}执行成功`)
        } else {
          this.$message.error((data && data.msg) || `${config.title}执行失败`)
        }
      } catch (error) {
        this.$message.error((error && error.message) || `${config.title}执行失败`)
      } finally {
        this.loading = false
      }
    },
    clearResult() {
      this.resultTitle = '最近一次执行结果'
      this.resultRows = []
      this.resultColumns = []
    }
  }
}
</script>

<style lang="scss" scoped>
.procedure-page {
  padding: 18px;
  background: #f5f7fa;
  min-height: calc(100vh - 80px);
}

.page-head {
  margin-bottom: 14px;
}

.page-head h2 {
  margin: 0 0 6px;
  color: #263238;
  font-size: 22px;
}

.page-head p {
  margin: 0;
  color: #667085;
  line-height: 1.7;
}

.page-panel {
  background: #fff;
  border-radius: 10px;
  padding: 16px;
  box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
  margin-bottom: 16px;
}

.tool-card {
  height: 100%;
  padding: 16px;
  border: 1px solid #e5eef0;
  border-radius: 8px;
  background: #fbfdfd;
}

.tool-title {
  margin-bottom: 14px;
  font-size: 15px;
  font-weight: 600;
  color: #22303c;
}

.result-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
  margin-bottom: 12px;
}

.result-head h3 {
  margin: 0 0 4px;
  color: #22303c;
}

.result-head p {
  margin: 0;
  color: #7a8793;
}

@media (max-width: 992px) {
  .result-head {
    flex-direction: column;
  }
}
</style>
