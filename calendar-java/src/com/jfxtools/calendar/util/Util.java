/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jfxtools.calendar.util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author joshy
 *         Winston Prakash
 */
public class Util {

    private static void printTimeStamp(){
        SimpleDateFormat formatter = new SimpleDateFormat("E, dd MMM yyyy HH:mm:ss Z");
        System.out.print(formatter.format(new Date()) + " ==> ");
    }

    public static void log(Exception ex) {
        if (enableDebug()) {
            log(ex.getMessage());
            ex.printStackTrace();
        }
    }

    public static void log(String string) {
            println(string);
    }

    public static void println(String string) {
        if (enableDebug()) {
            printTimeStamp();
            System.out.println(string);
        }
    }

    public static boolean enableDebug() {
        return Boolean.getBoolean("debug");
    }
}
