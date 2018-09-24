var rowNo = 0;

function newRow() {
	rowNo++;
}

function getSessionID() {
	if(document.getElementById("root").hasAttribute("n")){
		var prevSessionID = document.getElementById("root").getAttribute("n");
		var sessionID = Number(prevSessionID) + 1;
		document.getElementById("root").setAttribute("n", sessionID);
	}
	else{
		var sessionIDattr = document.createAttribute("n");
		sessionIDattr.value = "1";
		document.getElementById("root").setAttributeNode(sessionIDattr);
		var sessionID = "1";
	}
}

function editComment(r) {
	var d = new Date();
	var utc = d.getTime();
	var ts = d.toUTCString();
	var rowID = r.parentNode.parentNode.id;
	var tblID = r.parentNode.parentNode.parentNode.parentNode.id;
	var id = tblID.split("t", 1);
	var initID = id + rowID + "init";
	var inputID = id + rowID + "input";
	var initCell = document.getElementById(rowID).childNodes[2];
	var inputCell = document.getElementById(rowID).childNodes[4];
	var initText = document.getElementById(rowID).childNodes[2].innerHTML;
	var inputText = document.getElementById(rowID).childNodes[4].innerHTML;
	initCell.innerHTML = "<input id='" + initID + "' value='" + initText + "'/>";
	inputCell.innerHTML = "<input id='" + inputID + "' value='" + inputText + "'/>";
	r.textContent = "Save";
	r.setAttribute("onclick", "saveComment(this)");
	document.getElementById(rowID).style.backgroundColor = "Khaki";
	document.getElementById(rowID).childNodes[3].setAttribute("id", id + rowID + "ed");
}

function saveComment(r) {
	var d = new Date();
	var utc = d.getTime();
	var ts = d.toUTCString();
	var rowID = r.parentNode.parentNode.id;
	var tblID = r.parentNode.parentNode.parentNode.parentNode.id;
	var id = tblID.split("t", 1);
	var initID = id + rowID + "init";
	var inputID = id + rowID + "input";
	var inputCell = document.getElementById(inputID).parentNode;
	var initText = document.getElementById(initID).value;
	document.getElementById(initID).parentNode.innerHTML = initText;
	var inputText = document.getElementById(inputID).value;
	document.getElementById(inputID).parentNode.innerHTML = inputText;
	var span = document.createAttribute("style");
	span.value = "width:650px";
	inputCell.setAttributeNode(span);
	var rowPos = document.getElementById(tblID).childNodes[0].childNodes.length;
	if (rowPos % 2 == 0) {
		document.getElementById(rowID).style.backgroundColor = "Lavender";
	} else {
		document.getElementById(rowID).style.backgroundColor = "Azure";
	}
	r.textContent = "Edit";
	r.setAttribute("onclick", "editComment(this)");
	if (document.getElementById(rowID).childNodes[3].hasAttribute("id")) {
		var commentRub = document.getElementById(rowID).childNodes[3];
		commentRub.innerHTML = "<b>Comment (<a style='background-color:Khaki' title='edited at " + ts + "'>ed.</a>):</b>";
	}
}

function delRow(r) {
	var d = new Date();
	var utc = d.getTime();
	var ts = d.toUTCString();
	var tblID = r.parentNode.parentNode.parentNode.parentNode.id;
	var i = r.parentNode.parentNode.rowIndex;
	document.getElementById(tblID).deleteRow(i);
};
function delCol() {
	var rowCount = document.getElementById(tblID).firstChild.childElementCount;
	for (j = 0; j < rowCount; j++) {
		var row = document.getElementsByTagName("tr")[j];
		row.deleteCell(5);
	}
}

function textComment (id) {
	var d = new Date();
	var utc = d.getTime();
	var ts = d.toUTCString();
	var button = document.getElementById(id);
	var table = button.previousElementSibling;
	var tableID = id + "tbl";
	var tableIDattr = document.createAttribute("id");
	tableIDattr.value = tableID;
	table.setAttributeNode(tableIDattr);
	var nextRow = table.insertRow(0);
	var sessionID = document.getElementById("root").getAttribute("n");
	var row = document.createAttribute("id");
	row.value = rowNo + "." + sessionID;
	newRow();
	nextRow.setAttributeNode(row);
	var rowID = row.value;
	nextRow.style.fontSize = '10px';
	var col1 = nextRow.insertCell(0);
	col1.innerHTML = ts;
	var col2 = nextRow.insertCell(1);
	col2.innerHTML = "<b>Name:</b>";
	var col3 = nextRow.insertCell(2);
	col3.innerHTML = "<input/>";
	var initID = document.createAttribute("id");
	initID.value = id + rowID + "init";
	col3.childNodes[0].setAttributeNode(initID);
	var col4 = nextRow.insertCell(3);
	col4.innerHTML = "<b>Comment:</b>";
	var col5 = nextRow.insertCell(4);
	col5.innerHTML = "<input/>";
	var inputID = document.createAttribute("id");
	inputID.value = id + rowID + "input";
	col5.childNodes[0].setAttributeNode(inputID);
	var inputSize = document.createAttribute("size");
	inputSize.value = "80";
	col5.childNodes[0].setAttributeNode(inputSize);
	var col6 = nextRow.insertCell(5);
	col6.innerHTML = "<button>Del.</button><br/><button>Save</button>";
	var delOnClick = document.createAttribute("onclick");
	delOnClick.value = 'delRow(this)';
	col6.childNodes[0].setAttributeNode(delOnClick);
	var delStyle = document.createAttribute("style");
	delStyle.value = "width:75px";
	col6.childNodes[0].setAttributeNode(delStyle);
	var saveOnClick = document.createAttribute("onclick");
	saveOnClick.value = "saveComment(this)";
	col6.childNodes[2].setAttributeNode(saveOnClick);
	var saveStyle = document.createAttribute("style");
	saveStyle.value = "width:75px;";
	col6.childNodes[2].setAttributeNode(saveStyle);
}