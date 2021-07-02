<template>
  <div id="zong">
    <div id="backimg"></div>
    <div class="card">
      <div class="box1">
        登录
      </div>
      <hr>
      <div class="box3">
        没有账号，点击<router-link id="Register" to="/Register">注册</router-link>
      </div>
      <div class="box2">
        <el-form :model="ruleForm" status-icon :rules="rules" ref="ruleForm" label-width="100px" class="demo-ruleForm" id="block" :label-position="labelPosition" >
          <el-form-item label="邮箱" prop="account" id="ei">
            <el-input prefix-icon="el-icon-user-solid" v-model="ruleForm.account"></el-input>
          </el-form-item>
          <el-form-item label="密码" prop="pass" id="eis">
            <el-input prefix-icon="el-icon-key" type="password" v-model="ruleForm.pass" autocomplete="off"></el-input>
          </el-form-item>
          <el-form-item id="but">
            <el-button type="primary" @click="submitForm('ruleForm')">登录</el-button>
            <el-button @click="resetForm('ruleForm')">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
    <!--
    http://10.13.1.7:8081/login
    -->
  </div>
</template>

<script>
import Vue from 'vue'
import {Input,Button,Divider} from 'element-ui'
import axios from 'axios'
import * as qs from 'qs'
Vue.use(Input)
Vue.use(Button)

Vue.use(Divider)

export default {
  name: 'Login',
  data() {
    var checkAccount = (rule, value, callback) => {
      const mailReg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/
      if (!value) {
        return callback(new Error('邮箱不能为空'));
      }
      setTimeout(() => {
        if (mailReg.test(value)) {
          callback()
        } else {
          callback(new Error('请输入正确的邮箱格式'))
        }
      }, 100)
    };
    var validatePass = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请输入密码'));
      } else {
        if (this.ruleForm.checkPass !== '') {
          this.$refs.ruleForm.validateField('checkPass');
        }
        if(!/^(?![\d]+$)(?![a-zA-Z]+$)(?![^\da-zA-Z]+$)([^\u4e00-\u9fa5\s]){9,16}$/.test(value)) {
          callback(new Error('请输入10-16位英文字母、数字或者符号(除空格)，且字母、数字和标点符号至少包含两种'))

        }
        callback();
      }
    };

    return {
      labelPosition:'right',
      userToken: '',
      ruleForm: {
        pass: '',
        account: '',
      },
      zhud:false,
      loading:false,
      rules: {
        pass: [
          { validator: validatePass, trigger: 'blur' }
        ],
        account: [
          { validator: checkAccount, trigger: 'blur' }
        ]
      }
    };
  },
  methods: {
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          console.log(this.ruleForm.account+this.ruleForm.pass)
          let _data = {
            email:this.ruleForm.account,
            password:this.ruleForm.pass,
          }
          axios.post(
            this.Host.BASE_URL  + 'login',
            qs.stringify(_data)
          ).then(res=>{
            console.log(res)
            if(res.data.data === 'Success'){
              this.$store.dispatch("setUser", true);
              //Vuex在用户刷新的时候userLogin会回到默认值false，所以我们需要用到HTML5储存
              //我们设置一个名为Flag，值为isLogin的字段，作用是如果Flag有值且为isLogin的时候，证明用户已经登录了。
              localStorage.setItem("Flag", "isLogin");
              //iViewUi的友好提示
              sessionStorage.setItem("userName",this.ruleForm.account);
              // sessionStorage.setItem("userToken",)
              // this.$store.dispatch("setUser",this.ruleForm.account);
              // this.$store.dispatch("setToken",)
              // console.log(this.$store.state.isLogin)

              this.userToken = res.data.jwtToken;
              localStorage.setItem("token", this.userToken);
              // this.changeLogin({ Authorization:this.userToken });

              this.$message.success('登录成功');
              // this.$router.go(-1);
              this.$router.replace('Home');
            } else if(res.data === '账号不存在'){
              this.$message('账号不存在');
            } else if(res.data ==='密码错误'){
              this.$message('密码错误');
            }else{
              this.$message('异常');
            }
          })


        } else {
          console.log('error submit!!');
          return false;
        }
      });
    },

    resetForm(formName) {
      this.$refs[formName].resetFields();
    }
  }
}
</script>

<style scoped>
#zong{
  width: 100%;
  height: 100%;
  position: absolute;
  background-color: rgba(255, 255, 255, 0.2);
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
.box1{
  width: 100%;
  height: 30%;
  text-align: center;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 2rem;
  color: #ececec;
}
.box2{
  width: 100%;
  height: 70%;
}
.box3{
  padding-right: 1rem;
  text-align: right;
  color: #ececec;
}
#Register{
  color: #409EFF;
}
a{
  text-decoraction: none;
}
.router-link-active {
  text-decoration: none;
}
.card{
  position: absolute;
  top:0;
  left:0;
  bottom:0;
  right:0;
  width:30%;
  height:70%;
  margin:auto;
  background-color: rgba(0, 0, 0, 0.5);
  border-radius:40px;
}
#block{
  text-align:center
}

.box2 .el-form-item__label{
  color: #ececec!important;
}

#ei{
  margin: 5% 15% 10% 5%;
}
#eis{
  margin: 10% 15% 10% 5%;
}
#but{
  margin: 15% 25% 10% 5%!important;
}
</style>
<style>
.el-form-item__label{
  color: #ececec!important;
}
</style>
