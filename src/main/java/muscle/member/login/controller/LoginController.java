package muscle.member.login.controller;


import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import javax.xml.transform.sax.SAXSource;

import muscle.common.util.MailService;
import muscle.common.util.MessageService;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import muscle.common.common.CommandMap;
import muscle.member.join.service.JoinService;
import muscle.member.login.dao.UserVO;
import muscle.member.login.service.KakaoService;
import muscle.member.login.service.LoginService;


@Controller
@RequestMapping("/member")
public class LoginController {

    Logger log = Logger.getLogger(this.getClass());

    @Resource(name = "mailService")
    private MailService mailService;

    @Resource(name = "loginService")
    private LoginService loginService;

    @Resource(name = "kakaoService")
    private KakaoService kakaoService;

    @Resource(name = "joinService")
    private JoinService joinService;

    @Resource(name = "messageService")
    private MessageService messageService;

    @RequestMapping(value = "/openLoginForm") // loginForm.jsp
    public ModelAndView loginForm(HttpServletRequest request, Model model) throws Exception {
        ModelAndView mv = new ModelAndView();

        //session
        HttpSession session = request.getSession();

        System.out.println("session : " + session.getAttribute("session_MEMBER"));

        if (session.getAttribute("session_MEMBER") != null) {
            mv.setViewName("redirect:main/openMainList.do");
            return mv;

        } else {
            mv.addObject("userVO", new UserVO());
            mv.setViewName("/member/loginForm");
            return mv;
        }
    }


