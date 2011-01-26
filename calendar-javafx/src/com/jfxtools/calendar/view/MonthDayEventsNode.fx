/*
 * MultiEventsNode.fx
 *
 * Created on Jan 15, 2010, 6:26:57 PM
 */
package com.jfxtools.calendar.view;

import javafx.scene.Group;
import javafx.scene.layout.Panel;
import javafx.scene.layout.Flow;
import javafx.geometry.HPos;
import javafx.scene.layout.LayoutInfo;
import com.jfxtools.calendar.event.model.CalendarEvent;
import com.jfxtools.calendar.AppContext;
import javafx.scene.control.Label;
import javafx.scene.paint.Color;

/**
 * Node that displays multiple Calendar Events
 * @author winstonp
 */
public class MonthDayEventsNode extends Panel {

    public var appContext: AppContext;

    public override var width on replace {
        refreshEventNodes();
    }
    public override var height on replace {
        refreshEventNodes();
    }

    public var events: CalendarEvent[] on replace {
        refreshEventNodes();
    }

    postinit{
       refreshEventNodes();
    }
    
    function refreshEventNodes() {
         if ((events != null) and (events.size() > 0) and (width > 10) and (height > 10)) {

             content = Flow {
                vertical: true
                height: height
                width: width
                hgap: 2
                vgap: 2
                nodeHPos: HPos.LEFT
                content: for (event in events) {
                    EventNode {
                        appContext: appContext
                        event: event
                        height: 15
                        width: width
                        layoutInfo: LayoutInfo {height: 15 width: width}
                    }
                }
            }
         }else{
             content = null;
         }
    }
}

class EventNode extends SingleEventNode {

    protected var summaryLabel1 = Label {
            text: bind event.summary
            textFill: bind if (selected) Color.WHITE else Color.DARKBLUE
    };

    protected override function createContent(){
        content = Group {
            content: [
                eventBackground,
                eventBorder,
                summaryLabel1
            ]
        }
    }
}

