<template>
  <div class="box">
    <!--<div id="echart1"></div>
    <div>
      <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
      <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      <input type="file" id="files" ref="refFile" style="display: none" v-on:change="fileLoad">
    </div>-->
    <div class="card1">
      <div id="leftbox">
        <h1>蜂群图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="自定义标题">
            <el-input v-model="formInline.title" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="源文件">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
          </el-form-item>
          <el-form-item>
          </el-form-item>
          <el-form-item label="X轴标题">
            <el-input v-model="formInline.Xtitle" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="Y轴标题">
            <el-input v-model="formInline.Ytitle" placeholder=""></el-input>
          </el-form-item>
        </el-form>

        <el-form  :model="colorInline" class="demo-form-inline">
          <el-form-item  v-for="(color, index) in colorInline.color1"
                         :label="'分组' + index + '颜色'"
                         :key="color.key" :span="18">
            <td>
              <el-input v-model="color.color" :placeholder="color.color"></el-input>
            </td>
            <td>
              <el-color-picker v-model="color.color" size="small"></el-color-picker>
              <el-button @click.prevent="removeColor(color)">删除</el-button>
            </td>
          </el-form-item>
          <el-form-item>
            <el-button @click="addColor">新增颜色</el-button>
            <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
          </el-form-item>
          <!--
          <el-form-item label="柱1颜色">
            <el-input v-model="colorInline.color1" :placeholder="colorInline.color1"></el-input>
            <el-color-picker v-model="colorInline.color1"></el-color-picker>
          </el-form-item>
          <el-form-item label="柱2颜色">
            <el-input v-model="colorInline.color2" :placeholder="colorInline.color2"></el-input>
            <el-color-picker v-model="colorInline.color2"></el-color-picker>
          </el-form-item>
          <el-form-item label="柱3颜色">
            <el-input v-model="colorInline.color3" :placeholder="colorInline.color3"></el-input>
            <el-color-picker v-model="colorInline.color3"></el-color-picker>
          </el-form-item>-->
        </el-form>
        <!--        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>-->
      </div>
      <div id="rightbox"></div>
    </div>
    <div id="line">
      <h2>生成结果</h2>
    </div>
    <div id="echart1" v-show="pic!==''">
      <!--      <img src="http://10.13.1.130:8081/public/20210429222508_heatmap.png" />-->
      <img :src="pic" />
    </div>
  </div>

</template>

<script>
// import host from '../host.vue'
// Vue.prototype.$host = host
//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'Fengqun',
  data() {
    return{
      formData: new FormData(),
      formInline: {
        file: '',
        title: 'Beeswarm',
        Xtitle: 'X',
        Ytitle: 'Y',
        no: '',
      },
      colorInline: {
        color1: [{
          color: '#FF0000'
        }],
      },
      para: {
        "historyid": '',
        "title_0": '',
        "xt_1": '',
        "yt_2": '',
        "color_3": '',
      },
      chartInstance:null,
      fileData:null, //读取的数据
      lineColor: '',
      pic: '',
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Beeswarm' + this.formInline.no
  },
  methods: {
    removeColor(item) {
      var index = this.colorInline.color1.indexOf(item)
      if (index !== -1) {
        this.colorInline.color1.splice(index, 1)
      }
    },
    addColor() {
      this.colorInline.color1.push({
        value: '',
        key: Date.now()
      });
    },

    chartCommit(){
      let _this = this;

      //参数设置
      if(_this.formInline.title!==''){
        _this.para.title_0 =_this.formInline.title
      }

      if(_this.formInline.Xtitle!==''){
        _this.para.xt_1 = _this.formInline.Xtitle
      }
      if(_this.formInline.Ytitle!==''){
        _this.para.yt_2 = _this.formInline.Ytitle
      }

      for (let i = 0; i < _this.colorInline.color1.length; i++){
        if(_this.colorInline.color1[i].color!=null){
          if(i === 0){
            _this.lineColor =  '"'+_this.colorInline.color1[i].color+'"'
          }else{
            _this.lineColor =  _this.lineColor + ',"'+_this.colorInline.color1[i].color+'"'
          }
        }
      }

      if(_this.lineColor!==""){
        _this.para.color_3 = 'c(' + _this.lineColor + ')'
      }
      if(_this.fileData == null){
        alert("文件不能为空");
      }else {
        console.log(_this.formData.get('files'))
        _this.$axios({
          url: this.Host.BASE_URL + 'BaseFunction/beeswarm_chart/multiUpload',
          method: 'post',
          data: _this.formData,
          headers: {
            "Content-Type": "multipart/form-data" ,
            'Authorization': localStorage.getItem("token")
          },

        }).then((res)=>{
          console.log(res)
          _this.para.historyid = res.data
          if(res.data==='token过期'){
            localStorage.removeItem("Flag")
            localStorage.removeItem("token")
            _this.$router.replace('Login');
          }else{
            _this.$axios({
              url: this.Host.BASE_URL  + 'BaseFunction/beeswarm_chart/run',
              method: 'post',
              data: _this.para,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': localStorage.getItem("token")
              },

            }).then((res)=>{
              console.log(res)
              _this.pic = this.Host.BASE_URL  + res.data
              if(res.data==='token过期'){
                localStorage.removeItem("Flag")
                localStorage.removeItem("token")
                this.$router.replace('Login');
              }
            })
          }
        })

      }
    },

    fileLoad() {
      let _this = this;
      const selectedFile = this.$refs.refFile.files[0];
      _this.formData.append('files',selectedFile);
      console.log(this.$refs.refFile.files)
      _this.formInline.file = this.$refs.refFile.files[0].name;
      let reader = new FileReader();
      reader.readAsText(selectedFile);
      reader.onload = function () {
        _this.fileData=this.result;
        console.log(_this.fileData)
      }
    },

    clickLoad() {
      this.$refs.refFile.dispatchEvent(new MouseEvent("click"));
    },

    clear_data(){
      let _this=this;
      _this.fileData=null; //读取的数据
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.box {
  background: url('../assets/back.png');
  width: 100%;
  height: auto;
  position: absolute;
  z-index: -1;
  background-size: cover;
  left: 0;
}
.card1{
  width: 80%;
  height: auto;
  margin: 0 auto;
  display: flex;
  background: #409EFF;
}
#leftbox{
  width: 50%;
  height: auto;
  background: white;
  padding: 5px 15px 10px 15px;
  border-radius:40px 0 0 40px;
}
#rightbox{
  width: 50%;
  height: 100%;
  background: #c1c1c1;
  padding: 5px 15px 10px 15px;
  border-radius:0 40px 40px 0;
}
#line{
  margin: 10px auto;
  text-align: center;
  color: white;
}
#echart1 {
  height: 432px;
  width: 768px;
  margin: 10px auto;
  background: #ffffff;
  display:flex;
  align-items:center;
  justify-content:center;
}
img{
  width:auto;
  height:auto;
  max-width: 100%;
  max-height: 100%;
}
</style>

<style>
.element.style{
  height: 0!important;
}
html,body {
  width: 100%;
  height: auto;
}
</style>
