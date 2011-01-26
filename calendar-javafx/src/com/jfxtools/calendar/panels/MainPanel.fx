/*
 * MainPanel.fx
 *
 * Created on Dec 09, 2009, 10:46:19 PM
 */

package com.jfxtools.calendar.panels;

import javafx.scene.layout.Panel;

import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

import com.jfxtools.calendar.Constants;
import com.jfxtools.calendar.AppContext;
import com.jfxtools.calendar.explorer.CalendarExplorerView;
import com.jfxtools.calendar.view.CalendarView;

import com.jfxtools.calendar.view.CalendarPickerView;

import javafx.scene.Group;

/**
 * The main panel of the calendar tool
 * @author Winston Prakash
 */

public class MainPanel extends Panel{

    public-init var appContext:AppContext;
    
    var calenderPickerW = Constants.explorerWidth;
    var calenderPickerH = 235;

    var calenderPickerX = Constants.windowLeftIndent;
    var calenderPickerY = bind height - Constants.windowTopIndent - calenderPickerH;

    var explorerViewX = Constants.windowLeftIndent;
    var explorerViewY = Constants.windowTopIndent;

    var explorerViewW = Constants.explorerWidth;
    var explorerViewH = bind height - Constants.windowTopIndent - 2 * Constants.windowBottomIndent - calenderPickerH;


    var backgroundOverlay = Rectangle {
        width: bind width
        height: bind height
        fill: Color.rgb(105,4,0,1.0)
//        fill: LinearGradient {
//            startX : 0.0 startY : 0.0 endX : 0 endY : 1.0 proportional: true
//            stops: [
//                Stop{ offset: 0.00 color: Color.rgb(105,4,0,1.0) }
//                Stop{ offset: 0.10 color: Color.rgb(116,18,0,1.0) }
//                Stop{ offset: 0.60 color: Color.rgb(110,18,0,0.8) }
//                Stop{ offset: 0.98 color: Color.rgb(102,16,0,0.85) }
//                Stop{ offset: 1.00 color: Color.rgb(102,16,0,1.0) }
//            ]
//        }
    }
    
    var explorerView = CalendarExplorerView{
        appContext:appContext
        layoutX: explorerViewX
        layoutY: explorerViewY
        width: bind explorerViewW
        height: bind explorerViewH
    }

    var calendarPickerView = CalendarPickerView{
	layoutX: calenderPickerX
        layoutY: bind calenderPickerY
        width: calenderPickerW
        height: calenderPickerH
        calendarModel: bind appContext.calendarModel
    };

    var centerPanelX = explorerViewX + explorerViewW + Constants.windowGap;
    var centerPanelY = Constants.windowTopIndent;

    var viewPanel = ViewPanel{
        layoutX: centerPanelX
        layoutY: centerPanelY
        width: bind width - explorerViewW - 3 * Constants.windowGap
        height: bind height - Constants.windowTopIndent - Constants.windowBottomIndent
    }

    var monthViewCalendar:CalendarView = CalendarView {
        type: CalendarView.TYPE_MONTH
        appContext: bind appContext
        calendarModel: bind appContext.calendarModel
    }
    var weekViewCalendar:CalendarView = CalendarView {
        type: CalendarView.TYPE_WEEK
        appContext: bind appContext
        calendarModel: bind appContext.calendarModel
    }
    var dayViewCalendar:CalendarView = CalendarView {
        type: CalendarView.TYPE_DAY
        appContext: bind appContext
        calendarModel: bind appContext.calendarModel
    }

    postinit{
        viewPanel.addTab("Day", dayViewCalendar);
        viewPanel.addTab("Week", weekViewCalendar);
        viewPanel.addTab("Month", monthViewCalendar);
        viewPanel.selectedIndex = 2;
        appContext.viewPanel = viewPanel;
        content = [
            backgroundOverlay,
            explorerView,
            calendarPickerView,
            viewPanel
        ]
    }
}
