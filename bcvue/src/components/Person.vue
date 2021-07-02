<template>
<div id="zong">
  <div id="backimg"></div>
  <div class="box">
    <div class="c1">
      <div class="cc1">
        <img src="https://cube.elemecdn.com/9/c2/f0ee8a3c7c9638a54940382568c9dpng.png">
      </div>
      <div class="cc2">
        {{ names }}
      </div>
      <div class="cc3">
        <el-button type="danger" icon="el-icon-close" round @click="logout">退出登录</el-button>
      </div>
    </div>
    <div class="c2">
      <el-tabs type="border-card" @tab-click="choose" v-model="activeTab">
        <el-tab-pane label="历史管理" name="first">历史管理</el-tab-pane>
        <el-tab-pane label="账号管理" name="second">账号管理</el-tab-pane>
      </el-tabs>
      <el-scrollbar style="height:80%"> <!-- 滚动条 -->
      <div class="history" v-show="flags===0">
        <el-main>
          <el-table :data="tableData">
            <el-table-column prop="dataname" label="日期" width="140">
            </el-table-column>
            <el-table-column prop="historyid" label="名称" width="120">
            </el-table-column>
            <el-table-column  label="资源">
              <template slot-scope="scope">
                <p v-for="(item,i) in scope.row.picpaths" >
                  <el-link icon="el-icon-view" :href="item" target="_blank" class="buttonText">文件</el-link>
                </p>
<!--                <a v-for="(item,index) of scope.row.picpaths" :key="item.id" :href="scope.row.picpaths" target="_blank" class="buttonText">{{item.id}}</a>-->
              </template>
            </el-table-column>
          </el-table>
        </el-main>
      </div>
      <div class="inform" v-show="flags===1">
      </div>
      </el-scrollbar>
    </div>

  </div>
</div>
</template>

<script>
export default {
name: "Person",
  created () {
    this.flags = 0;

    this.names = sessionStorage.getItem("userName")

    this.$axios({
      url: this.Host.BASE_URL  + 'user/histories',
      method: 'get',
      timeout: 6000,
      headers: {
        'Authorization': localStorage.getItem("token")
      },
    }).then((res)=>{
      console.log(res)
      if(res.data==='token过期'){
        localStorage.removeItem("Flag")
        localStorage.removeItem("token")
        this.$router.replace('Login');
      }else{
        this.inform = res.data

        for(let i = 0; i < this.inform.length; i++){
          var p = this.inform[i].picname.split(',')
          for (let j = 0; j < p.length; j++){
            p[j] = this.Host.BASE_URL  + 'public/' + this.inform[i].email + '/' + p[j]
          }
          console.log(p)
          this.inform[i].picpaths = p
          // let tempList = []
          // this.inform[i].picpath = this.Host.BASE_URL  + 'public/' + this.inform[i].email + '/' + p[0]
          // for (let j = 0; j < p.length; j++){
          //   let s = this.Host.BASE_URL  + 'public/' + this.inform[i].email + '/' + p[j]
          //   console.log(s)
          //   this.inform[i].picpaths.push(s)
          //   // tempList.push(s)
          //   // this.inform[i].picpaths.push(this.Host.BASE_URL  + 'public/' + this.inform[i].email + '/' + p[j])
          // }
          // this.inform[i].picpath = this.Host.BASE_URL  + 'public/' + this.inform[i].picname
          let time = this.inform[i].dataname.split('_')
          this.inform[i].dataname = time[0]
          // var person = {v:'urls', test:tempList};
          // this.inform[i].push(person)
        }
        console.log(this.inform)
        this.tableData = this.inform
        console.log(this.tableData)
      }
    })

      // function (error) {
      //   // 对响应错误做点什么
      //   console.log(error.response.status)
      //   if (error.response.status === 401) {
      //     localStorage.removeItem("Flag")
      //     localStorage.removeItem("token")
      //     this.$router.replace('Login');
      //   }
      // },
      .catch((error) => {
        console.log(error.message);
        if (error.response.status === 401) {
          localStorage.removeItem("Flag")
          localStorage.removeItem("token")
          this.$router.replace('Login');
          this.$message.error('登录过期');
        }else if (error.message === 'timeout of 6000ms exceeded') {
          console.log('111')
          this.$message.error('请求超时，检查网络');
        }
      })
  },

  mounted:function(){

  },
  methods: {
  choose(tab,event){
    if(tab.name === 'first'){
      this.part1();
    }else {
      this.part2();
    }
  },
    part1(){
      this.flags=0;
      console.log(this.flags)
    },
    part2(){
      this.flags=1;
      console.log(this.flags)
    },
    logout(){
      localStorage.removeItem("Flag")
      localStorage.removeItem("token")
      this.$router.push("/Home");
    }
  },
  data() {
    // const item = {
    //   date: '2016-05-02',
    //   name: '文件名',
    //   address: '图片地址'
    // };
    return {
      flags: 0,
      names:'',
      activeTab: 'first',
      //tableData: Array(8).fill(item),
      inform:[{
        dataname: '',
        historyid: '',
        picpaths: [],
      }],
      tableData:[],
      urls: []
    }
  },
}
</script>

<style scoped>
#zong{
  width: 100%;
  height: 100%;
  position: absolute;
  background-color: rgba(255, 255, 255, 0.5);
}
#backimg {
  background: url('../assets/back.png');
  width: 100%;
  height: 100%;
  position: absolute;
  z-index: -1;
  background-size: cover;
  top: 0;
  left: 0;
}
.box{
  width: 70%;
  height: 600px;
  margin: 50px auto;
  display: flex;
}
.c1{
  width: 30%;
  height: 100%;
  background: #42b983;
  border-radius:40px 0 0 0;
  margin-right: 10px;
  display: table-cell;
  vertical-align: middle;
  text-align: center;
}
.cc1{
  width: 70%;
  height: 30%;
  margin: 5% auto;
  padding-top: 10%;
  vertical-align: middle;
  text-align: center;
}
.cc1 img{
  width: 60%;
  height: auto;
  border-radius:50%;
}
.cc2{
  width: 70%;
  height: 30%;
  margin: 0 auto;
  vertical-align: middle;
  text-align: center;
  font-size: 2em;
  padding-top: 5%;
}
.cc3{
  width: 70%;
  height: 10%;
  margin: 0 auto;
}
.c2{
  width: 70%;
  height: 100%;
  background: #ffffff;
  border-radius:0 40px 40px 0;
}
.history{
  width: 95%;
  height: 80%;

  margin: 5px auto;
}
.inform{
  width: 95%;
  height: 80%;
  background: #9a2f2f;
  margin: 5px auto;
}
</style>
<style>
.el-tabs--border-card{
  border-radius:0 40px 0 0!important;
}
.el-tabs__nav-scroll{
  border-radius:0 40px 0 0!important;
}
.el-tabs__nav-wrap{
  border-radius:0 40px 0 0!important;
}
.el-tabs--border-card>.el-tabs__header{
  border-radius:0 40px 0 0!important;
}
.el-scrollbar__wrap{
  overflow-x: hidden;
}
</style>
