<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>动态折线图</h1>
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
        </el-form>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;用一个带有表头的的表格数据绘制一个动态的折线图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;文件格式说明：格式如下，数据与数据之间务必用制表符(tab符)隔开，不能用空格，支持上传txt(制表符分隔)文本文件。制图时将以第一列为x轴其他列为y轴数据<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;①自定义标题：可自己定义折线图的标题<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;②X轴标题：可自己定义折线图的X轴标题名称<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③Y轴标题：可自己定义折线图的Y轴标题名称<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;④折线的颜色：可自定义折线的颜色,注意颜色数量要与系列数相等，不设置则默认颜色<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑤散点的大小：可自定义散点的大小，默认为2<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;程序将输出折线图，提供SVG格式的图片下载<br>
      </div>
    </div>
    <div id="line" v-show="isloadfile>0">
      <h2>生成结果</h2>

      <el-button @click="dialog  = true" type="primary" style="margin-left: 16px;">
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
<!--        <el-scrollbar style="height:50%"> &lt;!&ndash; 滚动条 &ndash;&gt;-->
        <div class="demo-drawer__content">
          <el-form :model="paraForm">
            <el-form-item label="X轴标题" :label-width="formLabelWidth">
              <el-input v-model="paraForm.Xtitle" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="Y轴标题" :label-width="formLabelWidth">
              <el-input v-model="paraForm.Ytitle" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="文字大小" :label-width="formLabelWidth">
              <el-input v-model="paraForm.size" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="线条粗细" :label-width="formLabelWidth">
              <el-input v-model="paraForm.line" placeholder=""></el-input>
            </el-form-item>
          </el-form>
          <el-form  :model="colorInline">
            <el-form-item  v-for="(color, index) in colorInline.color1"
                           :label="'折线' + index + '颜色'"
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
<!--              <el-button type="button" id="fileCommit" v-on:click="paraCommit">提交</el-button>-->
            </el-form-item>
          </el-form>
          <el-checkbox v-model="checked1">折线点</el-checkbox>
          <el-checkbox v-model="checked2">边框</el-checkbox>
          <el-checkbox v-model="checked3">图例</el-checkbox>
          <el-checkbox v-model="checked4">网格线</el-checkbox>
          <div class="but">
            <el-button @click="cancelForm">取 消</el-button>
            <el-button type="primary" @click="$refs.drawer.closeDrawer()">{{ loading ? '提交中 ...' : '确 定' }}</el-button>
          </div>
        </div>
<!--        </el-scrollbar>-->
      </el-drawer>

      <div class="mask" v-if="showModal" @click="showModal=false"></div>
      <div class="pop" v-if="showModal">
        <button @click="showModal=false" class="btn">点击guanbi弹框</button>

        <el-form :model="paraForm" class="demo-form-inline">
        <el-form-item label="X轴标题">
          <el-input v-model="paraForm.Xtitle" placeholder=""></el-input>
        </el-form-item>
        <el-form-item label="Y轴标题">
          <el-input v-model="paraForm.Ytitle" placeholder=""></el-input>
        </el-form-item>
        <el-form-item label="文字大小">
          <el-input v-model="paraForm.size" placeholder=""></el-input>
        </el-form-item>
        <el-form-item label="线条粗细">
          <el-input v-model="paraForm.line" placeholder=""></el-input>
        </el-form-item>
        </el-form>
        <el-form  :model="colorInline" class="demo-form-inline">
          <el-form-item  v-for="(color, index) in colorInline.color1"
                         :label="'折线' + index + '颜色'"
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
            <el-button type="button" id="fileCommit" v-on:click="paraCommit">提交</el-button>
          </el-form-item>
        </el-form>
          <el-checkbox v-model="checked1">折线点</el-checkbox>
          <el-checkbox v-model="checked2">边框</el-checkbox>
          <el-checkbox v-model="checked3">图例</el-checkbox>
          <el-checkbox v-model="checked4">网格线</el-checkbox>
      </div>
