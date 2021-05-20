<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>饼图</h1>
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
          <el-form-item label="饼图类型">
            <el-select v-model="formInline.region" :placeholder="formInline.region">
              <el-option label="带图例饼图" value="1"></el-option>
              <el-option label="3D饼图" value="3"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="自定义序列名">
            <el-input v-model="formInline.Name" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="自定义风格">
            <el-select v-model="formInline.Color" placeholder="shine">
              <el-option label="blue" value="blue"></el-option>
              <el-option label="dark" value="dark"></el-option>
              <el-option label="gray" value="gray"></el-option>
              <el-option label="green" value="green"></el-option>
              <el-option label="helianthus" value="helianthus"></el-option>
              <el-option label="infographic" value="infographic"></el-option>
              <el-option label="macarons" value="macarons"></el-option>
              <el-option label="macarons2" value="macarons2"></el-option>
              <el-option label="mint" value="mint"></el-option>
              <el-option label="red" value="red"></el-option>
              <el-option label="roma" value="roma"></el-option>
              <el-option label="sakura" value="sakura"></el-option>
              <el-option label="shine" value="shine"></el-option>
              <el-option label="vintage" value="vintage"></el-option>
            </el-select>
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
    <div id="echart1"></div>
  </div>

</template>

<script>

//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'Bing',
  data() {
    return{
      formData: new FormData(),
      formInline: {
        file: '',
        Color: 'shine',
        region: '1',
        title: 'pie',
        Name: 'p1',
        no: '',
      },
      para: {
        "historyid": '',
        "title_0": '',
        "theme_1": '',
        "type_2": '',
        "sub_3": '',
      },
      fileData:null, //读取的数据
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Pie' + this.formInline.no
  },
  methods: {

    chartCommit(){
      let _this = this;

      //参数设置
      if(_this.formInline.title!==''){
        _this.para.title_0 =_this.formInline.title
      }

      if(_this.formInline.region!==''){
        _this.para.type_2 = _this.formInline.region
      }

      if(_this.formInline.Name!==''){
        _this.para.sub_3 = _this.formInline.Name
      }

      if(_this.formInline.Color!==''){
        _this.para.theme_1 = _this.formInline.Color
      }


      if(_this.fileData == null){
        alert("文件不能为空");
      }else {
        console.log(_this.formData.get('files'))

        _this.$axios({
          url: this.Host.BASE_URL + 'BaseFunction/pie/multiUpload',
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
              url: this.Host.BASE_URL + 'BaseFunction/pie/save',
              method: 'post',
              data: _this.para,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': localStorage.getItem("token")
              },

            }).then((res)=>{
              console.log(res)
              //_this.pic = this.Host.BASE_URL  + res.data
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
