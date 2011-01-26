/*
 * MonthGrid.fx
 *
 * Created on Jan 13, 2010, 4:28:28 PM
 */

package com.jfxtools.calendar.model;
import java.util.Calendar;

/**
 * @author winstonp
 */

public class MonthGrid{
    public-init var calendarModel:CalendarModel;
    public var selection:DayGrid on replace{
        if (selection != null){
            var selDay = if (calendarModel.isSameMonth(selection.date, calendarModel.selectedMonth))
                         then selection.date.get(Calendar.DATE) else -1;
            selectedDayIndex = prefixDays + selDay - 1;
        }
    }

    public var title:String;
    public var size = 35;
    public var prefixDays = 0;
    public var postfixDays = 0;
    public var dayGrids:DayGrid[];
    public var todayIndex = -1;
    public var selectedDayIndex = -1 on replace oldValue{
        if ((not (oldValue == selectedDayIndex)) and (selectedDayIndex > -1)){
            var lCalendar = calendarModel.selectedMonth.clone() as Calendar;
            if (selectedDayIndex < prefixDays){
                lCalendar.add(Calendar.MONTH, -1);
                var prevMonthDays = lCalendar.getActualMaximum(Calendar.DAY_OF_MONTH);
                lCalendar.set(Calendar.DATE, prevMonthDays-(prefixDays - selectedDayIndex) + 1);
            }else if (selectedDayIndex > (calendarModel.getNoOfDaysInMonth() + prefixDays)){
                lCalendar.add(Calendar.MONTH, 1);
                lCalendar.set(Calendar.DATE, selectedDayIndex - prefixDays - calendarModel.getNoOfDaysInMonth() + 1);
            }else{
               lCalendar.set(Calendar.DATE, selectedDayIndex - prefixDays + 1);
            }

            if (not calendarModel.isSameDate(calendarModel.selectedDate, lCalendar)){
                calendarModel.selectedDate = lCalendar;
            }
        }
    }
}
