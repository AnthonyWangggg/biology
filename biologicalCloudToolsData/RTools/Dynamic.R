

#组内相关性热图
#data_filepath 数据文件路径,支持txt,csv,xlsx
#out_picpath 输出的图片路径，svg格式
#cor_type 分析类型(string) 输入三者之一("pearson","kendall","spearman")
#cal_dir 选择计算向量(string) 输入二者之一("col","row")
#U_color 颜色
#U_text_fontsize 标签文字的大小
#U_display_number 单元格内数字是否显示(TRUE,FALSE)
#如果U_display_number值为TRUE时，以下两个参数的设置才生效，无论TRUE或者FALSE以下两个参数都需要传递值
#U_fontcolor 表格字体颜色,默认传"grey"
#U_fontsize 表格字体大小
#display_grid 是否画出格子的边界(TRUE,FALSE)
#display_rowcol_text 结果是否显示行名和列名(TRUE,FALSE)
# plot_heatmap_cor("E:/code_app/R_code/Rdata/heatmap.xls",
#                  "E:/code_app/R_code/Rdata/heatmap_out.svg",
#                  "pearson",
#                  "col",
#                  c("green","white"),
#                  10,
#                  FALSE,
#                  "grey",
#                  8,
#                  TRUE,
#                  TRUE)
plot_heatmap_cor=function(data_filepath,out_picpath,
                          cor_type="pearson",
                          cal_dir="col",
                          U_color=c("green","white"),
                          U_text_fontsize=10,
                          U_display_number=FALSE,
                          U_fontcolor="grey",
                          U_fontsize=8,
                          display_grid=TRUE,
                          display_rowcol_text=TRUE){
  library(corrplot)
  library(ggplot2)
  library(Cairo)
  library(openxlsx)
  
  line_data=NULL
  file_type=unlist(strsplit(data_filepath,"[.]"))[-1]
  file_type=file_type[length(file_type)]
  if(file_type=="txt")
    line_data=read.table(data_filepath,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
  if(file_type=="csv")
    line_data=read.csv(data_filepath,header=TRUE,row.names = 1,sep=",",na.strings=c("NA"),check.names=F)
  if(file_type=="xlsx")
    line_data=read.xlsx(data_filepath,colNames = TRUE,rowNames = TRUE,na.strings=c("NA"))
  
  
  if(cal_dir=="row")
    line_data=-t(line_data)
  matrix_data=cor(line_data,method = cor_type)
  color = colorRampPalette(U_color)(102)
  if(U_display_number){
    if(display_grid){
      if(display_rowcol_text){
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addCoef.col=U_fontcolor,number.cex = U_fontsize/10,
                      number.digits = 4,addgrid.col="grey")
        graphics.off()
      }
      else{
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addCoef.col=U_fontcolor,number.cex = U_fontsize/10,
                      number.digits = 4,addgrid.col="grey",tl.pos = "n")
        graphics.off()
      }
      
    }
    else{
      if(display_rowcol_text){
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addCoef.col=U_fontcolor,number.cex = U_fontsize/10,
                      number.digits = 4)
        graphics.off()
      }
      else{
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addCoef.col=U_fontcolor,number.cex = U_fontsize/10,
                      number.digits = 4,tl.pos = "n")
        graphics.off()
      }
    }
  }
  else{
    if(display_grid){
      if(display_rowcol_text){
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addgrid.col="grey")
        graphics.off()
      }
      else{
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addgrid.col="grey",tl.pos = "n")
        graphics.off()
      }
      
    }
    else{
      if(display_rowcol_text){
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE)
        graphics.off()
      }
      else{
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,tl.pos = "n")
        graphics.off()
      }
      
    }
  }
}





#组间相关性热图
#data_filepath1 数据文件1路径,支持txt,csv,xlsx
#data_filepath2 数据文件2路径,支持txt,csv,xlsx
#out_picpath 输出的图片路径，svg格式
#cor_type 分析类型(string) 输入三者之一("pearson","kendall","spearman")
#U_color 颜色
#U_text_fontsize 标签文字的大小
#U_display_number 单元格内数字是否显示(TRUE,FALSE)
#如果U_display_number值为TRUE时，以下两个参数的设置才生效，无论TRUE或者FALSE以下两个参数都需要传递值
#U_fontcolor 表格字体颜色,默认传"grey"
#U_fontsize 表格字体大小
#display_grid 是否画出格子的边界(TRUE,FALSE)
#display_rowcol_text 结果是否显示行名和列名(TRUE,FALSE)

