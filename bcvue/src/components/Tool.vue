<template>
  <div id="zong">
    <el-backtop target=".page-component__scroll .el-scrollbar__wrap"></el-backtop>
    <div class="display-flex">
      <div class="div-size1">
        <el-row class="tac" id="erow">
          <el-col :span="1">
            <el-menu
              :default-active="$route.params.part"
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
              <el-menu-item index="7" @click="part7">
                <i class="el-icon-location"></i>
                <span slot="title">注释工具</span>
              </el-menu-item>
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
          <div class="c1" v-for="(item,index) of all" v-show="flags==0"></div>
          <div class="c1" v-for="(item,index) of jichu" v-show="flags==1" :key="item.id" @click="go(item.router)">
            <div id="pics" @click="go(item.router)">
              <img src="../assets/back.png"/>
            </div>
            <div id="titles" @click="go(item.router)">
              {{item.name}}
            </div>
          </div>
          <div class="c1" v-for="(item,index) of gongneng" v-show="flags==2"></div>
          <div class="c1" v-for="(item,index) of julei" v-show="flags==3"></div>
          <div class="c1" v-for="(item,index) of dongtai" v-show="flags==4"></div>
          <div class="c1" v-for="(item,index) of xulie" v-show="flags==5"></div>
          <div class="c1" v-for="(item,index) of zhushi" v-show="flags==6"></div>
          <div class="c1" v-for="(item,index) of biaoge" v-show="flags==7" :key="item.id" @click="go(item.router)">{{item.name}}</div>
          <div class="c1" v-for="(item,index) of tongji" v-show="flags==8"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Tool',
  created (){
    this.all=this.jichu.concat(this.gongneng).concat(this.biaoge).concat(this.dongtai).concat(this.julei).concat(this.tongji).concat(this.xulie).concat(this.zhushi )
    console.log('hello')
    this.flags = this.$route.params.flags
    console.log(this.flags)
  },
  methods: {
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
        {
          name:'九象限图',
          pic:'',
          router: '/Tool/Jiuxiangxian',
        },
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
          name:'DO富集分析高级版',
          pic:'',
        },
        {
          name:'KEGG富集分析高级版',
          pic:'',
        },
        {
          name:'GO富集分析高级版',
          pic:'',
        },
        {
          name:'xGSEAdotplot',
          pic:'',
        },
        {
          name:'GSEA静态工具',
          pic:'',
        },
        {
          name:'富集差异气泡图',
          pic:'',
        },
        {
          name:'富集圈图',
          pic:'',
        },
        {
          name:'富集分析条形图',
          pic:'',
        },
        {
          name:'GO分类柱状图',
          pic:'',
        },
        {
          name:'COG/KOG图',
          pic:'',
        },
        {
          name:'GO富集分析',
          pic:'',
        },
        {
          name:'KEGG富集分析',
          pic:'',
        },
      ],
      julei:[
        {
          name:'Tsne',
          pic:'',
        },
        {
          name:'CCA/RDA',
          pic:'',
        },
        {
          name:'NMDS',
          pic:'',
        },
        {
          name:'PCoA',
          pic:'',
        },
        {
          name:'三维PCA',
          pic:'',
        },
        {
          name:'分层聚类分析（hca）',
          pic:'',
        },
        {
          name:'趋势分析图',
          pic:'',
        },
        {
          name:'PCA',
          pic:'',
        },
      ],
      dongtai:[
        {
          name:'动态四/九象限图',
          pic:'',
        },
        {
          name:'GSEA动态工具',
          pic:'',
        },
        {
          name:'kegg高级网络图',
          pic:'',
        },
        {
          name:'kegg网络图',
          pic:'',
        },
        {
          name:'动态堆叠图',
          pic:'',
        },
        {
          name:'动态富集圈图',
          pic:'',
        },
        {
          name:'动态富集差异气泡图',
          pic:'',
        },
        {
          name:'动态富集条形图',
          pic:'',
        },
        {
          name:'动态富集气泡图',
          pic:'',
        },
        {
          name:'动态三元图（富集型）',
          pic:'',
        },
        {
          name:'动态Upset图',
          pic:'',
        },
        {
          name:'动态火山图',
          pic:'',
        },
        {
          name:'动态雷达图',
          pic:'',
        },
        {
          name:'动态ROC',
          pic:'',
        },
        {
          name:'动态三元图（分布型）',
          pic:'',
        },
        {
          name:'动态circos图',
          pic:'',
        },
        {
          name:'动态趋势分析',
          pic:'',
        },
        {
          name:'动态tSNE',
          pic:'',
        },
        {
          name:'动态RDA',
          pic:'',
        },
        {
          name:'动态CCA',
          pic:'',
        },
        {
          name:'动态NMDS',
          pic:'',
        },
        {
          name:'动态PCoA(进阶版）',
          pic:'',
        },
        {
          name:'动态PCA',
          pic:'',
        },
        {
          name:'动态丰富维恩图',
          pic:'',
        },
        {
          name:'动态柱状图',
          pic:'',
        },
        {
          name:'动态盒形图（分组）',
          pic:'',
        },
        {
          name:'动态盒形图',
          pic:'',
        },
        {
          name:'动态小提琴（分组',
          pic:'',
        },
        {
          name:'动态小提琴',
          pic:'',
        },
        {
          name:'动态折线图',
          pic:'',
        },
        {
          name:'动态相关性热图（组间）',
          pic:'',
        },
        {
          name:'动态相关性热图（组内）',
          pic:'',
        },
        {
          name:'动态热图',
          pic:'',
        },
        {
          name:'动态KEGC富集分析',
          pic:'',
        },
        {
          name:'动态PCoA(基础版）',
          pic:'',
        },
        {
          name:'动态GO富集分析',
          pic:'',
        },
      ],
      xulie:[
        {
          name:'蛋白进化树',
          pic:'',
        },
        {
          name:'Blast序列局部比对',
          pic:'',
        },
        {
          name:'CDS转蛋白',
          pic:'',
        },
        {
          name:'DNA/RNA转换器',
          pic:'',
        },
        {
          name:'muscle多序列比对',
          pic:'',
        },
        {
          name:'截取序列',
          pic:'',
        },
        {
          name:'序列长度过滤',
          pic:'',
        },
        {
          name:'序列长度统计',
          pic:'',
        },
        {
          name:'序列格式化',
          pic:'',
        },
      ],
      zhushi:[
        {
          name:'plantTFdb注释',
          pic:'',
        },
        {
          name:'CAZy注释',
          pic:'',
        },
        {
          name:'eggNOG注释',
          pic:'',
        },
        {
          name:'细菌抗性基因（CARD）注释',
          pic:'',
        },
        {
          name:'细菌致病菌毒力因子（VFDB）注释',
          pic:'',
        },
        {
          name:'细菌抗性基因（ARDB）注释',
          pic:'',
        },
        {
          name:'PHI注释',
          pic:'',
        },
        {
          name:'AnimalTFDB注释',
          pic:'',
        },
        {
          name:'Pfam注释',
          pic:'',
        },
        {
          name:'KOG注释',
          pic:'',
        },
        {
          name:'COG注释',
          pic:'',
        },
        {
          name:'NR注释',
          pic:'',
        },
        {
          name:'KEGG功能注释',
          pic:'',
        },
        {
          name:'GO功能注释',
          pic:'',
        },
        {
          name:'Swiss-Prot注释',
          pic:'',
        },
      ],
      biaoge:[
        {
          name:'fq2fa',
          pic:'',
        },
        {
          name:'SVG转换',
          pic:'',
          router: '/Tool/Svg',
        },
        {
          name:'解读SAM flag',
          pic:'',
        },
        {
          name:'表格筛选',
          pic:'',
        },
        {
          name:'表格转置',
          pic:'',
        },
        {
          name:'多表格合并',
          pic:'',
        },
        {
          name:'两表格合并',
          pic:'',
        },
      ],
      tongji:[
        {
          name:'adonis分析（permannova）',
          pic:'',
        },
        {
          name:'多组检验',
          pic:'',
        },
        {
          name:'普氏分析（procrustes）',
          pic:'',
        },
        {
          name:'字母标识柱形图',
          pic:'',
        },
        {
          name:'两组检验箱线图（兼容多组文件）',
          pic:'',
        },
        {
          name:'两组检验箱线图（兼容两组文件）',
          pic:'',
        },
        {
          name:'两组检验柱形图（兼容多组文件）',
          pic:'',
        },
        {
          name:'两组检验柱形图（兼容两组文件）',
          pic:'',
        },
        {
          name:'秩和检验',
          pic:'',
        },
        {
          name:'配对T检验',
          pic:'',
        },
        {
          name:'t检验',
          pic:'',
        },
        {
          name:'组间相关性分析',
          pic:'',
        },
        {
          name:'组内相关性分析',
          pic:'',
        },
        {
          name:'ROC',
          pic:'',
        },
        {
          name:'(O)PLS-DA',
          pic:'',
        },
        {
          name:'配对edgeR差异分析',
          pic:'',
        },
        {
          name:'edgeR差异分析',
          pic:'',
        },
      ],

    }
  }


}
</script>

<style scoped>
#zong{
  width: 100%;
  height: 400%;
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
#pics{
  background: #b98342;
  display: flex;
  display: -webkit-flex;
  align-items:center;
  justify-content:center;
  height: 80%;
}
#titles{
  background: #4642b9;
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
</style>
