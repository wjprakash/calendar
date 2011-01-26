/*
 * WeekView.fx
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
import javafx.util.Sequences;

import javafx.scene.control.Label;

import javafx.geometry.HPos;
import javafx.geometry.VPos;
import com.jfxtools.calendar.Constants;

import com.jfxtools.calendar.model.CalendarModel;
import javafx.util.Math;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.HBox;
import com.jfxtools.calendar.controls.ArrowButton;
import javafx.scene.input.MouseEvent;
import com.jfxtools.calendar.event.model.EventModelHelper;
import java.util.Calendar;
import com.jfxtools.calendar.event.model.CalendarEvent;
import com.jfxtools.calendar.AppContext;
import com.jfxtools.calendar.event.CreateEventDialog;
import com.jfxtools.calendar.controls.PopupMenu;
import com.jfxtools.calendar.controls.PopupMenuItem;

/**
 * Week View of the Calendar
 * @author Winston Prakash
 */

public class WeekView extends Panel{

    public var appContext: AppContext;

    var hourText:String[] = ["1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "Noon",
                             "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"];

    var weekLabelText = bind weekGrid.title;

    var dayGrids = bind weekGrid.dayGrids on replace{
         if (dayGrids != null){
            createEventNodes();
         }
    }

    var weekGrid =  bind calendarModel.weekGrid;

    var xGridOffset = 50.;
    var yGridOffset = 50.;
    var xGridSize:Integer = 7;
    var yGridSize:Integer = 48;

    var background = Rectangle {
        width: bind width, height: bind height
        fill: Color.BLANCHEDALMOND;
        stroke: Color.GRAY
        strokeWidth: 0.4
    }

    public var gridWidth:Number = bind (width - xGridOffset)/xGridSize;
    public var gridHeight:Number = bind (height  - yGridOffset)/yGridSize;

    var todayIndex = bind weekGrid.todayIndex on replace{
        todayHighlight.visible = false;
        if (weekGrid.todayIndex > -1){
            todayHighlight.visible = true;
        }
    }

    var selectedDayIndex = bind weekGrid.selectedDayIndex on replace{
       selectedDayHighlight.visible = false;
        if (weekGrid.selectedDayIndex > -1){
            selectedDayHighlight.visible = true;
        }
    }

    var todayHighlight = Rectangle{
        layoutX: bind todayIndex * gridWidth + xGridOffset
        layoutY: bind  yGridOffset
        width: bind gridWidth
        height: bind background.height - yGridOffset
        fill: Color.BURLYWOOD
        visible: false
    }

    var selectedDayHighlight = Rectangle{
        layoutX: bind selectedDayIndex * gridWidth + xGridOffset
        layoutY: bind yGridOffset
        width: bind gridWidth
        height: bind background.height - yGridOffset
        fill: Color.DARKSALMON
        visible: false
    }

    var headerLine = bind Line {
            startY: yGridOffset, startX: background.boundsInParent.minX
            endY: yGridOffset, endX: background.boundsInParent.maxX
            strokeWidth: 0.4
            stroke: Color.GRAY
        }

    var verticalLines:Line[] = bind for (i in [0 .. xGridSize - 1]){
         Line {
            startX: i * gridWidth + xGridOffset, startY: background.boundsInParent.minY + yGridOffset
            endX: i * gridWidth + xGridOffset, endY: background.boundsInParent.maxY
            strokeWidth: 0.4
            stroke: Color.GRAY
        }
    }

    var horizontalLines:Line[] = bind for (i in [0 .. yGridSize - 1]){
         Line {
            startY: i * gridHeight + yGridOffset, startX: background.boundsInParent.minX + xGridOffset
            endY: i * gridHeight + yGridOffset, endX: background.boundsInParent.maxX
            strokeWidth: 0.2 + ((i + 1) mod 2) * .2
            stroke: Color.GRAY
        }
    }

    var weekDayLabels:Label[] = bind for (i in [0 .. xGridSize - 1]){
         Label {
            layoutX: i * gridWidth + xGridOffset
            layoutY: yGridOffset - 20
            width: gridWidth
            height: 20
            hpos: HPos.CENTER
            vpos: VPos.CENTER
            text: dayGrids[i].title
            font: Constants.fontRegularExtraLarge
        }
    }

