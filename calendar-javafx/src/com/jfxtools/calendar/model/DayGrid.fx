/*
 * DayGrid.fx
 *
 * Created on Jan 15, 2010, 8:15:50 AM
 */

package com.jfxtools.calendar.model;

import java.util.Calendar;
import com.jfxtools.calendar.event.model.CalendarEvent;
import com.jfxtools.calendar.event.model.EventModel;

/**
 * @author winstonp
 */

public class DayGrid {
    public var otherMonthDay:Boolean = false;
    public var isToday:Boolean = false;
    public var isSelectedDay:Boolean = false;

    public-init var calendarModel:CalendarModel;

    public var date:Calendar on replace{
        if (date != null){
            eventModel = calendarModel.eventModelHelper.findModel(date);
        }
    }

    public var title:String;

    public var eventModel:EventModel;

    public-read var events:CalendarEvent[] = bind eventModel.events;

    public function addEvent(event: CalendarEvent){
        calendarModel.eventModelHelper.addEvent(event);
    }

    public function removeEvent(event: CalendarEvent){
        calendarModel.eventModelHelper.removeEvent(event);
    }
}
