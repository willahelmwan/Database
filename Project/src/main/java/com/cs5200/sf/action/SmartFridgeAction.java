package com.cs5200.sf.action;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;

public class SmartFridgeAction extends ActionSupport implements ServletRequestAware, SessionAware{

	HttpServletRequest request;
	private Map<String, Object> sessionAttributes = null;
	
	public void setServletRequest(HttpServletRequest arg0) {
		request = arg0;
	}

	private List<Providers> existingProviders = new ArrayList<Providers>();
	private List<Providers> potentialProviders = new ArrayList<Providers>();
	private List<Inventory> allInventoryItems = new ArrayList<Inventory>();
	private List<Ordering> allCategories = new ArrayList<Ordering>();
	private List<Ordering> allProducts = new ArrayList<Ordering>();
	private List<String> allQuantity = new ArrayList<String>();
	private List<Ordering> allProdPrice = new ArrayList<Ordering>();
	private List<ShoppingItems> allshoppingList = new ArrayList<ShoppingItems>();
	private List<ShoppingItems> underProcessedshoppingList = new ArrayList<ShoppingItems>();
	private List<ShoppingItems> processedshoppingList = new ArrayList<ShoppingItems>();
	private List<Users> usersList = new ArrayList<Users>();
	private List<ExpiringExpired> expiredList = new ArrayList<ExpiringExpired>();
	private List<ExpiringExpired> expiringList = new ArrayList<ExpiringExpired>();
	private List<Promotions> promotionsList = new ArrayList<Promotions>();
	
	private String provId;
	private String provNm;
	private String itemId;
	private String itemNm;
	private String pinThres;
	private String pinQuant;
	
	private String catId;
	private String quantId;
	private String provdPriceId;
	
	private String prodNm;
	private String quant;
	private String vendorText;
	private String vendorId;
	
	private String placeOrder;
	private String itemArrived;
	private String sid;
	
	private String itemQuant;
	private String itemExpiry;
	
	private String user;
	private String passwd;
	
	private String userId;
	private String pinFlag;
	
	private String promId;

