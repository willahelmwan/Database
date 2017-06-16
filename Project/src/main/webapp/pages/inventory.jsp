<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.cs5200.sf.action.Inventory"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	List<Inventory> invList = (ArrayList<Inventory>) request.getAttribute("invList");
	String dispHead = request.getAttribute("dpHdVal").toString();
%>
<div style="width: 600px; overflow: auto">
	<%if(invList.size() > 0){ %>
		<table border="0" style="table-layout: fixed;height: 100%; width: 100%;">
			<thead>
				<tr align="left" height="10px">
					<th width="80px">Name</th>
					<th width="60px">Quantity</th>
					<th width="60px">Delete</th>
					<th width="40px">Item</th>
					<%if("Y".equalsIgnoreCase(dispHead)){ %>
						<th width="80px"><div id="pinThresDivId" style="display: inline">Threshold</div></th>
						<th width="80px"><div id="pinQuanDivId" style="display: inline">Quantity</div></th>
						<th width="60px"><div id="pinUpdateDivId" style="display: inline">Update</div></th>
					<%} else {%>
						<th width="80px"></th>
						<th width="80px"></th>
						<th width="60px"></th>
					<%} %>
				</tr>
			</thead>
			<%
				for (int i = 0; i < invList.size(); i++) {
			%>
			<tr align="left" height="10px">
				<td><%=invList.get(i).getItemName()%></td>
				<td><%=invList.get(i).getItemQuantity()%></td>
				<td><input type="button" value="Delete" id="deleteItemId" onclick="deleteItem('<%=invList.get(i).getItemName()%>')"/></td>
				<td><input type="button" value="Pin" id="pinItemId<%=i %>" disabled="disabled"
				onclick="pinItem('<%=invList.get(i).getItemName()%>')"/></td>
				<%
					if("Y".equalsIgnoreCase(invList.get(i).getItemPin())){
				%>
					<td>
						<div id="pinThresDivDataIdY<%=i %>" style="display: inline">
							<input type="text" maxlength="3" size="6" id="pinThresTextIdY<%=i %>" value="<%=invList.get(i).getItemPinThres() %>"/>
						</div>
					</td>
					<td>
						<div id="pinQuantityDivDataIdY<%=i %>" style="display: inline">
							<input type="text" maxlength="3" size="6" id="pinQuantityTextIdY<%=i %>" value="<%=invList.get(i).getItemPinQuant() %>"/>
						</div>
					</td>
					<td>
						<div id="pinUpdateBtnDivIdY<%=i %>" style="display: inline">
							<input type="button" value="Update" id="updatePinId<%=i %>" disabled="disabled"
							onclick="updatePinData('<%=i %>','<%=invList.get(i).getItemName() %>')"/>
						</div>
					</td>
				<%} %>
			</tr>
			<%
				}
			%>
		</table>
	<%}else{ %>
			<font size="3" color="red">No items in fridge...</font>
	<%} %>
</div>