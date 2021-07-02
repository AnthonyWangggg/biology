<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>二值热图（数字分组）</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="自定义标题">
            <el-input v-model="formInline.title" placeholder=""></el-input>
          </el-form-item>
          <el-form-item label="输入文件">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
            <el-link class="outputbutton" type="info" v-on:click="file1">&nbsp;&nbsp;示例文件</el-link>
          </el-form-item>
          <el-form-item label="分组范围(2,5,8,15 代表2-5,5-8,8-15,15以后为一组)">
            <el-input v-model="formInline.group" :placeholder="formInline.group"></el-input>
          </el-form-item>
          <el-form-item label="字体大小">
            <el-input v-model="formInline.size" :placeholder="formInline.size"></el-input>
          </el-form-item>
          <el-form-item label="分组颜色(与分组个数相同)">
            <el-input v-model="formInline.color" :placeholder="formInline.color"></el-input>
          </el-form-item>
          <el-form-item label="显示行名">
            <el-select v-model="formInline.xlabel" :placeholder="formInline.xlabel">
              <el-option label="是" value='true'></el-option>
              <el-option label="否" value="false"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="显示列名">
            <el-select v-model="formInline.ylabel" :placeholder="formInline.ylabel">
              <el-option label="是" value="true"></el-option>
              <el-option label="否" value="false"></el-option>
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
        &nbsp;&nbsp;&nbsp;&nbsp;根据输入的表格信息和分组信息，利用0/1二值热图展示数据分析结果。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;1. 矩阵表格文件；<br>
        &nbsp;&nbsp;&nbsp;&nbsp;2. 文件格式：输入的文件支持txt(制表符分隔)文本文件。表格名称以字母、数字、下划线组成，不可以有空格；<br>
        &nbsp;&nbsp;&nbsp;&nbsp;注意：为图形美观，建议输入基因数量低于150个。<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.	分组数据<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.	分组颜色：若为空，使用默认颜色<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.	字体大小：默认10，可调整；<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.	默认显示行名，可选；<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.	默认显示列名，可选；<br>


        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;提供SVG格式的图片下载<br>
      </div>
    </div>
    <div id="line">
      <h2>生成结果</h2>
    </div>
    <div class="b2" v-show="isloadfile!=0">
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
  name: 'Erre',
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formInline: {
        file: '',
        xlabel: 'true',
        ylabel: 'true',
        title: 'Binary_heatmap',
        no: '',
        color: '',
        size: 10,
        group: '2,4;6,8;10,15;15',
      },

      historyid: '',

      chartInstance:null,
      fileData:null, //读取的数据

      gro:[],

      //用户输入
      groupdatafromuser: [], //分组数据--文本框输入
      // groupdatafromuser: [[2,4],[6,8],[10,15],[15,'']], //[[2,4],[6,8],[10,15],[15,‘’]] or [[2,4],[6,8],[10,15],[15,50]]//分组数据--文本框输入
      colordatafromuser: [],//分组颜色--用户自定义
      groupnamesfromuser: [],//分组名
      labelfontsize: 10,//字体大小--默认为10
      showxlable: true,//是否显示列名--文本框获取
      showylable: true,//是否显示行名--文本框获取


      colordata: ['#FF0000', '#90d7ec', '#45b97c', '#145b7d',
        '#F0E675', '#ED8F60', '#BF406A', '#692A6F',
        '#5B00AE', '#921AFF', '#AE00AE', '#FF44FF',
        '#0000C6', '#02C874', '#8B6971', '#009AC0'], //分组颜色--用户未自定义颜色则使用

      heatmapdata:[],//画图数据
      groupdata: [],//分组数据
      xlable:[],
      ylable:[],
    }
  },

  mounted() {
    this.init_chart();
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Binary_heatmap' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/binaryheatmap/binary_heatmap.txt','_blank')
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
          url: this.Host.BASE_URL + 'BaseFunction/binaryheatmap/multiUpload',
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
              url: this.Host.BASE_URL + 'BaseFunction/binaryheatmap/save',
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
      }else {
        if(_this.formInline.color!==''){
          //_this.para.color_5 = String(_this.formInline.color.split(','))
          _this.colordatafromuser = _this.formInline.color.split(',')
        }
        if(_this.formInline.group!==''){
          //_this.para.color_5 = String(_this.formInline.color.split(','))
          // _this.groupdatafromuser = _this.formInline.group.split(',').map(Number)
          _this.gro = _this.formInline.group.split(';')
          var b = []
          var c = []
          for (var i = 0; i < _this.gro.length; i++){
            b = _this.gro[i].split(',').map(Number)
            if(b.length===1){
              b.push("")
            }
            console.log(b)
            c.push(b)
          }
          console.log(c)
          var a = JSON.stringify(_this.gro)
          // console.log(a)
          // console.log(_this.gro)
          _this.groupdatafromuser = c
          console.log(_this.groupdatafromuser)
        }

        if(_this.formInline.xlabel!=''){
          if(_this.formInline.xlabel==='true'){
            _this.showxlable = true
          }else {
            _this.showxlable = false
          }
          // _this.showxlable = _this.formInline.xlabel
        }
        if(_this.formInline.ylabel!=''){
          if(_this.formInline.ylabel==='true'){
            _this.showylable = true
          }else {
            _this.showylable = false
          }
          // _this.showylable = _this.formInline.ylabel
        }
        if(_this.formInline.size!=''){
          _this.labelfontsize = _this.formInline.size
        }

        // console.log(_this.showylable + _this.showxlable)
        //
        // console.log('字体大小：'+_this.labelfontsize);
        // _this.chartInstance.showLoading();
        // _this.init_fileData(_this.fileData);
        // console.log('文件数据处理完成');
        // _this.init_groupData(_this.groupdatafromuser, _this.colordatafromuser, _this.groupnamesfromuser);
        // console.log('分组数据完成');
        // _this.update_chart();
        // console.log('画图完成');
        _this.chartInstance.showLoading();
        _this.init_fileData(_this.fileData);//文件数据初步处理
        _this.init_groupData(_this.groupdatafromuser, _this.colordatafromuser, _this.groupnamesfromuser);//分组数据处理
        _this.update_chart();


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
      let data_line=fileData.split("\n");//将文件按行划分并存入data_line
      let data_names=data_line[0].split("\t");//将文件首行的列名划分并存入data_names

      //读取x轴名称
      for(let i=1;i<data_names.length;i++){
        _this.xlable.push(data_names[i]);
      }


      for (let i = 1; i < data_line.length; i++) {
        let line_data = data_line[i].split("\t");
        _this.ylable.push(line_data[0]);//y轴
        for (let j = 1; j < line_data.length; j++) {
          _this.heatmapdata.push([
            (j - 1), (i - 1), line_data[j] //heatmap数据格式
          ])
        }
      }
    },

    // init_color(){
    //   let _this = this;
    // },

    init_groupData(groupData, colorData, groupNames){//分组数据处理
      let _this = this;
      if(groupData.length === 0){
        return;
      }
      let gd = groupData;//分组数据

      let gdc = colorData;//分组颜色
      if(gdc.length === 0 || gd.length>gdc.length){ //如果用户未自定义颜色或用户输入颜色数量少于分组数，则使用已定义分组颜色
        gdc = _this.colordata;
      }

      let gn = groupNames;//分组名
      if(gn.length === 0 || gd.length>gn.length){
        for(let i=0;i<gd.length;i++){
          gn.push('group'+(i+1));
        }
      }
      //前n-1个分组
      for(let i=0;i<gd.length-1;i++){
        _this.groupdata.push({
          gt: gd[i][0], lte: gd[i][1], color: gdc[i], label: gn[i]
        })
      }
      //最后一个分组，判断是[n,m]，还是[n,∞]
      if(gd[gd.length-1][1] === ''){
        _this.groupdata.push({
          gt: gd[gd.length-1][0], color: gdc[gd.length-1], label: gn[gd.length-1]
        })
      }
      else{
        _this.groupdata.push({
          gt: gd[gd.length-1][0], lte: gd[gd.length-1][1],color: gdc[gd.length-1], label: gn[gd.length-1]
        })
      }

    },



    //二值热图
    update_chart(){
      let _this = this;
      _this.chartInstance.hideLoading();
      const option= {
        toolbox: { //工具
          feature: {
            mark: {show: true},
            dataZoom: {show: true}, //数据区域缩放
            restore: {show: true}, //重置
            saveAsImage: {show: true} //保存图片
          }
        },
        tooltip: {
          //trigger: 'item',
          //triggerOn: 'mousemove',
          position: 'top'
        },
        grid: {
          width: '50%',
          height: '80%',
          top: '10%'
        },
        xAxis: {
          show: _this.showxlable,
          type: 'category',
          data: _this.xlable,
          splitArea: {
            show: true
          },
          axisLabel: {
            inside: false,
            rotate: 90,
            fontSize: _this.labelfontsize
          },
          axisTick: { //去掉坐标轴刻度线
            show: false
          }
        },
        yAxis: {
          show: _this.showylable,
          type: 'category',
          data: _this.ylable,
          axisLabel: {
            fontSize: _this.labelfontsize
          },
          position: 'right',
          splitArea: {
            show: true
          },
          axisTick: {
            show: false
          }
        },
        visualMap: { //视觉映射
          pieces: _this.groupdata, // lt（小于，little than），gt（大于，greater than），lte（小于等于 lettle than or equals），gte（大于等于，greater than or equals）
          left: 'center',
          top: 'bottom',
          orient: 'horizontal' //水平
        },
        series: [{
          name: '',
          type: 'heatmap',
          data: _this.heatmapdata, //数据
          label: {
            show: false //是否显示数值
          },
          emphasis: { //鼠标移入动态的时候显示的默认样式
            itemStyle: {
              shadowBlur: 10,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          },


        }]
      }
      _this.chartInstance.setOption(option);
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
  height: 1000px;
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