<!--      <button @click="showModal=true" class="btn">点击出现弹框</button>-->

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
export default {
  name: "Dongzhe",
  data() {
    return{
      formData: new FormData(),
      formInline: {
        file: '',
        size: '',
        title: '',
        no: '',
      },
      drawer: false,
      dialog: false,
      loading: false,
      formLabelWidth: '80px',
      timer: null,
      showModal: false,
      historyid: '',
      isloadfile:0, //用于判断是否重复提交
      chartInstance:null,
      fileData:null, //读取的数据
      dNames:[], //X轴名字和折线的名字
      xData:[], //X轴数据
      yData:[], //Y轴数据，双重数组
      series_data:[], //折线的纵坐标数据
      title:null, //图表标题
      lineColor:[], //折线颜色
      linenum:null, //折线的数量
      default_color:['#5470c6', '#91cc75', '#fac858', '#ee6666', '#73c0de', '#3ba272', '#fc8452', '#9a60b4', '#ea7ccc'], //默认颜色

      colorInline: {
        color1: [{
          color: ''
        }],
        color2: '',
        color3: '',
      },

      paraForm: {
        size: '',
        Xtitle: '',
        Ytitle: '',
        line: '',
      },
      checked1: true,
      checked2: false,
      checked3: true,
      checked4: false,
    }
  },
  mounted() {
    this.init_chart();

    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'line' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/Dynamic/line/line.txt','_blank')
    },

    handleClose(done) {
      let _this = this;
      this.$confirm('确定要提交表单吗？')
        .then(_ => {
          _this.update_fontsize()
          _this.update_xname()
          _this.update_yname()
          _this.update_linewidth()
          _this.update_linepoint()
          _this.update_gridshow()
          _this.update_legendshow()
          _this.update_splitlineshow()
          _this.update_legendshow()
          _this.update_linecolor()
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
          url: this.Host.BASE_URL + 'Dynamic/line/multiUpload',
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
              url: this.Host.BASE_URL + 'Dynamic/line/save',
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
              }else if (res.data === 'Error'){
                this.$message.error('发生错误，检查提交文件及参数，重新提交');
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

    //修改字体大小，int
    update_fontsize(){
      let _this = this;
      if(_this.paraForm.size!=''){
        _this.chartInstance.setOption({
          xAxis:{
            nameTextStyle: {
              fontSize: _this.paraForm.size //修改此处为传入的参数值
            },
            axisLabel: {
              fontSize: _this.paraForm.size //修改此处为传入的参数值
            }
          },
          yAxis:{
            nameTextStyle: {
              fontSize: _this.paraForm.size //修改此处为传入的参数值
            },
            axisLabel: {
              fontSize: _this.paraForm.size //修改此处为传入的参数值
            }
          }
        });
      }

    },

    //修改字体样式，string
    update_fontstyle(){
      let _this = this;
      _this.chartInstance.setOption({
        xAxis:{
          nameTextStyle: {
            fontFamily: 'Courier New' //修改此处为传入的参数值
          },
          axisLabel: {
            fontFamily: 'Courier New' //修改此处为传入的参数值
          }
        },
        yAxis:{
          nameTextStyle: {
            fontFamily: 'Courier New' //修改此处为传入的参数值
          },
          axisLabel: {
            fontFamily: 'Courier New' //修改此处为传入的参数值
          }
        }
      });
    },

    //修改X轴标题，string
    update_xname(){
      let _this = this;
      if(_this.paraForm.Xtitle!=''){
        _this.chartInstance.setOption({
          xAxis:{
            name: _this.paraForm.Xtitle //修改此处为传入的参数值
          }
        });
      }

    },

    //修改Y轴标题，string
    update_yname(){
      let _this = this;
      if(_this.paraForm.Ytitle!=''){
        _this.chartInstance.setOption({
          yAxis:{
            name: _this.paraForm.Ytitle //修改此处为传入的参数值
          }
        });
      }
    },

    //修改线条粗细，int
    update_linewidth(){
      let _this = this;
      if(_this.paraForm.line!=''){
        let temp_series=[];
        for(let i=0;i<_this.linenum;i++){
          temp_series.push({
            symbolSize: Number(_this.paraForm.line)+2, //修改此处，尽量保存值为线大小+2，即width对应值加上2
            lineStyle: {
              width: Number(_this.paraForm.line) //修改此处
            }
          })
        }
        _this.chartInstance.setOption({
          series:temp_series
        });
      }

    },

    //取消折线点，bool
    update_linepoint(){
      let _this = this;
      let temp_series=[];
      let point_show=_this.checked1; //修改此处为传入的参数值,显示折现点为true,不显示为false
      for(let i=0;i<_this.linenum;i++){
        if(point_show){
          temp_series.push({
            symbol:'circle',
          })
        }else {
          temp_series.push({
            symbol:'none',
          })
        }
      }
      _this.chartInstance.setOption({
        series:temp_series
      });
    },

    //图像外边框，bool
    update_gridshow(){
      let _this = this;
      let grid_show=_this.checked2; //修改此处为传入的参数值,显示边框为true,不显示为false
      _this.chartInstance.setOption({
        grid:{
          show:grid_show
        }
      });
    },

    //图例显示，bool
    update_legendshow(){
      let _this = this;
      let legend_show=_this.checked3; //修改此处为传入的参数值,显示图例为true,不显示为false
      _this.chartInstance.setOption({
        legend:{
          show:legend_show
        }
      });
    },

    //网格线显示，bool
    update_splitlineshow(){
      let _this = this;
      let splitline_show=_this.checked4; //修改此处为传入的参数值,显示网格线为true,不显示为false
      _this.chartInstance.setOption({
        xAxis:{
          splitLine:{
            show:splitline_show
          }
        },
        yAxis:{
          splitLine:{
            show:splitline_show
          }
        }
      });
    },

    //改变折线颜色，string数组(所有折线颜色)
    update_linecolor(){
      let _this = this;
      let temp_series=[];
      let colors = [];
      for (let i = 0; i < _this.colorInline.color1.length; i++){
        if(_this.colorInline.color1[i].color!=null){
          colors[i] = _this.colorInline.color1[i].color
        }
      }
      let line_color = colors //修改此处为传入的参数值(string 数组，按照绘制的折线顺序，数组大小要严格与折线数量保持一致)
      //console.log(line_color)
      for(let i=0;i<_this.linenum;i++){
        temp_series.push({
          itemStyle:{
            color:line_color[i],
          }
        })
      }
      _this.chartInstance.setOption({
        series:temp_series
      });
    },

    paraCommit(){
      let _this = this;
      _this.update_fontsize()
      _this.update_xname()
      _this.update_yname()
      _this.update_linewidth()
      _this.update_linepoint()
      _this.update_gridshow()
      _this.update_legendshow()
      _this.update_splitlineshow()
      _this.update_legendshow()
      _this.update_linecolor()
    },


    chartCommit(){
      let _this = this;
      _this.isloadfile += 1;
      if(_this.fileData == null){
        alert("文件不能为空");
      }
      if(_this.isloadfile>1){
        alert("请勿重复提交");
      }
      else {
        _this.chartInstance.showLoading();
        _this.init_fileData(_this.fileData);
        _this.init_color();
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
      _this.linenum=_this.yData.length;
    },

    update_chart(){
      let _this = this;
      _this.chartInstance.hideLoading();
      const option={
        tooltip:{
          trigger:'axis',
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
          type: 'inside',//图表下方的伸缩条
          show : true, //是否显示
          xAxisIndex: [0],
          realtime : true, //拖动时，是否实时更新系列的视图
          start : 0, //伸缩条开始位置（1-100），可以随时更改
          end : 100, //伸缩条结束位置（1-100），可以随时更改
        },
          {
            type: 'inside',//图表下方的伸缩条
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
          type: 'category',
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
      if(_this.lineColor.length >= _this.yData.length){
        for(let i=0;i<_this.yData.length;i++){
          _this.series_data.push({
            name:_this.dNames[i+1],
            type:'line',
            symbol:'circle',
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
            symbol:'circle',
            data:_this.yData[i],
          });
        }
      }
    },

    clear_data(){
      let _this=this;
      _this.dNames.length=0; //X轴名字和折线的名字
      _this.xData.length=0; //X轴数据
      _this.yData.length=0; //Y轴数据，双重数组
      _this.series_data.length=0; //折线的纵坐标数据
      _this.lineColor.length=0;
      _this.linenum=null;
    }
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

.mask {
  background-color: #000;
  opacity: 0.3;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1
}
.pop {
  background-color: #fff;
  position: fixed;
  top: 100px;
  left: 300px;
  width: calc(100% - 600px);
  height:calc(100% - 200px);
  padding: 5px 10px;
  z-index: 2
}
.btn {
  background-color: #fff;
  border-radius: 4px;
  border: 1px solid blue;
  padding: 4px 12px;
}
.but{
  margin: 0 auto;
  padding: 5px 10px!important;
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

