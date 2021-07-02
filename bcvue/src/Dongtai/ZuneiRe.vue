<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>动态相关性热图（组内）</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <!--          <el-form-item label="自定义标题">-->
          <!--            <el-input v-model="formInline.title" placeholder=""></el-input>-->
          <!--          </el-form-item>-->
          <el-form-item label="输入文件">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="分析类型">
            <el-select v-model="formInline.type" :placeholder="formInline.type">
              <el-option label="pearson" value="pearson"></el-option>
              <el-option label="kendall" value="kendall"></el-option>
              <el-option label="spearman" value="spearman"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="选择计算方向">
            <el-select v-model="formInline.dir" :placeholder="formInline.dir">
              <el-option label="col" value="col"></el-option>
              <el-option label="row" value="row"></el-option>
            </el-select>
          </el-form-item>
        </el-form>

        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;计算表格内所有元素的两两相关性。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;（1）表格包含分析数据及表头信息，如示例文件中的基因表达量表格，表头为样本名称，列名为基因ID，每行数据为对应基因在各样本中表达量的FPKM值<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（2）输入文件支持txt(制表符分隔)文本文件、csv(逗号分隔)文本文件、以及Excel专用的xlsx格式。
        <br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;（1）分析类型：包含三种，pearson和spearman，1）pearson系数，通常用于计算连续数据的相关性；2）spearman系数，专门用于计算等级数据的相关性；3）kendall系数<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（2）计算向量：默认列向量col。如示例文件中，若选择列向量，则以列为基础，计算每两列数据的相关性，即样本之间的相关性，可用于评估样本分组差异、样本重复性等；若选择行向量，则以行为基础，计算每两行数据的相关性，即基因之间的相关性，可用于评估基因的关联特征等。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（3）颜色，可根据数据量大小、相关性系数波动范围等选择2种。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（4）标签文字大小<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（5）单元格内是否显示数字：默认为no，不显示<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（6）表格内的字体颜色：默认为灰色<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（7）表格内字体的大小<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（8）是否显示表格边界：默认为no,不显示<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（9）图片是否显示行名<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（10）图片是否显示列名<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;提供SVG格式的图片下载<br>
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
            <el-form-item label="颜色下限" :label-width="formLabelWidth">
              <el-input v-model="paraForm.ucolor1" :placeholder="paraForm.ucolor1">
              </el-input>
              <el-color-picker v-model="paraForm.ucolor1" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="颜色上限" :label-width="formLabelWidth">
              <el-input v-model="paraForm.ucolor2" :placeholder="paraForm.ucolor2">
              </el-input>
              <el-color-picker v-model="paraForm.ucolor2" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="标签文字的大小" :label-width="formLabelWidth">
              <el-input v-model="paraForm.fontsize" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="单元格内数字是否显示" :label-width="formLabelWidth">
              <el-select v-model="paraForm.nshow" :placeholder="paraForm.nshow">
                <el-option label="显示" value="TRUE"></el-option>
                <el-option label="不显示" value="FALSE"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="单元格内数字颜色" :label-width="formLabelWidth">
              <el-input v-model="paraForm.fcolor" :placeholder="paraForm.fcolor">
              </el-input>
              <el-color-picker v-model="paraForm.fcolor" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="单元格内数字大小" :label-width="formLabelWidth">
              <el-input v-model="paraForm.fsize" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="是否画出格子的边界" :label-width="formLabelWidth">
              <el-select v-model="paraForm.gshow" :placeholder="paraForm.gshow">
                <el-option label="显示" value="TRUE"></el-option>
                <el-option label="不显示" value="FALSE"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="是否显示行名和列名" :label-width="formLabelWidth">
              <el-select v-model="paraForm.rc" :placeholder="paraForm.rc">
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

