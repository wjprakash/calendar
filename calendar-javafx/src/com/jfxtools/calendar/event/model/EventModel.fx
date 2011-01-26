/*
 * DayModel.fx
 *
 * Created on Jan 14, 2010, 9:28:37 PM
 */

package com.jfxtools.calendar.event.model;

import java.util.Calendar;

/**
 * @author winstonp
 */

public class EventModel{

    public var date:Calendar;
    public-read var events:CalendarEvent[];

    public function addEvent(event:CalendarEvent){
        event.model = this;
        insert event into events;
    }

    public function removeEvent(event:CalendarEvent){
        event.model = this;
        delete event from events;
    }
}
