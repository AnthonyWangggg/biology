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
import Gaosan from '@/Jichu/Gaosan'
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
import Huoshan from '@/Jichu/Huoshan'
import Erre from '@/Jichu/Erre'
import ErreLetter from '@/Jichu/ErreLetter'
import Sangji from '@/Jichu/Sangji'
import UpSet from '@/Jichu/UpSet'
import Duanzhou from '@/Jichu/Duanzhou'

import Svg from '@/Biaoge/Svg'
import Erhebing from '@/Biaoge/Erhebing'
import SAM from '@/Biaoge/SAM'
import Shaixuan from '@/Biaoge/Shaixuan'
import Fqtfa from '@/Biaoge/Fqtfa'

import ZujianRe from '@/Dongtai/ZujianRe'
import ZuneiRe from '@/Dongtai/ZuneiRe'
import Dongsan from '@/Dongtai/Dongsan'
import DongCircos from '@/Dongtai/DongCircos'
import DongUpSet from '@/Dongtai/DongUpSet'
import Donghuo from '@/Dongtai/Donghuo'
import DongROC from '@/Dongtai/DongROC'
import DongZhe from '@/Dongtai/DongZhe'
import Dongdui from '@/Dongtai/Dongdui'

import Tsne from '@/Julei/Tsne'
import NMDS from '@/Julei/NMDS'
import PCOA from '@/Julei/PCOA'
import PCA from '@/Julei/PCA'
import PCAtD from '@/Julei/PCAtD'
import HCA from '@/Julei/HCA'
import CCA from '@/Julei/CCA'

import XiangxianER from '@/Tongji/XiangxianER'
import XiangxianDUO from '@/Tongji/XiangxianDUO'
import ZhuER from '@/Tongji/ZhuER'
import ZhuDUO from '@/Tongji/ZhuDUO'
import Anosim from '@/Tongji/Anosim'
import Adonis from '@/Tongji/Adonis'
import Duozu from '@/Tongji/Duozu'

import XulieLength from '@/Xulie/XulieLength'

import Fuquan from '@/Gongneng/Fuquan'
import Fuchaqi from '@/Gongneng/Fuchaqi'
import KEGGFuchaqi from '@/Gongneng/KEGGFuchaqi'
import DOFuchaqi from '@/Gongneng/DOFuchaqi'
import DOFufen from '@/Gongneng/DOFufen'
import KEGGFufen from '@/Gongneng/KEGGFufen'
import COG from '@/Gongneng/COG'

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

    //基础绘图
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
      path:'/Tool/Huoshan',
      name: 'Huoshan',
      component:Huoshan,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Gaosan',
      name: 'Gaosan',
      component:Gaosan,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Erre',
      name: 'Erre',
      component:Erre,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/ErreLetter',
      name: 'ErreLetter',
      component:ErreLetter,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Sangji',
      name: 'Sangji',
      component:Sangji,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/UpSet',
      name: 'UpSet',
      component:UpSet,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Duanzhou',
      name: 'Duanzhou',
      component:Duanzhou,
      meta: {
        isLogin: false
      },
    },



    //表格与格式转换
    {
      path:'/Tool/Svg',
      name: 'Svg',
      component:Svg,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Erhebing',
      name: 'Erhebing',
      component:Erhebing,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/SAM',
      name: 'SAM',
      component:SAM,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Shaixuan',
      name: 'Shaixuan',
      component:Shaixuan,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Fqtfa',
      name: 'Fqtfa',
      component:Fqtfa,
      meta: {
        isLogin: false
      },
    },



    //动态交互
    {
      path:'/Tool/ZujianRe',
      name: 'ZujianRe',
      component:ZujianRe,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/ZuneiRe',
      name: 'ZuneiRe',
      component:ZuneiRe,
      meta: {
        isLogin: false
      },
    },
    {
        path:'/Tool/Dongsan',
      name: 'Dongsan',
      component:Dongsan,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/DongCircos',
      name: 'DongCircos',
      component:DongCircos,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/DongUpSet',
      name: 'DongUpSet',
      component:DongUpSet,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Donghuo',
      name: 'Donghuo',
      component:Donghuo,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/DongROC',
      name: 'DongROC',
      component:DongROC,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/DongZhe',
      name: 'DongZhe',
      component:DongZhe,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Dongdui',
      name: 'Dongdui',
      component:Dongdui,
      meta: {
        isLogin: false
      },
    },


    //聚类分析
    {
      path:'/Tool/Tsne',
      name: 'Tsne',
      component:Tsne,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/NMDS',
      name: 'NMDS',
      component:NMDS,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/PCOA',
      name: 'PCOA',
      component:PCOA,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/PCA',
      name: 'PCA',
      component:PCA,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/PCAtD',
      name: 'PCAtD',
      component:PCAtD,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/HCA',
      name: 'HCA',
      component:HCA,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/CCA',
      name: 'CCA',
      component:CCA,
      meta: {
        isLogin: false
      },
    },


    //统计检验
    {
      path:'/Tool/XiangxianER',
      name: 'XiangxianER',
      component:XiangxianER,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/XiangxianDUO',
      name: 'XiangxianDUO',
      component:XiangxianDUO,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/ZhuER',
      name: 'ZhuER',
      component:ZhuER,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/ZhuDUO',
      name: 'ZhuDUO',
      component:ZhuDUO,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Anosim',
      name: 'Anosim',
      component:Anosim,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Adonis',
      name: 'Adonis',
      component:Adonis,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Duozu',
      name: 'Duozu',
      component:Duozu,
      meta: {
        isLogin: false
      },
    },


    //序列分析
    {
      path:'/Tool/XulieLength',
      name: 'XulieLength',
      component:XulieLength,
      meta: {
        isLogin: false
      },
    },


    //功能分析
    {
      path:'/Tool/Fuquan',
      name: 'Fuquan',
      component:Fuquan,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/Fuchaqi',
      name: 'Fuchaqi',
      component:Fuchaqi,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/KEGGFuchaqi',
      name: 'KEGGFuchaqi',
      component:KEGGFuchaqi,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/DOFuchaqi',
      name: 'DOFuchaqi',
      component:DOFuchaqi,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/DOFufen',
      name: 'DOFufen',
      component:DOFufen,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/KEGGFufen',
      name: 'KEGGFufen',
      component:KEGGFufen,
      meta: {
        isLogin: false
      },
    },
    {
      path:'/Tool/COG',
      name: 'COG',
      component:COG,
      meta: {
        isLogin: false
      },
    },

  ]
})
