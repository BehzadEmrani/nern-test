package com.atrosys.util;

import com.atrosys.entity.PersonalInfo;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.Scanner;

/**
 * Created by met on 5/21/18.
 * Hash a string with pass hashing function.
 */

public class PassHashingUtil {
    public static void main(String[] args) {
        try {
            Scanner scanner = new Scanner(System.in);
            String hash = PersonalInfo.customHash(scanner.nextLine());
            System.out.println(hash);
        } catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }
}

