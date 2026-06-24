<template>
  <div class="ops-page">
    <div class="page-head">
      <div>
        <h2>{{ module.title }}</h2>
        <p v-if="module.description">{{ module.description }}</p>
      </div>
      <div class="head-actions">
        <el-button
          v-for="action in pageActions"
          :key="action.key"
          size="small"
          :type="action.type || 'warning'"
          plain
          @click="handlePageAction(action)"
        >
          {{ action.label }}
        </el-button>
        <el-button size="small" icon="el-icon-refresh" @click="fetchTableData">刷新</el-button>
        <el-button
          v-if="canCreate"
          size="small"
          type="primary"
          icon="el-icon-plus"
          @click="openCreate"
        >
          新增
        </el-button>
        <el-button
          v-if="canDelete"
          size="small"
          type="danger"
          icon="el-icon-delete"
          :disabled="!selectedRows.length"
          @click="deleteSelected"
        >
          批量删除
        </el-button>
      </div>
    </div>

    <div class="page-panel search-panel">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item v-for="field in searchFields" :key="field.prop" :label="field.label">
          <el-select
            v-if="isSelectField(field)"
            v-model="searchForm[field.prop]"
            clearable
            filterable
            size="small"
            style="width: 220px;"
            :placeholder="`请选择${field.label}`"
          >
            <el-option
              v-for="option in resolveOptions(field)"
              :key="`${field.prop}-${option.value}`"
              :label="option.label"
              :value="option.value"
            />
          </el-select>
          <el-date-picker
            v-else-if="field.type === 'date'"
            v-model="searchForm[field.prop]"
            size="small"
            type="date"
            value-format="yyyy-MM-dd"
            style="width: 220px;"
            :placeholder="`请选择${field.label}`"
          />
          <el-date-picker
            v-else-if="field.type === 'datetime'"
            v-model="searchForm[field.prop]"
            size="small"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            style="width: 220px;"
            :placeholder="`请选择${field.label}`"
          />
          <el-input
            v-else
            v-model="searchForm[field.prop]"
            clearable
            size="small"
            style="width: 220px;"
            :placeholder="`请输入${field.label}`"
          />
        </el-form-item>
        <el-form-item>
          <el-button size="small" type="primary" icon="el-icon-search" @click="search">查询</el-button>
          <el-button size="small" @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="page-panel table-panel">
      <el-table
        :data="tableData"
        border
        size="small"
        v-loading="loading"
        @selection-change="selectedRows = $event"
      >
        <el-table-column v-if="canDelete" type="selection" width="48" />
        <el-table-column type="index" label="#" width="56" />
        <el-table-column
          v-for="field in tableFields"
          :key="field.prop"
          :prop="field.prop"
          :label="field.label"
          :min-width="field.tableWidth || 140"
          show-overflow-tooltip
        >
          <template slot-scope="{ row }">
            <div v-if="field.type === 'image'" class="image-cell">
              <img v-if="row[field.prop]" :src="$base.url + row[field.prop]" :alt="field.label">
              <span v-else>-</span>
            </div>
            <span v-else>{{ formatCell(row, field) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="320" fixed="right">
          <template slot-scope="{ row }">
            <el-button size="mini" type="success" plain @click="openView(row)">查看</el-button>
            <el-button
              v-for="action in rowActions"
              :key="`${action.key}-${row.id}`"
              size="mini"
              :type="action.type || 'warning'"
              plain
              @click="handleRowAction(action, row)"
            >
              {{ action.label }}
            </el-button>
            <el-button v-if="canUpdate" size="mini" type="primary" plain @click="openEdit(row)">修改</el-button>
            <el-button v-if="canDelete" size="mini" type="danger" plain @click="deleteOne(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrap">
        <el-pagination
          background
          layout="total, prev, pager, next, sizes"
          :current-page="pageIndex"
          :page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          @current-change="pageIndex = $event; fetchTableData()"
          @size-change="pageSize = $event; pageIndex = 1; fetchTableData()"
        />
      </div>
    </div>

    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      width="720px"
      :close-on-click-modal="false"
    >
      <el-form ref="editForm" :model="editForm" :rules="rules" label-width="108px">
        <el-row :gutter="16">
          <el-col :span="12" v-for="field in formFields" :key="field.prop">
            <el-form-item :label="field.label" :prop="field.prop">
              <el-select
                v-if="isSelectField(field)"
                v-model="editForm[field.prop]"
                clearable
                filterable
                :disabled="field.readonly || dialogMode === 'view'"
                style="width: 100%;"
              >
                <el-option
                  v-for="option in resolveOptions(field)"
                  :key="`${field.prop}-form-${option.value}`"
                  :label="option.label"
                  :value="option.value"
                />
              </el-select>
              <el-date-picker
                v-else-if="field.type === 'date'"
                v-model="editForm[field.prop]"
                type="date"
                value-format="yyyy-MM-dd"
                style="width: 100%;"
                :disabled="field.readonly || dialogMode === 'view'"
              />
              <el-date-picker
                v-else-if="field.type === 'datetime'"
                v-model="editForm[field.prop]"
                type="datetime"
                value-format="yyyy-MM-dd HH:mm:ss"
                style="width: 100%;"
                :disabled="field.readonly || dialogMode === 'view'"
              />
              <el-input-number
                v-else-if="field.type === 'number'"
                v-model="editForm[field.prop]"
                :disabled="field.readonly || dialogMode === 'view'"
                :controls-position="'right'"
                style="width: 100%;"
              />
              <el-input
                v-else-if="field.type === 'textarea'"
                v-model="editForm[field.prop]"
                type="textarea"
                :rows="4"
                :disabled="field.readonly || dialogMode === 'view'"
              />
              <el-input
                v-else
                v-model="editForm[field.prop]"
                :type="field.type === 'password' && dialogMode !== 'view' ? 'password' : 'text'"
                :show-password="field.type === 'password' && dialogMode !== 'view'"
                :disabled="field.readonly || dialogMode === 'view'"
              />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <span slot="footer">
        <el-button @click="dialogVisible = false">{{ dialogMode === 'view' ? '关闭' : '取消' }}</el-button>
        <el-button v-if="dialogMode !== 'view'" type="primary" :loading="submitLoading" @click="submitForm">
          保存
        </el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { isAuth } from '@/utils/utils'
import { getModuleConfig, getOptionLabel } from './module-registry'

export default {
  data() {
    return {
      loading: false,
      submitLoading: false,
      module: { title: '', description: '', fields: [], searchFields: [] },
      searchForm: {},
      tableData: [],
      selectedRows: [],
      pageIndex: 1,
      pageSize: 10,
      total: 0,
      dialogVisible: false,
      dialogMode: 'view',
      editForm: {},
      optionRows: {}
    }
  },
  computed: {
    searchFields() {
      return (this.module.searchFields || [])
        .map(prop => this.module.fields.find(field => field.prop === prop))
        .filter(Boolean)
    },
    tableFields() {
      return (this.module.fields || []).filter(field => field.table !== false)
    },
    formFields() {
      return (this.module.fields || []).filter(field => field.prop !== 'id' && field.form !== false)
    },
    rules() {
      const rules = {}
      this.formFields.forEach(field => {
        if (field.required && !field.readonly) {
          rules[field.prop] = [{ required: true, message: `请填写${field.label}`, trigger: 'blur' }]
          if (this.isSelectField(field) || field.type === 'date' || field.type === 'datetime') {
            rules[field.prop][0].trigger = 'change'
          }
        }
      })
      return rules
    },
    canCreate() {
      return !this.module.readonlyModule && isAuth(this.module.tableName, '新增')
    },
    canUpdate() {
      return !this.module.readonlyModule && isAuth(this.module.tableName, '修改')
    },
    canDelete() {
      return !this.module.readonlyModule && isAuth(this.module.tableName, '删除')
    },
    dialogTitle() {
      const actionMap = {
        create: '新增',
        edit: '修改',
        view: '查看'
      }
      return `${actionMap[this.dialogMode] || '查看'}${this.module.title}`
    },
    rowActions() {
      return Array.isArray(this.module.extraRowActions) ? this.module.extraRowActions : []
    },
    pageActions() {
      return Array.isArray(this.module.extraPageActions) ? this.module.extraPageActions : []
    }
  },
  watch: {
    '$route.name': {
      immediate: true,
      handler() {
        this.bootstrapModule()
      }
    }
  },
  methods: {
    bootstrapModule() {
      const module = getModuleConfig(this.$route.name)
      if (!module) {
        this.$message.error('未找到模块配置')
        return
      }
      this.module = module
      this.pageIndex = 1
      this.pageSize = module.pageSize || 10
      this.selectedRows = []
      this.searchForm = this.createEmptyForm(this.searchFields)
      this.editForm = this.createEmptyForm(this.formFields)
      this.loadOptions().then(() => {
        this.fetchTableData()
      })
    },
    createEmptyForm(fields) {
      const form = {}
      fields.forEach(field => {
        form[field.prop] = field.defaultValue !== undefined ? field.defaultValue : ''
      })
      return form
    },
    async loadOptions() {
      const sources = Array.from(new Set(
        (this.module.fields || [])
          .filter(field => field.optionSource)
          .map(field => field.optionSource)
      ))
      const rows = {}
      await Promise.all(sources.map(source => {
        return this.$http({
          url: `ops/${source}/list`,
          method: 'get',
          params: { sort: 'id', order: 'asc' }
        }).then(({ data }) => {
          rows[source] = data && data.code === 0 && Array.isArray(data.data) ? data.data : []
        }).catch(() => {
          rows[source] = []
        })
      }))
      this.optionRows = rows
    },
    fetchTableData() {
      this.loading = true
      const params = {
        page: this.pageIndex,
        limit: this.pageSize,
        sort: this.module.sort || 'id',
        order: 'desc'
      }
      this.searchFields.forEach(field => {
        const value = this.searchForm[field.prop]
        if (value === '' || value === null || value === undefined) {
          return
        }
        params[field.prop] = this.isSelectField(field) || field.type === 'date' || field.type === 'datetime'
          ? value
          : `%${value}%`
      })
      this.$http({
        url: `ops/${this.module.tableName}/page`,
        method: 'get',
        params
      }).then(({ data }) => {
        if (data && data.code === 0 && data.data) {
          this.tableData = Array.isArray(data.data.list) ? data.data.list : []
          this.total = Number(data.data.total || 0)
        } else {
          this.tableData = []
          this.total = 0
        }
      }).catch(() => {
        this.tableData = []
        this.total = 0
        this.$message.error('列表加载失败')
      }).finally(() => {
        this.loading = false
      })
    },
    search() {
      this.pageIndex = 1
      this.fetchTableData()
    },
    resetSearch() {
      this.searchForm = this.createEmptyForm(this.searchFields)
      this.search()
    },
    resolveOptions(field) {
      if (field.options) {
        return field.options.map(item => ({
          label: item.label,
          value: item.value
        }))
      }
      if (!field.optionSource) {
        return []
      }
      const sourceRows = this.optionRows[field.optionSource] || []
      return sourceRows.map(row => ({
        label: getOptionLabel(row, field.optionLabelFields),
        value: row[field.optionValueField || 'id']
      }))
    },
    isSelectField(field) {
      return field.type === 'select' || !!field.optionSource
    },
    formatCell(row, field) {
      const value = row[field.prop]
      if (value === null || value === undefined || value === '') {
        return this.emptyText(field)
      }
      if (field.optionSource) {
        const sourceRows = this.optionRows[field.optionSource] || []
        const matched = sourceRows.find(item => String(item[field.optionValueField || 'id']) === String(value))
        return matched ? getOptionLabel(matched, field.optionLabelFields) : value
      }
      if (field.options) {
        const matched = field.options.find(item => String(item.value) === String(value))
        return matched ? matched.label : value
      }
      if (field.type === 'date' || field.type === 'datetime') {
        return this.formatDateValue(value, field.type)
      }
      if (field.type === 'textarea') {
        return String(value).replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim()
      }
      if (field.type === 'password') {
        return '******'
      }
      return value
    },
    emptyText(field) {
      const specialMap = {
        checkout_time: '未退房',
        completed_time: '未完成',
        end_time: '处理中',
        paid_at: '未支付',
        scheduled_time: '待安排',
        last_status_time: '未更新',
        last_booking_time: '暂无'
      }
      return specialMap[field.prop] || '-'
    },
    formatDateValue(value, type) {
      let date = null
      if (typeof value === 'number') {
        date = new Date(value)
      } else if (/^\d{13}$/.test(String(value))) {
        date = new Date(Number(value))
      }
      if (date && !Number.isNaN(date.getTime())) {
        const pad = item => String(item).padStart(2, '0')
        const text = `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`
        return type === 'date' ? text.slice(0, 10) : text
      }
      const text = String(value).replace('T', ' ')
      return type === 'date' ? text.slice(0, 10) : text.slice(0, 19)
    },
    async openView(row) {
      this.dialogMode = 'view'
      if (this.shouldLoadRemoteDetail(row)) {
        await this.loadDetail(row.id)
      } else {
        this.fillFormFromRow(row)
      }
      this.dialogVisible = true
    },
    async openEdit(row) {
      this.dialogMode = 'edit'
      await this.loadDetail(row.id)
      this.dialogVisible = true
      this.$nextTick(() => this.$refs.editForm && this.$refs.editForm.clearValidate())
    },
    openCreate() {
      this.dialogMode = 'create'
      this.editForm = this.createEmptyForm(this.formFields)
      this.dialogVisible = true
      this.$nextTick(() => this.$refs.editForm && this.$refs.editForm.clearValidate())
    },
    loadDetail(id) {
      return this.$http({
        url: `ops/${this.module.tableName}/info/${id}`,
        method: 'get'
      }).then(({ data }) => {
        const detail = data && data.code === 0 && data.data ? data.data : {}
        this.fillFormFromRow(detail)
      }).catch(() => {
        this.$message.error('详情加载失败')
      })
    },
    shouldLoadRemoteDetail(row) {
      return row && row.id !== undefined && row.id !== null && row.id !== ''
    },
    fillFormFromRow(detail) {
      this.editForm = this.formFields.reduce((form, field) => {
        const rawValue = detail && detail[field.prop] !== undefined ? detail[field.prop] : ''
        form[field.prop] = this.normalizeFormValue(field, rawValue)
        return form
      }, { id: detail ? detail.id : undefined })
    },
    normalizeFormValue(field, value) {
      if (value === null || value === undefined || value === '') {
        return ''
      }
      if (field.type === 'date' || field.type === 'datetime') {
        const formatted = this.formatDateValue(value, field.type)
        return field.type === 'date' ? formatted.slice(0, 10) : formatted
      }
      return value
    },
    submitForm() {
      this.$refs.editForm.validate(valid => {
        if (!valid) {
          return
        }
        this.submitLoading = true
        const payload = {}
        if (this.dialogMode === 'edit') {
          payload.id = this.editForm.id
        }
        this.formFields.forEach(field => {
          if (field.readonly) {
            return
          }
          const value = this.editForm[field.prop]
          if (value !== '' && value !== undefined) {
            payload[field.prop] = value
          }
        })
        const url = this.dialogMode === 'edit'
          ? `ops/${this.module.tableName}/update`
          : `ops/${this.module.tableName}/save`
        this.$http({
          url,
          method: 'post',
          data: payload
        }).then(({ data }) => {
          if (data && data.code === 0) {
            this.$message.success('保存成功')
            this.dialogVisible = false
            this.fetchTableData()
          } else {
            this.$message.error((data && data.msg) || '保存失败')
          }
        }).catch(() => {
          this.$message.error('保存失败')
        }).finally(() => {
          this.submitLoading = false
        })
      })
    },
    deleteSelected() {
      this.deleteByIds(this.selectedRows.map(row => row.id))
    },
    deleteOne(row) {
      this.deleteByIds([row.id])
    },
    handleRowAction(action, row) {
      if (!action) {
        return
      }
      if (action.routeName) {
        const query = typeof action.buildQuery === 'function'
          ? action.buildQuery(row)
          : (action.query || {})
        this.$router.push({ name: action.routeName, query })
        return
      }
      if (typeof action.handler === 'function') {
        action.handler.call(this, row)
      }
    },
    handlePageAction(action) {
      if (!action) {
        return
      }
      if (action.routeName) {
        const query = typeof action.buildQuery === 'function'
          ? action.buildQuery()
          : (action.query || {})
        this.$router.push({ name: action.routeName, query })
        return
      }
      if (typeof action.handler === 'function') {
        action.handler.call(this)
      }
    },
    deleteByIds(ids) {
      if (!ids.length) {
        return
      }
      this.$confirm('确认删除选中的记录吗？', '提示', {
        type: 'warning'
      }).then(() => {
        this.$http({
          url: `ops/${this.module.tableName}/delete`,
          method: 'post',
          data: ids
        }).then(({ data }) => {
          if (data && data.code === 0) {
            this.$message.success('删除成功')
            this.selectedRows = []
            this.fetchTableData()
          } else {
            this.$message.error((data && data.msg) || '删除失败')
          }
        }).catch(() => {
          this.$message.error('删除失败')
        })
      }).catch(() => {})
    }
  }
}
</script>

<style lang="scss" scoped>
.ops-page {
  padding: 18px;
  background: #f5f7fa;
  min-height: calc(100vh - 80px);
}

.page-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 14px;
}

.page-head h2 {
  margin: 0;
  color: #263238;
  font-size: 22px;
}

.page-head p {
  margin: 6px 0 0;
  color: #667085;
  line-height: 1.6;
}

.head-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.page-panel {
  margin-bottom: 14px;
  padding: 14px;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
}

.search-form {
  display: flex;
  flex-wrap: wrap;
}

.table-panel {
  padding-bottom: 6px;
}

.pagination-wrap {
  display: flex;
  justify-content: flex-end;
  margin-top: 14px;
}

.image-cell img {
  width: 72px;
  height: 52px;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid #e5e7eb;
}

@media (max-width: 768px) {
  .page-head {
    flex-direction: column;
    align-items: stretch;
  }

  .pagination-wrap {
    justify-content: flex-start;
  }
}
</style>
