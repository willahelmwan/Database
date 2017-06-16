package com.cs5200.sf.action;

public class Ordering {
	private String categoryId;
	private String categoryName;
	
	private String productId;
	private String productName;
	
	private String quantity;
	
	private String vendorId;
	private String vendorName;
	private String vendorPrice;
	private String vendorDelvDays;

	public String getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(String categoryId) {
		this.categoryId = categoryId;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getQuantity() {
		return quantity;
	}

	public void setQuantity(String quantity) {
		this.quantity = quantity;
	}

	public String getVendorId() {
		return vendorId;
	}

	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}

	public String getVendorName() {
		return vendorName;
	}

	public void setVendorName(String vendorName) {
		this.vendorName = vendorName;
	}

	public String getVendorPrice() {
		return vendorPrice;
	}

	public void setVendorPrice(String vendorPrice) {
		this.vendorPrice = vendorPrice;
	}

	public String getVendorDelvDays() {
		return vendorDelvDays;
	}

	public void setVendorDelvDays(String vendorDelvDays) {
		this.vendorDelvDays = vendorDelvDays;
	}

}
