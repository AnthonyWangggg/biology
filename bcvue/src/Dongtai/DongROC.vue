<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>动态ROC</h1>
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
        &nbsp;&nbsp;&nbsp;&nbsp;ROC曲线（receiver operator characteristic curve，ROC curve），以真阳性率TPR（True positive rate）（灵敏度，sensitivity）为纵坐标，假阳性率FPR（False positive rate）（特异度，specificity）为横坐标绘制的曲线。主要用来评价一个二值分类器（binary classifier）的优劣，常用于评价一个物种或一个基因在两组间的区分效果（即物种或基因的指示性分析）。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;数据文件：上传文件格式说明：支持txt(制表符分隔)文本文件、csv(逗号分隔)文本文件。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;输入两列数据，第一列为分组信息（仅输入样本所在分组即可，分组数量只能为2组），第二列为物种丰度或基因表达量等数据，输入表格必须带有列名。<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.	颜色设置：自定义下方颜色和上方区域颜色，网格颜色，线的颜色，对角线颜色<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.	数值设置：自定义是否显示AUC的值，是否转换为分数形式<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.	形式设置：是否添加对角线，是否展示网格，是否展示置信区间，是否显示上方区域，是否显示最大值的点坐标<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.	标题设置：自定义标题，X轴标题和Y轴标题<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;输出格式为SVG<br>
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
        <div class="demo-drawer__content">
          <el-form :model="paraForm" :label-width="formLabelWidth">
            <el-form-item label="下方区域颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.lcolor" :placeholder="paraForm.lcolor">
              </el-input>
              <el-color-picker v-model="paraForm.lcolor" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="上方区域颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.ucolor" :placeholder="paraForm.ucolor">
              </el-input>
              <el-color-picker v-model="paraForm.ucolor" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="网格竖线颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.gcolor1" :placeholder="paraForm.gcolor1">
              </el-input>
              <el-color-picker v-model="paraForm.gcolor1" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="网格横线颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.gcolor2" :placeholder="paraForm.gcolor2">
              </el-input>
              <el-color-picker v-model="paraForm.gcolor2" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="是否显示AUC的值" :label-width="formLabelWidth">
              <el-select v-model="paraForm.ashow" :placeholder="paraForm.ashow">
                <el-option label="显示" value="TRUE"></el-option>
                <el-option label="不显示" value="FALSE"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="是否显示上方区域" :label-width="formLabelWidth">
              <el-select v-model="paraForm.ushow" :placeholder="paraForm.ushow">
                <el-option label="显示" value="TRUE"></el-option>
                <el-option label="不显示" value="FALSE"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="是否显示最大值的点坐标" :label-width="formLabelWidth">
              <el-select v-model="paraForm.maxpoint" :placeholder="paraForm.maxpoint">
                <el-option label="显示" value="TRUE"></el-option>
                <el-option label="不显示" value="FALSE"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="X标题" :label-width="formLabelWidth">
              <el-input v-model="paraForm.xtext" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="Y标题" :label-width="formLabelWidth">
              <el-input v-model="paraForm.ytext" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="主标题" :label-width="formLabelWidth">
              <el-input v-model="paraForm.title" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="线的颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.linecolor" :placeholder="paraForm.linecolor">
              </el-input>
              <el-color-picker v-model="paraForm.linecolor" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="是否展示置信区间" :label-width="formLabelWidth">
              <el-select v-model="paraForm.cshow" :placeholder="paraForm.cshow">
                <el-option label="显示" value="TRUE"></el-option>
                <el-option label="不显示" value="FALSE"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="是否展示网格" :label-width="formLabelWidth">
              <el-select v-model="paraForm.gshow" :placeholder="paraForm.gshow">
                <el-option label="显示" value="TRUE"></el-option>
                <el-option label="不显示" value="FALSE"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="是否转换为分数形式" :label-width="formLabelWidth">
              <el-select v-model="paraForm.pshow" :placeholder="paraForm.pshow">
                <el-option label="显示" value="TRUE"></el-option>
                <el-option label="不显示" value="FALSE"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="对角线颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.icolor" :placeholder="paraForm.icolor">
              </el-input>
              <el-color-picker v-model="paraForm.icolor" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="是否添加对角线" :label-width="formLabelWidth">
              <el-select v-model="paraForm.ishow" :placeholder="paraForm.ishow">
                <el-option label="显示" value="TRUE"></el-option>
                <el-option label="不显示" value="FALSE"></el-option>
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
import pdf from 'vue-pdf'
export default {
  name: 'DongROC',
  components: {
    pdf
  },
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
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
        "lcolor_0": '',
        "ucolor_1": '',
        "gcolor_2": '',
        "ashow_3": '',
        "ushow_4": '',
        "maxpoint_5": '',
        "xtext_6": '',
        "ytext_7": '',
        "title_8": '',
        "linecolor_9": '',
        "cshow_10": '',
        "gshow_11": '',
        "pshow_12": '',
        "icolor_13": '',
        "ishow_14": '',
      },

      paraForm: {
        lcolor: '#87ceeb',
        ucolor: '#ffa500',
        gcolor1: '#008000',
        gcolor2: '#ff0000',
        ashow: 'TRUE',
        ushow: 'TRUE',
        maxpoint: 'TRUE',
        xtext: 'Specificity',
        ytext: 'Specificity',
        title: 'ROC',
        linecolor: '#ff0000',
        cshow: 'FALSE',
        gshow: 'TRUE',
        pshow: 'FALSE',
        icolor: '#A9A9A9',
        ishow: 'TRUE',
      },

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
    this.formInline.no = 'ReportROC' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/Dynamic/ROC/ROC.txt','_blank')
    },

    handleClose(done) {
      let _this = this;
      this.$confirm('确定要提交表单吗？')
        .then(_ => {

          if(_this.paraForm.lcolor!==''){
            _this.paras.lcolor_0 = _this.paraForm.lcolor
          }

          if(_this.paraForm.ucolor!==''){
            _this.paras.ucolor_1 = _this.paraForm.ucolor
          }

          if(_this.paraForm.gcolor1!==''&&_this.paraForm.gcolor2!==''){
            _this.paras.gcolor_2 = 'c("' + _this.paraForm.gcolor1 + '","' + _this.paraForm.gcolor2 + '")'
          }

          if(_this.paraForm.ashow!==''){
            _this.paras.ashow_3 = _this.paraForm.ashow
          }

          if(_this.paraForm.ushow!==''){
            _this.paras.ushow_4 = _this.paraForm.ushow
          }

          if(_this.paraForm.maxpoint!==''){
            _this.paras.maxpoint_5 = _this.paraForm.maxpoint
          }

          if(_this.paraForm.xtext!==''){
            _this.paras.xtext_6 = _this.paraForm.xtext
          }

          if(_this.paraForm.ytext!==''){
            _this.paras.ytext_7 = _this.paraForm.ytext
          }

          if(_this.paraForm.title!==''){
            _this.paras.title_8 = _this.paraForm.title
          }

          if(_this.paraForm.linecolor!==''){
            _this.paras.linecolor_9 = _this.paraForm.linecolor
          }

          if(_this.paraForm.cshow!==''){
            _this.paras.cshow_10 = _this.paraForm.cshow
          }

          if(_this.paraForm.gshow!==''){
            _this.paras.gshow_11 = _this.paraForm.gshow
          }

          if(_this.paraForm.pshow!==''){
            _this.paras.pshow_12 = _this.paraForm.pshow
          }

          if(_this.paraForm.icolor!==''){
            _this.paras.icolor_13 = _this.paraForm.icolor
          }

          if(_this.paraForm.ishow!==''){
            _this.paras.ishow_14 = _this.paraForm.ishow
          }

          console.log(_this.paras)

          _this.$axios({
            url: this.Host.BASE_URL + 'Dynamic/ROC/run',
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
            }else if (res.data === 'Error'){
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
        a.download = 'ReportROC.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
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
            url: this.Host.BASE_URL + 'Dynamic/ROC/multiUpload',
            method: 'post',
            data: _this.formData,
            headers: {
              "Content-Type": "multipart/form-data" ,
              'Authorization': localStorage.getItem("token")
            },

          }).then((res)=>{
            _this.para.historyid = res.data
            _this.paras.historyid = res.data
            console.log(res)
            if(res.data==='token过期'){
              localStorage.removeItem("Flag")
              localStorage.removeItem("token")
              this.$router.replace('Login');
            }else if (res.data === 'Error'){
              this.$message.error('发生错误，检查提交文件及参数，重新提交');
            }else{
              _this.$axios({
                url: this.Host.BASE_URL + 'Dynamic/ROC/run',
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
