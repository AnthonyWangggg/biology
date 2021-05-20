import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import Home from '@/components/Home'
import Tool from '@/components/Tool'
import Login from '@/components/Login'
import Register from '@/components/Register'
import Person from '@/components/Person'
import Progress from '@/components/Progress'
import Submit from '@/components/Submit'
import Mianji from '@/Jichu/Mianji'
import Zhuzhuang from '@/Jichu/Zhuzhuang'
import Qipao from '@/Jichu/Qipao'
import Zhexian from '@/Jichu/Zhexian'
import Sandian from '@/Jichu/Sandian'
import Jizuobiao from '@/Jichu/Jizuobiao'
import Hezhuang from '@/Jichu/Hezhuang'
import ThreeD from '@/Jichu/ThreeD'
import Bing from '@/Jichu/Bing'
import Fengqun from '@/Jichu/Fengqun'
import Gaoqi from '@/Jichu/Gaoqi'
import Krona from '@/Jichu/Krona'
import MA from '@/Jichu/MA'
import Pinglv from '@/Jichu/Pinglv'
import Re from '@/Jichu/Re'
import Doujia from '@/Jichu/Doujia'
import Xianhui from '@/Jichu/Xianhui'
import Circos from '@/Jichu/Circos'
import FenQing from '@/Jichu/FenQing'
import Xiaotiqing from '@/Jichu/Xiaotiqing'
import Quanwang from '@/Jichu/Quanwang'
import Youwang from '@/Jichu/Youwang'
import Sanyuan from '@/Jichu/Sanyuan'
import Weien from '@/Jichu/Weien'
import Svg from '@/Biaoge/Svg'


Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home,
      //redirect: '/Login',
      meta: {
        isLogin: false
      }
    },
    {
      path: '/Hello',
      name: 'HelloWorld',
      component: HelloWorld,
      meta: {
        isLogin: true
      }
    },
    {
      path: '/Home',
      name: 'Home',
      component: Home,
      // redirect: '/Login',
      meta: {
        isLogin: false
      }
    },
    {
      path: '/Tool',
      name: 'Tool',
      component: Tool,
      meta: {
        isLogin: false
      },
    },
    {
      path: '/Login',
      name: 'Login',

      component: Login,
      meta: {
        isLogin: false
      }
    },
    {
      path: '/Register',
      name: 'Register',
      component: Register,
      meta: {
        isLogin: false
      }
    },
    {
      path: '/Person',
      name: 'Person',
      component: Person,
      meta: {
        isLogin: true
      }
    },
    {
      path: '/Progress',
      name: 'Progress',
      component: Progress,
      meta: {
        isLogin: false
      }
    },
    {
      path: '/Submit',
      name: 'Submit',
      component: Submit,
      meta: {
        isLogin: false
      }
    },

    {
      path:'/Tool/Mianji',
      name: 'Mianji',
      component:Mianji,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Zhuzhuang',
      name: 'Zhuzhuang',
      component:Zhuzhuang,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Qipao',
      name: 'Qipao',
      component:Qipao,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Zhexian',
      name: 'Zhexian',
      component:Zhexian,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Sandian',
      name: 'Sandian',
      component:Sandian,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Jizuobiao',
      name: 'Jizuobiao',
      component:Jizuobiao,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Hezhuang',
      name: 'Hezhuang',
      component:Hezhuang,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/ThreeD',
      name: 'ThreeD',
      component:ThreeD,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Bing',
      name: 'Bing',
      component:Bing,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Fengqun',
      name: 'Fengqun',
      component:Fengqun,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Gaoqi',
      name: 'Gaoqi',
      component:Gaoqi,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Krona',
      name: 'Krona',
      component:Krona,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/MA',
      name: 'MA',
      component:MA,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Pinglv',
      name: 'Pinglv',
      component:Pinglv,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Re',
      name: 'Re',
      component:Re,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Doujia',
      name: 'Doujia',
      component:Doujia,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Xianhui',
      name: 'Xianhui',
      component:Xianhui,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Circos',
      name: 'Circos',
      component:Circos,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/FenQing',
      name: 'FenQing',
      component:FenQing,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Xiaotiqing',
      name: 'Xiaotiqing',
      component:Xiaotiqing,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Quanwang',
      name: 'Quanwang',
      component:Quanwang,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Youwang',
      name: 'Youwang',
      component:Youwang,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Sanyuan',
      name: 'Sanyuan',
      component:Sanyuan,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Weien',
      name: 'Weien',
      component:Weien,
      meta: {
        isLogin: false
      },
    },


    {
      path:'/Tool/Svg',
      name: 'Svg',
      component:Svg,
      meta: {
        isLogin: false
      },
    },


  ]
})
