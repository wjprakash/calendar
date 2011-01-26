/*
 * CustomTextBox.fx
 *
 * Created on Jan 17, 2010, 6:19:32 PM
 */

package com.jfxtools.calendar.controls;

import javafx.scene.control.TextBox;

import com.sun.javafx.scene.control.caspian.TextBoxSkin;

import javafx.scene.Scene;
import javafx.stage.Stage;

import javafx.scene.input.KeyCode;
import com.jfxtools.calendar.Constants;

/**
 * Simple extension of TextBox to customize it
 * @author Winston Prakash
 */

public class CustomTextBox extends TextBox{
        
    public var onEscKey:function();
    public var onEnterKey:function();

    public override var font = Constants.fontRegularMedium;

    public var enabled:Boolean = true on replace{
        if (not enabled){
            editable = false;
            disable = true;
        }else{
            editable = true;
            disable = false;
        }
    }


    public override var onKeyPressed = function(e) {
        if(e.code == KeyCode.VK_ESCAPE) {
            onEscKey();
        }else if(e.code == KeyCode.VK_ENTER) {
            onEnterKey();
        }
    }

    public override var skin = bind if (enabled) TextBoxSkin {
         textFill: Constants.textColor
         highlightFill: Constants.keyboardFocusColor
         borderFill: Constants.lineColor
         shadowFill: Constants.lineColor
         accent: Constants.keyboardFocusColor
         borderWidth: 0

    } else TextBoxSkin {
         textFill: Constants.disabledTextColor
         highlightFill: null
         borderFill: Constants.disabledLineColor
         shadowFill: Constants.disabledLineColor
         accent: Constants.disabledLineColor
         borderWidth: 0
    }

    public override var font = Constants.fontRegularExtraLarge;
}

function run() {
    Stage {
        scene: Scene {
            width: 400 height: 300
            content: [
                    CustomTextBox {
                        width: 200
                        layoutX: 10;
                        layoutY: 20;
                    }

                    CustomTextBox {
                        width: 200
                        layoutX: 10;
                        layoutY: 50;
                    }
            ]
        }

    }
}
