package test;

public class randomTest {
    public static void main(String[] args) {
            long beforeTime = System.currentTimeMillis();

            Object key = (int) Math.floor(Math.random() * 9000 + 1000);
            System.out.println(key.toString());

            long afterTime = System.currentTimeMillis();
            long setDiffTime = (afterTime - beforeTime);
            System.out.println(setDiffTime);

            long beforeTime2 = System.currentTimeMillis();

            Object key2 = (int)Math.floor(Math.random() * 9000 + 1000);
            System.out.println(String.valueOf(key2));

            long afterTime2 = System.currentTimeMillis();
            long setDiffTime2 = (afterTime2 - beforeTime2);
        System.out.println(setDiffTime2);
        System.out.println(String.valueOf(Math.floor(Math.random() * 9000 + 1000)));

        Object key3 = (int)Math.floor(Math.random() * 9000 + 1000);
        String randomKey = key3.toString();
        System.out.println("toString()" + randomKey);
    }
}
