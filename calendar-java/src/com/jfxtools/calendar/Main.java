/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jfxtools.calendar;

import org.osaf.caldav4j.methods.HttpClient;

/**
 *
 * @author winstonp
 */
public class Main {

    private String serverHost = "";
    private int serverPort = 80;
    private String serverProtocol = "";
    private String serverWebDavRoot = "";
    private String serverUserName = "";
    private String serverPassword = "";

    private HttpClient httpClient;

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        BaseCaldavClient cli = new BaseCaldavClient();
    }
}
