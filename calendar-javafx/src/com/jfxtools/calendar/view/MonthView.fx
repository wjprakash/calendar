/*
 * MonthView.fx
 *
 * Created on Nov 16, 2009, 7:21:07 PM
 */
package com.jfxtools.calendar.view;

import javafx.scene.Group;
import javafx.scene.paint.Color;
import javafx.scene.shape.Line;
import javafx.scene.shape.Rectangle;

import javafx.scene.layout.Panel;

import javafx.scene.Node;
import javafx.util.Math;

import javafx.scene.control.Label;

import javafx.geometry.HPos;
import javafx.geometry.VPos;
import com.jfxtools.calendar.Constants;

import com.jfxtools.calendar.model.CalendarModel;
import com.jfxtools.calendar.controls.ArrowButton;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.input.MouseEvent;
import java.util.Calendar;
import com.jfxtools.calendar.event.model.CalendarEvent;
import com.jfxtools.calendar.AppContext;
import com.jfxtools.calendar.event.CreateEventDialog;
import com.jfxtools.calendar.controls.PopupMenu;
import com.jfxtools.calendar.controls.PopupMenuItem;

/**
 * Month View of the Calendar
 * @author Winston Prakash
 */
public class MonthView extends Panel {

    public var appContext: AppContext;
    
    var monthLabelText = bind monthGrid.title;
    var weekdays = bind calendarModel.weekDayLabels;

    var todayIndex = bind monthGrid.todayIndex on replace{
        todayHighlight.visible = false;
        if (monthGrid.todayIndex > -1){
            todayHighlight.visible = true;
        }
    }

    var selectedDayIndex = bind monthGrid.selectedDayIndex on replace{
       selectedDayHighlight.visible = false;
        if (monthGrid.selectedDayIndex > -1){
            selectedDayHighlight.visible = true;
        }
    }

    var monthDayLabels: Label[];

    var verticalLines: Line[];

    var horizontalLines: Line[];

    var weekDayLabels: Label[];

    var eventNodes: Node[];

    var monthGrid =  bind calendarModel.monthGrid on replace{
        if (monthGrid != null){
            yGridSize = monthGrid.size / xGridSize;
            redrawGrid();
        }
    }

    var xGridOffset = 0.;
    var yGridOffset = 50.;
    var xGridSize: Integer = 7;
    var yGridSize: Integer;
    var background = Rectangle {
            width: bind width, height: bind height
            fill: Color.BLANCHEDALMOND;
            stroke: Color.GRAY
            strokeWidth: 0.4
        }
    public var gridWidth: Number = bind (width - xGridOffset) / xGridSize on replace{
        if (gridWidth > 0){
            redrawGrid();
        }
    }

    public var gridHeight: Number = bind (height - yGridOffset) / yGridSize on replace{
        if (gridHeight > 0){
            redrawGrid();
        }
    }

    var todayHighlight = Rectangle{
        layoutX: bind (todayIndex mod 7) * gridWidth + xGridOffset
        layoutY: bind (todayIndex / 7) * gridHeight + yGridOffset
        width: bind gridWidth
        height: bind gridHeight
        fill: Color.BURLYWOOD
        visible: false
    }

    var selectedDayHighlight = Rectangle{
        layoutX: bind (selectedDayIndex mod 7) * gridWidth + xGridOffset
        layoutY: bind (selectedDayIndex / 7) * gridHeight + yGridOffset
        width: bind gridWidth
        height: bind gridHeight
        fill: Color.DARKSALMON
        visible: false
    }

    var monthLabel: Label = Label {
            hpos: HPos.CENTER
            vpos: VPos.CENTER
            layoutInfo: LayoutInfo{
                width: 150
                height: 20
            }
            text: bind monthLabelText
            font: Constants.fontBoldExtraLarge3
        }
    var leftNavButton = ArrowButton {
            direction: ArrowButton.LEFT
            width: 20
            height: 20
            action: function () {
                calendarModel.prevMonth();
            }
        }

    var rightNavButton = ArrowButton {
            direction: ArrowButton.RIGHT
            width: 20
            height: 20
            action: function () {
                calendarModel.nextMonth();
            }
        }

    var header = HBox {
            layoutY: 10
            layoutX: bind (width - 200) / 2
            width: 200
            height: yGridOffset - 20
            spacing: 3
            content: [leftNavButton, monthLabel, rightNavButton]
        }

    var grid = Group {
            content: bind [
                background,
                header,
                todayHighlight,
                selectedDayHighlight,
                weekDayLabels,
                verticalLines,
                horizontalLines,
                monthDayLabels,
                eventNodes
            ]
        }

    public-init var calendarModel: CalendarModel;

    postinit {
        blocksMouse = true;
        content = [grid];
    }

