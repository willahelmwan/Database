<%@page import="com.cs5200.sf.action.Providers"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<%
	List<Providers> provList = (ArrayList<Providers>) request.getAttribute("existingProv");
    List<Providers> potentialProvList = (ArrayList<Providers>) request.getAttribute("potentialProv");
%>
<table style="height:300px;width:375px" border="0">
	<tr>
		<td style="height: 20px">
			<font>Select New Provider</font>
		</td>
		<td>
			<select id="potentialProvidersId">
			   	<option id="0">--Select--</option>
				<%
					for (int i = 0; i < potentialProvList.size(); i++) {
				%>
				<option id="<%=potentialProvList.get(i).getId() %>"><%=potentialProvList.get(i).getName() %></option>
				<%} %>
			</select>
		</td>
		<td style="height: 20px">
			<input type="button" id="providerBtnId" name="Add Provider"
			value="Add Provider" onclick="addNewProvider()" />
		</td>
	</tr>
	<tr>
		<td colspan="3" valign="top">
			<div style="height:200px;width:100%;overflow:auto">
				<%if(provList.size() > 0){ %>
					<table>
						<thead>
							<tr>
								<th>S.No.</th>
								<th>Name</th>
								<th></th>
							</tr>
						</thead>
						<%
							for (int i = 0; i < provList.size(); i++) {
						%>
						<tr>
							<td><%=i+1 %></td>
							<td><%=provList.get(i).getName() %></td>
							<td><input type="button" value="Delete" id="deleteProviderId" 
										onclick="deleteProvider('<%=provList.get(i).getId() %>','<%=provList.get(i).getName() %>')"/></td>
						</tr>
						<%} %>
					</table>
				<%}else{ %>
					<font size="3" color="red">No providers configured...</font>
				<%} %>
			</div>
		</td>
	</tr>
</table>