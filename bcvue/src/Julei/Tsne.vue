<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>TSNE</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="源文件">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
            <el-form-item label="标题">
              <el-input v-model="formInline.title" :placeholder="formInline.title"></el-input>
            </el-form-item>
          <el-form-item label="X轴标题">
            <el-input v-model="formInline.Xtitle" :placeholder="formInline.Xtitle"></el-input>
          </el-form-item>
          <el-form-item label="Y轴标题">
            <el-input v-model="formInline.Ytitle" :placeholder="formInline.Ytitle"></el-input>
          </el-form-item>
            <el-form-item label="归一化">
              <el-select v-model="formInline.norm" :placeholder="formInline.norm">
                <el-option label="是" value="TRUE"></el-option>
                <el-option label="否" value="False"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="是否对行PCA线性降维聚类">
              <el-select v-model="formInline.pca" :placeholder="formInline.pca">
                <el-option label="是" value="TRUE"></el-option>
                <el-option label="否" value="FALSE"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="partial_PCA线性降维">
              <el-select v-model="formInline.ppca" :placeholder="formInline.ppca">
                <el-option label="是" value="TRUE"></el-option>
                <el-option label="否" value="False"></el-option>
              </el-select>
            </el-form-item>
          <el-form-item label="点大小">
            <el-select v-model="formInline.size" :placeholder="formInline.size">
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
              <el-option label="1.1" value="1.1"></el-option>
              <el-option label="1.2" value="1.2"></el-option>
              <el-option label="1.3" value="1.3"></el-option>
              <el-option label="1.4" value="1.4"></el-option>
              <el-option label="1.5" value="1.5"></el-option>
              <el-option label="1.6" value="1.6"></el-option>
              <el-option label="1.7" value="1.7"></el-option>
              <el-option label="1.8" value="1.8"></el-option>
              <el-option label="1.9" value="1.9"></el-option>
              <el-option label="2.0" value="2"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="透明度">
            <el-select v-model="formInline.alpha" :placeholder="formInline.alpha">
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
          <el-form-item label="图例">
            <el-select v-model="formInline.lengend" :placeholder="formInline.lengend">
              <el-option label="是" value="TRUE"></el-option>
              <el-option label="否" value="False"></el-option>
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
        &nbsp;&nbsp;&nbsp;&nbsp;将包含多个变量的复杂数据，通过非线性降维的方式投影至二维平面，将相似度较高的个体聚类为同一亚群。注：该工具暂不支持单细胞数据。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;丰度矩阵表格：文件为二维矩阵文件，第一行一般为基因ID或OTU，第一列一般为样本名称，最后一列为分组信息<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（1）线性降维：线性降维是对数据的预处理，利用主成分对数据进行tSNE降维，可以有效提高tSNE算法的运算速度。使用partial_PCA算法后运算速度最快，但降维后的精确度最低，建议仅大型数据时使用。PCA算法和partial_PCA算法不可同时使用。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（2）归一化：我们利用z-score进行数据的归一化，即将每个基因的表达量减去这个基因在所有样本中表达量的均值，然后除以其标准差。对数据进行归一化，可消除表达量异常高的基因的影响，减少数据间的“贫富差距”。我们推荐对数据进行归一化。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（3）点大小：默认为2<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（4）点透明度：默认为0.5<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（5）主标题：自定义<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（6）x轴标签：自定义<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（7）y轴标签：自定义<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（8）图例：显示/不显示<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;1.	样本在tSNE二维图中的坐标位置<br>
        &nbsp;&nbsp;&nbsp;&nbsp;2.	样本降维得到的tSNE图<br>
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
  name: 'tSNE',
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formData1: new FormData(),
      formInline: {
        file: '',
        file1: '',
        title: 'tsne',
        size: '2',
        pca: 'TRUE',
        ppca: 'FALSE',
        norm: 'TRUE',
        alpha: '0.5',
        lengend: 'TRUE',
        Xtitle: 'X',
        Ytitle: 'Y',
        no: '',
      },
      para: {
        "historyid": '',
        "psize_0": '',
        "pca_1": '',
        "ppca_2": '',
        "norm_3": '',
        "alpha_4": '',
        "lcolor_5": '',
        "title_6": '',
        "xtitle_7": '',
        "ytitle_8": '',
        "lengend_9": '',
      },

      choose: true,
      activeTab: 'first',
      flag: 1,
      chartInstance:null,
      fileData:null, //读取的数据
      fileData1:null, //读取基因组的数据
      pic: '',
      csv: '',
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'tsne' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/ClusteringAnalysis/tsne_chart/tsne.txt','_blank')
    },

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'tsne.svg'  // 下载文件的名字
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

        if(_this.formInline.size!==''){
          _this.para.psize_0 = _this.formInline.size
        }
        if(_this.formInline.pca!==''){
          _this.para.pca_1 = _this.formInline.pca
        }
        if(_this.formInline.ppca!==''){
          _this.para.ppca_2 = _this.formInline.ppca
        }
        if(_this.formInline.norm!==''){
          _this.para.norm_3 = _this.formInline.norm
        }
        if(_this.formInline.alpha!==''){
          _this.para.alpha_4 = _this.formInline.alpha
        }

        _this.para.lcolor_5 = 'black'

        if(_this.formInline.lengend!==''){
          _this.para.lengend_9 = _this.formInline.lengend
        }
        if(_this.formInline.title!==''){
          _this.para.title_6 = _this.formInline.title
        }
        if(_this.formInline.Xtitle!==''){
          _this.para.xtitle_7 = _this.formInline.Xtitle
        }
        if(_this.formInline.Ytitle!==''){
          _this.para.ytitle_8 = _this.formInline.Ytitle
        }

        console.log(_this.para)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('file'))

          _this.$axios({
            url: this.Host.BASE_URL + 'ClusteringAnalysis/tsne_chart/upload',
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
                url: this.Host.BASE_URL + 'ClusteringAnalysis/tsne_chart/run',
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
                  _this.csv = ''
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
