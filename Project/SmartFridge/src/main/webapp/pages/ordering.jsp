<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.cs5200.sf.action.Ordering"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<%
	List<Ordering> catgList = (ArrayList<Ordering>) request.getAttribute("categoriesList");
	List<Ordering> prodList = (ArrayList<Ordering>) request.getAttribute("productList");
	List<String> quanList = (ArrayList<String>) request.getAttribute("quantityList");
	List<Ordering> prodPriceList = (ArrayList<Ordering>) request.getAttribute("prodPriceList");
%>
<table style="height: 10%; width: 100%" border="0">
	<tr align="left">
		<td>
			<%if(catgList.size() > 0){ %>
				<select id="categoryDropId" onchange="populateProducts()">
					<option id="0">--Category--</option>
				<% for(int i = 0;i<catgList.size();i++) {%>
					<option id="<%=catgList.get(i).getCategoryId() %>"><%=catgList.get(i).getCategoryName() %></option>
				<%} %>
				</select>
			<%} else{%>
				<select id="categoryDropId">
					<option id="0">--Category--</option>
				</select>
			<%} %>
		</td>
		<td>
			<%if(prodList.size() > 0){ %>
				<select id="productsDropId" onchange="populateVendorPrice()">
					<option id="0">--Products--</option>
				<% for(int i = 0;i<prodList.size();i++) {%>
					<option id="<%=i+1 %>"><%=prodList.get(i).getProductName() %></option>
				<%} %>
				</select>
			<%} else{%>
				<select id="productsDropId">
					<option id="0">--Products--</option>
				</select>			
			<%} %>
		</td>
		<td>
			<%if(quanList.size() > 0){ %>
				<select id="quantityDropId" onchange="populateVendorPrice()">
					<option id="0">--Quantity--</option>
				<% for(int i = 0;i<quanList.size();i++) {%>
					<option id="<%=quanList.get(i) %>"><%=quanList.get(i) %></option>
				<%} %>
				</select>
			<%} else{%>
				<select id="quantityDropId">
					<option id="0">--Quantity--</option>
				</select>
			<%} %>
		</td>
		<td>
			<%if(prodPriceList.size() > 0){ %>
				<select id="provdPriceDropId">
					<option id="0">--Vendr:Price:DelvDays--</option>
				<% for(int i = 0;i<prodPriceList.size();i++) {%>
					<option id="<%=prodPriceList.get(i).getVendorId() %>"><%=prodPriceList.get(i).getVendorName()%>&nbsp;:&nbsp;<%=prodPriceList.get(i).getVendorPrice()%>&#36;&nbsp;:&nbsp;<%=prodPriceList.get(i).getVendorDelvDays()%></option>
				<%} %>
				</select>
			<%} else{%>
				<select id="provdPriceDropId">
					<option id="0">--Vendr:Price:DelvDays--</option>
				</select>				
			<%} %>
		</td>
		<td>
			<input type="button" value="Add" id="manualShopId" onclick="addItemToList()"/>
		</td>
	</tr>
</table>
