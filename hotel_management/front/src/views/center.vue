<template>
  <div class="center-page">
    <el-card shadow="never">
      <h3>个人信息</h3>
      <p>当前角色：{{ role }}</p>
      <p>登录账号：{{ username }}</p>
    </el-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      role: this.$storage.get('role') || '',
      username: this.$storage.get('adminName') || ''
    }
  }
}
</script>

<style scoped>
.center-page { padding: 20px; }
</style>
