/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jfxtools.calendar.caldav;

import java.io.IOException;
import org.apache.commons.httpclient.HttpConnection;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpState;
import org.osaf.caldav4j.CalDAVConstants;
import org.osaf.caldav4j.methods.CalDAVReportMethod;

/**
 *
 * @author winstonp
 */
public class CalDAVReportMethodExt extends CalDAVReportMethod {

    @Override
    protected String generateRequestBody() {
        System.out.println("Generating request body");
        String body = "<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
                "<C:calendar-query xmlns:D=\"DAV:\"" +
                "xmlns:C=\"urn:ietf:params:xml:ns:caldav\">" +
                "<D:prop>" +
                "<C:calendar-data/>" +
                "</D:prop>" +
                "<C:filter>" +
                "<C:comp-filter name=\"VCALENDAR\">" +
                "<C:comp-filter name=\"VEVENT\">" +
                "<C:time-range start=\"20090101T000000Z\" " +
                "end=\"20090107T000000Z\"/> " +
                "</C:comp-filter>" +
                "</C:comp-filter>" +
                "</C:filter>" +
                "</C:calendar-query>";

        return body;
    }

    @Override
    public void addRequestHeaders(HttpState state, HttpConnection conn)
    throws IOException, HttpException {
        System.out.println("Adding request Header");
        super.addRequestHeaders(state, conn);

        switch (getDepth()) {
        case DEPTH_0:
            super.setRequestHeader("Depth", "0");
            break;
        case DEPTH_1:
            super.setRequestHeader("Depth", "1");
            break;
        case DEPTH_INFINITY:
            super.setRequestHeader("Depth", "infinity");
            break;
        }

        addRequestHeader("Content-Type", "application/xml");

    }
}
