import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

var state = {
    isLogin: false,
  // 存储token
  //Authorization: localStorage.getItem('Authorization') ? localStorage.getItem('Authorization') : ''
  }

  // 获取属性的状态,似于vue中的computed
var getters = {
    //获取登录状态
    isLogin: state => state.isLogin,
  }

  // 设置属性状态,改变state里面的数据
var mutations = {
    //保存登录状态
    userStatus(state, flag) {
      state.isLogin = flag
    },
  // 修改token，并将token存入localStorage
  // changeLogin (state, user) {
  //   state.Authorization = user.Authorization;
  //   localStorage.setItem('Authorization', user.Authorization);
  // }
  }

  // 应用mutations
var actions = {
    //获取登录状态
    setUser ({commit}, flag) {
      commit("userStatus", flag)
    }
  }

//实例化vuxe.store
const store = new Vuex.Store({
  state:state,
  mutations:mutations,
  getters:getters,
  actions:actions,
})

//抛出暴露
export default store;
