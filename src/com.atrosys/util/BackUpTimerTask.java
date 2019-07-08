package com.atrosys.util;

import com.atrosys.model.Constants;
import org.hibernate.boot.Metadata;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.mapping.RootClass;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import java.util.TimerTask;
import java.util.concurrent.TimeUnit;

public class BackUpTimerTask extends TimerTask {
    public void run() {
        StandardServiceRegistry standardRegistry = new StandardServiceRegistryBuilder().configure("hibernate.cfg.xml").build();
        Metadata metaData = new MetadataSources(standardRegistry).getMetadataBuilder().build();
        Object[] rootClassesObjects = metaData.getEntityBindings().toArray();
        Properties properties = new Configuration().configure().getProperties();
        String dataBaseURL = properties.getProperty("hibernate.connection.url");
        String dataBase = dataBaseURL.substring(dataBaseURL.lastIndexOf('/') + 1, dataBaseURL.length());
        String usermame = properties.getProperty("hibernate.connection.username");
        String password = properties.getProperty("hibernate.connection.password");
        for (Object item : rootClassesObjects) {
            RootClass rootClass = (RootClass) item;
            String tableName = rootClass.getIdentifier().getTable().getName();
            String s = null;
            try {
                DateFormat dateFormat = new SimpleDateFormat(" yyyy-MM-dd HH.mm.ss");
                Date date = new Date();
                String command = String.format("%s -uatro -patrosys %s %s > '%s.sql'\nexit",
                        Constants.MYSQL_DUMP_PATH, dataBase, tableName, Constants.MYSQL_BACKUP_PATH + tableName + dateFormat.format(date));
                if (OSValidator.isMac()) {
                    final ProcessBuilder processBuilder = new ProcessBuilder("/usr/bin/osascript", "-e");
                    processBuilder.command().add("tell application \"Terminal\" to do script \"" + command + "\"");
                    final Process process = processBuilder.start();
                    process.waitFor();
                } else if (OSValidator.isWindows()) {
                    Process p = Runtime.getRuntime().exec("cmd /c start /wait " + command);
                    p.waitFor();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        File[] backUpFolderFiles = new File(Constants.MYSQL_BACKUP_PATH).listFiles();
        boolean richedFileCountLimit =
                (rootClassesObjects.length * Constants.DAYS_FOR_BACKUP_KEEPING * Constants.DAY_HOURS_FOR_BACKUP.length) <
                        backUpFolderFiles.length;
        if (richedFileCountLimit)
            for (File backUpFile : backUpFolderFiles) {
                long diff = new Date().getTime() - backUpFile.lastModified();
                long diffDays = diff / TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS);
                if (diffDays > Constants.DAYS_FOR_BACKUP_KEEPING)
                    backUpFile.delete();
            }
    }
}