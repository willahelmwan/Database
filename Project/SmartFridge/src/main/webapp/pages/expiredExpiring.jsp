<%@page import="com.cs5200.sf.action.ExpiringExpired"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	List<ExpiringExpired> expiredList = (ArrayList<ExpiringExpired>) request.getAttribute("expiredList");
	List<ExpiringExpired> expiringList = (ArrayList<ExpiringExpired>) request.getAttribute("expiringList");
%>
<table style="height: 100%; width: 100%" border="0">
	<tr align="center">
		<td align="center" width="50%">
			<%if(expiredList.size() > 0){ %>
				<table>
					<thead>
						<tr>
							<th colspan="2">Expired Items</th>
						</tr>
						<tr>
							<th>Item Name</th>
							<th>Date Expired</th>
						</tr>
					</thead>
					<tbody>
					<%for(int i = 0 ; i < expiredList.size() ; i++){ %>
						<tr>
							<td><%=expiredList.get(i).getItemName() %></td>
							<td><%=expiredList.get(i).getDateExpired() %></td>
						</tr>
					<%} %>
					</tbody>
				</table>
			<%}else{ %>
				<table><tr align="left"><td align="left"><font size="3" color="red">No expired items...</font></td></tr></table>
			<%} %>
		</td>
		<td align="center" width="50%">
			<%if(expiringList.size() > 0){ %>
				<table>
					<thead>
						<tr>
							<th colspan="2">Expiring Items</th>
						</tr>
						<tr>
							<th>Item Name</th>
							<th>Days to Expire</th>
						</tr>
					</thead>
					<tbody>
					<%for(int i = 0 ; i < expiringList.size() ; i++){ %>
						<tr>
							<td><%=expiringList.get(i).getItemName() %></td>
							<td><%=expiringList.get(i).getDaysToExpire() %></td>
						</tr>
					<%} %>
					</tbody>
				</table>
			<%}else{ %>
				<table><tr align="left"><td align="left"><font size="3" color="red">No expiring items...</font></td></tr></table>
			<%} %>
		</td>
	</tr>
</table>