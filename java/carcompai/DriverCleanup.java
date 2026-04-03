package carcompai;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.util.Enumeration;

@WebListener
public class DriverCleanup implements ServletContextListener {

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

        System.out.println("Shutting down MySQL cleanup threads and deregistering drivers...");

        // 1️⃣ Deregister JDBC drivers
        try {
            Enumeration<Driver> drivers = DriverManager.getDrivers();
            while (drivers.hasMoreElements()) {
                Driver d = drivers.nextElement();
                DriverManager.deregisterDriver(d);
                System.out.println("Deregistered JDBC driver: " + d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 2️⃣ Stop MySQL abandoned cleanup thread
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
            System.out.println("MySQL AbandonedConnectionCleanupThread stopped.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Optional: nothing here
    }
}
