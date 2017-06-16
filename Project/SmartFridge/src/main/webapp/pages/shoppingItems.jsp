<%@page import="com.cs5200.sf.action.ShoppingItems"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	List<ShoppingItems> shopList = (ArrayList<ShoppingItems>) request.getAttribute("allshoppingList");
%>

<%
	if (shopList.size() < 1) {
%>
<table style="table-layout: fixed;height: 100%; width: 100%;">
	<tr align="left">
		<td><font size="3" color="red">No items in shopping
				list...</font></td>
	</tr>
</table>
<%
	} else {
%>
<table style="table-layout: fixed;height: 100%; width: 100%;">
	<thead>
		<tr>
		    <th>OrderId</th>
			<th>Item</th>
			<th>Quantity</th>
			<th>Provider</th>
			<th>Price</th>
			<th>Status</th>
			<th>Promotion Item</th>
			<th>Remove</th>
		</tr>
	</thead>
	<tbody>
		<%for(int i = 0; i < shopList.size() ; i++){ %>
			<tr>
				<td><%=shopList.get(i).getItemId() %></td>
				<td><%=shopList.get(i).getItemName() %></td>
				<td><%=shopList.get(i).getQuantity() %></td>
				<td><%=shopList.get(i).getProviderNm() %></td>
				<td><%=shopList.get(i).getPrice() %></td>
				<td><%=shopList.get(i).getOrderStatus() %></td>
				<td><%=shopList.get(i).getPromotionId() %></td>
				<td align="center"><a style="cursor: pointer;" onclick="removeFromShopinList('<%=shopList.get(i).getItemId() %>')">&otimes;</a></td>
			</tr>
		<%} %>
	</tbody>
</table>
<%
	}
%>

<table style="height: 90%; width: 100%" border="0">
	<tr align="left">
		<td align="left" width="100%" colspan="3">
			<%
				if (shopList.size() < 1) {
			%>
				<input type="button" value="PlaceOrder" disabled="disabled"/>
			<%
				} else {
			%>
				<font color="red" size="2">Authenticate (user/password)&nbsp;&nbsp;</font>
				<input type="text" id = "authPlaceOrdUsrId" maxlength="15" size="15"/>&nbsp;&nbsp;
				<input type="password" id = "authPlaceOrdPasswdId" maxlength="15" size="15"/>&nbsp;&nbsp;
				<input type="button" value="PlaceOrder" id="placeOrderBtnId" onclick="authenticatePlaceOrder()"/>
			<%
				}
			%>
		</td>
	</tr>
</table>