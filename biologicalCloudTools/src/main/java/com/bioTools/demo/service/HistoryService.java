package com.bioTools.demo.service;

import java.util.ArrayList;
import java.util.List;

import com.bioTools.demo.util.FileUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bioTools.demo.dao.HistoryDAO;
import com.bioTools.demo.entities.History;
import com.bioTools.demo.util.GetRandomStringUtil;
import com.bioTools.demo.util.GetTimeStringUtil;
import org.springframework.web.multipart.MultipartFile;

@Service
public class HistoryService {
	
	@Autowired
	private HistoryDAO historyDAO;

	//增
	public History creatHistory(String email,String model,String function, MultipartFile file) {
		History history = new History();
		history.setDatapath("null");
		history.setDataname("null");
		history.setPicpath("null");
		history.setPicname("null");
		history.setEmail(email);
		history.setModel(model);
		history.setToolfunction(function);
		history.setHistoryid(this.GenerateHistoryID(email));
		String result = FileUtil.upload(file,history);
		if(result.equals(new String("上传成功"))) {
			this.addHistoryDAO(history);       //DAO 操作
			if(this.historyNum(email) > 10) {
				this.deleteEarliestHistory(email);
			}
			return history;
		}else {
			return null;
		}
	}
	public History creatHistory(String email,String model,String function, MultipartFile[] files) {
		History history = new History();
		history.setDatapath("null");
		history.setDataname("null");
		history.setPicpath("null");
		history.setPicname("null");
		history.setEmail(email);
		history.setModel(model);
		history.setToolfunction(function);
		history.setHistoryid(this.GenerateHistoryID(email));
		String result = FileUtil.multiUpload(files,history);
		if(result.equals(new String("上传成功"))) {
			this.addHistoryDAO(history);       //DAO 操作
			if(this.historyNum(email) > 10) {
				this.deleteEarliestHistory(email);
			}
			return history;
		}else {
			return null;
		}
	}

	//删
	public void deleteHistory(String historyID){
		History history = this.selectHistoryByHistoryIdDAO(historyID);
		FileUtil.deleteFile(history);
		this.deleteByHistoryIdDAO(historyID);
	}
	public void clearUserHistory(String email){
		List<History> histories = this.selectUserHistoryDAO(email);
		for(History history: histories){
			this.deleteHistory(history.getHistoryid());
		}
	}
	public void clearAllHistory(List<String> emailList){
		for (String email: emailList){
			FileUtil.deleteFolder(email);
		}
		for (String email: emailList){
			FileUtil.createFolder(email);
		}
	}

	//改
	public String updateHistoryBySavePic(MultipartFile[] files, String historyid){
		History history = this.selectHistoryByHistoryIdDAO(historyid);
		String result = FileUtil.save(files,history);
		if( result.equals("上传成功") ) {
			this.updateHistoryDAO(history);
			System.out.println("save:" +  history.toString());
			return history.getHistoryid();
		}else {
			return result;
		}
	}

	private String GenerateHistoryID(String email) {
		String id = "";
		String temp[] = email.split("@");
		id += temp[0];
		id += GetRandomStringUtil.getRandomString(4);
		id += GetTimeStringUtil.getTimeString();
		id += GetRandomStringUtil.getRandomString(4);
		return id;
	}

	public void deletePicFile(History history){
		if (history.getPicname().equalsIgnoreCase("") || history.getPicname() == null){
			FileUtil.deletePicFile(history);
		}
	}