plot_heatmap_cor2=function(data_filepath,out_picpath,
                           cor_type="pearson",
                           U_color=c("green","white"),
                           U_text_fontsize=10,
                           U_display_number=FALSE,
                           U_fontcolor="grey",
                           U_fontsize=8,
                           display_grid=TRUE,
                           display_rowcol_text=TRUE){
  library(corrplot)
  library(ggplot2)
  library(Cairo)
  library(openxlsx)
  
  line_data1=NULL
  file_type1=unlist(strsplit(data_filepath[1],"[.]"))
  file_type1=file_type1[length(file_type1)]
  if(file_type1=="txt")
    line_data1=read.table(data_filepath[1],header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
  if(file_type1=="csv")
    line_data1=read.csv(data_filepath[1],header=TRUE,row.names = 1,sep=",",na.strings=c("NA"),check.names=F)
  if(file_type1=="xlsx")
    line_data1=read.xlsx(data_filepath[1],colNames = TRUE,rowNames = TRUE,na.strings=c("NA"))
  
  line_data2=NULL
  file_type2=unlist(strsplit(data_filepath[2],"[.]"))[-1]
  file_type2=file_type2[length(file_type2)]
  if(file_type2=="txt")
    line_data2=read.table(data_filepath[2],header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
  if(file_type2=="csv")
    line_data2=read.csv(data_filepath[2],header=TRUE,row.names = 1,sep=",",na.strings=c("NA"),check.names=F)
  if(file_type2=="xlsx")
    line_data2=read.xlsx(data_filepath[2],colNames = TRUE,rowNames = TRUE,na.strings=c("NA"))
  
  
  line_data1=-t(line_data1)
  line_data2=-t(line_data2)
  
  matrix_data=cor(line_data1,line_data2,method = cor_type)
  color = colorRampPalette(U_color)(102)
  
  if(U_display_number){
    if(display_grid){
      if(display_rowcol_text){
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addCoef.col=U_fontcolor,number.cex = U_fontsize/10,
                      number.digits = 4,addgrid.col="grey")
        graphics.off()
      }
      else{
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addCoef.col=U_fontcolor,number.cex = U_fontsize/10,
                      number.digits = 4,addgrid.col="grey",tl.pos = "n")
        graphics.off()
      }
      
    }
    else{
      if(display_rowcol_text){
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addCoef.col=U_fontcolor,number.cex = U_fontsize/10,
                      number.digits = 4)
        graphics.off()
      }
      else{
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addCoef.col=U_fontcolor,number.cex = U_fontsize/10,
                      number.digits = 4,tl.pos = "n")
        graphics.off()
      }
    }
  }
  else{
    if(display_grid){
      if(display_rowcol_text){
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addgrid.col="grey")
        graphics.off()
      }
      else{
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,addgrid.col="grey",tl.pos = "n")
        graphics.off()
      }
      
    }
    else{
      if(display_rowcol_text){
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE)
        graphics.off()
      }
      else{
        CairoSVG(file=out_picpath,width = ncol(matrix_data)+3,height = nrow(matrix_data)+3)
        plot=corrplot(corr = matrix_data,method="color",col = color,tl.cex = U_text_fontsize/10,
                      is.corr=FALSE,tl.pos = "n")
        graphics.off()
      }
      
    }
  }
}

# plot_heatmap_cor2("E:/code_app/R_code/Rdata/ica2_1.eg.xlsx",
#                   "E:/code_app/R_code/Rdata/ica2_2.eg.txt",
#                   "E:/code_app/R_code/Rdata/heatmap_out.svg",
#                   "pearson",
#                   c("green","white"),
#                   10,
#                   FALSE,
#                   "grey",
#                   8,
#                   TRUE,
#                   TRUE)



