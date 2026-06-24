<template>
  <div class="home-page">
    <div class="hero">
      <div>
        <h2>酒店管理系统后台</h2>
        <p>围绕基础资料、客房资源、预订入住、房态服务、财务结算和报表分析六条主线组织业务。</p>
        <div class="hero-actions">
          <el-button size="small" type="primary" plain @click="openFront">前往前台</el-button>
        </div>
      </div>
      <div class="hero-meta">
        <span>当前角色：{{ role || '-' }}</span>
        <span>当前账号：{{ adminName || '-' }}</span>
      </div>
    </div>

    <el-row :gutter="16">
      <el-col
        v-for="group in currentMenuGroups"
        :key="group.menu"
        :xs="24"
        :sm="12"
        :lg="8"
      >
        <div class="group-card">
          <div class="group-title">{{ group.menu }}</div>
          <div class="group-list">
            <button
              v-for="child in group.child"
              :key="`${group.menu}-${child.menu}`"
              class="group-link"
              @click="go(child)"
            >
              <span>{{ child.menu }}</span>
              <i class="el-icon-arrow-right" />
            </button>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import router from '@/router/router-static'
import menu from '@/utils/menu'

export default {
  data() {
    return {
      role: '',
      adminName: '',
      currentMenuGroups: []
    }
  },
  mounted() {
    this.init()
    this.role = this.$storage.get('role')
    this.adminName = this.$storage.get('adminName')
    const matched = menu.list().find(item => item.roleName === this.role)
    this.currentMenuGroups = matched ? matched.backMenu : []
  },
  methods: {
    init() {
      if (this.$storage.get('Token')) {
        this.$http({
          url: `${this.$storage.get('sessionTable')}/session`,
          method: 'get'
        }).then(({ data }) => {
          if (data && data.code !== 0) {
            router.push({ name: 'login' })
          }
        })
      } else {
        router.push({ name: 'login' })
      }
    },
    go(child) {
      this.$router.push({
        path: `/${child.tableName}`,
        query: child.routeQuery || {}
      })
    },
    openFront() {
      window.open(this.$base.indexUrl, '_blank')
    }
  }
}
</script>

<style lang="scss" scoped>
.home-page {
  padding: 18px;
  background: #f5f7fa;
  min-height: calc(100vh - 80px);
}

.hero {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 16px;
  padding: 18px;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
}

.hero h2 {
  margin: 0;
  color: #263238;
}

.hero p {
  margin: 8px 0 0;
  color: #667085;
  line-height: 1.7;
}

.hero-actions {
  margin-top: 14px;
}

.hero-meta {
  display: grid;
  gap: 8px;
  color: #248b92;
  font-weight: 600;
}

.group-card {
  margin-bottom: 16px;
  padding: 16px;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
}

.group-title {
  margin-bottom: 12px;
  color: #344054;
  font-weight: 700;
}

.group-list {
  display: grid;
  gap: 8px;
}

.group-link {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  padding: 10px 12px;
  color: #344054;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  background: #fff;
  cursor: pointer;
}

.group-link:hover {
  border-color: #248b92;
  color: #248b92;
}

@media (max-width: 768px) {
  .hero {
    flex-direction: column;
  }
}
</style>
