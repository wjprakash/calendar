/*
 * DayView.fx
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

import javafx.scene.control.Label;

import javafx.geometry.HPos;
import javafx.geometry.VPos;
import com.jfxtools.calendar.Constants;

import com.jfxtools.calendar.model.CalendarModel;
import com.jfxtools.calendar.controls.ArrowButton;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.input.MouseEvent;
import javafx.util.Math;
import java.util.Calendar;
import com.jfxtools.calendar.event.model.CalendarEvent;
import com.jfxtools.calendar.event.CreateEventDialog;
import com.jfxtools.calendar.AppContext;
import com.jfxtools.calendar.controls.PopupMenu;
import com.jfxtools.calendar.controls.PopupMenuItem;

/**
 * Day View of the Calendar
 * @author Winston Prakash
 */
public class DayView extends Panel {

    public var appContext: AppContext;

    var dayGrid = bind calendarModel.selectedDayGrid;

    var hourText: String[] = ["1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "Noon",
                "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"];
    var xGridOffset = 50.;
    var yGridOffset = 50.;
    var xGridSize: Integer = 1;
    var yGridSize: Integer = 48;
    var background = Rectangle {
                width: bind width, height: bind height
                fill: Color.BLANCHEDALMOND;
                stroke: Color.GRAY
                strokeWidth: 0.4
            }
    public var gridWidth: Number = bind (width - xGridOffset) / xGridSize;

    public var gridHeight: Number = bind (height - yGridOffset) / yGridSize;

    var headerLine = bind Line {
                startY: yGridOffset, startX: background.boundsInParent.minX
                endY: yGridOffset, endX: background.boundsInParent.maxX
                strokeWidth: 0.4
                stroke: Color.GRAY
            }
    var verticalLines: Line[] = bind for (i in [0..xGridSize - 1]) {
                Line {
                    startX: i * gridWidth + xGridOffset, startY: background.boundsInParent.minY + yGridOffset
                    endX: i * gridWidth + xGridOffset, endY: background.boundsInParent.maxY
                    strokeWidth: 0.4
                    stroke: Color.GRAY
                }
            }
    var horizontalLines: Line[] = bind for (i in [0..yGridSize - 1]) {
                Line {
                    startY: i * gridHeight + yGridOffset, startX: background.boundsInParent.minX + xGridOffset
                    endY: i * gridHeight + yGridOffset, endX: background.boundsInParent.maxX
                    strokeWidth: 0.2 + ((i + 1) mod 2) * .2
                    stroke: Color.GRAY
                }
            }
    var dayLabel: Label = Label {
                layoutInfo: LayoutInfo {
                    width: 175
                    height: 20
                }
                hpos: HPos.CENTER
                vpos: VPos.CENTER
                text: bind dayGrid.title
                font: Constants.fontBoldExtraLarge3
            }
    var leftNavButton = ArrowButton {
                direction: ArrowButton.LEFT
                width: 20
                height: 20
                action: function () {
                    calendarModel.prevDay();
                }
            }
    var rightNavButton = ArrowButton {
                direction: ArrowButton.RIGHT
                width: 20
                height: 20
                action: function () {
                    calendarModel.nextDay();
                }
            }
    var header = HBox {
                layoutY: 10
                layoutX: bind (width - 250) / 2
                width: 250
                height: yGridOffset - 20
                spacing: 3
                content: [leftNavButton, dayLabel, rightNavButton]
            }
    var hourLabels: Label[] = bind for (i in [0..yGridSize / 2 - 1]) {
                Label {
                    layoutX: 0
                    layoutY: yGridOffset + (gridHeight * ((i + 1) * 2)) - 15
                    width: xGridOffset - 5
                    height: 20
                    hpos: HPos.RIGHT
                    vpos: VPos.BOTTOM
                    text: hourText[i]
                    font: Constants.fontRegular
                    textFill: Color.GRAY
                }
            }

    var eventNodes = DayEventsNode{
           events: bind dayGrid.events
           appContext: appContext
           width: bind background.boundsInParent.maxX - xGridOffset - 10;
           gridHeight: bind gridHeight
           layoutX: xGridOffset + 5;
           layoutY: yGridOffset;
    }

    var grid = Group {
                content: bind [
                    background,
                    header,
                    headerLine,
                    verticalLines,
                    horizontalLines,
                    hourLabels,
                    eventNodes
                ]
            }
    public-init var calendarModel: CalendarModel;

    postinit {
        blocksMouse = true;
        content = [grid];
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
             if (e.clickCount == 2){
                addEvent();
            }else {
                if (e.popupTrigger){
                    popupMenu.show(e);
                }
            }
        }
    }

    function addEvent(){
        var yGrid = Math.floor((mouseEvent.y - yGridOffset) / gridHeight);
        var startHour = yGrid / 2;
        var startMin = yGrid mod 2;
        var startCal = dayGrid.date.clone() as Calendar;
        var endCal = dayGrid.date.clone() as Calendar;
        startCal.set(Calendar.HOUR_OF_DAY, startHour);
        startCal.set(Calendar.MINUTE, startMin);
        endCal.set(Calendar.HOUR_OF_DAY, startHour + 1);
        endCal.set(Calendar.MINUTE, startMin);
        var event = CalendarEvent {
            start: startCal
            end: endCal
            summary: "New event"
        }

        dayGrid.addEvent(event);
        var createEventDialog:CreateEventDialog = CreateEventDialog {
            appContext: appContext
            event: event
            callbackFunction: function () {
               if (createEventDialog.cancelled){
                    dayGrid.removeEvent(event);
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
}