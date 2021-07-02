<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>CCA</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="OTU丰度表">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="环境因子列表文件">
            <el-input  v-model="formInline.file1" :placeholder="this.formInline.file1" :readonly="true"></el-input>
            <el-button type="button" id="fileImports" v-on:click="clickLoad1">选择上传的数据文件</el-button>
            <input type="file" id="filess" ref="refFiles" style="display: none"  v-on:change="fileLoad1">
            <el-link class="outputbutton" type="info" v-on:click="file2">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="分组文件">
            <el-input  v-model="formInline.file2" :placeholder="this.formInline.file2" :readonly="true"></el-input>
            <el-button type="button" id="fileImportss" v-on:click="clickLoad2">选择上传的数据文件</el-button>
            <input type="file" id="filesss" ref="refFiless" style="display: none"  v-on:change="fileLoad2">
            <el-link class="outputbutton" type="info" v-on:click="file3">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
        </el-form>

        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <!--<el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <input type="file" id="files" ref="refFile" style="display: none" v-on:change="fileLoad">-->
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;利用CCA分析环境因子对群落分布影响。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;（1）带物种注释的OTU丰度表（必须）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（2）各样本的环境因子表格，要求环境因子数目小于样本数（必须）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（3）如果有分组信息，请输入样本分组信息表。单样本最多支持两种分组信息，如A样本同时属于病人分组，也属于成年人分组。（非必需）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（4） 当前支持txt(制表符分隔)文本文件。<br>

        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;1) 样本坐标表： 记录了样本在各个维度上的位置<br>
        &nbsp;&nbsp;&nbsp;&nbsp;2) 物种坐标表： 记录了物种在各个维度上的位置<br>
        &nbsp;&nbsp;&nbsp;&nbsp;3) 环境因子坐标： 记录了环境因子在各个维度上的位置<br>
        &nbsp;&nbsp;&nbsp;&nbsp;4) DCA结果表<br>
        &nbsp;&nbsp;&nbsp;&nbsp;5) CCA/RDA结果图<br>

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
      <div class="output" v-show="f1!==''">
        <span>文件导出：</span>
        <el-button type="info" icon="el-icon-download" size="mini" :href="f1" @click.prevent="downloadItem(f1, f1)" ></el-button>
      </div>
      <div class="output" v-show="f2!==''">
        <span>文件导出：</span>
        <el-button type="info" icon="el-icon-download" size="mini" :href="f2" @click.prevent="downloadItem(f2, f2)" ></el-button>
      </div>
      <div class="output" v-show="f3!==''">
        <span>文件导出：</span>
        <el-button type="info" icon="el-icon-download" size="mini" :href="f3" @click.prevent="downloadItem(f3, f3)" ></el-button>
      </div>
      <div class="output" v-show="f4!==''">
        <span>文件导出：</span>
        <el-button type="info" icon="el-icon-download" size="mini" :href="f4" @click.prevent="downloadItem(f4, f4)" ></el-button>
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
  name: 'PCA',
  components: {

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

      chartInstance:null,
      fileData:null, //读取的数据
      fileData1:null, //读取基因组的数据
      rd: '',
      pic: '',
      f1: '',
      f2: '',
      f3: '',
      f4: '',
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'CCA' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/ClusteringAnalysis/CCA_chart/ccatop20-1.txt','_blank')
    },

    file2(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/ClusteringAnalysis/CCA_chart/ccaenvir-2.txt','_blank')
    },

    file3(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/ClusteringAnalysis/CCA_chart/ccagroup-3.txt','_blank')
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

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'cca.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
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
        console.log(_this.para)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('files'))

          _this.$axios({
            url: this.Host.BASE_URL + 'ClusteringAnalysis/CCA_chart/multiUpload',
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
            }else if (res.data === 'Error'){
              this.$message.error('发生错误，检查提交文件及参数，重新提交');
            }else{
              _this.$axios({
                url: this.Host.BASE_URL + 'ClusteringAnalysis/CCA_chart/run',
                method: 'post',
                data: _this.para,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': localStorage.getItem("token")
                },

              }).then((res)=>{
                console.log(res)
                _this.rd = res.data.split(',')
                _this.pic = this.Host.BASE_URL  + _this.rd[4]
                _this.f4 = this.Host.BASE_URL  + _this.rd[3]
                _this.f3 = this.Host.BASE_URL  + _this.rd[2]
                _this.f2 = this.Host.BASE_URL  + _this.rd[1]
                _this.f1 = this.Host.BASE_URL  + _this.rd[0]
                if(res.data==='token过期'){
                  localStorage.removeItem("Flag")
                  localStorage.removeItem("token")
                  this.$router.replace('Login');
                }else if (res.data === 'Error'){
                  _this.pic = ''
                  _this.f4 = ''
                  _this.f3 = ''
                  _this.f2 = ''
                  _this.f1 = ''
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
