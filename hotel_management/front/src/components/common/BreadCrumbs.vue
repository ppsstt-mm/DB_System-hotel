<template>
  <div class="breadcrumbs">
    <el-breadcrumb separator="/">
      <el-breadcrumb-item>首页</el-breadcrumb-item>
      <el-breadcrumb-item v-if="currentLabel">{{ currentLabel }}</el-breadcrumb-item>
    </el-breadcrumb>
  </div>
</template>

<script>
import menu from '@/utils/menu'

export default {
  computed: {
    currentLabel() {
      const routeName = this.$route.name
      if (!routeName || routeName === 'home') {
        return ''
      }
      if (routeName === 'center') {
        return '个人信息'
      }
      if (routeName === 'updatePassword') {
        return '修改密码'
      }
      if (routeName === 'operations_report') {
        const tabMap = {
          finance: '财务报表',
          room: '房态报表',
          employee: '员工考核报表'
        }
        return tabMap[this.$route.query.tab] || '经营报表'
      }
      const menus = menu.list()
      for (const roleMenu of menus) {
        for (const group of roleMenu.backMenu || []) {
          for (const item of group.child || []) {
            if (item.tableName === routeName) {
              return item.menu
            }
          }
        }
      }
      return routeName
    }
  }
}
</script>

<style lang="scss" scoped>
.breadcrumbs {
  padding: 12px 16px;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
}

.breadcrumbs /deep/ .el-breadcrumb__inner,
.breadcrumbs /deep/ .el-breadcrumb__separator {
  color: #667085;
}

.breadcrumbs /deep/ .el-breadcrumb__inner.is-link {
  color: #248b92;
}
</style>
