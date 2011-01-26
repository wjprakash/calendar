/*
 * ClickOverlay.fx
 *
 * Created on Dec 09, 2009, 2:44:57 PM
 */
package com.jfxtools.calendar.controls;

import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.effect.DropShadow;
import javafx.scene.effect.Effect;

public class ClickOverlay extends Rectangle {
        
    public-init var target:Node;
    public-init var action:function();
    public-init var padding = 0.0;
    override var x = bind target.boundsInParent.minX - padding;
    override var y = bind target.boundsInParent.minY - padding;
    override var width = bind target.boundsInParent.width + padding*2;
    override var height = bind target.boundsInParent.height + padding*2;
    override var fill = Color.TRANSPARENT;
    public-init var shadowRadius = 5;
    public-init var shadowSpread = .5;

    var defaultEffect:Effect;

    init {
        target.onMouseEntered = function(e) {
           defaultEffect = target.effect;
           target.effect =  DropShadow {
                color: Color.BROWN
                spread: shadowSpread
                radius: shadowRadius
            }
        }
        target.onMouseExited = function(e) {
           target.effect = defaultEffect;
        }

        target.onMouseReleased = function(e) {
           action();
        }
    }
}
