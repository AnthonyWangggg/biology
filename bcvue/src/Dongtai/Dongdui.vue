<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>动态堆叠图</h1>
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
        </el-form>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
      </div>
      <div id="rightbox">
        <h2>功能：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;微生物群落研究/宏基因组/转录组学等领域  常见的数据展示图形，将输入的表格数据转化为百分比的形式，对样本/分组中所有进行行数据转换为堆叠柱逐一进行展示，以不同的颜色区分不同物种/基因/蛋白，可以通过堆叠图展示优势元素在组间/样本间占比变化趋势。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;数据文件：输入矩阵表格，第一列可以是物种名称信息、基因名称信息、蛋白名称信息等；第一行为样本或分组名称信息（必填信息）；表格中输入对应数据<br>
        &nbsp;&nbsp;&nbsp;&nbsp;上传文件格式说明：支持txt(制表符分隔)文本文件<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;提供SVG格式的图片下载<br>
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
            <el-form-item label="标题" :label-width="formLabelWidth">
              <el-input v-model="paraForm.title" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="X轴标题" :label-width="formLabelWidth">
              <el-input v-model="paraForm.Xtitle" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="Y轴标题" :label-width="formLabelWidth">
              <el-input v-model="paraForm.Ytitle" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="柱状图类型" :label-width="formLabelWidth">
              <el-select v-model="paraForm.type" :placeholder="paraForm.type">
                <el-option label="纵向柱形图" value="false"></el-option>
                <el-option label="横向柱形图" value="true"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="文字大小" :label-width="formLabelWidth">
              <el-input v-model="paraForm.size" placeholder=""></el-input>
            </el-form-item>
          </el-form>
          <el-form  :model="colorInline">
            <el-form-item  v-for="(color, index) in colorInline.color1"
                           :label="'柱形' + index + '颜色'"
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

          <el-checkbox v-model="checked">图例</el-checkbox>

          <div class="but">
            <el-button @click="cancelForm">取 消</el-button>
            <el-button type="primary" @click="$refs.drawer.closeDrawer()">{{ loading ? '提交中 ...' : '确 定' }}</el-button>
          </div>
        </div>
