package com.jfxtools.calendar;

import com.jfxtools.calendar.caldav.CalDAVReportMethodExt;
import java.io.IOException;
import java.io.StringWriter;
import java.net.SocketException;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.fortuna.ical4j.data.CalendarBuilder;
import net.fortuna.ical4j.data.ParserException;
import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.ComponentList;
import net.fortuna.ical4j.model.Date;
import net.fortuna.ical4j.model.component.VEvent;
import org.apache.commons.httpclient.Credentials;
import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HostConfiguration;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.auth.AuthScope;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.osaf.caldav4j.CalDAV4JException;
import org.osaf.caldav4j.CalDAV4JProtocolException;
import org.osaf.caldav4j.CalDAVCalendarCollection;
import org.osaf.caldav4j.CalDAVConstants;
import org.osaf.caldav4j.DOMValidationException;
import org.osaf.caldav4j.methods.CalDAV4JMethodFactory;
import org.osaf.caldav4j.methods.CalDAVReportMethod;
import org.osaf.caldav4j.methods.GetMethod;
import org.osaf.caldav4j.methods.HttpClient;
import org.osaf.caldav4j.methods.OptionsMethod;
import org.osaf.caldav4j.methods.PropFindMethod;
import org.osaf.caldav4j.model.request.CalendarDescription;
import org.osaf.caldav4j.model.request.CalendarQuery;
import org.osaf.caldav4j.model.request.CompFilter;
import org.osaf.caldav4j.model.request.DisplayName;
import org.osaf.caldav4j.model.request.PropProperty;
import org.osaf.caldav4j.model.response.CalDAVResponse;
import org.osaf.caldav4j.util.ICalendarUtils;
import org.osaf.caldav4j.util.XMLUtils;
import org.w3c.dom.Document;

/**
 * Base class for CalDAV4j connection,
 * .TODO use SSL?
 * FIXME it shouldn't be possibile to change serverhost/port:
 *  	these should be changed at the same time re-creating the hostConfig
 */
public class BaseCaldavClient {

    public CalDAV4JMethodFactory methodFactory = new CalDAV4JMethodFactory();
    protected CaldavCredential caldavCredential = new CaldavCredential();
    public String COLLECTION_PATH;
    public static final String OUTBOX = "/Outbox";
    public static final String INBOX = "calendar-inbox";

    public BaseCaldavClient() {
    }

    public HttpClient createHttpClient() {
        HttpClient http = new HttpClient();

        Credentials credentials = new UsernamePasswordCredentials(caldavCredential.CALDAV_SERVER_USERNAME,
                caldavCredential.CALDAV_SERVER_PASSWORD);
        http.getState().setCredentials(
                new AuthScope(caldavCredential.CALDAV_SERVER_HOST, caldavCredential.CALDAV_SERVER_PORT),
                credentials);
        http.getParams().setAuthenticationPreemptive(true);
        return http;
    }

    public HostConfiguration createHostConfiguration() {

        HostConfiguration hostConfig = new HostConfiguration();
        hostConfig.setHost(caldavCredential.CALDAV_SERVER_HOST, caldavCredential.CALDAV_SERVER_PORT, caldavCredential.CALDAV_SERVER_PROTOCOL);
        //hostConfig.setHost(new URI(caldavCredential.CALDAV_SERVER_URI));
        return hostConfig;

    }

    public CalDAVCalendarCollection createCalDAVCalendarCollection() {
        CalDAVCalendarCollection calendarCollection = new CalDAVCalendarCollection(
                caldavCredential.CALDAV_SERVER_WEBDAV_ROOT, createHostConfiguration(), methodFactory,
                CalDAVConstants.PROC_ID_DEFAULT);
        return calendarCollection;
    }

