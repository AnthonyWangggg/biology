<template>
  <div id="zong">
    <el-backtop target=".page-component__scroll .el-scrollbar__wrap"></el-backtop>
    <div class="display-flex">
      <div class="div-size1">
        <el-row class="tac" id="erow">
          <el-col :span="1">
            <el-menu
              :default-active="flags+1"
              class="el-menu-vertical-demo"
              @open="handleOpen"
              @close="handleClose">
              <el-menu-item index="1" @click="part1">
                <i class="el-icon-location"></i>
                <span slot="title">全部工具</span>
              </el-menu-item>
              <el-menu-item index="2" @click="part2">
                <i class="el-icon-location"></i>
                <span slot="title">基础绘图</span>
              </el-menu-item>
              <el-menu-item index="3" @click="part3">
                <i class="el-icon-location"></i>
                <span slot="title">功能分析</span>
              </el-menu-item>
              <el-menu-item index="4" @click="part4">
                <i class="el-icon-location"></i>
                <span slot="title">聚类分析</span>
              </el-menu-item>
              <el-menu-item index="5" @click="part5">
                <i class="el-icon-location"></i>
                <span slot="title">动态交互</span>
              </el-menu-item>
              <el-menu-item index="6" @click="part6">
                <i class="el-icon-location"></i>
                <span slot="title">序列处理</span>
              </el-menu-item>
<!--              <el-menu-item index="7" @click="part7">-->
<!--                <i class="el-icon-location"></i>-->
<!--                <span slot="title">注释工具</span>-->
<!--              </el-menu-item>-->
              <el-menu-item index="8" @click="part8">
                <i class="el-icon-location"></i>
                <span slot="title">表格与格式</span>
              </el-menu-item>
              <el-menu-item index="9" @click="part9">
                <i class="el-icon-location"></i>
                <span slot="title">统计检验与差异</span>
              </el-menu-item>
            </el-menu>
          </el-col>
        </el-row>
      </div>
      <div class="div-size2">
        <div class="d">

          <div class="c1" v-for="(item,index) of all" v-show="flags==0" @click="go(item.router)">
            <div id="pics" @click="go(item.router)">
              <img src="../assets/jiyinfenxi.png"/>
            </div>
            <div id="titles" @click="go(item.router)">
              {{item.name}}
            </div>
          </div>

          <div class="c1" v-for="(item,index) of jichu" v-show="flags==1" :key="item.id" @click="go(item.router)">
            <div id="pics" @click="go(item.router)">
              <img src="../assets/jiyinfenxi1.png"/>
            </div>
            <div id="titles" @click="go(item.router)">
              {{item.name}}
            </div>
          </div>

          <div class="c1" v-for="(item,index) of gongneng" v-show="flags==2" :key="item.id" @click="go(item.router)">
            <div id="pics" @click="go(item.router)">
              <img src="../assets/jiyinfenxi2.png"/>
            </div>
            <div id="titles" @click="go(item.router)">
              {{item.name}}
            </div>
          </div>

          <div class="c1" v-for="(item,index) of julei" v-show="flags==3" :key="item.id" @click="go(item.router)">
            <div id="pics" @click="go(item.router)">
              <img src="../assets/jiyinfenxi3.png"/>
            </div>
            <div id="titles" @click="go(item.router)">
              {{item.name}}
            </div>
          </div>

          <div class="c1" v-for="(item,index) of dongtai" v-show="flags==4" :key="item.id" @click="go(item.router)">
            <div id="pics" @click="go(item.router)">
              <img src="../assets/jiyinfenxi4.png"/>
            </div>
            <div id="titles" @click="go(item.router)">
              {{item.name}}
            </div>
          </div>

          <div class="c1" v-for="(item,index) of xulie" v-show="flags==5" :key="item.id" @click="go(item.router)">
            <div id="pics" @click="go(item.router)">
              <img src="../assets/jiyinfenxi5.png"/>
            </div>
            <div id="titles" @click="go(item.router)">
              {{item.name}}
            </div>
          </div>

