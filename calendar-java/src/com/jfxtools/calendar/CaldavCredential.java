package com.jfxtools.calendar;

public class CaldavCredential {
    // sample class for storing credentials
    //public static final String CALDAV_SERVER_HOST = "10.0.8.205";

    public String CALDAV_SERVER_HOST = "aries.demo.sun.com";
    public int CALDAV_SERVER_PORT = 3080;
    public String CALDAV_SERVER_PROTOCOL = "http";
    public String CALDAV_SERVER_WEBDAV_ROOT = "/davserver/dav/home/wj100425/calendar/";
    //public String CALDAV_SERVER_WEBDAV_ROOT = "/davserver/dav/principals/wj100425/";
    public String CALDAV_SERVER_USERNAME = "wj100425";
    public String CALDAV_SERVER_PASSWORD = "conv2pra";
    public String COLLECTION = "calendar";

//    public String CALDAV_SERVER_HOST = "www.google.com";
//    public int CALDAV_SERVER_PORT = -1;
//    public String CALDAV_SERVER_PROTOCOL = "https";
//    public String CALDAV_SERVER_WEBDAV_ROOT = "/calendar/dav/winston.prakash@gmail.com/user/";
//    public String CALDAV_SERVER_USERNAME = "winston.prakash";
//    public String CALDAV_SERVER_PASSWORD = "wjp987123";
//    public String COLLECTION = "calendar";
//    public String CALDAV_SERVER_URI = "https://www.google.com/calendar/dav/winston.prakash@gmail.com/user/";

    public CaldavCredential() {
    }

    public CaldavCredential(String proto, String server, int port, String base, String collection, String user, String pass) {
        CALDAV_SERVER_HOST = server;
        CALDAV_SERVER_PORT = port;
        CALDAV_SERVER_PROTOCOL = proto;
        CALDAV_SERVER_WEBDAV_ROOT = base;
        COLLECTION = collection;
        CALDAV_SERVER_USERNAME = user;
        CALDAV_SERVER_PASSWORD = pass;
    }
}

