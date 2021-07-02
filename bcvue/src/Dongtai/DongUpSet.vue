<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>动态Upset图</h1>
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
        &nbsp;&nbsp;&nbsp;&nbsp;以upset图动态统计并展示集合间共有/特有元素信息。表格列名表示集合，行名表示元素，统计列之间的共有、特有元素。。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;支持txt(制表符分隔)文本文件、csv(逗号分隔)文本文件<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.	输出图片大小：自定义输出图片的长和宽（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.	标签：自定义集合（横矩形）名字和纵矩形名字（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.	点形式：自定义点的颜色，大小（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.	矩形颜色:自定义横矩形和纵矩形颜色（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.	Y轴数据：决定Y轴数据是否显示（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6.	排序方式：自定义矩阵中交集排序方式，"freq"从大到小排序，其他选项degree, 先freq后degree（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;7.	线宽度：自定义线的宽度（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;8.	交点数：自定义要绘制的交点数，如果设置为NA，将绘制所有交点（可选）<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;输出格式为svg<br>
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
            <el-form-item label="图片宽度 × 高度">
              <el-col :span="5">
                <el-input v-model="paraForm.pwidth" placeholder="" style="width: 100%;"></el-input>
              </el-col>
              <el-col class="line" :span="1">&#8194;×</el-col>
              <el-col :span="5">
                <el-input v-model="paraForm.pheight" placeholder="" style="width: 100%;"></el-input>
              </el-col>
            </el-form-item>
            <el-form-item label="集合（横矩形）名" :label-width="formLabelWidth">
              <el-input v-model="paraForm.slabel" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="纵矩形名" :label-width="formLabelWidth">
              <el-input v-model="paraForm.ylabel" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="点颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.pcolor" :placeholder="paraForm.pcolor">
              </el-input>
              <el-color-picker v-model="paraForm.pcolor" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="纵矩形颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.ycolor" :placeholder="paraForm.ycolor">
              </el-input>
              <el-color-picker v-model="paraForm.ycolor" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="集合(横矩形)颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.scolor" :placeholder="paraForm.scolor">
              </el-input>
              <el-color-picker v-model="paraForm.scolor" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="y轴数据是否显示" :label-width="formLabelWidth">
              <el-select v-model="paraForm.yshow" :placeholder="paraForm.yshow">
                <el-option label="显示" value="yes"></el-option>
                <el-option label="不显示" value="no"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="矩阵中交集排序方式" :label-width="formLabelWidth">
              <el-select v-model="paraForm.ob" :placeholder="paraForm.ob">
                <el-option label="从大到小排序" value="freq"></el-option>
                <el-option label="degree" value="degree"></el-option>
              </el-select>
            </el-form-item>

            <el-form-item label="点大小" :label-width="formLabelWidth">
              <el-input v-model="paraForm.psize" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="线宽度" :label-width="formLabelWidth">
              <el-input v-model="paraForm.lsize" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="集合排序" :label-width="formLabelWidth">
              <el-select v-model="paraForm.uo" :placeholder="paraForm.uo">
                <el-option label="从大到小" value="FALSE"></el-option>
                <el-option label="从小到大" value="TRUE"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="交点数" :label-width="formLabelWidth">
              <el-input v-model="paraForm.in" :placeholder="paraForm.in"></el-input>
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
  name: 'DongUpSet',
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
        "pwidth_0": '',
        "pheight_1": '',
        "slabel_2": '',
        "ylabel_3": '',
        "pcolor_4": '',
        "ycolor_5": '',
        "scolor_6": '',
        "yshow_7": '',
        "ob_8": '',
        "psize_9": '',
        "lsize_10": '',
        "uo_11": '',
        "in_12": '',
      },

      paraForm: {
        pwidth: '8',
        pheight: '8',
        slabel: 'Set Size',
        ylabel: 'Intersection Size',
        pcolor: '#000000',
        ycolor: '#000000',
        scolor: '',
        yshow: 'yes',
        ob: 'freq',
        psize: '3',
        lsize: '1',
        uo: 'TRUE',
        in: 'NA',
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
    this.formInline.no = 'Reportupset' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/Dynamic/upset_chart/upset.txt','_blank')
    },

    handleClose(done) {
      let _this = this;
      this.$confirm('确定要提交表单吗？')
        .then(_ => {
          if(_this.paraForm.pwidth!==''){
            _this.paras.pwidth_0 = _this.paraForm.pwidth
          }

          if(_this.paraForm.pheight!==''){
            _this.paras.pheight_1 = _this.paraForm.pheight
          }

          if(_this.paraForm.slabel!==''){
            _this.paras.slabel_2 = _this.paraForm.slabel
          }

          if(_this.paraForm.ylabel!==''){
            _this.paras.ylabel_3 = _this.paraForm.ylabel
          }

          if(_this.paraForm.pcolor!==''){
            _this.paras.pcolor_4 = 'c("' + _this.paraForm.pcolor + '")'
          }

          if(_this.paraForm.ycolor!==''){
            _this.paras.ycolor_5 = 'c("' + _this.paraForm.ycolor + '")'
          }

          if(_this.paraForm.scolor!==''){
            _this.paras.scolor_6 = 'c("' + _this.paraForm.scolor + '")'
          }else{
            _this.paras.scolor_6 = 'NULL'
          }

          if(_this.paraForm.yshow!==''){
            _this.paras.yshow_7 = _this.paraForm.yshow
          }

          if(_this.paraForm.ob!==''){
            _this.paras.ob_8 = 'c("' + _this.paraForm.ob + '")'
          }

          if(_this.paraForm.psize!==''){
            _this.paras.psize_9 = _this.paraForm.psize
          }

          if(_this.paraForm.lsize!==''){
            _this.paras.lsize_10 = _this.paraForm.lsize
          }

          if(_this.paraForm.uo!==''){
            _this.paras.uo_11 = _this.paraForm.uo
          }

          if(_this.paraForm.in!==''){
            _this.paras.in_12 = _this.paraForm.in
          }

          console.log(_this.paras)

          _this.$axios({
            url: this.Host.BASE_URL + 'Dynamic/upset_chart/run',
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
        a.download = 'reporticaw.svg'  // 下载文件的名字
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
            url: this.Host.BASE_URL + 'Dynamic/upset_chart/multiUpload',
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
                url: this.Host.BASE_URL + 'Dynamic/upset_chart/run',
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
