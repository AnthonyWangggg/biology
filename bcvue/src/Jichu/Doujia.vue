<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>豆荚图</h1>
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
          <el-form-item label="分组1名称">
            <el-input v-model="formInline.name1" :placeholder="formInline.name1"></el-input>
          </el-form-item>
          <el-form-item label="分组1颜色">
            <el-input v-model="formInline.color1" :placeholder="formInline.color1">
            </el-input>
            <el-color-picker v-model="formInline.color1" size="small"></el-color-picker>
          </el-form-item>
          <el-form-item label="输入文件2">
            <el-input  v-model="formInline.file1" :placeholder="this.formInline.file1" :readonly="true"></el-input>
            <el-button type="button" id="fileImports" v-on:click="clickLoad1">选择上传的数据文件</el-button>
            <input type="file" id="filess" ref="refFiles" style="display: none"  v-on:change="fileLoad1">
            <el-link class="outputbutton" type="info" v-on:click="file2">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="分组2名称">
            <el-input v-model="formInline.name2" :placeholder="formInline.name2"></el-input>
          </el-form-item>
          <el-form-item label="分组2颜色">
            <el-input v-model="formInline.color2" :placeholder="formInline.color2">
            </el-input>
            <el-color-picker v-model="formInline.color2" size="small"></el-color-picker>
          </el-form-item>
          <el-form-item label="X轴标题">
            <el-input v-model="formInline.Xtitle" :placeholder="formInline.Xtitle"></el-input>
          </el-form-item>
          <el-form-item label="Y轴标题">
            <el-input v-model="formInline.Ytitle" :placeholder="formInline.Ytitle"></el-input>
          </el-form-item>
          <el-form-item label="图片标题">
            <el-input v-model="formInline.title" :placeholder="formInline.title"></el-input>
          </el-form-item>
        </el-form>

        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <!--<el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <input type="file" id="files" ref="refFile" style="display: none" v-on:change="fileLoad">-->
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;与分组小提琴图类似，把两组合并为一个小提琴图展示，便于直观比较两组之间的数据分布状态，适合展示多因素数据分布。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;1. 文件必须是支持txt(制表符分隔)文本文件。表格名称以字母、数字、下划线组成，不可以有空格。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;2. 文件第一行“a/b/c/d”为X轴参数，可以为不同样本、不同基因、不同cluster、不同时间梯度等；第一列为Y轴参数属性，可以为基因ID、细胞barcode、样本等，对应内容（数值）可以为基因表达量、细胞UMI、肿瘤体积等。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;3. 两组文件中，每组文件的列数和对应列的名称需保持一致。<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 输入文件，依次输入两个文件，文件1对应分组1，文件2对应分组2，可自定义分组名称及颜色，如未选择则为系统默认名称及颜色。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. X轴标题：自定义<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. Y轴标题：自定义<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. 图形标题：自定义<br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;提供图片下载<br>
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
  name: 'Doujia',
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formData1: new FormData(),
      formInline: {
        file: '',
        file1: '',
        no: '',
        name1: 'File1',
        name2: 'File2',
        color1: '#FF0000',
        color2: '#15FF00',
        title: 'Splitviolin',
        Xtitle: 'X',
        Ytitle: 'Y',
      },
      para: {
        "historyid": '',
        "color_0": '',
        "color_1": '',
        "title_2": '',
        "Xt_3": '',
        "Yt_4": '',
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
      pic: '',
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Splitviolin' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/podfigure/splitviolin1.txt','_blank')
    },

    file2(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/podfigure/splitviolin2.txt','_blank')
    },

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'Splitviolin.svg'  // 下载文件的名字
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
        if(_this.formInline.color1!==''){
          _this.para.color_0 ='c("'+_this.formInline.color1+'")'
        }
        if(_this.formInline.color2!==''){
          _this.para.color_1 ='c("'+_this.formInline.color2+'")'
        }
        if(_this.formInline.title!==''){
          _this.para.title_2 =_this.formInline.title
        }
        if(_this.formInline.Xtitle!==''){
          _this.para.Xt_3 =_this.formInline.Xtitle
        }if(_this.formInline.Ytitle!==''){
          _this.para.Yt_4 =_this.formInline.Ytitle
        }
        console.log(_this.para)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('files'))

          _this.$axios({
            url: this.Host.BASE_URL + 'BaseFunction/podfigure/multiUpload',
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
                url: this.Host.BASE_URL + 'BaseFunction/podfigure/run',
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
