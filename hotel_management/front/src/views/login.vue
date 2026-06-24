<template>
  <div class="login-page">
    <div class="login-panel">
      <h2>酒店管理系统</h2>
      <el-form :model="form" label-width="70px">
        <el-form-item label="角色">
          <el-select v-model="form.tableName" style="width:100%" @change="roleChanged">
            <el-option v-for="item in roles" :key="item.tableName" :label="item.roleName" :value="item.tableName" />
          </el-select>
        </el-form-item>
        <el-form-item label="账号">
          <el-input v-model="form.username" clearable />
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="form.password" type="password" clearable @keyup.enter.native="login" />
        </el-form-item>
        <el-button type="primary" style="width:100%" @click="login">登录</el-button>
        <el-button style="width:100%;margin-top:12px" @click="openFront">前往前台</el-button>
      </el-form>
    </div>
  </div>
</template>

<script>
import menu from '@/utils/menu'
export default {
  data() {
    const roles = menu.list().filter(item => item.hasBackLogin === '是')
    return {
      roles,
      form: {
        tableName: roles[0] ? roles[0].tableName : 'admin_user',
        username: '',
        password: ''
      }
    }
  },
  methods: {
    roleChanged() {},
    openFront() {
      window.location.href = this.$base.indexUrl
    },
    login() {
      if (!this.form.username || !this.form.password) {
        this.$message.error('请输入账号和密码')
        return
      }
      const formData = new URLSearchParams()
      formData.append('username', this.form.username)
      formData.append('password', this.form.password)
      this.$http({
        url: `${this.form.tableName}/login`,
        method: 'post',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        data: formData
      }).then(({ data }) => {
        if (data && data.code === 0) {
          const role = this.roles.find(item => item.tableName === this.form.tableName)
          this.$storage.set('Token', data.auth_token)
          this.$storage.set('role', role ? role.roleName : '')
          this.$storage.set('sessionTable', this.form.tableName)
          this.$storage.set('adminName', this.form.username)
          this.$router.replace('/index')
        } else {
          this.$message.error(data.msg || '登录失败')
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #eef3f7;
}
.login-panel {
  width: 360px;
  padding: 28px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 10px 30px rgba(31, 41, 55, .12);
}
.login-panel h2 {
  margin: 0 0 22px;
  text-align: center;
  color: #263238;
}
</style>
