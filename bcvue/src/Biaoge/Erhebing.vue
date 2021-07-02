<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>两表格合并</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <!--          <el-form-item label="自定义标题">-->
          <!--            <el-input v-model="formInline.title" placeholder=""></el-input>-->
          <!--          </el-form-item>-->
          <el-form-item label="输入文件1">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="输入文件2">
            <el-input  v-model="formInline.file1" :placeholder="this.formInline.file1" :readonly="true"></el-input>
            <el-button type="button" id="fileImports" v-on:click="clickLoad1">选择上传的数据文件</el-button>
            <input type="file" id="filess" ref="refFiles" style="display: none"  v-on:change="fileLoad1">
            <el-link class="outputbutton" type="info" v-on:click="file2">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="设置连接方式">
            <el-select v-model="formInline.type" :placeholder="formInline.type">
              <el-option label="内连接" value="1"></el-option>
              <el-option label="左连接" value="2"></el-option>
              <el-option label="右连接" value="3"></el-option>
              <el-option label="全连接" value="4"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="缺省值设置">
            <el-radio-group v-model="formInline.radio">
              <el-radio :label="1">--</el-radio>
              <el-radio :label="2">X</el-radio>
              <el-radio :label="3">N/A</el-radio>
              <el-radio :label="4">NULL</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>

        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <!--<el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <input type="file" id="files" ref="refFile" style="display: none" v-on:change="fileLoad">-->
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;把两个表格合并为一个表格。按内连接、左连接、右连接、全连接四种方式，将两个表格的信息根据需求合并到一个表格中。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;前支持txt(制表符分隔)文本文件、csv(逗号分隔)文本文件、以及Excel专用的xlsx格式，同样支持旧版Excel的xls(Excel 97-2003 )格式。如果是核酸、蛋白序列文件，必须为FASTA格式（本质是文本文件）。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;文件名可由英文和数字构成，不可以有空格。文件拓展名没有限制，可以是“.txt”、“.xlsx”、“.xls”、“.csv”“.fasta”等，例如 mydata01.txt，gene02.xlsx 。<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;连接方式有：内连接、左连接、右连接、全连接四种<br>

        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;①内连接：将两个表的共有ID或共有名称的所有行合并输出；<br>

        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;②左连接：利用共有ID或共有名称，以左边表中的数据为基准，来提取右表的数据，若右表无相应数据则相应位置为空值；<br>

        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③右连接：利用共有ID或共有名称，以右边表中的数据为基准，来提取左表的数据，若左表无相应数据则相应位置为空值；<br>

        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;④全连接：利用共有ID或共有名称，合并两个表，若有共有行ID或者共有名称则合并一行输出，无则分别输出。<br>

        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑤缺省值：没有对应的值用于填充的字符：——、X、N/A、空，也可自填缺省值。<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;程序将以txt的形式输出结果文档，第一行为表头数据<br>
      </div>
    </div>
    <div id="line">
      <h2>生成结果</h2>
    </div>
    <div class="b2">
      <div class="output" v-show="pic!==''">
        <span>文件导出：</span>
        <el-button type="info" icon="el-icon-download" size="mini" :href="pic" @click.prevent="downloadItem(pic, pic)" ></el-button>
      </div>
      <!--      <el-link :href="csv" v-on:click="down1">查看<i class="el-icon-view el-icon&#45;&#45;right"></i> </el-link>-->
    </div>
  </div>

</template>

<script>

//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'Erhebing',
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formData1: new FormData(),
      formInline: {
        file: '',
        file1: '',
        no: '',
        type: '1',
        radio: 1,
      },
      para: {
        "historyid": '',
        "type_0": '',
        "radio_1": '',
      },

      fileData:null, //读取的数据
      fileData1:null, //读取基因组的数据
      pic: '',
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Combine' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/FormatChange/join_table/combinefile1.txt','_blank')
    },

    file2(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/FormatChange/join_table/combinefile2.txt','_blank')
    },

    downloadItem(url, label) {
      this.$axios
        .get(url, { responseType: "blob" })
        .then(response => {
          const blob = new Blob([response.data]);
          const link = document.createElement("a");
          link.href = URL.createObjectURL(blob);
          link.download = label;
          link.click();
          URL.revokeObjectURL(link.href);
        })
        .catch(console.error);
    },

    chartCommit(){
      let _this = this;
      _this.isloadfile += 1;
      if(_this.isloadfile>1){
        alert("请勿重复提交");
      }else{
        console.log(_this.formData)
        console.log(_this.formInline)
        //参数设置
        if(_this.formInline.type!==''){
          _this.para.type_0 = _this.formInline.type
        }
        if(_this.formInline.radio!==''){
          _this.para.radio_1 = _this.formInline.radio
        }

        console.log(_this.para)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('files'))

          _this.$axios({
            url: this.Host.BASE_URL + 'FormatChange/join_table/multiUpload',
            method: 'post',
            data: _this.formData,
            headers: {
              "Content-Type": "multipart/form-data",
              'Authorization': localStorage.getItem("token")
            },

          }).then((res) => {
            _this.para.historyid = res.data
            console.log(res)
            if (res.data === 'token过期') {
              localStorage.removeItem("Flag")
              localStorage.removeItem("token")
              this.$router.replace('Login');
            } else {
              _this.$axios({
                url: this.Host.BASE_URL + 'FormatChange/join_table/run',
                method: 'post',
                data: _this.para,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': localStorage.getItem("token")
                },

              }).then((res) => {
                console.log(res)
                _this.pic = this.Host.BASE_URL + res.data
                if (res.data === 'token过期') {
                  localStorage.removeItem("Flag")
                  localStorage.removeItem("token")
                  this.$router.replace('Login');
                }else if (res.data === 'Error'){
                  _this.pic = ''
                  this.$message.error('发生错误，检查提交文件及参数，重新提交');
                }
              })
                // .catch((error) => {
                //   console.log(error);
                //   localStorage.removeItem("Flag")
                //   localStorage.removeItem("token")
                //   this.$router.replace('Login');
                //   this.$message.error('登录过期');
                // })
            }
          })
        }
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

    fileLoad1() {
      let _this = this;
      const selectedFiles = this.$refs.refFiles.files[0];
      _this.formData.append('files',selectedFiles);
      console.log(this.$refs.refFile.files)
      console.log(this.$refs.refFiles.files)
      _this.formInline.file1 = this.$refs.refFiles.files[0].name;
      let readers = new FileReader();
      readers.readAsText(selectedFiles);
      readers.onload = function () {
        _this.fileData=this.result;
        console.log(_this.fileData)
      }
    },

    clickLoad() {
      let _this=this;
      _this.clear_data();
      this.$refs.refFile.dispatchEvent(new MouseEvent("click"));
    },

    clickLoad1() {
      let _this=this;
      _this.clear_data1();
      this.$refs.refFiles.dispatchEvent(new MouseEvent("click"));
    },

    clear_data(){
      let _this=this;
      _this.fileData=null; //读取的数据
    },

    clear_data1(){
      let _this=this;
      _this.fileData1=null; //读取的数据
    },
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
  height: 700px;
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
#choose{
  width: 100%;
  height: auto;
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
