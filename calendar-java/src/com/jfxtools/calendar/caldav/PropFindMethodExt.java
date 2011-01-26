/*
 * Copyright 2006 Open Source Applications Foundation
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.jfxtools.calendar.caldav;

import org.apache.webdav.lib.methods.PropFindMethod;

/**
 * This method is overwritten in order to register the ticketdiscovery element
 * with the PropertyFactory.
 * 
 * @author EdBindl
 * 
 */
public class PropFindMethodExt extends PropFindMethod {

    /**
     * Generates a request body from the calendar query.
     */
    protected String generateRequestBody() {
        String body = "<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
                "<x0:propfind xmlns:x2=\"http://calendarserver.org/ns/\" xmlns:x1=\"urn:ietf:params:xml:ns:caldav\" xmlns:x2=\"DAV:\">" +
                "<x0:prop>" +
                "<x1:calendar-home-set/>" +
                "<x1:calendar-user-address-set/>" +
                "<x1:schedule-inbox-URL/>" +
                "<x1:schedule-outbox-URL/>" +
                "<x2:dropbox-home-URL/>" +
                "<x2:notifications-URL/>" +
                "<x0:displayname/>" +
                "</x0:prop>" +
                "</x0:propfind>";

        return body;
    }
}
