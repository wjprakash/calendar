/*
 * Tree.fx
 *
 * Created on Feb 3, 2010, 4:32:36 PM
 */
package com.jfxtools.calendar.controls;

import javafx.scene.control.Control;
import javafx.stage.Stage;
import javafx.scene.Scene;

/**
 * Tree control
 * @author winstonp
 */
public class Tree extends Control{

    public var rootNode:TreeNode on replace {
        println("rootNode: {rootNode}");
    }

    
    postinit {
        skin = TreeSkin{};
    }
}

function run() {
    Stage {
        scene: Scene {
            width: 400 height: 300
            content: [
                 Tree{
                    layoutX: 20
                    layoutY: 20
                    rootNode: TreeNode{
                        expanded: true
                        children: [
                            TreeNode{
                                expanded: true
                                data: "Node1"
                                children: [
                                    TreeNode{
                                        data: "Node1.1"
                                        children: [
                                            TreeNode{data: "Node1.1.1"}
                                            TreeNode{data: "Node1.1.2"}
                                        ]
                                    }
                                ]
                            }
                            TreeNode{
                                data: "Node2"
                                children: [
                                    TreeNode{data: "Node2.1"}
                                    TreeNode{data: "Node2.2"}
                                ]
                            }
                            TreeNode{
                                expanded: true
                                data: "Node3"
                                children: [
                                    TreeNode{
                                        expanded: true
                                        data: "Node3.1"
                                        children: [
                                            TreeNode{data: "Node3.1.1"}
                                            TreeNode{data: "Node3.1.2"}
                                        ]
                                    }
                                ]
                            }
                        ]
                    }
                 }
            ]
        }
    }
}