package com.bioTools.demo.controller;

import java.util.List;

import javax.servlet.http.HttpSession;
import javax.websocket.server.PathParam;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import com.alibaba.fastjson.JSONObject;
import com.bioTools.demo.entities.History;
import com.bioTools.demo.entities.User;
import com.bioTools.demo.util.CheckCodeUtil;
import com.bioTools.demo.util.FileUtil;
import com.bioTools.demo.service.HistoryService;
import com.bioTools.demo.service.PersonInfoService;

/*
 * 个人信息类
 * 功能：登陆注册、查看历史文件，允许删除、下载历史数据
 * 路由：
 *     login  post
 *     register  post
 *     clearHistory  post get
 *     sendCheckCode  post
 */

@RestController
public class PersonInfoController {
	
	@Autowired
	private PersonInfoService personInfoService;
	
//	@RequestMapping(value = "/login", method = RequestMethod.POST)
//	public String loginCheck(@RequestParam("email") String email,
//			@RequestParam("password") String password,
//			HttpSession session) {
//		System.out.println("/dologin");
//		User user = new User();
//		user.setEmail(email);
//		user.setPassword(password);
//		System.out.println(user.toString());
//		String temp = personInfoService.login(user);
//		if(temp.equalsIgnoreCase(new String("Success"))) {
//			System.out.println("登录成功");
//		}else {
//			System.out.println(temp);
//		}
//		return temp;
//	}

	//增
	@RequestMapping(value = {"/register","/users"}, method = RequestMethod.POST)
	public String Register(@RequestBody JSONObject jsonObject) {
		
		System.out.println("register");
		String email = jsonObject.getString("email");
        String password = jsonObject.getString("password");
        String telephone = jsonObject.getString("telephone");
        
		User user = new User();
		user.setEmail(email);
		user.setPassword(password);
		user.setTelephone(telephone);
		System.out.println(user.toString());
		
		String temp =personInfoService.register(user);
		System.out.println(temp);
		return temp;
	}
	
	@RequestMapping(value = "/register", method = RequestMethod.GET)
	public String RegisterForGet() {
		System.out.println("/register  ---get");
		return "get方法不被允许，请用post方法	";
	}


	//删指定用户
	@RequestMapping(value = "/users/{email}", method = RequestMethod.DELETE)
	public String UserDelete(@PathParam("email")String email) {
		if( email == null) {
			return "Error";
		}
		personInfoService.deleteUser(email);
		return "OK";
	}

	//改当前用户
	@RequestMapping(value = "/user", method = RequestMethod.PUT)
	public String UserUpdate(@RequestBody JSONObject jsonObject) {
		System.out.println("user");
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String email = auth.getName().toString();
		if( email == null) {
			return null;
		}
		String name = jsonObject.getString("name");
        String password = jsonObject.getString("password");
        String telephone = jsonObject.getString("telephone");
        
		User user = personInfoService.getUserByEmail(email);
		user.setName(name);
		user.setPassword(password);
		user.setTelephone(telephone);
		System.out.println(user.toString());
		
		personInfoService.updateUser(user);
		
		return "OK";
	}

	//改指定用户
	@RequestMapping(value = "/users/{email}", method = RequestMethod.PUT)
	public String UserUpdate2(@RequestBody JSONObject jsonObject,@PathParam("email")String email) {
		if( email == null) {
			return "Error";
		}
		String name = jsonObject.getString("name");
		String password = jsonObject.getString("password");
		String telephone = jsonObject.getString("telephone");

		User user = personInfoService.getUserByEmail(email);
		user.setName(name);
		user.setPassword(password);
		user.setTelephone(telephone);
		System.out.println(user.toString());

		personInfoService.updateUser(user);

		return "OK";
	}

	//查
	@GetMapping("/admin/api/users")
	public String getAllUsersAPI() {
		return personInfoService.selectAllUsers().toString();
	}
	@RequestMapping(value = "/admin/users", method = RequestMethod.GET)
	public List<User> getAllUsers() {
		return personInfoService.selectAllUsers();
	}
	@RequestMapping(value = "/user", method = RequestMethod.GET)
	public User getUser() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String email = auth.getName().toString();
		if( email == null) {
			return null;
		}
		return personInfoService.getUserByEmail(email);
	}
	@RequestMapping(value = "/users/{email}", method = RequestMethod.GET	)
	public User getUser2(@PathParam("email")String email) {
		if( email == null) {
			return null;
		}
		return personInfoService.getUserByEmail(email);
	}
	@RequestMapping(value = {"/api/user","user/api/user","user/api"}, method = RequestMethod.GET)
	public String getUserAPI() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String email = auth.getName().toString();
		if( email == null) {
			return null;
		}
		return personInfoService.getUserByEmail(email).toString();
	}


	//验证码
	@RequestMapping(value = "/sendCheckCode", method = RequestMethod.POST)
	public String sendCheckCode(@RequestBody JSONObject jsonObject) {
		String email = jsonObject.getString("email");
		String checkCode = personInfoService.sendCheckCode(email);

		System.out.println("准备发送验证码，目标邮箱：" + email);
		System.out.println("验证码: "+checkCode);
		return checkCode;
	}
}