    @RequestMapping(value = "/login", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView login(@ModelAttribute @Valid UserVO vo, BindingResult result, CommandMap commandMap, HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView("/member/login");
        String message = "";
        String url = "";

        if (result.hasErrors()) { // ????????? List??? ??????
            List<ObjectError> list = result.getAllErrors();
            for (ObjectError error : list) {
                System.out.println("login????????? ???????????? : " + error);
            }

            ModelAndView mv2 = new ModelAndView();
            mv2.setViewName("/member/loginForm");
            return mv2;
        }

        HttpSession session = request.getSession();

        //????????? ?????????
        Map<String, Object> chk = loginService.login(commandMap.getMap());
        if (chk == null) { // ???????????? ????????? ???????????? ??????
            message = "?????? ???????????? ???????????? ????????????.";
        } else {
            if (chk.get("MEM_PW").equals(vo.getMEM_PW())) {
                session.setAttribute("session_MEM_ID", commandMap.get("MEM_ID"));
                session.setAttribute("session_MEM_NUM", commandMap.get("MEM_NUM")); //commandMap?????? mem_id??? ?????????????????? null ?????? ????????????.
                session.setAttribute("session_MEM_ADMIN", commandMap.get("MEM_ADMIN"));
                session.setAttribute("session_MEMBER", chk);
                System.out.println(commandMap.get("MEM_NUM"));
                System.out.println(commandMap.get("MEM_ADMIN"));

                System.out.println("??????????????????" + session.getAttribute("session_MEM_ID"));
                System.out.println("??????????????????" + session.getAttribute("session_MEM_NUM"));
                System.out.println("??????????????????" + session.getAttribute("session_MEM_ADMIN"));
                System.out.println();

            } else { // if?????? ?????? sql??? ?????? ?????? ??????
                message = "??????????????? ?????? ????????????.";
            }
        }
        System.out.println(chk);
        mv.addObject("message", message);
        mv.addObject("url", url);

        return mv;
    }

    @RequestMapping(value = "/logout") // ????????????
    public ModelAndView logout(CommandMap commandMap, HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        if (session != null)
            session.invalidate();
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/member/logout");
        return mv;
    }

    @RequestMapping(value = "/login/kakao_login")
    public void kakaoLogin(HttpServletResponse response) throws IOException {
        StringBuffer loginUrl = new StringBuffer();
        loginUrl.append("https://kauth.kakao.com/oauth/authorize?client_id=");
        loginUrl.append("5cc74eda6966240a1c6d5f938e19ad0c");
        loginUrl.append("&redirect_uri=");
        loginUrl.append("http://localhost:8007/muscle/member/kakao_callback");
        loginUrl.append("&response_type=code");
        response.sendRedirect(loginUrl.toString());
    }

    @RequestMapping(value = "/kakao_callback", method = RequestMethod.GET)
    public String redirectkakao(Model model, @RequestParam String code, CommandMap commandMap, HttpSession session, HttpServletResponse response) throws Exception {
        System.out.println("redirectkakao????????? ?????? : " + code);

        String kakaoToken = kakaoService.getReturnAccessToken(code);
        System.out.println("????????? ?????? : " + kakaoToken);

        Map<String, Object> result = kakaoService.getUserInfo(kakaoToken);
        System.out.println("???????????? ?????? : " + result);

        String kakao_id = (String) result.get("account_email");
        System.out.println(kakao_id);
        model.addAttribute("MEM_KAKAO_ID", kakao_id);
        model.addAttribute("MEM_KAKAO_LINK", "Y");
        commandMap.put("MEM_KAKAO_ID", kakao_id);
        commandMap.put("MEM_KAKAO_LINK", "Y");


        Map<String, Object> chk = loginService.findKakaoId(commandMap.getMap());
        System.out.println(chk);
        if (chk != null) {
            session.setAttribute("session_MEM_ID", chk.get("MEM_ID"));
            session.setAttribute("session_MEM_NUM", chk.get("MEM_NUM"));
            session.setAttribute("session_MEM_ADMIN", chk.get("MEM_ADMIN"));
            session.setAttribute("session_MEM_KAKAO_ID", chk.get("MEM_KAKAO_ID"));
            session.setAttribute("session_MEM_KAKAO_LINK", chk.get("MEM_KAKAO_LINK"));
            session.setAttribute("session_MEMBER", chk);

            return "redirect:/main/openMainList.do";
        }
        return "redirect:/member/openKakaoLoginForm";
    }

    @RequestMapping(value = "/openKakaoLoginForm")
    public String kakaoLoginForm(CommandMap commandMap, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
        HttpSession session = request.getSession();
        String kakaoId = (String) commandMap.get("MEM_KAKAO_ID");
        String kakaoLink = (String) commandMap.get("MEM_KAKAO_LINK");
        System.out.println("----------------------------"); // ?????? ??????????????? ??????!
        System.out.println(kakaoId);
        System.out.println(kakaoLink);
        System.out.println("----------------------------");

        model.addAttribute("MEM_KAKAO_ID", kakaoId);
        model.addAttribute("MEM_KAKAO_LINK", kakaoLink);
        model.addAttribute("userVO", new UserVO());


        if (session.getAttribute("session_MEM_KAKAO_ID") != null) {
            return "redirect:main/openMainList.do";
        }
        return "member/kakaoLoginForm";
    }

    @RequestMapping(value = "/kakaoLogin", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView kakaoLogin(@ModelAttribute @Valid UserVO vo, BindingResult result, CommandMap commandMap, HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView("/member/kakaoLogin");
        String url = "";
        String message = "";

        if (result.hasErrors()) {
            List<ObjectError> list = result.getAllErrors();
            for (ObjectError error : list) {
                System.out.println("????????? ????????? ????????? : " + error);
            }

            mv.setViewName("/member/kakaoLoginForm");
            return mv;
        }

        String kakaoId = (String) commandMap.get("MEM_KAKAO_ID");
        String kakaoLink = (String) commandMap.get("MEM_KAKAO_LINK");
        String mem_id = (String) commandMap.get("MEM_ID");
        System.out.println("-----------------------------------");
        System.out.println("kakaoLogin Method : " + kakaoId);
        System.out.println("kakaoLogin Method : " + kakaoLink);
        System.out.println("kakaoLogin Method : " + mem_id);
        System.out.println("-----------------------------------");

        Map<String, Object> chk = loginService.finder(commandMap.getMap());

        if (chk == null) {
            message = "?????? ???????????? ???????????? ????????????.";
        } else if (chk.get("MEM_PW").equals(vo.getMEM_PW())) {
            int i = loginService.kakaoUpdate1(commandMap.getMap());
            System.out.println("??????????????? ?????? ??? : " + i);
            if (i < 0) {
                Map<String, Object> chk2 = loginService.finder(commandMap.getMap());
                HttpSession session = request.getSession();
                session.setAttribute("session_MEM_ID", chk2.get("MEM_ID"));
                session.setAttribute("session_MEM_NUM", chk2.get("MEM_NUM"));
                session.setAttribute("session_MEM_ADMIN", chk2.get("MEM_ADMIN"));
                session.setAttribute("session_MEM_KAKAO_ID", chk2.get("MEM_KAKAO_ID"));
                session.setAttribute("session_MEM_KAKAO_LINK", chk2.get("MEM_KAKAO_LINK"));
                session.setAttribute("session_MEMBER", chk2);

                System.out.println("?????? ?????? ?????? : " + session.getAttribute("session_MEM_ID"));
                System.out.println("?????? ?????? ?????? : " + session.getAttribute("session_MEM_NUM"));
                System.out.println("?????? ?????? ?????? : " + session.getAttribute("session_MEM_ADMIN"));
                System.out.println("?????? ?????? ?????? : " + session.getAttribute("session_MEM_KAKAO_ID"));
                System.out.println("?????? ?????? ?????? : " + session.getAttribute("session_MEM_KAKAO_LINK"));
                System.out.println(chk2);
                mv.setViewName("redirect:/main/openMainList.do");

            }
            HttpSession session = request.getSession();
            session.setAttribute("session_MEM_ID", chk.get("MEM_ID"));
            session.setAttribute("session_MEM_NUM", chk.get("MEM_NUM"));
            session.setAttribute("session_MEM_ADMIN", chk.get("MEM_ADMIN"));
            session.setAttribute("session_MEM_KAKAO_ID", chk.get("MEM_KAKAO_ID"));
            session.setAttribute("session_MEM_KAKAO_LINK", chk.get("MEM_KAKAO_LINK"));
            session.setAttribute("session_MEMBER", chk);

            System.out.println("?????? ?????? ?????? : " + session.getAttribute("session_MEM_ID"));
            System.out.println("?????? ?????? ?????? : " + session.getAttribute("session_MEM_NUM"));
            System.out.println("?????? ?????? ?????? : " + session.getAttribute("session_MEM_ADMIN"));
            System.out.println("?????? ?????? ?????? : " + session.getAttribute("session_MEM_KAKAO_ID"));
            System.out.println("?????? ?????? ?????? : " + session.getAttribute("session_MEM_KAKAO_LINK"));
            System.out.println(chk);
        } else {
            message = "??????????????? ?????? ????????????.";
        }
        mv.addObject("message", message);
        mv.addObject("url", url);
        return mv;

    }

    @RequestMapping(value = "/main/logoutSc")
    public ModelAndView openJoinForm(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("/member/logout");

        return mv;
    }


    @RequestMapping("/findId") // ????????? ?????? ?????? ???????????? ?????????
    public ModelAndView findId(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("/member/findId");
        return mv;
    }


    @RequestMapping(value = "/findId/{With}", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView findWithId(@PathVariable(value = "With") String with, CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView();

        if (with.equals("phone")) {
            System.out.println("/findId/{phone}?????? ??????");
            System.out.println("commandMap?????? ???????????? ????????? : " + commandMap.getMap());
            Map<String, Object> map = loginService.findIdWithPhone(commandMap.getMap());
            System.out.println("findIdWithPhone ?????? ?????? : " + map);
            if (map != null) {
                mv.addObject("map", map);
                mv.setViewName("/member/findIdWithPhone");
                return mv;
            } else {
                mv.addObject("map", null);
                mv.setViewName("/member/findIdWithPhone");
                return mv;
            }

        } else if (with.equals("email")) {
            System.out.println("/findId/{email}?????? ??????");
            System.out.println("??????????????? ???????????? ????????? : " + commandMap.getMap());
            System.out.println("redirect:/member/findIdWithemail");
            mv.setViewName("redirect:/member/findIdWithemail");
        }
        return mv;
    }

    @RequestMapping(value = "/send/authCode/sms", method = RequestMethod.POST)
    public @ResponseBody
    Map<String, Object> sendMessage(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView();
        Map<String, Object> result = loginService.findIdWithPhone(commandMap.getMap());
        System.out.println("findIdWithPhone : " + result);
        Map<String, Object> map = new HashMap<String, Object>();

        Object key = (int) Math.floor(Math.random() * 9000 + 1000);
        String randomKey = key.toString();
        System.out.println(randomKey);
        String to = (String) commandMap.get("phone");
        System.out.println("-------sendMessage-------");
        System.out.println("???????????? ?????? : " + to);
        if(result != null) {
            messageService.sendMessage(to, randomKey);
            map.put("success", true);
            map.put("randomKey", randomKey);
            map.put("message", "??????????????? ?????????????????????.");
            return map;
        } else {
            System.out.println("-------(success : false)sendMessage-------");
            map.put("success", false);
            map.put("message", "???????????? ?????? ????????? ????????????.");
            return map;
        }
    }

    @RequestMapping(value = "/api/sms/certification")
    public @ResponseBody Map<String, Object> Certification(CommandMap commandMap) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        System.out.println("commandMap : " + commandMap.getMap());
        System.out.println(commandMap.get("certPhoneNum"));
        System.out.println(commandMap.get("randomKey"));

        String inputKey = (String) commandMap.get("certPhoneNum");
        String randomKey = (String) commandMap.get("randomKey");

        if (!randomKey.equals(inputKey)) {
            map.put("message", "??????????????? ???????????? ????????????.");
            map.put("success", false);
            return map;
        }
        map.put("success", true);
        map.put("message", "??????????????? ???????????????.");
        return map;
    }

    @RequestMapping(value = "/findIdWithemail", method = {RequestMethod.GET, RequestMethod.POST}, produces = "application/text; charset=utf-8")
    public @ResponseBody
    String findIdWitheResult(CommandMap commandMap) throws Exception {
        Map<String, Object> map = loginService.findIdWithEmail(commandMap.getMap());
        if (map != null) {
            System.out.println("findIdWithEmail??? ?????? : " + map.entrySet());
            String to = (String) commandMap.getMap().get("MEM_EMAIL");
            String id = (String) map.get("MEM_ID");
            mailService.sendMail(to, id);
            return "true";
        } else {
            return "false";
        }
    }

    @RequestMapping(value = "/findPw") // ???????????? ?????? ?????? ???????????? ?????????
    public ModelAndView findPw(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("/member/findPw");
        int ran = (int) Math.floor(Math.random() * 900000 + 100000);
        System.out.println("?????? ??? : " + ran);
        mv.addObject("random", ran); // random?????? ran??? ????????????...

        return mv;
    }

    // ???????????? ?????? ?????? ????????? ????????? ???????????? ????????? ($.ajax() ??????????????? ????????????.)
    @RequestMapping(value = "/openFindPwResult", method = RequestMethod.POST)
    @ResponseBody
    public boolean findPwEmail(CommandMap commandMap) throws Exception {

        System.out.println(commandMap.getMap());

        String emailCheck = String.valueOf(loginService.findPwWithEmail(commandMap.getMap()));

        System.out.println("????????? ???????????? ?????? ????????? ??? : " + emailCheck);

        if (emailCheck.equals("1")) {
            System.out.println(commandMap.get("MEM_ID"));
            System.out.println(commandMap.get("MEM_EMAIL"));
            System.out.println(commandMap.get("authCode"));
            loginService.updateTempPw(commandMap.getMap());
            String to = (String) commandMap.get("MEM_EMAIL");
            int authCode = (int) commandMap.get("authCode");
            mailService.sendMail(to, authCode);
            return true;
        } else {
            return false;
        }
    }
}