package muscle.common.util;

import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import java.util.HashMap;

@Service("messageService")
public class MessageService {
    static final String api_key = "NCSN2LZKRRXY0PEI";
    static final String api_secret = "S8NMPXSWQKOPV4OE211VNSCLIQKNT2ZQ";
    Message coolsms = new Message(api_key, api_secret);

    public void sendMessage(String to, String randomKey) {
        HashMap<String, String> params = new HashMap<String, String>();
        params.put("to", to);
        params.put("from", "07080959463");
        params.put("type", "SMS");
        params.put("text", "[MUSCLE] 인증번호" + "[" + randomKey + "]" + "를 입력하세요.");
        params.put("api_version", "test api 1.2");

        try {
            JSONObject obj = (JSONObject) coolsms.send(params);
            System.out.println(obj.toString());
        } catch(CoolsmsException e) {
            System.out.println(e.getMessage());
            System.out.println(e.getCode());
        }
    }
}
