<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>断轴柱状图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <!--          <el-form-item label="自定义标题">-->
          <!--            <el-input v-model="formInline.title" placeholder=""></el-input>-->
          <!--          </el-form-item>-->
          <el-form-item label="表格数据">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="分组文件">
            <el-input  v-model="formInline.file1" :placeholder="this.formInline.file1" :readonly="true"></el-input>
            <el-button type="button" id="fileImports" v-on:click="clickLoad1">选择上传的数据文件</el-button>
            <input type="file" id="filess" ref="refFiles" style="display: none"  v-on:change="fileLoad1">
            <el-link class="outputbutton" type="info" v-on:click="file2">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="断轴上下比例">
            <el-input v-model="formInline.ratio" :placeholder="formInline.ratio"></el-input>
          </el-form-item>
          <el-form-item label="下断点值">
            <el-input v-model="formInline.btm" :placeholder="formInline.btm"></el-input>
          </el-form-item>
          <el-form-item label="上断点值">
            <el-input v-model="formInline.top" :placeholder="formInline.top"></el-input>
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

        <el-form  :model="colorInline" class="demo-form-inline">
          <el-form-item  v-for="(color, index) in colorInline.color1"
                         :label="'柱' + index + '颜色'"
                         :key="color.key" :span="18">
            <td>
              <el-input v-model="color.color" :placeholder="color.color"></el-input>
            </td>
            <td>
              <el-color-picker v-model="color.color" size="small"></el-color-picker>
              <el-button @click.prevent="removeColor(color)">删除</el-button>
            </td>
          </el-form-item>
          <el-form-item>
            <el-button @click="addColor">新增颜色</el-button>
            <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
          </el-form-item>
        </el-form>


<!--        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>-->
        <!--<el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <input type="file" id="files" ref="refFile" style="display: none" v-on:change="fileLoad">-->
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;柱状图（或称条形图）是数据展示最常用的图形之一。当需要展示的数据间差异较大时，会出现一些“柱子”极高，而一些“柱子”低到几乎看不到的程度。纵坐标中断柱状图被用于解决这种由于数据间相差过大从而导致的部分数据被掩盖的问题，通过分段展示纵轴内容，保证高低数据都能得到合理的展示。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;注意：输入的表格文件，支持txt(制表符分隔)文本文件<br>
        &nbsp;&nbsp;&nbsp;&nbsp;表格第一列输入横轴各分组名称，第二列起输出依次输入各组数据。<br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;颜色：自定义
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;下断点值：输入断点下端位置数值<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;上断点值：输入断点上端位置数值<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;标题：输入标题信息<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;X轴标题：输入X轴名称<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Y轴标题：输入Y轴名称<br>

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
  name: 'Duanzhou',
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
        title: 'broken_columns',
        Xtitle: 'X',
        Ytitle: 'Y',
        radio: '0.65',
        btm: '1',
        top: '3',
      },

      colorInline: {
        color1: [{
          color: '#000fff'
        }],
        color2: '',
        color3: '',
      },

      para: {
        "historyid": '',
        "color_0": '',
        "btm_1": '',
        "top_2": '',
        "title_3": '',
        "Xt_4": '',
        "Yt_5": '',
        "radio_6": '',
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
    this.formInline.no = 'broken_columns' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/broken_chart/broken_columns_genus.txt','_blank')
    },

    file2(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/broken_chart/broken_columns_group.txt','_blank')
    },

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'broken_columns.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
    },

    removeColor(item) {
      var index = this.colorInline.color1.indexOf(item)
      if (index !== -1) {
        this.colorInline.color1.splice(index, 1)
      }
    },
    addColor() {
      this.colorInline.color1.push({
        value: '',
        key: Date.now()
      });
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
        if(_this.formInline.btm!==''){
          _this.para.btm_1 = _this.formInline.btm
        }
        if(_this.formInline.top!==''){
          _this.para.top_2 = _this.formInline.top
        }
        if(_this.formInline.title!==''){
          _this.para.title_3 =_this.formInline.title
        }
        if(_this.formInline.Xtitle!==''){
          _this.para.Xt_4 =_this.formInline.Xtitle
        }
        if(_this.formInline.Ytitle!==''){
          _this.para.Yt_5 =_this.formInline.Ytitle
        }
        if(_this.formInline.radio!==''){
          _this.para.radio_6 =_this.formInline.radio
        }

        if(_this.colorInline.color1.length!==0){
          _this.para.color_0 = 'c('
          for (let i = 0; i < _this.colorInline.color1.length; i++){
            if(i===0){
              _this.para.color_0 = _this.para.color_0 + '"'+ _this.colorInline.color1[i].color + '"'
            }else{
              _this.para.color_0 = _this.para.color_0 + ',' +  '"'+ _this.colorInline.color1[i].color + '"'
            }
          }
          _this.para.color_0 = _this.para.color_0 + ')'
        }


        console.log(_this.para)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('files'))

          _this.$axios({
            url: this.Host.BASE_URL + 'BaseFunction/broken_chart/multiUpload',
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
                url: this.Host.BASE_URL + 'BaseFunction/broken_chart/run',
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
  height: auto;
  width: auto;
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
