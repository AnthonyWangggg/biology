<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>高级气泡图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="自定义标题">
            <el-input v-model="formInline.title" :placeholder="formInline.title"></el-input>
          </el-form-item>
          <el-form-item label="源文件">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
          </el-form-item>
          <el-form-item>
            <el-form-item label="用于做图的行数">
              <el-input v-model="formInline.line" :placeholder="formInline.line"></el-input>
            </el-form-item>
          </el-form-item>
          <el-form-item label="输入文件的类型">
            <el-select v-model="formInline.type" :placeholder="formInline.type">
              <el-option label="type1" value="1"></el-option>
              <el-option label="type2" value="2"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="参数">
            <el-select v-model="formInline.paras" :placeholder="formInline.para">
              <el-option label="P-value" value="1"></el-option>
              <el-option label="Q-value" value="2"></el-option>
            </el-select>
          </el-form-item>
<!--          <el-form-item label="顺序">-->
<!--            <el-select v-model="formInline.order" placeholder="p/q值从小到大">-->
<!--              <el-option label="p/q值从小到大" value="0"></el-option>-->
<!--              <el-option label="p/q值从大到小" value="1"></el-option>-->
<!--            </el-select>-->
<!--          </el-form-item>-->
<!--          <el-form-item label="类型">-->
<!--            <el-select v-model="formInline.style" placeholder="GO">-->
<!--              <el-option label="GO°" value="0"></el-option>-->
<!--              <el-option label="KEGG°" value="1"></el-option>-->
<!--            </el-select>-->
<!--          </el-form-item>-->
        </el-form>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <!--<el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
        <el-button type="button" id="fileCommit" v-on:click="chartCommit">提交</el-button>
        <input type="file" id="files" ref="refFile" style="display: none" v-on:change="fileLoad">-->
      </div>
      <div id="rightbox"></div>
    </div>
    <div id="line">
      <h2>生成结果</h2>
    </div>
    <div id="echart1" v-show="pic!==''">
      <!--      <img src="http://10.13.1.130:8081/public/20210429222508_heatmap.png" />-->
      <img :src="pic" />
    </div>
  </div>

</template>

<script>

//echarts的容器长宽按此标准，最终下载的图片为1080P
// height: 432px;
// width: 768px;

export default {
  name: 'Gaoqi',
  data() {
    return{
      formData: new FormData(),
      formInline: {
        file: '',
        line: '',
        type: '1',
        title: 'seniorbubble',
        //style: '',
        no: '',
        paras: '1',

        //order: '',
      },
      para: {
        "historyid": '',
        "row_0": '',
        "type_1": '',
        "t1part_2": '',
        "t1all_3": '',
        "t1pw_4": '',
        "t1pv_5": '',
        "t2part_6": '',
        "t2all_7": '',
        "t2pw_8": '',
        "t2pv_9": '',
        "t2qv_10": '',
        "pqtype_11": '',
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
    this.formInline.no = 'Seniorbubble' + this.formInline.no
  },
  methods: {
    chartCommit(){
      let _this = this;

      //参数设置
      if(_this.formInline.line!==''){
        _this.para.row_0 =_this.formInline.line
      }

      if(_this.formInline.type!==''){
        _this.para.type_1 = _this.formInline.type
      }

      if(_this.formInline.paras!==''){
        _this.para.pqtype_11 = _this.formInline.paras
      }

      if(_this.formInline.type==='1'){
        _this.para.t1part_2 = '2'
        _this.para.t1all_3 = '3'
        _this.para.t1pw_4 = '1'
        _this.para.t1pv_5 = '4'

        _this.para.t2part_6 = 'NULL'
        _this.para.t2all_7 = 'NULL'
        _this.para.t2pw_8= 'NULL'
        _this.para.t2pv_9 = 'NULL'
        _this.para.t2qv_10 = 'NULL'
      }else if(_this.formInline.type==='2'){
        _this.para.t1part_2 = 'NULL'
        _this.para.t1all_3 = 'NULL'
        _this.para.t1pw_4 = 'NULL'
        _this.para.t1pv_5 = 'NULL'

        _this.para.t2part_6 = '2'
        _this.para.t2all_7 = '3'
        _this.para.t2pw_8= '1'
        _this.para.t2pv_9 = '4'
        _this.para.t2qv_10 = '5'
      }

      if(_this.fileData == null){
        alert("文件不能为空");
      }else {
        console.log(_this.formData.get('files'))

        _this.$axios({
          url: this.Host.BASE_URL  +'BaseFunction/seniorbubble/multiUpload',
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
          }else{
            _this.$axios({
              url: this.Host.BASE_URL  + 'BaseFunction/seniorbubble/run',
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
  height: auto;
  margin: 0 auto;
  display: flex;
  background: #409EFF;
}
#leftbox{
  width: 50%;
  height: auto;
  background: white;
  padding: 5px 15px 10px 15px;
  border-radius:40px 0 0 40px;
}
#rightbox{
  width: 50%;
  height: 100%;
  background: #c1c1c1;
  padding: 5px 15px 10px 15px;
  border-radius:0 40px 40px 0;
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
</style>

<style>
.element.style{
  height: 0!important;
}
html,body {
  width: 100%;
  height: auto;
}
</style>