    function redrawGrid(){
        if ( (monthGrid != null) and (gridWidth > 0) and (gridHeight > 0)){
            monthDayLabels = for (i in [0 .. xGridSize - 1], j in [0 .. monthGrid.size / xGridSize - 1]) {
                    Label {
                        layoutX: (i + 1) * gridWidth - 30 + xGridOffset
                        layoutY: j * gridHeight + yGridOffset + 5
                        width: 25
                        hpos: HPos.RIGHT
                        vpos: VPos.CENTER
                        text: monthGrid.dayGrids[i + (j * 7)].title
                        font: Constants.fontRegularExtraLarge
                        textFill: if (monthGrid.dayGrids[i + (j * 7)].otherMonthDay) Color.GRAY else Color.BLACK
                    }
                }

            verticalLines = for (i in [0..xGridSize - 1]) {
                    Line {
                        startX: i * gridWidth + xGridOffset, startY: background.boundsInParent.minY + yGridOffset
                        endX: i * gridWidth + xGridOffset, endY: background.boundsInParent.maxY
                        strokeWidth: 0.4
                        stroke: Color.GRAY
                    }
                }
            horizontalLines  =  for (i in [0..yGridSize - 1]) {
                    Line {
                        startY: i * gridHeight + yGridOffset, startX: background.boundsInParent.minX + xGridOffset
                        endY: i * gridHeight + yGridOffset, endX: background.boundsInParent.maxX
                        strokeWidth: 0.4
                        stroke: Color.GRAY
                    }
                }
            weekDayLabels = for (i in [0..xGridSize - 1]) {
                    Label {
                        layoutX: i * gridWidth + xGridOffset
                        layoutY: yGridOffset - 20
                        width: gridWidth
                        height: 20
                        hpos: HPos.CENTER
                        vpos: VPos.CENTER
                        text: weekdays[i]
                        font: Constants.fontRegularExtraLarge
                    }
                }

            refreshEventNodes();
        }
    }

    function refreshEventNodes() {
        var nodes: MonthDayEventsNode[];
        for (dayGrid in monthGrid.dayGrids) {
            var node = MonthDayEventsNode {
                appContext:appContext
                width: gridWidth;
                height: gridHeight;
                layoutX: indexof dayGrid mod 7 * gridWidth + xGridOffset;
                layoutY: indexof dayGrid / 7 * gridHeight + yGridOffset;
                events: bind dayGrid.events
            }
            insert node into nodes;
        }
        eventNodes = nodes;
    }

    protected var popupMenu = PopupMenu {
        appContext: appContext
        menuItems: [
            PopupMenuItem {
                text: "Add Event"
                action: addEvent
            }
        ]
    };

    var eventDayIndex = 0;
    
    override public var onMousePressed = function(e:MouseEvent):Void {
        if ((e.x > xGridOffset) and (e.y > yGridOffset)) {

            var xGrid = Math.floor((e.x - xGridOffset) / gridWidth);
            var yGrid = Math.floor((e.y - yGridOffset) / gridHeight);
            eventDayIndex = (yGrid * 7 + xGrid) as Integer;
            if (e.clickCount == 2){
                addEvent();
            }else {
                if (e.popupTrigger){
                    popupMenu.show(e);
                }
                monthGrid.selectedDayIndex = eventDayIndex;
            }
       }
    }

    function addEvent(){
        var startHour = 9;
        var currentDayGrid = monthGrid.dayGrids[eventDayIndex];
        var startCal = currentDayGrid.date.clone() as Calendar;
        var endCal = currentDayGrid.date.clone() as Calendar;
        startCal.set(Calendar.HOUR_OF_DAY, startHour);
        endCal.set(Calendar.HOUR_OF_DAY, startHour + 1);
        var event = CalendarEvent {
            start: startCal
            end: endCal
            summary: "New event"
        }

        currentDayGrid.addEvent(event);
        var createEventDialog:CreateEventDialog = CreateEventDialog {
            appContext: appContext
            event: event
            callbackFunction: function () {
               if (createEventDialog.cancelled){
                    currentDayGrid.removeEvent(event);
               }
            }
        };
        createEventDialog.show();
    }

//
//    override public var onMouseDragged = function(e:MouseEvent):Void {
//        dragLine.ex = e.x;
//        dragLine.ey = e.y;
//        dragLine.visible = true;
//    }
//    package function placeNode(node: Node, x: Number, y: Number) {
//        if (Sequences.indexOf(content, node) == -1) {
//            insert node into content;
//        }
//        var xOffset = Math.floor(x / gridWidth) * gridWidth;
//        var yOffset = Math.floor(y / gridHeight) * gridHeight;
//        positionNode(node, xOffset, yOffset);
//    }
}
