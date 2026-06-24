<template>
  <div class="flow-page">
    <div class="page-head">
      <div>
        <h2>订单与入住人</h2>
        <p>按订单号或订单 ID 查看预订、支付、入住、离店流程，以及预订入住人与实际入住人的明细。</p>
      </div>
      <div class="head-actions">
        <el-button size="small" icon="el-icon-refresh" @click="reloadCurrent">刷新</el-button>
      </div>
    </div>

    <div class="page-panel search-panel">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="订单号">
          <el-input
            v-model.trim="searchForm.bookingNo"
            clearable
            size="small"
            style="width: 220px;"
            placeholder="例如 BK202604290007"
            @keyup.enter.native="searchFlow"
          />
        </el-form-item>
        <el-form-item label="订单ID">
          <el-input
            v-model.trim="searchForm.bookingId"
            clearable
            size="small"
            style="width: 160px;"
            placeholder="例如 6007"
            @keyup.enter.native="searchFlow"
          />
        </el-form-item>
        <el-form-item>
          <el-button size="small" type="primary" icon="el-icon-search" @click="searchFlow">查询</el-button>
          <el-button size="small" @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div v-loading="loading">
      <div v-if="flow" class="flow-content">
        <el-row :gutter="16" class="summary-row">
          <el-col :xs="24" :sm="12" :lg="6">
            <div class="summary-card">
              <span>当前阶段</span>
              <strong>{{ flow.currentStage }}</strong>
            </div>
          </el-col>
          <el-col :xs="24" :sm="12" :lg="6">
            <div class="summary-card">
              <span>支付状态</span>
              <strong>{{ payStatusLabel(flow.booking.ispay) }}</strong>
            </div>
          </el-col>
          <el-col :xs="24" :sm="12" :lg="6">
            <div class="summary-card">
              <span>账单状态</span>
              <strong>{{ flow.billSummary ? billStatusLabel(flow.billSummary.bill_status) : '未生成账单' }}</strong>
            </div>
          </el-col>
          <el-col :xs="24" :sm="12" :lg="6">
            <div class="summary-card">
              <span>入住人数</span>
              <strong>{{ guestCountText }}</strong>
            </div>
          </el-col>
        </el-row>

        <el-row :gutter="16">
          <el-col :xs="24" :lg="15">
            <div class="page-panel">
              <div class="section-title">
                <span>订单总览</span>
                <el-tag size="small" effect="plain">{{ flow.booking.yudingbianhao }}</el-tag>
              </div>
              <div class="info-grid">
                <div class="info-item"><label>客户账号</label><span>{{ flow.booking.customerming || '-' }}</span></div>
                <div class="info-item"><label>客户姓名</label><span>{{ flow.booking.xingming || '-' }}</span></div>
                <div class="info-item"><label>客房名称</label><span>{{ flow.booking.kefangmingcheng || '-' }}</span></div>
                <div class="info-item"><label>客房类型</label><span>{{ flow.booking.room_category || '-' }}</span></div>
                <div class="info-item"><label>预计入住</label><span>{{ formatDate(flow.booking.expected_checkin_date) }}</span></div>
                <div class="info-item"><label>预计离店</label><span>{{ formatDate(flow.booking.expected_checkout_date) }}</span></div>
                <div class="info-item"><label>订单金额</label><span>{{ money(flow.booking.zongjine) }}</span></div>
                <div class="info-item"><label>创建时间</label><span>{{ formatDateTime(flow.booking.addtime) }}</span></div>
              </div>
            </div>

            <div class="page-panel">
              <div class="section-title">
                <span>房间锁定与入住安排</span>
              </div>
              <el-table :data="flow.bookingRooms || []" border size="small">
                <el-table-column prop="room_no" label="房号" min-width="90" />
                <el-table-column prop="room_name" label="房间名称" min-width="140" />
                <el-table-column prop="room_category" label="房型" min-width="120" />
                <el-table-column prop="room_price" label="锁定单价" min-width="100">
                  <template slot-scope="{ row }">{{ money(row.room_price) }}</template>
                </el-table-column>
                <el-table-column prop="stay_start_date" label="入住日期" min-width="110">
                  <template slot-scope="{ row }">{{ formatDate(row.stay_start_date) }}</template>
                </el-table-column>
                <el-table-column prop="stay_end_date" label="离店日期" min-width="110">
                  <template slot-scope="{ row }">{{ formatDate(row.stay_end_date) }}</template>
                </el-table-column>
                <el-table-column prop="room_status" label="业务状态" min-width="100">
                  <template slot-scope="{ row }">{{ bookingStatusLabel(row.room_status) }}</template>
                </el-table-column>
                <el-table-column prop="room_current_status" label="当前房态" min-width="100">
                  <template slot-scope="{ row }">{{ roomStatusLabel(row.room_current_status) }}</template>
                </el-table-column>
              </el-table>
            </div>

            <div class="page-panel">
              <div class="section-title">
                <span>账单与支付流水</span>
              </div>
              <div class="bill-grid">
                <div class="info-item"><label>应收金额</label><span>{{ money(flow.billSummary && flow.billSummary.payable_amount) }}</span></div>
                <div class="info-item"><label>实收金额</label><span>{{ money(flow.billSummary && flow.billSummary.actual_paid_amount) }}</span></div>
                <div class="info-item"><label>退款金额</label><span>{{ money(flow.billSummary && flow.billSummary.actual_refund_amount) }}</span></div>
                <div class="info-item"><label>最近支付</label><span>{{ formatDateTime(flow.billSummary && flow.billSummary.last_paid_at) }}</span></div>
              </div>
              <el-table :data="flow.paymentRecords || []" border size="small" style="margin-top: 16px;">
                <el-table-column prop="payment_no" label="支付单号" min-width="170" />
                <el-table-column prop="pay_method" label="支付方式" min-width="100">
                  <template slot-scope="{ row }">{{ paymentMethodLabel(row.pay_method) }}</template>
                </el-table-column>
                <el-table-column prop="pay_amount" label="支付金额" min-width="100">
                  <template slot-scope="{ row }">{{ money(row.pay_amount) }}</template>
                </el-table-column>
                <el-table-column prop="pay_status" label="支付结果" min-width="100">
                  <template slot-scope="{ row }">{{ paymentStatusLabel(row.pay_status) }}</template>
                </el-table-column>
                <el-table-column prop="paid_at" label="支付时间" min-width="168">
                  <template slot-scope="{ row }">{{ formatDateTime(row.paid_at) }}</template>
                </el-table-column>
                <el-table-column prop="remark" label="备注" min-width="180" show-overflow-tooltip />
              </el-table>
            </div>
          </el-col>

          <el-col :xs="24" :lg="9">
            <div class="page-panel">
              <div class="section-title">
                <span>入住人信息</span>
              </div>
              <div class="guest-subtitle">预订入住人</div>
              <el-table :data="flow.bookingGuests || []" border size="small">
                <el-table-column prop="guest_name" label="姓名" min-width="100" />
                <el-table-column prop="id_card_no" label="身份证号" min-width="160" show-overflow-tooltip />
                <el-table-column prop="phone" label="联系电话" min-width="120" />
                <el-table-column prop="is_primary" label="身份" min-width="90">
                  <template slot-scope="{ row }">{{ Number(row.is_primary) === 1 ? '主入住人' : '同行人' }}</template>
                </el-table-column>
              </el-table>
              <div class="guest-subtitle actual">实际入住人</div>
              <el-table v-if="(flow.checkinGuests || []).length" :data="flow.checkinGuests || []" border size="small">
                <el-table-column prop="guest_name" label="姓名" min-width="100" />
                <el-table-column prop="id_card_no" label="身份证号" min-width="160" show-overflow-tooltip />
                <el-table-column prop="phone" label="联系电话" min-width="120" />
                <el-table-column prop="is_primary" label="身份" min-width="90">
                  <template slot-scope="{ row }">{{ Number(row.is_primary) === 1 ? '主入住人' : '同行人' }}</template>
                </el-table-column>
              </el-table>
              <div v-else class="empty-tip">当前订单尚未登记实际入住人。</div>
            </div>

            <div class="page-panel">
              <div class="section-title">
                <span>实际入住信息</span>
              </div>
              <div v-if="flow.checkinRecord" class="info-grid single-column">
                <div class="info-item"><label>入住状态</label><span>{{ checkinStatusLabel(flow.checkinRecord.status) }}</span></div>
                <div class="info-item"><label>办理员工</label><span>{{ flow.checkinRecord.employee_name || '-' }}</span></div>
                <div class="info-item"><label>房号</label><span>{{ flow.checkinRecord.room_no || '-' }}</span></div>
                <div class="info-item"><label>入住时间</label><span>{{ formatDateTime(flow.checkinRecord.checkin_time) }}</span></div>
                <div class="info-item"><label>离店时间</label><span>{{ formatDateTime(flow.checkinRecord.checkout_time) }}</span></div>
                <div class="info-item"><label>备注</label><span>{{ flow.checkinRecord.remark || '-' }}</span></div>
              </div>
              <div v-else class="empty-tip">当前订单尚未生成入住记录。</div>
            </div>

            <div class="page-panel">
              <div class="section-title">
                <span>订单时间线</span>
              </div>
              <el-timeline>
                <el-timeline-item
                  v-for="item in flow.timeline || []"
                  :key="`${item.key}-${item.time}`"
                  :timestamp="formatDateTime(item.time)"
                  placement="top"
                >
                  <div class="timeline-card">
                    <strong>{{ item.title }}</strong>
                    <p>{{ item.description }}</p>
                  </div>
                </el-timeline-item>
              </el-timeline>
            </div>
          </el-col>
        </el-row>
      </div>

      <div v-else class="page-panel empty-panel">
        <el-empty description="请输入订单号或订单 ID 查询订单业务流" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  computed: {
    guestCountText() {
      if (!this.flow) {
        return '0 / 0'
      }
      const bookingCount = (this.flow.bookingGuests || []).length
      const checkinCount = (this.flow.checkinGuests || []).length
      return `${bookingCount} / ${checkinCount}`
    }
  },
  data() {
    return {
      loading: false,
      flow: null,
      searchForm: {
        bookingNo: '',
        bookingId: ''
      }
    }
  },
  mounted() {
    this.searchForm.bookingNo = this.$route.query.bookingNo || ''
    this.searchForm.bookingId = this.$route.query.bookingId || ''
    if (this.searchForm.bookingNo || this.searchForm.bookingId) {
      this.searchFlow()
    }
  },
  methods: {
    searchFlow() {
      if (!this.searchForm.bookingNo && !this.searchForm.bookingId) {
        this.$message.warning('请先输入订单号或订单 ID')
        return
      }
      this.loading = true
      this.$http({
        url: 'ops/bookingFlow/detail',
        method: 'get',
        params: {
          bookingNo: this.searchForm.bookingNo || undefined,
          bookingId: this.searchForm.bookingId || undefined
        }
      }).then(({ data }) => {
        if (data && data.code === 0) {
          this.flow = data.data || null
        } else {
          this.flow = null
          this.$message.error((data && data.msg) || '订单追踪加载失败')
        }
      }).catch(error => {
        this.flow = null
        this.$message.error((error && error.message) || '订单追踪加载失败')
      }).finally(() => {
        this.loading = false
      })
    },
    reloadCurrent() {
      if (this.flow) {
        this.searchFlow()
      }
    },
    resetSearch() {
      this.searchForm.bookingNo = ''
      this.searchForm.bookingId = ''
      this.flow = null
    },
    money(value) {
      const num = Number(value || 0)
      return `¥${num.toFixed(2)}`
    },
    formatDate(value) {
      if (!value) {
        return '-'
      }
      return String(value).replace('T', ' ').slice(0, 10)
    },
    formatDateTime(value) {
      if (!value) {
        return '-'
      }
      const text = String(value).replace('T', ' ')
      return text.length >= 19 ? text.slice(0, 19) : text
    },
    bookingStatusLabel(value) {
      return {
        reserved: '已锁房',
        checked_in: '已入住',
        completed: '已完成',
        cancelled: '已取消'
      }[value] || (value || '-')
    },
    payStatusLabel(value) {
      return {
        unpaid: '未支付',
        partial: '部分支付',
        paid: '已支付',
        refunded: '已退款'
      }[value] || (value || '-')
    },
    billStatusLabel(value) {
      return {
        unpaid: '未收款',
        partial: '部分收款',
        paid: '已结清',
        refunded: '已退款'
      }[value] || (value || '-')
    },
    paymentMethodLabel(value) {
      return {
        cash: '现金',
        card: '银行卡',
        alipay: '支付宝',
        wechat: '微信'
      }[value] || (value || '-')
    },
    paymentStatusLabel(value) {
      return {
        success: '成功',
        failed: '失败',
        cancelled: '已取消'
      }[value] || (value || '-')
    },
    roomStatusLabel(value) {
      return {
        available: '可预订',
        reserved: '已预订',
        occupied: '入住中',
        cleaning: '清扫中',
        maintenance: '维修中'
      }[value] || (value || '-')
    },
    checkinStatusLabel(value) {
      return {
        checked_in: '入住中',
        checked_out: '已离店',
        cancelled: '已取消'
      }[value] || (value || '-')
    }
  }
}
</script>

