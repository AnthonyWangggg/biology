<template>
  <div id="zong">
    <div id="backimg"></div>
    <!--<img :src="imgSrc" width="100%" height="100%" alt="" />-->
    <div class="display-flex">
      <div class="div-size1"></div>
      <div class="div-size2">
        <div class="text1">
          <img src="../assets/logos.png">
        </div>
        <div class="text2">B - CHARTS 为用户提供100余种工具，帮助用户轻松将数据转换成所需图表或格式</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Home',
  data () {
    return {
      imgSrc: require('../assets/back.png')
    }
  }
}
</script>

<style scoped>
#zong{
  width: 100%;
  height: 100%;
  position: absolute;
}
#backimg {
  background: url('../assets/back.png');
  width: 100%;
  height: 100%;
  position: absolute;
  z-index: -1;
  background-size: cover;
  top: 0;
  left: 0;
}
.display-flex {
  display: flex;
  z-index: 1;
  height: 100%;
}

.div-size1 {
  width: 50%;
  height: 100%;
  margin: 0;
}
.div-size2 {
  width: 50%;
  height: 100%;
  margin: 0;
  background-color: rgba(255, 255, 255, 0.5);
}
.text1{
  width: 100%;
  height: 60%;
  margin: 0 auto;
  display: flex;
  justify-content: center;
  align-items: center;
}
.text1 img {
  margin-top: 35%;
  width: 40%;
}
.text2{
  width: 40%;
  height: 40%;
  margin: 0 auto;
  padding-bottom: 10px;
  text-align:center;
}
</style>
