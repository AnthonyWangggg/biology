<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>分组小提琴图</h1>
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
          <el-form-item label="第一列是否为数字">
            <el-select v-model="formInline.num" :placeholder="formInline.num">
              <el-option label="否" value="FALSE"></el-option>
              <el-option label="是" value="TRUE"></el-option>
            </el-select>
          </el-form-item>
        </el-form>
                <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;用表格数据绘制分组小提琴图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;1、输入文件支持txt(制表符分隔)文本文件、csv(逗号分隔)文本文件，<br>
        &nbsp;&nbsp;&nbsp;&nbsp;2、文件需要带表头和列名，以第一行为X轴，每一列可代表不同样本、不同基因或不同类型，可以输入基因表达量表、代谢物丰度表、微生物丰度表等，也可以是其他数据，例如肿瘤大小、体重、长度等指标。最后一列必须为分组数据。<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.第一列是否为数字：默认第一列为字符，如果第一列即为数字请选择是，其他剩余的列必须是数字（除表头）（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.标题：可自定义小提琴图标题（可选）<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;violin：结果表，包含最大值，最小值，中位数，R1,R3的表格<br>
        &nbsp;&nbsp;&nbsp;&nbsp;默认输出jpg格式的结果图<br>

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
      <div class="output" v-show="pic!==''">
        <span>文件导出：</span>
        <el-button type="info" icon="el-icon-download" size="mini" :href="csv" @click.prevent="downloadItem(csv, csv)" ></el-button>
      </div>
    </div>
  </div>

</template>

<script>
// import host from '../host.vue'
// Vue.prototype.$host = host
//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'FenQing',
  data() {
    return{
      formData: new FormData(),
      formInline: {
        file: '',
        num: 'FALSE',
        title: 'groupedviolin',
        Xtitle: 'X',
        Ytitle: 'Y',
        no: '',
      },
      colorInline: {
        color1: [{
          color: '#FF0000'
        }],
      },
      para: {
        "historyid": '',
        "first_0": '',
        "title_1": '',
      },
      chartInstance:null,
      fileData:null, //读取的数据
      rd:[],
      pic: '',
      csv: '',
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Groupedviolin' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/groupedviolin/mut_violin.txt','_blank')
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
        a.download = 'groupedviolin.jpg'  // 下载文件的名字
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

    chartCommit(){
      let _this = this;

      //参数设置
      if(_this.formInline.title!==''){
        _this.para.title_1 =_this.formInline.title
      }

      if(_this.formInline.num!==''){
        _this.para.first_0 =_this.formInline.num
      }


      if(_this.fileData == null){
        alert("文件不能为空");
      }else {
        console.log(_this.formData.get('files'))
        _this.$axios({
          url: this.Host.BASE_URL + 'BaseFunction/groupedviolin/multiUpload',
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
            _this.$router.replace('Login');
          }else{
            _this.$axios({
              url: this.Host.BASE_URL  + 'BaseFunction/groupedviolin/run',
              method: 'post',
              data: _this.para,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': localStorage.getItem("token")
              },

            }).then((res)=>{
              console.log(res)
              _this.rd = res.data.split(',')
              _this.csv = this.Host.BASE_URL  + _this.rd[1]
              _this.pic = this.Host.BASE_URL  + _this.rd[0]
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
  height: 600px;
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