	public String execute() {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			ps = con.prepareStatement("select cat_id, cat_name from category");
			rs = ps.executeQuery();
			while(rs.next()){
				Ordering o = new Ordering();
				o.setCategoryId(rs.getString(1));
				o.setCategoryName(rs.getString(2));
				allCategories.add(o);
			}
			request.setAttribute("categoriesList", allCategories);
			rs.close();
			ps.close();
			ps = con.prepareStatement("select userid, username from fridgeusers");
			rs = ps.executeQuery();
			while(rs.next()){
				Users u = new Users();
				u.setUserId(rs.getString(1));
				u.setUserName(rs.getString(2));
				usersList.add(u);
			}
			request.setAttribute("usersList", usersList);
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try{
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String addPromotions(){
		Connection con = null;
		CallableStatement cs = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			cs = con.prepareCall("{call smartfridge.p_apply_promotion(?)}");
			cs.setInt(1, Integer.parseInt(promId));
			cs.execute();
			con.commit();
			inputStream = new ByteArrayInputStream("promotion added".getBytes("UTF-8"));
		}catch(Exception e){
			try {
				inputStream = new ByteArrayInputStream(e.getMessage().getBytes("UTF-8"));
			} catch (UnsupportedEncodingException e1) {
				e1.printStackTrace();
			}
		}finally{
			try{
				cs.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String displayPromotions(){
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			ps = con.prepareStatement("select prom_id, prom_item, prom_detail, item_quantity, related_item, discount, prom_flag from promotions");
			rs = ps.executeQuery();
			
			while(rs.next()){
				Promotions p = new Promotions();
				p.setPromId(rs.getString(1));
				
				String promId = rs.getString(2);
				PreparedStatement ps1 = con.prepareStatement("select pd_name from product_details where pd_id = ?");
				ps1.setInt(1, Integer.parseInt(promId));
				ResultSet rs1 = ps1.executeQuery();
				while(rs1.next()){
					p.setPromItem(rs1.getString(1));
				}
				
				p.setPromDetail(rs.getString(3));
				p.setIteQquantity(rs.getString(4));
				
				String relItm = rs.getString(5);
				if(relItm != null && !"".equalsIgnoreCase(relItm) && relItm.trim().length() > 0){
					ps1 = con.prepareStatement("select pd_name from product_details where pd_id = ?");
					ps1.setInt(1, Integer.parseInt(rs.getString(5)));
					rs1 = ps1.executeQuery();
					while(rs1.next()){
						p.setRelatedItem(rs1.getString(1));
					}
					
				}else{
					p.setRelatedItem("");
				}
				p.setDiscount(rs.getString(6));
				p.setPromFlag(rs.getString(7));
				promotionsList.add(p);
				rs1.close();
				ps1.close();
			}
			request.setAttribute("promotionsLst", promotionsList);
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			try{
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String checkItemQuantityInventory(){
		Connection con = null;
		CallableStatement cs = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			cs = con.prepareCall("{call smartfridge.p_del_pin_zero_quant_items()}");
			cs.execute();
			con.commit();
			inputStream = new ByteArrayInputStream("items deleted".getBytes("UTF-8"));
		}catch(Exception e){
			System.out.println(e.getMessage());
		}finally{
			try{
				cs.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String clearProcessedHist(){
		Connection con = null;
		PreparedStatement ps = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			ps = con.prepareStatement("delete from shopping_list where order_flag = ?");
			ps.setString(1, "A");
			
			ps.execute();
			con.commit();
			inputStream = new ByteArrayInputStream("history deleted".getBytes("UTF-8"));
		}catch(Exception e){
			System.out.println(e.getMessage());
		}finally{
			try{
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String removeFromShopinList(){
		Connection con = null;
		CallableStatement cs = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean callDelProc = false;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			
			ps = con.prepareStatement("select prom_id from shopping_list where si_id = ?");
			ps.setInt(1, Integer.parseInt(sid));
			rs = ps.executeQuery();
			
			while(rs.next()){
				String cnt = rs.getString(1);
				if(null != cnt && !"".equalsIgnoreCase(cnt) && cnt.trim().length() > 0){
					callDelProc = true;
				}
			}
			ps.close();
			rs.close();
			if(callDelProc){
				ps = con.prepareStatement("select prom_id from shopping_list where si_id = ?");
				ps.setInt(1, Integer.parseInt(sid));
				rs = ps.executeQuery();
				String promId = "";
				while(rs.next()){
					promId = rs.getString(1);
				}
				
				cs = con.prepareCall("{call smartfridge.p_delete_promotion(?)}");
				cs.setInt(1, Integer.parseInt(promId));
				cs.execute();
			}else{
				ps = con.prepareStatement("delete from shopping_list where si_id = ?");
				ps.setInt(1, Integer.parseInt(sid));
				ps.execute();
			}
			
			con.commit();
			inputStream = new ByteArrayInputStream("Promotion item deleted".getBytes("UTF-8"));
		}catch(Exception e){
			System.out.println(e.getMessage());
		}finally{
			try{
				rs.close();
				ps.close();
				cs.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String removeFromShopinListY(){
		Connection con = null;
		PreparedStatement ps = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			
			ps = con.prepareStatement("delete from shopping_list where si_id = ?");
			ps.setInt(1, Integer.parseInt(sid));
			ps.execute();
			
			con.commit();
			inputStream = new ByteArrayInputStream("Promotion item deleted".getBytes("UTF-8"));
		}catch(Exception e){
			System.out.println(e.getMessage());
		}finally{
			try{
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String displayExpiredExpiring(){
		Connection con = null;
		CallableStatement cs = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			cs = con.prepareCall("{call smartfridge.p_check_expiry_items_inventory()}");
			cs.execute();
			
			ps = con.prepareCall("select item_name, date_exp from expired_items");
			rs = ps.executeQuery();
			while(rs.next()){
				ExpiringExpired ee = new ExpiringExpired();
				ee.setItemName(rs.getString(1));
				ee.setDateExpired(rs.getString(2));
				expiredList.add(ee);
			}
			rs.close();
			ps.close();
			ps = con.prepareCall("select item_name, days_exp from expiring_items");
			rs = ps.executeQuery();
			while(rs.next()){
				ExpiringExpired ee = new ExpiringExpired();
				ee.setItemName(rs.getString(1));
				ee.setDaysToExpire(rs.getString(2));
				expiringList.add(ee);
			}
			
			request.setAttribute("expiredList", expiredList);
			request.setAttribute("expiringList", expiringList);
			
			
			con.commit();
		}catch (Exception e) {
			System.out.println(e.getMessage());
		}finally{
			try{
				cs.close();
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String validatePlaceOrder(){
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			int i = 0;
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			ps = con.prepareStatement("select count(*) from fridgeusers where UserName = ? and UserPassword = ?");
			ps.setString(1, user);
			ps.setString(2, passwd);
			rs = ps.executeQuery();
			while(rs.next()){
				i = rs.getInt(1);
			}
			rs.close();
			ps.close();
			if(null != pinFlag && "Y".equalsIgnoreCase(pinFlag)){
				ps = con.prepareStatement("select count(*) from inventory");
				rs = ps.executeQuery();
				while(rs.next()){
					if(i > 0){
						StringBuilder s = new StringBuilder();
						s.append("true").append("##").append(rs.getString(1));
						inputStream = new ByteArrayInputStream(s.toString().getBytes("UTF-8"));
					}else{
						inputStream = new ByteArrayInputStream("false".getBytes("UTF-8"));
					}
				}
			}else{
				if(i > 0){
					inputStream = new ByteArrayInputStream("true".getBytes("UTF-8"));
				}else{
					inputStream = new ByteArrayInputStream("false".getBytes("UTF-8"));
				}
			}
			
		}catch(Exception e){
			System.out.println(e.getMessage());
		}finally{
			try{
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String createNewUser(){
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			ps = con.prepareStatement("insert into fridgeusers (UserName, UserPassword) values (?,?)");
			ps.setString(1, user);
			ps.setString(2, passwd);
			
			ps.execute();
			ps.close();
			ps = con.prepareStatement("select userid, username from fridgeusers where UserName = ? and UserPassword = ?");
			ps.setString(1, user);
			ps.setString(2, passwd);
			
			rs = ps.executeQuery();
			StringBuilder sb = new StringBuilder();
			while(rs.next()){
				sb.append(rs.getString(1)).append("##").append(rs.getString(2));
			}
			
			con.commit();
			inputStream = new ByteArrayInputStream(sb.toString().getBytes("UTF-8"));
		}catch(Exception e){
			try {
				inputStream = new ByteArrayInputStream("false".getBytes("UTF-8"));
			} catch (Exception e1) {
				System.out.println(e.getMessage());
			}
		}finally{
			try{
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String deleteUser(){
		Connection con = null;
		PreparedStatement ps = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			ps = con.prepareStatement("delete from fridgeusers where userid = ?");
			ps.setInt(1, Integer.parseInt(userId));
			
			ps.execute();
			con.commit();
			inputStream = new ByteArrayInputStream("User deleted".getBytes("UTF-8"));
		}catch(Exception e){
			System.out.println(e.getMessage());
		}finally{
			try{
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String manualInvUpdate(){
		Connection con = null;
		CallableStatement cs = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			cs = con.prepareCall("{call smartfridge.p_add_manual_item_inventory(?,?,?,?)}");
			
			cs.setString(1, itemNm);
			cs.setInt(2, Integer.parseInt(itemQuant));
			cs.setInt(3, Integer.parseInt(catId));
			
			DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
			Date dt = df.parse(itemExpiry);
			java.sql.Date expdt = new java.sql.Date(dt.getTime());
			
			cs.setDate(4, expdt);
			
			cs.execute();
			con.commit();
			inputStream = new ByteArrayInputStream("manual order updated".getBytes("UTF-8"));
		}catch(Exception e){
			System.out.println(e.getMessage());
		}finally{
			try{
				cs.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String displayProcessedUndProcessed(){
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			
			if(null != itemArrived && "Y".equalsIgnoreCase(itemArrived)){
				ps = con.prepareStatement("update shopping_list set order_flag = 'A' where si_id = ?");
				ps.setInt(1, Integer.parseInt(sid));
				ps.executeUpdate();
				ps.close();
			}
			
			ps = con.prepareStatement("select si_id, si_name, si_quantity, lowest_provider, lowest_price, order_flag from shopping_list where order_flag = 'Y'");
			
			rs = ps.executeQuery();
			
			while(rs.next()){
				ShoppingItems s = new ShoppingItems();
				s.setItemId(rs.getString(1));
				s.setItemName(rs.getString(2));
				s.setQuantity(rs.getString(3));
				s.setProviderNm(rs.getString(4));
				s.setPrice(rs.getString(5));
				s.setOrderStatus("Not Received");
				underProcessedshoppingList.add(s);
			}
			rs.close();
			ps = con.prepareStatement("select si_id, si_name, si_quantity, lowest_provider, lowest_price, order_flag from shopping_list where order_flag = 'A'");
			
			rs = ps.executeQuery();
			
			while(rs.next()){
				ShoppingItems s = new ShoppingItems();
				s.setItemId(rs.getString(1));
				s.setItemName(rs.getString(2));
				s.setQuantity(rs.getString(3));
				s.setProviderNm(rs.getString(4));
				s.setPrice(rs.getString(5));
				s.setOrderStatus("Order Complete");
				processedshoppingList.add(s);
			}
			con.commit();
		}catch(Exception e){
			System.out.println(e.getMessage());
		}finally{
			try{
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String getShoppingListItems(){
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			
			if(null != placeOrder && "Y".equalsIgnoreCase(placeOrder)){
				con.prepareStatement("update shopping_list set order_flag = 'Y' where order_flag = 'N'").executeUpdate();
			}
			
			ps = con.prepareStatement("select si_id, si_name, si_quantity, lowest_provider, lowest_price, prom_id from shopping_list where order_flag = 'N'");
			rs = ps.executeQuery();
			while(rs.next()){
				ShoppingItems s = new ShoppingItems();
				s.setItemId(rs.getString(1));
				s.setItemName(rs.getString(2));
				s.setQuantity(rs.getString(3));
				s.setProviderNm(rs.getString(4));
				s.setPrice(rs.getString(5));
				s.setOrderStatus("Not Ordered");
				String promId = rs.getString(6);
				if(null != promId && !"".equalsIgnoreCase(promId) && promId.length() > 0){
					s.setPromotionId("Y");
					s.setPromId(rs.getString(6));
				}else{
					s.setPromotionId("N");
					s.setPromId("0");
				}
				allshoppingList.add(s);
			}
		con.commit();
		}catch(Exception e){
			System.out.println(e.getMessage());
		}finally{
			try{
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String addItemToShoppingList(){
		Connection con = null;
		CallableStatement cs = null;
		try{
			String[] vendorTextArr = vendorText.split(":");
			String lowestProviderNm = vendorTextArr[0].trim();
			String lowestPrice = vendorTextArr[1].trim().substring(1, vendorTextArr[1].indexOf("$"));
			
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			cs = con.prepareCall("{call smartfridge.p_add_shopping_items(?,?,?,?,?)}");;
			cs.setString(1, prodNm); //product id from product details
			cs.setInt(2, Integer.parseInt(quant)); //quantity which user has selected
			cs.setString(3, lowestProviderNm);
			cs.setInt(4, Integer.parseInt(lowestPrice));
			cs.setInt(5, Integer.parseInt(vendorId));
			
			cs.execute();
			
			con.commit();
			inputStream = new ByteArrayInputStream("shopping list updated".getBytes("UTF-8"));
		}catch(Exception e){
			System.out.println(e.getMessage());
		}finally{
			try{
				cs.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String populateVendors(){
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			ps = con.prepareStatement("select distinct p.ProviderId, p.ProviderName, pd.pd_price, pd.pd_delvdays "
					+ "from product_details pd, providers p "
					+ "where pd.pd_cat = ? and pd.provider_id = p.ProviderId and pd.pd_name = ?"
					+ "and pd.provider_id in (select CurrProviderId from currentproviders)");
			
			ps.setInt(1, Integer.parseInt(catId));
			ps.setString(2, provNm);
			
			rs = ps.executeQuery();
			while(rs.next()){
				Ordering o = new Ordering();
				o.setVendorId(rs.getString(1));
				o.setVendorName(rs.getString(2));
				o.setVendorPrice(String.valueOf(Integer.parseInt(quantId) * rs.getInt(3)));
				o.setVendorDelvDays(rs.getString(4));
				allProdPrice.add(o);
			}
			request.setAttribute("categoriesList", sessionAttributes.get("catListSess"));
			
			request.setAttribute("productList", sessionAttributes.get("prodListSess"));
			
			request.setAttribute("quantityList", sessionAttributes.get("quantListSess"));
			
			request.setAttribute("prodPriceList", allProdPrice);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}finally{
			try{
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String populateProducts(){
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			ps = con.prepareStatement("select distinct pd_name from product_details where pd_cat = ?");
			ps.setInt(1, Integer.parseInt(catId));
			rs = ps.executeQuery();
			while(rs.next()){
				Ordering o = new Ordering();
				o.setProductName(rs.getString(1));
				allProducts.add(o);
			}
			request.setAttribute("categoriesList", sessionAttributes.get("catListSess"));
			
			request.setAttribute("productList", allProducts);
			sessionAttributes.put("prodListSess", allProducts);
			
			request.setAttribute("quantityList", sessionAttributes.get("quantListSess"));
			
			request.setAttribute("prodPriceList", allProdPrice);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try{
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String getCategoryForOrder(){
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			ps = con.prepareStatement("select cat_id, cat_name from category");
			rs = ps.executeQuery();
			while(rs.next()){
				Ordering o = new Ordering();
				o.setCategoryId(rs.getString(1));
				o.setCategoryName(rs.getString(2));
				allCategories.add(o);
			}
			for(int i=1;i<=5;i++){
				allQuantity.add(String.valueOf(i));
			}
			request.setAttribute("categoriesList", allCategories);
			sessionAttributes.put("catListSess", allCategories);
			
			request.setAttribute("productList", allProducts);
			
			request.setAttribute("quantityList", allQuantity);
			sessionAttributes.put("quantListSess", allQuantity);
			
			request.setAttribute("prodPriceList", allProdPrice);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try{
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String addItemToInventory(){
		Connection con = null;
		CallableStatement cs = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			cs = con.prepareCall("{call smartfridge.p_add_item_inventory(?)}");;
			cs.setInt(1, Integer.parseInt(itemId));
			cs.execute();
			con.commit();
			inputStream = new ByteArrayInputStream("item added".getBytes("UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try{
				cs.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String deleteItemFromInventory(){
		Connection con = null;
		CallableStatement cs = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			cs = con.prepareCall("{call smartfridge.p_delete_item_inventory(?)}");;
			cs.setString(1, itemNm);
			cs.execute();
			con.commit();
			inputStream = new ByteArrayInputStream("item deleted".getBytes("UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try{
				cs.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String pinItemFromInventory(){
		Connection con = null;
		CallableStatement cs = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			cs = con.prepareCall("{call smartfridge.p_pin_item_inventory(?)}");;
			cs.setString(1, itemNm);
			cs.execute();
			con.commit();
			inputStream = new ByteArrayInputStream("item pinned".getBytes("UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try{
				cs.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String updatePinDataInventory(){
		Connection con = null;
		CallableStatement cs = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			cs = con.prepareCall("{call smartfridge.p_update_pinItem_inventory(?,?,?)}");;
			cs.setString(1, itemNm);
			cs.setInt(2, Integer.parseInt(pinThres));
			cs.setInt(3, Integer.parseInt(pinQuant));
			cs.execute();
			con.commit();
			inputStream = new ByteArrayInputStream("pinned data updated".getBytes("UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try{
				cs.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String getAllInventory(){
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		PreparedStatement ps1 = null;
		try{
			con = MysqlConnectionManager.dataSource().getConnection();
			ps = con.prepareStatement("select item_name, sum(item_quantity) from inventory group by item_name");
			rs = ps.executeQuery();
			
			ps1 = con.prepareStatement("select distinct item_pin, pin_quantity, pin_threshold from inventory WHERE item_name = ?");
			
			while(rs.next()){
				Inventory i = new Inventory();
				i.setItemName(rs.getString(1));
				i.setItemQuantity(rs.getString(2));
				
				ps1.setString(1, i.getItemName());
				rs1 = ps1.executeQuery();
				while(rs1.next()){
					i.setItemPin(rs1.getString(1));
					i.setItemPinQuant(rs1.getString(2));
					i.setItemPinThres(rs1.getString(3));
				}
				
				allInventoryItems.add(i);
			}
			request.setAttribute("dpHdVal", "N");
			for(Inventory i : allInventoryItems){
				if("Y".equalsIgnoreCase(i.getItemPin())){
					request.setAttribute("dpHdVal", "Y");
					break;
				}
			}
			request.setAttribute("invList", allInventoryItems);
		} catch (Exception ex) {
			ex.printStackTrace();
		}finally{
			try{
				rs1.close();
				rs.close();
				ps1.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}

	public String fetchPotentialProviders() {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			ps = con.prepareStatement("select providerid, providername from providers where providerid not in (select distinct currproviderid from currentproviders)");
			rs = ps.executeQuery();
			while(rs.next()){
				Providers p = new Providers();
				p.setId(rs.getString(1));
				p.setName(rs.getString(2));
				potentialProviders.add(p);
			}
			rs.close();
			ps.close();
			ps = con.prepareStatement("select CurrProviderId, CurrProviderNm from CurrentProviders");
		    rs = ps.executeQuery();
		    
			while(rs.next()){
				Providers p = new Providers();
				p.setId(rs.getString(1));
				p.setName(rs.getString(2));
				existingProviders.add(p);
			}
			request.setAttribute("existingProv", existingProviders);
			request.setAttribute("potentialProv", potentialProviders);
		} catch (Exception ex) {

		}finally{
			try{
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String addPotentialProviders() {
		Connection con = null;
		PreparedStatement ps = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			ps = con.prepareStatement("insert into CurrentProviders values (?,?)");
			ps.setInt(1, Integer.valueOf(provId));
			ps.setString(2, provNm);
			ps.execute();
			con.commit();
			inputStream = new ByteArrayInputStream("added".getBytes("UTF-8"));
		} catch (Exception ex) {

		}finally{
			try{
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}
	
	public String deleteCurrentProvider() {
		Connection con = null;
		PreparedStatement ps = null;
		try {
			con = MysqlConnectionManager.dataSource().getConnection();
			con.setAutoCommit(false);
			ps = con.prepareStatement("delete from CurrentProviders where CurrProviderId = ?");
			ps.setInt(1, Integer.valueOf(provId));
			ps.execute();
			con.commit();
			inputStream = new ByteArrayInputStream("deleted".getBytes("UTF-8"));
		} catch (Exception ex) {

		}finally{
			try{
				ps.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return SUCCESS;
	}

	public List<Providers> getExistingProviders() {
		return existingProviders;
	}

	public void setExistingProviders(List<Providers> existingProviders) {
		this.existingProviders = existingProviders;
	}

	public List<Providers> getPotentialProviders() {
		return potentialProviders;
	}

	public void setPotentialProviders(List<Providers> potentialProviders) {
		this.potentialProviders = potentialProviders;
	}

	public String getProvId() {
		return provId;
	}

	public void setProvId(String provId) {
		this.provId = provId;
	}

	public String getProvNm() {
		return provNm;
	}

	public void setProvNm(String provNm) {
		this.provNm = provNm;
	}

	public List<Inventory> getAllInventoryItems() {
		return allInventoryItems;
	}

	public void setAllInventoryItems(List<Inventory> allInventoryItems) {
		this.allInventoryItems = allInventoryItems;
	}

	public HttpServletRequest getRequest() {
		return request;
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}
	
	private InputStream inputStream;
	  public InputStream getInputStream() {
	    return inputStream;
	   }

	public String getItemId() {
		return itemId;
	}

	public void setItemId(String itemId) {
		this.itemId = itemId;
	}

	public String getPinThres() {
		return pinThres;
	}

	public void setPinThres(String pinThres) {
		this.pinThres = pinThres;
	}

	public String getPinQuant() {
		return pinQuant;
	}

	public void setPinQuant(String pinQuant) {
		this.pinQuant = pinQuant;
	}

	public void setInputStream(InputStream inputStream) {
		this.inputStream = inputStream;
	}

	public List<Ordering> getAllCategories() {
		return allCategories;
	}

	public void setAllCategories(List<Ordering> allCategories) {
		this.allCategories = allCategories;
	}

	public List<Ordering> getAllProducts() {
		return allProducts;
	}

	public void setAllProducts(List<Ordering> allProducts) {
		this.allProducts = allProducts;
	}

	public List<String> getAllQuantity() {
		return allQuantity;
	}

	public void setAllQuantity(List<String> allQuantity) {
		this.allQuantity = allQuantity;
	}

	public List<Ordering> getAllProdPrice() {
		return allProdPrice;
	}

	public void setAllProdPrice(List<Ordering> allProdPrice) {
		this.allProdPrice = allProdPrice;
	}

	public String getCatId() {
		return catId;
	}

	public void setCatId(String catId) {
		this.catId = catId;
	}

	public String getQuantId() {
		return quantId;
	}

	public void setQuantId(String quantId) {
		this.quantId = quantId;
	}

	public String getProvdPriceId() {
		return provdPriceId;
	}

	public void setProvdPriceId(String provdPriceId) {
		this.provdPriceId = provdPriceId;
	}

	@Override
	public void setSession(Map<String, Object> arg0) {
		sessionAttributes = arg0;
	}

	public String getVendorText() {
		return vendorText;
	}

	public void setVendorText(String vendorText) {
		this.vendorText = vendorText;
	}

	public String getProdNm() {
		return prodNm;
	}

	public void setProdNm(String prodNm) {
		this.prodNm = prodNm;
	}

	public String getQuant() {
		return quant;
	}

	public void setQuant(String quant) {
		this.quant = quant;
	}

	public List<ShoppingItems> getAllshoppingList() {
		return allshoppingList;
	}

	public void setAllshoppingList(List<ShoppingItems> allshoppingList) {
		this.allshoppingList = allshoppingList;
	}

	public String getVendorId() {
		return vendorId;
	}

	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}

	public String getPlaceOrder() {
		return placeOrder;
	}

	public void setPlaceOrder(String placeOrder) {
		this.placeOrder = placeOrder;
	}

	public List<ShoppingItems> getUnderProcessedshoppingList() {
		return underProcessedshoppingList;
	}

	public void setUnderProcessedshoppingList(List<ShoppingItems> underProcessedshoppingList) {
		this.underProcessedshoppingList = underProcessedshoppingList;
	}

	public List<ShoppingItems> getProcessedshoppingList() {
		return processedshoppingList;
	}

	public void setProcessedshoppingList(List<ShoppingItems> processedshoppingList) {
		this.processedshoppingList = processedshoppingList;
	}

	public String getItemArrived() {
		return itemArrived;
	}

	public void setItemArrived(String itemArrived) {
		this.itemArrived = itemArrived;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String getItemNm() {
		return itemNm;
	}

	public void setItemNm(String itemNm) {
		this.itemNm = itemNm;
	}

	public String getItemQuant() {
		return itemQuant;
	}

	public void setItemQuant(String itemQuant) {
		this.itemQuant = itemQuant;
	}

	public String getItemExpiry() {
		return itemExpiry;
	}

	public void setItemExpiry(String itemExpiry) {
		this.itemExpiry = itemExpiry;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getPasswd() {
		return passwd;
	}

	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}

	public List<Users> getUsersList() {
		return usersList;
	}

	public void setUsersList(List<Users> usersList) {
		this.usersList = usersList;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPinFlag() {
		return pinFlag;
	}

	public void setPinFlag(String pinFlag) {
		this.pinFlag = pinFlag;
	}

	public List<ExpiringExpired> getExpiredList() {
		return expiredList;
	}

	public void setExpiredList(List<ExpiringExpired> expiredList) {
		this.expiredList = expiredList;
	}

	public List<ExpiringExpired> getExpiringList() {
		return expiringList;
	}

	public void setExpiringList(List<ExpiringExpired> expiringList) {
		this.expiringList = expiringList;
	}

	public List<Promotions> getPromotionsList() {
		return promotionsList;
	}

	public void setPromotionsList(List<Promotions> promotionsList) {
		this.promotionsList = promotionsList;
	}

	public String getPromId() {
		return promId;
	}

	public void setPromId(String promId) {
		this.promId = promId;
	}
}
