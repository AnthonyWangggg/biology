package com.bioTools.demo.util;

import java.io.*;
import java.util.Vector;

public class FormatChangeUtil {


    //两表格合并
    //file_name 输入的文件路径（数组）
    //merge_type 合并种类
    //sep 缺省值替换的符号
    public static String join_table(String[] file_name,String out_path,String out_name,String merge_type,String sep_mode){
        Vector<Vector> file1=FileUtil.file_reader(file_name[0]);
        Vector<Vector> file2=FileUtil.file_reader(file_name[1]);
        Vector<Vector> merge_file = new Vector();
        String sep = "";
        switch (sep_mode){
            case "1":
                sep = "--";
                break;
            case "2":
                sep = "X";
                break;
            case "3":
                sep = "N/A";
                break;
            case "4":
                sep = "NULL";
                break;
        }

        //文件标头的合并
        Vector file_title=new Vector();
        for(int m=0;m<file1.get(0).size();m++){
            file_title.add(file1.get(0).get(m));
        }
        for(int m=1;m<file2.get(0).size();m++){
            file_title.add(file2.get(0).get(m));
        }
        merge_file.add(file_title);
        try{
            switch (merge_type){
                case "1": //内连接
                    for(int i=1;i<file1.size();i++){
                        for(int j=1;j<file2.size();j++){
                            if(file1.get(i).get(0).equals(file2.get(j).get(0))){
                                merge_file.add(file1.get(i));
                                for(int k=1;k<file2.get(j).size();k++){
                                    merge_file.lastElement().add(file2.get(j).get(k));
                                }
                                break;
                            }
                        }
                    }
                    FileUtil.file_Writer(out_path,out_name,"\t",merge_file);
                    break;

                case "2": //左连接
                    int datanum2=file2.get(0).size();
                    for(int i=1;i<file1.size();i++){
                        Vector line_data1=file1.get(i);
                        merge_file.add(line_data1);
                        for(int j=1;j<file2.size();j++){
                            Vector line_data2=file2.get(j);
                            if(line_data1.get(0).equals(line_data2.get(0))){
                                for(int k=1;k<datanum2;k++){
                                    merge_file.lastElement().add(line_data2.get(k));
                                }
                                break;
                            }
                            if(j==file2.size()-1){
                                for(int k=1;k<datanum2;k++){
                                    merge_file.lastElement().add(sep);
                                }
                            }
                        }

                    }
                    FileUtil.file_Writer(out_path,out_name,"\t",merge_file);
                    break;

                case "3": //右连接
                    int datanum3_1=file1.get(0).size();
                    int datanum3_2=file2.get(0).size();
                    for(int i=1;i<file2.size();i++){
                        Vector line_data2=file2.get(i);
                        for(int j=1;j<file1.size();j++){
                            Vector line_data1=file1.get(j);
                            if(line_data2.get(0).equals(line_data1.get(0))){
                                merge_file.add(line_data1);
                                for(int k=1;k<datanum3_2;k++){
                                    merge_file.lastElement().add(line_data2.get(k));
                                }
                                break;
                            }
                            if(j==file1.size()-1){
                                Vector new_linedata=new Vector();
                                new_linedata.add(line_data2.firstElement());
                                System.out.println(datanum3_1);
                                for(int m=1;m<datanum3_1;m++){
                                    new_linedata.add(sep);
                                }
                                merge_file.add(new_linedata);
                                for(int k=1;k<datanum3_2;k++){
                                    merge_file.lastElement().add(line_data2.get(k));
                                }
                            }
                        }

                    }
                    FileUtil.file_Writer(out_path,out_name,"\t",merge_file);
                    break;

                case "4": //全连接
                    Vector<Integer> file1_del=new Vector<Integer>();
                    Vector<Integer> file2_del=new Vector<Integer>();
                    int datanum4_1=file1.get(0).size();
                    int datanum4_2=file2.get(0).size();

                    for(int i=1;i<file1.size();i++){
                        Vector line_data1=file1.get(i);
                        for(int j=1;j<file2.size();j++){
                            Vector line_data2=file2.get(j);
                            if(line_data1.get(0).equals(line_data2.get(0))){
                                merge_file.add(file1.get(i));
                                for(int k=1;k<file2.get(j).size();k++){
                                    merge_file.lastElement().add(line_data2.get(k));
                                }
                                file1_del.add(i);
                                file2_del.add(j);
                                break;
                            }
                        }
                    }
                    for(int i=1;i<file1.size();i++){
                        if(file1_del.indexOf(i)==-1){
                            Vector line_data=file1.get(i);
                            for(int j=1;j<datanum4_2;j++){
                                line_data.add(sep);
                            }
                            merge_file.add(line_data);
                        }
                    }
                    for(int i=1;i<file2.size();i++){
                        if(file2_del.indexOf(i)==-1) {
                            Vector line_data = new Vector();
                            line_data.add(file2.get(i).firstElement());
                            for (int j = 1; j < datanum4_1; j++) {
                                line_data.add(sep);
                            }
                            for (int k = 1; k < datanum4_2; k++) {
                                line_data.add(file2.get(i).get(k));
                            }
                            merge_file.add(line_data);
                        }
                    }
                    FileUtil.file_Writer(out_path,out_name,"\t",merge_file);
                    break;
            }
        }catch (Exception e){
            e.printStackTrace();
            return "Error";
        }
        return "Success";
    }

    public static String fq2fa(String dataFile, String picFile) {
        int line = 0;
        int mod;
        try {
            FileReader fin = new FileReader(dataFile);
            FileWriter fout = new FileWriter(picFile);
            BufferedReader br = new BufferedReader(fin);
            String str;
            StringBuilder  strBuilder;
            while((str = br.readLine()) != null) {
                line++;
                mod = line % 4;
                if(mod == 1) {
                    strBuilder = new StringBuilder(str);
                    strBuilder.setCharAt(0, '>');
                    str = strBuilder.toString();
                    fout.write(str + "\n");
                }
                else if(mod == 2) {
                    fout.write(str + "\n");
                }
            }
            fin.close();
            fout.close();
            br.close();
        } catch (IOException e){
            System.out.println(e.getMessage());
            return "Error";
        }

        return "Success";
    }
}
