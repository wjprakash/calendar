/*
 * AppContext.fx
 *
 * Created on Dec 09, 2009, 2:44:57 PM
 */
package com.jfxtools.calendar;

import javafx.stage.Stage;
import javafx.scene.Node;

import com.jfxtools.calendar.panels.ViewPanel;
import com.jfxtools.calendar.model.CalendarModel;
import java.util.GregorianCalendar;
import java.util.Calendar;
import com.jfxtools.calendar.event.model.CalendarEvent;
import com.jfxtools.calendar.event.model.EventModelHelper;

/**
 * Holds information about the Application context
 * @author Winston Prakash
 */
public class AppContext {

    public-read var calendarModel: CalendarModel;
    
    public var x = bind stage.x;
    public var y = bind stage.y;
    public var width = bind stage.width;
    public var height = bind stage.height;

    public var stage: Stage;
    public var defaultFocus: Node;
    public var viewPanel: ViewPanel;

    public var selectedEventNode: Node;

    postinit {

        var selectedDate = new GregorianCalendar();
        selectedDate.add(Calendar.DATE, 2);

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

        calendarModel = CalendarModel {
            selectedDate: selectedDate
            eventModelHelper: eventModelHelper
        };
    }
}