#3.动态UPSet图
#file_path          输入文件路径
#out_path           输出图片路径
#p_width            图片宽度——inches
#p_height           图片高度——inches
#set_lable          集合（横矩形）名
#y_lable            纵矩形名
#point_color        点颜色
#y_color            纵矩形颜色
#set_color          集合(横矩形)颜色
#ydata_show         y轴数据是否显示——"yes" or "no"
#order_by           矩阵中交集排序方式，"freq"从大到小排序，其他选项degree, 先freq后degree
#point_size         点大小
#line_size          线宽度
#upset_order        按使用sets参数输入的顺序保留集合。函数中默认值为FALSE，按大小对集合进行排序，此处为TRUE
#intersection_num   要绘制的交点数。如果设置为NA，将绘制所有交点

upset_chart <- function(file_path,
                        out_path,
                        p_width = 8,
                        p_height = 8,
                        set_lable = "Set Size",
                        y_lable = "Intersection Size",
                        point_color = c("black"),
                        y_color = c("black"),
                        set_color = NULL,
                        ydata_show = "yes",
                        order_by = c("freq"),
                        point_size = 3,
                        line_size = 1,
                        upset_order = TRUE,
                        intersection_num = NA
){
  library(UpSetR) 
  library(svglite)
  
  file_data <- read.table(file_path, header = TRUE, sep = "\t")
  
  col_name <- colnames(file_data)
  
  colnum = ncol(file_data)
  rownum = nrow(file_data)
  
  datalist <- list()
  
  for(i in 1:colnum){
    t = c()
    for(j in 1:rownum){
      if(is.na(file_data[j,i])){
        break
      }
      t = c(t,file_data[j,i])
    }
    
    datalist_t = list(t)
    datalist = c(datalist, datalist_t)
  }
  
  names(datalist) <- col_name #修改列表名
  
  if(is.null(set_color)){
    set_color = rainbow(colnum) #设置集合默认颜色
  }
  
  p <- upset(fromList(datalist), 
             nsets = length(datalist),
             sets = col_name,
             order.by = order_by, #矩阵中交集排序方式，"freq"从大到小排序，其他选项degree, 先freq后degree
             point.size = point_size, #点大小
             line.size = line_size, #线宽度
             text.scale = c(1.5, 1.2, 1.2, 1, 1.5, 1), # ytitle, ylabel, xtitle, xlabel, sets, number
             matrix.color = point_color, #点颜色
             main.bar.color = y_color, #y轴颜色
             mainbar.y.label = y_lable, #y轴标题
             sets.bar.color = set_color, #x轴集合颜色
             nintersects = intersection_num, #要绘制的交点数。如果设置为NA，将绘制所有交点
             keep.order = upset_order, #按使用sets参数输入的顺序保留集合。默认值为FALSE，按大小对集合进行排序
             sets.x.label = set_lable, #x轴标题
             show.numbers = ydata_show, #y轴数据是否显示
             group.by = "degree" #数据分组依据("degree" or "sets")
  )
  
  #保存图片
  svglite(out_path, width = p_width, height = p_height)
  print(p) #该图片只能通过print方式写至创建的空白画布中
  graphics.off() #upset画图开启的好像不是一条线，所以需要使用graphics.off()函数，全部关闭
}


# upset_chart("upset.txt", #输入文件路径
#             "upsetchart.svg", #图片输出路径
#             8,8, #宽✖高
#             "Set Size", #集合(横矩形)名
#             "Intersection Size", #纵矩形名
#             order_by = c("freq") #c("freq"), c("degree"), c("freq", "degree")
# ) 


#动态图

#1.三元图
#file_path1   输入文件1——数据文件
#file_path2   输入文件2——分组文件
#out_path1    图片输出路径1——png格式
#out_path2    图片输出路径2——png格式
#out_path3    文件输出路径——txt格式
#main_name    图片主标题
#points_color，一般为三个颜色一起
#points_size  点大小
#point_shape 点形状,labels_position为标签位置
#grid_colors 网格颜色，grid_style为网格形式,border_color 为边界颜色，bg_color为背景颜色
#whether_legend 是否画图例——TRUE 画图例，FALSE 不画

