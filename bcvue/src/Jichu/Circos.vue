<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>circos物种关系图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="OTU分类文件">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="样本分组文件">
            <el-input  v-model="formInline.file1" :placeholder="this.formInline.file1" :readonly="true"></el-input>
            <el-button type="button" id="fileImports" v-on:click="clickLoad1">选择上传的数据文件</el-button>
            <input type="file" id="filess" ref="refFiles" style="display: none"  v-on:change="fileLoad1">
            <el-link class="outputbutton" type="info" v-on:click="file2">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="OTU丰度表">
            <el-input  v-model="formInline.file2" :placeholder="this.formInline.file2" :readonly="true"></el-input>
            <el-button type="button" id="fileImportss" v-on:click="clickLoad2">选择上传的数据文件</el-button>
            <input type="file" id="filesss" ref="refFiless" style="display: none"  v-on:change="fileLoad2">
            <el-link class="outputbutton" type="info" v-on:click="file3">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
        </el-form>

        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;根据样本与物种关系绘制circos物种关系图<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;输入文件为三个txt,顺序不能变。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;第一个为OTU分类文件（taxonomy.txt）第一列为OTU ID，第二列为OTU的“门水平”分类，第三列为OTU的详细物种分类。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;第二个为样本分组文件（group.txt）第一列为样本ID，第二列为样本分组信息。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;第三个为OTU丰度表（otu_table.txt）第一列为OTU ID,其他每一列为样本，每一行为物种（此处为OTU），交叉区为个OTU在各样本中的丰度。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;otu数量别超过30，就是图例展示的部分。group别超过5种，sample别超过10种。<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;输出物种与样本关系的circos图。图形一侧为样本，另外一侧为物种，各用不同颜色表示。物种丰度以百分比展示。连线表示某样本存在某物种，线段越粗，该物种含量越丰富。<br>
      </div>
    </div>
    <div id="line">
      <h2>生成结果</h2>
    </div>
    <div class="b2">
      <div id="echart1" v-show="pic!==''">
        <pdf ref="pdf" :src="pic"
             v-for="i in numPages"
             :key="i"
             :page="i"
             v-show="i!==1"
             class="pdf-set" />
      </div>
      <div class="output" v-show="pic!==''">
        <span>图表导出：</span>
        <el-button type="info" icon="el-icon-download" size="mini" :href="pic" @click.prevent="downloadItem(pic, pic)" ></el-button>
      </div>
    </div>

  </div>

</template>

<script>

//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;
import pdf from 'vue-pdf'
export default {
  name: 'Circos',
  components: {
    pdf
  },
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formData1: new FormData(),
      formData2: new FormData(),
      formInline: {
        file: '',
        file1: '',
        file2: '',
        no: '',
      },
      para: {
        "historyid": '',
      },
      numPages: '',

      chartInstance:null,
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
    this.formInline.no = 'Circos' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/circos/taxonomy.txt','_blank')
    },

    file2(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/circos/group.txt','_blank')
    },

    file3(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/circos/otu_table.txt','_blank')
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
      // _this.isloadfile += 1;
      if(_this.isloadfile>1){
        alert("请勿重复提交");
      }else{
        console.log(_this.formData)
        console.log(_this.formInline)
        //参数设置

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('files'))

          _this.$axios({
            url: this.Host.BASE_URL + 'BaseFunction/circos/multiUpload',
            method: 'post',
            data: _this.formData,
            headers: {
              "Content-Type": "multipart/form-data" ,
              'Authorization': localStorage.getItem("token")
            },

          }).then((res)=>{
            _this.para.historyid = res.data
            console.log(res)
            if(res.data==='token过期'){
              localStorage.removeItem("Flag")
              localStorage.removeItem("token")
              this.$router.replace('Login');
            }else{
              _this.$axios({
                url: this.Host.BASE_URL + 'BaseFunction/circos/run',
                method: 'post',
                data: _this.para,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': localStorage.getItem("token")
                },

              }).then((res)=>{
                console.log(res)
                _this.pic = this.Host.BASE_URL  + res.data
                // _this.pic.then(pdf => {
                //   _this.numPages = pdf.numPages;
                // });
                let loadingTask = pdf.createLoadingTask(_this.pic)
                loadingTask.promise.then(pdf => {
                  _this.numPages = pdf.numPages
                }).catch(err => {
                  this.$message.error('发生错误');
                })

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

    fileLoad2() {
      let _this = this;
      const selectedFiless = this.$refs.refFiless.files[0];
      _this.formData.append('files',selectedFiless);
      console.log(this.$refs.refFile.files)
      console.log(this.$refs.refFiles.files)
      _this.formInline.file2 = this.$refs.refFiless.files[0].name;
      let readerss = new FileReader();
      readerss.readAsText(selectedFiless);
      readerss.onload = function () {
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

    clickLoad2() {
      let _this=this;
      _this.clear_data2();
      this.$refs.refFiless.dispatchEvent(new MouseEvent("click"));
    },


    clear_data(){
      let _this=this;
      _this.fileData=null; //读取的数据
    },

    clear_data1(){
      let _this=this;
      _this.fileData1=null; //读取的数据
    },

    clear_data2(){
      let _this=this;
      _this.fileData2=null; //读取的数据
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
  height: auto;
  width: 90%;
  margin: 5px auto;
  background: #ffffff;
  display:flex;
  align-items:center;
  justify-content:center;
}
#choose{
  width: 100%;
  height: auto;
}
pdf{
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
.pdf-set{
  display: inline-block;
  /*text-align: center;*/
  width:100%;
  height: auto;
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
