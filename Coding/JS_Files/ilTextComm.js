function revealComment(id) {
	var lineID = id.slice(4);
	var buttonID = document.getElementById(id).nextElementSibling.nextElementSibling.nextElementSibling.getAttribute("id");
	var tableID = document.getElementById(id).nextElementSibling.nextElementSibling.getAttribute("id");
	var button = document.getElementById(buttonID);
	var table = document.getElementById(tableID);
	button.removeAttribute("hidden");
	document.getElementById(id).nextElementSibling.nextElementSibling.removeAttribute("hidden");
	var plus = document.getElementById(id);
	plus.innerHTML = "<b>-</b>";
	plus.setAttribute("onclick", "hideComment(this.id)");
	var plusBreak;
	if(id.includes('_dip')){
		var baseID = id.split('_', 1)
		var plusBreak = document.getElementById(baseID + "br_dip");
	}
	else{
	var plusBreak = document.getElementById(id + "br");
	}
	plusBreak.removeAttribute("hidden");
}

function hideComment(id) {
	var lineID = id.slice(4);
	var buttonID = document.getElementById(id).nextElementSibling.nextElementSibling.nextElementSibling.getAttribute("id");
	var button = document.getElementById(buttonID);
	button.setAttribute("hidden", "hidden");
	var plus = document.getElementById(id);
	plus.innerHTML = "<b>+</b>";
	plus.setAttribute("onclick", "revealComment(this.id)");
	var tableNode = document.getElementById(id).nextElementSibling.nextElementSibling;
	tableNode.setAttribute("hidden", "hidden");
	var hasComment;
	if (tableNode.hasChildNodes()){
		if(tableNode.childNodes[0].hasChildNodes()){
			hasComment = 1;
		}
		else{
			hasComment = 0;
		}
		}
	else{
		hasComment = 0;
	}
	if (hasComment == 1) {
		document.getElementById(id).style.backgroundColor = "Khaki";
	} else {
		document.getElementById(id).style.backgroundColor = "";
	}
	var plusBreak;
	if(id.includes('_dip')){
		var baseID = id.split('_', 1)
		var plusBreak = document.getElementById(baseID + "br_dip");
	}
	else{
	var plusBreak = document.getElementById(id + "br");
	}
	plusBreak.setAttribute("hidden", "hidden");
}

function disableWordFunctions(id) {
	if(document.getElementById(id).parentNode.tagName == "A"){
	var word = document.getElementById(id).parentNode;
	word.setAttribute("onclick", "");
	word.setAttribute("onmouseover", "");
	word.setAttribute("onmouseout", "");
	}
	else{
		return;
	}
}

function enableWordFunctions(id) {
	if(document.getElementById(id).parentNode.tagName == "A"){
	var word = document.getElementById(id).parentNode;
	var wsButtons = document.getElementsByClassName("ws");
	var csButtons = document.getElementsByClassName("cs");
	if (wsButtons[0].hasAttribute("disabled")) {
		word.setAttribute("onclick", "addSlip(this.id)");
	} else if (csButtons[0].hasAttribute("disabled")) {
		word.setAttribute("onclick", "wordSearch(this.id)");
	} else {
		word.setAttribute("onclick", "addSlip(this.id)");
	}
	}
	else{
		return;
	}
	word.setAttribute("onmouseover", "hilite(this.id)");
	word.setAttribute("onmouseout", "dhilite(this.id)");
}