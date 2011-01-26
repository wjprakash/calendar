/*
 * ViewPanelTabSelection.fx
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
import javafx.scene.control.Label;
import javafx.geometry.VPos;
import javafx.geometry.HPos;
import com.jfxtools.calendar.Constants;
import javafx.scene.effect.Effect;
import javafx.scene.effect.InnerShadow;
import javafx.scene.Scene;
import javafx.stage.Stage;

/**
 * A Tab class for the view Panel
 * @author Winston Prakash
 */

public class ViewPanelTabSelection extends Panel{

   public var index:Integer = 0;

   public var appContext:AppContext;

   public-init var label:String = "tab";

   public-init var viewPanel:ViewPanel;

   public var font = Constants.fontBoldLarge;

   public var selected = false;

   postinit{
       width = ViewPanel.TAB_SELECTION_WIDTH;
       height = ViewPanel.TAB_SELECTION_HEIGHT;
       var background:Rectangle = Rectangle {
            width: width,
            height: height,
            arcWidth: 6
            arcHeight: 6
            effect: bind getEffect(hover, selected)
            onMousePressed: function(e) {
                viewPanel.selectedIndex = index;
                selected = true;
            }
            fill: bind getBackground(hover, pressed)
       }

       blocksMouse = true;

       var tabLabel = Label{
           text: label
           width: bind width
           height: bind height
           vpos: VPos.CENTER
           hpos: HPos.CENTER
           font: font
       }

       content = [
            background,
            tabLabel
       ];
   }

   function getEffect(hover:Boolean, selected:Boolean):Effect {
       if (selected){
           return  InnerShadow {
                choke: 0.01
                radius: 15
                color: Color.BROWN
           }
       }

       if (hover){
           return  InnerShadow {
                choke: 0.5
                radius: 10
                color: Color.WHEAT
           }

       }else{
           return DropShadow {
                offsetY: 2
                offsetX: 2
                spread: .2
                color: Color.color(0., 0., 0., .5)
            }
       }
   }


   function getBackground(hover:Boolean, pressed:Boolean):Color{
        if (selected){
            return Color.web("#eeeeee")
        }

        if (pressed){
            Color.web("#659bc4")
        }else{
            Color.web("#eeeeee")
        }
    }
}

public function run() {



    var scene:Scene = Scene {
        content: ViewPanelTabSelection{
            layoutX: 20
            layoutY: 20
            label: "Test"
            selected: true
        }
    }

    Stage {
        width: 300
        height: 300
        title: "Calendar Viewer"
        scene: scene
    }
}
