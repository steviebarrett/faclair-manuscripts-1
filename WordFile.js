var rowNo = 0;

function newRow() {
	rowNo++;
}

function createTable() {
	var table = document.createElement("table");
	document.getElementsByTagName("table");
	var script = document.createElement("script");
	var anchor = document.createElement("a");
	var tblBorder = document.createAttribute ("border");
	tblBorder.value = "solid 0.1mm black";
	table.setAttributeNode(tblBorder);
	var tblId = document.createAttribute ("id");
	tblId.value = "slipTable";
	table.setAttributeNode(tblId);
	var row1 = table.insertRow(0);
	var rowID = document.createAttribute("id");
	rowID.value = rowNo;
	newRow();
	row1.setAttributeNode(rowID);
	var r1col1 = row1.insertCell(0);
	r1col1.outerHTML = "<th><b>Form</b></th>";
	var r1col2 = row1.insertCell(1);
	r1col2.outerHTML = "<th><b>MS Ref.</b></th>";
	var r1col3 = row1.insertCell(2);
	r1col3.outerHTML = "<th><b>MS Context</b></th>";
	var r1col4 = row1.insertCell(3);
	r1col4.outerHTML = "<th><b>Text Form</b></th>";
	var r1col5 = row1.insertCell(4);
	r1col5.outerHTML = "<th><b>Issue(s)?</b></th>";
	var r1col6 = row1.insertCell(5);
	r1col6.outerHTML = "<th><b>Abbrevs</b></th>";
	var r1col7 = row1.insertCell(6);
	r1col7.outerHTML = "<th><b>Scribe</b></th>";
	var r1col8 = row1.insertCell(7);
	r1col8.outerHTML = "<th><b>Scribe Date</b></th>";
	var r1col9 = row1.insertCell(8);
	r1col9.outerHTML = "<th><b>PoS</b></th>";
	var r1col10 = row1.insertCell(9);
	r1col10.outerHTML = "<th><b>Lemma (eDIL)</b></th>";
	var r1col11 = row1.insertCell(10);
	r1col11.outerHTML = "<th><b>URI (eDIL)</b></th>";
	var r1col12 = row1.insertCell(11);
	r1col12.outerHTML = "<th><b>Lemma (Dwellys)</b></th>";
	var r1col13 = row1.insertCell(12);
	r1col13.outerHTML = "<th><b>HDSG Slip</b></th>";
	var r1col14 = row1.insertCell(13);
	r1col14.outerHTML = "<th><button onclick='delCol()'>Del Col</button><br/><button onclick='delRow(this)'>Del Row</button></th>";
	var opened = window.open("", "FnaG MS Corpus Word Table");
	opened.document.body.appendChild(table);
	opened.document.head.appendChild(script);
	opened.document.body.appendChild(anchor);
	anchor.outerHTML = "<a id='dlink'  style='display:none;'></a>";
	script.innerHTML = "function delRow(r) \
	{ \
	var i = r.parentNode.parentNode.rowIndex; \
	document.getElementById('slipTable').deleteRow(i); \
	}; \
	function delCol() { \
	var rowCount = document.getElementById('slipTable').firstChild.childElementCount; \
	for (j = 0; j < rowCount; j++) { \
	var row = document.getElementsByTagName('tr')[j]; \
	row.deleteCell(13); \
	}\
	}\
	function abbrHilite(id) { \
	var ids = id.split(','); \
	var formID = ids[0]; \
	var rowID = ids[1]; \
	var abbrID = ids[2]; \
	var abbrSpl = abbrID.split('', 2);\
	var abbrPOS = abbrSpl[1];\
	var row = document.getElementById(rowID);\
	var form = row.cells[0].children[0];\
	var abbr = form.getElementsByTagName('i')[abbrPOS];\
	abbr.style.backgroundColor = 'GreenYellow';\
	}; \
	function abbrDeHilite(id) { \
	var ids = id.split(','); \
	var formID = ids[0]; \
	var rowID = ids[1]; \
	var abbrID = ids[2]; \
	var abbrSpl = abbrID.split('', 2);\
	var abbrPOS = abbrSpl[1];\
	var row = document.getElementById(rowID);\
	var form = row.cells[0].children[0];\
	var abbr = form.getElementsByTagName('i')[abbrPOS];\
	abbr.style.backgroundColor = 'White';\
	}; \
	";
	var type = document.createAttribute("type");
	type.value = "text/javascript";
	script.setAttributeNode(type);
	var jquery = document.createAttribute("src");
	jquery.value = "http://code.jquery.com/jquery-1.7.1.min.js";
	script.setAttributeNode(jquery);
}

