<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>三元图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <!--          <el-form-item label="自定义标题">-->
          <!--            <el-input v-model="formInline.title" placeholder=""></el-input>-->
          <!--          </el-form-item>-->
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
          <el-form-item label="图片标题">
            <el-input v-model="formInline.title" :placeholder="formInline.title"></el-input>
          </el-form-item>
          <el-form-item label="点大小">
            <el-input v-model="formInline.Xtitle" :placeholder="formInline.Xtitle"></el-input>
          </el-form-item>
          <el-form-item label="是否画图例">
            <el-select v-model="formInline.Ytitle" :placeholder="formInline.Ytitle">
              <el-option label="是" value="TRUE"></el-option>
              <el-option label="否" value="FALSE"></el-option>
            </el-select>
          </el-form-item>
        </el-form>

        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;三元图，又称三元相图（Ternary plot）有三个坐标轴，与直角坐标系不同，它的三个坐标轴“首尾相接”成夹角为60度的等边三角形。“元”即成分，或部分，三元图主要用来展示不同样本的三种成分的比例，微生物多样性分析当中，三元相图可以展示物种在不同分组当中的相对丰度的大小。三元相图当中，不同的点代表不同的物种，点的大小代表了该物种在不同分组当中平均丰度，灰色点代表未富集，各颜色的点分别代表被富集到的分组。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;（1）丰度表格为必须输入的文件，可以是物种或者otu丰度表格，根据标注内容进行作图。当输入富集标注信息（Enrich）时，将生成富集三元图；输入关注物种（Focus）信息时，则生成关注物种分布三元图。富集信息与关注物种信息至少输入一种。 （1.富集标注（Enrich）：为富集物种标注，标注内容要与分组表格对应，填写该物种在分组中的富集情况，未被富集填写none。2.关注物种（Focus）：标注关注的物种，关注物种输入名字，不关注标注other。）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（2）分组表格为必须输入的文件，三元图分组数为3，在分组表格中要写明三个分组的命名以及该分组中的样本，注意此文件一定要有表头，可以参考示例文件。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（3）丰度数据在所有分组内的总和必须大于0。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（4）所有表格支持txt(制表符分隔)文本文件。<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（1）点大小转换：默认为空<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（2）标题：自定义<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（3）图例：显示/不显示<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;（1）Ternary_data.txt （各分组的信息总表：表头从左到右显示物种名称、各组物种平均丰度、物种在三元图上的点大小、富集信息、物种在各组中丰度占比）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（2）Ternary_plot.enrich.svg （富集三元图：图中点的大小表示该物种丰度大小，点的坐标位置由三个分组中的占比构成，点的颜色表示所富集到的分组，灰色表示未被富集。）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;（3）Ternary_plot.focus.svg （分布三元图：图中点的大小表示该物种丰度大小，点的坐标位置由三个分组中的占比构成。）<br>
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
      <div id="echart1" v-show="pics!==''">
        <img :src="pics" />
      </div>
      <div class="output" v-show="pic!==''">
        <span>图表导出：</span>
        <el-link class="outputbutton" type="info" v-on:click="downs">SVG</el-link>
        <el-button type="info" icon="el-icon-download" size="mini" v-on:click="downs" circle></el-button>
      </div>
      <div class="output" v-show="pic!==''">
        <span>文件导出：</span>
        <el-button type="info" icon="el-icon-download" size="mini" :href="csv" @click.prevent="downloadItem(csv, 'sss.txt')" ></el-button>
      </div>
    </div>
  </div>

</template>

<script>

//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'Sanyuan',
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formData1: new FormData(),
      formInline: {
        file: '',
        file1: '',
        no: '',
        title: 'Ternary plot',
        Xtitle: 0.4,
        Ytitle: 'FALSE',
      },
      para: {
        "historyid": '',
        "title_0": '',
        "size_1": '',
        "p_2": '',
      },
      chartInstance:null,
      fileData:null, //读取的数据
      fileData1:null, //读取基因组的数据
      rd:[],
      pic: '',
      pics: '',
      csv: '',
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Ternary_plot' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/ternaryplot_plot/ternary_input.txt','_blank')
    },

    file2(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/ternaryplot_plot/ternary_group.txt','_blank')
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
        if(_this.formInline.title!==''){
          _this.para.title_0 =_this.formInline.title
        }
        if(_this.formInline.Xtitle!==''){
          _this.para.size_1 =_this.formInline.Xtitle
        }if(_this.formInline.Ytitle!==''){
          _this.para.p_2 =_this.formInline.Ytitle
        }
        console.log(_this.para)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('files'))

          _this.$axios({
            url: this.Host.BASE_URL + 'BaseFunction/ternaryplot_plot/multiUpload',
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
                url: this.Host.BASE_URL + 'BaseFunction/ternaryplot_plot/run',
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
                  _this.pic = ''
                  _this.csv = ''
                  _this.pics = ''
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