<!--          <div class="c1" v-for="(item,index) of zhushi" v-show="flags==6"></div>-->

          <div class="c1" v-for="(item,index) of biaoge" v-show="flags==7" :key="item.id" @click="go(item.router)">
            <div id="pics" @click="go(item.router)">
              <img src="../assets/jiyinfenxi6.png"/>
            </div>
            <div id="titles" @click="go(item.router)">
              {{item.name}}
            </div>
          </div>

          <div class="c2" v-show="flags==7">
            <div id="pics" @click="jumpHtml">
              <img src="../assets/jiyinfenxi6.png"/>
            </div>
            <div id="titles" @click="jumpHtml">
              SAM Flag
            </div>
          </div>


          <div class="c1" v-for="(item,index) of tongji" v-show="flags==8">
            <div id="pics" @click="go(item.router)">
              <img src="../assets/jiyinfenxi7.png"/>
            </div>
            <div id="titles" @click="go(item.router)">
              {{item.name}}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Tool',
  created (){
    // this.all=this.jichu.concat(this.gongneng).concat(this.biaoge).concat(this.dongtai).concat(this.julei).concat(this.tongji).concat(this.xulie).concat(this.zhushi)
    console.log(this.all)
    // this.flags = this.$route.params.part
    console.log(this.flags)
  },
  methods: {
    jumpHtml(){
      window.open(this.Host.BASE_URL + 'public/FormatChange/Sam.html','_blank')
      // window.location.href = this.Host.BASE_URL + 'public/Sam.html'
    },

    handleOpen (key, keyPath) {
      console.log(key, keyPath);
    },
    handleClose (key, keyPath) {
      console.log(key, keyPath);
    },
    part1 (){
      this.flags=0;
    },
    part2 (){
      this.flags=1;
    },
    part3 (){
      this.flags=2;
    },
    part4 (){
      this.flags=3;
    },
    part5 (){
      this.flags=4;
    },
    part6 (){
      this.flags=5;
    },
    part7 (){
      this.flags=6;
    },
    part8 (){
      this.flags=7;
    },
    part9 (){
      this.flags=8;
    },
    go (ip) {
      this.$router.push({path: ip})
    },
  },
  data() {
    return{
      flags:0,
      all:[
        {
          name:'桑基图',
          pic:'',
          router: '/Tool/Sangji',
        },
        {
          name:'极坐标柱状图',
          pic:'',
          router: '/Tool/Jizuobiao',
        },
        {
          name:'蜂群图',
          pic:'',
          router: '/Tool/Fengqun',
        },
        {
          name:'二值热图',
          pic:'',
          router: '/Tool/Erre',
        },
        {
          name:'豆荚图',
          pic:'',
          router: '/Tool/Doujia',
        },
        {
          name:'断轴柱状图',
          pic:'',
          router: '/Tool/Duanzhou',
        },
        {
          name:'三元图',
          pic:'',
          router: '/Tool/Sanyuan',
        },
        {
          name:'UpSet维恩图',
          pic:'',
          router: '/Tool/UpSet',
        },
        {
          name:'circos物种关系图',
          pic:'',
          router: '/Tool/Circos',
        },
        // {
        //   name:'九象限图',
        //   pic:'',
        //   router: '/Tool/Jiuxiangxian',
        // },
        {
          name:'分组小提琴图',
          pic:'',
          router: '/Tool/FenQing',
        },
        {
          name:'小提琴图',
          pic:'',
          router: '/Tool/Xiaotiqing',
        },
        {
          name:'频率直方图',
          pic:'',
          router: '/Tool/Pinglv',
        },
        {
          name:'饼图',
          pic:'',
          router: '/Tool/Bing',
        },
        {
          name:'3D散点图',
          pic:'',
          router: '/Tool/ThreeD',
        },
        {
          name:'线性回归图',
          pic:'',
          router: '/Tool/Xianhui',
        },
        {
          name:'权重网络图',
          pic:'',
          router: '/Tool/Quanwang',
        },
        {
          name:'有向网络图',
          pic:'',
          router: '/Tool/Youwang',
        },
        {
          name:'高级气泡图',
          pic:'',
          router: '/Tool/Gaoqi',
        },
        {
          name:'高级散点图',
          pic:'',
          router: '/Tool/Gaosan',
        },
        {
          name:'维恩图',
          pic:'',
          router: '/Tool/Weien',
        },
        {
          name:'Krona层级饼图',
          pic:'',
          router: '/Tool/Krona',
        },
        {
          name:'MA图',
          pic:'',
          router: '/Tool/MA',
        },
        {
          name:'火山图',
          pic:'',
          router: '/Tool/Huoshan',
        },
        {
          name:'热图',
          pic:'',
          router: '/Tool/Re',
        },
        {
          name:'气泡图',
          pic:'',
          router: '/Tool/Qipao'
        },
        {
          name:'盒形图',
          pic:'',
          router: '/Tool/Hezhuang'
        },
        {
          name:'面积图',
          pic:'',
          router: '/Tool/Mianji'
        },
        {
          name:'柱状图',
          pic:'',
          router: '/Tool/Zhuzhuang'
        },
        {
          name:'折线图',
          pic:'',
          router: '/Tool/Zhexian'
        },
        {
          name:'散点图',
          pic:'',
          router: '/Tool/Sandian'
        },
        {
          name:'DO富集差异气泡图',
          pic:'',
          router: '/Tool/DOFuchaqi'
        },
        {
          name:'KEGG富集分析',
          pic:'',
          router: '/Tool/KEGGFufen'
        },
        {
          name:'KEGG富集差异气泡图',
          pic:'',
          router: '/Tool/KEGGFuchaqi'
        },
        {
          name:'富集圈图',
          pic:'',
          router: '/Tool/Fuquan'
        },
        {
          name:'COG/KOG图',
          pic:'',
          router: '/Tool/COG'
        },
        {
          name:'DO富集分析',
          pic:'',
          router: '/Tool/DOFufen'
        },
        {
          name:'GO富集差异气泡图',
          pic:'',
          router: '/Tool/Fuchaqi'
        },
        {
          name:'Tsne',
          pic:'',
          router: '/Tool/Tsne'
        },
        {
          name:'CCA/RDA',
          pic:'',
          router: '/Tool/CCA'
        },
        {
          name:'NMDS',
          pic:'',
          router: '/Tool/NMDS'
        },
        {
          name:'PCoA',
          pic:'',
          router: '/Tool/PCoA'
        },
        {
          name:'三维PCA',
          pic:'',
          router: '/Tool/PCAtD'
        },
        {
          name:'分层聚类分析（hca）',
          pic:'',
          router: '/Tool/HCA'
        },
        {
          name:'PCA',
          pic:'',
          router: '/Tool/PCA'
        },
        {
          name:'动态堆叠图',
          pic:'',
          router: '/Tool/Dongdui'
        },
        {
          name:'动态折线图',
          pic:'',
          router: '/Tool/Dongzhe'
        },
        {
          name:'动态三元图',
          pic:'',
          router: '/Tool/Dongsan'
        },
        {
          name:'动态Upset图',
          pic:'',
          router: '/Tool/DongUpSet'
        },
        {
          name:'动态火山图',
          pic:'',
          router: '/Tool/Donghuo'
        },
        {
          name:'动态ROC',
          pic:'',
          router: '/Tool/DongROC'
        },
        {
          name:'动态circos图',
          pic:'',
          router: '/Tool/DongCircos'
        },
        {
          name:'动态相关性热图（组间）',
          pic:'',
          router: '/Tool/ZujianRe',
        },
        {
          name:'动态相关性热图（组内）',
          pic:'',
          router: '/Tool/ZuneiRe',
        },
        {
          name:'fq2fa',
          pic:'',
          router: '/Tool/Fqtfa',
        },
        {
          name:'SVG转换',
          pic:'',
          router: '/Tool/Svg',
        },
        {
          name:'表格筛选',
          pic:'',
          router: '/Tool/Shaixuan',
        },
        {
          name:'两表格合并',
          pic:'',
          router: '/Tool/Erhebing',
        },
        {
          name:'序列长度统计',
          pic:'',
          router: '/Tool/XulieLength',
        },
        {
          name:'adonis分析（permannova）',
          pic:'',
          router: '/Tool/Adonis',
        },
        {
          name:'多组检验',
          pic:'',
          router: '/Tool/Duozu',
        },
        {
          name:'anosim分析',
          pic:'',
          router: '/Tool/Anosim',
        },
        {
          name:'两组检验箱线图（兼容多组文件）',
          pic:'',
          router: '/Tool/XiangxianDUO',
        },
        {
          name:'两组检验箱线图（兼容两组文件）',
          pic:'',
          router: '/Tool/XiangxianER',
        },
        {
          name:'两组检验柱形图（兼容多组文件）',
          pic:'',
          router: '/Tool/ZhuDUO',
        },
        {
          name:'两组检验柱形图（兼容两组文件）',
          pic:'',
          router: '/Tool/ZhuER',
        },
      ],
      jichu:[
        {
          name:'桑基图',
          pic:'',
          router: '/Tool/Sangji',
        },
        {
          name:'极坐标柱状图',
          pic:'',
          router: '/Tool/Jizuobiao',
        },
        {
          name:'蜂群图',
          pic:'',
          router: '/Tool/Fengqun',
        },
        {
          name:'二值热图',
          pic:'',
          router: '/Tool/Erre',
        },
        {
          name:'豆荚图',
          pic:'',
          router: '/Tool/Doujia',
        },
        {
          name:'断轴柱状图',
          pic:'',
          router: '/Tool/Duanzhou',
        },
        {
          name:'三元图',
          pic:'',
          router: '/Tool/Sanyuan',
        },
        {
          name:'UpSet维恩图',
          pic:'',
          router: '/Tool/UpSet',
        },
        {
          name:'circos物种关系图',
          pic:'',
          router: '/Tool/Circos',
        },
        // {
        //   name:'九象限图',
        //   pic:'',
        //   router: '/Tool/Jiuxiangxian',
        // },
        {
          name:'分组小提琴图',
          pic:'',
          router: '/Tool/FenQing',
        },
        {
          name:'小提琴图',
          pic:'',
          router: '/Tool/Xiaotiqing',
        },
        {
          name:'频率直方图',
          pic:'',
          router: '/Tool/Pinglv',
        },
        {
          name:'饼图',
          pic:'',
          router: '/Tool/Bing',
        },
        {
          name:'3D散点图',
          pic:'',
          router: '/Tool/ThreeD',
        },
        {
          name:'线性回归图',
          pic:'',
          router: '/Tool/Xianhui',
        },
        {
          name:'权重网络图',
          pic:'',
          router: '/Tool/Quanwang',
        },
        {
          name:'有向网络图',
          pic:'',
          router: '/Tool/Youwang',
        },
        {
          name:'高级气泡图',
          pic:'',
          router: '/Tool/Gaoqi',
        },
        {
          name:'高级散点图',
          pic:'',
          router: '/Tool/Gaosan',
        },
        {
          name:'维恩图',
          pic:'',
          router: '/Tool/Weien',
        },
        {
          name:'Krona层级饼图',
          pic:'',
          router: '/Tool/Krona',
        },
        {
          name:'MA图',
          pic:'',
          router: '/Tool/MA',
        },
        {
          name:'火山图',
          pic:'',
          router: '/Tool/Huoshan',
        },
        {
          name:'热图',
          pic:'',
          router: '/Tool/Re',
        },
        {
          name:'气泡图',
          pic:'',
          router: '/Tool/Qipao'
        },
        {
          name:'盒形图',
          pic:'',
          router: '/Tool/Hezhuang'
        },
        {
          name:'面积图',
          pic:'',
          router: '/Tool/Mianji'
        },
        {
          name:'柱状图',
          pic:'',
          router: '/Tool/Zhuzhuang'
        },
        {
          name:'折线图',
          pic:'',
          router: '/Tool/Zhexian'
        },
        {
          name:'散点图',
          pic:'',
          router: '/Tool/Sandian'
        },
      ],
      gongneng:[
        {
          name:'DO富集差异气泡图',
          pic:'',
          router: '/Tool/DOFuchaqi'
        },
        {
          name:'KEGG富集分析',
          pic:'',
          router: '/Tool/KEGGFufen'
        },
        {
          name:'KEGG富集差异气泡图',
          pic:'',
          router: '/Tool/KEGGFuchaqi'
        },
        {
          name:'富集圈图',
          pic:'',
          router: '/Tool/Fuquan'
        },
        {
          name:'COG/KOG图',
          pic:'',
          router: '/Tool/COG'
        },
        {
          name:'DO富集分析',
          pic:'',
          router: '/Tool/DOFufen'
        },
        {
          name:'GO富集差异气泡图',
          pic:'',
          router: '/Tool/Fuchaqi'
        },
      ],
      julei:[
        {
          name:'Tsne',
          pic:'',
          router: '/Tool/Tsne'
        },
        {
          name:'CCA/RDA',
          pic:'',
          router: '/Tool/CCA'
        },
        {
          name:'NMDS',
          pic:'',
          router: '/Tool/NMDS'
        },
        {
          name:'PCoA',
          pic:'',
          router: '/Tool/PCoA'
        },
        {
          name:'三维PCA',
          pic:'',
          router: '/Tool/PCAtD'
        },
        {
          name:'分层聚类分析（hca）',
          pic:'',
          router: '/Tool/HCA'
        },
        {
          name:'PCA',
          pic:'',
          router: '/Tool/PCA'
        },
      ],
      dongtai:[
        {
          name:'动态堆叠图',
          pic:'',
          router: '/Tool/Dongdui'
        },
        {
          name:'动态折线图',
          pic:'',
          router: '/Tool/Dongzhe'
        },
        {
          name:'动态三元图',
          pic:'',
          router: '/Tool/Dongsan'
        },
        {
          name:'动态Upset图',
          pic:'',
          router: '/Tool/DongUpSet'
        },
        {
          name:'动态火山图',
          pic:'',
          router: '/Tool/Donghuo'
        },
        {
          name:'动态ROC',
          pic:'',
          router: '/Tool/DongROC'
        },
        {
          name:'动态circos图',
          pic:'',
          router: '/Tool/DongCircos'
        },
        {
          name:'动态相关性热图（组间）',
          pic:'',
          router: '/Tool/ZujianRe',
        },
        {
          name:'动态相关性热图（组内）',
          pic:'',
          router: '/Tool/ZuneiRe',
        },

      ],
      xulie:[
        {
          name:'序列长度统计',
          pic:'',
          router: '/Tool/XulieLength',
        },
      ],
      // zhushi:[
      //   {
      //     name:'plantTFdb注释',
      //     pic:'',
      //   },
      //   {
      //     name:'CAZy注释',
      //     pic:'',
      //   },
      //   {
      //     name:'eggNOG注释',
      //     pic:'',
      //   },
      //   {
      //     name:'细菌抗性基因（CARD）注释',
      //     pic:'',
      //   },
      //   {
      //     name:'细菌致病菌毒力因子（VFDB）注释',
      //     pic:'',
      //   },
      //   {
      //     name:'细菌抗性基因（ARDB）注释',
      //     pic:'',
      //   },
      //   {
      //     name:'PHI注释',
      //     pic:'',
      //   },
      //   {
      //     name:'AnimalTFDB注释',
      //     pic:'',
      //   },
      //   {
      //     name:'Pfam注释',
      //     pic:'',
      //   },
      //   {
      //     name:'KOG注释',
      //     pic:'',
      //   },
      //   {
      //     name:'COG注释',
      //     pic:'',
      //   },
      //   {
      //     name:'NR注释',
      //     pic:'',
      //   },
      //   {
      //     name:'KEGG功能注释',
      //     pic:'',
      //   },
      //   {
      //     name:'GO功能注释',
      //     pic:'',
      //   },
      //   {
      //     name:'Swiss-Prot注释',
      //     pic:'',
      //   },
      // ],
      biaoge:[
        {
          name:'fq2fa',
          pic:'',
          router: '/Tool/Fqtfa',
        },
        {
          name:'SVG转换',
          pic:'',
          router: '/Tool/Svg',
        },
        {
          name:'表格筛选',
          pic:'',
          router: '/Tool/Shaixuan',
        },
        {
          name:'两表格合并',
          pic:'',
          router: '/Tool/Erhebing',
        },
      ],
      tongji:[
        {
          name:'adonis分析（permannova）',
          pic:'',
          router: '/Tool/Adonis',
        },
        {
          name:'多组检验',
          pic:'',
          router: '/Tool/Duozu',
        },
        {
          name:'anosim分析',
          pic:'',
          router: '/Tool/Anosim',
        },
        {
          name:'两组检验箱线图（兼容多组文件）',
          pic:'',
          router: '/Tool/XiangxianDUO',
        },
        {
          name:'两组检验箱线图（兼容两组文件）',
          pic:'',
          router: '/Tool/XiangxianER',
        },
        {
          name:'两组检验柱形图（兼容多组文件）',
          pic:'',
          router: '/Tool/ZhuDUO',
        },
        {
          name:'两组检验柱形图（兼容两组文件）',
          pic:'',
          router: '/Tool/ZhuER',
        },
      ],

    }
  }


}
</script>

