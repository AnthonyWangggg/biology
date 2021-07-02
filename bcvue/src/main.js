// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
Vue.config.productionTip = false

import * as echarts from 'echarts'
Vue.prototype.$echarts = echarts

import axios from 'axios'
import QS from 'qs';
Vue.prototype.$axios = axios    //全局注册，使用方法为:this.$axios
Vue.prototype.qs = QS           //全局注册，使用方法为:this.QS

Vue.use(ElementUI)

import md5 from 'js-md5'
Vue.prototype.$md5 = md5

import _host from './host.vue'
Vue.prototype.Host = _host

Vue.prototype.$publicURL = './';

/*import Vuex from 'vuex'
Vue.use( Vuex );
const store = new Vuex.Store({

  // 设置属性
  state: {
    isLogin: false,
  },

  // 获取属性的状态
  getters: {
    //获取登录状态
    isLogin: state => state.isLogin,
  },

  // 设置属性状态
  mutations: {
    //保存登录状态
    userStatus(state, flag) {
      state.isLogin = flag
    },
  },

  // 应用mutations
  actions: {
    //获取登录状态
    setUser ({commit}, flag) {
      commit("userStatus", flag)
    },
  }
});*/

router.beforeEach((to, from, next) => {
  //获取用户登录成功后储存的登录标志
  let getFlag = localStorage.getItem("Flag");
  //如果登录标志存在且为isLogin，即用户已登录
  if(getFlag === "isLogin"){
    //设置vuex登录状态为已登录
    store.state.isLogin = true
    next()
    //如果已登录，还想想进入登录注册界面，则定向回首页
    // if (!to.meta.isLogin) {
    //   //iViewUi友好提示
    //   message.error('请先退出登录')
    //   next({
    //     path: '/Home'
    //   })
    // }
    //如果登录标志不存在，即未登录
  }else{
    //用户想进入需要登录的页面，则定向回登录界面
    if(to.meta.isLogin){
      next({
        path: '/Login',
      })
      //iViewUi友好提示
      message.info('请先登录')
      //用户进入无需登录的界面，则跳转继续
    }else{
      next()
    }
  }
});

router.afterEach(route => {
  window.scroll(0, 0);
});

// router.beforeEach((to, from, next) => {
//   if (to.path === '/Login') {
//     next();
//   } else {
//     let token = localStorage.getItem('Authorization');
//
//     if (token === null || token === '') {
//       next('/Login');
//     } else {
//       next();
//     }
//   }
// });
//
//
// axios.interceptors.request.use(
//   config => {
//     if (localStorage.getItem('Authorization')) {
//       config.headers.Authorization = localStorage.getItem('Authorization');
//     }
//
//     return config;
//   },
//   error => {
//     return Promise.reject(error);
//   });

//axios.defaults.withCredentials = true,

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store:store,
  //render: function (h) { return h(App) },
  components: { App },
  template: '<App/>',
})
