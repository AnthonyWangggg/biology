package com.bioTools.demo.service;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

import com.bioTools.demo.util.FormatChangeUtil;
import org.rosuda.REngine.REXP;
//import org.rosuda.REngine.REngineException;
import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bioTools.demo.entities.History;
import com.bioTools.demo.util.GetAbsolutePathUtil;
import com.bioTools.demo.util.IsNumericUtil;


/*
 * R语言后端服务类
 * 功能：实现对135个工具的R语言调用
 */

/*
 * BaseFunction
 * # 1. sankey               桑基图
 * # 2. polarbar       极坐标柱状图
 * # 3. beeswarm             蜂群图
 * # 4. binaryheatmap      二值热图
 * # 5. podfigure            豆荚图
 * # 6. brokencolumn     断轴柱状图
 * # 7. ternaryplot          三元图
 * # 8. upsetvenn       UpSet维恩图
 * # 9. circos     circos物种关系图
 * # 10. jxx               九象限图
 * # 11. groupedviolin 分组小提琴图
 * # 12. violin            小提琴图
 * # 13. freqhistogram   频率直方图
 * # 14. pie                   饼图
 * # 15. scatter3d         3D散点图
 * # 16. regressionline  线性回归图
 * # 17. weightednetwork 权重网络图
 * # 18. directednetwork 有向网络图
 * # 19. seniorbubble    高级气泡图
 * # 20. seniorscatter   高级散点图
 * # 21. vn_plot             维恩图
 * # 22. krona        Krona层级饼图
 * # 23. maplot                MA图
 * # 24. volcano             火山图
 * # 25. heatmap               热图
 * # 26. bubble              气泡图
 * # 27. box                 盒形图
 * # 28. area                面积图
 * # 29. histogram           柱状图
 * # 30. line                折线图
 * # 31. scatterplot         散点图
 * 
 */

@Service
public class ToolsService{
	
	
	public String generateFileString(String model) {
		String absolutePath = GetAbsolutePathUtil.getAbsolutePath();
		String rFilePath = "RTools" + "/" + model + ".R";
		//		System.out.println(fileStringTemp);
		return "source('"+absolutePath+rFilePath+ "')";
	}
	
	public String generateFunctionString(History history, String[] param) {
		String absolutePath = GetAbsolutePathUtil.getAbsolutePath();
		String[] dataNames = history.getDataname().split(",");
		String[] picNames = history.getPicname().split(",");
		
		
		StringBuilder functionStringTemp = new StringBuilder(history.getToolfunction() + "(");
		

		if(dataNames.length == 1) {
			functionStringTemp.append("'").append(absolutePath).append(history.getDatapath()).append(dataNames[0]).append("'");
		}else {
			functionStringTemp.append("c(");
			for (int i=0; i<dataNames.length;i++) {
				if(i==0) {
					functionStringTemp.append("'").append(absolutePath).append(history.getDatapath()).append(dataNames[i]).append("'");
				}else {
					functionStringTemp.append(",'").append(absolutePath).append(history.getDatapath()).append(dataNames[i]).append("'");
				}
			}
			functionStringTemp.append(")");
		}
		
		
		functionStringTemp.append(",");
		if(picNames.length == 1) {
			functionStringTemp.append("'").append(absolutePath).append(history.getPicpath()).append(picNames[0]).append("'");
		}else {
			functionStringTemp.append("c(");
			for (int i=0; i<picNames.length;i++) {
				if(i==0) {
					functionStringTemp.append("'").append(absolutePath).append(history.getPicpath()).append(picNames[i]).append("'");
				}else {
					functionStringTemp.append(",'").append(absolutePath).append(history.getPicpath()).append(picNames[i]).append("'");
				}
			}
			functionStringTemp.append(")");
		}

		for (String s : param) {
			if (s == null) {
				break;
			}
			if (s.equalsIgnoreCase(new String("TRUE"))) {
				functionStringTemp.append(",").append(s);
			} else if (s.equalsIgnoreCase(new String("FALSE"))) {
				functionStringTemp.append(",").append(s);
			} else if (s.equals(new String("NULL"))) {
				functionStringTemp.append(",").append(s);
			} else if (s.charAt(0) == 'c' && s.charAt(1) == '(' && s.charAt(s.length() - 1) == ')') {
//				String cTemp = param[i].substring(1, param[i].length()-1);
				functionStringTemp.append(",").append(s);
			} else if (IsNumericUtil.isNumeric(s) || IsNumericUtil.isNumericInt(s)) {
				functionStringTemp.append(",").append(s);
			} else {
				functionStringTemp.append(",'").append(s).append("'");
			}
		}
		
		functionStringTemp.append(")");
		
//		System.out.println(functionStringTemp);
		return functionStringTemp.toString();
	}
	
