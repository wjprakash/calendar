/*
 * AsyncJavaTask.java
 *
 * Created on Jan 09, 2010, 1:15:51 PM
 */

package com.jfxtools.calendar.utils;

import com.sun.javafx.runtime.Entry;
import javafx.async.RunnableFuture;

/**
 * Java Async Task for lenghty tasks
 * @author Winston Prakash
 */
public class AsyncJavaTask implements RunnableFuture{
  
  private Runnable proxy;

  public AsyncJavaTask(Runnable proxy){
    this.proxy = proxy;
  }

  public void run() throws Exception {
     proxy.run();
  }

  public void postMessage(final String msg) {
        Entry.deferAction(new Runnable() {
            public void run() {
                //listener.callback(msg);
            }
        });
    }
}
