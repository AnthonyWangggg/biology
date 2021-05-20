<template>
<div id="zong">
  <div class="box2">
    <el-form :model="ruleForm" status-icon :rules="rules" ref="ruleForm" label-width="100px" class="demo-ruleForm" id="block" :label-position="labelPosition">
      <el-form-item label="单号" prop="pass" id="p1">
        <el-input type="password" v-model="ruleForm.pass" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="时间" prop="checkPass" id="p2">
        <el-input type="password" v-model="ruleForm.checkPass" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="单位" prop="age" id="p3">
        <el-input v-model="ruleForm.age"></el-input>
      </el-form-item>
      <el-form-item label="姓名" prop="name" id="p4">
        <el-input v-model="ruleForm.name"></el-input>
      </el-form-item>
      <el-form-item label="顺丰号" prop="sf" id="p5">
        <el-input v-model="ruleForm.sf"></el-input>
      </el-form-item>
      <el-form-item label="邮箱" prop="mail" id="p6">
        <el-input v-model="ruleForm.mail"></el-input>
      </el-form-item>
      <el-form-item label="验证码" prop="code" id="p7">
        <el-input v-model="ruleForm.code"></el-input>
      </el-form-item>
      <el-form-item label="手机号" prop="phone" id="p8">
        <el-input v-model="ruleForm.phone"></el-input>
      </el-form-item>
      <el-form-item label="项目负责人" prop="people" id="p9">
        <el-input v-model="ruleForm.people"></el-input>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="submitForm('ruleForm')">提交</el-button>
        <el-button @click="resetForm('ruleForm')">重置</el-button>
      </el-form-item>
    </el-form>
  </div>
</div>
</template>

<script>
export default {
name: "Submit",
  data() {
    var checkAge = (rule, value, callback) => {
      if (!value) {
        return callback(new Error('年龄不能为空'));
      }
      setTimeout(() => {
        if (!Number.isInteger(value)) {
          callback(new Error('请输入数字值'));
        } else {
          if (value < 18) {
            callback(new Error('必须年满18岁'));
          } else {
            callback();
          }
        }
      }, 1000);
    };
    var validatePass = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请输入密码'));
      } else {
        if (this.ruleForm.checkPass !== '') {
          this.$refs.ruleForm.validateField('checkPass');
        }
        callback();
      }
    };
    var validatePass2 = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请再次输入密码'));
      } else if (value !== this.ruleForm.pass) {
        callback(new Error('两次输入密码不一致!'));
      } else {
        callback();
      }
    };
    var checkName = (rule, value, callback) => {

    };
    var checkSf = (rule, value, callback) => {

    };
    var checkMail = (rule, value, callback) => {

    };
    var checkCode = (rule, value, callback) => {

    };
    var checkPhone = (rule, value, callback) => {

    };
    var checkPeople = (rule, value, callback) => {

    };
    return {
      labelPosition:'right',
      ruleForm: {
        pass: '',
        checkPass: '',
        age: '',
        name: '',
        sf: '',
        mail: '',
        code: '',
        phone: '',
        people: '',
      },
      rules: {
        pass: [
          { validator: validatePass, trigger: 'blur' }
        ],
        checkPass: [
          { validator: validatePass2, trigger: 'blur' }
        ],
        age: [
          { validator: checkAge, trigger: 'blur' }
        ],
        name: [
          { validator: checkName, trigger: 'blur' }
        ],
        sf: [
          { validator: checkSf, trigger: 'blur' }
        ],
        mail: [
          { validator: checkMail, trigger: 'blur' }
        ],
        code: [
          { validator: checkCode, trigger: 'blur' }
        ],
        phone: [
          { validator: checkPhone, trigger: 'blur' }
        ],
        people: [
          { validator: checkPeople, trigger: 'blur' }
        ]
      }
    };
  },
  methods: {
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          alert('submit!');
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
.box2{
  position: absolute;
  top:0;
  left:0;
  bottom:0;
  right:0;
  width:80%;
  height:90%;
  margin:auto;
  background-color: rgba(0, 0, 0, 0.5);
  border-radius:40px;
}
#p1{

}
#p2{

}
#p3{

}
#p4{

}
#p5{

}
#p6{

}
#p7{

}
#p8{

}
#p9{

}
</style>
