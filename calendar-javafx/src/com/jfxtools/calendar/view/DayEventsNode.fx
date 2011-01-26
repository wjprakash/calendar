/*
 * MultiEventsNode.fx
 *
 * Created on Jan 15, 2010, 6:26:57 PM
 */
package com.jfxtools.calendar.view;

import javafx.scene.Group;
import javafx.scene.layout.Panel;
import com.jfxtools.calendar.event.model.CalendarEvent;
import com.jfxtools.calendar.event.model.EventModelHelper;
import com.jfxtools.calendar.AppContext;

/**
 * Node that displays multiple Calendar Events
 * @author winstonp
 */
public class DayEventsNode extends Panel {

    public var appContext: AppContext;

    public override var width on replace {
        refreshEventNodes();
    }
    public override var height on replace {
        refreshEventNodes();
    }
    public var gridHeight on replace {
        refreshEventNodes();
    }
    
    public var events: CalendarEvent[] on replace {
        refreshEventNodes();
    }

    postinit{
       refreshEventNodes();
    }
    
    function refreshEventNodes() {
        //println("Refreshing 1 ");

        if ((events != null) and (width > 10) and (gridHeight > 5)) {
            //println("Refreshing 2 ");
            // To avoid unnecessary refresh
            var tmpContent = for (event in events) {
                SingleEventNode {
                    event: event
                    appContext: appContext
                    width: bind width;
                    height: bind EventModelHelper.getEventDuration(event) * gridHeight * 2;
                    layoutY: bind EventModelHelper.getTime(event.start) * gridHeight * 2
                }
            }
            content = tmpContent;
        }else{
            content = null;
        }

    }
}


