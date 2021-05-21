package com.bioTools.demo.config;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.bioTools.demo.service.PersonInfoService;
import com.bioTools.demo.util.GetAbsolutePathService;

//@Configuration
//public class WebMvcConfig implements WebMvcConfigurer {
//
//    /**
//     * 开启跨域
//     */
//    @Override
//    public void addCorsMappings(CorsRegistry registry) {
//        // 设置允许跨域的路由
//    	registry.addMapping("/**")
//        		.allowedOrigins("http://localhost:8080")
//        		.allowedHeaders("*")
//        		.allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
//        		.allowCredentials(true)
//        		.exposedHeaders("Access-Control-Allow-Headers",
//        				"Access-Control-Allow-Methods",
//        				"Access-Control-Allow-Origin",
//        				"Access-Control-Max-Age",
//        				"X-Frame-Options")
//        		.maxAge(3600);
//    }
//}

@Configuration
//public class WebMvcConfiger extends WebMvcConfigurerAdapter {
public class WebMvcConfig implements WebMvcConfigurer {
	
	@Autowired
	GetAbsolutePathService getABPathService;
	
	@Autowired
	PersonInfoService personInfoService;
	
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		String path = getABPathService.getAbsolutePath();
		System.out.println(path);
//		List<String> emailList = personInfoService.getAllUsersEmail();
//		String[] tempStrings = new String[emailList.size() * 2 + 2 ];
//		for(int i= 0; i<emailList.size();i++) {
//			String tempFileString = "classpath:" + "public/UserFolder/" + emailList.get(i) + "/";
//			tempStrings[i*2] = tempFileString;
//			String tempFileString2 = "classpath:" + "public/UploadFolder/" + emailList.get(i) + "/";
//			tempStrings[i*2 + 1] = tempFileString2;
//		}
//		tempStrings[emailList.size()*2] = "classpath:" + "public/UserFolder/" + "test" + "/";
//		tempStrings[emailList.size()*2 + 1] = "classpath:" + "public/UploadFolder/" + "test" + "/";
//		String[] fileStrings = new String[emailList.size() * 2];
//		for(int i= 0; i<emailList.size();i++) {
//			String tempFileString = "file:" + path + "UserFolder/" + emailList.get(i) + "/";
//			fileStrings[i*2] = tempFileString;
//			String tempFileString2 = "file:" + path + "UploadFolder/" + emailList.get(i) + "/";
//			fileStrings[i*2 + 1] = tempFileString2;
//		}
//		System.out.println(emailList.toString());
//		registry.addResourceHandler("/public/**")
////			.addResourceLocations(tempStrings)
//			.addResourceLocations(fileStrings);
		registry.addResourceHandler("/public/**")
		.addResourceLocations("file:" + path+"UserFolder/")
		.addResourceLocations("file:" + path+"UploadFolder/");
		registry.addResourceHandler("/static/**")
		.addResourceLocations("file:" + path + "static/");
  }
	
	@Override
	public void addCorsMappings(CorsRegistry registry) {
      // 设置允许跨域的路由
  	registry.addMapping("/**")
//      		.allowedOrigins("http://localhost:8080")
  			.allowedOrigins("**")
      		.allowedHeaders("*")
      		.allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
      		.allowCredentials(true)
      		.exposedHeaders("Access-Control-Allow-Headers",
      				"Access-Control-Allow-Methods",
      				"Access-Control-Allow-Origin",
      				"Access-Control-Max-Age",
      				"X-Frame-Options")
      		.maxAge(3600);
  }
}