ternary_chart <- function(file_path,
                          out_path, 
                          main_name = "asd",point_shape=18,grid_colors="gray",
                          points_size = 2,points_color=c("red","blue","green"), 
                          whether_legend = TRUE,border_color="black",
                          bg_color="white",grid_style = "dashed",
                          labels_position = "outside"
){
  library(grid)
  library(vcd)
  library(svglite)
  
  file_data1 <- read.table(file_path[1], header = TRUE)
  file_data2 <- read.table(file_path[2], header = TRUE)
  
  colname1 <- colnames(file_data1)
  colname2 <- colnames(file_data2)
  colname <-c(colname1[1], colname2[1], colname2[2], colname2[3], colname1[11])
  rownum = nrow(file_data1)#行数
  arr <- array(1:(rownum*5), c(rownum,5))#创建rownum行5列数组
  my_data <- as.data.frame(arr)#根据数据创建数据框
  names(my_data) <- colname#修改数据框列名
  
  for(i in 1:rownum){
    my_data[i,1] = file_data1[i, 1]
    for(j in 1:3){
      my_data[i,1+j] = (file_data1[i,(j-1)*3+2] + file_data1[i,(j-1)*3+3] + file_data1[i,(j-1)*3+4])/3
    }
    my_data[i,5] = file_data1[i,11]
  }
  
  #导出数据，txt格式
  write.table(my_data, #需要导出的数据
              out_path[3], #文件路径
              sep = "\t", #分隔符，默认为空格
              row.names = FALSE, #是否输出行名，默认为TRUE
              col.names = TRUE, #是否输出列名，默认为TRUE
              quote = FALSE)#字符串是否使用引号表示，默认为TRUE
  
  
  #输出图片1——富集三元图
  
  #点的大小
  #my_data$size <- (apply(my_data[2:4], 1, mean)) ^ points_size
  
  #点的颜色——富集三元图
  my_data[which(my_data[,5] == colname2[1]), "color"] <-points_color[3]#"red"
  my_data[which(my_data[,5] == colname2[2]), "color"] <-points_color[2]#"blue"
  my_data[which(my_data[,5] == colname2[3]), "color"] <-points_color[1]#"green3"
  my_data[which(my_data[,5] == "none"), "color"] <-"gray"
  
  
  my_data$size <- (apply(my_data[2:4], 1, mean)) ^ points_size#自定义点大小
  #输出图片1——富集三元图
  svglite(out_path[1])
  ternaryplot(my_data[2:4], 
              scale = NULL, 
              col = my_data$color, #点的颜色
              prop_size = FALSE, 
              cex = points_size, #点的大小
              pch=point_shape,
              bg=bg_color,
              labels=labels_position,
              grid=grid_style,
              grid_color=grid_colors,
              border=border_color,
              main = main_name)
  if(whether_legend){
    grid_legend(x = "topright", 
                pch = point_shape, #点样式
                col = points_color,
                label = colname2,
                title = "Enrich",
                size = 1, #点大小
                frame = FALSE)
  }
  dev.off()
  
  #输出图片2——分布三元图
  svglite(out_path[2])
  ternaryplot(my_data[2:4], 
              scale = NULL, 
              col = rainbow(rownum), #点的颜色
              prop_size = FALSE, 
              pch=point_shape,
              bg=bg_color,
              grid_color=grid_colors,
              labels=labels_position,
              grid=grid_style,
              border=border_color,
              cex = points_size, #点的大小
              main = main_name)
  #画图例
  if(whether_legend){
    grid_legend(x = "topright", 
                #y = 0.7, 
                #xpd = TRUE,
                pch = point_shape, #点样式
                col = rainbow(rownum), 
                label = my_data[,1], 
                title = "Group", 
                size = 1, #点大小
                frame = FALSE)
  }
  dev.off()
}




# ternary_chart("ternary-out.txt", #输入文件1——数据文件
#               "ternary-group.txt", #输入文件2——分组文件
#               "ternary_enrich_test1.svg", #输出图片1——富集三元图——png格式
#               "ternary_focus_test1.svg", #输出图片2——分布三元图——png格式
#               "ternary_test.txt", #数据文件输出路径——txt格式
#               "sss", #主标题
#               0.5, #点大小
#               TRUE) #画图例




