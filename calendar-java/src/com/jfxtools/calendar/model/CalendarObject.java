package com.jfxtools.calendar.model;

import java.sql.SQLException;

import com.jfxtools.calendar.api.ICalendarObject;
import com.jfxtools.calendar.api.ICalendarInfo;


/**
 * Abstract model object for DB Explorer Nodes
 * 
 * @author Winston Prakash
 * @version 1.0
 */
public class CalendarObject implements ICalendarObject {

	private ICalendarInfo databaseInfo;
	private String name;

	private ICalendarObject parent;

	public CalendarObject(ICalendarInfo dbMetadata, String name) {
		databaseInfo = dbMetadata;
		this.name = name;
	}

	public ICalendarInfo getDatabaseInfo() {
		return databaseInfo;
	}

	public void setDatabaseInfo(ICalendarInfo databaseInfo) {
		this.databaseInfo = databaseInfo;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void refresh() throws SQLException {
		// To be implemented by sub classes
	}

	public boolean delete() {
		// To be implemented by sub classes
		return false;
	}

	public void addChild(ICalendarObject child) {
		// To be implemented by sub classes
	}

	public void removeChild(ICalendarObject child) {
		// To be implemented by sub classes
	}

	public ICalendarObject getParent() {
		return parent;
	}

	public void setParent(ICalendarObject parent) {
		this.parent = parent;
	}
}
