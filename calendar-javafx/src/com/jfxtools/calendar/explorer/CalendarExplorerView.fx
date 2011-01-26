/*
 * CalendarExplorerView.fx
 *
 * Created on Dec 09, 2009, 2:26:01 PM
 */
package com.jfxtools.calendar.explorer;

import javafx.scene.Group;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.Panel;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

import com.jfxtools.calendar.AppContext;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.effect.InnerShadow;
import javafx.scene.control.Label;
import com.jfxtools.calendar.Constants;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import com.jfxtools.calendar.controls.Tree;
import com.jfxtools.calendar.controls.TreeNode;

/**
 * Calendar Explorer View
 * @author winstonp
 */
public class CalendarExplorerView extends Panel {

    public-init
        var appContext: AppContext    ;

        var background     = Rectangle {
                    width:

        bind width
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
    var header: Rectangle = Rectangle {
                width: bind width,
                height: 30
                stroke: null
                arcWidth: 10
                arcHeight: 10
                fill: LinearGradient {
                    startX: 0.0
                    startY: 0.0
                    endX: 0
                    endY: 1.0
                    stops: [
                        Stop {
                            color: Color.web("#993333")
                            offset: 0.0
                        },
                        Stop {
                            color: Color.web("#AD593A")
                            offset: 0.6
                        },
                        Stop {
                            color: Color.web("#993333")
                            offset: 1.0
                        }
                    ]
                }
            }
    var headerClip: Rectangle = Rectangle {
                width: bind width,
                height: 25,
                layoutY: 25
                stroke: null
                fill: Color.WHITESMOKE
                effect: InnerShadow {
                    //choke: 0.5
                    //offsetX: 1
                    offsetY: 1
                    radius: 1
                    color: Color.web("#35556a")
                }
            }
    var title = Label {
                layoutY: 5
                width: bind width,
                //height: 60
                text: "My Calendars"
                //vpos: VPos.CENTER
                hpos: HPos.CENTER
                font: Constants.fontBoldExtraLarge
                textFill: Color.WHITE
            }
    var tree = Tree {
                layoutX: 10
                layoutY: 30
                rootNode: TreeNode {
                    data: "Local"
                    expanded: true
                    children: [
                        TreeNode {
                            data: "Home"
                        }
                        TreeNode {
                            data: "Work"
                        }
                    ]
                }
            }

    postinit {
        content = [
            background,
            header,
            headerClip,
            title,
            tree
        ]
    }
}

public function run()   {

    var scene: Scene = Scene {
                width: 200
                height: 300
                content: [
                    CalendarExplorerView {
                        layoutX: 10
                        layoutY: 10
                        width: bind scene.width - 20
                        height: bind scene.height - 20
                    }
                ];
                fill: Color.rgb(105, 4, 0, 1.0)
            };

    var stage: Stage = Stage {
                width: 200
                height: 300
                title: "Calendar Explorer View"
                scene: scene
            }
}

