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
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item>
          </el-form-item>
          <el-form-item label="饼图类型">
            <el-select v-model="formInline.region" :placeholder="formInline.region">
              <el-option label="高级2D饼图" value="1"></el-option>
<!--              <el-option label="普通2D饼图" value="2"></el-option>-->
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
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;用一个带有表头的数据绘制动态饼图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;支持txt(制表符分隔)文本文件，csv(逗号分隔)文本文件。<br>
        &nbsp;&nbsp;&nbsp;&nbsp; 分为两列，数据与数据之间用制表符（tab符）隔开，不能用空格，制图时以第一行作为表头，其余行为数据，共两列。
        <br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.饼图标题：饼图的主标题（必选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.饼图类型：1为高级2D饼图，漏斗图互换,可以拖拽重算,可以加辅助线，可以改变主题颜色<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.饼图主题：可供选择1高级2D饼图的主题，有如下主题可供选择“macarons”, “infographic”, “blue”, “dark”, “gray”, “green”,“shine”,“helianthus”, “macarons2”, “mint”, “red”, “roma”, “sakura”,  “vintage”（可选）<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;输出格式为HTML；<br>
      </div>
    </div>
    <div id="line">
      <h2>生成结果</h2>
    </div>
    <div class="b2">
      <div class="output" v-show="pic!==''">
<!--        <div @click="toRescue">-->
<!--          window.location.href跳转到外部链接测试-->
<!--        </div>-->
        <span>查看结果：</span>
        <el-button type="info" icon="el-icon-download" size="mini" v-on:click="toRescue" circle></el-button>
      </div>
    </div>
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
      pic: '',
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
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/pie/pie.txt','_blank')
    },

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'Pie.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
    },

    toRescue() {
      window.location.href = this.pic;
    },

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
              url: this.Host.BASE_URL + 'BaseFunction/pie/run',
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
