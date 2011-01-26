/*
 * CalendarMonthModel.fx
 *
 * Created on Dec 11, 2009, 4:21:55 PM
 */

package com.jfxtools.calendar.model;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import com.jfxtools.calendar.event.model.EventModelHelper;


/**
 * Model for the Calendar View
 * @author Winston Prakash
 */

public class CalendarModel {

        public var eventModelHelper:EventModelHelper;
        public-read var today:Calendar = new GregorianCalendar();
        protected var simpleDateFormat = SimpleDateFormat.getDateInstance() as SimpleDateFormat;
        
        public-read var selectedDayGrid:DayGrid;
        public-read var monthGrid:MonthGrid;
        public-read var weekDayLabels:String[];

        public-read var weekGrid:WeekGrid;

        public var selectedMonth:Calendar on replace{
            if (selectedMonth != null) {
                monthGrid = getMonthGrid();
            }
        }

        public var selectedDate:Calendar = new GregorianCalendar() on replace{
           if (selectedDate != null){
               selectedDayGrid = getDayGrid();
               if (not isSameWeek(selectedDate, selectedWeek)){
                   selectedWeek = selectedDate;
               }else{
                   weekGrid.selection = selectedDayGrid;
               }
               if (not isSameMonth(selectedDate, selectedMonth)){
                    selectedMonth = selectedDate;
               }else{
                   monthGrid.selection = selectedDayGrid;
               }

           }
        }

        public var selectedWeek:Calendar on replace{
           if (selectedWeek != null){
               weekGrid = getWeekGrid();
           }
        }

        postinit{
            weekDayLabels = getWeekDayLabels();
        }
        
        public function getMonthNames() : String[]{
            var lCalendar = new GregorianCalendar(2009, 0, 1);
            simpleDateFormat.applyPattern("MMMMM");
            return [
                for (i in [0..11]){
                    lCalendar.set(Calendar.MONTH, i);
                    simpleDateFormat.format(lCalendar.getTime())
                }
            ];
	}

	/**
	 * Get the current month name
	 */
	public function getMonth():String{
            simpleDateFormat.applyPattern("MMMMM");
            return simpleDateFormat.format(selectedMonth.getTime());
	}

        public function getYear():String{
            simpleDateFormat.applyPattern("yyyy");
            return simpleDateFormat.format(selectedMonth.getTime());
	}

        public function prevMonth(){
            var newCalendar = selectedMonth.clone() as Calendar;
            newCalendar.add(Calendar.MONTH, -1);
            selectedMonth = newCalendar;
        }

        public function nextMonth(){
            var newCalendar = selectedMonth.clone() as Calendar;
            newCalendar.add(Calendar.MONTH, 1);
            selectedMonth = newCalendar;
        }

        public function prevWeek(){
            var newCalendar = selectedWeek.clone() as Calendar;
            newCalendar.add(Calendar.DATE, -7);
            selectedWeek = newCalendar;
        }

        public function nextWeek(){
            var newCalendar = selectedWeek.clone() as Calendar;
            newCalendar.add(Calendar.DATE, 7);
            selectedWeek = newCalendar;
        }

        public function prevDay(){
            var newCalendar = selectedDate.clone() as Calendar;
            newCalendar.add(Calendar.DATE, -1);
            selectedDate = newCalendar;
        }

        public function nextDay(){
            var newCalendar = selectedDate.clone() as Calendar;
            newCalendar.add(Calendar.DATE, 1);
            selectedDate = newCalendar;
        }

        function getSelectedDateLabel():String{
            simpleDateFormat.applyPattern("E, dd MMM yyyy");
            return simpleDateFormat.format(selectedDate.getTime());
        }

	/**
	 * Return the list of weekday names
	 */
	function getWeekDayLabels():String[]{
            // Calendar.SUNDAY = 1 and Calendar.SATURDAY = 7
            simpleDateFormat.applyPattern("E");
            var lCalendar = new GregorianCalendar(2009, 6, 4 + selectedMonth.getFirstDayOfWeek()); // july 5th 2009 is a Sunday
            return [
                for (i in  [0..6]){
                    lCalendar.set(Calendar.DATE, 4 + selectedMonth.getFirstDayOfWeek() + i);
                    simpleDateFormat.format(lCalendar.getTime());
                }
            ];
	}

