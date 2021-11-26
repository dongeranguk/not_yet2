package test;

import java.util.ArrayList;
import java.util.List;

public class test {
    public static void main(String[] args) {
        try {
            int[] arrInt = new int[0];
            System.out.println(arrInt[0]);
        } catch(Exception e) {
            System.out.println("1. ArrayIndexOutOfBoundsException 에러 : ");
            e.printStackTrace(System.out);
            System.out.println("=========================================");
        }

        try {
            String str = "hello";
            System.out.println(str.substring(11));
        } catch(Exception e) {
            System.out.println("2. StringIndexOutOfBoundException 에러 : ");
            e.printStackTrace(System.out);
            System.out.println("=========================================");
        }

        try {
            List list = new ArrayList();
            System.out.println(list.get(0));
        } catch(Exception e) {
            System.out.println("3. IndexOutOfBoundException 에러 : ");
            e.printStackTrace(System.out);
            System.out.println("=========================================");
        }
    }
}