function addSlip(id) {
	var opened = window.open("", "FnaG MS Corpus Word Table");
	var createdTable = opened.document.getElementById("slipTable");
	var el = document.getElementById(id);
	el.style.backgroundColor = "White";
	var form = el.outerHTML;
	var lem = el.getAttribute('lemma');
	var an = el.getAttribute('ana');
	var msref = el.getAttribute('ref');
	var lref = el.getAttribute('lemmaRef');
	var hnd = el.getAttribute('hand');
	var date = el.getAttribute('date');
	var prob = el.getAttribute('cert');
	var abbrArray = el.getAttribute('abbrRefs').split(" ");
	var abbrList = abbrArray.join('</a></li><li><a>');
	var abbrListFull = '<li><a>' + abbrList + '</a></li>';
	var listID = 'li.' + id;
	var abbr = '<ul id="' + listID + '" style="list-style: none;margin:0;padding:0;">' + abbrListFull + '</ul>';
	var med = el.getAttribute('medium');
	var el_plus_1;
	if (el == el.parentNode.lastElementChild) {
		el_plus_1 = "";
	} else if (el.nextElementSibling == null) {
		el_plus_1 = "";
	} else {
		el_plus_1 = el.nextElementSibling
	}
	var el_minus_1;
	if (el == el.parentNode.firstElementChild) {
		el_minus_1 = "";
	} else if (el.previousElementSibling == null) {
		el_minus_1 = "";
	} else {
		el_minus_1 = el.previousElementSibling
	}
	var el_plus_2;
	if (el == el.parentNode.lastElementChild) {
		el_plus_2 = "";
	} else if (el.nextElementSibling == el.parentNode.lastElementChild) {
		el_plus_2 = "";
	} else if (el.nextElementSibling.nextElementSibling == null) {
		el_plus_2 = "";
	} else {
		el_plus_2 = el.nextElementSibling.nextElementSibling
	}
	var el_minus_2;
	if (el == el.parentNode.firstElementChild) {
		el_minus_2 = "";
	} else if (el.previousElementSibling == el.parentNode.firstElementChild) {
		el_minus_2 = "";
	} else if (el.previousElementSibling.previousElementSibling == null) {
		el_minus_2 = "";
	} else {
		el_minus_2 = el.previousElementSibling.previousElementSibling
	}
	var el_plus_3;
	if (el == el.parentNode.lastElementChild) {
		el_plus_3 = "";
	} else if (el.nextElementSibling == el.parentNode.lastElementChild) {
		el_plus_3 = "";
	} else if (el.nextElementSibling.nextElementSibling == null) {
		el_plus_3 = "";
	} else if (el.nextElementSibling.nextElementSibling.nextElementSibling == null) {
		el_plus_3 = "";
	} else {
		el_plus_3 = el.nextElementSibling.nextElementSibling.nextElementSibling
	}
	var el_minus_3;
	if (el == el.parentNode.firstElementChild) {
		el_minus_3 = "";
	} else if (el.previousElementSibling == el.parentNode.firstElementChild) {
		el_minus_3 = "";
	} else if (el.previousElementSibling.previousElementSibling == null) {
		el_minus_3 = "";
	} else if (el.previousElementSibling.previousElementSibling.previousElementSibling == null) {
		el_minus_3 = "";
	} else {
		el_minus_3 = el.previousElementSibling.previousElementSibling.previousElementSibling
	}
	var el_plus_4;
	if (el == el.parentNode.lastElementChild) {
		el_plus_4 = "";
	} else if (el.nextElementSibling == el.parentNode.lastElementChild) {
		el_plus_4 = "";
	} else if (el.nextElementSibling.nextElementSibling == null) {
		el_plus_4 = "";
	} else if (el.nextElementSibling.nextElementSibling.nextElementSibling == null) {
		el_plus_4 = "";
	} else if (el.nextElementSibling.nextElementSibling.nextElementSibling.nextElementSibling == null) {
		el_plus_4 = "";
	} else {
		el_plus_4 = el.nextElementSibling.nextElementSibling.nextElementSibling.nextElementSibling
	}
	var el_minus_4;
	if (el == el.parentNode.firstElementChild) {
		el_minus_4 = "";
	} else if (el.previousElementSibling == el.parentNode.firstElementChild) {
		el_minus_4 = "";
	} else if (el.previousElementSibling.previousElementSibling == null) {
		el_minus_4 = "";
	} else if (el.previousElementSibling.previousElementSibling.previousElementSibling == null) {
		el_minus_4 = "";
	} else if (el.previousElementSibling.previousElementSibling.previousElementSibling.previousElementSibling == null) {
		el_minus_4 = "";
	} else {
		el_minus_4 = el.previousElementSibling.previousElementSibling.previousElementSibling.previousElementSibling
	}
	var el_plus_5;
	if (el == el.parentNode.lastElementChild) {
		el_plus_5 = "";
	} else if (el.nextElementSibling == el.parentNode.lastElementChild) {
		el_plus_5 = "";
	} else if (el.nextElementSibling.nextElementSibling == null) {
		el_plus_5 = "";
	} else if (el.nextElementSibling.nextElementSibling.nextElementSibling == null) {
		el_plus_5 = "";
	} else if (el.nextElementSibling.nextElementSibling.nextElementSibling.nextElementSibling == null) {
		el_plus_5 = "";
	} else if (el.nextElementSibling.nextElementSibling.nextElementSibling.nextElementSibling.nextElementSibling == null) {
		el_plus_5 = "";
	} else {
		el_plus_5 = el.nextElementSibling.nextElementSibling.nextElementSibling.nextElementSibling.nextElementSibling
	}
	var el_minus_5;
	if (el == el.parentNode.firstElementChild) {
		el_minus_5 = "";
	} else if (el.previousElementSibling == el.parentNode.firstElementChild) {
		el_minus_5 = "";
	} else if (el.previousElementSibling.previousElementSibling == null) {
		el_minus_5 = "";
	} else if (el.previousElementSibling.previousElementSibling.previousElementSibling == null) {
		el_minus_5 = "";
	} else if (el.previousElementSibling.previousElementSibling.previousElementSibling.previousElementSibling == null) {
		el_minus_5 = "";
	} else if (el.previousElementSibling.previousElementSibling.previousElementSibling.previousElementSibling.previousElementSibling == null) {
		el_minus_5 = "";
	} else {
		el_minus_5 = el.previousElementSibling.previousElementSibling.previousElementSibling.previousElementSibling.previousElementSibling
	}
	var el_plus_1Id;
	if (el_plus_1.id == null) {
		el_plus_1Id = "";
	} else {
		el_plus_1Id = el_plus_1.id
	}
	var el_minus_1Id;
	if (el_minus_1.id == null) {
		el_minus_1Id = "";
	} else {
		el_minus_1Id = el_minus_1.id
	}
	var el_plus_2Id;
	if (el_plus_2.id == null) {
		el_plus_2Id = "";
	} else {
		el_plus_2Id = el_plus_2.id
	}
	var el_minus_2Id;
	if (el_minus_2.id == null) {
		el_minus_2Id = "";
	} else {
		el_minus_2Id = el_minus_2.id
	}
	var el_plus_3Id;
	if (el_plus_3.id == null) {
		el_plus_3Id = "";
	} else {
		el_plus_3Id = el_plus_3.id
	}
	var el_minus_3Id;
	if (el_minus_3.id == null) {
		el_minus_3Id = "";
	} else {
		el_minus_3Id = el_minus_3.id
	}
	var el_plus_4Id;
	if (el_plus_4.id == null) {
		el_plus_4Id = "";
	} else {
		el_plus_4Id = el_plus_4.id
	}
	var el_minus_4Id;
	if (el_minus_4.id == null) {
		el_minus_4Id = "";
	} else {
		el_minus_4Id = el_minus_4.id
	}
	var el_plus_5Id;
	if (el_plus_5.id == null) {
		el_plus_5Id = "";
	} else {
		el_plus_5Id = el_plus_5.id
	}
	var el_minus_5Id;
	if (el_minus_5.id == null) {
		el_minus_5Id = "";
	} else {
		el_minus_5Id = el_minus_5.id
	}
	var el_plus_1node;
	if (el_plus_1Id === "") {
		el_plus_1node = "";
	} else {
		el_plus_1node = document.getElementById(el_plus_1Id).outerHTML
	}
	var el_minus_1node;
	if (el_minus_1Id === "") {
		el_minus_1node = "";
	} else {
		el_minus_1node = document.getElementById(el_minus_1Id).outerHTML
	}
	var el_plus_2node;
	if (el_plus_2Id === "") {
		el_plus_2node = "";
	} else {
		el_plus_2node = document.getElementById(el_plus_2Id).outerHTML
	}
	var el_minus_2node;
	if (el_minus_2Id === "") {
		el_minus_2node = "";
	} else {
		el_minus_2node = document.getElementById(el_minus_2Id).outerHTML
	}
	var el_plus_3node;
	if (el_plus_3Id === "") {
		el_plus_3node = "";
	} else {
		el_plus_3node = document.getElementById(el_plus_3Id).outerHTML
	}
	var el_minus_3node;
	if (el_minus_3Id === "") {
		el_minus_3node = "";
	} else {
		el_minus_3node = document.getElementById(el_minus_3Id).outerHTML
	}
	var el_plus_4node;
	if (el_plus_4Id === "") {
		el_plus_4node = "";
	} else {
		el_plus_4node = document.getElementById(el_plus_4Id).outerHTML
	}
	var el_minus_4node;
	if (el_minus_4Id === "") {
		el_minus_4node = "";
	} else {
		el_minus_4node = document.getElementById(el_minus_4Id).outerHTML
	}
	var el_plus_5node;
	if (el_plus_5Id === "") {
		el_plus_5node = "";
	} else {
		el_plus_5node = document.getElementById(el_plus_5Id).outerHTML
	}
	var el_minus_5node;
	if (el_minus_5Id === "") {
		el_minus_5node = "";
	} else {
		el_minus_5node = document.getElementById(el_minus_5Id).outerHTML
	}
	var msref = el.getAttribute('ref');
	var row = createdTable.insertRow(-1);
	row.style.fontSize = "medium";
	var rowID = document.createAttribute("id");
	rowID.value = "r" + rowNo;
	row.setAttributeNode(rowID);
	newRow();
	var rcol1 = row.insertCell(0);
	rcol1.innerHTML = form;
	var rcol2 = row.insertCell(1);
	rcol2.innerHTML = msref;
	var textForm;
	if (el.firstChild.innerText == "/alt") {
		var sicForm = el.lastChild.innerHTML;
		var altTag = rcol1.firstElementChild.firstElementChild;
		altTag.setAttribute("hidden", "hidden");
		rcol1.firstElementChild.innerHTML = sicForm;
		var sicNode = rcol1.firstElementChild.outerHTML;
		textForm = sicNode;
	} else {
		textForm = form
	}
	var context = el_minus_5node.concat(' ', el_minus_4node, ' ', el_minus_3node, ' ', el_minus_2node, ' ', el_minus_1node, ' ', '<b>' + textForm + '</b>', ' ', el_plus_1node, ' ', el_plus_2node, ' ', el_plus_3node, ' ', el_plus_4node, ' ', el_plus_5node);
	var rcol3 = row.insertCell(2);
	rcol3.innerHTML = context;
	rcol3.style.fontSize = "smaller";
	if (el.firstChild.innerText == "/alt") {
		var choiceID = el.getAttribute("choicePOS").slice(3);
		var corrID = "corr" + choiceID;
		var corrForm = rcol3.querySelector("a[choicePOS=" + corrID +"]");
		corrForm.setAttribute("hidden", "hidden");
	}
	var rcol4 = row.insertCell(3);
	rcol4.innerHTML = med;
	var rcol5 = row.insertCell(4);
	rcol5.innerHTML = prob;
	var rcol6 = row.insertCell(5);
	rcol6.innerHTML = abbr;
	var lineCount = rcol6.firstChild.childElementCount;
	var i;
	for (i = 0; i < lineCount; i++) {
		var rID = rcol6.parentNode.getAttribute("id");
		var lineID = document.createAttribute("id");
		lineID.value = id + "," + rID + ",l" + i;
		rcol6.firstChild.getElementsByTagName("li")[i].setAttributeNode(lineID);
		var abbrAnch = rcol6.firstChild.getElementsByTagName("li")[i].firstChild;
		var URL = abbrAnch.innerHTML.startsWith("www.");
		var hiliteLinkIn = document.createAttribute("onmouseover");
		hiliteLinkIn.value = 'abbrHilite(this.id)';
		rcol6.firstChild.getElementsByTagName("li")[i].setAttributeNode(hiliteLinkIn);
		var hiliteLinkOut = document.createAttribute("onmouseout");
		hiliteLinkOut.value = 'abbrDeHilite(this.id)';
		rcol6.firstChild.getElementsByTagName("li")[i].setAttributeNode(hiliteLinkOut);
		if (URL) {
			var abbrURL = abbrAnch.innerHTML;
			var href = document.createAttribute("href");
			var target = document.createAttribute("target");
			href.value = 'https://' + abbrURL;
			target.value = 'https://' + abbrURL;
			abbrAnch.setAttributeNode(href);
			abbrAnch.setAttributeNode(target);
			var finText = abbrAnch.innerHTML.slice(23);
			abbrAnch.innerHTML = finText;
		} else {
			var abbrName = abbrAnch.innerHTML;
			var line = abbrAnch.parentNode;
			line.innerHTML = abbrName;
		}
	};
	var rcol7 = row.insertCell(6);
	rcol7.innerHTML = hnd;
	var rcol8 = row.insertCell(7);
	rcol8.innerHTML = date;
	var rcol9 = row.insertCell(8);
	rcol9.innerHTML = an;
	var rcol10 = row.insertCell(9);
	rcol10.innerHTML = lem;
	var rcol11 = row.insertCell(10);
	rcol11.innerHTML = '<a target="' + lref + '" href="' + lref + '">' + lref + '</a>';
	var finURI = rcol11.firstChild.innerHTML.slice(18);
	rcol11.firstChild.innerHTML = finURI;
	var rcol12 = row.insertCell(11);
	rcol12.innerHTML = "";
	var rcol13 = row.insertCell(12);
	rcol13.innerHTML = "";
	var rcol14 = row.insertCell(13);
	rcol14.outerHTML = '<td><button onclick="delRow(this)">Del Row</button></td>';
	opened.document.table.appendChild(tr);
}