	public String generateFormatChangeFunctionString(History history, String[] param) {

		String absolutePath = GetAbsolutePathUtil.getAbsolutePath();
		String[] dataNames = history.getDataname().split(",");
		String[] picNames = history.getPicname().split(",");
		
		
		StringBuilder functionStringTemp = new StringBuilder(history.getToolfunction() + "(");
		
		functionStringTemp.append("'").append(absolutePath).append(history.getDatapath()).append(dataNames[0]).append("',");
		
		String[] temp = picNames[0].split("\\.");
		functionStringTemp.append("'").append(absolutePath).append(history.getPicpath()).append(temp[0]).append(".").append(param[0]).append("'");
		history.setPicname(temp[0]+"."+param[0]);


		for (String s : param) {
			if (s == null) {
				break;
			}
			if (s.equalsIgnoreCase(new String("TRUE"))) {
				functionStringTemp.append(",").append(s);
			} else if (s.equalsIgnoreCase(new String("FALSE"))) {
				functionStringTemp.append(",").append(s);
			} else if (s.equals(new String("NULL"))) {
				functionStringTemp.append(",").append(s);
			} else if (s.charAt(0) == 'c' && s.charAt(1) == '(' && s.charAt(s.length() - 1) == ')') {
//				String cTemp = param[i].substring(1, param[i].length()-1);
				functionStringTemp.append(",").append(s);
			} else if (IsNumericUtil.isNumeric(s) || IsNumericUtil.isNumericInt(s)) {
				functionStringTemp.append(",").append(s);
			} else {
				functionStringTemp.append(",'").append(s).append("'");
			}
		}
		
		functionStringTemp.append(")");
		
//		System.out.println(functionStringTemp);
		return functionStringTemp.toString();
	}

	public String FormatChange_JoinTable(History history, String[] param){

		System.out.println(Arrays.toString(param));

		String absolutePath = GetAbsolutePathUtil.getAbsolutePath();
		String[] dataNames = history.getDataname().split(",");
		for (int i = 0 ; i < dataNames.length; i++){
			dataNames[i] = absolutePath + history.getDatapath()+ dataNames[i];
		}
		System.out.println(Arrays.toString(dataNames));
		String result = FormatChangeUtil.join_table(dataNames,absolutePath+history.getPicpath(), history.getPicname(), param[0],param[1]);
//		System.out.println(outName);
		return result;
	}

	public String fq2fa(History history){
		String absolutePath = GetAbsolutePathUtil.getAbsolutePath();
		String dataFile = absolutePath + history.getDatapath()+ history.getDataname();
		String picFile = absolutePath + history.getPicpath()+ history.getPicname();
		String result = FormatChangeUtil.fq2fa(dataFile,picFile);
//		System.out.println(result);
		return result;
	}
	
	
	public String toolsImpleFunction(String fileString, String functionString){
		String result = "";
		RConnection connection = null;
		String function = "";
		try {
			function = new String( functionString.getBytes("GBK") , StandardCharsets.UTF_8);
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		try {
//			connection = new RConnection(host, port);
			connection = new RConnection();
		} catch (RserveException e) {
			e.printStackTrace();
		}

		try {
			connection.eval(fileString);
			connection.eval(function);
			result = "OK";
		} catch (RserveException e) {
			result = "Error";
			e.printStackTrace();
		}
		connection.close();

		return result;
	}
	
	
}
