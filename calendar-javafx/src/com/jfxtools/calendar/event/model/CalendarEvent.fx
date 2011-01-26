/*
 * CalendarEvent.fx
 *
 * Created on Jan 14, 2010, 9:29:19 PM
 */

package com.jfxtools.calendar.event.model;

import java.util.Calendar;
import java.text.SimpleDateFormat;

/**
 * @author winstonp
 */

public class CalendarEvent{
        
    public var model:EventModel;
    
    public var start:Calendar;
    public var end:Calendar;
    public var summary:String;
    public var location:String;

    public-read var startHour = bind start.get(Calendar.HOUR_OF_DAY);
    public-read var startMinute = bind start.get(Calendar.MINUTE);
    public-read var endHour = bind end.get(Calendar.HOUR_OF_DAY);
    public-read var endMinute = bind end.get(Calendar.MINUTE);

    public function print(){
        var simpleDateFormat = SimpleDateFormat.getDateInstance() as SimpleDateFormat;
        simpleDateFormat.applyPattern("MMM dd, yyyy  HH:mm");
        println("\n=================================================");
        println("Start: {simpleDateFormat.format(start.getTime())}");
        println("End: {simpleDateFormat.format(end.getTime())}");
        println("Summary: {summary}");
        println("=================================================\n");
    }

}

