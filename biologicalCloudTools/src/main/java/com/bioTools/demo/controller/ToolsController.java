package com.bioTools.demo.controller;

import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSONObject;
import com.bioTools.demo.entities.History;
import com.bioTools.demo.util.FileUtil;
import com.bioTools.demo.service.HistoryService;
import com.bioTools.demo.service.ToolsService;

/*
 * 工具调用类
 * 功能：调用R语言工具
 * 路由：
 *     test/run
 *     {model}/{function}/run
 *     
 */

@RestController
public class ToolsController {
	
	@Autowired
	private ToolsService toolsService;
	
	@Autowired
	private HistoryService historyService;


	@RequestMapping(value = "{model}/{function}/run", method = RequestMethod.POST)
	@ResponseBody
	public String run(@PathVariable String model,
			@PathVariable String function,
			@RequestBody JSONObject jsonObject) {
		System.out.println(model+"/"+function+"功能被调用");

		//获得功能的参数信息
		String historyId = null;
		String[] param = new String[30];
		Iterator iter = jsonObject.entrySet().iterator();
		while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();
            String key = entry.getKey().toString();
            if(key.equalsIgnoreCase( "historyid" )){
				historyId = entry.getValue().toString();
			}
            else {
				String[] temp = key.split("_");
				String value = entry.getValue().toString();
				param[Integer.parseInt(temp[temp.length - 1])] = value;
			}
        }

		
		System.out.println("historyID:"+historyId);
        History history = historyService.selectHistoryByHistoryIdDAO(historyId);
        historyService.deletePicFile(history);
		String fileString = toolsService.generateFileString(model);
		String functionString = "";
		String result = "";

		switch (model){
			case "BaseFunction":
				historyService.BaseFunctionGeneratePicPath(history);
				functionString = toolsService.generateFunctionString(history, param);
				result = toolsService.toolsImpleFunction(fileString, functionString);
				break;
			case "FormatChange":
				historyService.FormatChangeGeneratePicPath(history,param);
				switch (function){
					case "svg_conversion":
						functionString = toolsService.generateFunctionString(history, param);
						result = toolsService.toolsImpleFunction(fileString, functionString);
						break;
					case "join_table":
						result = toolsService.FormatChange_JoinTable(history,param);
						break;
					case "fq2fa":
						result = toolsService.fq2fa(history);
						break;
				}
			case "Dynamic":
				historyService.DynamicGeneratePicPath(history,param);
				functionString = toolsService.generateFunctionString(history, param);
				result = toolsService.toolsImpleFunction(fileString, functionString);
				break;
			case "ClusteringAnalysis":
				historyService.ClusteringAnalysisGeneratePicPath(history,param);
				functionString = toolsService.generateFunctionString(history, param);
				result = toolsService.toolsImpleFunction(fileString, functionString);
				break;
			case "StatisticalAnalysis":
				historyService.StatisticalAnalysisGeneratePicPath(history,param);
				functionString = toolsService.generateFunctionString(history, param);
				result = toolsService.toolsImpleFunction(fileString, functionString);
				break;

		}

		System.out.println(fileString);
		System.out.println(functionString);

		if(result.equalsIgnoreCase("OK") || result.equalsIgnoreCase("Success")) {
			String temp[] = history.getPicname().split(",");
			String results = "";
			for(int i=0;i<temp.length;i++) {
				if(i != 0) {
					results +=",";
				}
				results += "public/"+history.getEmail()+"/"+temp[i];
			}
			return results;
		}else {
			return "Error";
		}
    }


}
