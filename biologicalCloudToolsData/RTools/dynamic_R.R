

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

plot_heatmap_cor=function(data_filepath,out_picpath,cor_type,cal_dir,U_color,U_text_fontsize,U_display_number,U_fontcolor,U_fontsize,display_grid,display_rowcol_text){
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
plot_heatmap_cor("E:/code_app/R_code/Rdata/heatmap.xls",
                 "E:/code_app/R_code/Rdata/heatmap_out.svg",
                 "pearson",
                 "col",
                 c("green","white"),
                 10,
                 FALSE,
                 "grey",
                 8,
                 TRUE,
                 TRUE)



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

plot_heatmap_cor2=function(data_filepath1,data_filepath2,out_picpath,cor_type,U_color,U_text_fontsize,U_display_number,U_fontcolor,U_fontsize,display_grid,display_rowcol_text){
  library(corrplot)
  library(ggplot2)
  library(Cairo)
  library(openxlsx)
  
  line_data1=NULL
  file_type1=unlist(strsplit(data_filepath1,"[.]"))
  file_type1=file_type1[length(file_type1)]
  if(file_type1=="txt")
    line_data1=read.table(data_filepath1,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
  if(file_type1=="csv")
    line_data1=read.csv(data_filepath1,header=TRUE,row.names = 1,sep=",",na.strings=c("NA"),check.names=F)
  if(file_type1=="xlsx")
    line_data1=read.xlsx(data_filepath1,colNames = TRUE,rowNames = TRUE,na.strings=c("NA"))
  
  line_data2=NULL
  file_type2=unlist(strsplit(data_filepath2,"[.]"))[-1]
  file_type2=file_type2[length(file_type2)]
  if(file_type2=="txt")
    line_data2=read.table(data_filepath2,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
  if(file_type2=="csv")
    line_data2=read.csv(data_filepath2,header=TRUE,row.names = 1,sep=",",na.strings=c("NA"),check.names=F)
  if(file_type2=="xlsx")
    line_data2=read.xlsx(data_filepath2,colNames = TRUE,rowNames = TRUE,na.strings=c("NA"))
  
  
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

plot_heatmap_cor2("E:/code_app/R_code/Rdata/ica2_1.eg.xlsx",
                  "E:/code_app/R_code/Rdata/ica2_2.eg.txt",
                  "E:/code_app/R_code/Rdata/heatmap_out.svg",
                  "pearson",
                  c("green","white"),
                  10,
                  FALSE,
                  "grey",
                  8,
                  TRUE,
                  TRUE)
































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

plot_heatmap_dy=function(data_filepath,group_filepath,out_picpath,U_ncol,U_nrow,U_scale,U_cluster_row,U_cluster_cols,U_color,U_fontsize,U_fontsize_rowcol,U_display_number,U_border_color,U_show_rownames,U_show_colnames,U_number_color="grey30",U_cellwidth=NA,U_cellheight=NA ){
  library(pheatmap)
  library(ggplot2)
  library(reshape2)
  line_data=read.table(data_filepath,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
  
  if(!is.null(group_filepath)){
    group_data=read.table(group_filepath,header=TRUE,sep="\t",check.names=F)
    sample_names=c()
    group_names=c()
    for(i in 1:ncol(group_data)){
      coldata=group_data[,i]
      for(j in 1:length(coldata)){
        if(!is.null(coldata[j])){
          sample_names=c(sample_names,coldata[j])
          group_names=c(group_names,colnames(group_data)[i])
        }
      }
    }
    group_col=data.frame(Group = factor(group_names))
    rownames(group_col) = sample_names
    merge_data=line_data[1:nrow(line_data),1:ncol(line_data)]
    if(is.null(U_color)){
      plot=pheatmap(merge_data,scale = U_scale,cluster_row = U_cluster_row,cluster_cols = U_cluster_cols,
               fontsize = U_fontsize,fontsize_row = U_fontsize_rowcol,
               fontsize_col = U_fontsize_rowcol,display_numbers = U_display_number,
               border_color = U_border_color,number_color = U_number_color,
               show_rownames = U_show_rownames,show_colnames = U_show_colnames,
               cellwidth = U_cellwidth,cellheight = U_cellheight,
               annotation_col=group_col)
      ggsave(out_picpath,plot = plot,width = ncol(merge_data)+3,height = nrow(merge_data)+3)
    }
    else{
      plot=pheatmap(merge_data,scale = U_scale,cluster_row = U_cluster_row,cluster_cols = U_cluster_cols,
               fontsize = U_fontsize,fontsize_row = U_fontsize_rowcol,fontsize_col = U_fontsize_rowcol,
               color = colorRampPalette(rev(U_color))(102),display_numbers = U_display_number,
               border_color = U_border_color,number_color = U_number_color,
               show_rownames = U_show_rownames,show_colnames = U_show_colnames,
               cellwidth = U_cellwidth,cellheight = U_cellheight,
               annotation_col=group_col)
      ggsave(out_picpath,plot = plot,width = ncol(merge_data)+3,height = nrow(merge_data)+3)
    }
  }
  else{
    sample_names=c()
    gene_names=row.names(line_data)[1:U_nrow]
    for(i in 1:length(U_ncol)){
      sample_names=c(sample_names,names(line_data)[U_ncol[i]])
    }
    
    merge_data=line_data[1:U_nrow,U_ncol[1]]
    for(i in 2:length(U_ncol)){
      col_data=line_data[1:U_nrow,U_ncol[i]]
      merge_data=data.frame(merge_data,col_data)
    }
    names(merge_data)=sample_names
    row.names(merge_data)=gene_names
    
    # merge_data=line_data[1:nrow(line_data),1:ncol(line_data)]
    if(is.null(U_color)){
      plot=pheatmap(merge_data,scale = U_scale,cluster_row = U_cluster_row,cluster_cols = U_cluster_cols,
               fontsize = U_fontsize,fontsize_row = U_fontsize_rowcol,
               fontsize_col = U_fontsize_rowcol,display_numbers = U_display_number,
               border_color = U_border_color,number_color = U_number_color,
               show_rownames = U_show_rownames,show_colnames = U_show_colnames,
               cellwidth = U_cellwidth,cellheight = U_cellheight)
      ggsave(out_picpath,plot = plot,width = ncol(merge_data)+3,height = nrow(merge_data)+3)
    }
    else{
      plot=pheatmap(merge_data,scale = U_scale,cluster_row = U_cluster_row,cluster_cols = U_cluster_cols,
               fontsize = U_fontsize,fontsize_row = U_fontsize_rowcol,fontsize_col = U_fontsize_rowcol,
               color = colorRampPalette(rev(U_color))(102),display_numbers = U_display_number,
               border_color = U_border_color,number_color = U_number_color,
               show_rownames = U_show_rownames,show_colnames = U_show_colnames,
               cellwidth = U_cellwidth,cellheight = U_cellheight)
      ggsave(out_picpath,plot = plot,width = ncol(merge_data)+3,height = nrow(merge_data)+3)
    }
  }
}
plot_heatmap_dy("E:/code_app/R_code/Rdata/heatmap.txt",
                "E:/code_app/R_code/Rdata/heatmap_group.txt",
                "E:/code_app/R_code/Rdata/heatmap_out.svg",
                c(1,2,4,5),
                3,
                "row",
                TRUE,
                TRUE,
                NULL,
                10,
                5,
                F,
                "NA",
                TRUE,
                TRUE)






#小提琴图
plot_violin_dy=function(data_filepath,out_picpath){
  library(ggplot2)
  library(vioplot)
  library(reshape2)
  file_data=read.table(data_filepath,header=TRUE,sep="\t",na.strings=c("NA"),check.names=F)
  file_data=melt(file_data,id=names(file_data)[1])
  
  plot=ggplot(file_data, aes(x=variable, y=value))
  plot+geom_violin(aes(fill=variable,linetype=NA),trim = FALSE)+
    geom_boxplot(width=0.2,outlier.colour = NA,aes(fill=variable),show.legend = FALSE)+
    # geom_jitter(shape=16,aes(fill=variable),alpha=0.5,size=0.3,position = position_jitter(0.2),show.legend = FALSE)+
    stat_summary(fun=median, geom="point",color="white",size=2)+
    xlab("")+ylab("")+
    labs(fill="",color="")+
    theme_bw()
  
  # ggsave(out_picpath,width = 10,height = 10)
}
plot_violin_dy("E:/code_app/R_code/Rdata/new_violin.txt",
               "E:/code_app/R_code/Rdata/violin_out.svg")



# file_data=read.table(data_filepath,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
# colname=names(file_data)
# print(colname)
# 
# vioplot(x=file_data,
#         col="red", #小提琴颜色
#         border="white", #小提琴边框颜色
#         rectCol="white", #箱子的颜色
#         colMed="yellow", #点的颜色
#         names=colname)




#PCA
#data_filepath1 数据文件1路径,支持txt,csv,xlsx
#data_filepath2 数据文件2路径,支持txt,csv,xlsx
#data_filepath3 数据文件2路径,支持txt,csv,xlsx
plot_PCA=function(data_filepath1,data_filepath2,data_filepath3){
  library(openxlsx)
  library(factoextra)
  library(FactoMineR)
  
  line_data1=NULL
  file_type1=unlist(strsplit(data_filepath1,"[.]"))
  file_type1=file_type1[length(file_type1)]
  if(file_type1=="txt")
    line_data1=read.table(data_filepath1,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
  if(file_type1=="csv")
    line_data1=read.csv(data_filepath1,header=TRUE,row.names = 1,sep=",",na.strings=c("NA"),check.names=F)
  if(file_type1=="xlsx")
    line_data1=read.xlsx(data_filepath1,colNames = TRUE,rowNames = TRUE,na.strings=c("NA"))
  
  line_data2=NULL
  file_type2=unlist(strsplit(data_filepath2,"[.]"))[-1]
  file_type2=file_type2[length(file_type2)]
  if(file_type2=="txt")
    line_data2=read.table(data_filepath2,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
  if(file_type2=="csv")
    line_data2=read.csv(data_filepath2,header=TRUE,row.names = 1,sep=",",na.strings=c("NA"),check.names=F)
  if(file_type2=="xlsx")
    line_data2=read.xlsx(data_filepath2,colNames = TRUE,rowNames = TRUE,na.strings=c("NA"))
  
  line_data3=NULL
  file_type3=unlist(strsplit(data_filepath3,"[.]"))[-1]
  file_type3=file_type3[length(file_type3)]
  if(file_type3=="txt")
    line_data3=read.table(data_filepath3,header=TRUE,row.names = 1,sep="\t",na.strings=c("NA"),check.names=F)
  if(file_type3=="csv")
    line_data3=read.csv(data_filepath3,header=TRUE,row.names = 1,sep=",",na.strings=c("NA"),check.names=F)
  if(file_type3=="xlsx")
    line_data2=read.xlsx(data_filepath3,colNames = TRUE,rowNames = TRUE,na.strings=c("NA"))
  
  line_data1=-t(line_data1)
  pca_prcomp=prcomp(line_data1,scale=TRUE)
  pca_data = predict(pca_prcomp)
  # plot(pca_data[,1:2]) 
  
  biplot(pca_prcomp)
  
  # p<-predict(line_data1.pr)
  # print(p)
  
}

plot_PCA("E:/code_app/R_code/Rdata/exam.fpkm3.eg.xlsx",
         "E:/code_app/R_code/Rdata/exam.group3.eg.xlsx",
         "E:/code_app/R_code/Rdata/exam.row.eg.xlsx")



