/*
 * CalendarExplorerView.fx
 *
 * Created on Dec 09, 2009, 2:26:01 PM
 */
package com.jfxtools.calendar.view;

import javafx.scene.Group;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.Panel;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

import com.jfxtools.calendar.AppContext;




import javafx.scene.effect.DropShadow;
import com.jfxtools.calendar.model.CalendarModel;
import java.util.Calendar;
import java.util.GregorianCalendar;

/**
 * Calendar Picker View
 * @author winstonp
 */
public class CalendarPickerView extends Panel {

    public
        var calendarModel

        : CalendarModel    ;



    public-init var appContext: AppContext;
    var background = Rectangle {
                width: bind width
                height: bind height
                fill: Color.WHITESMOKE//Color {red: 0.941, green: 0.906, blue: 0.843}

                //        effect: Lighting {
                //            light: DistantLight {azimuth: -135, elevation: 75}
                //            surfaceScale: 3
                //            bumpInput: GaussianBlur {radius: 5}
                //        }
                arcHeight: 12
                arcWidth: 12
            }
    var calBackground = Rectangle {
                layoutX: bind (width - 235) / 2
                layoutY: bind (height - 220) / 2
                width: 235
                height: 220
                fill: Color.BURLYWOOD
                arcHeight: 6
                arcWidth: 6
                stroke: Color.GRAY
                strokeWidth: .4
            }

    postinit {
        var calendarPicker = MonthMiniView {
                    layoutX: bind (width - 225) / 2
                    layoutY: bind (height - 210) / 2
                    effect: DropShadow {
                        color: Color.BLACK
                        radius: 10
                    }
                    calendarModel: calendarModel
                };
        content = [
            background,
            calBackground,
            calendarPicker
        ]
    }
}

public function run()  {
    var selectedDate = new GregorianCalendar();
    selectedDate.add(Calendar.DATE, 7);

    var scene: Scene = Scene {
            width: 300
            height: 300
            content: [
                CalendarPickerView {
                    layoutX: 10
                    layoutY: 10
                    width: bind scene.width - 20
                    height: bind scene.height - 20
                    calendarModel: CalendarModel {selectedDate: selectedDate};
                }
            ];
            fill: Color.rgb(105, 4, 0, 1.0)
        };

    var stage: Stage = Stage {
            width: 300
            height: 300
            title: "Month Mini View"
            scene: scene
        }
}

