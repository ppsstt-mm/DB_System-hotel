<template>
  <div class="report-page" v-loading="loading">
    <div class="report-head">
      <div>
        <h2>{{ pageTitle }}</h2>
      </div>
      <div class="head-actions">
        <el-button v-if="!isEmployee" size="small" icon="el-icon-document" @click="exportCurrentTab">导出当前标签页</el-button>
        <el-button v-if="isAdmin" size="small" icon="el-icon-edit-outline" @click="openAssessmentDialog">生成员工考核</el-button>
        <el-button size="small" type="primary" icon="el-icon-refresh" @click="loadAll">刷新数据</el-button>
      </div>
    </div>

    <el-row :gutter="16" class="metric-row">
      <el-col :xs="24" :sm="12" :md="6" v-for="item in metrics" :key="item.label">
        <div class="metric">
          <span>{{ item.label }}</span>
          <strong>{{ item.value }}</strong>
        </div>
      </el-col>
    </el-row>

    <div class="filter-panel">
      <div class="filter-grid" :class="{ compact: isEmployee }">
        <el-date-picker
          v-model="filters.dateRange"
          type="daterange"
          size="small"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          value-format="yyyy-MM-dd"
          unlink-panels
          @change="handleFilterChange"
        />
        <el-select
          v-model="filters.roomCategory"
          clearable
          filterable
          size="small"
          placeholder="全部房型"
          @change="handleFilterChange"
        >
          <el-option v-for="item in roomCategoryOptions" :key="item" :label="item" :value="item" />
        </el-select>
        <el-select
          v-if="!isEmployee"
          v-model="filters.employeeId"
          clearable
          filterable
          size="small"
          placeholder="全部员工"
          @change="handleFilterChange"
        >
          <el-option
            v-for="item in employeeOptions"
            :key="item.id"
            :label="employeeLabel(item)"
            :value="item.id"
          />
        </el-select>
        <div class="filter-actions">
          <el-button size="small" @click="resetFilters">重置筛选</el-button>
        </div>
      </div>
      <div class="filter-summary">
        <span>当前筛选：</span>
        <el-tag size="mini" effect="plain">{{ activeDateLabel }}</el-tag>
        <el-tag size="mini" effect="plain">{{ activeRoomCategoryLabel }}</el-tag>
        <el-tag size="mini" effect="plain">{{ activeEmployeeLabel }}</el-tag>
      </div>
    </div>

    <div v-if="isAdmin" class="meta-panel">
      <div class="meta-card">
        <div class="meta-title">编号规则</div>
        <div class="meta-list">
          <span>顾客编号：{{ reportMeta.customerIdRange || '-' }}</span>
          <span>员工编号：{{ reportMeta.employeeIdRange || '-' }}</span>
          <span>订单编号：{{ reportMeta.bookingIdRange || '-' }}</span>
          <span>订单单号：{{ reportMeta.bookingNoRule || '-' }}</span>
        </div>
      </div>
      <div v-if="displayHighlights.length" class="meta-card">
        <div class="meta-title">业务范围</div>
        <div class="meta-list">
          <span v-for="item in displayHighlights" :key="item">{{ item }}</span>
        </div>
      </div>
    </div>

    <el-tabs v-model="activeTab" @tab-click="handleTabChange">
      <el-tab-pane v-if="isAdmin" label="财务报表" name="finance">
        <el-row :gutter="16">
          <el-col :xs="24" :lg="14">
            <div class="panel">
              <div class="panel-title">月度收入趋势</div>
              <div ref="revenueChart" class="chart"></div>
            </div>
          </el-col>
          <el-col :xs="24" :lg="10">
            <div class="panel">
              <div class="panel-title">支付方式净收入</div>
              <div ref="payMethodChart" class="chart"></div>
            </div>
          </el-col>
        </el-row>
        <el-table :data="filteredFinanceRows" border size="small" class="data-table">
          <el-table-column prop="revenue_month" label="月份" min-width="110" />
          <el-table-column prop="room_category" label="房型" min-width="130" />
          <el-table-column prop="pay_method" label="支付方式" min-width="110">
            <template slot-scope="{ row }">{{ payMethodLabel(row.pay_method) }}</template>
          </el-table-column>
          <el-table-column prop="gross_revenue" label="总收入" min-width="110">
            <template slot-scope="{ row }">{{ money(row.gross_revenue) }}</template>
          </el-table-column>
          <el-table-column prop="refund_amount" label="退款" min-width="100">
            <template slot-scope="{ row }">{{ money(row.refund_amount) }}</template>
          </el-table-column>
          <el-table-column prop="net_revenue" label="净收入" min-width="110">
            <template slot-scope="{ row }">{{ money(row.net_revenue) }}</template>
          </el-table-column>
          <el-table-column prop="payment_count" label="支付笔数" min-width="100" />
        </el-table>
      </el-tab-pane>

      <el-tab-pane :label="isEmployee ? '房态概览' : '房态报表'" name="room">
        <el-row :gutter="16">
          <el-col :xs="24" :lg="14">
            <div class="panel">
              <div class="panel-title">客房库存分布</div>
              <div ref="roomInventoryChart" class="chart"></div>
            </div>
          </el-col>
          <el-col :xs="24" :lg="10">
            <div class="panel">
              <div class="panel-title">当前房态占比</div>
              <div ref="roomStatusChart" class="chart"></div>
            </div>
          </el-col>
        </el-row>
        <el-table :data="filteredRoomRows" border size="small" class="data-table">
          <el-table-column prop="hotel_name" label="酒店" min-width="120" />
          <el-table-column prop="room_name" label="客房" min-width="140" />
          <el-table-column prop="room_category" label="房型" min-width="120" />
          <el-table-column prop="total_rooms" label="总房数" min-width="90" />
          <el-table-column prop="available_rooms" label="可预订" min-width="90" />
          <el-table-column prop="reserved_rooms" label="已预订" min-width="90" />
          <el-table-column prop="occupied_rooms" label="入住中" min-width="90" />
          <el-table-column prop="cleaning_rooms" label="清扫中" min-width="90" />
          <el-table-column prop="maintenance_rooms" label="维修中" min-width="90" />
        </el-table>

        <div v-if="isAdmin" class="panel secondary-panel">
          <div class="panel-title">房态明细快照</div>
          <el-table :data="filteredRoomStatusRows" border size="small">
            <el-table-column prop="room_no" label="房号" min-width="90" />
            <el-table-column prop="room_name" label="客房" min-width="120" />
            <el-table-column prop="room_category" label="房型" min-width="120" />
            <el-table-column prop="current_status" label="当前状态" min-width="100">
              <template slot-scope="{ row }">{{ roomStatusLabel(row.current_status) }}</template>
            </el-table-column>
            <el-table-column prop="booking_no" label="订单单号" min-width="150" />
            <el-table-column prop="customer_name" label="顾客账号" min-width="110" />
            <el-table-column prop="business_status" label="业务状态" min-width="140">
              <template slot-scope="{ row }">{{ roomStatusLabel(row.business_status) }}</template>
            </el-table-column>
          </el-table>
        </div>
      </el-tab-pane>

      <el-tab-pane :label="isEmployee ? '我的业务报表' : '员工考核报表'" name="employee">
        <div v-if="isAdmin" class="tab-actions">
          <el-alert
            title="可按当前筛选条件生成员工考核记录。"
            type="info"
            :closable="false"
            show-icon
          />
          <el-button size="small" type="primary" icon="el-icon-data-analysis" @click="openAssessmentDialog">
            生成考核
          </el-button>
        </div>
        <el-row :gutter="16">
          <el-col :xs="24" :lg="14">
            <div class="panel">
              <div class="panel-title">{{ isEmployee ? '我的考核得分' : '员工考核得分' }}</div>
              <div ref="employeeScoreChart" class="chart"></div>
            </div>
          </el-col>
          <el-col :xs="24" :lg="10">
            <div class="panel">
              <div class="panel-title">{{ isEmployee ? '我的业务办理量' : '员工业务办理量' }}</div>
              <div ref="employeeOpsChart" class="chart"></div>
            </div>
          </el-col>
        </el-row>
        <el-table :data="filteredEmployeeRows" border size="small" class="data-table">
          <el-table-column prop="employee_name" label="员工" min-width="120" />
          <el-table-column prop="employee_no" label="员工工号" min-width="110" />
          <el-table-column prop="period_start" label="开始日期" min-width="110" />
          <el-table-column prop="period_end" label="结束日期" min-width="110" />
          <el-table-column prop="checkin_count" label="入住办理" min-width="90" />
          <el-table-column prop="bill_count" label="账单" min-width="80" />
          <el-table-column prop="payment_count" label="支付" min-width="80" />
          <el-table-column prop="cleaning_count" label="清扫" min-width="80" />
          <el-table-column prop="maintenance_count" label="维修" min-width="80" />
          <el-table-column prop="manager_score" label="管理加分" min-width="90" />
          <el-table-column prop="total_score" label="总分" min-width="80" />
          <el-table-column prop="grade" label="等级" min-width="70" />
        </el-table>
      </el-tab-pane>
    </el-tabs>

    <el-dialog
      title="生成员工考核"
      :visible.sync="assessmentDialogVisible"
      width="520px"
      :close-on-click-modal="false"
    >
      <el-form ref="assessmentForm" :model="assessmentForm" :rules="assessmentRules" label-width="96px">
        <el-form-item label="考核员工" prop="employeeId">
          <el-select v-model="assessmentForm.employeeId" filterable placeholder="请选择员工" style="width: 100%;">
            <el-option
              v-for="item in employeeOptions"
              :key="item.id"
              :label="employeeLabel(item)"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="考核区间" prop="dateRange">
          <el-date-picker
            v-model="assessmentForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd"
            unlink-panels
            style="width: 100%;"
          />
        </el-form-item>
        <el-form-item label="考核人">
          <el-select v-model="assessmentForm.assessorId" clearable filterable placeholder="可选" style="width: 100%;">
            <el-option
              v-for="item in employeeOptions"
              :key="`assessor-${item.id}`"
              :label="employeeLabel(item)"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="管理加分">
          <el-input-number
            v-model="assessmentForm.managerScore"
            :min="0"
            :max="30"
            :precision="2"
            :step="1"
            controls-position="right"
            style="width: 100%;"
          />
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="assessmentDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="assessmentLoading" @click="submitAssessment">生成并刷新</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  data() {
    return {
      activeTab: 'finance',
      role: '',
      sessionTable: '',
      currentUserId: '',
      currentUserName: '',
      loading: false,
      assessmentLoading: false,
      assessmentDialogVisible: false,
      filters: {
        dateRange: [],
        roomCategory: '',
        employeeId: ''
      },
      rawFinanceRows: [],
      rawRoomRows: [],
      rawRoomStatusRows: [],
      rawEmployeeRows: [],
      rawEmployeeOperationRows: [],
      employeeOptions: [],
      charts: {},
      reportMeta: {
        customerIdRange: '',
        employeeIdRange: '',
        bookingIdRange: '',
        bookingNoRule: '',
        demoHighlights: []
      },
      assessmentForm: {
        employeeId: '',
        assessorId: '',
        dateRange: [],
        managerScore: 10
      },
      assessmentRules: {
        employeeId: [{ required: true, message: '请选择考核员工', trigger: 'change' }],
        dateRange: [{ type: 'array', required: true, message: '请选择考核区间', trigger: 'change' }]
      }
    }
  },
  computed: {
    isAdmin() {
      return this.role === '管理员'
    },
    isEmployee() {
      return this.role === '员工'
    },
    roomCategoryOptions() {
      const set = new Set()
      this.rawRoomRows.forEach(item => item.room_category && set.add(item.room_category))
      this.rawFinanceRows.forEach(item => item.room_category && set.add(item.room_category))
      this.rawRoomStatusRows.forEach(item => item.room_category && set.add(item.room_category))
      return Array.from(set)
    },
    filteredFinanceRows() {
      if (!this.isAdmin) {
        return []
      }
      return this.rawFinanceRows.filter(item => this.matchRoomCategory(item.room_category) && this.matchRevenueMonth(item.revenue_month))
    },
    filteredRoomRows() {
      return this.rawRoomRows.filter(item => this.matchRoomCategory(item.room_category))
    },
    filteredRoomStatusRows() {
      return this.rawRoomStatusRows.filter(item => this.matchRoomCategory(item.room_category))
    },
    filteredEmployeeRows() {
      return this.rawEmployeeRows.filter(item => this.matchEmployee(item.employee_id) && this.matchPeriod(item.period_start, item.period_end))
    },
    filteredEmployeeOperationRows() {
      return this.rawEmployeeOperationRows.filter(item => this.matchEmployee(item.employee_id) && this.matchPeriod(item.first_operation_time, item.last_operation_time))
    },
    metrics() {
      if (this.isEmployee && this.activeTab === 'employee') {
        const operation = this.filteredEmployeeOperationRows[0] || {}
        const performance = this.filteredEmployeeRows[0] || {}
        return [
          { label: '我的业务量', value: this.num(operation.total_operations) },
          { label: '入住办理', value: this.num(operation.checkin_operations) },
          { label: '清扫任务', value: this.num(operation.cleaning_task_count) },
          { label: '最近考核', value: performance.grade ? `${performance.grade} / ${this.num(performance.total_score)}` : '暂无' }
        ]
      }
      if (this.isEmployee) {
        return [
          { label: '客房总数', value: this.sum(this.filteredRoomRows, 'total_rooms') },
          { label: '可预订房间', value: this.sum(this.filteredRoomRows, 'available_rooms') },
          { label: '清扫中房间', value: this.sum(this.filteredRoomRows, 'cleaning_rooms') },
          { label: '维修中房间', value: this.sum(this.filteredRoomRows, 'maintenance_rooms') }
        ]
      }
      return [
        { label: '净收入', value: this.money(this.sum(this.filteredFinanceRows, 'net_revenue')) },
        { label: '客房总数', value: this.sum(this.filteredRoomRows, 'total_rooms') },
        { label: '可预订房间', value: this.sum(this.filteredRoomRows, 'available_rooms') },
        { label: '参与员工数', value: new Set(this.filteredEmployeeOperationRows.map(item => item.employee_id)).size }
      ]
    },
    pageTitle() {
      if (this.isEmployee) {
        return this.activeTab === 'room' ? '房态报表' : '我的业务报表'
      }
      return '经营报表'
    },
    activeDateLabel() {
      return this.filters.dateRange && this.filters.dateRange.length === 2
        ? `${this.filters.dateRange[0]} 至 ${this.filters.dateRange[1]}`
        : '日期：全部'
    },
    activeRoomCategoryLabel() {
      return this.filters.roomCategory ? `房型：${this.filters.roomCategory}` : '房型：全部'
    },
    activeEmployeeLabel() {
      if (this.isEmployee) {
        return `员工：${this.currentUserName || '本人'}`
      }
      if (!this.filters.employeeId) {
        return '员工：全部'
      }
      const employee = this.employeeOptions.find(item => String(item.id) === String(this.filters.employeeId))
      return `员工：${employee ? this.employeeLabel(employee) : this.filters.employeeId}`
    },
    displayHighlights() {
      return (this.reportMeta.demoHighlights || []).filter(item => item)
    }
  },
  watch: {
    '$route.query.tab': {
      immediate: true,
      handler() {
        this.syncTabFromRoute()
      }
    }
  },
  async mounted() {
    this.role = this.$storage.get('role') || ''
    this.sessionTable = this.$storage.get('sessionTable') || ''
    await this.initSession()
    await this.loadAll()
    window.addEventListener('resize', this.resizeCharts)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.resizeCharts)
    Object.keys(this.charts).forEach(key => {
      const chart = this.charts[key]
      if (chart) {
        chart.dispose()
      }
    })
  },
  methods: {
    async initSession() {
      if (!this.sessionTable) {
        return
      }
      try {
        const { data } = await this.$http({
          url: `${this.sessionTable}/session`,
          method: 'get'
        })
        if (data && data.code === 0 && data.data) {
          this.currentUserId = data.data.id
          this.currentUserName = data.data.employeexingming || data.data.xingming || data.data.username || this.$storage.get('adminName') || ''
          if (this.isEmployee) {
            this.filters.employeeId = data.data.id
          }
        }
      } catch (error) {}
    },
    syncTabFromRoute() {
      const allowedTabs = this.isEmployee ? ['room', 'employee'] : ['finance', 'room', 'employee']
      const routeTab = this.$route.query && this.$route.query.tab
      const nextTab = allowedTabs.includes(routeTab) ? routeTab : allowedTabs[0]
      if (this.activeTab !== nextTab) {
        this.activeTab = nextTab
      }
    },
    handleTabChange() {
      this.$router.replace({
        path: '/operations_report',
        query: { tab: this.activeTab }
      }).catch(() => {})
      this.renderCharts()
    },
    async loadAll() {
      this.loading = true
      try {
        const [finance, rooms, roomStatus, employee, employeeOps, employees, meta] = await Promise.all([
          this.fetchView('v_monthly_revenue_report'),
          this.fetchView('v_room_inventory_overview'),
          this.fetchView('v_room_daily_status'),
          this.fetchView('v_employee_performance_detail'),
          this.fetchView('v_employee_operation_summary'),
          this.fetchEmployees(),
          this.fetchReportMeta()
        ])
        this.rawFinanceRows = finance
        this.rawRoomRows = rooms
        this.rawRoomStatusRows = roomStatus
        this.rawEmployeeRows = employee
        this.rawEmployeeOperationRows = employeeOps
        this.employeeOptions = this.isEmployee
          ? employees.filter(item => String(item.id) === String(this.currentUserId))
          : employees
        this.reportMeta = meta
        if (this.isEmployee) {
          this.filters.employeeId = this.currentUserId
        }
        this.syncTabFromRoute()
        this.renderCharts()
      } catch (error) {
        this.$message.error('报表数据加载失败')
      } finally {
        this.loading = false
      }
    },
    fetchView(viewName) {
      return this.$http({
        url: `ops/${viewName}/list`,
        method: 'get',
        params: { sort: 'id', order: 'desc' }
      }).then(({ data }) => {
        return data && data.code === 0 && Array.isArray(data.data) ? data.data : []
      })
    },
    fetchEmployees() {
      return this.$http({
        url: 'ops/employee/list',
        method: 'get',
        params: { sort: 'id', order: 'asc' }
      }).then(({ data }) => {
        return data && data.code === 0 && Array.isArray(data.data) ? data.data : []
      }).catch(() => [])
    },
    fetchReportMeta() {
      return this.$http({
        url: 'ops/report/meta',
        method: 'get'
      }).then(({ data }) => {
        return data && data.code === 0 && data.data ? data.data : { demoHighlights: [] }
      }).catch(() => ({ demoHighlights: [] }))
    },
    employeeLabel(item) {
      if (!item) return ''
      const name = item.employeexingming || item.employee_name || ''
      const code = item.employeegonghao || item.employee_no || ''
      return code && name ? `${name}（${code}）` : (name || code || String(item.id))
    },
    handleFilterChange() {
      this.renderCharts()
    },
    resetFilters() {
      this.filters = {
        dateRange: [],
        roomCategory: '',
        employeeId: this.isEmployee ? this.currentUserId : ''
      }
      this.renderCharts()
    },
    matchRoomCategory(roomCategory) {
      return !this.filters.roomCategory || roomCategory === this.filters.roomCategory
    },
    matchEmployee(employeeId) {
      const targetEmployeeId = this.isEmployee ? this.currentUserId : this.filters.employeeId
      return !targetEmployeeId || String(employeeId) === String(targetEmployeeId)
    },
    matchRevenueMonth(monthText) {
      if (!this.filters.dateRange || this.filters.dateRange.length !== 2 || !monthText) {
        return true
      }
      const start = this.filters.dateRange[0].slice(0, 7)
      const end = this.filters.dateRange[1].slice(0, 7)
      return monthText >= start && monthText <= end
    },
    matchPeriod(startValue, endValue) {
      if (!this.filters.dateRange || this.filters.dateRange.length !== 2) {
        return true
      }
      const rangeStart = this.normalizeDate(this.filters.dateRange[0])
      const rangeEnd = this.normalizeDate(this.filters.dateRange[1])
      const rowStart = this.normalizeDate(startValue) || rangeStart
      const rowEnd = this.normalizeDate(endValue) || rowStart
      return rowStart <= rangeEnd && rowEnd >= rangeStart
    },
    normalizeDate(value) {
      return value ? String(value).slice(0, 10) : ''
    },
    renderCharts() {
      this.$nextTick(() => {
        setTimeout(() => {
          this.renderCurrentTabCharts()
          this.resizeCharts()
        }, 80)
      })
    },
    renderCurrentTabCharts() {
      if (this.activeTab === 'finance' && this.isAdmin) {
        this.renderRevenueChart()
        this.renderPayMethodChart()
        return
      }
      if (this.activeTab === 'room') {
        this.renderRoomInventoryChart()
        this.renderRoomStatusChart()
        return
      }
      this.renderEmployeeScoreChart()
      this.renderEmployeeOpsChart()
    },
    initChart(refName) {
      const el = this.$refs[refName]
      if (!el || !el.clientWidth || !el.clientHeight) {
        return null
      }
      let chart = this.charts[refName]
      if (chart && chart.getDom() !== el) {
        chart.dispose()
        chart = null
      }
      if (!chart) {
        chart = this.$echarts.getInstanceByDom(el) || this.$echarts.init(el, 'macarons')
        this.$set(this.charts, refName, chart)
      }
      return chart
    },
    renderRevenueChart() {
      const chart = this.initChart('revenueChart')
      if (!chart) return
      const grouped = this.groupSum(this.filteredFinanceRows, 'revenue_month', ['gross_revenue', 'refund_amount', 'net_revenue'])
      chart.setOption({
        tooltip: { trigger: 'axis' },
        legend: { data: ['总收入', '退款', '净收入'] },
        grid: { left: 48, right: 24, top: 48, bottom: 36 },
        xAxis: { type: 'category', data: grouped.labels },
        yAxis: { type: 'value' },
        series: [
          { name: '总收入', type: 'line', smooth: true, data: grouped.gross_revenue },
          { name: '退款', type: 'line', smooth: true, data: grouped.refund_amount },
          { name: '净收入', type: 'bar', barMaxWidth: 38, data: grouped.net_revenue }
        ]
      }, true)
    },
    renderPayMethodChart() {
      const chart = this.initChart('payMethodChart')
      if (!chart) return
      const grouped = this.groupSum(this.filteredFinanceRows, 'pay_method', ['net_revenue'])
      chart.setOption({
        tooltip: { trigger: 'item' },
        legend: { bottom: 8, left: 'center' },
        series: [{
          name: '净收入',
          type: 'pie',
          radius: ['40%', '68%'],
          center: ['50%', '44%'],
          label: { formatter: '{b}\n{d}%' },
          data: grouped.labels.map((name, index) => ({
            name: this.payMethodLabel(name),
            value: grouped.net_revenue[index]
          }))
        }]
      }, true)
    },
    renderRoomInventoryChart() {
      const chart = this.initChart('roomInventoryChart')
      if (!chart) return
      const grouped = this.groupSum(this.filteredRoomRows, 'room_category', [
        'available_rooms', 'reserved_rooms', 'occupied_rooms', 'cleaning_rooms', 'maintenance_rooms'
      ])
      chart.setOption({
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        legend: { top: 8, data: ['可预订', '已预订', '入住中', '清扫中', '维修中'] },
        grid: { left: 64, right: 24, top: 64, bottom: 52 },
        xAxis: {
          type: 'category',
          data: grouped.labels,
          axisLabel: {
            interval: 0,
            rotate: grouped.labels.length > 6 ? 16 : 0
          }
        },
        yAxis: { type: 'value', name: '房间数' },
        series: [
          { name: '可预订', type: 'bar', stack: 'room', barMaxWidth: 56, data: grouped.available_rooms },
          { name: '已预订', type: 'bar', stack: 'room', barMaxWidth: 56, data: grouped.reserved_rooms },
          { name: '入住中', type: 'bar', stack: 'room', barMaxWidth: 56, data: grouped.occupied_rooms },
          { name: '清扫中', type: 'bar', stack: 'room', barMaxWidth: 56, data: grouped.cleaning_rooms },
          { name: '维修中', type: 'bar', stack: 'room', barMaxWidth: 56, data: grouped.maintenance_rooms }
        ]
      }, true)
    },
    renderRoomStatusChart() {
      const chart = this.initChart('roomStatusChart')
      if (!chart) return
      const counts = this.filteredRoomStatusRows.reduce((acc, item) => {
        const key = item.current_status || item.business_status || 'unknown'
        acc[key] = (acc[key] || 0) + 1
        return acc
      }, {})
      const data = Object.keys(counts).map(key => ({
        name: this.roomStatusLabel(key),
        value: counts[key]
      }))
      chart.setOption({
        tooltip: { trigger: 'item', formatter: '{b}：{c} 间 ({d}%)' },
        legend: {
          orient: 'vertical',
          right: 0,
          top: 'middle',
          itemWidth: 12,
          itemHeight: 12
        },
        series: [{
          name: '房态',
          type: 'pie',
          radius: ['42%', '70%'],
          center: ['34%', '50%'],
          avoidLabelOverlap: true,
          minAngle: 10,
          label: {
            show: true,
            formatter: '{b}\n{c}间'
          },
          labelLine: {
            length: 12,
            length2: 10
          },
          data
        }]
      }, true)
    },
    renderEmployeeScoreChart() {
      const chart = this.initChart('employeeScoreChart')
      if (!chart) return
      const rows = this.filteredEmployeeRows
      chart.setOption({
        tooltip: { trigger: 'axis' },
        grid: { left: 44, right: 24, top: 32, bottom: 42 },
        xAxis: {
          type: 'category',
          data: rows.map(item => item.employee_name || item.employee_no),
          axisLabel: { interval: 0, rotate: rows.length > 4 ? 20 : 0 }
        },
        yAxis: { type: 'value', max: 100 },
        series: [{
          name: '考核得分',
          type: 'bar',
          barMaxWidth: 44,
          data: rows.map(item => this.num(item.total_score))
        }]
      }, true)
    },
    renderEmployeeOpsChart() {
      const chart = this.initChart('employeeOpsChart')
      if (!chart) return
      const rows = this.filteredEmployeeOperationRows
      chart.setOption({
        tooltip: { trigger: 'axis' },
        legend: { data: ['预订', '入住', '账单', '清扫', '维修'] },
        grid: { left: 44, right: 24, top: 48, bottom: 42 },
        xAxis: {
          type: 'category',
          data: rows.map(item => item.employee_name || item.employee_no),
          axisLabel: { interval: 0, rotate: rows.length > 4 ? 20 : 0 }
        },
        yAxis: { type: 'value' },
        series: [
          { name: '预订', type: 'bar', barMaxWidth: 36, data: rows.map(item => this.num(item.booking_operations)) },
          { name: '入住', type: 'bar', barMaxWidth: 36, data: rows.map(item => this.num(item.checkin_operations)) },
          { name: '账单', type: 'bar', barMaxWidth: 36, data: rows.map(item => this.num(item.bill_operations)) },
          { name: '清扫', type: 'bar', barMaxWidth: 36, data: rows.map(item => this.num(item.cleaning_task_count)) },
          { name: '维修', type: 'bar', barMaxWidth: 36, data: rows.map(item => this.num(item.maintenance_task_count)) }
        ]
      }, true)
    },
    groupSum(rows, key, fields) {
      const map = {}
      rows.forEach(row => {
        const label = row[key] || '未登记'
        if (!map[label]) {
          map[label] = {}
          fields.forEach(field => {
            map[label][field] = 0
          })
        }
        fields.forEach(field => {
          map[label][field] += this.num(row[field])
        })
      })
      const labels = Object.keys(map).sort()
      const result = { labels }
      fields.forEach(field => {
        result[field] = labels.map(label => Number(map[label][field].toFixed(2)))
      })
      return result
    },
    sum(rows, field) {
      return rows.reduce((total, item) => total + this.num(item[field]), 0)
    },
    num(value) {
      const parsed = Number(value)
      return Number.isFinite(parsed) ? parsed : 0
    },
    money(value) {
      return `￥${this.num(value).toFixed(2)}`
    },
    payMethodLabel(value) {
      const labels = {
        wechat: '微信',
        alipay: '支付宝',
        cash: '现金',
        card: '银行卡'
      }
      return labels[value] || value || '未登记'
    },
    roomStatusLabel(value) {
      const labels = {
        available: '可预订',
        reserved: '已预订',
        occupied: '入住中',
        cleaning: '清扫中',
        maintenance: '维修中',
        occupied_by_checkin: '入住中',
        maintenance_processing: '维修处理中',
        cleaning_processing: '清扫处理中',
        reserved_by_booking: '预订锁房',
        unknown: '未知'
      }
      return labels[value] || value || '未知'
    },
    openAssessmentDialog() {
      const fallbackRange = this.filters.dateRange && this.filters.dateRange.length === 2
        ? this.filters.dateRange.slice()
        : this.currentMonthRange()
      this.assessmentForm = {
        employeeId: this.filters.employeeId || '',
        assessorId: '',
        dateRange: fallbackRange,
        managerScore: 10
      }
      this.assessmentDialogVisible = true
      this.$nextTick(() => {
        if (this.$refs.assessmentForm) {
          this.$refs.assessmentForm.clearValidate()
        }
      })
    },
    currentMonthRange() {
      const now = new Date()
      const year = now.getFullYear()
      const month = String(now.getMonth() + 1).padStart(2, '0')
      const lastDay = new Date(year, now.getMonth() + 1, 0).getDate()
      return [
        `${year}-${month}-01`,
        `${year}-${month}-${String(lastDay).padStart(2, '0')}`
      ]
    },
    submitAssessment() {
      this.$refs.assessmentForm.validate(async valid => {
        if (!valid) return
        this.assessmentLoading = true
        try {
          const payload = {
            employeeId: this.assessmentForm.employeeId,
            startDate: this.assessmentForm.dateRange[0],
            endDate: this.assessmentForm.dateRange[1],
            assessorId: this.assessmentForm.assessorId || null,
            managerScore: this.assessmentForm.managerScore
          }
          const { data } = await this.$http({
            url: 'ops/dbops/generateEmployeeAssessment',
            method: 'post',
            data: payload
          })
          if (data && data.code === 0) {
            this.$message.success('已生成考核记录')
            this.assessmentDialogVisible = false
            await this.loadAll()
            this.activeTab = 'employee'
            this.handleTabChange()
          } else {
            this.$message.error((data && data.msg) || '生成考核失败')
          }
        } catch (error) {
          this.$message.error('生成考核失败')
        } finally {
          this.assessmentLoading = false
        }
      })
    },
    exportCurrentTab() {
      const config = this.exportConfigByTab(this.activeTab)
      if (!config.rows.length) {
        this.$message.warning('当前筛选结果为空，暂无可导出数据')
        return
      }
      const csv = this.buildCsv(config.fields, config.rows)
      const blob = new Blob([`\uFEFF${csv}`], { type: 'text/csv;charset=utf-8;' })
      const link = document.createElement('a')
      link.href = URL.createObjectURL(blob)
      link.download = `${config.fileName}_${this.timestampText()}.csv`
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
      URL.revokeObjectURL(link.href)
      this.$message.success(`已导出 ${config.rows.length} 条记录`)
    },
    exportConfigByTab(tab) {
      if (tab === 'finance') {
        return {
          fileName: 'finance_report',
          fields: [
            ['月份', 'revenue_month'],
            ['房型', 'room_category'],
            ['支付方式', 'pay_method'],
            ['总收入', 'gross_revenue'],
            ['退款', 'refund_amount'],
            ['净收入', 'net_revenue'],
            ['支付笔数', 'payment_count']
          ],
          rows: this.filteredFinanceRows.map(row => ({
            ...row,
            pay_method: this.payMethodLabel(row.pay_method)
          }))
        }
      }
      if (tab === 'room') {
        return {
          fileName: 'room_status_report',
          fields: [
            ['酒店', 'hotel_name'],
            ['客房', 'room_name'],
            ['房型', 'room_category'],
            ['总房数', 'total_rooms'],
            ['可预订', 'available_rooms'],
            ['已预订', 'reserved_rooms'],
            ['入住中', 'occupied_rooms'],
            ['清扫中', 'cleaning_rooms'],
            ['维修中', 'maintenance_rooms']
          ],
          rows: this.filteredRoomRows
        }
      }
      return {
        fileName: 'employee_report',
        fields: [
          ['员工', 'employee_name'],
          ['员工工号', 'employee_no'],
          ['开始日期', 'period_start'],
          ['结束日期', 'period_end'],
          ['入住办理', 'checkin_count'],
          ['账单', 'bill_count'],
          ['支付', 'payment_count'],
          ['清扫', 'cleaning_count'],
          ['维修', 'maintenance_count'],
          ['管理加分', 'manager_score'],
          ['总分', 'total_score'],
          ['等级', 'grade']
        ],
        rows: this.filteredEmployeeRows
      }
    },
    buildCsv(fields, rows) {
      const header = fields.map(item => this.escapeCsv(item[0])).join(',')
      const body = rows.map(row => fields.map(item => this.escapeCsv(row[item[1]])).join(',')).join('\n')
      return `${header}\n${body}`
    },
    escapeCsv(value) {
      if (value === null || value === undefined) {
        return '""'
      }
      const text = String(value).replace(/"/g, '""')
      return `"${text}"`
    },
    timestampText() {
      const now = new Date()
      const pad = value => String(value).padStart(2, '0')
      return `${now.getFullYear()}${pad(now.getMonth() + 1)}${pad(now.getDate())}_${pad(now.getHours())}${pad(now.getMinutes())}${pad(now.getSeconds())}`
    },
    resizeCharts() {
      Object.keys(this.charts).forEach(key => {
        const chart = this.charts[key]
        if (chart) {
          chart.resize()
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.report-page {
  padding: 18px;
  background: #f5f7fa;
  min-height: calc(100vh - 80px);
}

.report-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 14px;
}

.report-head h2 {
  margin: 0;
  font-size: 22px;
  color: #263238;
}

.head-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.metric-row {
  margin-bottom: 12px;
}

.metric {
  height: 86px;
  padding: 16px;
  margin-bottom: 12px;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
}

.metric span {
  display: block;
  color: #667085;
  font-size: 13px;
}

.metric strong {
  display: block;
  margin-top: 10px;
  color: #1f2937;
  font-size: 24px;
}

.filter-panel,
.panel,
.meta-card {
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
}

.filter-panel {
  margin-bottom: 12px;
  padding: 14px;
}

.filter-grid {
  display: grid;
  grid-template-columns: minmax(260px, 1.3fr) minmax(160px, 1fr) minmax(180px, 1fr) auto;
  gap: 12px;
  align-items: center;
}

.filter-grid.compact {
  grid-template-columns: minmax(260px, 1.4fr) minmax(180px, 1fr) auto;
}

.filter-actions {
  display: flex;
  justify-content: flex-end;
}

.filter-summary {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  margin-top: 12px;
  color: #667085;
  font-size: 13px;
}

.meta-panel {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
  margin-bottom: 12px;
}

.meta-card {
  padding: 14px;
}

.meta-title {
  margin-bottom: 8px;
  color: #344054;
  font-weight: 600;
}

.meta-list {
  display: grid;
  gap: 6px;
  color: #667085;
  font-size: 13px;
}

.panel {
  margin-bottom: 16px;
  padding: 14px;
}

.secondary-panel {
  margin-top: 16px;
}

.panel-title {
  margin-bottom: 8px;
  color: #344054;
  font-weight: 600;
}

.tab-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.tab-actions .el-alert {
  flex: 1;
}

.chart {
  width: 100%;
  height: 360px;
}

.data-table {
  margin-top: 4px;
}

@media (max-width: 1200px) {
  .filter-grid,
  .meta-panel {
    grid-template-columns: 1fr 1fr;
  }

  .filter-grid.compact {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 768px) {
  .report-head,
  .tab-actions {
    flex-direction: column;
    align-items: stretch;
  }

  .head-actions {
    justify-content: flex-start;
  }

  .filter-grid,
  .meta-panel,
  .filter-grid.compact {
    grid-template-columns: 1fr;
  }

  .filter-actions {
    justify-content: flex-start;
  }
}
</style>
