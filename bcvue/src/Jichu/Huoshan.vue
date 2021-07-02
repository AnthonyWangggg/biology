<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>火山图</h1>
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
          <el-form-item label="散点大小">
            <el-input v-model="formInline.size" :placeholder="formInline.size"></el-input>
          </el-form-item>
          <el-form-item>
            <el-form-item label="X最大值">
              <el-input v-model="formInline.xmax" :placeholder="formInline.xmax"></el-input>
            </el-form-item>
            <el-form-item label="Y最大值">
              <el-input v-model="formInline.ymax" :placeholder="formInline.ymax"></el-input>
            </el-form-item>
          </el-form-item>
          <el-form-item label="用作X轴值的列">
            <el-input v-model="formInline.xcol" :placeholder="formInline.xocl"></el-input>
          </el-form-item>
          <el-form-item label="X阈值">
            <el-input v-model="formInline.xnum" :placeholder="formInline.xnum"></el-input>
          </el-form-item>
          <el-form-item label="用作Y轴值的列">
            <el-input v-model="formInline.ycol" :placeholder="formInline.ycol"></el-input>
          </el-form-item>
          <el-form-item label="Y阈值">
            <el-select v-model="formInline.ynum" :placeholder="formInline.ynum">
              <el-option label="0.01" value="0.01"></el-option>
              <el-option label="0.05" value="0.05"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="down的颜色">
            <el-input v-model="formInline.dcolor" :placeholder="formInline.dcolor">
            </el-input>
            <el-color-picker v-model="formInline.dcolor" size="small"></el-color-picker>
          </el-form-item>
          <el-form-item label="up的颜色">
            <el-input v-model="formInline.ucolor" :placeholder="formInline.ucolor">
            </el-input>
            <el-color-picker v-model="formInline.ucolor" size="small"></el-color-picker>
          </el-form-item>
          <el-form-item label="nodiff的颜色">
            <el-input v-model="formInline.ncolor" :placeholder="formInline.ncolor">
            </el-input>
            <el-color-picker v-model="formInline.ncolor" size="small"></el-color-picker>
          </el-form-item>
        </el-form>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;以组间差异倍数取以2为底的对数（log2(FC)）为横坐标，以差异显著性检验p-value(q-value)取10为底的对数的负值（-log10(p)）为纵坐标，给差异显著（一般为差异倍数为2倍以上，且p值小于0.05）的点赋不同的颜色，来显示两组样品间的差异显著性。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;①输入的表格文件，支持txt(制表符分隔)文本文件格式。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;②自定义标题，x轴、y轴标题可自行定义，默认标题(Volcano Plot),x轴标题(log2(FC)),y轴标题(-log10(p-value))。<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;①x轴所在的列：log2(FC)所在的列。y轴所在的列：p-value所在的列或q-value所在的列<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;②x轴阈值：即是差异倍数的阈值,一般为 2 或 1.5，可以自行输入。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③y轴阈值：p-value或q-value的阈值,0.01 或 0.05。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;④xmax：画出的图中x轴最大值。ymax:画出的图中y轴最大的值。<br>
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
  name: 'Huanshan',
  data() {
    return{
      formData: new FormData(),
      formInline: {
        file: '',
        title: 'volcano',
        no: '',
        size: 1.5,
        xmax: 4,
        ymax: 30,
        xcol: 6,
        xnum: 2,
        ycol: 7,
        ynum: 0.01,
        dcolor: '#92d050',
        ucolor: '#ff0000',
        ncolor: '#000000',
      },
      para: {
        "historyid": '',
        "title_0": '',
        "psize_1": '',
        "xmax_2": '',
        "ymax_3": '',
        "xcol_4": '',
        "xval_5": '',
        "ycol_6": '',
        "yval_7": '',
        "downc_8": '',
        "notc_9": '',
        "upc_10": '',
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
    this.formInline.no = 'Volcano' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/volcano_plot/vol_exa.txt','_blank')
    },

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'Volcano.svg'  // 下载文件的名字
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
        _this.para.psize_1 = _this.formInline.size
      }

      if(_this.formInline.xmax!==''){
        _this.para.xmax_2 = _this.formInline.xmax
      }

      if(_this.formInline.ymax!==''){
        _this.para.ymax_3 = _this.formInline.ymax
      }

      if(_this.formInline.xcol!==''){
        _this.para.xcol_4 = _this.formInline.xcol
      }

      if(_this.formInline.xnum!==''){
        _this.para.xval_5 = _this.formInline.xnum
      }

      if(_this.formInline.ycol!==''){
        _this.para.ycol_6 = _this.formInline.ycol
      }

      if(_this.formInline.ynum!==''){
        _this.para.yval_7 = _this.formInline.ynum
      }

      if(_this.formInline.dcolor!==''){
        _this.para.downc_8 = _this.formInline.dcolor
      }

      if(_this.formInline.ucolor!==''){
        _this.para.upc_10 = _this.formInline.ucolor
      }

      if(_this.formInline.ncolor!==''){
        _this.para.notc_9 = _this.formInline.ncolor
      }


      if(_this.fileData == null){
        alert("文件不能为空");
      }else {
        console.log(_this.formData.get('files'))

        _this.$axios({
          url: this.Host.BASE_URL  +'BaseFunction/volcano_plot/multiUpload',
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
              url: this.Host.BASE_URL  + 'BaseFunction/volcano_plot/run',
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
