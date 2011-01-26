/*
 * CreateEventPopup.fx
 *
 * Created on Jan 17, 2010, 6:19:32 PM
 */

package com.jfxtools.calendar.event;

import javafx.scene.Node;
import javafx.scene.Group;
import javafx.geometry.HPos;
import javafx.scene.control.Label;
import com.jfxtools.calendar.Constants;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.stage.Stage;
import com.jfxtools.calendar.AppContext;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import com.jfxtools.calendar.controls.ActionButton;
import com.jfxtools.calendar.controls.CustomTextBox;
import com.jfxtools.calendar.dialogs.AbstractDialog;
import javafx.scene.control.CheckBox;
import javafx.geometry.VPos;
import com.jfxtools.calendar.event.model.CalendarEvent;
import java.util.GregorianCalendar;
import java.util.Calendar;

/**
 * @author winstonp
 */

public class CreateEventDialog extends AbstractDialog{

     override public var width = 400;
     override public var height = 200;

     public var modify = false;

     public-init var callbackFunction:function ():  Void;
     public-read var cancelled: Boolean;

     public-init var event: CalendarEvent;

     def controlHeight = 15;

     var defaultButton: ActionButton;
     
     var whatLabel = Label {
        text: "What:"
        layoutInfo: LayoutInfo {height: controlHeight }
        textFill: Constants.textColor
        font: Constants.fontRegularLarge
     }

     var whenLabel = Label {
        text: "When:"
        layoutInfo: LayoutInfo {height: controlHeight }
        textFill: Constants.textColor
        font: Constants.fontRegularLarge
     }

     var repeatsLabel = Label {
        text: "Repeat:"
        layoutInfo: LayoutInfo {height: controlHeight }
        textFill: Constants.textColor
        font: Constants.fontRegularLarge
     }

     var whereLabel = Label {
        text: "Where:"
        layoutInfo: LayoutInfo {height: controlHeight }
        textFill: Constants.textColor
        font: Constants.fontRegularLarge
     }

     var celendarLabel = Label {
        text: "Calendar:"
        layoutInfo: LayoutInfo {height: controlHeight }
        textFill: Constants.textColor
        font: Constants.fontRegularLarge
     }

     var labelsBox = VBox {
            spacing: 8
            nodeHPos: HPos.RIGHT
            hpos: HPos.CENTER
            content: [
               whatLabel,
               whenLabel,
               repeatsLabel,
               whereLabel,
               celendarLabel
            ]
        }

     var whatField: CustomTextBox = CustomTextBox {
            layoutInfo: LayoutInfo {height: controlHeight width: 300 }
            selectOnFocus: true
            onEscKey: function () {
                hide();
                }
            //onEnterKey: bind defaultButton.action
        }

     var fromHourField: CustomTextBox = CustomTextBox {
            layoutInfo: LayoutInfo {height: controlHeight, width:30}
            selectOnFocus: true
            height: controlHeight
            onEscKey: function () {
                hide();
                }
            //onEnterKey: bind defaultButton.action
        }
        
     var fromSeparatotLabel = Label {
        text: ":"
        layoutInfo: LayoutInfo {height: controlHeight}
        textFill: Constants.textColor
        font: Constants.fontRegularLarge
     }

     var fromMinuteField: CustomTextBox = CustomTextBox {
        layoutInfo: LayoutInfo {height: controlHeight, width:30}
        selectOnFocus: true
        height: controlHeight
        onEscKey: function () {
            hide();
            }
        //onEnterKey: bind defaultButton.action
     }

     var fromBox = HBox {
        spacing: 1
        hpos: HPos.CENTER
        content: [
           fromHourField,
           fromSeparatotLabel,
           fromMinuteField,
        ]
     }

     var toLabel = Label {
        text: "to"
        layoutInfo: LayoutInfo {height: controlHeight }
        textFill: Constants.textColor
        font: Constants.fontRegularLarge
     }

     var toHourField: CustomTextBox = CustomTextBox {
        layoutInfo: LayoutInfo {height: controlHeight, width:30}
        selectOnFocus: true
        height: controlHeight
        onEscKey: function () {
            hide();
        }
        //onEnterKey: bind defaultButton.action
     }

     var toSeparatotLabel = Label {
        text: ":"
        layoutInfo: LayoutInfo {height: controlHeight}
        textFill: Constants.textColor
        font: Constants.fontRegularLarge
     }

     var toMinuteField: CustomTextBox = CustomTextBox {
        layoutInfo: LayoutInfo {height: controlHeight, width:30}
        selectOnFocus: true
        height: controlHeight
        onEscKey: function () {
            hide();
        }
        //onEnterKey: bind defaultButton.action
     }

     var toBox = HBox {
        spacing: 1
        hpos: HPos.CENTER
        content: [
           toHourField,
           toSeparatotLabel,
           toMinuteField
        ]
     }

