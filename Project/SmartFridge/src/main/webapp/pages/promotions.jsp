<%@page import="com.cs5200.sf.action.Promotions"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	List<Promotions> promotionsLst = (ArrayList<Promotions>) request.getAttribute("promotionsLst");
%>

<%
	if (promotionsLst.size() > 0) {
%>
<table style="height: 100%; width: 100%">
	<thead align="left">
		<tr align="left">
			<th>Name</th>
			<th>Detail</th>
			<th>Quantity</th>
			<th>RelatedItm</th>
			<th>Discount</th>
			<th></th>
		</tr>
	</thead>
	<%
		for (int i = 0; i < promotionsLst.size(); i++) {
	%>
	<tr align="left">
		<td><%=promotionsLst.get(i).getPromItem()%></td>
		<td><%=promotionsLst.get(i).getPromDetail()%></td>
		<td><%=promotionsLst.get(i).getIteQquantity()%></td>
		<td><%=promotionsLst.get(i).getRelatedItem()%></td>
		<td><%=promotionsLst.get(i).getDiscount()%></td>
		<td><input type="button" id="applyPromotionId" value="Add"
			onclick="addPromotions('<%=promotionsLst.get(i).getPromId()%>')" /></td>
	</tr>
	<%
			}
	%>
</table>
<%
	} else {
%>
<font size="3" color="red">No promotions available...</font>
<%
	}
%>


