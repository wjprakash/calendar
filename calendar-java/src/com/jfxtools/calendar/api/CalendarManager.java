/*
 * CalendarManager.fx
 *
 * Created on Dec 09, 2009, 2:26:01 PM
 */
package com.jfxtools.calendar.api;

import com.jfxtools.calendar.CalendarManagerImpl;


/**
 * Connection Manager that maintains the information about added connections
 * 
 * @author Winston Prakash
 * @version 1.0
 */
public abstract class CalendarManager {

	private static CalendarManager instance;

	public synchronized static CalendarManager getInstance() {
		if (instance == null) {
			instance = new CalendarManagerImpl();
		}
		return instance;
	}

//	public static interface ConnectionManagerListener {
//		public void connectionConfigAdded(IConnectionConfig config);
//
//		public void connectionConfigRemoved(IConnectionConfig config);
//
//		public void connectionConfigModified(IConnectionConfig connectionConfig);
//	}
}