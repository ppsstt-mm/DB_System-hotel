<template>
  <el-aside class="index-aside" width="220px">
    <div class="index-aside-inner">
      <div v-for="item in menuList" :key="item.roleName" v-if="role === item.roleName">
        <el-menu :default-active="activeMenu" unique-opened class="menu-panel">
          <el-menu-item index="home" @click="menuHandler('')">
            <i class="el-icon-s-home" />
            <span>首页</span>
          </el-menu-item>

          <el-submenu index="profile">
            <template slot="title">
              <i class="el-icon-user-solid" />
              <span>个人中心</span>
            </template>
            <el-menu-item index="updatePassword" @click="menuHandler('updatePassword')">修改密码</el-menu-item>
            <el-menu-item index="center" @click="menuHandler('center')">个人信息</el-menu-item>
          </el-submenu>

          <el-submenu
            v-for="(menuGroup, index) in item.backMenu"
            :key="menuGroup.menu"
            :index="`group-${index}`"
          >
            <template slot="title">
              <i :class="icons[index % icons.length]" />
              <span>{{ menuGroup.menu }}</span>
            </template>
            <el-menu-item
              v-for="child in menuGroup.child"
              :key="`${menuGroup.menu}-${child.menu}-${child.tableName}`"
              :index="buildMenuIndex(child)"
              @click="menuHandler(child.tableName, child.routeQuery)"
            >
              {{ child.menu }}
            </el-menu-item>
          </el-submenu>
        </el-menu>
      </div>
    </div>
  </el-aside>
</template>

<script>
import menu from '@/utils/menu'

export default {
  data() {
    return {
      menuList: [],
      role: '',
      icons: [
        'el-icon-s-cooperation',
        'el-icon-s-grid',
        'el-icon-s-shop',
        'el-icon-s-order',
        'el-icon-s-finance',
        'el-icon-s-data',
        'el-icon-s-management'
      ]
    }
  },
  computed: {
    activeMenu() {
      const rawPath = this.$route.path
      const path = rawPath === '/' || rawPath === '/index'
        ? 'home'
        : rawPath.replace(/^\//, '')
      const tab = this.$route.query && this.$route.query.tab
      return tab ? `${path}-${tab}` : path
    }
  },
  mounted() {
    const menus = menu.list()
    this.menuList = menus || []
    this.role = this.$storage.get('role')
  },
  methods: {
    buildMenuIndex(child) {
      return child.routeQuery && child.routeQuery.tab
        ? `${child.tableName}-${child.routeQuery.tab}`
        : child.tableName
    },
    menuHandler(name, routeQuery) {
      if (!name) {
        this.$router.push('/index')
        return
      }
      this.$router.push({
        path: `/${name}`,
        query: routeQuery || {}
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.index-aside {
  background: linear-gradient(180deg, #248b92 0%, #6fb9bf 100%);
}

.index-aside-inner {
  height: 100%;
  overflow-y: auto;
  padding-top: 60px;
}

.menu-panel {
  min-height: calc(100vh - 60px);
  border-right: 0;
  background: transparent;
}

.menu-panel /deep/ .el-menu-item,
.menu-panel /deep/ .el-submenu__title {
  color: #fff;
  background: transparent;
}

.menu-panel /deep/ .el-menu-item i,
.menu-panel /deep/ .el-submenu__title i {
  color: rgba(255, 255, 255, 0.92);
}

.menu-panel /deep/ .el-menu-item:hover,
.menu-panel /deep/ .el-submenu__title:hover {
  background: rgba(255, 255, 255, 0.14);
}

.menu-panel /deep/ .el-menu-item.is-active {
  background: rgba(255, 255, 255, 0.18);
  color: #fff;
}

.menu-panel /deep/ .el-submenu .el-menu {
  background: rgba(255, 255, 255, 0.96);
}

.menu-panel /deep/ .el-submenu .el-menu-item {
  color: #263238;
}

.menu-panel /deep/ .el-submenu .el-menu-item:hover,
.menu-panel /deep/ .el-submenu .el-menu-item.is-active {
  background: rgba(36, 139, 146, 0.12);
  color: #248b92;
}
</style>