#5.动态ROC曲线
#输入txt,输出svg
#low_col为下方颜色，uper_col为上方区域颜色
#auc_show为是否显示AUC的值
#uper_show为是否显示上方区域
#max_point为是否显示最大值的点坐标
#grid_col为网格颜色，c("green","red")，绿色为竖线，红色为横线
#x_text为X标题，y_text为Y标题，main_text为主标题
#ci_show为是否展示置信区间
#grid_show为是否展示网格
#line_col为线的颜色,identity_col为对角线颜色
#identity_show为是否添加对角线
#percent_show为转换为分数形式
#实例
#ROC('roc.txt','roc.svg')
ROC <- function(file_path,
                out_path,
                low_col='skyblue',
                uper_col='orange',
                grid_col=c("green","red"),
                auc_show=T,
                uper_show=T,
                max_point=T,
                x_text='Specificity',
                y_text='Sensitivity',
                main_text='ROC',
                line_col='red',
                ci_show=F,
                grid_show=T,
                percent_show=F,
                identity_col='darkgrey',
                identity_show=T
                
){
  library(pROC)
  library(ggplot2)
  library(svglite)
  svglite(out_path)
  data1<-read.table(file_path,header = T)
  colnames(data1)[1] <- 'ss'
  colnames(data1)[2] <- 'pp'
  roc1<-roc(data1$ss,data1$pp,ci=ci_show,percent=percent_show,partial.auc.correct=F)
  auc(roc1)
  plot(roc1,print.auc=auc_show,auc.polygon=T,grid.col=grid_col,
       max.auc.polygon=uper_show,max.auc.polygon.col=uper_col,auc.polygon.col=low_col,print.thres=max_point
       ,xlab = x_text, ylab = y_text,
       main = main_text,grid=grid_show,col=line_col,identity.col=identity_col,identity=identity_show)
  dev.off()
}
#ROC('roc.txt','roc.svg')



#4.动态火山图
#file_name输入文件名txt，out_path输出svg
#title_name标题，
#p_size点大小，x_max x最大值，y_max y最大值
#x_column x的列，x_val 阈值 y通
#down_col ，not_col ，up_col down、未标记、up三种区域颜色
volcano_plot<-function(file_name,out_path,
                       title_name="vol",p_size=1.5,
                       x_max=4,y_max=30,x_column=6,x_val=2,y_column=7,y_val=0.01,
                       down_col="#2f5688",not_col="#BBBBBB",up_col="#CC0000"){
  library(ggplot2)
  library(ggrepel)
  df<-read.table(file_name,header = T,
                 sep="\t",na.strings=c("NA"))
  df$group<- ifelse(df[,x_column]>=x_val&df[,y_column]<=y_val,"Up",
                    ifelse(df[,x_column]<=(-1)*x_val&df[,y_column]<=y_val,"Down","Not sig"))
  table(df$group)#
  
  ggplot(df,aes(x=df[,x_column],y=-log10(df[,y_column])))+
    geom_point(aes(color=group),size=p_size)+
    xlim((-1)*x_max,x_max)+
    ylim(0,y_max)+
    scale_color_manual(values=c(down_col,not_col,up_col))+
    labs(title=title_name,x ="log2(FC)", y ="-log10(Pvalue)")+
    geom_hline(yintercept = 1.30,linetype="dashed")+
    geom_vline(xintercept = c((-1)*x_val,x_val),linetype="dashed")+
    theme_bw()
  ggsave(out_path)
}
# volcano_plot("volcano.txt","volcano.svg","vol",1.5,4,30,6,2,7,0.01,"#2f5688","#BBBBBB","#CC0000")





