<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>盒形图</h1>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="项目编号" id="b1">
            <el-input v-model="formInline.no" :placeholder="this.formInline.no" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="源文件1" v-show="flag>=0">
            <el-input  v-model="formInline.file" :placeholder="this.formInline.file" :readonly="true"></el-input>
            <el-button type="button" id="fileImport" v-on:click="clickLoad">选择上传的数据文件</el-button>
            <input type="file" id="files" ref="refFile" style="display: none"  v-on:change="fileLoad">
          </el-form-item>
          <el-form-item label="分组名1" v-show="flag>=0">
            <el-input v-model="formInline.group1" :placeholder="this.formInline.group1"></el-input>
          </el-form-item>
          <el-form-item label="源文件2" v-show="flag>=1">
            <el-input  v-model="formInline.file1" :placeholder="this.formInline.file1" :readonly="true"></el-input>
            <el-button type="button" id="fileImport1" v-on:click="clickLoad1">选择上传的数据文件</el-button>
            <input type="file" id="files1" ref="refFiles" style="display: none"  v-on:change="fileLoad1">
          </el-form-item>
          <el-form-item label="分组名2" v-show="flag>=1">
            <el-input v-model="formInline.group2" :placeholder="this.formInline.group2"></el-input>
          </el-form-item>
          <el-form-item label="源文件3" v-show="flag>=2">
            <el-input  v-model="formInline.file2" :placeholder="this.formInline.file2" :readonly="true"></el-input>
            <el-button type="button" id="fileImport2" v-on:click="clickLoad2">选择上传的数据文件</el-button>
            <input type="file" id="files2" ref="refFiless" style="display: none"  v-on:change="fileLoad2">
          </el-form-item>
          <el-form-item label="分组名3" v-show="flag>=2">
            <el-input v-model="formInline.group3" :placeholder="this.formInline.group3"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button @click="addForm">新增表格</el-button>
            <el-button @click="deletForm">删除表格</el-button>
          </el-form-item>
          <el-form-item label="Y轴范围">
            <el-col :span="5">
              <el-input v-model="formInline.min" placeholder="" style="width: 100%;"></el-input>
            </el-col>
            <el-col class="line" :span="1">&#8194;-&#8194; </el-col>
            <el-col :span="5">
              <el-input v-model="formInline.max" placeholder="" style="width: 100%;"></el-input>
            </el-col>
          </el-form-item>
