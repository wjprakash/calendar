

package com.jfxtools.calendar.util;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;

/**
 * Some common web requests done using HHTPS
 * @author Winston Prakash
 */
public class SecuredWebRequest extends WebRequest{
    public SecuredWebRequest(String uriStr) throws URISyntaxException, MalformedURLException, IOException {
        super(uriStr);
    }

    public SecuredWebRequest(URI uri) throws IOException {
        super(uri);
    }

    @Override
    protected void createConnection(URI uri) throws IOException{
        if ("http".equalsIgnoreCase(uri.getScheme())) {
            try {
                uri = new URI("https", uri.getSchemeSpecificPart(), uri.getFragment());
            } catch(URISyntaxException impossible) {
                throw new IOException("Could not transform URI", impossible);
            }
        }

        super.createConnection(uri);
    }
}