        function getDayGrid():DayGrid{
            var dayGrid = DayGrid {
                calendarModel: this
                date: selectedDate;
                title: getSelectedDateLabel();
            };
            return dayGrid;
        }

        function getWeekGrid(): WeekGrid {
            var weekGrid = WeekGrid {calendarModel: this};
            weekGrid.selection = if (selectedDayGrid == null) getDayGrid() else selectedDayGrid;
            simpleDateFormat.applyPattern("E, dd MMM yyyy");
            var weekNumber = selectedWeek.get(Calendar.WEEK_OF_YEAR);
            simpleDateFormat.applyPattern("yyyy");
            var year = simpleDateFormat.format(selectedWeek.getTime());
            weekGrid.title = "Week {weekNumber} of {year}";
            
            var lCalendar = selectedWeek.clone() as Calendar;
            var weekDayIndex = selectedWeek.get(Calendar.DAY_OF_WEEK);
            lCalendar.add(Calendar.DATE, -weekDayIndex);
            weekGrid.startDate = lCalendar.clone() as Calendar;
            simpleDateFormat.applyPattern("E, MMM dd");

            for (i in [0..6]) {
                var dayGrid:DayGrid = DayGrid{calendarModel: this};
                lCalendar.add(Calendar.DATE, 1);
                dayGrid.title = simpleDateFormat.format(lCalendar.getTime());
                dayGrid.date = lCalendar.clone() as Calendar;
                if (isToday(lCalendar)){
                    dayGrid.isToday = true;
                    weekGrid.todayIndex = i;
                }
                insert dayGrid into weekGrid.dayGrids;
            }
            return weekGrid;
        }


        function getMonthGrid():MonthGrid{
            var monthGrid = MonthGrid{calendarModel: this};
            simpleDateFormat.applyPattern("MMMM yyyy");
            monthGrid.title = simpleDateFormat.format(selectedMonth.getTime());
            var todayDay = if (isSameMonth(today, selectedMonth)) then today.get(Calendar.DATE) else -1;
            var selDay = if (isSameMonth(selectedDate, selectedMonth)) then selectedDate.get(Calendar.DATE) else -1;
            var firstOfMonthIndex = getFirstOfMonthIndex();
            var nextCalendar = selectedMonth.clone() as Calendar;
            nextCalendar.add(Calendar.MONTH, 1);
            var prevCalendar = selectedMonth.clone() as Calendar;
            prevCalendar.add(Calendar.MONTH, -1);
            var prevMonthDays = prevCalendar.getActualMaximum(Calendar.DAY_OF_MONTH);
            var noOfDaysInMonth = getNoOfDaysInMonth();
            monthGrid.size = if ((firstOfMonthIndex + noOfDaysInMonth) > 35) 42 else 35;
            for (i in [1 .. monthGrid.size]){
                var dayGrid:DayGrid = DayGrid{calendarModel: this};
                var index = i - firstOfMonthIndex + 1;
                if (index <= 0){
                    monthGrid.prefixDays++;
                    dayGrid.otherMonthDay = true;
                    index = prevMonthDays + index ;
                    var lCalendar = prevCalendar.clone() as Calendar;
                    lCalendar.set(Calendar.DATE, index);
                    dayGrid.date = lCalendar;
                }else if (index > getNoOfDaysInMonth()){
                    var lCalendar = nextCalendar.clone() as Calendar;
                    lCalendar.set(Calendar.DATE, index);
                    dayGrid.date = lCalendar;
                    dayGrid.otherMonthDay = true;
                    index = index - getNoOfDaysInMonth();
                    monthGrid.postfixDays++;
                }else{
                    if (index == todayDay){
                        monthGrid.todayIndex = i - 1;
                        dayGrid.isToday = true;
                    }

                    if (index == selDay){
                        monthGrid.selectedDayIndex = i - 1;
                        dayGrid.isSelectedDay = true;
                    }
                    var lCalendar = selectedMonth.clone() as Calendar;
                    lCalendar.set(Calendar.DATE, index);
                    dayGrid.date = lCalendar;
                }
                dayGrid.title = index.toString();
                insert dayGrid into monthGrid.dayGrids;
            }
            return monthGrid;
        }

