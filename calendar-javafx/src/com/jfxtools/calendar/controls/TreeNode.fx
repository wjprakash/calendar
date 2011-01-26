/*
 * TreeNode.fx
 *
 * Created on Feb 3, 2010, 5:47:56 PM
 */

package com.jfxtools.calendar.controls;

import javafx.scene.control.Control;
import javafx.scene.Scene;
import javafx.stage.Stage;

/**
 * Tree Node
 * @author winstonp
 */

public class TreeNode extends Control{

    public var data:Object = "Tree Node";

    public var expanded = false;

    public var renderer:NodeRenderer;

    public var children:TreeNode[] on replace {
        if ((children != null) and (children.size() > 0)){
            leaf = false
        }else{
            leaf = true
        }
    }
    
    public var leaf = true;

    postinit {
        skin = TreeNodeSkin{};
    }
}

function run() {
    Stage {
        scene: Scene {
            width: 400 height: 300
            content: [
                 TreeNode{
                    //expanded: true
                    layoutX: 20
                    layoutY: 20
                    children: [TreeNode{}, TreeNode{}]
                 }
            ]
        }
    }
}