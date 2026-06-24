<template>
  <el-main class="index-main">
    <bread-crumbs class="bread-crumbs" />
    <div class="router-shell">
      <router-view />
    </div>
  </el-main>
</template>

<script>
export default {}
</script>

<style lang="scss" scoped>
.index-main {
  min-height: 100vh;
  padding: 72px 20px 20px;
  background: #eef3f7;
}

.bread-crumbs {
  margin-bottom: 12px;
}

.router-shell {
  min-height: calc(100vh - 124px);
  border-radius: 8px;
}
</style>
