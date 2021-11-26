package test;

import java.util.HashMap;
import java.util.Map;

public class mapTest {
    public static void main(String[] args) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("이름", "김동욱");
        map.put("나이", 26);
        map.put("사는 곳", "충무로 3가 59-11");
        System.out.println(map.entrySet());
        System.out.println(map.size());
        System.out.println(map.keySet());
        System.out.println(map.isEmpty());
        System.out.println(map);
    }

}
