<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>气泡图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="自定义标题">
            <el-input v-model="formInline.title" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="分组文件1">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="分组文件2">
            <el-input  v-model="formInline.file1" :placeholder="this.formInline.file1" :readonly="true"></el-input>
            <el-button type="button" id="fileImports" v-on:click="clickLoad1">选择上传的数据文件</el-button>
            <input type="file" id="filess" ref="refFiles" style="display: none"  v-on:change="fileLoad1">
          </el-form-item>
          <el-form-item label="分组文件3">
            <el-input  v-model="formInline.file2" :placeholder="this.formInline.file2" :readonly="true"></el-input>
            <el-button type="button" id="fileImportss" v-on:click="clickLoad2">选择上传的数据文件</el-button>
            <input type="file" id="filesss" ref="refFiless" style="display: none"  v-on:change="fileLoad2">
          </el-form-item>
          <el-form-item>
          </el-form-item>
          <el-form-item label="X轴标题">
            <el-input v-model="formInline.Xtitle" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="Y轴标题">
            <el-input v-model="formInline.Ytitle" placeholder=""></el-input>
          </el-form-item>

          <el-form  :model="colorInline" class="demo-form-inline">
            <el-form-item  v-for="(color, index) in colorInline.color1"
                           :label="'气泡' + index + '颜色'"
                           :key="color.key" :span="18">
              <td>
                <el-input v-model="color.color" :placeholder="color.color"></el-input>
              </td>
              <td>
                <el-color-picker v-model="color.color" size="small"></el-color-picker>
                <el-button @click.prevent="removeColor(color)">删除</el-button>
              </td>
            </el-form-item>
            <el-form-item>
              <el-button @click="addColor">新增颜色</el-button>
            </el-form-item>
          </el-form>

          <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        </el-form>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;用一个带有表头的以table分隔的表格数据绘制一个气泡图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;数据的第一列将作为x轴，第二列将作为y轴,第三列为气泡大小。数据与数据间请用tab符隔开<br>
        &nbsp;&nbsp;&nbsp;&nbsp;上传文件格式说明：格式如下，数据与数据之间务必用制表符隔开(tab符)，不能用空格，支持txt(制表符分隔)文本文件。制图时将以第一列为x轴<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;① 自定义标题：可自己定义气泡图的标题名称。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;② X轴标题：可自己定义气泡图的X轴标题名称。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③ Y轴标题：可自己定义气泡图的Y轴标题名称。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;④ 自定义气泡的颜色：可自己定义气泡图的颜色，注意颜色数量要与文件个数相等。<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;程序将按要求输出热图，提供SVG格式的图片下载<br>
      </div>
    </div>
    <div id="line">
      <h2>生成结果</h2>
    </div>
    <div class="b2" v-show="isloadfile>0">
      <div id="echart1"></div>
      <div class="output">
        <span>图表导出：</span>
        <el-link class="outputbutton" type="info" @click="output('SVG')">SVG</el-link>
        <el-button type="info" icon="el-icon-download" size="mini" @click="output('SVG')" circle></el-button>
      </div>
    </div>
  </div>

</template>

<script>

