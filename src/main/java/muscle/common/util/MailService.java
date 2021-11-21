package muscle.common.util;

import org.springframework.stereotype.Service;

import javax.activation.CommandMap;
import javax.activation.MailcapCommandMap;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.util.Date;
import java.util.Properties;
import javax.mail.Session;


@Service("mailService")
public class MailService {
    public static void sendMail(String to, String authCode) {
        final String bodyEncoding = "UTF-8";
        String subject = "메일 발송 테스트";
        String fromEmail = "rooetym47@gmail.com";
        String fromUserName = "MSUCLE";
        String toEmail = to; // 받을 이메일 주소

        final String username = "rooetym47@gmail.com";
        final String password = "wwhriwoemaijbyqp";


        // 메일에 출력할 텍스트
        StringBuffer sb = new StringBuffer();
        sb.append("<h3>안녕하세요</h3>");
        sb.append("<h4>MUSCLE 입니다.\n");
        sb.append("임시비밀번호는 " + authCode + "입니다.");
        String html = sb.toString();

        // 메일 옵션 설정
        Properties props = new Properties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.auth", "true");

        props.put("mail.smtp.quitwait", "false");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.fallback", "false");

        try {
            Authenticator auth = new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            };

            //메일 세션 생성
            Session session = Session.getInstance(props, auth);

            //메일 송/수신 옵션 설정
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, fromUserName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            message.setSubject(subject);
            message.setSentDate(new Date());

            //메일 콘텐츠 설정
            Multipart mParts = new MimeMultipart();
            MimeBodyPart mTextPart = new MimeBodyPart();
            MimeBodyPart mFilePart = null;

            //메일 콘텐츠 - 내용
            mTextPart.setText(html, bodyEncoding, "html");
            mParts.addBodyPart(mTextPart);

            //메일 콘텐츠 설정
            message.setContent(mParts);

            //MIME 타입 설정
            MailcapCommandMap MailcapCmdMap = (MailcapCommandMap) CommandMap.getDefaultCommandMap();
            MailcapCmdMap.addMailcap("text/html;; x-java-content-handler=com.sun.mail.handlers.text_html");
            MailcapCmdMap.addMailcap("text/xml;; x-java-content-handler=com.sun.mail.handlers.text_xml");
            MailcapCmdMap.addMailcap("text/plain;; x-java-content-handler=com.sun.mail.handlers.text_plain");
            MailcapCmdMap.addMailcap("multipart/*;; x-java-content-handler=com.sun.mail.handlers.multipart_mixed");
            MailcapCmdMap.addMailcap("message/rfc822;; x-java-content-handler=com.sun.mail.handlers.message_rfc822");
            CommandMap.setDefaultCommandMap(MailcapCmdMap);

            //메일 발송
            Transport.send(message);
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}
