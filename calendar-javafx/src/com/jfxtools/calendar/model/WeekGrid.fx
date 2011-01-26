/*
 * WeekGrid.fx
 *
 * Created on Jan 13, 2010, 4:30:18 PM
 */

package com.jfxtools.calendar.model;
import java.util.Calendar;

/**
 * @author winstonp
 */

public class WeekGrid{
    public-init var calendarModel:CalendarModel;

    public var startDate:Calendar;

    public var selection:DayGrid on replace{
        if (selection != null){
            if (calendarModel.isSameWeek(selection.date, calendarModel.selectedWeek)) then{
                selectedDayIndex = selection.date.get(Calendar.DAY_OF_WEEK) - 1;
            }
        }
    }

    public var title:String;
    public var dayGrids:DayGrid[];
    public var todayIndex = -1;
    public var selectedDayIndex = -1 on replace oldValue{
        if ((not (oldValue == selectedDayIndex)) and (selectedDayIndex > -1) and (startDate != null)){
            var lCalendar = startDate.clone() as Calendar;
            lCalendar.add(Calendar.DATE, selectedDayIndex + 1);
            if (not calendarModel.isSameDate(calendarModel.selectedDate, lCalendar)){
                calendarModel.selectedDate = lCalendar;
            }
        }
    }
}