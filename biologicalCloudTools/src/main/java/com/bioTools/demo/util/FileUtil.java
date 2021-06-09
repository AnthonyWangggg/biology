package com.bioTools.demo.util;

import java.io.*;
import java.util.Vector;

import org.springframework.web.multipart.MultipartFile;

import com.bioTools.demo.entities.History;

/*
 * public String upload(MultipartFile file,History history)
 * public String multiUpload(MultipartFile[] files,History history)
 * public String save(MultipartFile file,History history)
 * public String generatePicPathByDataPath(History history)
 * public void createFolder(String s)
 * public void deleteFolder(String email)
 * public void deleteFile(History history)
 * public void deleteFile(String dataPath, String picPath)
 * public void deleteDir(File file)
 * 
 * */

public class FileUtil {
	
	private static final String saveFolderPath = "UserFolder/";
	private static final String updateFolderPath = "UploadFolder/";

	public static String upload(MultipartFile file,History history) {
		String abPath = GetAbsolutePathUtil.getAbsolutePath();
    	String dataPath = updateFolderPath + history.getEmail() + "/";
    	String dataName = GetTimeStringUtil.getTimeString() + "_" + file.getOriginalFilename();
		if (!file.isEmpty()) {    
            try {
                BufferedOutputStream out = new BufferedOutputStream( new FileOutputStream(new File(abPath+dataPath+dataName) ) );    
//                System.out.println(file.getName());  
                out.write(file.getBytes());    
                out.flush();    
                out.close();    
            } catch (IOException e) {
                e.printStackTrace();
                return "上传失败," + e.getMessage();
            }
			history.setDataname( dataName );
            history.setDatapath(dataPath);
            return "上传成功";
    
        } else {    
            return "上传失败，因为文件是空的.";    
        }    
    }
	
	public static String multiUpload(MultipartFile[] files,History history) {
		String abPath = GetAbsolutePathUtil.getAbsolutePath();
    	String dataPath = updateFolderPath + history.getEmail() + "/";
        history.setDatapath(dataPath);
        for(MultipartFile file: files) {
        	String filename =  GetTimeStringUtil.getTimeString() + "_" + file.getOriginalFilename();
    		if (!file.isEmpty()) {    
                try {
                    BufferedOutputStream out = new BufferedOutputStream( new FileOutputStream(new File(abPath+dataPath+filename) ) );    
//                    System.out.println(file.getName());  
                    out.write(file.getBytes());    
                    out.flush();    
                    out.close();    
                } catch (IOException e) {
                    e.printStackTrace();
                    return "上传失败," + e.getMessage();
                }
				history.addDataname( filename );
            } else {    
                return "上传失败，因为文件是空的.";    
            }   
        }
        return "上传成功";
    }
	
	public static String save(MultipartFile[] files,History history) {
		String abPath = GetAbsolutePathUtil.getAbsolutePath();
		String picPath = saveFolderPath + history.getEmail() + "/";
        history.setPicpath(picPath);
        for (int i=0;i<files.length;i++) {
        	String picName = GetTimeStringUtil.getTimeString() + "_" + files[i].getName()+".svg";
    		if (!files[i].isEmpty()) {
            	String temp = abPath+picPath+picName;
                File saveFile = new File(temp);
                if (!saveFile.exists()){
                    saveFile.mkdirs();
                }
                try {
                    files[i].transferTo(saveFile);  //将临时存储的文件移动到真实存储路径下
                } catch (IOException e) {
                    e.printStackTrace();
                }
                history.addPicname(picName);
            } else {    
                return "上传失败，因为文件是空的.";    
            }   
        }
        return "上传成功";
		 
	}

	public static void createFolder(String s) {
		String abPath = GetAbsolutePathUtil.getAbsolutePath();
		File file=new File(abPath+saveFolderPath+s);
		if(!file.exists()){//如果文件夹不存在
			file.mkdir();//创建文件夹
		}
		File file_upload=new File(abPath+updateFolderPath+s);
		if(!file_upload.exists()){//如果文件夹不存在
			file_upload.mkdir();//创建文件夹
		}
		
	}
	
	public static void deleteFolder(String email) {
		String abPath = GetAbsolutePathUtil.getAbsolutePath();
		File file = new File(abPath+saveFolderPath+email);
		File file_upload=new File(abPath+updateFolderPath+email);
		deleteDir(file);
		deleteDir(file_upload);
    }
	
	public static void deleteFile(History history) {
		String abPath = GetAbsolutePathUtil.getAbsolutePath();
		if(history.getDatapath() != null) {
			String[] files = history.getDataname().split(",");
			for (int i=0;i<files.length;i++) {
				File file = new File(abPath+history.getDatapath()+files[i]);
				file.delete();
			}
		}
		if(history.getPicpath() != null) {
			String[] files = history.getPicname().split(",");
			for (int i=0;i<files.length;i++) {
				File file = new File(abPath+history.getPicpath()+files[i]);
				file.delete();
			}
		}
	}

    public static void deletePicFile(History history) {
        String abPath = GetAbsolutePathUtil.getAbsolutePath();
        if(history.getPicpath() != null) {
            String[] files = history.getPicname().split(",");
            for (int i=0;i<files.length;i++) {
                File file = new File(abPath+history.getPicpath()+files[i]);
                file.delete();
            }
        }
    }
//	public void deleteUpLoadFile(String email) {
//		File file = new File(updateFolderPath+email);
//		file.delete();
//	}
	
	public static void deleteDir(File file){
        //判断是否为文件夹
        if(file.isDirectory()){
            //获取该文件夹下的子文件夹
            File[] files = file.listFiles();
            //循环子文件夹重复调用delete方法
            for (int i = 0; i < files.length; i++) {
                deleteDir(files[i]);
            }
        }
        //若为空文件夹或者文件删除，File类的删除方法
        file.delete();
    }

    public static Vector<Vector> file_reader(String f_name) {
        File file = new File(f_name);
        Vector file_data = new Vector();
        try {
            BufferedReader br = new BufferedReader(new FileReader(file));//构造一个BufferedReader类来读取文件
            String s = null;
            while ((s = br.readLine()) != null) {//使用readLine方法，一次读一行
                String[] temp_s = s.split("\t");
                Vector line_data = new Vector();
                for (int i = 0; i < temp_s.length; i++) {
                    line_data.add(temp_s[i]);
                }
                file_data.add(line_data);
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return file_data;
    }

    public static void file_Writer(String f_path,String f_name,String sep,Vector<Vector> file_data){
        File file =new File(f_path);
        if(!file.exists())
            file.mkdir();
        String file_name = f_path+"/"+f_name;
        try{
            BufferedWriter bw = new BufferedWriter(new FileWriter(file_name));
            for(int i=0;i<file_data.size();i++){
                Vector line_data=new Vector();
                String line_str="";
                line_data=file_data.get(i);
                for(int j=0;j<line_data.size();j++){
                    line_str+=line_data.get(j).toString();
                    line_str+="\t";
                }
                bw.write(line_str);
                bw.newLine();
            }
            bw.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }




}
