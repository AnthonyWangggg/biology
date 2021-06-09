#1.两组检验箱线图（兼容两组文件） 
## data_path1输入文件txt
#out_path 输出文件png,svg,jpg等
#x_lab,y_lab x和y轴标签
#main_title是标题
#bxp_errorbar是否显示误差条
##label_show是显示标签的方法，NULL表示显示数值， "p.signif"表示不显示数值，显示***
#n_height,输出文件长度，n_width输出文件宽度
#检测方法1.“t.test” 2.“wilcox.test"
saliency2<-function(data_path1,out_path,x_lab="x",y_lab="y",main_title="saliency",
                    n_height=14,n_width=19,method_n='t.test',label_show=NULL,bxp_errorbar=T){
  library(ggpubr)
  library(ggplot2)
  traits <- read.table(data_path1,header=F)
  traits1 <- read.table(data_path1,header=T)
  col_num=dim(traits1)[1]
  x_data=c(rep(traits[1,1],times=col_num),rep(traits[1,2],times=col_num))
  y_data=c(traits1[,1],traits1[,2])
  data1<-data.frame(x_data,y_data)
  ## 绘制箱线图
  m <- ggboxplot(data1,x="x_data",y="y_data",color = "x_data",add = "jitter",bxp.errorbar = bxp_errorbar,palette ="x_data",shape = "x_data",
                 xlab=x_lab,ylab=y_lab,title=main_title)
  my_comparisons <- list( c(traits[1,1], traits[1,2]) )
  m + stat_compare_means(comparisons = my_comparisons,method=method_n,label=label_show)
  
  ggsave(out_path,height = n_height,width =n_width,units = "cm")
  
}
# saliency2("saliency2.txt","saliency2.svg")



#2.两组检验箱线图（兼容多组文件）
## data_path1输入文件txt
#out_path 输出文件png,svg,jpg等
#x_lab,y_lab x和y轴标签
#main_title是标题
#label_show是显示标签的方法，NULL表示显示数值， "p.signif"表示不显示数值，显示***
#组的数量目前只支持到8组以内，包括8组
#n_height,输出文件长度，n_width输出文件宽度
#bxp_errorbar是否显示误差条
#检测方法1.“t.test” 2.“wilcox.test"
multisaliency<-function(data_path1,out_path,x_lab="x",y_lab="y",main_title="saliency",
                        n_height=14,n_width=19,method_n='t.test',label_show=NULL,bxp_errorbar=T){
  library(ggpubr)
  library(ggplot2)
  traits <- read.table(data_path1,header=F)
  traits1 <- read.table(data_path1,header=T)
  col_num=dim(traits1)[1]
  lin_num=dim(traits1)[2]
  x_data=NULL
  y_data=NULL
  
  for(i in 1:lin_num){
    x_data=c(x_data,rep(traits[1,i],times=col_num))
  }
  for(i in 1:lin_num){
    y_data=c(y_data,traits1[,i])
  }
  #x_data=c(rep(traits[1,1],times=col_num),rep(traits[1,2],times=col_num))
  #y_data=c(traits1[,1],traits1[,2])
  data1<-data.frame(x_data,y_data)
  ## 绘制箱线图
  
  m <- ggboxplot(data1,x="x_data",y="y_data",color = "x_data",add = "jitter",palette ="x_data",shape = "x_data",
                 xlab=x_lab,ylab=y_lab,title=main_title,bxp.errorbar = bxp_errorbar)
  if(lin_num==3){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]))
  }
  else if (lin_num==4){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]),
                         c(traits[1,1],traits[1,4]),c(traits[1,2],traits[1,4]),c(traits[1,3],traits[1,4]))
  }
  else if (lin_num==5){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]),
                         c(traits[1,1],traits[1,4]),c(traits[1,1],traits[1,5]),c(traits[1,2],traits[1,4]),c(traits[1,2],traits[1,5]),
                         c(traits[1,3],traits[1,4]),c(traits[1,3],traits[1,5]),c(traits[1,4],traits[1,5]))
  }
  else if (lin_num==6){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]),c(traits[1,2],traits[1,6]),
                         c(traits[1,1],traits[1,4]),c(traits[1,1],traits[1,5]),c(traits[1,1],traits[1,6]),c(traits[1,2],traits[1,4]),c(traits[1,2],traits[1,5]),
                         c(traits[1,3],traits[1,4]),c(traits[1,3],traits[1,5]),c(traits[1,3],traits[1,6]),c(traits[1,4],traits[1,5]),c(traits[1,4],traits[1,6]),c(traits[1,5],traits[1,6]))
  }
  else if (lin_num==7){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]),c(traits[1,2],traits[1,6]),
                         c(traits[1,1],traits[1,4]),c(traits[1,1],traits[1,5]),c(traits[1,1],traits[1,6]),c(traits[1,1],traits[1,7]),
                         c(traits[1,2],traits[1,4]),c(traits[1,2],traits[1,5]),c(traits[1,2],traits[1,7]),c(traits[1,3],traits[1,7]),
                         c(traits[1,3],traits[1,4]),c(traits[1,3],traits[1,5]),c(traits[1,3],traits[1,6]),c(traits[1,4],traits[1,5]),
                         c(traits[1,4],traits[1,6]),c(traits[1,5],traits[1,6]),c(traits[1,5],traits[1,7]),c(traits[1,6],traits[1,7]))
  }
  else if (lin_num>=8){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]),c(traits[1,2],traits[1,6]),c(traits[1,4],traits[1,8]),
                         c(traits[1,1],traits[1,4]),c(traits[1,1],traits[1,5]),c(traits[1,1],traits[1,6]),c(traits[1,1],traits[1,7]),c(traits[1,1],traits[1,8]),
                         c(traits[1,2],traits[1,4]),c(traits[1,2],traits[1,5]),c(traits[1,2],traits[1,7]),c(traits[1,3],traits[1,7]),c(traits[1,2],traits[1,8]),
                         c(traits[1,3],traits[1,4]),c(traits[1,3],traits[1,5]),c(traits[1,3],traits[1,6]),c(traits[1,4],traits[1,5]),c(traits[1,3],traits[1,8]),
                         c(traits[1,4],traits[1,6]),c(traits[1,5],traits[1,6]),c(traits[1,5],traits[1,7]),c(traits[1,6],traits[1,7]),c(traits[1,5],traits[1,8]),
                         c(traits[1,6],traits[1,8]),c(traits[1,7],traits[1,8]))
  }
  
  
  
  m + stat_compare_means(comparisons = my_comparisons,method=method_n,label=label_show)
  
  ggsave(out_path,height = n_height,width =n_width,units = "cm")
  
}
# multisaliency("multisaliency.txt","multisaliency.svg")



