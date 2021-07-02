<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>面积图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="自定义标题">
            <el-input v-model="formInline.title" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="源文件">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item>
          </el-form-item>
          <el-form-item label="面积图类型">
            <el-select v-model="formInline.region" :placeholder="formInline.region">
              <el-option label="普通面积图" value="null"></el-option>
              <el-option label="堆叠面积图" value="2"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="X轴标题">
            <el-input v-model="formInline.Xtitle" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="Y轴标题">
            <el-input v-model="formInline.Ytitle" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="透明度">
            <el-input v-model="formInline.color" placeholder=""></el-input>
          </el-form-item>
        </el-form>

        <el-form  :model="colorInline" class="demo-form-inline">
          <el-form-item  v-for="(color, index) in colorInline.color1"
                         :label="'面积区域' + index + '颜色'"
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
            <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
          </el-form-item>
        </el-form>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;用一个带有表头，且以tab符分隔的表格数据绘制一个面积图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;上传拥有表头的数据文件，且表头位于第一行。支持txt(制表符分隔)文本文件。数据与数据间以制表符分开（Tab键）,不能用空格，制图时将以第一列为x轴<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;① 面积图类型：普通面积图与堆叠面积图供选择<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;② 自定义标题：可自己定义面积图的标题名称<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③ X轴标题：可自己定义面积图的X轴标题名称<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③ Y轴标题：可自己定义面积图的Y轴标题名称<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;④ 面积颜色：可自定义面积图的颜色,注意颜色数量要与系列(组)数相等，不设置则默认颜色<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑤ 面积透明度：0-1之间的数据，越接近0越透明，默认为0.6<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;程序将按要求输出面积图，提供SVG格式的图片下载<br>
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
  name: 'Mianji',
  data() {
    return{
      isloadfile: 0,
      formData: new FormData(),
      formInline: {
        file: '',
        Xtitle: '',
        region: '',
        title: '',
        Ytitle: '',
        no: '',
        color: 0.4
      },
      colorInline: {
        color1: [{
          color: ''
        }],
        color2: '',
        color3: '',
      },

      historyid: '',

      chartInstance:null,
      fileData:null, //读取的数据
      dNames:[], //X轴名字和折线的名字
      xData:[], //X轴数据
      yData:[], //Y轴数据，双重数组
      series_data:[], //折线的纵坐标数据
      title:null, //图表标题
      xName:null, //X轴标题
      yName:null, //Y轴标题
      areaColor:[], //面积颜色
      areaType:null, //(string) null:普通面积图 '2':堆叠面积图
      areaAlpha:0.4, //面积的透明度,默认为0.4
    }
  },
  mounted() {
    this.init_chart();
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Area' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/area/area.txt','_blank')
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
          url: this.Host.BASE_URL + 'BaseFunction/area/multiUpload',
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
            // var canvas = document.createElement('canvas');
            // var dataURL = canvas.toDataURL('svg', 0.5);
            //var fd = new FormData(document.forms[0]);
            var fd = new FormData();
            fd.append('files', blob);
            console.log(blob)
            console.log(fd.get('files'))
            fd.append('historyid',_this.historyid)
            console.log(fd.get('historyid'))
            // console.log(blob)
            // console.log(fd)
            _this.$axios({
              url: this.Host.BASE_URL + 'BaseFunction/area/save',
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
        if(_this.formInline.title!=''){
          _this.title =_this.formInline.title
        }

        _this.areaType = _this.formInline.region

        _this.xName = _this.formInline.Xtitle
        _this.yName = _this.formInline.Ytitle
        _this.areaAlpha = _this.formInline.color
        for (let i = 0; i < _this.colorInline.color1.length; i++){
          if(_this.colorInline.color1[i].color!=null){
            _this.areaColor[i] = _this.colorInline.color1[i].color
          }
        }
        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          _this.chartInstance.showLoading();
          _this.init_fileData(_this.fileData);
          console.log(_this.dNames);
          _this.init_color();
          console.log(_this.series_data[1]);
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
        _this.fileData=this.result;
      }
    },

    clickLoad() {
      this.$refs.refFile.dispatchEvent(new MouseEvent("click"));
    },

    init_chart() {
      let _this=this;
      _this.chartInstance = this.$echarts.init(document.getElementById("echart1"),null,{renderer:'svg'});
    },

    init_fileData(fileData){
      let _this = this;
      let data_line=fileData.split("\n");
      let data_names=data_line[0].split("\t");
      for(let i=0;i<data_names.length;i++){
        _this.dNames.push(data_names[i]);
        if(i>0){
          let ldata=[];
          _this.yData.push(ldata);
        }
      }
      for(let i=1;i<data_line.length;i++){
        let line_data=data_line[i].split("\t");
        _this.xData.push(line_data[0]);
        for(let j=1;j<line_data.length;j++){
          let yLine=_this.yData[j-1];
          yLine.push(Number(line_data[j]));
          _this.yData[j-1]=yLine;
        }
      }
    },

    update_chart(){
      let _this = this;
      _this.chartInstance.hideLoading();
      const option={
        tooltip:{
          // trigger:'item'
          trigger: 'axis',
          axisPointer: {
            type: 'cross',
            label: {
              backgroundColor: '#6a7985'
            }
          }
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
          name:_this.xName,
          type: 'category',
          boundaryGap: false,
          data: _this.xData
        },
        yAxis: {
          name:_this.yName,
          scale:true, //当Y轴数据波动较小时，折线效果更加明显
          type: 'value'
        },
        series: _this.series_data,
        legend:{
          orient:'vertical',
          x:'right',
          y:'center'
        },
      }
      _this.chartInstance.setOption(option);
    },

    init_color(){
      let _this = this;
      if(_this.areaColor.length >= _this.yData.length){
        for(let i=0;i<_this.yData.length;i++){
          _this.series_data.push({
            name:_this.dNames[i+1],
            type:'line',
            stack:_this.areaType,
            areaStyle: {
              opacity:_this.areaAlpha
            },
            emphasis: {
              focus: 'series'
            },
            data:_this.yData[i],
            itemStyle:{
              normal:{
                color:_this.areaColor[i],
                lineStyle:{
                  color:_this.areaColor[i]
                }
              }
            }
          });
        }
      }
      else{
        for(let i=0;i<_this.yData.length;i++){
          _this.series_data.push({
            name:_this.dNames[i+1],
            type:'line',
            stack:_this.areaType,
            areaStyle: {
              opacity:_this.areaAlpha
            },
            emphasis: {
              focus: 'series'
            },
            data:_this.yData[i],
          });
        }
      }
    },

    clear_data(){
      let _this=this;
      _this.fileData=null; //读取的数据
      _this.dNames.length=0; //X轴名字和折线的名字
      _this.xData.length=0; //X轴数据
      _this.yData.length=0; //Y轴数据，双重数组
      _this.series_data.length=0; //折线的纵坐标数据
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
