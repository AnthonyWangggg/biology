<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>权重网络图</h1>
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
          <el-form-item label="权重范围">
            <el-col :span="5">
              <el-input v-model="formInline.min" :placeholder="formInline.min" style="width: 100%;"></el-input>
            </el-col>
            <el-col class="line" :span="1">&#8194;-&#8194; </el-col>
            <el-col :span="5">
              <el-input v-model="formInline.max" :placeholder="formInline.max" style="width: 100%;"></el-input>
            </el-col>
          </el-form-item>
        </el-form>
                <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;将基因间的调控互作关系绘制成一个有权重的网络图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;①需要输入一个边界文件。支持txt(制表符分隔)文本文件格式。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;②边界文件格式说明:边界文件至少包含三列，其中，第一列和第二列为基因名称或基因ID，在同一行中，表示第一列的基因和第二列的基因有相互作用关系(没有方向的区分)。第三列为权重，即两个基因间的相关系数。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;在权重网络图中，不同的权重将用不同的线条类型表示。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;边界文件必需包含表头，表头可以自定义，如：fromNode, toNode, weight<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;①连通性：连通性的计算方法有硬阈值和软阈值两种方法。硬阈值是指一个基因与多少个基因有联系。例如基因A总共与10个基因有相互作用，则基因A的连通性为10。软阈值是指一个基因与其他基因的相关系数（权重，weight）的总和。例如基因A与基因B 的权重为0.2，与基因C的权重为0.3，与基因D的权重为0.5，则基因A的连通性为0.2+0.3+0.5=1。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;②权重范围：可自行设置权重范围，展示特定权重范围下的基因间调控关系。 注意：如果连通性方法选择的是硬阈值，则是先筛选权重范围再在这个范围内计算基因的连通性；如果连通性方法选择的是软阈值，则是先计算每个基因的连通性后再筛选权重范围进行展示。<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;输出一个格式为.svg的图片。<br>
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
// import host from '../host.vue'
// Vue.prototype.$host = host
//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'Quanwang',
  data() {
    return{
      formData: new FormData(),
      formInline: {
        file: '',
        num: 'False',
        title: 'cytoscape',
        Xtitle: 'X',
        Ytitle: 'Y',
        max: '1.0',
        min: '0.5',
        no: '',
      },
      colorInline: {
        color1: [{
          color: '#FF0000'
        }],
      },
      para: {
        "historyid": '',
        "min_0": '',
        "max_1": '',
      },
      chartInstance:null,
      fileData:null, //读取的数据
      pic: '',
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Cytoscape' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/weightednetwork/weight_exa.txt','_blank')
    },

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'Cytoscape.svg'  // 下载文件的名字
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
      if(_this.formInline.max!==''){
        _this.para.max_1 =_this.formInline.max
      }

      if(_this.formInline.min!==''){
        _this.para.min_0 =_this.formInline.min
      }


      if(_this.fileData == null){
        alert("文件不能为空");
      }else {
        console.log(_this.formData.get('files'))
        _this.$axios({
          url: this.Host.BASE_URL + 'BaseFunction/weightednetwork/multiUpload',
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
          }else if (res.data === 'Error'){
            this.$message.error('发生错误，检查提交文件及参数，重新提交');
          }else{
            _this.$axios({
              url: this.Host.BASE_URL  + 'BaseFunction/weightednetwork/run',
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
  height: auto;
  width: auto;
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
