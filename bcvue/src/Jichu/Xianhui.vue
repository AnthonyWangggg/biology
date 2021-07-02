<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>线性回归图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="自定义标题">
            <el-input v-model="formInline.title" :placeholder="formInline.title"></el-input>
          </el-form-item>
          <el-form-item label="源文件">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item>
          </el-form-item>
          <el-form-item label="X轴标题">
            <el-input v-model="formInline.Xtitle" :placeholder="formInline.Xtitle"></el-input>
          </el-form-item>
          <el-form-item label="Y轴标题">
            <el-input v-model="formInline.Ytitle" :placeholder="formInline.Ytitle"></el-input>
          </el-form-item>
          <el-form-item label="散点颜色">
            <el-input v-model="formInline.color1" :placeholder="formInline.color1">
            </el-input>
            <el-color-picker v-model="formInline.color1" size="small"></el-color-picker>
          </el-form-item>
          <el-form-item label="线颜色">
            <el-input v-model="formInline.color2" :placeholder="formInline.color2">
            </el-input>
            <el-color-picker v-model="formInline.color2" size="small"></el-color-picker>
          </el-form-item>
          <el-form-item label="散点大小">
            <el-input v-model="formInline.size" :placeholder="formInline.size"></el-input>
          </el-form-item>
        </el-form>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>

      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;用一个带有表头的表格数据绘制一个包含拟合线和置信空间的散点图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;支持txt(制表符分隔)文本文件、csv(逗号分隔)文本文件。格式如下，数据与数据之间务必用制表符(tab符)隔开，不能用空格，制图时将以第一列为x数据第二列为y轴数据<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.自定义标题：可自己定义线性回归图的标题（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.X轴标题：可自己定义线性回归图的X轴标题名称（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.Y轴标题：可自己定义线性回归图的Y轴标题名称（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.自定义颜色：可自定义拟合线和散点的颜色（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.散点大小：可自定义散点的大小（可选）<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;程序将输出线性回归图，提供SVG格式的图片下载<br>
      </div>
    </div>
    <div id="line">
      <h2>生成结果</h2>
    </div>
    <div class="b2">
      <div id="echart1" v-show="pic!==''">
        <!--      <img src="http://10.13.1.130:8081/public/20210429222508_heatmap.png" />-->
        <img :src="pic" />
      </div>
      <div class="output" v-show="pic!==''">
        <span>图表导出：</span>
        <el-link class="outputbutton" type="info" v-on:click="down">SVG</el-link>
        <el-button type="info" icon="el-icon-download" size="mini" v-on:click="down" circle></el-button>
      </div>
    </div>
  </div>

</template>

<script>

//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'Xianhui',
  data() {
    return{
      formData: new FormData(),
      formInline: {
        file: '',
        color1: '#FF0000',
        color2: '#000000',
        title: 'Regressionline',
        Xtitle: 'X',
        Ytitle: 'Y',
        no: '',
        size: 4,
      },

      para: {
        "historyid": '',
        "title_0": '',
        "size_1": '',
        "c1_2": '',
        "c2_3": '',
        "X_4": '',
        "Y_5": '',
      },
      pic: '',
      chartInstance:null,
      fileData:null, //读取的数据
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Regressionline' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/regressionline/regre.txt','_blank')
    },

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'Regre.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
    },

    chartCommit(){
      let _this = this;

      //参数设置
      if(_this.formInline.title!==''){
        _this.para.title_0 =_this.formInline.title
      }

      if(_this.formInline.size!==''){
        _this.para.size_1 = _this.formInline.size
      }

      if(_this.formInline.Xtitle!==''){
        _this.para.X_4 = _this.formInline.Xtitle
      }

      if(_this.formInline.Ytitle!==''){
        _this.para.Y_5 = _this.formInline.Ytitle
      }

      if(_this.formInline.color1!==''){
        _this.para.c1_2 = _this.formInline.color1
      }

      if(_this.formInline.color2!==''){
        _this.para.c2_3 = _this.formInline.color2
      }



      if(_this.fileData == null){
        alert("文件不能为空");
      }else {
        console.log(_this.formData.get('files'))

        _this.$axios({
          url: this.Host.BASE_URL + 'BaseFunction/regressionline/multiUpload',
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
            this.$router.replace('Login');
          }else{
            _this.$axios({
              url: this.Host.BASE_URL + 'BaseFunction/regressionline/run',
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
              }else if (res.data === 'Error'){
                this.$message.error('发生错误，检查提交文件及参数，重新提交');
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
      let _this=this;
      _this.clear_data();
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
  height: 800px;
  margin: 10px auto;
  display: flex;
  /*background: #409EFF;*/
}
#leftbox{
  width: 50%;
  height: 95%;
  background: white;
  padding: 5px 15px 10px 15px;
  border-radius:40px 0 0 40px;
  overflow: scroll;
}
#rightbox{
  width: 50%;
  height: 95%;
  background: #a2d7ff;
  padding: 5px 15px 10px 15px;
  border-radius:0 40px 40px 0;
  overflow: scroll;
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
.b2{
  height: auto;
  width: auto;
  margin: 10px auto;
  display: flex;
  flex-direction: column;
}
.output{
  margin: 10px auto;
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
::-webkit-scrollbar {
  width: 0 !important;
}
::-webkit-scrollbar {
  width: 0 !important;height: 0;
}
</style>
