/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author chaua
 */


import java.util.Scanner;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    public static String hashPassword(String rawPassword) {
        return BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));
    }
    public static boolean verifyPassword(String rawPassword, String hash) {
        return BCrypt.checkpw(rawPassword, hash);
    }
    
    public static void main(String[] args) {
        try (Scanner sc = new Scanner(System.in)) {
            System.out.print("Nhập mật khẩu cần hash: ");
            String password = sc.nextLine();

            String hash = PasswordUtil.hashPassword(password);

            System.out.println("Password hash (BCrypt):");
            System.out.println(hash);
        }
    }
    
    
}
