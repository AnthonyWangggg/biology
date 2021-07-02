<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>富集圈图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
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
          <el-form-item label="内圈柱状的数量">
            <el-input v-model="formInline.num" :placeholder="formInline.num"></el-input>
          </el-form-item>
          <el-form-item label="外圈标签的大小">
            <el-input v-model="formInline.size" :placeholder="formInline.size"></el-input>
          </el-form-item>
          <el-form-item label="内圈半径">
            <el-input v-model="formInline.ir" :placeholder="formInline.ir"></el-input>
          </el-form-item>
          <el-form-item label="外圈半径">
            <el-input v-model="formInline.or" :placeholder="formInline.or"></el-input>
          </el-form-item>
        </el-form>

        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <!--<el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <input type="file" id="files" ref="refFile" style="display: none" v-on:change="fileLoad">-->
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;使用富集分析结果表格绘制富集圈图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;格式：支持txt(制表符分隔)文本文件、csv(逗号分隔)文本文件。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;data_path1:txt格式，A data frame with columns for 'category', 'ID', 'term', adjusted p-value ('adj_pval') and 'genes'<br>
        &nbsp;&nbsp;&nbsp;&nbsp;data_path2:txt格式，A data frame with columns for 'ID', 'logFC'<br>
        &nbsp;&nbsp;&nbsp;&nbsp;两个文件的标题行必须包括以上款项且命名完全相同，注意两个文件ID要对应，详细请参考实例文件。<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.内圈柱状的数量：自定义显示基因的数量<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.标签：自定义外圈标签的大小<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.半径：自定义设置内圈半径和外圈半径<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;提供SVG格式的图片下载<br>
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
  name: 'Fuquan',
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formData1: new FormData(),
      formInline: {
        file: '',
        file1: '',
        no: '',
        num: '10',
        size: '5',
        ir: '3',
        or: '4',
      },
      para: {
        "historyid": '',
        "num_0": '',
        "size_1": '',
        "ir_2": '',
        "or_3": '',
      },

      choose: true,
      activeTab: 'first',
      flag: 1,
      chartInstance:null,
      fileData:null, //读取的数据
      fileData1:null, //读取基因组的数据
      pic: '',
      txt: '',
      rd: [],
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'enrich_dicos' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/FunctionalAnalysis/enrich_dicos/richcircos.txt','_blank')
    },

    file2(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/FunctionalAnalysis/enrich_dicos/gene.txt','_blank')
    },

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'enrich_dicos.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
    },

    choosepara(){
      this.choose = !this.choose
    },
    choosetype(tab,event){
      if(tab.name === 'first'){
        this.flag=1
      }else {
        this.flag=2
      }
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
        if(_this.formInline.num!==''){
          _this.para.num_0 = _this.formInline.num
        }
        if(_this.formInline.size!==''){
          _this.para.size_1 = _this.formInline.size
        }
        if(_this.formInline.ir!==''){
          _this.para.ir_2 =_this.formInline.ir
        }
        if(_this.formInline.or!==''){
          _this.para.or_3 =_this.formInline.or
        }

        console.log(_this.para)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('files'))

          _this.$axios({
            url: this.Host.BASE_URL + 'FunctionalAnalysis/enrich_dicos/multiUpload',
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
                url: this.Host.BASE_URL + 'FunctionalAnalysis/enrich_dicos/run',
                method: 'post',
                data: _this.para,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': localStorage.getItem("token")
                },

              }).then((res)=>{
                console.log(res)
                _this.pic = this.Host.BASE_URL + res.data
                if(res.data==='token过期'){
                  localStorage.removeItem("Flag")
                  localStorage.removeItem("token")
                  this.$router.replace('Login');
                }else if (res.data === 'Error'){
                  _this.pic = ''
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
