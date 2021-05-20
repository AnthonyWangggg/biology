<template>
  <div className="box">
    <div id="echart1"></div>
    <div>
      <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
      <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      <input type="file" id="files" ref="refFile" style="display: none" v-on:change="fileLoad">
    </div>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data(){
    return{
      chartInstance:null,
      fileData:null, //读取的数据
      dNames:[], //X轴名字和折线的名字
      xData:[], //X轴数据
      yData:[], //Y轴数据，双重数组
      series_data:[], //折线的纵坐标数据
      title:null, //图表标题
      xName:null, //X轴标题
      yName:null, //Y轴标题
      lineColor:[], //折线颜色
      pointSize:8 //散点大小，默认为8
    }
  },

  mounted() {
    this.init_chart();
    //this.onInitEchart1();

  },

  methods: {
    // onInitEchart1(){
    //   let echarts = require('echarts');
    //   let myChart = echarts.init(document.getElementById('echart1'), 'walden');
    //
    //   let option = {
    //         ///这一就完全可以把上面的网站图这里
    //     xAxis: {
    //       type: 'category',
    //       data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    //     },
    //     yAxis: {
    //       type: 'value'
    //     },
    //     series: [{
    //       data: [150, 230, 224, 218, 135, 147, 260],
    //       type: 'line'
    //     }]
    //   };
    //   myChart.setOption(option);
    // },
    chartCommit(){
      let _this = this;
      _this.init_fileData(_this.fileData);
      _this.init_color();
      _this.update_chart();
    },

    fileLoad() {
      let _this = this;
      const selectedFile = this.$refs.refFile.files[0];
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
      this.chartInstance = this.$echarts.init(document.getElementById("echart1"));
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
      const option={
        toolbox:{
          feature:{
            saveAsImage:{},
            dataView:{},
            dataZoom:{},
          }
        },
        title:{
          text:_this.title,
          x:'center'
        },
        xAxis: {
          name:_this.xName,
          type: 'category',
          data: _this.xData
        },
        yAxis: {
          name:_this.yName,
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
      if(_this.lineColor.length >= _this.yData.length){
        for(let i=0;i<_this.yData.length;i++){
          _this.series_data.push({
            name:_this.dNames[i+1],
            type:'line',
            stack:'total',
            symbol:'circle',
            symbolSize:_this.pointSize,
            data:_this.yData[i],
            itemStyle:{
              normal:{
                color:_this.lineColor[i],
                lineStyle:{
                  color:_this.lineColor[i]
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
            stack:'total',
            symbol:'circle',
            symbolSize:_this.pointSize,
            data:_this.yData[i],
          });
        }
      }
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.box {
  width: auto;
  height: auto;
}

#echart1 {
  height: 350px;
  width: 800px;
  margin: 0 auto;
}
</style>
