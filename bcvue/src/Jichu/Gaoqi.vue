<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>高级气泡图</h1>
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
            <el-form-item label="用于做图的行数">
              <el-input v-model="formInline.line" :placeholder="formInline.line"></el-input>
            </el-form-item>
          </el-form-item>
          <el-form-item label="输入文件的类型">
            <el-select v-model="formInline.type" :placeholder="formInline.type">
              <el-option label="type1" value="1"></el-option>
              <el-option label="type2" value="2"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="参数">
            <el-select v-model="formInline.paras" :placeholder="formInline.para">
              <el-option label="P-value" value="1"></el-option>
              <el-option label="Q-value" value="2"></el-option>
            </el-select>
          </el-form-item>
        </el-form>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;用一个带有表头的以tab分隔的表格数据绘制一个高级气泡图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;支持txt(制表符分隔)文本文件格式。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;输入文件有两种类型：<br>
        &nbsp;&nbsp;&nbsp;&nbsp;①type1：有4列数据，这四列分别是：<br>
        &nbsp;&nbsp;&nbsp;&nbsp;1）通路名称<br>
        &nbsp;&nbsp;&nbsp;&nbsp;2）（差异基因中）属于这个通路的基因数<br>
        &nbsp;&nbsp;&nbsp;&nbsp;3）所有基因中属于这个通路的基因数<br>
        &nbsp;&nbsp;&nbsp;&nbsp;4）富集分析的P值（或Q值）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;备注：最终绘制的出的图中，RichFactor= 以上第二列除以第三列<br><br>

        &nbsp;&nbsp;&nbsp;&nbsp;②type1：有5列数据，这四列分别是：<br>
        &nbsp;&nbsp;&nbsp;&nbsp;1）通路名称<br>
        &nbsp;&nbsp;&nbsp;&nbsp;2）（差异基因中）属于这个通路的基因数<br>
        &nbsp;&nbsp;&nbsp;&nbsp;3）所有基因中属于这个通路的基因数<br>
        &nbsp;&nbsp;&nbsp;&nbsp;4）富集分析的P<br>
        &nbsp;&nbsp;&nbsp;&nbsp;5）富集分析的Q值<br>
        &nbsp;&nbsp;&nbsp;&nbsp;备注：最终绘制的出的图中，RichFactor= 以上第二列除以第三列<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;①输入文件类型：type1类型的文件只有4列，type2类型的文件则同时包括P-value和Q-value<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;②用于作图的行：默认为前20行的数据用来作图<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③参数选择：选择P-value或Q-value会影响最后的图形结果<br>
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
  name: 'Gaoqi',
  data() {
    return{
      formData: new FormData(),
      formInline: {
        file: '',
        line: '',
        type: '1',
        title: 'seniorbubble',
        //style: '',
        no: '',
        paras: '1',

        //order: '',
      },
      para: {
        "historyid": '',
        "row_0": '',
        "type_1": '',
        "t1part_2": '',
        "t1all_3": '',
        "t1pw_4": '',
        "t1pv_5": '',
        "t2part_6": '',
        "t2all_7": '',
        "t2pw_8": '',
        "t2pv_9": '',
        "t2qv_10": '',
        "pqtype_11": '',
      },
      fileData:null, //读取的数据
      pic:'',
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Seniorbubble' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/seniorbubble/bubble_exa.txt','_blank')
    },

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'Seniorbubble.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
    },

    chartCommit(){
      let _this = this;

      //参数设置
      if(_this.formInline.line!==''){
        _this.para.row_0 =_this.formInline.line
      }

      if(_this.formInline.type!==''){
        _this.para.type_1 = _this.formInline.type
      }

      if(_this.formInline.paras!==''){
        _this.para.pqtype_11 = _this.formInline.paras
      }

      if(_this.formInline.type==='1'){
        _this.para.t1part_2 = '2'
        _this.para.t1all_3 = '3'
        _this.para.t1pw_4 = '1'
        _this.para.t1pv_5 = '4'

        _this.para.t2part_6 = 'NULL'
        _this.para.t2all_7 = 'NULL'
        _this.para.t2pw_8= 'NULL'
        _this.para.t2pv_9 = 'NULL'
        _this.para.t2qv_10 = 'NULL'
      }else if(_this.formInline.type==='2'){
        _this.para.t1part_2 = 'NULL'
        _this.para.t1all_3 = 'NULL'
        _this.para.t1pw_4 = 'NULL'
        _this.para.t1pv_5 = 'NULL'

        _this.para.t2part_6 = '2'
        _this.para.t2all_7 = '3'
        _this.para.t2pw_8= '1'
        _this.para.t2pv_9 = '4'
        _this.para.t2qv_10 = '5'
      }

      if(_this.fileData == null){
        alert("文件不能为空");
      }else {
        console.log(_this.formData.get('files'))

        _this.$axios({
          url: this.Host.BASE_URL  +'BaseFunction/seniorbubble/multiUpload',
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
          }else if (res.data === 'Error'){
            this.$message.error('发生错误，检查提交文件及参数，重新提交');
          }else{
            _this.$axios({
              url: this.Host.BASE_URL  + 'BaseFunction/seniorbubble/run',
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
                _this.pic = ''
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
