/*
 * TreeSkin.fx
 *
 * Created on Feb 3, 2010, 4:47:12 PM
 */
package com.jfxtools.calendar.controls;

import javafx.scene.control.Skin;
import javafx.scene.Group;

/**
 * Skin for the Tree
 * @author winstonp
 */
public class TreeSkin extends Skin {

    var tree = bind control as Tree;
    var contentGroup = Group {
                content: bind tree.rootNode
            }

    override function contains(localX: Number, localY: Number): Boolean {
        return node.contains(localX, localY);
    }

    override function intersects(localX: Number, localY: Number, localWidth: Number, localHeight: Number): Boolean {
        return node.intersects(localX, localY, localWidth, localHeight);
    }

    postinit {
        node = contentGroup;
    }
}