<style scoped>
#zong{
  width: 100%;
  height: auto;
  position: absolute;
}
.display-flex {
  display: flex;
  z-index: 1;
  height: 100%;
}

.div-size1 {
  width: auto;
  height: 100%;
  margin: 0;
  background: #ffffff;
  position:fixed
}
.div-size2 {
  width: 85%;
  height: 100%;
  background: #ececec;
  float: right;
  margin-right:0;
  position:absolute;
  top: 0;
  right: 0;
}
.d{
  width: 100%;
  height: auto;
  overflow: hidden;
  padding: 10px 80px;
  display: flex;
  flex-wrap: wrap;
  background: #ececec;
}
.c1{
  border: 1px solid #ffffff;
  width: 300px;
  height: 180px;
  padding: 10px 0 0 0;
  margin-right: 100px;
  margin-bottom: 80px;
  display: flex;
  align-items: center;
  background: #ffffff;
  flex-direction: column;
  border-radius: 10px;
}
.c2{
  border: 1px solid #ffffff;
  width: 300px;
  height: 180px;
  padding: 10px 0 0 0;
  margin-right: 100px;
  margin-bottom: 80px;
  display: flex;
  align-items: center;
  background: #ffffff;
  flex-direction: column;
  border-radius: 10px;
}
#pics{
  /*background: #b98342;*/
  display: flex;
  display: -webkit-flex;
  align-items:center;
  justify-content:center;
  height: 80%;
}
#titles{
  /*background: #4642b9;*/
  display: flex;
  display: -webkit-flex;
  align-items:center;
  justify-content:center;
  height: 20%;
}
#erow{
  width: 15%;
  height: 100%;
}
img{
  width: 70%;
  height: 90%;
}
</style>