#3.两组检验柱形图（兼容两组文件） 
## data_path1输入文件txt
#out_path 输出文件png,svg,jpg等
#x_lab,y_lab x和y轴标签
#main_title是标题
#label_show是显示标签的方法，NULL表示显示数值， "p.signif"表示不显示数值，显示***
#n_height,输出文件长度，n_width输出文件宽度
#lin_color可以选择其他颜色一般选择”black“，误差条颜色
#检测方法1.“t.test” 2.“wilcox.test"
bartest2<-function(data_path1,out_path,x_lab="x",y_lab="y",main_title="saliency",
                   n_height=14,n_width=12,method_n='t.test',label_show=NULL,lin_color="x_data"
){
  library(ggpubr)
  library(ggplot2)
  traits <- read.table(data_path1,header=F)
  traits1 <- read.table(data_path1,header=T)
  col_num=dim(traits1)[1]
  x_data=c(rep(traits[1,1],times=col_num),rep(traits[1,2],times=col_num))
  y_data=c(traits1[,1],traits1[,2])
  data1<-data.frame(x_data,y_data)
  ## 绘制柱形图
  
  m <- ggbarplot(data1,x="x_data",y="y_data",fill="x_data",color=lin_color,#position = position_identity(),#position = position_dodge(0.1),
                 xlab=x_lab,ylab=y_lab,title=main_title, add = c("mean_se"))
  my_comparisons <- list( c(traits[1,1], traits[1,2]) )
  m + stat_compare_means(comparisons = my_comparisons,method=method_n,label=label_show)
  
  ggsave(out_path,height = n_height,width =n_width,units = "cm")
  
}
# bartest2("saliency2.txt","bartest2.svg")

