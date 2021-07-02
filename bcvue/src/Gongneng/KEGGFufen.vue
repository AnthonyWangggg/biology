<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>KEGG富集分析</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="输入文件">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
        </el-form>

        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;输入基因集或差异分析基因集，通过预设定参数，进行KEGG富集分析并将分析结果进行精美图形可视化，输出图形有富集气泡图、富集条形图、富集圈图、kegg网络图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;输入的表格文件，支持txt(制表符分隔)文本文件、csv(逗号分隔)文本文件。需要有标题，输入文件第一列必须为id号，即为KEGG官网上的id或ncbi上得到的geneid，其余列可以自定义作为筛选条件。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;基因差异表达倍数表：第一列为基因ID，第二列为差异表达倍数log2(FC)。<br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;1.	输出富集柱形图<br>
        &nbsp;&nbsp;&nbsp;&nbsp;2.	输出富集气泡图<br>
        &nbsp;&nbsp;&nbsp;&nbsp;3.	输出富集网络图<br>
        &nbsp;&nbsp;&nbsp;&nbsp;4.	输出富集圈图<br>

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
      <div id="echart1" v-show="pic1!==''">
        <!--      <img src="http://10.13.1.130:8081/public/20210429222508_heatmap.png" />-->
        <img :src="pic1" />
      </div>
      <div class="output" v-show="pic1!==''">
        <span>图表导出：</span>
        <el-link class="outputbutton" type="info" v-on:click="downs">SVG</el-link>
        <el-button type="info" icon="el-icon-download" size="mini" v-on:click="downs" circle></el-button>
      </div>
      <div id="echart1" v-show="pic2!==''">
        <!--      <img src="http://10.13.1.130:8081/public/20210429222508_heatmap.png" />-->
        <img :src="pic2" />
      </div>
      <div class="output" v-show="pic2!==''">
        <span>图表导出：</span>
        <el-link class="outputbutton" type="info" v-on:click="downss">SVG</el-link>
        <el-button type="info" icon="el-icon-download" size="mini" v-on:click="downss" circle></el-button>
      </div>
      <div id="echart1" v-show="pic3!==''">
        <!--      <img src="http://10.13.1.130:8081/public/20210429222508_heatmap.png" />-->
        <img :src="pic3" />
      </div>
      <div class="output" v-show="pic3!==''">
        <span>图表导出：</span>
        <el-link class="outputbutton" type="info" v-on:click="downss">SVG</el-link>
        <el-button type="info" icon="el-icon-download" size="mini" v-on:click="downsss" circle></el-button>
      </div>
    </div>
  </div>

</template>

<script>

//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'DOFufen',
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formData1: new FormData(),
      formInline: {
        file: '',
        file1: '',
        no: '',
      },
      para: {
        "historyid": '',
        // "type_0": '',
        // "test_1": '',
        // "back_2": '',
      },

      COL: [],
      C: [],
      COLS: [],
      C1: [],
      choose: true,
      activeTab: 'first',
      flag: 1,
      chartInstance:null,
      fileData:null, //读取的数据
      fileData1:null, //读取基因组的数据
      rd:[],
      pic: '',
      pic1: '',
      pic2: '',
      pic3: '',
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
      window.open(this.Host.BASE_URL + 'public/FunctionalAnalysis/kegg_enrich/dodata.txt','_blank')
    },

    down(){
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'do_enrich1.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
    },
    downs(){
      fetch(this.pic1).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'do_enrich2.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
    },
    downss(){
      fetch(this.pic2).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'do_enrich3.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
    },
    downsss(){
      fetch(this.pic3).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'do_enrich3.svg'  // 下载文件的名字
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
        console.log(_this.para)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('files'))

          _this.$axios({
            url: this.Host.BASE_URL + 'FunctionalAnalysis/kegg_enrich/multiUpload',
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
                url: this.Host.BASE_URL + 'FunctionalAnalysis/kegg_enrich/run',
                method: 'post',
                data: _this.para,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': localStorage.getItem("token")
                },

              }).then((res)=>{
                console.log(res)
                _this.rd = res.data.split(',')
                _this.pic3 = this.Host.BASE_URL  + _this.rd[3]
                _this.pic2 = this.Host.BASE_URL  + _this.rd[2]
                _this.pic1 = this.Host.BASE_URL  + _this.rd[1]
                _this.pic = this.Host.BASE_URL  + _this.rd[0]
                if(res.data==='token过期'){
                  localStorage.removeItem("Flag")
                  localStorage.removeItem("token")
                  this.$router.replace('Login');
                }else if (res.data === 'Error'){
                  _this.pic = ''
                  _this.pic1 = ''
                  _this.pic2 = ''
                  _this.pic3 = ''
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

    clickLoad() {
      let _this=this;
      _this.clear_data();
      this.$refs.refFile.dispatchEvent(new MouseEvent("click"));
    },

    clear_data(){
      let _this=this;
      _this.fileData=null; //读取的数据
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
  height: 400px;
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
