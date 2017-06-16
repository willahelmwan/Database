package com.cs5200.sf.action;

public class Inventory {
	private String itemId;
	private String itemName;
	private String itemQuantity;
	private String itemCategory;
	private String itemExp;
	private String itemPin;
	private String itemPinThres;
	private String itemPinQuant;
	private String displayHeader;
	private String pinFlag;
	
	public String getItemName() {
		return itemName;
	}

	public String getItemQuantity() {
		return itemQuantity;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public void setItemQuantity(String itemQuantity) {
		this.itemQuantity = itemQuantity;
	}

	public String getItemId() {
		return itemId;
	}

	public void setItemId(String itemId) {
		this.itemId = itemId;
	}

	public String getItemCategory() {
		return itemCategory;
	}

	public void setItemCategory(String itemCategory) {
		this.itemCategory = itemCategory;
	}

	public String getItemExp() {
		return itemExp;
	}

	public void setItemExp(String itemExp) {
		this.itemExp = itemExp;
	}

	public String getItemPin() {
		return itemPin;
	}

	public void setItemPin(String itemPin) {
		this.itemPin = itemPin;
	}

	public String getItemPinThres() {
		return itemPinThres;
	}

	public void setItemPinThres(String itemPinThres) {
		this.itemPinThres = itemPinThres;
	}

	public String getItemPinQuant() {
		return itemPinQuant;
	}

	public void setItemPinQuant(String itemPinQuant) {
		this.itemPinQuant = itemPinQuant;
	}

	public String getDisplayHeader() {
		return displayHeader;
	}

	public void setDisplayHeader(String displayHeader) {
		this.displayHeader = displayHeader;
	}

	public String getPinFlag() {
		return pinFlag;
	}

	public void setPinFlag(String pinFlag) {
		this.pinFlag = pinFlag;
	}

}
