/*
 * TreeNodeSkin.fx
 *
 * Created on Feb 3, 2010, 5:48:19 PM
 */
package com.jfxtools.calendar.controls;

import javafx.scene.control.Label;
import javafx.scene.control.Skin;
import javafx.scene.Node;
import javafx.scene.layout.HBox;
import javafx.geometry.VPos;
import javafx.scene.layout.VBox;
import javafx.scene.Group;
import javafx.scene.layout.Container;

/**
 * Skin for the tree node
 * @author winstonp
 */
public class TreeNodeSkin extends Skin {

    var treeNode = bind control as TreeNode on replace {
        nodeArrow.expanded = treeNode.expanded;
    }

    def nodeArrow: NodeArrow = NodeArrow {
                width: 8
                height: 8
                action: function () {
                    treeNode.expanded = nodeArrow.expanded;
                }
            }
    var defaultRenderer = NodeRenderer {
                override public function createNode(data: Object): Node {
                    return Label {
                                text: data.toString()
                            }
                }
            }
    var renderedNode: Node = bind if (treeNode.renderer != null)
                treeNode.renderer.createNode(treeNode.data) else
                defaultRenderer.createNode(treeNode.data);
    var childrenBox = VBox {
                content: bind treeNode.children
                override function doLayout(): Void {
                    def x: Number = 25;
                    var y: Number = 0;

                    for (node in getManaged(content)) {
                        positionNode(node, x, y);
                        y += getNodePrefHeight(node);
                    }
                }
            }
    var contentBox = HBox {
                spacing: 5
                nodeVPos: VPos.CENTER
                content: bind [
                    if (not treeNode.leaf) nodeArrow else null,
                    renderedNode
                ]
            }
    var mainBox = VBox {
                spacing: 5
                content: bind [
                    contentBox,
                    if (treeNode.expanded) childrenBox else null
                ]
            }

    postinit {
        node = mainBox;
    }

    override function contains(localX: Number, localY: Number): Boolean {
        return node.contains(localX, localY);
    }

    override function intersects(localX: Number, localY: Number, localWidth: Number, localHeight: Number): Boolean {
        return node.intersects(localX, localY, localWidth, localHeight);
    }

    override function getPrefHeight(height) {
        var prefH: Number = 20;
        if (treeNode.expanded) {
            for (node in treeNode.children) {
                prefH += node.getPrefHeight(-1);
            }
        }
        return prefH;
    }
}
