package com.bioTools.demo.controller;

import com.bioTools.demo.entities.History;
import com.bioTools.demo.entities.User;
import com.bioTools.demo.service.HistoryService;
import com.bioTools.demo.service.PersonInfoService;
import com.bioTools.demo.util.FileUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.websocket.server.PathParam;
import java.util.List;

@RestController
public class HistoryController {

    @Autowired
    private HistoryService historyService;

    @Autowired
    private PersonInfoService personInfoService;

    //增
    @RequestMapping(value = "/{model}/{function}/upload", method = RequestMethod.POST)
    @ResponseBody
    public String upload(@RequestParam("file") MultipartFile file,
                         @PathVariable String model,
                         @PathVariable String function) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName().toString();
        if( email.equalsIgnoreCase("") ) { return "未登录"; }
        History history = historyService.creatHistory(email,model,function, file);
        if (history == null){
            return "Error";
        }else {
            return history.getHistoryid();
        }
    }
    @RequestMapping(value = "/{model}/{function}/multiUpload", method = RequestMethod.POST)
    @ResponseBody
    public String multiUpload(@RequestParam("files") MultipartFile[] files,
                         @PathVariable String model,
                         @PathVariable String function) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName().toString();
        if( email.equalsIgnoreCase("") ) { return "未登录"; }
        History history = historyService.creatHistory(email,model,function, files);
        if (history == null){
            return "Error";
        }else {
            return history.getHistoryid();
        }
    }

    //删
    @RequestMapping(value = "/user/history/{historyId}", method = RequestMethod.DELETE)
    public void deleteHistory(@PathParam( value = "historyId") String historyId) {
        historyService.deleteHistory(historyId);
    }
    @RequestMapping(value = "/user/clearHistory", method = RequestMethod.GET)
    public String clearUserHistory() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName().toString();
        if( email.equalsIgnoreCase("") ) { return "未登录"; }
        historyService.clearUserHistory(email);
        return "Success";
    }
    @RequestMapping(value = "/admin/clearHistory", method = RequestMethod.GET)
    public String clearAllHistory() {
        historyService.clearAllHistory(personInfoService.getAllUsersEmail());
        return "Success";
    }

    //改
    @RequestMapping(value = "/{model}/{function}/save", method = RequestMethod.POST)
    @ResponseBody
    public String save(@RequestParam("files") MultipartFile[] files,
                       @RequestParam("historyid")String historyid,
                       @PathVariable String model,
                       @PathVariable String function) {
        String result = historyService.updateHistoryBySavePic(files, historyid);
        return result;
    }


    //查
    @RequestMapping(value = "/user/histories", method = RequestMethod.GET)
    public List<History> queryUserHistory() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName().toString();
        if( email.equalsIgnoreCase("") ) { return null; }
        return historyService.selectUserHistoryDAO(email);
    }
    @RequestMapping(value = "/user/api/histories", method = RequestMethod.GET)
    public String queryUserHistoryAPI() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName().toString();
        if( email.equalsIgnoreCase("") ) { return null; }
        return historyService.selectUserHistoryDAO(email).toString();
    }
    @RequestMapping(value = "/admin/histories", method = RequestMethod.GET)
    public List<History> queryAllHistory() {
        return historyService.selectAllHistoryDAO();
    }
    @RequestMapping(value = "/admin/api/histories", method = RequestMethod.GET)
    public String queryAllHistoryAPI() {
        return historyService.selectAllHistoryDAO().toString();
    }

}
