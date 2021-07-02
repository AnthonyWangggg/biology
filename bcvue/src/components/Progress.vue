<template>
<div id="zong">
  <el-steps :active="2" align-center finish-status="success">
    <el-step title="提交报告" description=""></el-step>
    <el-step title="进度报告" description=""></el-step>
    <el-step title="质控报告" description=""></el-step>
    <el-step title="测序报告" description=""></el-step>
    <el-step title="分析报告" description=""></el-step>
    <el-step title="下载页面" description=""></el-step>
  </el-steps>
</div>
</template>

<script>
export default {
name: "Progress"
}
</script>

<style scoped>
#zong{
  width: 100%;
  height: 100%;
  position: absolute;
  background-color: rgba(255, 255, 255, 0.2);
}
</style>
