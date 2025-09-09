package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.service.CustService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
public class LoginController {
    final CustService custService;
    final BCryptPasswordEncoder bCryptPasswordEncoder;
    final StandardPBEStringEncryptor standardPBEStringEncryptor;

    @RequestMapping("/login")
    public String login(Model model) {
        model.addAttribute("center","login");
        model.addAttribute("left","left");
        return "index";
    }

    @RequestMapping("/updatepwd")
    public String updatepwd(Model model) {
        model.addAttribute("center","updatepwd");
        model.addAttribute("left","left");
        return "index";
    }

    @RequestMapping("/updatepwdimpl")
    public String updatepwdimpl(Model model, @RequestParam("pwd") String pwd,
                            @RequestParam("new_pwd") String new_pwd,
                            HttpSession httpSession) throws Exception {
        Cust sessionCust = (Cust) httpSession.getAttribute("cust");
        boolean result = bCryptPasswordEncoder.matches(pwd, sessionCust.getCustPwd());
        if (result!=true) {
            model.addAttribute("msg", "비밀번호가 틀렸습니다.");
        }else{
            //신규 비밀번호 변경
            sessionCust.setCustPwd(bCryptPasswordEncoder.encode(new_pwd));
            custService.modify(sessionCust);
            model.addAttribute("msg", "비밀번호가 변경 되었습니다.");
        }
        model.addAttribute("center", "updatepwd");
        return "index";
    }

    @RequestMapping("/register")
    public String register(Model model) {
        model.addAttribute("center","register");
        model.addAttribute("left","left");
        return "index";
    }


    @RequestMapping("/loginimpl")
    public String loginimpl(Model model, @RequestParam("id") String id,
                            @RequestParam("pwd") String pwd,
                            HttpSession httpSession) throws Exception {
        Cust dbCust = custService.get(id);
        if(dbCust != null && bCryptPasswordEncoder.matches(pwd, dbCust.getCustPwd())){
            httpSession.setAttribute("cust",dbCust);
            return "redirect:/";
        }
        model.addAttribute("center","login");
        model.addAttribute("msg","로그인 실패!!!");
        return "index";
    }

    @RequestMapping("/logout")
    public String logout(Model model, HttpSession httpSession) throws Exception {
        if(httpSession != null){
            httpSession.invalidate();
        }
        return "redirect:/";
    }


    @RequestMapping("/registerimpl")
    public String registerimpl(Model model, Cust cust, HttpSession session) throws Exception {
        try {
            String originalAddr = cust.getCustAddr();

            cust.setCustPwd(bCryptPasswordEncoder.encode(cust.getCustPwd()));
            cust.setCustAddr(standardPBEStringEncryptor.encrypt(cust.getCustAddr()));

            custService.register(cust);

            cust.setCustAddr(originalAddr);
            session.setAttribute("logincust", cust);

        } catch (Exception e) {
            return "redirect:/register";
        }
        return "redirect:/";
    }

    @RequestMapping("/custinfo")
    public String custinfo(Model model, @RequestParam("id") String id) throws Exception {
        Cust dbCust = custService.get(id);
        dbCust.setCustAddr(standardPBEStringEncryptor.decrypt(dbCust.getCustAddr()));
        if(dbCust != null){
            model.addAttribute("cust",dbCust);
        }
        model.addAttribute("center","custinfo");
        return "index";
    }

    @RequestMapping("/updatecustinfo")
    public String updatecustinfo(Model model, Cust formCust) throws Exception {
        Cust dbCust = custService.get(formCust.getCustId());
        boolean pwdMatch = bCryptPasswordEncoder.matches(formCust.getCustPwd(), dbCust.getCustPwd());

        if (!pwdMatch) {
            model.addAttribute("error_msg", "비밀번호가 일치하지 않습니다.");
            dbCust.setCustAddr(standardPBEStringEncryptor.decrypt(dbCust.getCustAddr()));
            model.addAttribute("cust", dbCust);
            model.addAttribute("center", "custinfo");
            return "index";
        }

        dbCust.setCustName(formCust.getCustName());
        dbCust.setCustAddr(standardPBEStringEncryptor.encrypt(formCust.getCustAddr()));

        custService.modify(dbCust);

        return "redirect:/custinfo?id=" + dbCust.getCustId();
    }


}