package com.cs5200.sf.action;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class MysqlConnectionManager {
	private static DataSource ds;
	public static DataSource dataSource() {
		try{
			Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("jdbc/smartfridge");
		}catch(Exception ex){
			System.out.println(ex.getMessage());
		}
		return ds;
	}
}
