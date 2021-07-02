<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>极坐标柱状图</h1>
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
          <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        </el-form>
        <!--<el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <input type="file" id="files" ref="refFile" style="display: none" v-on:change="fileLoad">-->
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;与常规柱状图相同，用于展示数据分布统计结果。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;1. 文件必须是带有表头的文件，支持txt(制表符分隔)文本文件。表格名称以字母、数字、下划线组成，不可以有空格。<br>
        &nbsp;&nbsp;&nbsp;&nbsp;2. 文件包含两列，第一列为分组名，第二列各分组数据统计结果<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;提供SVG格式的图片下载<br>
      </div>
    </div>
    <div id="line">
      <h2>生成结果</h2>
    </div>
    <div class="b2" v-show="isloadfile!==0">
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
export default {
  name: 'Jizuobiao',
  data() {
    return{
      chartInstance:null,
      fileData:null, //读取的数据
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formInline: {
        file: '',
        title: 'Polarbar',
        no: '',
      },

      historyid: '',

      title:null, //(string)图表标题
      dNames:[],
      rosedataname:[],//名字
      rosedata:[],//数据
      serisData:[],

    }
  },
  mounted() {
    this.init_chart();
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Polarbar' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/polarbar/polarbar.txt','_blank')
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
          url: this.Host.BASE_URL + 'BaseFunction/polarbar/multiUpload',
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
              url: this.Host.BASE_URL + 'BaseFunction/polarbar/save',
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

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          _this.chartInstance.showLoading();
          _this.init_fileData(_this.fileData);
          _this.init_color();
          console.log(_this.rosedataname);
          console.log(_this.rosedata);
          console.log(_this.serisData);
          _this.update_chart();
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
      //_this.chartInstance = this.$echarts.init(document.getElementById("echart1"));
      _this.chartInstance = this.$echarts.init(document.getElementById("echart1"),null,{renderer:'svg'});
    },

    init_fileData(fileData){
      let _this = this;
      let data_line=fileData.split("\n");
      let data_names=data_line[0].split("\t");
      for(let i=0;i<data_names.length;i++){
        _this.dNames.push(data_names[i]);
      }
      for(let i=1;i<data_line.length;i++){
        let line_data=data_line[i].split("\t");
        _this.rosedataname.push(line_data[0]);
        _this.rosedata.push(line_data[1]);
      }
    },

    init_color(){
      let _this = this;
      for(let i=0;i<_this.rosedataname.length;i++){
        _this.serisData.push({
          name:_this.rosedataname[i],
          value:_this.rosedata[i]
        })
      }
    },


    update_chart(){
      let _this = this;
      _this.chartInstance.hideLoading();
      const option={
        legend: {
          top: 'bottom'
        },
        tooltip:{
          formatter:'{b} <div> {c}'
        },
        toolbox:{
          feature:{
            mark: {show: true},
            dataView:{show: true, readOnly: false},
            dataZoom:{show: true},
            restore: {show: true},
            saveAsImage:{show: true}
          }
        },
        title:{
          text:_this.title,
          x:'center'
        },

        series: [
          {
            name: '面积模式',
            type: 'pie',
            radius: [50,250],
            center: ['50%', '50%'],
            roseType: 'area',
            itemStyle: {
              borderRadius: 8
            },
            data:_this.serisData
          }
        ]

      }
      _this.chartInstance.setOption(option);
    },
  }
}
</script>

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
  height: 800px;
  width: 1000px;
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
