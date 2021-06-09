package com.bioTools.demo.util;

import java.net.URL;


public class GetAbsolutePathUtil {
	
	public static String getAbsolutePath() {
		URL pathUrl = GetAbsolutePathUtil.class.getResource("");
		String s = pathUrl.toString();
		String temp[] = s.split("/");
		String absolutePath = "";
		for( int i=1; i<temp.length;i++) {
			String temp2[] = temp[i].split("\\.");
			if(temp2[0].equalsIgnoreCase(new String("biologicalCloudTools"))) {
				absolutePath += temp2[0]+"Data";
				absolutePath += "/";
				break;
			}
			absolutePath += temp[i];
			absolutePath += "/";
		}
		return absolutePath;
	}

}