    public void getOptions() {
        HttpClient http = createHttpClient();
        HostConfiguration hostConfig = createHostConfiguration();

        OptionsMethod options = new OptionsMethod();
        options.setPath(caldavCredential.CALDAV_SERVER_WEBDAV_ROOT);
        try {
            http.executeMethod(hostConfig, options);
            System.out.println("Status Code: " + options.getStatusCode());
            for (Header h : options.getResponseHeaders()) {
                System.out.println(h);
            }

            Document rdoc = options.getResponseDocument();
            if (rdoc != null) {
                System.out.println(XMLUtils.toPrettyXML(rdoc));
            }

        } catch (HttpException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public void getPropertyNames() {
        HttpClient http = createHttpClient();
        HostConfiguration hostConfig = createHostConfiguration();

        org.apache.webdav.lib.methods.PropFindMethod propfind = new org.apache.webdav.lib.methods.PropFindMethod();
        propfind.setPath(caldavCredential.CALDAV_SERVER_WEBDAV_ROOT);
        propfind.setDepth(1);
        propfind.setType(2);
        try {
            http.executeMethod(hostConfig, propfind);
            System.out.println("Status Code: " + propfind.getStatusCode());
            for (Header h : propfind.getResponseHeaders()) {
                System.out.println(h);
            }
            Document rdoc = propfind.getResponseDocument();
            if (rdoc != null) {
                System.out.println(toPrettyXML(rdoc));
            }
        } catch (HttpException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }


    }

    public static String toPrettyXML(Document document) {
        StringWriter stringWriter = new StringWriter();
        OutputFormat outputFormat = new OutputFormat(document, null, true);
        XMLSerializer xmlSerializer = new XMLSerializer(stringWriter,
                outputFormat);
        xmlSerializer.setNamespaces(true);
        try {
            xmlSerializer.asDOMSerializer().serialize(document);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return stringWriter.toString();

    }

    public void getProperties() {

        HttpClient http = createHttpClient();
        HostConfiguration hostConfig = createHostConfiguration();

        PropFindMethod propfind = new PropFindMethod();
        propfind.setPath(caldavCredential.CALDAV_SERVER_WEBDAV_ROOT);

        PropProperty propFindTag = new PropProperty(CalDAVConstants.NS_DAV, "D", "propfind");
        PropProperty aclTag = new PropProperty(CalDAVConstants.NS_DAV, "D", "acl");
        PropProperty propTag = new PropProperty(CalDAVConstants.NS_DAV, "D", "prop");
        propTag.addChild(aclTag);
        propTag.addChild(new DisplayName());
        propTag.addChild(new CalendarDescription());
        propFindTag.addChild(propTag);
        propfind.setReportRequest(propFindTag);
        propfind.setDepth(0);

        try {
            http.executeMethod(hostConfig, propfind);
            System.out.println("Status Code: " + propfind.getStatusCode());
            for (Header h : propfind.getResponseHeaders()) {
                System.out.println(h);
            }

            Document rdoc = propfind.getResponseDocument();
            if (rdoc != null) {
                System.out.println(XMLUtils.toPrettyXML(rdoc));
            }

        } catch (HttpException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public void getReport() throws Exception {
        CalDAVReportMethod report = methodFactory.createCalDAVReportMethod();
        HttpClient http = createHttpClient();
        HostConfiguration hostConfig = createHostConfiguration();

        PropProperty calendarDataTag = new PropProperty(CalDAVConstants.NS_DAV, "D", "calendar-data");
        CalendarQuery calquery = new CalendarQuery("C", "D");
        calquery.addProperty(calendarDataTag);
        CompFilter vCalendarCompFilter = new CompFilter("C");
        vCalendarCompFilter.setName(Calendar.VCALENDAR);
        calquery.setCompFilter(vCalendarCompFilter);
        report.setReportRequest(calquery);
        report.setDepth(1);

        report.setPath(caldavCredential.CALDAV_SERVER_WEBDAV_ROOT);
        try {
            http.executeMethod(hostConfig, report);
            System.out.println("Status Code: " + report.getStatusCode());
            for (Header h : report.getResponseHeaders()) {
                System.out.println(h);
            }

            Document rdoc = report.getResponseDocument();
            if (rdoc != null) {
                System.out.println(XMLUtils.toPrettyXML(rdoc));
            }

        } catch (HttpException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }

    public Calendar getCalendar() throws ParserException {
        try {
            HttpClient http = createHttpClient();
            HostConfiguration hostConfig = createHostConfiguration();
            GetMethod get = methodFactory.createGetMethod();
            get.setPath(caldavCredential.CALDAV_SERVER_WEBDAV_ROOT + "calendar");
            http.executeMethod(hostConfig, get);
            int statusCode = get.getStatusCode();
            System.out.println("Status code: " + statusCode);
            for (Header h : get.getResponseHeaders()) {
                System.out.println(h);
            }

//            Document rdoc = get.getResponseDocument();
//            if (rdoc != null) {
//                System.out.println(XMLUtils.toPrettyXML(rdoc));
//            }
            return get.getResponseBodyAsCalendar();
        } catch (CalDAV4JProtocolException ex) {
            Logger.getLogger(BaseCaldavClient.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException exc) {
            exc.printStackTrace();
        }
        return null;
    }

    public Calendar getCalendarByPath() throws Exception {
        CalDAVCalendarCollection calendarCollection = createCalDAVCalendarCollection();
        Calendar calendar = null;
        HttpClient http = createHttpClient();
        try {
            calendar = calendarCollection.getCalendarByPath(http,
                    "A06FB3A2-30BB-4744-B8AF-004409BEBD79.ics");
        } catch (CalDAV4JException ce) {
            ce.printStackTrace();
        }

        return calendar;
    }

    public List<Calendar> getEventByDates() throws Exception {
        CalDAVCalendarCollection calendarCollection = createCalDAVCalendarCollection();
        HttpClient httpClient = createHttpClient();
        Date beginDate = ICalendarUtils.createDateTime(2009, 12, 1, null, false);
        Date endDate = ICalendarUtils.createDateTime(2009, 12, 25, null, false);
        List<Calendar> calendarList = calendarCollection.getEventResources(httpClient,
                beginDate, endDate);

        for (Calendar calendar : calendarList) {
            ComponentList vevents = calendar.getComponents().getComponents(
                    Component.VEVENT);
            VEvent vevent = (VEvent) vevents.get(0);
            String summary = ICalendarUtils.getSummaryValue(vevent);
            System.out.println(summary);
        }
        return calendarList;
    }

    private ThreadLocal<CalendarBuilder> calendarBuilderThreadLocal = new ThreadLocal<CalendarBuilder>();
    private CalendarBuilder getCalendarBuilderInstance(){
        CalendarBuilder builder = calendarBuilderThreadLocal.get();
        if (builder == null){
            builder = new CalendarBuilder();
            calendarBuilderThreadLocal.set(builder);
        }
        return builder;
    }

    public List<Calendar> getCalendarByQuery() throws CalDAV4JException {
        HttpClient httpClient = createHttpClient();
        HostConfiguration hostConfig = createHostConfiguration();
        System.out.println(hostConfig.getHostURL() + caldavCredential.CALDAV_SERVER_WEBDAV_ROOT);
        Date beginDate = ICalendarUtils.createDateTime(2009, 11, 1, null, true);
        Date endDate = ICalendarUtils.createDateTime(2009, 12, 25, null, true);
        //CalDAVReportMethod reportMethod = methodFactory.createCalDAVReportMethod();

        CalDAVReportMethodExt reportMethod = new CalDAVReportMethodExt();
        reportMethod.setCalendarBuilder(getCalendarBuilderInstance());
        reportMethod.setPath(caldavCredential.CALDAV_SERVER_WEBDAV_ROOT);

        CalendarQuery query = new CalendarQuery("C", "D");

        //query.addProperty(CalDAVConstants.PROP_ETAG);
        query.addProperty(new PropProperty(CalDAVConstants.NS_CALDAV, "C", "calendar-data"));
        CompFilter vCalendarCompFilter = new CompFilter("C");
        vCalendarCompFilter.setName(Calendar.VCALENDAR);

//        CompFilter vEventCompFilter = new CompFilter("C");
//        vEventCompFilter.setName(Component.VEVENT);
//        vEventCompFilter.setTimeRange(new TimeRange("C", beginDate, endDate));
//
//        vCalendarCompFilter.addCompFilter(vEventCompFilter);
        query.setCompFilter(vCalendarCompFilter);

        reportMethod.setReportRequest(query);
        reportMethod.setDepth(1);
        try {
            httpClient.executeMethod(hostConfig, reportMethod);
        } catch (Exception he) {
            he.printStackTrace();
            throw new CalDAV4JException("Problem executing method", he);
        }

        for (Header h : reportMethod.getRequestHeaders()) {
            System.out.println(h);
        }
        Document doc = null;
        try {
            doc = query.createNewDocument(XMLUtils
                    .getDOMImplementation());
        } catch (DOMValidationException domve) {
            domve.printStackTrace();
        }
        System.out.println(XMLUtils.toPrettyXML(doc));


        System.out.println("Status Code: " + reportMethod.getStatusCode());
        
        for (Header h : reportMethod.getResponseHeaders()) {
            System.out.println(h);
        }

        Document rdoc = reportMethod.getResponseDocument();
        if (rdoc != null) {
            System.out.println(XMLUtils.toPrettyXML(rdoc));
        }

        Enumeration<CalDAVResponse> e = reportMethod.getResponses();
        List<Calendar> list = new ArrayList<Calendar>();
        while (e.hasMoreElements()) {
            CalDAVResponse response = e.nextElement();
            String etag = response.getETag();
            System.out.println(etag);
//            CalDAVResource resource = getCalDAVResource(httpClient,stripHost(response.getHref()), etag);
//            list.add(resource.getCalendar());
        }

        return list;
    }

    // ************* test *****************
    public static void main(String[] args) throws CalDAV4JException, SocketException, URISyntaxException, Exception {

        BaseCaldavClient cli = new BaseCaldavClient();
//        cli.getPropertyNames();
//        cli.getOptions();
//        cli.getProperties();
//        cli.getReport();
//
//        Calendar calendar = cli.getCalendarByPath();
//        VEvent vevent = ICalendarUtils.getFirstEvent(calendar);
//        String summary = ICalendarUtils.getSummaryValue(vevent);
//        System.out.println(summary);

        cli.getCalendarByQuery();
    }
}
