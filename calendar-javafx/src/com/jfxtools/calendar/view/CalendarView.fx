/*
 * CalendarView.fx
 *
 * Created on Dec 09, 2009, 9:32:20 PM
 */
package com.jfxtools.calendar.view;

import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.layout.Panel;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.Group;

import com.jfxtools.calendar.AppContext;
import javafx.scene.Node;
import com.jfxtools.calendar.model.CalendarModel;
import java.util.Calendar;
import java.util.GregorianCalendar;
import com.jfxtools.calendar.event.model.CalendarEvent;
import com.jfxtools.calendar.event.model.EventModelHelper;

/**
 * Viewer that displays Month, Week and Day Calendar
 * @author Winston Prakash
 */
public def TYPE_MONTH = 1;
public def TYPE_WEEK = 2;
public def TYPE_DAY = 3;

public class CalendarView extends Panel {

    public-init var type = TYPE_MONTH ;
    public var calendarModel: CalendarModel;
    public var appContext: AppContext;
    var background = Rectangle {
                width: bind width
                height: bind height
                fill: Color.WHITESMOKE
                arcHeight: 12
                arcWidth: 12
            }

    postinit {
        var view: Node;
        if (type == TYPE_MONTH) {
            view = MonthView {
                appContext: bind appContext
                layoutX: 10
                layoutY: 10
                width: bind width - 20
                height: bind height - 20
                calendarModel: calendarModel
            }
        } else if (type == TYPE_WEEK) {
            view = WeekView {
                appContext: bind appContext
                layoutX: 10
                layoutY: 10
                width: bind width - 20
                height: bind height - 20
                calendarModel: calendarModel
            }
        } else if (type == TYPE_DAY) {
            view = DayView {
                appContext: bind appContext
                layoutX: 10
                layoutY: 10
                width: bind width - 20
                height: bind height - 20
                calendarModel: calendarModel
            }
        }

        blocksMouse = true;
        content = [
            background,
            view
        ];
    }
}

public function run() {

    var width = 900;
    var height = 900;

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

    var calendarModel = CalendarModel {
        eventModelHelper: eventModelHelper
        selectedDate: selectedDate
    };

    var appContext: AppContext = AppContext {
        width: width
        height: height
        stage: bind stage
    };

    var calendarView: CalendarView = CalendarView {
        appContext: appContext
        type: TYPE_MONTH
        width: bind panel.width
        height: bind panel.height
        calendarModel: calendarModel;
    }

    var panel: Panel = Panel {
        width: bind scene.width
        height: bind scene.height
        content: calendarView
    }

    var scene: Scene = Scene {
        content: panel
    }

    var stage: Stage  = Stage {
        width: width
        height: height
        title: "Calendar Viewer"
        scene: scene
    }    
}
