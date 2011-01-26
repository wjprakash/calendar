/*
 * MainPanel.fx
 *
 * Created on Dec 09, 2009, 10:46:19 PM
 */
package com.jfxtools.calendar.panels;

import javafx.scene.layout.Panel;


import com.jfxtools.calendar.AppContext;
import com.jfxtools.calendar.panels.ViewPanelTab;
import javafx.scene.layout.HBox;

/**
 * The main panel of the calendar tool
 * @author Winston Prakash
 */
public def  TAB_SELECTION_WIDTH = 75;
public def  TAB_SELECTION_HEIGHT = 20;

public class ViewPanel extends Panel {

    package var selectedIndex: Integer = 0 on replace oldValue{
        if (selectedIndex <= tabsCount){
            tabSelectionList[oldValue].selected = false;
            tabSelectionList[selectedIndex].selected = true;
        }
    }
    var tabs: ViewPanelTab[];
    var tabsCount: Integer = 0;
    var tabSelectionList: ViewPanelTabSelection[];
    var tabSelection = HBox {
                spacing: 3
                content: bind tabSelectionList
            }
    public-init var appContext: AppContext;

    public function addTab(title:String, panel: Panel) {
        var newTab = ViewPanelTab {
                    index: tabsCount
                    viewPanel: this
                    panelContent: panel
                    appContext: appContext
                }
        var newTabSelection = ViewPanelTabSelection {
                    label: title
                    index: tabsCount
                    viewPanel: this
                    appContext: appContext
                }
        tabsCount++;
        insert newTab into tabs;
        insert newTabSelection into tabSelectionList;
    }
    public override var content = bind [tabSelection, tabs[selectedIndex]];
}
