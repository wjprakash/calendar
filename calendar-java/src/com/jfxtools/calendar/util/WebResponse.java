package com.jfxtools.calendar.util;

/**
 * Response from server after the WebRequest is executed
 * @author Winston Prakash
 */
public class WebResponse {

    private String response;
    private String responseMessage;
    private int responseCode;

    public int getResponseCode() {
        return responseCode;
    }

    public void setResponseCode(int responseCode) {
        this.responseCode = responseCode;
    }

    public String getResponseMessage() {
        return responseMessage;
    }

    public void setResponseMessage(String responseMessage) {
        this.responseMessage = responseMessage;
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }
}
