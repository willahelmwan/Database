<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.cs5200.sf.action.Ordering"%>
<%@page import="com.cs5200.sf.action.Users"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/prototype.js"></script>
<link rel="stylesheet" href="css/display.css" type="text/css">
<script type="text/javascript" src="js/smartfridge.js"></script>

</head>
<%
  List<Ordering> catgList = (ArrayList<Ordering>) request.getAttribute("categoriesList");
  List<Users> userList = (ArrayList<Users>) request.getAttribute("usersList"); 
%>
<body onload="populateNecessaryElements()">
	<table style="height: 100%; width: 100%;" border="1">
		<tr style="height: 400px; width: 600px;" align="center" valign="middle">
			<td style="height: 400px; width: 600px;">
				<table style="height: 100%; width: 100%;" border="1">
					<tr align="center" style="height: 5%; width: 100%;" bgcolor="#ADD8E6">
						<td align="center">
							<a onclick="displayInventory()" style="cursor: pointer;"><u>Inventory Display</u></a>
						</td>
					</tr>
					<tr align="left" style="height: 10%; width: 100%;" valign="middle">
						<td align="left">
							<font color="red" size="2">AuthenticateForPin (user/password)&nbsp;&nbsp;</font>
							<input type="text" id = "authPinUsrId" maxlength="15" size="15"/>&nbsp;&nbsp;
							<input type="password" id = "authPinPasswdId" maxlength="15" size="15"/>&nbsp;&nbsp;
							<input type="button" value="EnablePin" id="enablePinBtnId" onclick="enablePin()"/>
							<input type="button" value="DisablePin" id="disablePinBtnId" onclick="disablePin()"/>
						</td>
					</tr>
					<tr align="center" style="height: 75%; width: 100%;">
						<td>
							<div style="display: inline" id="inventorydiv">
					
							</div>
						</td>
					</tr>
					<tr align="left" style="height: 10%; width: 100%;">
						<td align="left">
							<table>
								<tr align="left">
									<td align="left">Item&nbsp;<input type="text" id = "manualItemId" maxlength="15" size="15"/></td>
									<td align="left">Quantity&nbsp;<input type="text" id = "manualQuantityId" maxlength="3" size="5"/></td>
									<td align="left">Expiry&nbsp;<input type="text" id = "manualExpiryId" maxlength="10" placeholder="mm-dd-yyyy" size="12"/></td>
									<td align="left">
										<%if(catgList.size() > 0){ %>
											<select id="categoryManualDropId">
												<option id="0">--Category--</option>
											<% for(int i = 0;i<catgList.size();i++) {%>
												<option id="<%=catgList.get(i).getCategoryId() %>"><%=catgList.get(i).getCategoryName() %></option>
											<%} %>
											</select>
										<%} else{%>
											<select id="categoryManualDropId">
												<option id="0">--Category--</option>
											</select>
										<%} %>
									</td>
									<td align="left"><input type="button" id = "manualAddBtnId" value="Add" onclick="manualAddItem()"/></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
			<td style="height: 400px; width: 600px;">
				<table style="height: 100%; width: 100%;" border="1">
					<tr align="center" style="height: 5%; width: 100%;" bgcolor="#ADD8E6">
						<td align="center">
							<a onclick="displayProviders()" style="cursor: pointer;"><u>Provider/User Management</u></a>
						</td>
					</tr>
					<tr align="left" style="height: 10%; width: 100%;">
						<td align="left">
							<table>
								<tr align="left">
									<td align="left">New User&nbsp;<input type="text" id = "createUserId" maxlength="15" size="15"/></td>
									<td align="left">Password&nbsp;<input type="password" id = "createPasswdId" maxlength="15" size="15"/></td>
									<td align="left"><input type="button" id = "createUserBtnId" value="CreateUser" onclick="createNewUser()"/></td>
										<td><select id="userId">
												<option id="0">--Users--</option>
											<% for(int i = 0;i<userList.size();i++) {%>
												<option id="<%=userList.get(i).getUserId() %>"><%=userList.get(i).getUserName() %></option>
											<%} %>
										</select>&nbsp;&nbsp;
										<input type="button" id = "deleteUserBtnId" value="DeleteUser" onclick="deleteUser()"/>
										</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr align="center" style="height: 85%; width: 100%;">
						<td>
							<div style="display: inline" id="providerdiv">
								
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr style="height: 400px; width: 1400px;" align="center" valign="middle">
			<td style="height: 400px; width: 600px;">
				<table style="height: 100%; width: 100%;" border="1">
					<tr align="center" style="height: 5%; width: 100%;" bgcolor="#ADD8E6">
						<td align="center">
							<a onclick="displayPromotions()" style="cursor: pointer;"><u>Promotion Management</u></a>
						</td>
					</tr>
					<tr align="center" style="height: 95%; width: 100%;">
						<td>
							<div style="display: inline" id="promotiondiv">
					
							</div>
						</td>
					</tr>
				</table>
			</td>
			<td style="height: 400px; width: 600px;">
				<table style="height: 100%; width: 100%;" border="1">
					<tr align="center" style="height: 5%; width: 100%;" bgcolor="#ADD8E6">
						<td align="center">
							Order Management (<a onclick="displayManualOrders()" style="cursor: pointer;"><u>Manual</u></a>/<a onclick="displayAutoOrders()" style="cursor: pointer;"><u>Automatic</u></a>)
						</td>
					</tr>
					<tr align="center" style="height: 10%; width: 100%;">
						<td>
							<div style="display: inline" id="orderingdiv">
					
							</div>
						</td>
					</tr>
					<tr align="center" style="height: 90%; width: 100%;">
						<td>
							<div id="shoppingListDivId" style="height:275px;width:100%;overflow:auto">
							
							</div>
						</td>
					</tr>
					
				</table>
			</td>
		</tr>
		<tr style="height: 400px; width: 1400px;" align="center" valign="middle">
			<td style="height: 400px; width: 600px;">
				<table style="height: 100%; width: 100%;" border="1">
					<tr align="center" style="height: 5%; width: 100%;" bgcolor="#ADD8E6">
						<td align="center">
							<a onclick="displayProcessedItems()" style="cursor: pointer;"><u>Processed</u></a>/<a onclick="displayUnderProcessedItems()" style="cursor: pointer;"><u>UnderProcessed Orders</u></a>
						</td>
					</tr>
					<tr align="center" style="height: 95%; width: 100%;">
						<td>
							<div style="display: inline" id="processUnderprocssdiv">
					
							</div>
						</td>
					</tr>
				</table>
			</td>
			<td style="height: 400px; width: 600px;">
				<table style="height: 100%; width: 100%;" border="1">
					<tr align="center" style="height: 5%; width: 100%;" bgcolor="#ADD8E6">
						<td align="center">
							<a onclick="displayExpiredItems()" style="cursor: pointer;"><u>Expired</u></a>/<a onclick="displayAbtToExpiredItems()" style="cursor: pointer;"><u>About To Expire</u></a> Items
						</td>
					</tr>
					<tr align="center" style="height: 95%; width: 100%;">
						<td>
							<div style="display: inline" id="expirationdiv">
					
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

</body>
</html>