#2.circos图
#物种关系图
#n_transparency 透明度
#grid_col 网格颜色，输入形式为c('white','balck','yellow',...)
#link_clo 为连带颜色，输入形式同上
#annotationTrack_n为三种形式,NULL,grid不显示标签，name显示标签，axis显示刻度
#颜色每次自动更新，也可以自定义颜色
#输入文件为txt,输出为svg
#circosm('chord.txt','circlize_plot2.svg')
#实例为circosm('chord.txt','circlize_plot1.svg')
circosm =function(data_filepath,out_picpath,n_transparency=0.5,grid_col=NULL,link_col=NULL,annotationTrack_n=c('grid','name','axis')){
  
  library(svglite)
  library(grid)
  #pdf(out_picpath, width =width_n, height = height_n)
  svglite(out_picpath)
  # 安装并加载所需的R包
  # install.packages("circlize")
  library(circlize)
  #读取数据
  data1 <- read.table(data_filepath, header = TRUE)
  data2 <- read.table(data_filepath, header = F)
  len_dim=dim(data1)[2]#列
  len_row=dim(data1)[1]#行
  mat=NULL
  row=NULL
  dim=NULL
  for(j in 2:len_dim){
    
    dim<-c(dim,data2[1,j])
    for(i in 1:len_row){
      if(j==2){
        row<-c(row,data1[i,1])}
      mat<-c(mat,data1[i,j])
    }
  }
  
  # 构建邻接列表数据框
  #df = data.frame(from = rep(data1[,1],times=len_dim-1), #起始对象
  #to = rep(data2[1,2:len_dim],each=len_row), #终止对象
  #value = as.vector(mat),#起始对象与终止对象之间的相互作用强度
  #stringsAsFactors = FALSE)
  df = data.frame(from = rep(row,times=len_dim-1), #起始对象
                  to = rep(dim,each=len_row), #终止对象
                  value = as.vector(mat),#起始对象与终止对象之间的相互作用强度
                  stringsAsFactors = FALSE)
  #head(df)
  
  
  # 使用chordDiagram函数绘制和弦图
  # 使用邻接矩阵绘图
  chordDiagram(df,transparency=n_transparency,grid.col=grid_col,col=link_col,annotationTrack=annotationTrack_n)
  # 结束绘图，返回默认设置，否则会继续叠加图层
  #circos.clear() 
  
  dev.off()
}
# circosm('E:/idea_java_code/biologicalCloudToolsData/UploadFolder/001@qq.com/20210609210342_circos.txt','E:/idea_java_code/biologicalCloudToolsData/UserFolder/001@qq.com/20210609210342_circos.svg')















#热力图(分组)
#data_filepath 数据文件路径
#group_filepath 分组文件,用户不提交分组文件则传NULL
#out_picpath 输出的图片路径，svg格式
#U_ncol 用于做图的列(int数组),用户输入"1-4,7",则传入"c(1,2,3,4,7)"
#U_nrow 用于做图的行(int)
#U_scale 归一化(row,column,none),默认为row
#U_cluster_row 行聚类(TRUE,False),默认为TRUE
#U_cluster_cols 列聚类(TRUE,False),默认为TRUE
#U_color 颜色(从左到右，代表数值越来越小),传NULL则默认颜色 
#U_fontsize 表格字体大小
#U_fontsize_rowcol 行和列的字体大小
#U_display_number 单元格内数字是否显示(TRUE,FALSE)
#U_border_color 单元格边框颜色(NA为不显示边框)
#U_show_rownames 结果是否显示行名(TRUE,FALSE)
#U_show_colnames 结果是否显示列名(TRUE,FALSE)
#U_number_color 单元格数字颜色,默认为灰色("grey30")
#U_cellwidth  单元格宽度
#U_cellheight  单元格长度