	public String BaseFunctionGeneratePicPath(History history) {

		String saveFolderPath = "UserFolder/";
		String[] pngs = {"regressionline"};
		String[] htmls = {"freqhistogram","pie","scatter3d","krona"};
		String[] pdfs = {"circos"};
		String[] jpgs = {"groupedviolin","violin"};

		String dataFileName = history.getDataname();
		System.out.println(dataFileName);
		String[] temp = dataFileName.split("\\.");
		String[] temp2 = temp[0].split("_");
		String picName = "";
		if( macthString(pngs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".png";
		}else if (macthString(htmls,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".html";
		}else if( macthString(pdfs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".pdf";
		}else if( macthString(jpgs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".jpg";
			picName += ",";
			picName += GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".csv";
		}else if(history.getToolfunction().equalsIgnoreCase("ternaryplot_plot") ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + "(1).svg";
			picName += ",";
			picName += GetTimeStringUtil.getTimeString() + "_" + temp2[1] + "(2).svg";
			picName += ",";
			picName += GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".txt";
		}else {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".svg";
		}
		String picPath = saveFolderPath + history.getEmail() + "/";
//		String temp3 = 	getTimeStringService.getTimeString() + "_" + picName;
		history.setPicname(picName);
		history.setPicpath(picPath);
		this.updateHistoryDAO(history);
		return history.getPicpath();
	}

	public String FormatChangeGeneratePicPath(History history, String[] param){

		String saveFolderPath = "UserFolder/";
		String picPath = saveFolderPath + history.getEmail() + "/";
		String picName = "";
		String dataFileName = history.getDataname();
		String originFileName = dataFileName.split("\\.")[0].split("_")[1];
		switch (history.getToolfunction()){
			case "svg_conversion":
				picName = GetTimeStringUtil.getTimeString() + "_" + originFileName + "." +param[0];
				break;
			case "join_table":
				picName = GetTimeStringUtil.getTimeString() + "_" + "mergeout"+".txt";
				break;
			case "fq2fa":
				picName = GetTimeStringUtil.getTimeString() + "_" + originFileName + ".txt";
				break;
			default:
				picName = GetTimeStringUtil.getTimeString() + "_" + originFileName + ".txt";
				break;
		}
		history.setPicname(picName);
		history.setPicpath(picPath);
		this.updateHistoryDAO(history);
		return history.getPicpath();
	}

	public String DynamicGeneratePicPath(History history, String[] param){

		String saveFolderPath = "UserFolder/";
		String[] pngs = {};
		String[] htmls = {};
		String[] pdfs = {};
		String[] jpgs = {};

		String dataFileName = history.getDataname();
		System.out.println(dataFileName);
		String[] temp = dataFileName.split("\\.");
		String[] temp2 = temp[0].split("_");
		String picName = "";
		if( macthString(pngs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".png";
		}else if (macthString(htmls,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".html";
		}else if( macthString(pdfs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".pdf";
		}else if( macthString(jpgs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".jpg";
		}else if(history.getToolfunction().equalsIgnoreCase("ternary_chart") ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + "(1).svg";
			picName += ",";
			picName += GetTimeStringUtil.getTimeString() + "_" + temp2[1] + "(2).svg";
			picName += ",";
			picName += GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".txt";
		}else {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".svg";
		}
		String picPath = saveFolderPath + history.getEmail() + "/";
//		String temp3 = 	getTimeStringService.getTimeString() + "_" + picName;
		history.setPicname(picName);
		history.setPicpath(picPath);
		this.updateHistoryDAO(history);
		return history.getPicpath();
	}

	public String ClusteringAnalysisGeneratePicPath(History history, String[] param){

		String saveFolderPath = "UserFolder/";
		String[] pngs = {};
		String[] htmls = {};
		String[] pdfs = {};
		String[] jpgs = {};

		String dataFileName = history.getDataname();
		System.out.println(dataFileName);
		String[] temp = dataFileName.split("\\.");
		String[] temp2 = temp[0].split("_");
		String picName = "";
		if( macthString(pngs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".png";
		}else if (macthString(htmls,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".html";
		}else if( macthString(pdfs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".pdf";
		}else if( macthString(jpgs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".jpg";
		}else if(history.getToolfunction().equalsIgnoreCase("tsne_chart") ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".svg";
			picName += ",";
			picName += GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".txt";
		}else {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".svg";
		}
		String picPath = saveFolderPath + history.getEmail() + "/";
//		String temp3 = 	getTimeStringService.getTimeString() + "_" + picName;
		history.setPicname(picName);
		history.setPicpath(picPath);
		this.updateHistoryDAO(history);
		return history.getPicpath();
	}

	public String StatisticalAnalysisGeneratePicPath(History history, String[] param){

		String saveFolderPath = "UserFolder/";
		String[] pngs = {};
		String[] htmls = {};
		String[] pdfs = {};
		String[] jpgs = {};

		String dataFileName = history.getDataname();
		System.out.println(dataFileName);
		String[] temp = dataFileName.split("\\.");
		String[] temp2 = temp[0].split("_");
		String picName = "";
		if( macthString(pngs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".png";
		}else if (macthString(htmls,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".html";
		}else if( macthString(pdfs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".pdf";
		}else if( macthString(jpgs,history.getToolfunction()) ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".jpg";
		}else if(history.getToolfunction().equalsIgnoreCase("tsne_chart") ) {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".svg";
			picName += ",";
			picName += GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".txt";
		}else {
			picName = GetTimeStringUtil.getTimeString() + "_" + temp2[1] + ".svg";
		}
		String picPath = saveFolderPath + history.getEmail() + "/";
//		String temp3 = 	getTimeStringService.getTimeString() + "_" + picName;
		history.setPicname(picName);
		history.setPicpath(picPath);
		this.updateHistoryDAO(history);
		return history.getPicpath();
	}


	public int historyNum(String email) {
		List<History> historyList = historyDAO.selectUserHistory(email);
		return historyList.size();
	}
	
	public History findEarlistHistory(String email) {
		List<History> historyList = historyDAO.selectUserHistory(email);
		List<Long> timeList = new ArrayList<Long>();
		for(int i=0;i<historyList.size();i++) {
			String tempHistoryID = historyList.get(i).getHistoryid();
			timeList.add( Long.parseLong(  tempHistoryID.substring(tempHistoryID.length()-18, tempHistoryID.length()-4)) );
		}
		Long min = timeList.get(0);
		int minPosition = 0;
		for(int j=1;j<timeList.size();j++) {
			if(timeList.get(j) < min) {
				minPosition = j;
				min = timeList.get(j);
			}
		}
		System.out.println(min);
		return historyList.get(minPosition);
	}

	private boolean macthString(String[] strs, String str) {
		for (String s : strs) {
			if (str.equalsIgnoreCase(s)) {
				return true;
			}
		}
		return false;
	}


	public void deleteEarliestHistory(String email) {
		List<History> historyList = historyDAO.selectUserHistory(email);
		List<Long> timeList = new ArrayList<Long>();
		for(int i=0;i<historyList.size();i++) {
			String tempHistoryID = historyList.get(i).getHistoryid();
			timeList.add( Long.parseLong(  tempHistoryID.substring(tempHistoryID.length()-18, tempHistoryID.length()-4)) );
		}
		long min = timeList.get(0);
		int minPosition = 0;
		for(int j=1;j<timeList.size();j++) {
			if(timeList.get(j) < min) {
				minPosition = j;
				min = timeList.get(j);
			}
		}
		this.deleteHistory(historyList.get(minPosition).getHistoryid());
	}


	//DAO操作
	public void addHistoryDAO(History history) {
		historyDAO.addHistory(history);
	}
	
	public void deleteByDataPathDAO(String dataPath) {
		historyDAO.deleteByDataPath(dataPath);
	};
	
	public void deleteByHistoryIdDAO(String historyID) {
		historyDAO.deleteByHistoryId(historyID);
	};
	
	public void clearHistorysDAO() {
		historyDAO.clearHistroy();
	};
	
	public void updateHistoryDAO(History history) {
		historyDAO.updateHistory(history);
	}
	
	public History selectHistoryByDataPathDAO(String dataPath) {
		return historyDAO.selectHistoryByDataPath(dataPath);
	}
	
	public History selectHistoryByHistoryIdDAO(String historyId) {
		return historyDAO.selectHistoryByHistoryId(historyId);
	}
	
	public List<History> selectAllHistoryDAO(){
		return historyDAO.selectAllHistory();
	}
	
	public List<History> selectUserHistoryDAO(String email){
		return historyDAO.selectUserHistory(email);
	}



}
