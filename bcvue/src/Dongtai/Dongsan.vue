<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>动态三元图</h1>
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
          <el-form-item label="分组文件">
            <el-input  v-model="formInline.file1" :placeholder="this.formInline.file1" :readonly="true"></el-input>
            <el-button type="button" id="fileImports" v-on:click="clickLoad1">选择上传的数据文件</el-button>
            <input type="file" id="filess" ref="refFiles" style="display: none"  v-on:change="fileLoad1">
            <el-link class="outputbutton" type="info" v-on:click="file2">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          </el-form-item>
        </el-form>

        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;三元图，又称三元相图（Ternary Plot）有三个坐标轴，与直角坐标系不同，它的三个坐标轴“首尾相接”成夹角为60度的等边三角形。“元”即成分，或部分，三元图主要用来展示不同样本的三种成分的比例，微生物多样性分析当中，三元相图可以展示物种在不同分组当中的相对丰度的大小。三元图可分为富集型和分布型，本程序可同时将两种形式同时输出。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;1）数据表格为必须输入的文件，可以是基因表达量表格、微生物物种相对丰度表格等各类数据，根据标注内容进行作图。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;2）分组表格为必须输入的文件，三元图分组数为3，在分组表格中要写明三个分组的命名以及该分组中的样本，注意此文件一定要有表头。<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.	主标题：图片主标题（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.	点大小：自定义点的大小（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.	点形状：自定义点的形状（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.	点颜色：自定义点的颜色，一般三个一组（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.	网格颜色：自定义网格的颜色（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6.	边界颜色：自定义边界颜色（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;7.	背景颜色：自定义背景颜色，默认白色（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;8.	网格形式：自定义网格形式（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;9.	标签位置：自定义标签的位置（可选）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10.	图例显示：决定是否显示图例，默认为是。（可选）<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;输出格式为svg<br>
        &nbsp;&nbsp;&nbsp;&nbsp;输出图片1——富集三元图——<br>
        &nbsp;&nbsp;&nbsp;&nbsp;输出图片2——分布三元图——<br>
        &nbsp;&nbsp;&nbsp;&nbsp;数据文件输出路径——txt格式<br>

        &nbsp;&nbsp;&nbsp;&nbsp;程序将按要求输出面积图，提供SVG格式的图片下载<br>
      </div>
    </div>
    <div id="line">
      <h2>生成结果</h2>

      <el-button @click="dialog  = true" type="primary" style="margin-left: 16px;" v-show="pic!==''">
        自定义
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
            <el-form-item label="图片标题" :label-width="formLabelWidth">
              <el-input v-model="paraForm.title" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="点形状" :label-width="formLabelWidth">
              <el-select v-model="paraForm.pshape" :placeholder="paraForm.pshape">
                <el-option label="1" value="1"></el-option>
                <el-option label="2" value="2"></el-option>
                <el-option label="3" value="3"></el-option>
                <el-option label="4" value="4"></el-option>
                <el-option label="5" value="5"></el-option>
                <el-option label="6" value="6"></el-option>
                <el-option label="7" value="7"></el-option>
                <el-option label="8" value="8"></el-option>
                <el-option label="9" value="9"></el-option>
                <el-option label="10" value="10"></el-option>
                <el-option label="11" value="11"></el-option>
                <el-option label="12" value="12"></el-option>
                <el-option label="13" value="13"></el-option>
                <el-option label="14" value="14"></el-option>
                <el-option label="15" value="15"></el-option>
                <el-option label="16" value="16"></el-option>
                <el-option label="17" value="17"></el-option>
                <el-option label="18" value="18"></el-option>
                <el-option label="19" value="19"></el-option>
                <el-option label="20" value="20"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="网格颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.gcolor" :placeholder="paraForm.gcolor">
              </el-input>
              <el-color-picker v-model="paraForm.gcolor" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="点大小" :label-width="formLabelWidth">
              <el-input v-model="paraForm.size" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="点1颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.pcolor1" :placeholder="paraForm.pcolor1">
              </el-input>
              <el-color-picker v-model="paraForm.pcolor1" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="点2颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.pcolor2" :placeholder="paraForm.pcolor2">
              </el-input>
              <el-color-picker v-model="paraForm.pcolor2" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="点3颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.pcolor3" :placeholder="paraForm.pcolor3">
              </el-input>
              <el-color-picker v-model="paraForm.pcolor3" size="small"></el-color-picker>
            </el-form-item>
            <el-checkbox v-model="checked1">图例</el-checkbox>
            <el-form-item label="边界颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.bcolor" :placeholder="paraForm.bcolor">
              </el-input>
              <el-color-picker v-model="paraForm.bcolor" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="背景颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.bgcolor" :placeholder="paraForm.bgcolor">
              </el-input>
              <el-color-picker v-model="paraForm.bgcolor" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="网格形式" :label-width="formLabelWidth">
              <el-select v-model="paraForm.gs" :placeholder="paraForm.gs">
                <el-option label="虚线" value="dashed"></el-option>
                <el-option label="点状" value="dotted"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="标签位置" :label-width="formLabelWidth">
              <el-select v-model="paraForm.lp" :placeholder="paraForm.lp">
                <el-option label="inside" value="inside"></el-option>
                <el-option label="outside" value="outside"></el-option>
                <el-option label="none" value="none"></el-option>
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
      <div id="echart1" v-show="pics!==''">
        <!--      <img src="http://10.13.1.130:8081/public/20210429222508_heatmap.png" />-->
        <img :src="pics" />
      </div>
      <div class="output" v-show="pic!==''">
        <span>图表导出：</span>
        <el-link class="outputbutton" type="info" v-on:click="downs">SVG</el-link>
        <el-button type="info" icon="el-icon-download" size="mini" v-on:click="downs" circle></el-button>
