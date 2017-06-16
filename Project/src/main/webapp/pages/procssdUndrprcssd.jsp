<%@page import="com.cs5200.sf.action.ShoppingItems"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	List<ShoppingItems> underProcessedshoppingList = (ArrayList<ShoppingItems>) request
			.getAttribute("underProcessedshoppingList");
	List<ShoppingItems> processedshoppingList = (ArrayList<ShoppingItems>) request
			.getAttribute("processedshoppingList");
%>

<table style="table-layout: fixed; height: 100%; width: 100%;" border="0">
	<tr>
		<td width="20%">Select Order Id:
		<td align="left" width="15%">
			<select id="underProcessindDrpId">
				<option id="0">--OrderId--</option>
				<%for(int i = 0; i < underProcessedshoppingList.size() ; i++){ %>
					<option id="<%=underProcessedshoppingList.get(i).getItemId() %>"><%=underProcessedshoppingList.get(i).getItemId() %></option>
				<%} %>
			</select>
		</td>
		<td align="left" width="65%">
			<input type="button" value="MarkArrived" id="arrivedBtnId" onclick="markArrivedInvShopGrid()"/>
		</td>
	</tr>
	<tr height="40%">
		<td colspan="3">
			<div style="width: 100%; overflow: auto" id = "processingDivId">
				<table style="table-layout: fixed; height: 100%; width: 100%;">
					<%
						if (underProcessedshoppingList.size() < 1) {
					%>
						<tr><td><font size="3" color="red">No under processing items...</font></td></tr>
					<%}else{ %>
						<tr>
							<td>
								<table style="table-layout: fixed;height: 100%; width: 100%;">
									<thead>
										<tr><th colspan="6">Under Processing Items</th></tr>
										<tr>
										    <th>OrderId</th>
											<th>Item</th>
											<th>Quantity</th>
											<th>Provider</th>
											<th>Price</th>
											<th>OrderStatus</th>
											<th>Remove</th>
										</tr>
									</thead>
									<tbody>
										<%for(int i = 0; i < underProcessedshoppingList.size() ; i++){ %>
											<tr>
												<td><%=underProcessedshoppingList.get(i).getItemId() %></td>
												<td><%=underProcessedshoppingList.get(i).getItemName() %></td>
												<td><%=underProcessedshoppingList.get(i).getQuantity() %></td>
												<td><%=underProcessedshoppingList.get(i).getProviderNm() %></td>
												<td><%=underProcessedshoppingList.get(i).getPrice() %></td>
												<td><%=underProcessedshoppingList.get(i).getOrderStatus() %></td>
												<td align="center"><a style="cursor: pointer;" onclick="removeFromShopinListY('<%=underProcessedshoppingList.get(i).getItemId() %>')">&otimes;</a></td>
											</tr>
										<%} %>
									</tbody>
								</table>
							</td>
						</tr>
					<%} %>
				</table>
			</div>
		</td>
	</tr>
	<tr height="40%">
		<td colspan="3">
			<div style="width: 100%; overflow: auto" id = "underProcessingDivId">
				<table style="table-layout: fixed; height: 100%; width: 100%;">
					<%
						if (processedshoppingList.size() < 1) {
					%>
						<tr><td><font size="3" color="red">No processed items...</font></td></tr>
					<%}else{ %>
						<tr>
							<td>
								<table style="table-layout: fixed;height: 100%; width: 100%;">
									<thead>
										<tr><th colspan="6">Processed Items/<a style="cursor: pointer;" onclick="clearProcessedHist()" ><font size="2" color="blue"><u>Clear History</u></font></a></th></tr>
										<tr>
										    <th>OrderId</th>
											<th>Item</th>
											<th>Quantity</th>
											<th>Provider</th>
											<th>Price</th>
											<th>OrderStatus</th>
										</tr>
									</thead>
									<tbody>
										<%for(int i = 0; i < processedshoppingList.size() ; i++){ %>
											<tr>
												<td><%=processedshoppingList.get(i).getItemId() %></td>
												<td><%=processedshoppingList.get(i).getItemName() %></td>
												<td><%=processedshoppingList.get(i).getQuantity() %></td>
												<td><%=processedshoppingList.get(i).getProviderNm() %></td>
												<td><%=processedshoppingList.get(i).getPrice() %></td>
												<td><%=processedshoppingList.get(i).getOrderStatus() %></td>
											</tr>
										<%} %>
									</tbody>
								</table>
							</td>
						</tr>
					<%} %>
				</table>
			</div>
		</td>
	</tr>
</table>