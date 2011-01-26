package com.jfxtools.calendar.api;

import java.sql.SQLException;

/**
 * Abstract Database Object
 * 
 * @author Winston Prakash
 * @version 1.0
 */
public interface ICalendarObject {
//	public IDatabaseInfo getDatabaseInfo();
//
//	public void setDatabaseInfo(IDatabaseInfo databaseInfo);

	public void setName(String name);

	public String getName();

	public void refresh() throws SQLException;

	public ICalendarObject getParent();

	public void setParent(ICalendarObject parent);

	public void addChild(ICalendarObject child);

	public void removeChild(ICalendarObject child);

	public boolean delete();
}