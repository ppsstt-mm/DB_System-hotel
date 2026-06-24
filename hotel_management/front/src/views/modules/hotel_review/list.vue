<template>
  <div class="generic-list">
    <el-form :inline="true" size="small" class="toolbar">
      <el-form-item>
        <el-input v-model="keyword" placeholder="输入关键字" clearable @keyup.enter.native="search" />
      </el-form-item>
      <el-button type="primary" size="small" icon="el-icon-search" @click="search">查询</el-button>
      <el-button size="small" icon="el-icon-refresh" @click="reset">重置</el-button>
    </el-form>
    <el-table :data="dataList" border size="small" v-loading="loading">
      <el-table-column v-for="column in visibleColumns" :key="column" :prop="column" :label="columnLabels[column] || column" min-width="120" show-overflow-tooltip />
    </el-table>
    <el-pagination
      background
      layout="total, prev, pager, next, jumper"
      :total="total"
      :page-size="pageSize"
      :current-page.sync="pageIndex"
      @current-change="getDataList"
    />
  </div>
</template>

<script>
export default {
  data() {
    return {
      tableName: 'hotel_review',
      keyword: '',
      dataList: [],
      total: 0,
      pageIndex: 1,
      pageSize: 10,
      loading: false,
      columnLabels: {"id":"ID","refid":"酒店ID","userid":"用户ID","nickname":"昵称","score":"评分","content":"内容","reply":"回复"}
    }
  },
  computed: {
    visibleColumns() {
      if (!this.dataList.length) return Object.keys(this.columnLabels)
      return Object.keys(this.dataList[0]).filter(key => key !== 'mima' && key !== 'password')
    }
  },
  mounted() {
    this.getDataList()
  },
  methods: {
    getDataList() {
      this.loading = true
      const params = { page: this.pageIndex, limit: this.pageSize, sort: 'id' }
      if (this.keyword) {
        const searchColumn = Object.keys(this.columnLabels)[1] || 'id'
        params[searchColumn] = `%${this.keyword}%`
      }
      this.$http({ url: `${this.tableName}/page`, method: 'get', params }).then(({ data }) => {
        if (data && data.code === 0) {
          this.dataList = data.data.list || []
          this.total = data.data.total || 0
        } else {
          this.dataList = []
          this.total = 0
        }
        this.loading = false
      })
    },
    search() {
      this.pageIndex = 1
      this.getDataList()
    },
    reset() {
      this.keyword = ''
      this.search()
    }
  }
}
</script>

<style scoped>
.generic-list { padding: 18px; background: #fff; }
.toolbar { margin-bottom: 12px; }
.el-pagination { margin-top: 14px; text-align: right; }
</style>
