/*
 * MonthMiniView.fx
 *
 * Created on Nov 16, 2009, 7:21:07 PM
 */
package com.jfxtools.calendar.view;

import javafx.scene.Group;
import javafx.scene.paint.Color;
import javafx.scene.shape.Line;
import javafx.scene.shape.Rectangle;


import javafx.scene.Node;

import javafx.scene.control.Label;

import javafx.geometry.HPos;
import javafx.geometry.VPos;
import com.jfxtools.calendar.Constants;

import com.jfxtools.calendar.model.CalendarModel;
import com.jfxtools.calendar.controls.ArrowButton;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.CustomNode;
import javafx.scene.input.MouseEvent;
import javafx.util.Math;
import com.jfxtools.calendar.AppContext;

/**
 * Month Mini View of the Calendar
 * @author Winston Prakash
 */
public class MonthMiniView extends CustomNode {

    public var appContext: AppContext;
    var width = 225;
    var height = 210;
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


    var monthGrid =  bind calendarModel.monthGrid;

    var xGridOffset = 0.;
    var yGridOffset = 50.;
    var xGridSize: Integer = 7;
    var yGridSize: Integer = bind monthGrid.size / xGridSize;
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

    var monthDayLabels: Label[];

    var verticalLines: Line[];

    var horizontalLines: Line[];

    var weekDayLabels: Label[];
    
    var monthLabel: Label = Label {
                hpos: HPos.CENTER
                vpos: VPos.CENTER
                layoutInfo: LayoutInfo {
                    width: 150
                    height: 20
                }
                text: bind monthLabelText
                font: Constants.fontBoldExtraLarge
            }
    var leftNavButton = ArrowButton {
                direction: ArrowButton.LEFT
                width: 15
                height: 15
                action: function () {
                    calendarModel.prevMonth();
                }
            }
    var rightNavButton = ArrowButton {
                direction: ArrowButton.RIGHT
                width: 15
                height: 15
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
                ]
            }
    public-init var calendarModel: CalendarModel;

    postinit {
        blocksMouse = true;
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
         }
    }

    override protected function create(): Node {
        return grid;
    }

    override public var onMousePressed = function(e:MouseEvent):Void {
        var xGrid = Math.floor((e.x - xGridOffset) / gridWidth);
        var yGrid = Math.floor((e.y - yGridOffset) / gridHeight);
        monthGrid.selectedDayIndex = (yGrid * 7 + xGrid) as Integer;
    }

//
//    override public var onMouseDragged = function(e:MouseEvent):Void {
//        dragLine.ex = e.x;
//        dragLine.ey = e.y;
//        dragLine.visible = true;
//    }
}