    var weekLabel:Label = Label{
        layoutInfo: LayoutInfo{
                width: 150
                height: 20
            }
        hpos: HPos.CENTER
        vpos: VPos.CENTER
        text: bind weekLabelText
        font: Constants.fontBoldExtraLarge3
    }

    var leftNavButton = ArrowButton {
            direction: ArrowButton.LEFT
            width: 20
            height: 20
            action: function () {
                calendarModel.prevWeek();
            }
        }

    var rightNavButton = ArrowButton {
            direction: ArrowButton.RIGHT
            width: 20
            height: 20
            action: function () {
                calendarModel.nextWeek();
            }
        }

    var header = HBox {
            layoutY: 10
            layoutX: bind (width - 200) / 2
            width: 200
            height: yGridOffset - 20
            spacing: 3
            content: [leftNavButton, weekLabel, rightNavButton]
        }

    var hourLabels: Label[] = bind for (i in [0..yGridSize/2 - 1]) {
            Label {
                layoutX: 0
                layoutY: yGridOffset + (gridHeight * ((i+1) * 2)) - 15
                width: xGridOffset - 5
                height: 20
                hpos: HPos.RIGHT
                vpos: VPos.BOTTOM
                text: hourText[i]
                font: Constants.fontRegular
                textFill: Color.GRAY
            }
        }

    public-init var calendarModel:CalendarModel;

    var eventNodes: DayEventsNode[];

    var grid = Group{
        content: bind [
            background,
            header,
            todayHighlight,
            selectedDayHighlight,
            headerLine,
            weekDayLabels,
            verticalLines,
            horizontalLines,
            hourLabels,
            eventNodes
        ]
    }

    postinit {
        blocksMouse = true;
        content = [grid];
        createEventNodes();
    }


    function createEventNodes(){
        var tmpEventNodes:DayEventsNode[];

        for (dayGrid in dayGrids){
            var dayEventNode = DayEventsNode{
               events: bind dayGrid.events
               appContext: appContext
               width: bind gridWidth - 4;
               gridHeight: bind gridHeight
               layoutX: bind indexof dayGrid * gridWidth + xGridOffset + 5;
               layoutY: yGridOffset;
            }
            insert dayEventNode into tmpEventNodes;
        }
        // To avoid unnecessary refresh
        eventNodes = tmpEventNodes;
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
    var mouseEvent:MouseEvent;

    override public var onMousePressed = function(e:MouseEvent):Void {
        mouseEvent = e;
        if ((e.x > xGridOffset) and (e.y > yGridOffset)){
            eventDayIndex = Math.floor((e.x - xGridOffset) / gridWidth) as Integer;

            if (e.clickCount == 2){
                addEvent();
            }else {
                if (e.popupTrigger){
                    popupMenu.show(e);
                }
                weekGrid.selectedDayIndex = eventDayIndex;
            }
       }
    }

    function addEvent(){
        var yGrid = Math.floor((mouseEvent.y - yGridOffset) / gridHeight);
        var startHour = yGrid / 2;
        var startMin = yGrid mod 2;
        var currentDayGrid = weekGrid.dayGrids[eventDayIndex];
        var startCal = currentDayGrid.date.clone() as Calendar;
        var endCal = currentDayGrid.date.clone() as Calendar;
        startCal.set(Calendar.HOUR_OF_DAY, startHour);
        startCal.set(Calendar.MINUTE, startMin);
        endCal.set(Calendar.HOUR_OF_DAY, startHour + 1);
        endCal.set(Calendar.MINUTE, startMin);
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

//    package function placeNode(node:Node, x:Number, y:Number){
//        if (Sequences.indexOf(content, node) == -1){
//            insert node into content;
//        }
//        var xOffset = Math.floor(x / gridWidth) * gridWidth;
//        var yOffset = Math.floor(y / gridHeight) * gridHeight;
//        positionNode(node, xOffset, yOffset);
//    }
}
