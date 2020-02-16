package com.atrosys.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * servlet events listener
 */

public class ShoaServletContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
//        new BackUpTimerTask().run();
//
//        for (int hourOfDay : Constants.DAY_HOURS_FOR_BACKUP) {
//            Calendar calendar = Calendar.getInstance();
//            calendar.set(Calendar.HOUR_OF_DAY, hourOfDay);
//            calendar.set(Calendar.MINUTE, 0);
//            calendar.set(Calendar.SECOND, 0);
//            Timer timer = new Timer();
//            timer.schedule(new BackUpTimerTask(), calendar.getTime(),
//                    TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS)); // period: 1 day
//        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
//        new BackUpTimerTask().run();
    }
}