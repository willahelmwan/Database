var index;
var pinValue;
function fetchdata() {
	var url = 'Welcome.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {

		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			document.getElementById('sampleRet').style.display = 'inline';
			document.getElementById('sampleRet').innerHTML = response;

		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});

}

function populateNecessaryElements() {

	displayProviders();
	displayInventory();
	displayOrdering();
	displayShoppingGrid();
	displayProcessedUndProcessed();
	displayExpiredExpiring();
	displayPromotions();
}

function displayPromotions(){
	var url = 'displayPromotions.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			document.getElementById('promotiondiv').style.display = 'inline';
			document.getElementById('promotiondiv').innerHTML = response;
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function displayInventory() {
	// alert('display inven');
	var url = 'getAllInventory.action';
	new Ajax.Request(
			url,
			{
				method : 'post',
				parameters : {

				},
				onSuccess : function(transport) {
					var response = transport.responseText || "no response text";
					// alert(response);
					document.getElementById('inventorydiv').style.display = 'inline';
					document.getElementById('inventorydiv').innerHTML = response;

					if (document.getElementById('authPinUsrId') != null) {
						var id = document.getElementById('authPinUsrId').value;
						if (id.length > 0) {
							for (i = 0; document
									.getElementById("pinItemId" + i) != null; i++) {
								if (document.getElementById("pinItemId" + i) != null) {
									document.getElementById("pinItemId" + i).disabled = false;
								}
								if (document.getElementById("updatePinId" + i) != null) {
									document.getElementById("updatePinId" + i).disabled = false;
								}
							}
						} else {
							for (i = 0; document
									.getElementById("pinItemId" + i) != null; i++) {
								if (document.getElementById("pinItemId" + i) != null) {
									document.getElementById("pinItemId" + i).disabled = true;
								}
								if (document.getElementById("updatePinId" + i) != null) {
									document.getElementById("updatePinId" + i).disabled = true;
								}
							}
						}
					}
					checkItemQuantityInventory();
				},
				onFailure : function() {
					alert('Something went wrong...')
				}
			});
}

function checkItemQuantityInventory(){
	var url = 'checkItemQuantityInventory.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function disablePin() {
	var i = 0;

	for (i = 0; document.getElementById("pinItemId" + i) != null; i++) {
		if (document.getElementById("pinItemId" + i) != null) {
			document.getElementById("pinItemId" + i).disabled = true;
		}
		if (document.getElementById("updatePinId" + i) != null) {
			document.getElementById("updatePinId" + i).disabled = true;
		}
	}
	document.getElementById('authPinUsrId').value = "";
	document.getElementById('authPinPasswdId').value = "";
}

function enablePin() {
	var user = document.getElementById('authPinUsrId').value;
	var passwd = document.getElementById('authPinPasswdId').value;

	var url = 'validatePinOrder.action';
	new Ajax.Request(
			url,
			{
				method : 'post',
				parameters : {
					user : user,
					passwd : passwd,
					pinFlag : 'Y'
				},
				onSuccess : function(transport) {
					var response = transport.responseText || "no response text";
					// alert(response);

					if (response == 'false') {
						alert('Invalid credentials');
						document.getElementById('authPinUsrId').value = "";
						document.getElementById('authPinPasswdId').value = "";
					} else {
						var retVal = response.split('##');
						var size = retVal[1];
						var i = 0;

						for (i = 0; i < size; i++) {
							if (document.getElementById("updatePinId" + i) != null) {
								document.getElementById("updatePinId" + i).disabled = false;
							}
							if (document.getElementById("pinItemId" + i) != null) {
								document.getElementById("pinItemId" + i).disabled = false;
							}
						}
						// document.getElementById('authPinUsrId').value = "";
						// document.getElementById('authPinPasswdId').value =
						// "";
					}
				},
				onFailure : function() {
					alert('Something went wrong...')
				}
			});
}

function deleteUser() {
	// var x = document.getElementById("userId");
	// x.remove(x.selectedIndex);

	var userObj = document.getElementById("userId");
	var userId = userObj.options[userObj.selectedIndex].id;
	var userNm = userObj.options[userObj.selectedIndex].text;
	
	var selIndx = userObj.selectedIndex;

	if (userId == 0) {
		return;
	}

	var url = 'deleteUser.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			userId : userId
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert('User deleted.');
			userObj = document.getElementById("userId");
			userObj.remove(selIndx);

		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function createNewUser() {
	var user = document.getElementById('createUserId').value;
	var passwd = document.getElementById('createPasswdId').value;

	if (user == '' || passwd == '') {
		return;
	}

	var url = 'createNewUser.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			user : user,
			passwd : passwd
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";

			// alert('User created.');
			// alert(response);
			if (response == 'false') {
				alert('Try a different user name.');
			} else {
				alert('User created.');

				var respArr = response.split('##');

				var userObj = document.getElementById("userId");
				var option = document.createElement("option");
				option.id = respArr[0];
				option.text = respArr[1];
				userObj.add(option);
			}
			document.getElementById('createUserId').value = "";
			document.getElementById('createPasswdId').value = "";
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function manualAddItem() {
	// alert('hi');
	var itemNm = document.getElementById('manualItemId').value;
	var itemQuant = document.getElementById('manualQuantityId').value;
	var itemExpiry = document.getElementById('manualExpiryId').value;

	if (itemNm.length < 1) {
		return;
	}

	var catObj = document.getElementById('categoryManualDropId');
	var catId = catObj.options[catObj.selectedIndex].id;
	var catNm = catObj.options[catObj.selectedIndex].text;

	// alert(catId);

	var url = 'manualInvUpdate.action';
	new Ajax.Request(
			url,
			{
				method : 'post',
				parameters : {
					itemNm : itemNm,
					itemQuant : itemQuant,
					itemExpiry : itemExpiry,
					catId : catId
				},
				onSuccess : function(transport) {
					var response = transport.responseText || "no response text";
					// alert(response);

					document.getElementById('manualItemId').value = "";
					document.getElementById('manualQuantityId').value = "";
					document.getElementById('manualExpiryId').value = "";
					document.getElementById('manualExpiryId').placeholder = 'mm-dd-yyyy';
					var catObj = document
							.getElementById('categoryManualDropId');
					setSelectedValue(catObj, "--Category--");

					alert("Inventory updated.");
					displayInventory();
					alert("Expired/expiring grid updated.");
					displayExpiredExpiring();
					alert("Shopping Grid updated.");
					displayShoppingGrid();
				},
				onFailure : function() {
					alert('Something went wrong...')
				}
			});
}

function displayProviders() {
	var url = 'getAllProviders.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {

		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			document.getElementById('providerdiv').style.display = 'inline';
			document.getElementById('providerdiv').innerHTML = response;

		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function addNewProvider() {
	// alert('add new provider');
	var provObj = document.getElementById("potentialProvidersId");
	var provId = provObj.options[provObj.selectedIndex].id;
	var provNm = provObj.options[provObj.selectedIndex].text;
	// alert('id: '+provId+', provNm: '+provNm);
	if (provId == 0) {
		return;
	}
	var url = 'addProvider.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			provId : provId,
			provNm : provNm
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			displayProviders();
			displayOrdering();
		},
		onFailure : function() {
			alert('Something went wrong add new...')
		}
	});
}

function deleteProvider(id, val) {
	// alert('delete new provider: '+id+', val: '+val);
	var url = 'deleteProvider.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			provId : id,
			provNm : val
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			displayProviders();
			displayOrdering();
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function pinItem(itemNm) {
	// alert('pinVal: '+pinVal);
	var url = 'pinItemInventory.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			itemNm : itemNm
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			displayInventory();
			displayExpiredExpiring();
			// setTimeout(displayPin, 1000);
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function displayPin() {
	// alert('pinValue: '+pinValue);
	if (pinValue == 'N') {
		document.getElementById('pinThresDivId').style.display = 'none';
		document.getElementById('pinQuanDivId').style.display = 'none';
		document.getElementById('pinUpdateDivId').style.display = 'none';
	} else if (pinValue == 'Y') {
		document.getElementById('pinThresDivId').style.display = 'inline';
		document.getElementById('pinQuanDivId').style.display = 'inline';
		document.getElementById('pinUpdateDivId').style.display = 'inline';
	}
}

function updatePinData(index, itemNm) {
	var pinThres = document.getElementById('pinThresTextIdY' + index).value;
	var pinQuant = document.getElementById('pinQuantityTextIdY' + index).value;

	var url = 'updatePinDataInventory.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			pinThres : pinThres,
			pinQuant : pinQuant,
			itemNm : itemNm
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			alert('Inventory updated.');
			displayInventory();
			alert('Expired, expiring grid updated.');
			displayExpiredExpiring();
			alert('Processing orders updated.');
			displayProcessedUndProcessed();
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function addItem(itemId) {
	var url = 'addItemInventory.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			itemId : itemId
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			displayInventory();
			displayExpiredExpiring();
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function deleteItem(itemNm) {
	// alert('in delete');
	var url = 'deleteItemInventory.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			itemNm : itemNm
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			displayInventory();
			displayExpiredExpiring();
			displayProcessedUndProcessed();
			displayShoppingGrid();
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function displayOrdering() {
	var url = 'displayOrdering.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {

		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			document.getElementById('orderingdiv').style.display = 'inline';
			document.getElementById('orderingdiv').innerHTML = response;
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}
// called when category is selected
function populateProducts() {
	// alert('populateProducts');
	var catObj = document.getElementById("categoryDropId");
	var catId = catObj.options[catObj.selectedIndex].id;
	var catNm = catObj.options[catObj.selectedIndex].text;
	// alert('id: '+catId+', catNm: '+catNm);
	if (catId == 0) {
		var prodObj = document.getElementById("productsDropId");
		var quantObj = document.getElementById("quantityDropId");
		setSelectedValue(prodObj, "--Products--");
		setSelectedValue(quantObj, "--Quantity--");
		var prodPricObj = document.getElementById("provdPriceDropId");
		setSelectedValue(prodPricObj, "--Vendr:Price:DelvDays--");
		return;
	}
	var url = 'populateProducts.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			catId : catId
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			document.getElementById('orderingdiv').style.display = 'inline';
			document.getElementById('orderingdiv').innerHTML = response;

			catObj = document.getElementById("categoryDropId");
			setSelectedValue(catObj, catNm);
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}
// called when product is selected
function resetQuantProvPrice() {
	var prodObj = document.getElementById("productsDropId");
	var prodId = prodObj.options[prodObj.selectedIndex].id;
	if (prodId == 0) {
		var quantObj = document.getElementById("quantityDropId");
		var prodPricObj = document.getElementById("provdPriceDropId");
		setSelectedValue(quantObj, "--Quantity--");
		setSelectedValue(prodPricObj, "--Vendr:Price:DelvDays--");
	}
}
// called when quantity is selected
function populateVendorPrice() {
	var catObj = document.getElementById("categoryDropId");
	var catId = catObj.options[catObj.selectedIndex].id;
	var catNm = catObj.options[catObj.selectedIndex].text;

	var prodObj = document.getElementById("productsDropId");
	var prodId = prodObj.options[prodObj.selectedIndex].id;
	var prodNm = prodObj.options[prodObj.selectedIndex].text;

	var quantObj = document.getElementById("quantityDropId");
	var quantId = quantObj.options[quantObj.selectedIndex].id;
	var quant = quantObj.options[quantObj.selectedIndex].text;

	if (quantId == 0) {
		var prodPricObj = document.getElementById("provdPriceDropId");
		setSelectedValue(prodPricObj, "--Vendr:Price:DelvDays--");
		return;
	}

	if (prodId == 0) {
		var quantObj = document.getElementById("quantityDropId");
		var prodPricObj = document.getElementById("provdPriceDropId");
		setSelectedValue(quantObj, "--Quantity--");
		setSelectedValue(prodPricObj, "--Vendr:Price:DelvDays--");
		return;
	}

	var url = 'populateVendors.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			catId : catId,
			provNm : prodNm,
			quantId : quant
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			document.getElementById('orderingdiv').style.display = 'inline';
			document.getElementById('orderingdiv').innerHTML = response;

			catObj = document.getElementById("categoryDropId");
			prodObj = document.getElementById("productsDropId");
			quantObj = document.getElementById("quantityDropId");
			setSelectedValue(catObj, catNm);
			setSelectedValue(prodObj, prodNm);
			setSelectedValue(quantObj, quant);
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function setSelectedValue(selectObj, valueToSet) {
	// alert('selectObj: '+selectObj+', valueToSet: '+valueToSet);
	for (var i = 0; i < selectObj.options.length; i++) {
		// alert(selectObj.options[i].text + '' + valueToSet);
		if (selectObj.options[i].text == valueToSet) {
			selectObj.options[i].selected = true;
			return;
		}
	}
}

function addItemToList() {
	var catObj = document.getElementById("categoryDropId");
	var catId = catObj.options[catObj.selectedIndex].id;
	var catNm = catObj.options[catObj.selectedIndex].text;

	var prodObj = document.getElementById("productsDropId");
	var prodId = prodObj.options[prodObj.selectedIndex].id;
	var prodNm = prodObj.options[prodObj.selectedIndex].text;

	var quantObj = document.getElementById("quantityDropId");
	var quantId = quantObj.options[quantObj.selectedIndex].id;
	var quant = quantObj.options[quantObj.selectedIndex].text;

	var vendorObj = document.getElementById("provdPriceDropId");
	var vendorId = vendorObj.options[vendorObj.selectedIndex].id;
	var vendorText = vendorObj.options[vendorObj.selectedIndex].text;

	if (catId == 0 || prodId == 0 || quantId == 0 || vendorId == 0) {
		return 0;
	}

	var url = 'addItemToShoppingList.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			catId : catId,
			prodNm : prodNm,
			quant : quant,
			vendorId : vendorId,
			vendorText : vendorText
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			displayShoppingGrid();
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function displayShoppingGrid() {
	var url = 'displayShoppingGrid.action';
	new Ajax.Request(
			url,
			{
				method : 'post',
				parameters : {

				},
				onSuccess : function(transport) {
					var response = transport.responseText || "no response text";
					// alert(response);
					// alert(document.getElementById('shoppingListDivId'));
					document.getElementById('shoppingListDivId').style.display = 'inline';
					document.getElementById('shoppingListDivId').innerHTML = response;

					// alert(document.getElementById("authPinUsrId"));
					// alert(document.getElementById("authPinPasswdId"));
//					if (document.getElementById("authPinUsrId") != null
//							&& document.getElementById("authPinPasswdId") != null) {
//						// alert(document.getElementById("authPinUsrId").value);
//						// alert(document.getElementById("authPinUsrId").value);
//						var userVal = document.getElementById("authPinUsrId").value;
//						var passwd = document.getElementById("authPinPasswdId").value;
//						// alert('user trim: '+userVal.trim());
//						if (userVal != null && userVal != ""
//								&& userVal.trim().length > 0) {
//							document.getElementById("authPlaceOrdUsrId").value = userVal;
//							document.getElementById("authPlaceOrdPasswdId").value = passwd;
//						}
//					}
				},
				onFailure : function() {
					alert('Something went wrong...')
				}
			});
}

function authenticatePlaceOrder() {
	var user = document.getElementById('authPlaceOrdUsrId').value;
	var passwd = document.getElementById('authPlaceOrdPasswdId').value;

	if (user == '' || passwd == '') {
		alert('Invalid credentials');
		return;
	}

	var url = 'validatePlaceOrder.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			user : user,
			passwd : passwd
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);

			if (response == 'true') {
				updateShopGrid();
//				if (document.getElementById("authPinUsrId") != null
//						&& document.getElementById("authPinPasswdId") != null) {
//					document.getElementById("authPinUsrId").value = user;
//					document.getElementById("authPinPasswdId").value = passwd;
//				}
			} else {
				alert('Invalid credentials');
				document.getElementById('authPlaceOrdUsrId').value = "";
				document.getElementById('authPlaceOrdPasswdId').value = "";
			}
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function updateShopGrid() {
	var url = 'updateShoppingItemsNtoY.action';
	new Ajax.Request(
			url,
			{
				method : 'post',
				parameters : {
					placeOrder : 'Y'
				},
				onSuccess : function(transport) {
					var response = transport.responseText || "no response text";
					// alert(response);
					// alert(document.getElementById('shoppingListDivId'));
					document.getElementById('shoppingListDivId').style.display = 'inline';
					document.getElementById('shoppingListDivId').innerHTML = response;
					displayShoppingGrid();
					displayProcessedUndProcessed();
					displayOrdering();

					var catObj = document.getElementById("categoryDropId");
					var prodObj = document.getElementById("productsDropId");
					var quantObj = document.getElementById("quantityDropId");
					var provdPriceDropObj = document
							.getElementById("provdPriceDropId");

					if (catObj != null) {
						setSelectedValue(catObj, "--Category--")
					}

					if (prodObj != null) {
						setSelectedValue(prodObj, "--Products--")
					}

					if (quantObj != null) {
						setSelectedValue(quantObj, "--Quantity--")
					}

					if (provdPriceDropObj != null) {
						setSelectedValue(provdPriceDropObj, "--Vendr:Price:DelvDays--")
					}
				},
				onFailure : function() {
					alert('Something went wrong...')
				}
			});
}

function displayProcessedUndProcessed() {
	var url = 'displayProcessedUndProcessed.action';
	new Ajax.Request(
			url,
			{
				method : 'post',
				parameters : {

				},
				onSuccess : function(transport) {
					var response = transport.responseText || "no response text";
					// alert(response);
					// alert(document.getElementById('shoppingListDivId'));
					document.getElementById('processUnderprocssdiv').style.display = 'inline';
					document.getElementById('processUnderprocssdiv').innerHTML = response;

					var underprocessingDivGrid = document
							.getElementById("processingDivId");
					var processedDivGrid = document
							.getElementById("underProcessingDivId");

					adjustDivOverflow(underprocessingDivGrid);
					adjustDivOverflow(processedDivGrid);
				},
				onFailure : function() {
					alert('Something went wrong...')
				}
			});
}

function markArrivedInvShopGrid() {
	// alert('hi');
	var unPrsObj = document.getElementById("underProcessindDrpId");
	var unPrsId = unPrsObj.options[unPrsObj.selectedIndex].id;
	// alert('unPrsId: '+ unPrsId);
	if (unPrsId == 0) {
		return;
	}

	var url = 'updateItemsUProssdtoProssd.action';
	new Ajax.Request(
			url,
			{
				method : 'post',
				parameters : {
					sid : unPrsId,
					itemArrived : 'Y'
				},
				onSuccess : function(transport) {
					var response = transport.responseText || "no response text";
					// alert(response);
					// alert(document.getElementById('shoppingListDivId'));
					document.getElementById('processUnderprocssdiv').style.display = 'inline';
					document.getElementById('processUnderprocssdiv').innerHTML = response;

					var underprocessingDivGrid = document
							.getElementById("processingDivId");
					var processedDivGrid = document
							.getElementById("underProcessingDivId");

					displayInventory();

					adjustDivOverflow(underprocessingDivGrid);
					adjustDivOverflow(processedDivGrid);
					
				},
				onFailure : function() {
					alert('Something went wrong...')
				}
			});
}

function adjustDivOverflow(divObj) {
	// alert(divObj);
	if (divObj.offsetHeight > 200) {
		divObj.style.height = "200px";
		divObj.style.overflow = "auto";
	}
}

function displayExpiredExpiring() {
	var url = 'displayExpiredExpiring.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {

		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			// alert(document.getElementById('shoppingListDivId'));
			document.getElementById('expirationdiv').style.display = 'inline';
			document.getElementById('expirationdiv').innerHTML = response;

		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function clearProcessedHist() {
	var url = 'clearProcessedHist.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {

		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			// alert(response);
			displayShoppingGrid();
			displayProcessedUndProcessed();
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function removeFromShopinList(sid) {
	//alert('delete: '+sid);
	var url = 'removeFromShopinList.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			sid : sid
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			//alert(response);
			displayShoppingGrid();
			displayProcessedUndProcessed();
			displayPromotions();
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function removeFromShopinListY(sid) {
	//alert('delete: '+sid);
	var url = 'removeFromShopinListY.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			sid : sid
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			//alert(response);
			//displayShoppingGrid();
			displayProcessedUndProcessed();
			//displayPromotions();
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}

function addPromotions(promId){
	var url = 'addPromotions.action';
	new Ajax.Request(url, {
		method : 'post',
		parameters : {
			promId : promId
		},
		onSuccess : function(transport) {
			var response = transport.responseText || "no response text";
			//alert(response);
			displayShoppingGrid();
			displayPromotions();
		},
		onFailure : function() {
			alert('Something went wrong...')
		}
	});
}