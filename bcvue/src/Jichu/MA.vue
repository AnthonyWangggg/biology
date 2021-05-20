<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>MA图</h1>
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
          <el-form-item label="散点大小">
            <el-input v-model="formInline.size" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="X轴标题">
            <el-input v-model="formInline.Xtitle" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="Y轴标题">
            <el-input v-model="formInline.Ytitle" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="第一个样本的值的列数">
            <el-input v-model="formInline.FL" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="第二个样本的值的列数">
            <el-input v-model="formInline.SL" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="Pvalue/Qvalue值的列数">
            <el-input v-model="formInline.PQ" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="down点的颜色">
            <el-input v-model="formInline.color1" :placeholder="formInline.color1">
            </el-input>
            <el-color-picker v-model="formInline.color1" size="small"></el-color-picker>
          </el-form-item>
          <el-form-item label="no点的颜色">
            <el-input v-model="formInline.color2" :placeholder="formInline.color2">
            </el-input>
            <el-color-picker v-model="formInline.color2" size="small"></el-color-picker>
          </el-form-item>
          <el-form-item label="up点的颜色">
            <el-input v-model="formInline.color3" :placeholder="formInline.color3">
            </el-input>
            <el-color-picker v-model="formInline.color3" size="small"></el-color-picker>
          </el-form-item>
        </el-form>

        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>


        <!--<el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <input type="file" id="files" ref="refFile" style="display: none" v-on:change="fileLoad">-->
      </div>
      <div id="rightbox"></div>
    </div>
    <div id="line">
      <h2>生成结果</h2>
    </div>
    <div id="echart1" v-show="pic!==''">
      <img :src="pic" />
    </div>
  </div>

</template>

<script>

//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'MA',
  data() {
    return{
      formData: new FormData(),
      formInline: {
        file: '',
        size: '',
        Xtitle: '',
        title: '',
        Ytitle: '',
        no: '',
        FL: '',
        SL: '',
        PQ: '',
        color1: '',
        color2: '',
        color3: '',
      },
      para: {
        "historyid": '',
        "titlename_0": '',
        "acolumn_1": '',
        "bcolumn_2": '',
        "qcolumn_3": '',
        "psize_4": '',
        "xname_5": '',
        "yname_6": '',
        "downcol_7": '',
        "nocol_8": '',
        "upcol_9": '',
      },
      pic:'',

      chartInstance:null,
      fileData:null, //读取的数据
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'MA' + this.formInline.no
  },
  methods: {
    chartCommit(){
      let _this = this;

      //参数设置
      if(_this.formInline.title!==''){
        _this.para.title_0 =_this.formInline.title
      }

      if(_this.formInline.FL!==''){
        _this.para.acolumn_1 = _this.formInline.FL
      }

      if(_this.formInline.Sl!==''){
        _this.para.bcolumn_2 = _this.formInline.SL
      }

      if(_this.formInline.PQ!==''){
        _this.para.qcolumn_3 = _this.formInline.PQ
      }

      if(_this.formInline.size!==''){
        _this.para.psize_4 = _this.formInline.size
      }

      if(_this.formInline.Xtitle!==''){
        _this.para.xname_5 = _this.formInline.Xtitle
      }

      if(_this.formInline.Ytitle!==''){
        _this.para.yname_6 = _this.formInline.Ytitle
      }

      if(_this.formInline.color1!==''){
        _this.para.downcol_7 = _this.formInline.color1
      }

      if(_this.formInline.color2!==''){
        _this.para.nocol_8 = _this.formInline.color2
      }

      if(_this.formInline.color3!==''){
        _this.para.upcol_9 = _this.formInline.color3
      }

      if(_this.fileData == null){
        alert("文件不能为空");
      }else {
        console.log(_this.formData.get('files'))

        _this.$axios({
          url: this.Host.BASE_URL + 'BaseFunction/maplot/multiUpload',
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
              url: this.Host.BASE_URL + 'BaseFunction/maplot/run',
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
#choose{
  width: 100%;
  height: auto;
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