//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'Qipao',
  data() {
    return{
      chartInstance:null,
      fileData:[], //(双重数组)读取的文件数据
      dNames:[],
      series_data:[],
      plot_series:[],
      formData: new FormData(),
      formData1: new FormData(),
      formData2: new FormData(),

      formInline: {
        file: '',
        file1: '',
        file2: '',
        title: 'Bubble',
        Xtitle: 'X',
        Ytitle: 'Y',
        color1: '#ff0000',
        no: '',
      },

      colorInline: {
        color1: [{
          color: ''
        }],
        color2: '',
        color3: '',
      },

      historyid: '',
      isloadfile: 0,

      title:null, //(string)图表标题
      xName:null, //(string)X轴标题
      yName:null, //(string)Y轴标题
      bubbleColor:[], //(string)气泡颜色
      groupNames:["seqA","seqB","seqC"], //(string)不同文件的分组名
    }
  },
  mounted() {
    this.init_chart();
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Bubble' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/bubble/qipao.txt','_blank')
    },

    dataURItoBlob(base64Data) {
      var byteString;
      if (base64Data.split(',')[0].indexOf('base64') >= 0)
        byteString = atob(base64Data.split(',')[1]);
      else
        byteString = unescape(base64Data.split(',')[1]);
      var mimeString = base64Data.split(',')[0].split(':')[1].split(';')[0];
      var ia = new Uint8Array(byteString.length);
      for (var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
      }
      return new Blob([ia], {type:mimeString});
    },

    output(type) {
      // this.chartObject存的是echarts实例
      if(this.chartInstance){
        console.log(this.chartInstance)
        // echarts官网文档实例方法getDataURL
        let picInfo = this.chartInstance.getDataURL({
          type: 'svg',
          pixelRatio: 1.5,  // 放大两倍下载。解决生成图片在移动端模糊问题
          backgroundColor: '#fff',
          excludeComponents: ['toolbox','dataZoom']	// 导出时忽略toolbox组件
        });// 获取到的是一串base64信息
        //console.log(picInfo.split(',')[1])

        if(type == 'SVG'){
          const elink = document.createElement('a');
          // 设置默认文件名，this.chartTitle为绘图时生成的标题
          elink.download = this.title + ".svg";
          elink.style.display = 'none';
          elink.href = picInfo;
          document.body.appendChild(elink);
          elink.click();
          URL.revokeObjectURL(elink.href); // 释放URL 对象
          document.body.removeChild(elink);
        }

        let _this = this
        _this.$axios({
          url: this.Host.BASE_URL + 'BaseFunction/bubble/multiUpload',
          method: 'post',
          data: _this.formData,
          headers: {
            "Content-Type": "multipart/form-data" ,
            'Authorization': localStorage.getItem("token")
          },

        }).then((res)=>{
          console.log(res)
          _this.historyid = res.data
          if(res.data==='token过期'){
            localStorage.removeItem("Flag")
            localStorage.removeItem("token")
            this.$router.replace('Login');
          }else{
            var blob = this.dataURItoBlob(picInfo);  // 上一步中的函数
            var fd = new FormData();
            fd.append('files', blob);
            console.log(blob)
            console.log(fd.get('files'))
            fd.append('historyid',_this.historyid)
            console.log(fd.get('historyid'))
            // console.log(blob)
            // console.log(fd)
            _this.$axios({
              url: this.Host.BASE_URL + 'BaseFunction/histogram/save',
              method: 'post',
              data:
              fd,
              //_this.para,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': localStorage.getItem("token")
              },

            }).then((res)=>{
              console.log(res)
              //_this.pic = this.Host.BASE_URL  + res.data
              if(res.data==='token过期'){
                localStorage.removeItem("Flag")
                localStorage.removeItem("token")
                this.$router.replace('Login');
              }
            })
          }
        })
      }
      else{
        this.$message({
          message: '暂未绘制图表，请先绘制图表',
          type: 'error'
        });
      }
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
      _this.isloadfile += 1;
      if(_this.isloadfile>1){
        alert("请勿重复提交");
      }else{
        //参数设置
        if(_this.formInline.title!==''){
          _this.title =_this.formInline.title
        }

        if(_this.formInline.Xtitle!==''){
          _this.xName = _this.formInline.Xtitle
        }

        if(_this.formInline.Ytitle!==''){
          _this.yName = _this.formInline.Ytitle
        }

        for (let i = 0; i < _this.colorInline.color1.length; i++){
          if(_this.colorInline.color1[i].color!=null){
            _this.bubbleColor[i] = _this.colorInline.color1[i].color
          }
        }
        console.log(_this.fileData.length)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          _this.chartInstance.showLoading();
          _this.init_fileData(_this.fileData);
          _this.init_color();
          _this.update_chart();
          _this.clear_data();
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
        _this.fileData.push(this.result);
        console.log(_this.fileData)
      }
    },

    fileLoad1() {
      let _this = this;
      const selectedFiles = this.$refs.refFiles.files[0];
      _this.formData.append('files',selectedFiles);
      _this.formInline.file1 = this.$refs.refFiles.files[0].name;
      let readers = new FileReader();
      readers.readAsText(selectedFiles);
      readers.onload = function () {
        _this.fileData.push(this.result);
        console.log(_this.fileData)
      }
    },

    fileLoad2() {
      let _this = this;
      const selectedFiless = this.$refs.refFiless.files[0];
      _this.formData.append('files',selectedFiless);
      console.log(this.$refs.refFile.files)
      console.log(this.$refs.refFiles.files)
      _this.formInline.file2 = this.$refs.refFiless.files[0].name;
      let readerss = new FileReader();
      readerss.readAsText(selectedFiless);
      readerss.onload = function () {
        _this.fileData.push(this.result);
        console.log(_this.fileData)
      }
    },

    clickLoad() {
      this.$refs.refFile.dispatchEvent(new MouseEvent("click"));
    },

    clickLoad1() {
      this.$refs.refFiles.dispatchEvent(new MouseEvent("click"));
    },

    clickLoad2() {
      this.$refs.refFiless.dispatchEvent(new MouseEvent("click"));
    },

    init_chart() {
      let _this=this;
      _this.chartInstance = this.$echarts.init(document.getElementById("echart1"),null,{renderer:'svg'});
    },

    init_fileData(fileData){
      let _this = this;
      for(let m=0;m<fileData.length;m++){
        let fileOne=[];
        let data_line=fileData[m].split("\n");
        let data_names=data_line[0].split("\t");
        for(let i=0;i<data_names.length;i++){
          _this.dNames.push(data_names[i]);
        }
        for(let i=1;i<data_line.length;i++){
          let line_data=data_line[i].split("\t");
          let bubbleOne=[];
          bubbleOne.push(Number(line_data[0])); //X值
          bubbleOne.push(Number(line_data[1])); //Y值
          bubbleOne.push(Number(line_data[2])); //SIZE 气泡大小
          let bubble_data={
            name:"",
            value:bubbleOne
          }
          // bubbleOne.push(_this.groupNames[m]) //group分组
          fileOne.push(bubble_data);
        }
        _this.series_data.push(fileOne);
      }
    },

    update_chart(){
      let _this = this;
      _this.chartInstance.hideLoading();
      const option={
        tooltip:{
          trigger:'item',
          formatter:'{a}  <br>  {c}'
        },
        toolbox:{
          feature:{
            saveAsImage:{
              type:'svg',
              pixelRatio:2.5,
              excludeComponents:['toolbox','dataZoom']
            },
            dataView:{},
            dataZoom:{},
            restore: {}
          }
        },
        dataZoom:[{
          type: 'slider',//图表下方的伸缩条
          show : true, //是否显示
          xAxisIndex: [0],
          realtime : true, //拖动时，是否实时更新系列的视图
          start : 0, //伸缩条开始位置（1-100），可以随时更改
          end : 100, //伸缩条结束位置（1-100），可以随时更改
        },
          {
            type: 'slider',//图表下方的伸缩条
            show : true, //是否显示
            yAxisIndex: [0],
            x:'left',
            realtime : true, //拖动时，是否实时更新系列的视图
            start : 0, //伸缩条开始位置（1-100），可以随时更改
            end : 100, //伸缩条结束位置（1-100），可以随时更改
          }
        ],
        title:{
          text:_this.title,
          x:'center'
        },
        xAxis: {
          splitLine:{
            show:false
          }
        },
        yAxis: {
          splitLine:{
            show:false
          },
          scale: true
        },
        series: _this.plot_series,
        legend:{
          orient:'vertical',
          x:'right',
          y:'center'
        },
      }
      _this.chartInstance.setOption(option);
    },

    // 用户自定义柱颜色并设置series_data
    init_color(){
      let _this = this;
      if(_this.bubbleColor.length >= _this.series_data.length){
        for(let i=0;i<_this.series_data.length;i++){
          _this.plot_series.push({
            name:_this.groupNames[i],
            type:'scatter',
            data:_this.series_data[i],
            symbolSize:function (val){
              return val[2];
            },
            itemStyle:{
              shadowBlur:10,
              color:_this.bubbleColor[i],
            }
          });
        }
      }
      else{
        for(let i=0;i<_this.series_data.length;i++){
          _this.plot_series.push({
            name:_this.groupNames[i],
            type:'scatter',
            data:_this.series_data[i],
            symbolSize:function (val){
              return val[2];
            },
          });
        }
      }
    },

    clear_data(){
      let _this=this;
      _this.fileData=null; //读取的数据
      _this.dNames.length=0; //X轴名字和折线的名字
      _this.series_data.length=0; //折线的纵坐标数据
      _this.plot_series.length=0;

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