<!--        <el-button type="button" id="title" v-on:click="update_title">标题</el-button>-->
<!--        <el-button type="button" id="xlabel" v-on:click="updata_xlabel">x轴标签</el-button>-->
<!--        <el-button type="button" id="ylabel" v-on:click="updata_ylabel">y轴标签</el-button>-->
<!--        <el-button type="button" id="direction" v-on:click="updata_direction">柱形图类型</el-button>-->
<!--        <el-button type="button" id="legend" v-on:click="update_legend">图例</el-button>-->
<!--        <el-button type="button" id="color" v-on:click="update_color">柱形图颜色</el-button>-->
<!--        <el-button type="button" id="fontcolor" v-on:click="updata_fontcolor">字体颜色</el-button>-->
<!--        <el-button type="button" id="fontsize" v-on:click="updata_fontsize">字体大小</el-button>-->
      </el-drawer>
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
  name: "Dongdui",
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

      //用户输入
      title: 'Dynamic Stack Graph', //(string)图表标题--'Dynamic Stack Graph'
      xlabel: 'x label', //x轴标签
      ylabel: 'y label', //y轴标签
      displaydirection: true, //柱形图显示方向，true：横向柱形图，false：纵向柱形图，默认为：true
      displaylegend: true, //是否显示图例
      colorfromuser: [], //柱形图颜色
      fontcolorfromuser: 'black', //字体颜色--全局
      fontsizefromuser: 15, //字体大小--全局

      //数据处理
      datanames:[],//数据名
      ylabelname:[],//y轴数据名
      stack:[],//series数据

      //默认颜色
      colordata: ['#5470c6','#ff7f50','#87cefa','#da70d6',
        '#32cd32','#6495ed','#ff69b4','#ba55d3',
        '#cd5c5c','#ffa500','#40e0d0','#1e90ff',
        '#ff6347','#7b68ee','#00fa9a','#ffd700',
        '#6699FF','#ff6666','#3cb371','#b8860b',
        '#30e0e0'],

      colorInline: {
        color1: [{
          color: ''
        }],
        color2: '',
        color3: '',
      },

      paraForm: {
        size: '15',
        title: 'Dynamic Stack Graph',
        Xtitle: 'x label',
        Ytitle: 'y label',
        line: '',
        type: 'true',
      },

      checked: true,

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
      window.open(this.Host.BASE_URL + 'public/Dynamic/stack/stack.txt','_blank')
    },

    handleClose(done) {
      let _this = this;
      this.$confirm('确定要提交表单吗？')
        .then(_ => {
          _this.update_title()
          _this.updata_xlabel()
          _this.updata_ylabel()
          _this.updata_direction()
          _this.update_legend()
          _this.update_color()
          _this.updata_fontsize()
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
          url: this.Host.BASE_URL + 'Dynamic/stack/multiUpload',
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
              url: this.Host.BASE_URL + 'Dynamic/stack/save',
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

    //修改标题
    update_title(){
      let _this = this;
      _this.chartInstance.setOption({
        title: {
          text: '\n' + _this.paraForm.title  //修改此处为传入的参数值--'\n'不要改
        },
      })
    },

    //修改x轴标签名
    updata_xlabel(){
      let _this = this;
      _this.chartInstance.setOption({
        xAxis: {
          name: '\n' + _this.paraForm.Xtitle, //修改此处为传入的参数值--'\n'不要改
        }
      })
    },

    //修改y轴标签名
    updata_ylabel(){
      let _this = this;
      _this.chartInstance.setOption({
        yAxis: {
          name: _this.paraForm.Ytitle + '\n', //修改此处为传入的参数值--'\n'不要改
        }
      })
    },

    //柱形图显示方向
    updata_direction(){
      let _this = this;
      if(_this.paraForm.type==='false'){
        _this.displaydirection = false;
      }
      else if(_this.paraForm.type==='true'){
        _this.displaydirection = true;
      }

      if(_this.displaydirection){
        _this.update_chart1();  //横向柱形图
      }
      else{
        _this.update_chart2();  //纵向柱形图
      }
    },


    //修改图例——是否显示
    update_legend(){
      let _this = this;
      if(!_this.checked){
        _this.displaylegend = false;
      }
      else {
        _this.displaylegend = true;
      }

      _this.chartInstance.setOption({
        legend: {
          show: _this.displaylegend,  //修改此处为传入的参数值
          orient: 'vertical',
          top: '15%',
          right: '0%',
          align:"left",
          data: _this.datanames
        }
      })
    },

    //修改颜色
    update_color(){
      let _this = this;
      let former_color = []; //原来柱形图的颜色
      let colors = [];
      for (let i = 0; i < _this.colorInline.color1.length; i++){
        if(_this.colorInline.color1[i].color!=null){
          colors[i] = _this.colorInline.color1[i].color
        }
      }

      for(let i = 0; i<_this.stack.length; i++){
        former_color.push(_this.stack[i].color)
      }

      let up_color = colors; //修改此处为传入的参数值
      let up_color_num = up_color.length;

      for(let i = 0; i < _this.stack.length; i++){
        _this.stack[i].color = up_color[i % up_color_num]
      }

      _this.chartInstance.setOption({
        series: _this.stack
      });

    },

    //字体颜色
    updata_fontcolor(){
      let _this = this;
      _this.chartInstance.setOption({
        textStyle: {
          color: 'red', //修改此处为传入的参数值
        },
        title: {  //标题
          textStyle: {
            color: 'red' //修改此处为传入的参数值
          },
        },
        legend: { //图例
          textStyle: {
            color: 'red'  //修改此处为传入的参数值
          }
        },

      })
    },

    //字体大小
    updata_fontsize(){
      let _this = this;
      _this.chartInstance.setOption({
        textStyle: {
          fontSize: _this.paraForm.size,  //修改此处为传入的参数值
        },
        title: {  //标题
          textStyle: {
            fontSize: _this.paraForm.size,  //修改此处为传入的参数值
          },
        },

      })
    },


    paraCommit(){
      let _this = this;
      _this.update_title()
      _this.updata_xlabel()
      _this.updata_ylabel()
      _this.updata_direction()
      _this.update_legend()
      _this.update_color()
      _this.updata_fontsize()
    },


    chartCommit(){
      let _this = this;
      _this.isloadfile += 1;
      _this.chartInstance.showLoading();
      _this.init_fileData(_this.fileData);
      if(_this.displaydirection){
        _this.update_chart1();//横向柱形图
      }
      else{
        _this.update_chart2();//纵向柱形图
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
      //将列名存入全局变量ylabelname中
      for(let i=1;i<data_names.length;i++){
        _this.ylabelname.push(data_names[i]);
      }
      //将数据按所需格式存入相应变量中
      for(let i=1;i<data_line.length;i++){
        let line_data=data_line[i].split("\t");
        _this.datanames.push(line_data[0]);//每行数据的名称存入全局变量中
        let line_d = [];
        for(let j=1;j<line_data.length;j++){
          line_d.push(line_data[j]);
        }

        //按series所需格式将数据push进stack中
        let colordata = _this.colorfromuser;
        if(colordata.length === 0){
          colordata = _this.colordata;
        }

        let colordatanum = colordata.length;
        _this.stack.push({
          name:line_data[0],
          type:'bar',
          stack:'total',
          label:{
            show:false
          },
          emphasis: {
            focus: 'series'
          },
          data:line_d,
          color: colordata[(i-1)%colordatanum]
        })
      }
    },

    //动态堆叠图——横向柱形图
    update_chart1(){
      let _this = this;
      _this.chartInstance.hideLoading();
      const option= {
        textStyle: {
          color: _this.fontcolorfromuser, //坐标轴标签、数据
          fontSize: _this.fontsizefromuser,  //坐标轴标签、图例
        },

        title: {  //标题
          text: '\n' + _this.title,
          x: "center",
          textStyle: {
            fontSize: _this.fontsizefromuser, //标题字体大小
            fontWeight: 'bolder',
            color: _this.fontcolorfromuser //标题颜色
          },
        },
        toolbox: { //工具
          feature: {
            mark: {show: true},
            dataView: {show: true, readOnly: false}, //数据视图
            dataZoom: {show: true}, //数据区域缩放
            restore: {show: true}, //重置
          }
        },
        tooltip: {  //提示框
          trigger: 'item',  //‘axis’ or 'item'
          axisPointer: {            // Use axis to trigger tooltip
            type: 'shadow'        // 'shadow' as default; can also be 'line' or 'shadow'
          }
        },
        legend: { //图例
          show: _this.displaylegend,//是否显示图例
          orient: 'vertical',
          top: '15%',
          right: '0%',
          align:"left",
          data: _this.datanames,
          textStyle: {
            color: _this.fontcolorfromuser
          }
        },
        grid: {
          left: '10%',
          right: '25%',
          top: '10%',
          bottom: '15%',
          containLabel: true
        },
        xAxis: {
          name: '\n' + _this.xlabel,
          nameLocation:'middle',
          type: 'value',
          axisLine: {
            show: true
          },
          axisTick: {
            show: true,
            inside: false
          },
          min: 0,
          max: 100
        },
        yAxis: {
          name: _this.ylabel + '\n',
          nameLocation:'middle',
          type: 'category',
          data: _this.ylabelname
        },
        series: _this.stack,
      }
      _this.chartInstance.setOption(option);
    },

    //动态堆叠图——纵向柱形图
    update_chart2(){
      let _this = this;
      _this.chartInstance.hideLoading();
      const option= {
        textStyle: {
          color: _this.fontcolorfromuser, //坐标轴标签、数据
          fontSize: _this.fontsizefromuser,  //坐标轴标签、图例
        },

        title: {  //标题
          text: '\n' + _this.title,
          x: "center",
          textStyle: {
            fontSize: _this.fontsizefromuser, //标题字体大小
            fontWeight: 'bolder',
            color: _this.fontcolorfromuser //标题颜色
          },
        },
        toolbox: { //工具
          feature: {
            mark: {show: true},
            dataView: {show: true, readOnly: false}, //数据视图
            dataZoom: {show: true}, //数据区域缩放
            restore: {show: true}, //重置
            saveAsImage: {show: true} //保存图片
          }
        },
        tooltip: {  //提示框
          trigger: 'item',  //‘axis’ or 'item'
          axisPointer: {            // Use axis to trigger tooltip
            type: 'shadow'        // 'shadow' as default; can also be 'line' or 'shadow'
          }
        },
        legend: { //图例
          show: _this.displaylegend,//是否显示图例
          orient: 'vertical',//'vertical','horizontal'
          top: '15%',
          right: '0%',
          align:"left",
          data: _this.datanames,
          textStyle: {
            color: _this.fontcolorfromuser
          }
        },
        grid: {
          left: '15%',
          right: '25%',
          bottom: '15%',
          top: '10%',
          containLabel: true
        },
        xAxis: {
          name: '\n' + _this.xlabel,
          nameLocation:'middle',
          type: 'category',
          data: _this.ylabelname
        },
        yAxis: {
          name: _this.ylabel + '\n',
          nameLocation:'middle',
          type: 'value',
          axisLine: {
            show: true
          },
          axisTick: {
            show: true,
            inside: false
          },
          min: 0,
          max: 100
        },
        series: _this.stack,
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
  height: 400px;
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