# plot_heatmap_dy=function(data_filepath,group_filepath,out_picpath,U_ncol,U_nrow,U_scale,U_cluster_row,U_cluster_cols,U_color,U_fontsize,U_fontsize_rowcol,U_display_number,U_border_color,U_show_rownames,U_show_colnames,U_number_color="grey30",U_cellwidth=NA,U_cellheight=NA ){
#   library(pheatmap)
#   library(ggplot2)
#   library(reshape2)
#   line_data=read.table(data_filepath,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
#   
#   if(!is.null(group_filepath)){
#     group_data=read.table(group_filepath,header=TRUE,sep="\t",check.names=F)
#     sample_names=c()
#     group_names=c()
#     for(i in 1:ncol(group_data)){
#       coldata=group_data[,i]
#       for(j in 1:length(coldata)){
#         if(!is.null(coldata[j])){
#           sample_names=c(sample_names,coldata[j])
#           group_names=c(group_names,colnames(group_data)[i])
#         }
#       }
#     }
#     group_col=data.frame(Group = factor(group_names))
#     rownames(group_col) = sample_names
#     merge_data=line_data[1:nrow(line_data),1:ncol(line_data)]
#     if(is.null(U_color)){
#       plot=pheatmap(merge_data,scale = U_scale,cluster_row = U_cluster_row,cluster_cols = U_cluster_cols,
#                     fontsize = U_fontsize,fontsize_row = U_fontsize_rowcol,
#                     fontsize_col = U_fontsize_rowcol,display_numbers = U_display_number,
#                     border_color = U_border_color,number_color = U_number_color,
#                     show_rownames = U_show_rownames,show_colnames = U_show_colnames,
#                     cellwidth = U_cellwidth,cellheight = U_cellheight,
#                     annotation_col=group_col)
#       ggsave(out_picpath,plot = plot,width = ncol(merge_data)+3,height = nrow(merge_data)+3)
#     }
#     else{
#       plot=pheatmap(merge_data,scale = U_scale,cluster_row = U_cluster_row,cluster_cols = U_cluster_cols,
#                     fontsize = U_fontsize,fontsize_row = U_fontsize_rowcol,fontsize_col = U_fontsize_rowcol,
#                     color = colorRampPalette(rev(U_color))(102),display_numbers = U_display_number,
#                     border_color = U_border_color,number_color = U_number_color,
#                     show_rownames = U_show_rownames,show_colnames = U_show_colnames,
#                     cellwidth = U_cellwidth,cellheight = U_cellheight,
#                     annotation_col=group_col)
#       ggsave(out_picpath,plot = plot,width = ncol(merge_data)+3,height = nrow(merge_data)+3)
#     }
#   }
#   else{
#     sample_names=c()
#     gene_names=row.names(line_data)[1:U_nrow]
#     for(i in 1:length(U_ncol)){
#       sample_names=c(sample_names,names(line_data)[U_ncol[i]])
#     }
#     
#     merge_data=line_data[1:U_nrow,U_ncol[1]]
#     for(i in 2:length(U_ncol)){
#       col_data=line_data[1:U_nrow,U_ncol[i]]
#       merge_data=data.frame(merge_data,col_data)
#     }
#     names(merge_data)=sample_names
#     row.names(merge_data)=gene_names
#     
#     # merge_data=line_data[1:nrow(line_data),1:ncol(line_data)]
#     if(is.null(U_color)){
#       plot=pheatmap(merge_data,scale = U_scale,cluster_row = U_cluster_row,cluster_cols = U_cluster_cols,
#                     fontsize = U_fontsize,fontsize_row = U_fontsize_rowcol,
#                     fontsize_col = U_fontsize_rowcol,display_numbers = U_display_number,
#                     border_color = U_border_color,number_color = U_number_color,
#                     show_rownames = U_show_rownames,show_colnames = U_show_colnames,
#                     cellwidth = U_cellwidth,cellheight = U_cellheight)
#       ggsave(out_picpath,plot = plot,width = ncol(merge_data)+3,height = nrow(merge_data)+3)
#     }
#     else{
#       plot=pheatmap(merge_data,scale = U_scale,cluster_row = U_cluster_row,cluster_cols = U_cluster_cols,
#                     fontsize = U_fontsize,fontsize_row = U_fontsize_rowcol,fontsize_col = U_fontsize_rowcol,
#                     color = colorRampPalette(rev(U_color))(102),display_numbers = U_display_number,
#                     border_color = U_border_color,number_color = U_number_color,
#                     show_rownames = U_show_rownames,show_colnames = U_show_colnames,
#                     cellwidth = U_cellwidth,cellheight = U_cellheight)
#       ggsave(out_picpath,plot = plot,width = ncol(merge_data)+3,height = nrow(merge_data)+3)
#     }
#   }
# }
# plot_heatmap_dy("E:/code_app/R_code/Rdata/heatmap.txt",
#                 "E:/code_app/R_code/Rdata/heatmap_group.txt",
#                 "E:/code_app/R_code/Rdata/heatmap_out.svg",
#                 c(1,2,4,5),
#                 3,
#                 "row",
#                 TRUE,
#                 TRUE,
#                 NULL,
#                 10,
#                 5,
#                 F,
#                 "NA",
#                 TRUE,
#                 TRUE)
# 
# 
# 
# 
# 
# 
# #小提琴图
# plot_violin_dy=function(data_filepath,out_picpath){
#   library(ggplot2)
#   library(vioplot)
#   library(reshape2)
#   file_data=read.table(data_filepath,header=TRUE,sep="\t",na.strings=c("NA"),check.names=F)
#   file_data=melt(file_data,id=names(file_data)[1])
#   
#   plot=ggplot(file_data, aes(x=variable, y=value))
#   plot+geom_violin(aes(fill=variable,linetype=NA),trim = FALSE)+
#     geom_boxplot(width=0.2,outlier.colour = NA,aes(fill=variable),show.legend = FALSE)+
#     # geom_jitter(shape=16,aes(fill=variable),alpha=0.5,size=0.3,position = position_jitter(0.2),show.legend = FALSE)+
#     stat_summary(fun=median, geom="point",color="white",size=2)+
#     xlab("")+ylab("")+
#     labs(fill="",color="")+
#     theme_bw()
#   
#   # ggsave(out_picpath,width = 10,height = 10)
# }
# plot_violin_dy("E:/code_app/R_code/Rdata/new_violin.txt",
#                "E:/code_app/R_code/Rdata/violin_out.svg")
# 
# 
# 
# # file_data=read.table(data_filepath,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
# # colname=names(file_data)
# # print(colname)
# # 
# # vioplot(x=file_data,
# #         col="red", #小提琴颜色
# #         border="white", #小提琴边框颜色
# #         rectCol="white", #箱子的颜色
# #         colMed="yellow", #点的颜色
# #         names=colname)
# 
# 
# 
# 
# #PCA
# #data_filepath1 数据文件1路径,支持txt,csv,xlsx
# #data_filepath2 数据文件2路径,支持txt,csv,xlsx
# #data_filepath3 数据文件2路径,支持txt,csv,xlsx
# plot_PCA=function(data_filepath1,data_filepath2,data_filepath3){
#   library(openxlsx)
#   library(factoextra)
#   library(FactoMineR)
#   
#   line_data1=NULL
#   file_type1=unlist(strsplit(data_filepath1,"[.]"))
#   file_type1=file_type1[length(file_type1)]
#   if(file_type1=="txt")
#     line_data1=read.table(data_filepath1,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
#   if(file_type1=="csv")
#     line_data1=read.csv(data_filepath1,header=TRUE,row.names = 1,sep=",",na.strings=c("NA"),check.names=F)
#   if(file_type1=="xlsx")
#     line_data1=read.xlsx(data_filepath1,colNames = TRUE,rowNames = TRUE,na.strings=c("NA"))
#   
#   line_data2=NULL
#   file_type2=unlist(strsplit(data_filepath2,"[.]"))[-1]
#   file_type2=file_type2[length(file_type2)]
#   if(file_type2=="txt")
#     line_data2=read.table(data_filepath2,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
#   if(file_type2=="csv")
#     line_data2=read.csv(data_filepath2,header=TRUE,row.names = 1,sep=",",na.strings=c("NA"),check.names=F)
#   if(file_type2=="xlsx")
#     line_data2=read.xlsx(data_filepath2,colNames = TRUE,rowNames = TRUE,na.strings=c("NA"))
#   
#   line_data3=NULL
#   file_type3=unlist(strsplit(data_filepath3,"[.]"))[-1]
#   file_type3=file_type3[length(file_type3)]
#   if(file_type3=="txt")
#     line_data3=read.table(data_filepath3,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
#   if(file_type3=="csv")
#     line_data3=read.csv(data_filepath3,header=TRUE,row.names = 1,sep=",",na.strings=c("NA"),check.names=F)
#   if(file_type3=="xlsx")
#     line_data2=read.xlsx(data_filepath3,colNames = TRUE,rowNames = TRUE,na.strings=c("NA"))
#   
#   line_data1=-t(line_data1)
#   pca_prcomp=prcomp(line_data1,scale=TRUE)
#   pca_data = predict(pca_prcomp)
#   # plot(pca_data[,1:2]) 
#   
#   biplot(pca_prcomp)
#   
#   # p<-predict(line_data1.pr)
#   # print(p)
#   
# }
# 
# plot_PCA("E:/code_app/R_code/Rdata/exam.fpkm3.eg.xlsx",
#          "E:/code_app/R_code/Rdata/exam.group3.eg.xlsx",
#          "E:/code_app/R_code/Rdata/exam.row.eg.xlsx")
# 


