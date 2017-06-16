package com.cs5200.sf.action;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class WelcomeUserAction{

	private String username;
	private List<Users> usersList;
	 
	// all struts logic here
	public String execute() {
		getAllUsers();
		return "SUCCESS";

	}

	public void getAllUsers() {
		Connection con = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			PreparedStatement ps = con.prepareStatement("select userid,username from user");
			ResultSet rs = ps.executeQuery();
			usersList = new ArrayList<Users>();
			while(rs.next()){
				Users user = new Users();
				user.setUserId(rs.getString(1));
				user.setUserName(rs.getString(2));
				usersList.add(user);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public List<Users> getUsersList() {
		return usersList;
	}

	public void setUsersList(List<Users> usersList) {
		this.usersList = usersList;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
}