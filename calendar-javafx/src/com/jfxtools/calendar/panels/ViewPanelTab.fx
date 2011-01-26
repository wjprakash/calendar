/*
 * ViewPanelTab.fx
 *
 * Created on Dec 09, 2009, 7:32:33 PM
 */
package com.jfxtools.calendar.panels;

import javafx.scene.Group;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.Node;
import javafx.scene.effect.DropShadow;
import javafx.scene.layout.Panel;

import com.jfxtools.calendar.AppContext;

/**
 * A Tab class for the view Panel
 * @author Winston Prakash
 */
public class ViewPanelTab extends Panel {

    public var index: Integer = 0;
    public var appContext: AppContext;
    public-init var panelContent: Panel;
    public override var width = bind viewPanel.width on replace {
                panelContent.width = width;
            }
    public override var height = bind viewPanel.height on replace {
                panelContent.height = height - offset;
            }
    public-init var viewPanel: ViewPanel;

    var offset = 30;

    postinit {
        offset =  ViewPanel.TAB_SELECTION_HEIGHT + 5;
        var background: Rectangle = Rectangle {
                    width: bind width,
                    height: bind height - offset;
                    arcWidth: 12
                    arcHeight: 12
                    effect: DropShadow {
                        offsetY: 2
                        offsetX: 2
                        spread: .2
                        color: Color.color(0., 0., 0., .5)
                    }
                    onMousePressed: function (e) {
                        background.requestFocus();
                    }
                    fill: Color.web("#eeeeee")
                }

        blocksMouse = true;

        content = Group {
            layoutX: 0
            layoutY: offset
            content: [
                background,
                panelContent
            ]
        };

        panelContent.width = viewPanel.width;
        panelContent.height = viewPanel.height - offset;
    }
}
