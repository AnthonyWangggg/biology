<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>桑基图</h1>
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
          <el-form-item label="透明度">
            <el-select v-model="formInline.opacity" :placeholder="formInline.opacity">
              <el-option label="0.0" value="0.0"></el-option>
              <el-option label="0.1" value="0.1"></el-option>
              <el-option label="0.2" value="0.2"></el-option>
              <el-option label="0.3" value="0.3"></el-option>
              <el-option label="0.4" value="0.4"></el-option>
              <el-option label="0.5" value="0.5"></el-option>
              <el-option label="0.6" value="0.6"></el-option>
              <el-option label="0.7" value="0.7"></el-option>
              <el-option label="0.8" value="0.8"></el-option>
              <el-option label="0.9" value="0.9"></el-option>
              <el-option label="1.0" value="1.0"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="条带变化曲率">
            <el-select v-model="formInline.curveness" :placeholder="formInline.curveness">
              <el-option label="0.0" value="0.0"></el-option>
              <el-option label="0.1" value="0.1"></el-option>
              <el-option label="0.2" value="0.2"></el-option>
              <el-option label="0.3" value="0.3"></el-option>
              <el-option label="0.4" value="0.4"></el-option>
              <el-option label="0.5" value="0.5"></el-option>
              <el-option label="0.6" value="0.6"></el-option>
              <el-option label="0.7" value="0.7"></el-option>
              <el-option label="0.8" value="0.8"></el-option>
              <el-option label="0.9" value="0.9"></el-option>
              <el-option label="1.0" value="1.0"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="标题大小">
            <el-input v-model="formInline.sizetitle" :placeholder="formInline.sizetitle"></el-input>
          </el-form-item>
          <el-form-item label="方格字体大小">
            <el-input v-model="formInline.sizelabel" :placeholder="formInline.sizelabel"></el-input>
          </el-form-item>
          <el-form-item label="方格名称是否显示">
            <el-select v-model="formInline.showlabel" :placeholder="formInline.showlabel">
              <el-option label="是" value="true"></el-option>
              <el-option label="否" value="false"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="方格名称位置">
            <el-select v-model="formInline.position" :placeholder="formInline.position">
              <el-option label="自适应，柱状内部中央" value="inside"></el-option>
              <el-option label="柱状外的正上方" value="top"></el-option>
              <el-option label="柱状外的正下方" value="bottom"></el-option>
              <el-option label="柱状外的左边" value="left"></el-option>
              <el-option label="柱状外的右边" value="right"></el-option>
            </el-select>
          </el-form-item>
        </el-form>

        <el-form  :model="colorInline" class="demo-form-inline">
          <el-form-item  v-for="(color, index) in colorInline.color1"
                         :label="'条带' + index + '颜色'"
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
        &nbsp;&nbsp;&nbsp;&nbsp;输入关联分析数据或其他数据绘制桑基图，支持双坐标轴、三坐标轴、四坐标轴、五坐标轴等多轴类型的桑基图。<br>
        <br>

        <h2>输入：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;（格式说明：支持txt(制表符分隔)文本文件）<br>
        &nbsp;&nbsp;&nbsp;&nbsp;绘制几坐标桑基图，就输入几列数据，最后一列为数据频数<br>

        &nbsp;&nbsp;&nbsp;&nbsp;上传拥有表头的数据文件，且表头位于第一行。支持txt(制表符分隔)文本文件。数据与数据间以制表符分开（Tab键）,不能用空格，制图时将以第一列为x轴<br>
        <br>

        <h2>参数：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;自定义颜色：在右边颜色框中选择想要绘图的颜色，建议选择3种或更多<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;透明度：定义条带的透明度，值越小越透明<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;条带变化曲率：表示条带的弯曲程度。值越小，表示条带弯曲程度越小，等于0时，没有弯曲度；值越大，表示条带弯曲程度越大<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;标题：自定义给桑基图添加图形标题<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;标题字体大小：默认15<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;方格名称是否显示：默认为显示<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;方格名称字体大小：默认为10<br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;方格名称显示位置：默认显示在右侧<br>
        <br>

        <h2>输出：<br></h2>
        &nbsp;&nbsp;&nbsp;&nbsp;提供SVG格式的图片下载<br>
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
export default {
  name: 'Sangji',
  data() {
    return{
      isloadfile:0, //用于判断是否重复提交
      chartInstance:null,
      fileData:null, //读取的数据

      formData: new FormData(),
      formInline: {
        file: '',
        title: 'Sankey',
        sizetitle: 15,
        sizelabel: 10,
        showlabel: 'true',
        position: 'right',
        opacity: 0.7,
        curveness: 0.5,
        no: '',
      },

      historyid: '',

      colorInline: {
        color1: [{
          color: ''
        }],
        color2: '',
        color3: '',
      },

      //用户输入
      title:'Sankey Diagram', //标题--'Dynamic Stack Graph'
      sizeoftitle: 15,//标题字体大小
      sizeoflabel: 10,//各方格名称字体大小（标签）
      showoflabel: true,//方格名称是否显示
      positionoflabel: 'right',//各方格名称显示位置，inside(自适应，柱状内部中央),top（柱状外的正上方）,bottom(柱状外的正下方)，left(柱状外的左边)，right(柱状外的右边)
      colorofdatafromuser: [],//['#FFFF00', '#FF0000', '#0000FF'],//用户自定义颜色
      opacityofline: 0.5,//条带透明度
      curvenessofline: 0.5,//条带曲率

      colordata: ['#FF0000', '#90d7ec', '#45b97c', '#145b7d',
        '#F0E675', '#ED8F60', '#BF406A', '#692A6F',
        '#5B00AE', '#921AFF', '#AE00AE', '#FF44FF',
        '#0000C6', '#02C874', '#8B6971', '#009AC0'], //分组颜色--用户未自定义颜色则使用
      labelname:[],//y轴标签
      sankeydata:[],//sankey数据名称
      sankeylink:[],//连接关系
    }
  },

  mounted() {
    this.init_chart();

    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Sankey' + this.formInline.no
  },
  methods: {
    file1(){
      // window.open('https://www.baidu.com/','_blank')
      window.open(this.Host.BASE_URL + 'public/BaseFunction/sankey/sankey.txt','_blank')
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
          url: this.Host.BASE_URL + 'BaseFunction/sankey/multiUpload',
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
              url: this.Host.BASE_URL + 'BaseFunction/sankey/save',
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

        if(_this.formInline.opacity!==''){
          _this.opacityofline = Number(_this.formInline.opacity)
        }

        if(_this.formInline.curveness!==''){
          _this.curvenessofline = Number(_this.formInline.curveness)
        }

        if(_this.formInline.sizelabel!==''){
          _this.sizeoflabel = Number(_this.formInline.sizelabel)
        }

        if(_this.formInline.sizetitle!==''){
          _this.sizeoftitle = Number(_this.formInline.sizetitle)
        }

        if(_this.formInline.showlabel!==''){
          if (_this.formInline.showlabel==='true'){
            _this.showoflabel = true
          }else {
            _this.showoflabel = false
          }
        }

        if(_this.formInline.position!==''){
          _this.positionoflabel = _this.formInline.position
        }

        for (let i = 0; i < _this.colorInline.color1.length; i++){
          if(_this.colorInline.color1[i].color!=null){
            _this.colorofdatafromuser[i] = _this.colorInline.color1[i].color
          }
        }

        console.log(_this.title)
        console.log(_this.sizeoftitle)
        console.log(_this.sizeoflabel)
        console.log(_this.showoflabel)
        console.log(_this.positionoflabel)
        console.log(_this.colorofdatafromuser)
        console.log(_this.opacityofline)
        console.log(_this.curvenessofline)

        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          _this.chartInstance.showLoading();
          _this.init_fileData(_this.fileData);
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
      _this.chartInstance = this.$echarts.init(document.getElementById("echart1"),null,{renderer:'svg'});
    },

    init_fileData(fileData){
      let _this = this;
      let data_line=fileData.split("\n");//将文件按行划分并存入data_line
      let data_names=data_line[0].split("\t");//将文件首行的列名划分并存入data_names

      //将列名存入全局变量labelname中
      for(let i=0;i<data_names.length;i++){
        _this.labelname.push(data_names[i]);
      }

      //获取所有名称——sankeydata
      let s = new Set();
      for(let i=1;i<data_line.length;i++){
        let line_data = data_line[i].split("\t");
        for(let j=0;j<line_data.length-1;j++){
          s.add(line_data[j]);
        }
      }
      //_this.sankeydata = Array.from(s); //Set转换为数组
      let template = [];
      s.forEach(t => {
        template.push(t)
      })

      //加入颜色
      let color;
      //若用户未自定义颜色，则使用colordata
      if(_this.colorofdatafromuser.length === 0){
        color = _this.colordata;
      }
      else{
        color = _this.colorofdatafromuser;
      }
      let l = color.length;//颜色数量
      for(let i=0;i<template.length;i++){
        _this.sankeydata.push({
          name:template[i],
          itemStyle: {
            color: color[i%l]//通过取余循环使用color中的颜色
          }
        })
      }

      //关系——sankeylink--支持2、3、4、5轴
      if(data_names.length === 3){ //双轴
        for(let i=1;i<data_line.length;i++){
          let line_data = data_line[i].split("\t");
          _this.sankeylink.push({
            source:line_data[0],
            target:line_data[1],
            value:line_data[2]
          })
        }
      }
      else if(data_names.length === 4){ //三轴
        for(let i=1;i<data_line.length;i++){
          let line_data = data_line[i].split("\t");
          _this.sankeylink.push({
            source:line_data[0],
            target:line_data[1],
            value:line_data[3]
          })
          _this.sankeylink.push({
            source:line_data[1],
            target:line_data[2],
            value:line_data[3]
          })
        }
      }
      else if(data_names.length === 5){ //四轴
        for(let i=1;i<data_line.length;i++){
          let line_data = data_line[i].split("\t");
          _this.sankeylink.push({
            source:line_data[0],
            target:line_data[1],
            value:line_data[4]
          })
          _this.sankeylink.push({
            source:line_data[1],
            target:line_data[2],
            value:line_data[4]
          })
          _this.sankeylink.push({
            source:line_data[2],
            target:line_data[3],
            value:line_data[4]
          })
        }
      }
      else if(data_names.length === 6){ //五轴
        for(let i=1;i<data_line.length;i++){
          let line_data = data_line[i].split("\t");
          _this.sankeylink.push({
            source:line_data[0],
            target:line_data[1],
            value:line_data[5]
          })
          _this.sankeylink.push({
            source:line_data[1],
            target:line_data[2],
            value:line_data[5]
          })
          _this.sankeylink.push({
            source:line_data[2],
            target:line_data[3],
            value:line_data[5]
          })
          _this.sankeylink.push({
            source:line_data[3],
            target:line_data[4],
            value:line_data[5]
          })
        }
      }
      else{
        console.log("数据格式错误");
      }
    },

    update_chart(){
      let _this = this;
      _this.chartInstance.hideLoading();
      const option= {
        toolbox: { //工具
          feature: {
            mark: {show: true},
            dataZoom: {show: true}, //数据区域缩放
            restore: {show: true}, //重置
          }
        },

        title: {
          text: _this.title,
          fontsize: _this.sizeoftitle
        },
        tooltip: {
          trigger: 'item',
          triggerOn: 'mousemove'
        },

        series: [{
          type: 'sankey',
          emphasis: {
            focus: 'adjacency'
          },
          data: _this.sankeydata,
          links: _this.sankeylink,
          lineStyle: {
            normal: {
              color: 'source',
              curveness: _this.curvenessofline, //设置边的曲度
              opacity: _this.opacityofline  //设置边的透明度
            }
          },
          label:{
            show: _this.showoflabel,
            fontsize: _this.sizeoflabel,
            position: _this.positionoflabel
          }

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

