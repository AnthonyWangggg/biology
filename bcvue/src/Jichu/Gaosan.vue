<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>高级散点图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="自定义标题">
            <el-input v-model="formInline.title" :placeholder="formInline.title"></el-input>
          </el-form-item>
          <el-form-item label="源文件">
            <el-input  v-model="formInline.file" :placeholder="formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item>
            <el-form-item label="用作x轴的列">
              <el-input v-model="formInline.xval" :placeholder="formInline.xval"></el-input>
            </el-form-item>
            <el-form-item label="用作y轴的列">
              <el-input v-model="formInline.yval" :placeholder="formInline.yval"></el-input>
            </el-form-item>
          </el-form-item>
          <el-form-item label="点大小">
            <el-input v-model="formInline.size" :placeholder="formInline.size"></el-input>
          </el-form-item>
          <el-form-item label="点颜色">
            <el-input v-model="formInline.color" :placeholder="formInline.color">
            </el-input>
            <el-color-picker v-model="formInline.color" size="small"></el-color-picker>
          </el-form-item>
          <hr>&#8194;&#8194;选填参数<hr>
          <div id="choose">
            <el-form-item label="水平辅助线，输入y轴截距">
              <el-col :span="5">
                <el-input v-model="formInline.y" :placeholder="formInline.y" style="width: 100%;"></el-input>
              </el-col>
            </el-form-item>
            <el-form-item label="水平辅助线样式">
              <el-select v-model="formInline.hty" :placeholder="formInline.hty">
                <el-option label="实线" value="1"></el-option>
                <el-option label="虚线" value="2"></el-option>
                <el-option label="点线" value="3"></el-option>
                <el-option label="点线线段" value="4"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="水平辅助线颜色">
              <el-col :span="5">
                <el-input v-model="formInline.hcolor" :placeholder="formInline.hcolor" style="width: 100%;">
                </el-input>
                <el-color-picker v-model="formInline.hcolor" size="small" style="width: 100%;"></el-color-picker>
              </el-col>
            </el-form-item>
            <el-form-item label="竖直辅助线，输入x轴截距">
              <el-col :span="5">
                <el-input v-model="formInline.x" :placeholder="formInline.x" style="width: 100%;"></el-input>
              </el-col>
            </el-form-item>
            <el-form-item label="竖直辅助线样式">
              <el-select v-model="formInline.vty" :placeholder="formInline.vty">
                <el-option label="实线" value="1"></el-option>
                <el-option label="虚线" value="2"></el-option>
                <el-option label="点线" value="3"></el-option>
                <el-option label="点线线段" value="4"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="竖直辅助线颜色">
              <el-col :span="5">
                <el-input v-model="formInline.vcolor" :placeholder="formInline.vcolor" style="width: 100%;">
                </el-input>
                <el-color-picker v-model="formInline.vcolor" size="small" style="width: 100%;"></el-color-picker>
              </el-col>
            </el-form-item>
            <el-form-item label="普通辅助线，输入斜率k和截距b">
              <el-col :span="5">
                <el-input v-model="formInline.k" :placeholder="formInline.k" style="width: 100%;"></el-input>
              </el-col>
              <el-col class="line" :span="1">&#8194;-&#8194; </el-col>
              <el-col :span="5">
                <el-input v-model="formInline.b" :placeholder="formInline.b" style="width: 100%;"></el-input>
              </el-col>
            </el-form-item>
            <el-form-item label="普通辅助线样式">
              <el-select v-model="formInline.dty" :placeholder="formInline.dty">
                <el-option label="实线" value="1"></el-option>
                <el-option label="虚线" value="2"></el-option>
                <el-option label="点线" value="3"></el-option>
                <el-option label="点线线段" value="4"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="普通辅助线颜色">
              <el-col :span="5">
                <el-input v-model="formInline.dcolor" :placeholder="formInline.dcolor" style="width: 100%;">
                </el-input>
                <el-color-picker v-model="formInline.dcolor" size="small" style="width: 100%;"></el-color-picker>
              </el-col>
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
        &nbsp;&nbsp;&nbsp;&nbsp;用一个带有表头的以tab分隔的表格数据绘制一个高级散点图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;矩阵表格文件:格式说明：支持txt(制表符分隔)文本文件格式。<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;①结果图片标题：最后生成的图片的标题，注意只能输入英文。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;②选定第几列作为x,y轴<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③点的大小<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;④点的颜色：最后的结果图中点的颜色。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑤添加辅助线(可选),现有三种类型的辅助线可以添加，<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a.平行x轴的线，要输入y截距，如输入2，即表示y=2这条直线<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b.平行y轴的线，要输入x截距，如输入2，即表示x=2这条直线<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c.一般的线，要输入y截距，和斜率,如输入1,2，即表示y=2x+1这条直线<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑥水平辅助线的颜色<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑦水平辅助线的样式：实线，虚线，点线，点线线段<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;提供SVG格式的图片下载<br>
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
  name: 'Gaosan',
  data() {
    return{
      formData: new FormData(),
      formInline: {
        file: '',
        title: 'seniorscatter',
        no: '',
        xval: 1,
        yval: 2,
        size: 1,
        color: '#ff0000',
        hty: '',
        hcolor: '',
        vty: '',
        vcolor: '',
        dty: '',
        dcolor: '',
        x: '',
        y: '',
        k: '',
        b: '',
      },
      para: {
        "historyid": '',
        "xaxis_0": '',
        "yaxis_1": '',
        "pcolor_2": '',
        "psize_3": '',
        "title_4": '',
        "hval_5": '',
        "hty_6": '',
        "hcolor_7": '',
        "vval_8": '',
        "vty_9": '',
        "vcolor_10": '',
        "dbval_11": '',
        "dkval_12": '',
        "dty_13": '',
        "dcolor_14": '',
      },
      fileData:null, //读取的数据
      pic:'',
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Seniorscatter' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/scatter_plot/scatter_exa.txt','_blank')
    },

    down(){
      console.log('111')
      fetch(this.pic).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
        const a = document.createElement('a')
        a.href = URL.createObjectURL(blob)
        console.log(a.href)
        a.download = 'Seniorscatter.svg'  // 下载文件的名字
        document.body.appendChild(a)
        a.click()
      })
    },
    chartCommit(){
      let _this = this;

      //参数设置
      if(_this.formInline.xval!==''){
        _this.para.xaxis_0 =_this.formInline.xval
      }

      if(_this.formInline.yval!==''){
        _this.para.yaxis_1 = _this.formInline.yval
      }

      if(_this.formInline.color!==''){
        _this.para.pcolor_2= _this.formInline.color
      }

      if(_this.formInline.size!==''){
        _this.para.psize_3= _this.formInline.size
      }

      if(_this.formInline.title!==''){
        _this.para.title_4= _this.formInline.title
      }

      if(_this.formInline.y!==''){
        _this.para.hval_5= _this.formInline.y
      }

      if(_this.formInline.hty!==''){
        _this.para.hty_6= _this.formInline.hty
      }

      if(_this.formInline.hcolor!==''){
        _this.para.hcolor_7= _this.formInline.hcolor
      }

      if(_this.formInline.x!==''){
        _this.para.vval_8= _this.formInline.x
      }

      if(_this.formInline.vty!==''){
        _this.para.vty_9= _this.formInline.vty
      }

      if(_this.formInline.vcolor!==''){
        _this.para.vcolor_10= _this.formInline.vcolor
      }

      if(_this.formInline.b!==''){
        _this.para.dbval_11= _this.formInline.b
      }

      if(_this.formInline.k!==''){
        _this.para.dkval_12= _this.formInline.k
      }

      if(_this.formInline.dty!==''){
        _this.para.dty_13= _this.formInline.dty
      }

      if(_this.formInline.dcolor!==''){
        _this.para.dcolor_14= _this.formInline.dcolor
      }

      if(_this.fileData == null){
        alert("文件不能为空");
      }else {
        console.log(_this.formData.get('files'))

        _this.$axios({
          url: this.Host.BASE_URL  +'BaseFunction/scatter_plot/multiUpload',
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
            this.$router.replace('Login');
          }else if (res.data === 'Error'){
            this.$message.error('发生错误，检查提交文件及参数，重新提交');
          }else{
            _this.$axios({
              url: this.Host.BASE_URL  + 'BaseFunction/scatter_plot/run',
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
      let _this=this;
      _this.clear_data();
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
img{
  width:auto;
  height:auto;
  max-width: 100%;
  max-height: 100%;
}
#choose{
  width: 100%;
  height: auto;
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