     var allDayCheckBox = CheckBox {
            text: "All Day Event"
            allowTriState: false
            selected: false
            translateX: 10
            vpos: VPos.CENTER
     }

     var whenBox = HBox {
        spacing: 8
        hpos: HPos.CENTER
        content: [
           fromBox,
           toLabel,
           toBox,
           allDayCheckBox
        ]
     }

     var repeatChoice: CustomTextBox = CustomTextBox {
         layoutInfo: LayoutInfo {height: controlHeight}
         selectOnFocus: true
         onEscKey: function () {
            hide();
         }
         //onEnterKey: bind defaultButton.action
     }

     var whereField: CustomTextBox = CustomTextBox {
         text: "Local"
         layoutInfo: LayoutInfo {height: controlHeight width: 300}
         selectOnFocus: true
         onEscKey: function () {
            hide();
         }
         //onEnterKey: bind defaultButton.action
     }

     var calendarChoice: CustomTextBox = CustomTextBox {
         layoutInfo: LayoutInfo {height: controlHeight }
         selectOnFocus: true
         onEscKey: function () {
            hide();
         }
         //onEnterKey: bind defaultButton.action
     }

     var fieldsBox = VBox {
            spacing: 8
            nodeHPos: HPos.LEFT
            hpos: HPos.CENTER
            content: [
               whatField,
               whenBox,
               repeatChoice,
               whereField,
               calendarChoice
            ]
        }

     var mainBox = HBox {
            spacing: 8
            hpos: HPos.CENTER
            content: [
               labelsBox,
               fieldsBox
            ]
        }

     var cancelButton = ActionButton {
            text: "Cancel"
            width: 60
            height: Constants.buttonHeight
            font: Constants.fontBoldMedium
            action: function () {
                cancelled = true;
                showBusyCursor(false);
                hide();
                callbackFunction();
            }
            onEnterKey: bind defaultButton.action
        }


      var createEventButton = ActionButton {
            text: if (modify) "Modify" else "Create"
            width: 60
            height: Constants.buttonHeight
            font: Constants.fontBoldMedium
            default: true
            action: createEvent
            onEnterKey: createEvent
        }

     var buttonBox = HBox {
            layoutX: width - 160
            layoutY: height - 80
            spacing: 8
            hpos: HPos.CENTER
            content: [
               cancelButton,
               createEventButton
            ]
        }

     var content = Group{
           layoutX: 20
           layoutY: 20
           content: [
              mainBox,
              buttonBox
           ]
         }

     override function createContent():Node {
         if (modify) {
            title = "Modify Event";
         }else{
           title = "Create Event";
         }

         return content;
     }

     init{
         if (event != null){
            whatField.text = event.summary;
            fromHourField.text = event.startHour.toString();
            fromMinuteField.text = event.startMinute.toString();
            toHourField.text = event.endHour.toString();
            toMinuteField.text = event.endMinute.toString();
         }
     }

     function createEvent():Void{
         whatField.commit();
         fromHourField.commit();
         fromMinuteField.commit();
         toHourField.commit();
         toMinuteField.commit();
         event.summary = whatField.text;
         var fromHour = Integer.parseInt(fromHourField.text);
         var fromMinute = Integer.parseInt(fromMinuteField.text);
         var toHour = Integer.parseInt(toHourField.text);
         var toMinute = Integer.parseInt(toMinuteField.text);
         event.start.set(Calendar.HOUR_OF_DAY, fromHour);
         event.start.set(Calendar.MINUTE, fromMinute);
         event.end.set(Calendar.HOUR_OF_DAY, toHour);
         event.end.set(Calendar.MINUTE, toMinute);
         cancelled = false;
         showBusyCursor(false);
         hide();
         callbackFunction();
     }

}

public function run() {
    var width = 450;
    var height = 250;

    var stage: Stage = Stage {
                title: "Connection Creation Dialog"
                width: width
                height: height
                scene: Scene {
                    content: Rectangle{
                        width: width
                        height: height
                        fill: Color.AZURE
                    }
                }
            }

    var appContext: AppContext = AppContext {
                width: width
                height: height
                stage: stage
            };

    var startCal = new GregorianCalendar();;
    var endCal = new GregorianCalendar();;
    startCal.set(Calendar.HOUR_OF_DAY, 8);
    startCal.set(Calendar.MINUTE, 30);
    endCal.set(Calendar.HOUR_OF_DAY, 9);
    endCal.set(Calendar.MINUTE, 15);
    var event = CalendarEvent {
        start: startCal
        end: endCal
        summary: "New event"
    }

    var createEventDialog = CreateEventDialog {
                appContext: appContext
                event: event
//                callbackFunction: function () {
//                    FX.exit();
//                }
            };
    createEventDialog.show();
}