<!--        <el-button :href="csv" @click.prevent="downloadItem(csv, 'sss.txt')" >下载</el-button>-->
      </div>
      <div class="output" v-show="pic!==''">
        <span>文件导出：</span>
        <el-button type="info" icon="el-icon-download" size="mini" :href="csv" @click.prevent="downloadItem(csv, 'sss.txt')" ></el-button>
      </div>
<!--      <el-link :href="csv" v-on:click="down1">查看<i class="el-icon-view el-icon&#45;&#45;right"></i> </el-link>-->

    </div>
  </div>

</template>

<script>

//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'Dongsan',
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formData1: new FormData(),
      formInline: {
        file: '',
        file1: '',
        no: '',
      },
      para: {
        "historyid": '',
      },
      paras: {
        "historyid": '',
        "title_0": '',
        "pshape_1": '',
        "gcolor_2": '',
        "size_3": '',
        "pcolor_4": '',
        "p_5": '',
        "bcolor_6": '',
        "bgcolor_7": '',
        "gs_8": '',
        "lp_9": '',
      },
      chartInstance:null,
      fileData:null, //读取的数据
      fileData1:null, //读取基因组的数据
      rd:[],
      pic: '',
      pics: '',
      csv: '',

      paraForm: {
        title: 'ternary',
        pshape: '18',
        gcolor: '#808080',
        size: '2',
        pcolor1: '#ff0000',
        pcolor2: '#0000ff',
        pcolor3: '#008000',
        bcolor: '#000000',
        bgcolor: '#ffffff',
        gs: 'dashed',
        lp: 'outside',
      },

      checked1: true,
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
    this.formInline.no = 'Reportternary_plot' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/Dynamic/ternary_chart/san1.txt','_blank')
    },

    file2(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/Dynamic/ternary_chart/san2.txt','_blank')
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

    handleClose(done) {
      let _this = this;
      this.$confirm('确定要提交表单吗？')
        .then(_ => {

          if(_this.paraForm.title!==''){
            _this.paras.title_0 = _this.paraForm.title
          }
          if(_this.paraForm.pshape!==''){
            _this.paras.pshape_1 = _this.paraForm.pshape
          }
          if(_this.paraForm.gcolor!==''){
            _this.paras.gcolor_2 = _this.paraForm.gcolor
          }
          if(_this.paraForm.size!==''){
            _this.paras.size_3 = _this.paraForm.size
          }
          if(_this.paraForm.title!==''){
            _this.paras.title_0 = _this.paraForm.title
          }

          if(_this.paraForm.pcolor1!=''&&_this.paraForm.pcolor2!=''&&_this.paraForm.pcolor3!=''){
            _this.paras.pcolor_4 = 'c(' + '"' + _this.paraForm.pcolor1 + '","' + _this.paraForm.pcolor2 + '","' + _this.paraForm.pcolor3 + '")'

          }

          _this.paras.p_5 = _this.checked1

          if(_this.paraForm.title!==''){
            _this.paras.bcolor_6 = _this.paraForm.bcolor
          }
          if(_this.paraForm.title!==''){
            _this.paras.bgcolor_7 = _this.paraForm.bgcolor
          }
          if(_this.paraForm.title!==''){
            _this.paras.gs_8 = _this.paraForm.gs
          }
          if(_this.paraForm.title!==''){
            _this.paras.lp_9 = _this.paraForm.lp
          }
          console.log(_this.paras)

          _this.$axios({
            url: this.Host.BASE_URL + 'Dynamic/ternary_chart/run',
            method: 'post',
            data: _this.paras,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': localStorage.getItem("token")
            },

          }).then((res)=>{
            console.log(res)
            //_this.pic = this.Host.BASE_URL  + res.data
            _this.rd = res.data.split(',')
            _this.csv = this.Host.BASE_URL  + _this.rd[2]
            _this.pics = this.Host.BASE_URL  + _this.rd[1]
            _this.pic = this.Host.BASE_URL  + _this.rd[0]
            if(res.data==='token过期'){
              localStorage.removeItem("Flag")
              localStorage.removeItem("token")
              _this.$router.replace('Login');
            } else if (res.data === 'Error'){
              _this.csv = ''
              _this.pics = ''
              _this.pic = ''
              _this.$message.error('发生错误，检查提交文件及参数，重新提交');
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
        a.download = 'ternary1.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
    },
    downs(){
      console.log('111')
      fetch(this.pics).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'ternary2.svg'  // 下载文件的名字
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

        console.log(_this.para)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('files'))

          _this.$axios({
            url: this.Host.BASE_URL + 'Dynamic/ternary_chart/multiUpload',
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
            }else{
              _this.$axios({
                url: this.Host.BASE_URL + 'Dynamic/ternary_chart/run',
                method: 'post',
                data: _this.para,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': localStorage.getItem("token")
                },

              }).then((res)=>{
                console.log(res)
                //_this.pic = this.Host.BASE_URL  + res.data
                _this.rd = res.data.split(',')
                _this.csv = this.Host.BASE_URL  + _this.rd[2]
                _this.pics = this.Host.BASE_URL  + _this.rd[1]
                _this.pic = this.Host.BASE_URL  + _this.rd[0]
                if(res.data==='token过期'){
                  localStorage.removeItem("Flag")
                  localStorage.removeItem("token")
                  this.$router.replace('Login');
                }else if (res.data === 'Error'){
                  _this.csv = ''
                  _this.pics = ''
                  _this.pic = ''
                  _this.$message.error('发生错误，检查提交文件及参数，重新提交');
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
