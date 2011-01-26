package com.jfxtools.calendar.util;

import sun.misc.BASE64Encoder;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.util.Map;

/**
 * Some common web requests done using HTTP
 * @author Winston Prakash
 */
public class WebRequest {

    protected HttpURLConnection urlConn;

    private final int TIME_OUT_RETRY_COUNT = 10;

    public WebRequest(String uriStr) throws URISyntaxException, IOException {
        createConnection(uriStr);
    }

    public WebRequest(URI uri) throws IOException {
        createConnection(uri);
    }

    protected void createConnection(String uriStr) throws URISyntaxException, IOException {
        URI uri = new URI(uriStr);
        createConnection(uri);
    }

    protected void createConnection(URI uri) throws IOException {
        urlConn = (HttpURLConnection) uri.toURL().openConnection();
        urlConn.setConnectTimeout(1000);
        urlConn.setUseCaches(true);
        urlConn.setDefaultUseCaches(true);
        urlConn.setAllowUserInteraction(false);
        urlConn.setRequestProperty("User-Agent", "Java Store");
        HttpURLConnection.setDefaultAllowUserInteraction(false);
    }

    private void connect() throws IOException{
        boolean connected = false;
        int count = 0;
        while (!connected){
            try{
                urlConn.connect();
                connected = true;
            }catch (SocketTimeoutException exc){
                Util.log("Connection timed out. try " + count);
                if (++count > TIME_OUT_RETRY_COUNT){
                    throw new IOException("Java Store server connection timed out after " + TIME_OUT_RETRY_COUNT + " tries");
                }
                connected = false;
            }catch (UnknownHostException exc){
                throw new IOException("Could not connect to Java Store Server. Check your internet connection and try again later.");
            }
        }
    }

    public void setAuthorization(String username, String password) {
        BASE64Encoder encoder = new BASE64Encoder();
        String encoded = encoder.encode((username + ":" + password).getBytes());
        urlConn.setRequestProperty("Authorization", "Basic " + encoded);
    }

    public void setContentType(String contentType) {
        urlConn.setRequestProperty("Content-Type", contentType);
    }

    public WebResponse get() throws IOException, URISyntaxException {
        //Util.log("Header:" + urlConn.getRequestProperties());
        connect();

        WebResponse response = getResponse(urlConn);
        urlConn.disconnect();

        return response;
    }

    public WebResponse delete() throws IOException, URISyntaxException {
        urlConn.setRequestMethod("DELETE");
        connect();

        WebResponse response = getResponse(urlConn);
        urlConn.disconnect();

        return response;
    }

    public WebResponse post(Map<String, String> params) throws IOException, URISyntaxException {
        StringBuffer sb = new StringBuffer();
        for (String key : params.keySet()){
            sb.append(URLEncoder.encode(key, "UTF-8" ));
            sb.append("=");
            sb.append(URLEncoder.encode(params.get(key), "UTF-8"));
            sb.append("&");
        }
        return request(sb.toString(), "POST", "application/x-www-form-urlencoded");
    }

    public WebResponse post(String source) throws IOException, URISyntaxException {
        return request(source, "POST", "application/xml");
    }

    public WebResponse put(String source) throws IOException, URISyntaxException {
        return request(source, "PUT", "application/xml");
    }

    public WebResponse request(String source, String method, String contentType) throws IOException, URISyntaxException {
        urlConn.setRequestMethod(method);
        if ((source != null) && !("".equals(source.trim()))) {
            if (contentType != null){
                urlConn.setRequestProperty("Content-Type", contentType);
            }
            urlConn.setRequestProperty("Content-Length", "" + source.length());

            urlConn.setDoInput(true);
            urlConn.setDoOutput(true);
            connect();
            OutputStream os = urlConn.getOutputStream();
            DataOutputStream wr = new DataOutputStream(os);
            wr.writeBytes(source);
            wr.flush();
            wr.close();
        }

        WebResponse response = getResponse(urlConn);
        urlConn.disconnect();

        return response;
    }

    private WebResponse getResponse(HttpURLConnection urlConn) throws IOException {
        WebResponse webResponse = new WebResponse();
        webResponse.setResponseCode(urlConn.getResponseCode());
        webResponse.setResponseMessage(urlConn.getResponseMessage());

        int responseCode = webResponse.getResponseCode();

        try {
            InputStream is = null;
            if (responseCode < 300){
               is = urlConn.getInputStream();
            }else{
               is = urlConn.getErrorStream();
            }
            StringBuilder stringBuilder = new StringBuilder();

            BufferedReader in = new BufferedReader(new InputStreamReader(is));
            String str;
            while ((str = in.readLine()) != null) {
                stringBuilder.append(str).append('\n');
            }
            in.close();

            is.close();
            if (responseCode < 300){
                webResponse.setResponse(stringBuilder.toString());
            }else if ((responseCode == 400) || (responseCode == 403) || (responseCode == 404)){
                webResponse.setResponseMessage(stringBuilder.toString());
            }
        } catch (Exception exc) {
            throw new IOException("Java Store Server is temporarily out of service.");
        }

        if ((responseCode >= 300) && (responseCode != 400) && (responseCode != 403) && (responseCode != 404)) {
            webResponse.setResponseMessage("Java Store Server is temporarily out of service.");
            webResponse.setResponse("Error: " + urlConn.getResponseCode() +
                    " - " + urlConn.getResponseMessage());
        }

        Util.log("Response Code: " + webResponse.getResponseCode());
        Util.log("Response Message: " + webResponse.getResponseMessage());
        Util.log("Response: " + webResponse.getResponse());
        return webResponse;
    }

    public static void main(String[] args) throws URISyntaxException, IOException{
        WebRequest webRequest = new WebRequest("http://www.sun.com");
        webRequest.connect();
    }
}
