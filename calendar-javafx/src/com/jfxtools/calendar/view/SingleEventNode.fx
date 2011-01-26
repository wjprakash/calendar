/*
 * DayEventNode.fx
 *
 * Created on Jan 15, 2010, 6:26:57 PM
 */
package com.jfxtools.calendar.view;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import java.text.SimpleDateFormat;
import com.jfxtools.calendar.event.model.CalendarEvent;
import com.jfxtools.calendar.controls.PopupMenu;
import com.jfxtools.calendar.controls.PopupMenuItem;
import com.jfxtools.calendar.AppContext;
import com.jfxtools.calendar.event.CreateEventDialog;

/**
 * Node display a single Calendar Event
 * @author winstonp
 */
public class SingleEventNode extends CustomNode {

    public var appContext: AppContext;

    var selectedEventNode = bind appContext.selectedEventNode on replace{
        if (selectedEventNode == this){
            selected = true;
        }else{
            selected = false
        }
    }

    protected var selected = false;

    var simpleDateFormat = SimpleDateFormat.getDateInstance() as SimpleDateFormat;
    public var event: CalendarEvent;

    public var width: Number;

    public var height: Number;
    
    var time:String;
    var timeLabel = Label {
            text: bind time
            textFill: bind if (selected) Color.WHITE else Color.DARKBLUE
    };

    protected var summaryLabel = Label {
            text: bind event.summary
            textFill: bind if (selected) Color.WHITE else Color.DARKBLUE
    };

    protected var popupMenu = PopupMenu {
        appContext: appContext
        menuItems: [
            PopupMenuItem {
                text: "Modify"
                action: function(){
                    var createEventDialog:CreateEventDialog = CreateEventDialog {
                        modify: true
                        appContext: appContext
                        event: event
                    };
                    createEventDialog.show();
                }
            },
            PopupMenuItem {
                text: "Delete"
                action: function(){
                    event.model.removeEvent(event);
                }
            }
        ]
    };
    
    var vbox = VBox {
        layoutX: 3
        //layoutY: 3
        content: [
            timeLabel,
            summaryLabel
        ]
    };

    protected var eventBackground = Rectangle {
        width: bind width,
        height: bind height
        fill: bind if (selected) Color.web("#1d7cbd") else Color.BLUE
        opacity: bind if (selected) .8 else .2
        arcWidth: 9
        arcHeight: 9
        strokeWidth: 1
        stroke: Color.BLUE
        onMousePressed: function(e) {
            if (e.popupTrigger){
                popupMenu.show(e);
            }else{
                if (e.clickCount == 2){
                    var createEventDialog:CreateEventDialog = CreateEventDialog {
                        modify: true
                        appContext: appContext
                        event: event
                    };
                    createEventDialog.show();
                }
            }
            appContext.selectedEventNode = this;
        }
    };

    protected var eventBorder = Rectangle {
        width: bind width,
        height: bind height
        fill: Color.TRANSPARENT
        arcWidth: 9
        arcHeight: 9
        strokeWidth: 1
        stroke: Color.BLUE
    };

    protected var content:Node;

    override protected function create(): Node {
        createContent();
        return content;
    }

    protected function createContent(){
        content = Group {
            content: [
                eventBackground,
                eventBorder,
                vbox
            ]
        }
    }


    init{
        simpleDateFormat.applyPattern("hh:mm");
        time = simpleDateFormat.format(event.start.getTime());
    }
    postinit{
        blocksMouse = true;
    }
}