<!--          <el-form-item label="横坐标文字倾斜角度">-->
<!--            <el-select v-model="formInline.angle" placeholder="水平">-->
<!--              <el-option label="水平°" value="0"></el-option>-->
<!--              <el-option label="25°" value="25"></el-option>-->
<!--              <el-option label="45°" value="45"></el-option>-->
<!--              <el-option label="75°" value="75"></el-option>-->
<!--              <el-option label="垂直" value="90"></el-option>-->
<!--            </el-select>-->
<!--          </el-form-item>-->
        </el-form>

        <el-form  :model="colorInline" class="demo-form-inline">
          <el-form-item  v-for="(color, index) in colorInline.color1"
                         :label="'文件' + index + '颜色'"
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
  name: 'Hezhuang',
  data() {
    return{
      flag: 0,
      isloadfile:0, //用于判断是否重复提交
      formData: new FormData(),
      formInline: {
        file: '',
        file1: '',
        file2: '',
        min: '1',
        max: '2',
        group1: 'group1',
        group2: 'group2',
        group3: 'group3',
        no: '',
      },
      colorInline: {
        color1: [{
          color: ''
        }],
        color2: '',
        color3: '',
      },
      para: {
        "historyid": '',
        "group_0": '',
        "color_1": '',
        "min_2": '',
        "max_3": '',
      },
      chartInstance:null,
      fileData:null, //读取的数据
      barColor:[],
      pic:'',
    }
  },
  mounted() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for(let i=0; i < 6; i++ ) {
      this.formInline.no += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    this.formInline.no = 'Box' + this.formInline.no
  },
  methods: {
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

    addForm() {
      if(this.flag<3){
        this.flag++
      }else{
        alert("最多三个表格")
      }
    },

    deletForm(){
      if(this.flag>0){
        this.flag--
      }else{
        alert("最少一个表格")
      }
    },

    chartCommit(){
      let _this = this;
      _this.isloadfile += 1;
      if(_this.isloadfile>1){
        alert("请勿重复提交");
      }else{
        //参数设置
        // if(_this.formInline.group1===''&&_this.formInline.group2===''&&_this.formInline.group3){
        //   _this.para.group_0 = 'c()'
        // }else{
        //   _this.para.group_0 ='c("'+_this.formInline.group1+'","'+_this.formInline.group2+'","'+_this.formInline.group3+'")'
        // }
        if(_this.flag===0){
          if(_this.formInline.group1===""){
            _this.para.group_0 = 'c()'
          }else{
            _this.para.group_0 = 'c("'+_this.formInline.group1+'")'
          }
        }else if (_this.flag===1){
          if(_this.formInline.group1===""&&_this.formInline.group2===""){
            _this.para.group_0 = 'c()'
          }else{
            _this.para.group_0 = 'c("'+_this.formInline.group1+'","'+_this.formInline.group2+'")'
          }
        }else if (_this.flag===2){
          if(_this.formInline.group1===""&&_this.formInline.group2===""&&_this.formInline.group3===""){
            _this.para.group_0 = 'c()'
          }else{
            _this.para.group_0 = 'c("'+_this.formInline.group1+'","'+_this.formInline.group2+'","'+_this.formInline.group3+'")'
          }
        }

        if(_this.formInline.min!==''){
          _this.para.min_2 = _this.formInline.min
        }

        if(_this.formInline.max!==''){
          _this.para.max_3 = _this.formInline.max
        }

        for (let i = 0; i < _this.colorInline.color1.length; i++){
          if(_this.colorInline.color1[i].color!=null){
            _this.barColor[i] = _this.colorInline.color1[i].color
          }
        }

        if(_this.barColor===""){
          _this.para.color_1 = 'c()'
        }else{
          for (let i = 0; i < _this.barColor.length; i++){
            if(i===0){
              _this.para.color_1 = 'c("' + _this.barColor[i] + '"'
            }else{
              _this.para.color_1 = _this.para.color_1 + ',"'+_this.barColor[i] + '"'
            }
          }
        }
        _this.para.color_1 = _this.para.color_1 + ')'


        if(_this.fileData == null){
          alert("文件不能为空");
        }else {
          console.log(_this.formData.get('file'))

          console.log(_this.para)
          _this.$axios({
            url: this.Host.BASE_URL + 'BaseFunction/box_line/multiUpload',
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
                url: this.Host.BASE_URL + 'BaseFunction/box_line/run',
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

    fileLoad1() {
      let _this = this;
      const selectedFiles = this.$refs.refFiles.files[0];
      _this.formData.append('files',selectedFiles);
      console.log(this.$refs.refFile.files)
      console.log(this.$refs.refFiles.files)
      _this.formInline.file1 = this.$refs.refFiles.files[0].name;
      let readers = new FileReader();
      readers.readAsText(selectedFiles);
      readers.onload = function () {
        _this.fileData=this.result;
        console.log(_this.fileData)
      }
    },

    fileLoad2() {
      let _this = this;
      const selectedFiless = this.$refs.refFiless.files[0];
      _this.formData.append('files',selectedFiless);
      console.log(this.$refs.refFile.files)
      console.log(this.$refs.refFiless.files)
      _this.formInline.file2 = this.$refs.refFiless.files[0].name;
      let readers = new FileReader();
      readers.readAsText(selectedFiless);
      readers.onload = function () {
        _this.fileData=this.result;
        console.log(_this.fileData)
      }
    },

    clickLoad() {
      let _this=this;
      _this.clear_data();
      this.$refs.refFile.dispatchEvent(new MouseEvent("click"));
    },

    clickLoad1() {
      let _this=this;
      _this.clear_data();
      this.$refs.refFiles.dispatchEvent(new MouseEvent("click"));
    },

    clickLoad2() {
      let _this=this;
      _this.clear_data();
      this.$refs.refFiless.dispatchEvent(new MouseEvent("click"));
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
