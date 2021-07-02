<template>
  <div>
    <!--<img src="./assets/logo.png">-->
    <el-menu :default-active="activeIndex" class="el-menu-demo" mode="horizontal" @select="handleSelect" >
      <el-menu-item index="0"><router-link id="Logo" to="/Home"><img src="../src/assets/logos.png"></router-link></el-menu-item>
      <el-menu-item index="1"><router-link id="Home" to="/Home">首页</router-link></el-menu-item>
      <el-menu-item index="2"><router-link id="Tool" to="/Tool">工具</router-link></el-menu-item>
<!--      <el-submenu index="2">-->
<!--        <template slot="title">工具</template>-->
<!--        <el-menu-item index="2-1"><router-link id="Tool" :to="{name:'Tool',params:{part:'1',flags: 0}}">全部工具</router-link></el-menu-item>-->
<!--        <el-menu-item index="2-2"><router-link id="Tool1" :to="{name:'Tool',params:{part:'2',flags: 1}}">基础绘图</router-link></el-menu-item>-->
<!--        <el-menu-item index="2-3"><router-link id="Tool2" :to="{name:'Tool',params:{part:'3',flags: 2}}">功能分析</router-link></el-menu-item>-->
<!--        <el-menu-item index="2-4"><router-link id="Tool3" :to="{name:'Tool',params:{part:'4',flags: 3}}">聚类分析</router-link></el-menu-item>-->
<!--        <el-menu-item index="2-5"><router-link id="Tool4" :to="{name:'Tool',params:{part:'5',flags: 4}}">动态交互</router-link></el-menu-item>-->
<!--        <el-menu-item index="2-6"><router-link id="Tool5" :to="{name:'Tool',params:{part:'6',flags: 5}}">序列处理</router-link></el-menu-item>-->
<!--        <el-menu-item index="2-7"><router-link id="Tool6" :to="{name:'Tool',params:{part:'7',flags: 6}}">注释工具</router-link></el-menu-item>-->
<!--        <el-menu-item index="2-8"><router-link id="Tool7" :to="{name:'Tool',params:{part:'8',flags: 7}}">表格与格式</router-link></el-menu-item>-->
<!--        <el-menu-item index="2-9"><router-link id="Tool8" :to="{name:'Tool',params:{part:'9',flags: 8}}">统计检验与差异</router-link></el-menu-item>-->
<!--      </el-submenu>-->
      <el-menu-item index="3"><router-link id="Login" to="/Login" v-show="this.$store.state.isLogin===false||this.$store.state.isLogin===''">登录/注册</router-link></el-menu-item>
      <el-menu-item index="3"><router-link id="Person" to="/Person" v-show="this.$store.state.isLogin===true">个人中心</router-link></el-menu-item>
    </el-menu>
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App',
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
.el-menu-demo{
  z-index: 10;
  width: 100% !important;
  height: auto !important;
  margin: 0!important;
}
img{
  width: 80%;
}
*{
  outline:none;
}
.el-menu-demo .el-menu-item{
  border-bottom-color:#ffffff!important;
  font-size: 16px;

}
.el-icon-caret-top{
  position: absolute;
  bottom: -8px;
  left: 34%;
  color: #1F51A9!important;
}
a {
  text-decoration: none;
}
.router-link-active {
  text-decoration: none;
}
</style>