        package function isSameDate(calendar1 : Calendar, calendar2 : Calendar){
            if ((calendar1 == null) or (calendar2 == null)) return false;
            var year1 = calendar1.get(Calendar.YEAR);
            var month1 = calendar1.get(Calendar.MONTH);
            var day1 = calendar1.get(Calendar.DATE);
            var year2 = calendar2.get(Calendar.YEAR);
            var month2 = calendar2.get(Calendar.MONTH);
            var day2 = calendar2.get(Calendar.DATE);
            return (year1 == year2 and month1 == month2 and day1 == day2);
        }

        /**
         * Check if the month and the year of the two calendars are the same
         */
        package function isSameMonth(calendar1 : Calendar, calendar2 : Calendar){
            if ((calendar1 == null) or (calendar2 == null)) return false;
            var year1 = calendar1.get(Calendar.YEAR);
            var month1 = calendar1.get(Calendar.MONTH);
            var year2 = calendar2.get(Calendar.YEAR);
            var month2 = calendar2.get(Calendar.MONTH);
            return (year1 == year2 and month1 == month2);
        }

        package function isSameWeek(calendar1 : Calendar, calendar2 : Calendar){
            if ((calendar1 == null) or (calendar2 == null)) return false;
            var year1 = calendar1.get(Calendar.YEAR);
            var week1 = calendar1.get(Calendar.WEEK_OF_YEAR);
            var year2 = calendar2.get(Calendar.YEAR);
            var week2 = calendar2.get(Calendar.WEEK_OF_YEAR);
            return (year1 == year2 and week1 == week2);
        }
        
	/**
	 * check if a certain weekday name is a certain day-of-the-week
	 */
	function isWeekday(idx:Integer, weekdaynr:Integer):Boolean{
            var lCalendar = new GregorianCalendar(2009, 6, 4 + selectedMonth.getFirstDayOfWeek()); // july 5th 2009 is a Sunday
            lCalendar.add(Calendar.DATE, idx);
            var lDayOfWeek = lCalendar.get(Calendar.DAY_OF_WEEK);
            return (lDayOfWeek == weekdaynr);
	}

        /**
	 * determine if a date is today
	 */
	function isToday(selectedMonth : Calendar):Boolean{
            if (selectedMonth == null) return false;
            var todayCal = Calendar.getInstance();
            var todayYear = todayCal.get(Calendar.YEAR);
            var todayMonth = todayCal.get(Calendar.MONTH);
            var todayDay = todayCal.get(Calendar.DATE);
            var year = selectedMonth.get(Calendar.YEAR);
            var month = selectedMonth.get(Calendar.MONTH);
            var day = selectedMonth.get(Calendar.DATE);
            return (year == todayYear and month == todayMonth and day == todayDay);
	}

	/**
	 * Check if a day of the month is weekend
	 */
	function isWeekdayWeekend(idx:Integer):Boolean{
            return (isWeekday(idx, Calendar.SATURDAY) or isWeekday(idx, Calendar.SUNDAY));
	}

	/**
	 * determine on which day of week idx the first of of the months is
	 */
	function getFirstOfMonthIndex(){
            var newCalendar = selectedMonth.clone() as Calendar;
            newCalendar.set(Calendar.DAY_OF_MONTH, 1);
            return newCalendar.get(Calendar.DAY_OF_WEEK);
	}

	/**
	 * determine the number of days in the month
	 */
	package function getNoOfDaysInMonth(){
            return selectedMonth.getActualMaximum(Calendar.DAY_OF_MONTH)
	}
}

