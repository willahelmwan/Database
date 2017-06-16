package com.cs5200.sf.action;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class SmartFridgeListener extends TimerTask implements ServletContextListener{
	Timer timer = new Timer(true);
	public void contextDestroyed(ServletContextEvent arg0) {
		timer.cancel();
	}

	@Override
	public void contextInitialized(ServletContextEvent arg0) {
//		TimerTask timerTask = new SmartFridgeListener();
//		timer = new Timer(true);
//        timer.scheduleAtFixedRate(timerTask, 0, 1000);
	}

	public void run() {
		Connection con = null;
		CallableStatement cs = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			cs = con.prepareCall("{call smartfridge.p_check_expiry_items_inventory()}");
			boolean res = cs.execute();
			System.out.println(res);
			con.commit();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try {
				cs.close();
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