<style lang="scss" scoped>
.flow-page {
  padding: 20px;
}

.page-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
}

.page-head h2 {
  margin: 0 0 6px;
  color: #22303c;
}

.page-head p {
  margin: 0;
  color: #708090;
}

.page-panel {
  background: #fff;
  border-radius: 8px;
  padding: 16px;
  box-shadow: 0 8px 20px rgba(31, 41, 55, 0.06);
  margin-bottom: 16px;
}

.summary-row {
  margin-bottom: 16px;
}

.summary-card {
  background: linear-gradient(180deg, #ffffff 0%, #f6fbfb 100%);
  border: 1px solid #e5eef0;
  border-radius: 8px;
  padding: 16px;
  min-height: 92px;
}

.summary-card span {
  display: block;
  color: #7a8793;
  font-size: 13px;
}

.summary-card strong {
  display: block;
  margin-top: 10px;
  font-size: 24px;
  color: #1f2d3d;
}

.section-title {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 14px;
  font-size: 16px;
  font-weight: 600;
  color: #22303c;
}

.guest-subtitle {
  margin-bottom: 10px;
  color: #7a8793;
  font-size: 13px;
}

.guest-subtitle.actual {
  margin-top: 16px;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px 16px;
}

.info-grid.single-column {
  grid-template-columns: minmax(0, 1fr);
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
  padding: 12px 14px;
  border-radius: 6px;
  background: #f8fafc;
}

.info-item label {
  font-size: 12px;
  color: #7a8793;
}

.info-item span {
  color: #22303c;
  word-break: break-all;
}

.bill-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px 16px;
}

.timeline-card strong {
  display: block;
  margin-bottom: 6px;
  color: #22303c;
}

.timeline-card p {
  margin: 0;
  color: #6b7785;
  line-height: 1.6;
}

.empty-panel {
  min-height: 320px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-tip {
  color: #7a8793;
  line-height: 1.7;
}

@media (max-width: 992px) {
  .page-head {
    flex-direction: column;
    gap: 12px;
  }

  .info-grid,
  .bill-grid {
    grid-template-columns: minmax(0, 1fr);
  }
}
</style>
