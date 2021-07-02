<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>动态circos图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="表格数据">
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
        &nbsp;&nbsp;&nbsp;&nbsp;以Circos图的环形布局直观展示任意二维矩阵（即行名、列名、数值）的数据分布特征。推荐行数、列数小于10。。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;支持txt(制表符分隔)文本文件、csv(逗号分隔)文本文件<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.	透明度：自定义修改透明度（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.	颜色：颜色每次自动更新。<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;输出为svg格式的图片<br>
      </div>
    </div>
    <div id="line">
      <h2>生成结果</h2>
      <el-button v-show="pic!==''" @click="dialog  = true" type="primary" style="margin-left: 16px;">
        点我打开
      </el-button>
      <el-drawer
        title="动态交互"
        :before-close="handleClose"
        :visible.sync="dialog"
        direction="ltr"
        custom-class="demo-drawer"
        ref="drawer"
        append-to-body=“true”
      >
        <!--        <el-scrollbar style="height:50%"> &lt;!&ndash; 滚动条 &ndash;&gt;-->
        <div class="demo-drawer__content">
          <el-form :model="paraForm">
            <el-form-item label="透明度" :label-width="formLabelWidth">
              <el-select v-model="paraForm.number" :placeholder="paraForm.number">
                <el-option label="0.0" value="0"></el-option>
                <el-option label="0.1" value="0.1"></el-option>
                <el-option label="0.2" value="0.2"></el-option>
                <el-option label="0.3" value="0.3"></el-option>
                <el-option label="0.4" value="0.4"></el-option>
                <el-option label="0.5" value="0.5"></el-option>
                <el-option label="0.6" value="0.6"></el-option>
                <el-option label="0.7" value="0.7"></el-option>
                <el-option label="0.8" value="0.8"></el-option>
                <el-option label="0.9" value="0.9"></el-option>
                <el-option label="1.0" value="1"></el-option>
              </el-select>
            </el-form-item>
          </el-form>
          <div class="but">
            <el-button @click="cancelForm">取 消</el-button>
            <el-button type="primary" @click="$refs.drawer.closeDrawer()">确 定</el-button>
          </div>
        </div>
      </el-drawer>
    </div>
    <div class="b2">
<!--      <div id="echart1" v-show="pic!==''">-->
        <div id="echart1">
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
import pdf from 'vue-pdf'
export default {
  name: 'DongCircos',
  components: {
    pdf
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
      paras: {
        "historyid": '',
        "tran_0": '',
        // "gcolor_1": '',
        // "lcolor_2": '',
      },
      colorInline: {
        color1: [{
          color: '#ffffcc'
        },
          {
            color: '#ccffff'
          },
          {
            color: '#ffcccc'
          }],
        color2: '',
        color3: '',
      },

      colorInline1: {
        color1: [{
          color: '#ff6666'
        },{
          color: '#ffff00'
        },{
          color: '#0066cc'
        }],
        color2: '',
        color3: '',
      },

      paraForm: {
        type: '0.1',
        number: '0.3',
      },

      historyid: '',
      chartInstance:null,
      fileData:null, //读取的数据
      fileData1:null, //读取基因组的数据
      pic: '',

      drawer: false,
      dialog: false,
      loading: false,
      formLabelWidth: '80px',
      timer: null,
      showModal: false,
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'ReportCircos' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/Dynamic/circosm/circos.txt','_blank')
    },

    handleClose(done) {
      let _this = this;
      this.$confirm('确定要提交表单吗？')
        .then(_ => {
          // _this.paras.historyid = _this.history
          // console.log(_this.history)
          console.log((_this.paras.historyid))

          if(_this.paraForm.number!==''){
            _this.paras.tran_0 = _this.paraForm.number
          }

          // if(_this.colorInline.color1.length>0){
          //   _this.paras.gcolor_1 = 'c('
          //   for (let i = 0; i < _this.colorInline.color1.length; i++){
          //     // if(_this.colorInline.color1[i].color!=null){
          //     //   colors[i] = _this.colorInline.color1[i].color
          //     // }
          //     if(i===0){
          //       _this.paras.gcolor_1 = _this.paras.gcolor_1 + '"'+ _this.colorInline.color1[i].color + '"'
          //     }else{
          //       _this.paras.gcolor_1 = _this.paras.gcolor_1 + ',' +  '"'+ _this.colorInline.color1[i].color + '"'
          //     }
          //   }
          //   _this.paras.gcolor_1 = _this.paras.gcolor_1 + ')'
          // }
          //
          // if(_this.colorInline1.color1.length>0){
          //   _this.paras.lcolor_2 = 'c('
          //   for (let i = 0; i < _this.colorInline1.color1.length; i++){
          //     // if(_this.colorInline.color1[i].color!=null){
          //     //   colors[i] = _this.colorInline.color1[i].color
          //     // }
          //     if(i===0){
          //       _this.paras.lcolor_2 = _this.paras.lcolor_2 + '"'+ _this.colorInline1.color1[i].color + '"'
          //     }else{
          //       _this.paras.lcolor_2 = _this.paras.lcolor_2 + ',' +  '"'+ _this.colorInline1.color1[i].color + '"'
          //     }
          //   }
          //   _this.paras.lcolor_2 = _this.paras.lcolor_2 + ')'
          // }

          console.log(_this.paras)

          _this.$axios({
            url: this.Host.BASE_URL + 'Dynamic/circosm/run',
            method: 'post',
            data: _this.paras,
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
            }
            else if (res.data === 'Error'){
              _this.pic = ''
              this.$message.error('发生错误，检查提交文件及参数，重新提交');
            }
          })

          this.loading = false;
          this.dialog = false;
          clearTimeout(this.timer);
        })
        .catch(_ => {
          this.loading = false;
          this.dialog = false;
          clearTimeout(this.timer);
        });
      this.loading = false;
      this.dialog = false;
      clearTimeout(this.timer);
    },
    cancelForm() {
      this.loading = false;
      this.dialog = false;
      clearTimeout(this.timer);
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

    removeColor1(item) {
      var index = this.colorInline1.color1.indexOf(item)
      if (index !== -1) {
        this.colorInline1.color1.splice(index, 1)
      }
    },
    addColor1() {
      this.colorInline1.color1.push({
        value: '',
        key: Date.now()
      });
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

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('files'))

          _this.$axios({
            url: this.Host.BASE_URL + 'Dynamic/circosm/multiUpload',
            method: 'post',
            data: _this.formData,
            headers: {
              "Content-Type": "multipart/form-data" ,
              'Authorization': localStorage.getItem("token")
            },

          }).then((res)=>{
            _this.para.historyid = res.data
            _this.paras.historyid = res.data
            console.log(_this.history)
            console.log(res)
            if(res.data==='token过期'){
              localStorage.removeItem("Flag")
              localStorage.removeItem("token")
              this.$router.replace('Login');
            }else{
              _this.$axios({
                url: this.Host.BASE_URL + 'Dynamic/circosm/run',
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
  height: 500px;
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
.el-drawer {
  overflow: scroll
}
::-webkit-scrollbar {
  width: 0 !important;
}
::-webkit-scrollbar {
  width: 0 !important;height: 0;
}
</style>