#4.两组检验柱形图（兼容多组文件）
## data_path1输入文件txt
#out_path 输出文件png,svg,jpg等
#x_lab,y_lab x和y轴标签
#main_title是标题
#lin_color可以选择其他颜色一般选择”black“，误差条颜色
#label_show是显示标签的方法，NULL表示显示数值， "p.signif"表示不显示数值，显示***
#分组只支持8组，大于8组只画前8组
#n_height,输出文件长度，n_width输出文件宽度
#检测方法1.“t.test” 2.“wilcox.test"
multibar<-function(data_path1,out_path,x_lab="x",y_lab="y",main_title="saliency",
                   n_height=14,n_width=19,method_n='t.test',label_show=NULL,lin_color="x_data"){
  library(ggpubr)
  library(ggplot2)
  traits <- read.table(data_path1,header=F)
  traits1 <- read.table(data_path1,header=T)
  col_num=dim(traits1)[1]
  lin_num=dim(traits1)[2]
  x_data=NULL
  x_data1=NULL
  y_data=NULL
  for(i in 1:lin_num){
    for(j in 1:lin_num){
      x_data1=list(c(traits[,],traits[,i]),c)
    }
  }
  for(i in 1:lin_num){
    x_data=c(x_data,rep(traits[1,i],times=col_num))
  }
  for(i in 1:lin_num){
    y_data=c(y_data,traits1[,i])
  }
  #x_data=c(rep(traits[1,1],times=col_num),rep(traits[1,2],times=col_num))
  #y_data=c(traits1[,1],traits1[,2])
  data1<-data.frame(x_data,y_data)
  ## 绘制柱形图
  
  m <- ggbarplot(data1,x="x_data",y="y_data",color = lin_color,fill = "x_data",
                 xlab=x_lab,ylab=y_lab,title=main_title,add = c("mean_se"))
  
  if(lin_num==3){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]))
  }
  else if (lin_num==4){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]),
                         c(traits[1,1],traits[1,4]),c(traits[1,2],traits[1,4]),c(traits[1,3],traits[1,4]))
  }
  else if (lin_num==5){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]),
                         c(traits[1,1],traits[1,4]),c(traits[1,1],traits[1,5]),c(traits[1,2],traits[1,4]),c(traits[1,2],traits[1,5]),
                         c(traits[1,3],traits[1,4]),c(traits[1,3],traits[1,5]),c(traits[1,4],traits[1,5]))
  }
  else if (lin_num==6){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]),c(traits[1,2],traits[1,6]),
                         c(traits[1,1],traits[1,4]),c(traits[1,1],traits[1,5]),c(traits[1,1],traits[1,6]),c(traits[1,2],traits[1,4]),c(traits[1,2],traits[1,5]),
                         c(traits[1,3],traits[1,4]),c(traits[1,3],traits[1,5]),c(traits[1,3],traits[1,6]),c(traits[1,4],traits[1,5]),c(traits[1,4],traits[1,6]),c(traits[1,5],traits[1,6]))
  }
  else if (lin_num==7){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]),c(traits[1,2],traits[1,6]),
                         c(traits[1,1],traits[1,4]),c(traits[1,1],traits[1,5]),c(traits[1,1],traits[1,6]),c(traits[1,1],traits[1,7]),
                         c(traits[1,2],traits[1,4]),c(traits[1,2],traits[1,5]),c(traits[1,2],traits[1,7]),c(traits[1,3],traits[1,7]),
                         c(traits[1,3],traits[1,4]),c(traits[1,3],traits[1,5]),c(traits[1,3],traits[1,6]),c(traits[1,4],traits[1,5]),
                         c(traits[1,4],traits[1,6]),c(traits[1,5],traits[1,6]),c(traits[1,5],traits[1,7]),c(traits[1,6],traits[1,7]))
  }
  else if (lin_num>=8){
    my_comparisons =list(c(traits[1,1],traits[1,2]),c(traits[1,1],traits[1,3]),c(traits[1,2],traits[1,3]),c(traits[1,2],traits[1,6]),c(traits[1,4],traits[1,8]),
                         c(traits[1,1],traits[1,4]),c(traits[1,1],traits[1,5]),c(traits[1,1],traits[1,6]),c(traits[1,1],traits[1,7]),c(traits[1,1],traits[1,8]),
                         c(traits[1,2],traits[1,4]),c(traits[1,2],traits[1,5]),c(traits[1,2],traits[1,7]),c(traits[1,3],traits[1,7]),c(traits[1,2],traits[1,8]),
                         c(traits[1,3],traits[1,4]),c(traits[1,3],traits[1,5]),c(traits[1,3],traits[1,6]),c(traits[1,4],traits[1,5]),c(traits[1,3],traits[1,8]),
                         c(traits[1,4],traits[1,6]),c(traits[1,5],traits[1,6]),c(traits[1,5],traits[1,7]),c(traits[1,6],traits[1,7]),c(traits[1,5],traits[1,8]),
                         c(traits[1,6],traits[1,8]),c(traits[1,7],traits[1,8]))
  }
  
  m + stat_compare_means(comparisons = my_comparisons,method=method_n,label= label_show)
  #test_value<-stat_compare_means(comparisons = my_comparisons,method=method_n )
  #write.table(test_value,"test_value.txt")
  ggsave(out_path,height = n_height,width =n_width,units = "cm")
  
}
# multibar("multisaliency.txt","multibar.svg")