export default {
  name: 'ZuneiRe',
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formData1: new FormData(),
      formInline: {
        file: '',
        file1: '',
        type: 'spearman',
        dir: 'col',
        col: '1-2',
        row: '2',
        scale: 'row',
        cols: 'TRUE',
        rows: 'TRUE',
        number: 'TRUE',
        no: '',
        border: '#C4C4C4',
        colsname: 'TRUE',
        rowsname: 'TRUE',
        size: 10,
        color: '#007D32,#000000,#AA0000',
        width: 80,
        height: 30,
      },
      para:{
        "historyid": '',
        "type_0": '',
        "dir_1": '',
      },

      paras: {
        "historyid": '',
        "type_0": '',
        "dir_1": '',
        "ucolor_2": '',
        "fontsize_3": '',
        "nshow_4": '',
        "fcolor_5": '',
        "fsize_6": '',
        "gshow_7": '',
        "rc_8": '',
      },

      paraForm: {
        ucolor1: '#00ff00',
        ucolor2: '#ffffff',
        fontsize: '10',
        fcolor: '#808080',
        nshow: 'FALSE',
        fsize: '8',
        gshow: 'TRUE',
        rc: 'TRUE',
      },


      drawer: false,
      dialog: false,
      loading: false,
      formLabelWidth: '80px',
      timer: null,
      showModal: false,

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
    this.formInline.no = 'Reporticaw' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/Dynamic/plot_heatmap_cor/heatmap.txt','_blank')
    },

    handleClose(done) {
      let _this = this;
      this.$confirm('确定要提交表单吗？')
        .then(_ => {

            _this.paras.type_0 = _this.para.type_0

            _this.paras.dir_1 = _this.para.dir_1


          if(_this.paraForm.ucolor1!==''&&_this.paraForm.ucolor2!==''){
            _this.paras.ucolor_2 = 'c("' + _this.paraForm.ucolor1 + '","' + _this.paraForm.ucolor2 + '")'
          }

          if(_this.paraForm.fontsize!==''){
            _this.paras.fontsize_3 = _this.paraForm.fontsize
          }

          if(_this.paraForm.nshow!==''){
            _this.paras.nshow_4 = _this.paraForm.nshow
          }

          if(_this.paraForm.fcolor!==''){
            _this.paras.fcolor_5 = _this.paraForm.fcolor
          }

          if(_this.paraForm.fsize!==''){
            _this.paras.fsize_6 = _this.paraForm.fsize
          }

          if(_this.paraForm.gshow!==''){
            _this.paras.gshow_7 = _this.paraForm.gshow
          }

          if(_this.paraForm.rc!==''){
            _this.paras.rc_8 = _this.paraForm.rc
          }


          console.log(_this.paras)

          _this.$axios({
            url: this.Host.BASE_URL + 'Dynamic/plot_heatmap_cor/run',
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

    download() {
      // let eleLink = document.createElement('a')
      // eleLink.download = this.pic
      // eleLink.href = this.pic
      // eleLink.click()
      // eleLink.remove()
      this.axios({
        method:'get',
        url: this.pic,
        responseType:'blob',
      }).then(res=>{
        const href = URL.createObjectURL(this.pic)
        let eleLink = document.createElement('a')
        eleLink.setAttribute('href',href);
        eleLink.setAttribute('download',this.formInline.no)
        eleLink.click()
        URL.revokeObjectURL(href)
      })
    },

    downloadByBlob(url,name) {
      let image = new Image()
      image.setAttribute('crossOrigin', 'anonymous')
      image.src = url
      image.onload = () => {
        let canvas = document.createElement('canvas')
        canvas.width = image.width
        canvas.height = image.height
        let ctx = canvas.getContext('2d')
        ctx.drawImage(image, 0, 0, image.width, image.height)
        canvas.toBlob((blob) => {
          let urls = URL.createObjectURL(blob)
          console.log(urls)
          //download(urls,name)
          // let eleLink = document.createElement('a')
          let a = document.createElement('a')
          a.download = url
          a.href = url
          console.log(a.download)
          console.log(a.href)
          a.click()
          a.remove()
          // eleLink.download = name
          // eleLink.href = urls
          // eleLink.click()
          // eleLink.remove()
          // 用完释放URL对象
          URL.revokeObjectURL(urls)
        })
      }
    },

    downCom() {
      let that = this;
      let hreLocal="";
      hreLocal = that.pic;
      that.downloadByBlob(hreLocal,that.formInline.no)
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
        //console.log(_this.formInline)
        //参数设置
        // if(_this.formInline.col!==''){
        //   _this.COL=_this.formInline.col.split(',')
        //   //console.log(_this.COL)
        //   let j = 0
        //   for(let i = 0; i < _this.COL.length; i++){
        //     _this.C = null
        //     if(_this.COL[i].indexOf('-') >= 0){
        //       _this.C = _this.COL[i].split('-')
        //       for(let k = Number(_this.C[0]); k <= Number(_this.C[1]); k++){
        //         _this.COLS[j] = k
        //         j++
        //       }
        //     }else{
        //       _this.COLS[j] = Number(_this.COL[i])
        //       j++
        //     }
        //   }
        //   //console.log(_this.COLS)
        //   _this.para.col_0 ='c('+String(_this.COLS)+')'
        // }

        if(_this.formInline.type!==''){
          _this.para.type_0 = _this.formInline.type
        }

        if(_this.formInline.dir!==''){
          _this.para.dir_1 = _this.formInline.dir
        }
        // if(_this.formInline.scale!==''){
        //   _this.para.scale_2 = _this.formInline.scale
        // }
        // if(_this.formInline.rows!==''){
        //   _this.para.rows_3 = _this.formInline.rows
        // }
        // if(_this.formInline.cols!==''){
        //   _this.para.cols_4 = _this.formInline.cols
        // }
        //
        // if(_this.formInline.color!==''){
        //   //_this.para.color_5 = String(_this.formInline.color.split(','))
        //   _this.C1 =_this.formInline.color.split(',')
        //   //console.log(_this.C1)
        //   _this.para.color_5 = 'c('
        //   for (let i = 0; i < _this.C1.length; i++){
        //     if(i===0){
        //       _this.para.color_5 = _this.para.color_5 + '"'+ _this.C1[i] + '"'
        //     }else{
        //       _this.para.color_5 = _this.para.color_5 + ',' +  '"'+ _this.C1[i] + '"'
        //     }
        //
        //   }
        //   _this.para.color_5 = _this.para.color_5 + ')'
        //   //console.log(_this.para.color_5)
        // }else {
        //   _this.para.color_5 = 'NULL'
        // }
        //
        // if(_this.formInline.size!==''){
        //   _this.para.size_6 = _this.formInline.size
        // }
        // if(_this.formInline.width!==''){
        //   _this.para.width_7 = _this.formInline.width
        // }
        // if(_this.formInline.height!==''){
        //   _this.para.height_8 = _this.formInline.height
        // }
        // if(_this.formInline.number!==''){
        //   _this.para.number_9 = _this.formInline.number
        // }
        // if(_this.formInline.border!==''){
        //   _this.para.border_10 = _this.formInline.border
        // }else {
        //   _this.para.border_10 = 'NA'
        // }
        // if(_this.formInline.colsname!==''){
        //   _this.para.colsname_11 = _this.formInline.colsname
        // }
        // if(_this.formInline.rowsname!==''){
        //   _this.para.rowsname_12 = _this.formInline.rowsname
        // }

        console.log(_this.para)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('files'))

          _this.$axios({
            url: this.Host.BASE_URL + 'Dynamic/plot_heatmap_cor/multiUpload',
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
                url: this.Host.BASE_URL + 'Dynamic/plot_heatmap_cor/run',
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
