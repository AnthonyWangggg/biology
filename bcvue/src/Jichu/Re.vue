<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>热图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
<!--          <el-form-item label="自定义标题">-->
<!--            <el-input v-model="formInline.title" placeholder=""></el-input>-->
<!--          </el-form-item>-->
          <el-form-item label="源文件">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item>
            <el-button type="text" @click="choosepara">选填参数</el-button>
          </el-form-item>
          <hr>
          <div id="choose" v-show="choose">
            <el-form-item label="选择用于作图的列">
              <el-input v-model="formInline.col" placeholder=""></el-input>
            </el-form-item>
            <el-tabs type="border-card" @tab-click="choosetype" v-model="activeTab">
              <el-tab-pane label="输入数字" name="first"></el-tab-pane>
<!--              <el-tab-pane label="输入基因列表文件" name="second"></el-tab-pane>-->
            </el-tabs>
            <el-form-item label="作图行数范围" v-show="flag===1">
              <el-input v-model="formInline.row" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="基因列表文件" v-show="flag===2">
              <el-input  v-model="formInline.file1" :placeholder="this.formInline.file1" :readonly="true"></el-input>
              <el-button type="button" id="fileImports" v-on:click="clickLoad1">选择上传的数据文件</el-button>
              <input type="file" id="filess" ref="refFiles" style="display: none"  v-on:change="fileLoad1">
            </el-form-item>

            <el-form-item label="归一化">
              <el-select v-model="formInline.scale" placeholder="row">
                <el-option label="row" value="row"></el-option>
                <el-option label="column" value="column"></el-option>
                <el-option label="none" value="none"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="是否对行聚类">
              <el-select v-model="formInline.rows" placeholder="yes">
                <el-option label="yes" value="TRUE"></el-option>
                <el-option label="no" value="False"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="是否对列聚类">
              <el-select v-model="formInline.cols" placeholder="yes">
                <el-option label="yes" value="TRUE"></el-option>
                <el-option label="no" value="False"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="颜色(从左到右，代表数值越来越大)">
              <el-input v-model="formInline.color" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="字体大小">
              <el-input v-model="formInline.size" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="格子的长度 × 高度">
              <el-col :span="5">
                <el-input v-model="formInline.width" placeholder="" style="width: 100%;"></el-input>
              </el-col>
              <el-col class="line" :span="1">&#8194;×</el-col>
              <el-col :span="5">
                <el-input v-model="formInline.height" placeholder="" style="width: 100%;"></el-input>
              </el-col>
            </el-form-item>
            <el-form-item label="在格子上显示数字">
              <el-select v-model="formInline.number" placeholder="yes">
                <el-option label="yes" value="TRUE"></el-option>
                <el-option label="no" value="False"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="单元格边框颜色">
              <el-input v-model="formInline.border" :placeholder="formInline.border">
              </el-input>
              <el-color-picker v-model="formInline.border" size="small"></el-color-picker>
            </el-form-item>
            <el-form-item label="结果是否显示行名">
              <el-select v-model="formInline.colsname" placeholder="yes">
                <el-option label="yes" value="TRUE"></el-option>
                <el-option label="no" value="False"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="结果是否显示列名">
              <el-select v-model="formInline.rowsname" placeholder="yes">
                <el-option label="yes" value="TRUE"></el-option>
                <el-option label="no" value="False"></el-option>
              </el-select>
            </el-form-item>
          </div>
        </el-form>

        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <!--<el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <input type="file" id="files" ref="refFile" style="display: none" v-on:change="fileLoad">-->
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;用一个带有表头的以tab分隔的表格数据绘制一个热图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;① 矩阵文件:文件为二维矩阵文件，第一行一般为样本，第一列为基因名。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;② 列的参数:即选择用哪几列画图。(如1-3,5,7)<br>
        &nbsp;&nbsp;&nbsp;&nbsp;③ 行的参数:可以数字输入前多少行作为绘图数据或输入基因名文件。<br>
        <br>
            上传文件格式说明：支持txt(制表符分隔)文本文件。<br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;可选输入<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;① 归一化（z-score）处理，选择列，或者行，或者不处理，一般选择行。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;② 颜色选择，一般选择green,black,red或者navy,white,firebrick3。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③ 单元格内的字体大小选择。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;④ 矩阵格子的长度和宽度，默认为自适应，也可以设置为25X12。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑤ 是否在格子上显示数字，默认不显示。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑥ 格子边框的颜色，默认不显示，也可自定义颜色。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑦ 生成的图是否显示行名和列名<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑧ 单元格数字的颜色，默认为和灰色<br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;程序将按要求输出热图，提供SVG格式的图片下载<br>
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
  name: 'Re',
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formData1: new FormData(),
      formInline: {
        file: '',
        file1: '',
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
      para: {
        "historyid": '',
        "col_0": '',
        "row_1": '',
        "scale_2": '',
        "rows_3": '',
        "cols_4": '',
        "color_5": '',
        "size_6": '',
        "width_7": '',
        "height_8": '',
        "number_9": '',
        "border_10": '',
        "colsname_11": '',
        "rowsname_12": '',
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
    this.formInline.no = 'Heat' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/heatmap/heatmap.txt','_blank')
    },

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'Heatmap.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
    },

    download() {
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
          let a = document.createElement('a')
          a.download = url
          a.href = url
          console.log(a.download)
          console.log(a.href)
          a.click()
          a.remove()
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
        if(_this.formInline.col!==''){
          _this.COL=_this.formInline.col.split(',')
          //console.log(_this.COL)
          let j = 0
          for(let i = 0; i < _this.COL.length; i++){
            _this.C = null
            if(_this.COL[i].indexOf('-') >= 0){
              _this.C = _this.COL[i].split('-')
              for(let k = Number(_this.C[0]); k <= Number(_this.C[1]); k++){
                _this.COLS[j] = k
                j++
              }
            }else{
              _this.COLS[j] = Number(_this.COL[i])
              j++
            }
          }
          //console.log(_this.COLS)
          _this.para.col_0 ='c('+String(_this.COLS)+')'
        }

        if(_this.formInline.row!==''){
          _this.para.row_1 = _this.formInline.row
        }
        if(_this.formInline.scale!==''){
          _this.para.scale_2 = _this.formInline.scale
        }
        if(_this.formInline.rows!==''){
          _this.para.rows_3 = _this.formInline.rows
        }
        if(_this.formInline.cols!==''){
          _this.para.cols_4 = _this.formInline.cols
        }

        if(_this.formInline.color!==''){
          //_this.para.color_5 = String(_this.formInline.color.split(','))
          _this.C1 =_this.formInline.color.split(',')
          //console.log(_this.C1)
          _this.para.color_5 = 'c('
          for (let i = 0; i < _this.C1.length; i++){
            if(i===0){
              _this.para.color_5 = _this.para.color_5 + '"'+ _this.C1[i] + '"'
            }else{
              _this.para.color_5 = _this.para.color_5 + ',' +  '"'+ _this.C1[i] + '"'
            }

          }
          _this.para.color_5 = _this.para.color_5 + ')'
          //console.log(_this.para.color_5)
        }else {
          _this.para.color_5 = 'NULL'
        }

        if(_this.formInline.size!==''){
          _this.para.size_6 = _this.formInline.size
        }
        if(_this.formInline.width!==''){
          _this.para.width_7 = _this.formInline.width
        }
        if(_this.formInline.height!==''){
          _this.para.height_8 = _this.formInline.height
        }
        if(_this.formInline.number!==''){
          _this.para.number_9 = _this.formInline.number
        }
        if(_this.formInline.border!==''){
          _this.para.border_10 = _this.formInline.border
        }else {
          _this.para.border_10 = 'NA'
        }
        if(_this.formInline.colsname!==''){
          _this.para.colsname_11 = _this.formInline.colsname
        }
        if(_this.formInline.rowsname!==''){
          _this.para.rowsname_12 = _this.formInline.rowsname
        }

        console.log(_this.para)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('file'))

          _this.$axios({
            url: this.Host.BASE_URL + 'BaseFunction/heatmap/upload',
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
            }else{
              _this.$axios({
                url: this.Host.BASE_URL + 'BaseFunction/heatmap/run',
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
      _this.formData.append('file',selectedFile);
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
      _this.formData1.append('files',selectedFiles);
      console.log(this.$refs.refFile.files)
      console.log(this.$refs.refFiles.files)
      _this.formInline.file1 = this.$refs.refFiles.files[0].name;
      let readers = new FileReader();
      readers.readAsText(selectedFiles);
      readers.onload = function () {
        _this.fileData1=this.result;
        console.log(_this.fileData1)
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
