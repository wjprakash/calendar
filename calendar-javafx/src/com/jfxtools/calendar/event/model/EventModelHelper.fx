/*
 * EventModel.fx
 *
 * Created on Jan 14, 2010, 8:59:53 PM
 */
package com.jfxtools.calendar.event.model;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.text.SimpleDateFormat;

/**
 * @author winstonp
 */
public class EventModelHelper {

    protected var simpleDateFormat = SimpleDateFormat.getDateInstance() as SimpleDateFormat;

    var models = new HashMap();

    public function addEvent(event:CalendarEvent){
        var model = findModel(event.start);
        model.addEvent(event);
    }

    public function removeEvent(event:CalendarEvent){
        var model = findModel(event.start);
        model.removeEvent(event);
    }

    public function findModel(date:Calendar):EventModel{
        var key = simpleDateFormat.format(date.getTime());
        if (models.containsKey(key)){
            return models.get(key) as EventModel;
        }
        var eventModel = EventModel{
            date: date
        }
        models.put(key, eventModel);
        return  eventModel;
    }

    postinit{
       simpleDateFormat.applyPattern("yyyy-MM-dd");
    }

}

public function getEventDuration(event: CalendarEvent) {
    return getTime(event.end) - getTime(event.start);
}

public function getTime(time: Calendar): Number {
//    var simpleDateFormat = SimpleDateFormat.getDateInstance() as SimpleDateFormat;
//    simpleDateFormat.applyPattern("HH:mm");
    var hour = time.get(Calendar.HOUR_OF_DAY);
    var minute = time.get(Calendar.MINUTE);
    return hour + minute / 60.;
}

public function run() {

    var selectedDate = new GregorianCalendar();
    //selectedDate.add(Calendar.DATE, 2);

    var eventModelHelper = EventModelHelper{};

    var start = selectedDate.clone() as Calendar;
    start.set(Calendar.HOUR_OF_DAY, 8);
    var end = selectedDate.clone() as Calendar;
    end.set(Calendar.HOUR_OF_DAY, 9);
    var event = CalendarEvent {
                start: start
                end: end
                summary: "First event"
            }

    eventModelHelper.addEvent(event);

    start = selectedDate.clone() as Calendar;
    start.set(Calendar.HOUR_OF_DAY, 10);
    end = selectedDate.clone() as Calendar;
    end.set(Calendar.HOUR_OF_DAY, 11);

    event = CalendarEvent {
        start: start
        end: end
        summary: "Second event"
    }

    eventModelHelper.addEvent(event);

    start = selectedDate.clone() as Calendar;
    start.add(Calendar.DATE, 1);
    start.set(Calendar.HOUR_OF_DAY, 10);
    end = selectedDate.clone() as Calendar;
    end.add(Calendar.DATE, 1);
    end.set(Calendar.HOUR_OF_DAY, 11);
    event = CalendarEvent {
        start: start
        end: end
        summary: "Third event"
    }

    eventModelHelper.addEvent(event);

    var model = eventModelHelper.findModel(selectedDate);
    for (evt in model.events) {
        evt.print();
    }

}



