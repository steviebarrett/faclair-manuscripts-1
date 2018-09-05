var rowNo = 0;

function newRow() {
	rowNo++;
}

function createTable() {
	var table = document.createElement("table");
	var title = document.createElement("title");
	var d = new Date();
	var uuid = d.getTime();
	title.innerHTML = "eSlips" + uuid;
	var script = document.createElement("script");
	var anchor = document.createElement("a");
	var tblBorder = document.createAttribute ("border");
	tblBorder.value = "solid 0.1mm black";
	table.setAttributeNode(tblBorder);
	var tblId = document.createAttribute ("id");
	tblId.value = "slipTable";
	table.setAttributeNode(tblId);
	var tblStyle = document.createAttribute("style");
	tblStyle.value = "font-size:16px";
	table.setAttributeNode(tblStyle);
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
	r1col5.outerHTML = "<th><b>Issues?</b></th>";
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
	r1col11.outerHTML = "<th><b>Lemma (Dwellys)</b></th>";
	var r1col12 = row1.insertCell(11);
	r1col12.outerHTML = "<th><b>HDSG Slip</b></th>";
	var r1col13 = row1.insertCell(12);
	r1col13.outerHTML = "<th><b>URI</b></th>";
	var r1col14 = row1.insertCell(13);
	r1col14.outerHTML = "<th><button onclick='delCol()' style='width:75px'>Del Col</button><br/><button onclick='delRow(this)' style='width:75px'>Del Row</button></th>";
	var opened = window.open("", "FnaG MS Corpus Word Table");
	opened.document.body.appendChild(table);
	opened.document.head.appendChild(title);
	opened.document.head.appendChild(script);
	opened.document.body.appendChild(anchor);
	anchor.outerHTML = "<a id='dlink'  style='display:none;'></a>";
	script.innerHTML = "var d = new Date(); \
	var utc = d.getTime(); \
	var ts = d.toUTCString(); \
	function delRow(r) \
	{ \
	var i = r.parentNode.parentNode.rowIndex; \
	document.getElementById('slipTable').deleteRow(i); \
	}; \
	function delCol() { \
	var rowCount = document.getElementById('slipTable').firstChild.childElementCount; \
	for (j = 0; j < rowCount; j++) { \
	var row = document.getElementsByTagName('tr')[j]; \
	if(row.attributes[0].value == 'comment') {\
	row.deleteCell(5); \
	} \
	else \
	{ \
	row.deleteCell(13); \
	}\
	}\
	};\
	function saveComment(r) \
	{ \
	var d = new Date(); \
	var utc = d.getTime(); \
	var ts = d.toUTCString(); \
	var commentID = r.parentNode.parentNode.id; \
	var initText = document.getElementById(commentID + 'init').value; \
	document.getElementById(commentID).childNodes[2].innerHTML = initText; \
	var inputText = document.getElementById(commentID + 'input').value; \
	document.getElementById(commentID).childNodes[4].innerHTML = inputText; \
	document.getElementById(commentID).style.backgroundColor = 'Azure'; \
	if (document.getElementById(commentID).childNodes[3].hasAttribute('class')) \
	{ \
	document.getElementById(commentID).childNodes[3].innerHTML = '<b>Comment (<a>ed.</a>): </b>'; \
	var edts = document.createAttribute('title'); \
	edts.value = 'edited at ' + ts; \
	document.getElementById(commentID).childNodes[3].childNodes[0].childNodes[1].setAttributeNode(edts); \
	var edHilite = document.createAttribute('style'); \
	edHilite.value = 'background-color:Khaki'; \
	document.getElementById(commentID).childNodes[3].childNodes[0].childNodes[1].setAttributeNode(edHilite); \
	} \
	r.textContent = 'Edit'; \
	r.setAttribute('onclick', 'editComment(this)'); \
	}; \
	function editComment(r){ \
	var d = new Date(); \
	var utc = d.getTime(); \
	var ts = d.toUTCString(); \
	var row = r.parentNode.parentNode; \
	var commentID = r.parentNode.parentNode.id; \
	var initText = row.childNodes[2].textContent; \
	var inputText = row.childNodes[4].textContent; \
	var initCell = row.childNodes[2]; \
	var inputCell = row.childNodes[4]; \
	initCell.innerHTML = '<input/>'; \
	var initVal = document.createAttribute('value'); \
	initVal.value = initText; \
	initCell.childNodes[0].setAttributeNode(initVal); \
	var initID = document.createAttribute('id'); \
	initID.value = commentID + 'init'; \
	initCell.childNodes[0].setAttributeNode(initID); \
	inputCell.innerHTML = '<input/>'; \
	var inputVal = document.createAttribute('value'); \
	inputVal.value = inputText; \
	inputCell.childNodes[0].setAttributeNode(inputVal); \
	var inputID = document.createAttribute('id'); \
	inputID.value = commentID + 'input'; \
	inputCell.childNodes[0].setAttributeNode(inputID); \
	row.style.backgroundColor = 'Khaki'; \
	var edTag = document.createAttribute('class'); \
	edTag.value = 'ed'; \
	row.childNodes[3].setAttributeNode(edTag) ; \
	r.textContent = 'Save'; \
	r.setAttribute('onclick', 'saveComment(this)'); \
	}; \
	function abbrHilite(id) { \
	var ids = id.split(','); \
	var formID = ids[0]; \
	var rowID = ids[1]; \
	var abbrID = ids[2]; \
	var abbrSpl = abbrID.split('', 2);\
	var abbrPOS = abbrSpl[1];\
	var row = document.getElementById(rowID);\
	var form = row.cells[0].childNodes[0];\
	var abbr = form.getElementsByClassName('glyph')[abbrPOS];\
	if (abbr.hasAttribute('id')) {\
	if (abbr.getAttribute('cert') == 'high'){\
	abbr.style.backgroundColor = 'LawnGreen';\
	} \
	else if (abbr.getAttribute('cert') == 'medium') {\
	abbr.style.backgroundColor = 'Gold';\
	} \
	else if (abbr.getAttribute('cert') == 'low') {\
	abbr.style.backgroundColor = 'Salmon';\
	} \
	else {\
	abbr.style.backgroundColor = 'Silver';\
	} \
	} \
	else {\
	abbr.style.backgroundColor = 'white';\
	} \
	}; \
	function abbrDeHilite(id) { \
	var ids = id.split(','); \
	var formID = ids[0]; \
	var rowID = ids[1]; \
	var abbrID = ids[2]; \
	var abbrSpl = abbrID.split('', 2);\
	var abbrPOS = abbrSpl[1];\
	var row = document.getElementById(rowID);\
	var form = row.cells[0].childNodes[0];\
	var abbr = form.getElementsByClassName('glyph')[abbrPOS];\
	abbr.style.backgroundColor = 'White';\
	}; \
	function addComment(r) { \
	var d = new Date(); \
	var utc = d.getTime(); \
	var ts = d.toUTCString(); \
	wordRowID = r.parentNode.parentNode.id; \
	wordRowPos = document.getElementById(wordRowID).rowIndex; \
	var thisTable = document.getElementById('slipTable'); \
	var row2 = thisTable.insertRow(wordRowPos + 1); \
	row2.setAttribute('class', 'comment');\
	row2.style.fontSize = '12px'; \
	var d = new Date(); \
	var r2col1 = row2.insertCell(0); \
	r2col1.innerHTML = ts; \
	var commentID = document.createAttribute('id'); \
	commentID.value = utc; \
	row2.setAttributeNode(commentID); \
	var r2col2 = row2.insertCell(1); \
	r2col2.innerHTML = '<b>Name:</b>'; \
	var r2col3 = row2.insertCell(2); \
	r2col3.innerHTML = '<input/>'; \
	var initID = document.createAttribute('id'); \
	initID.value = commentID.value + 'init'; \
	r2col3.childNodes[0].setAttributeNode(initID); \
	var r2col4 = row2.insertCell(3); \
	r2col4.innerHTML = '<b>Comment:</b>'; \
	var r2col5 = row2.insertCell(4); \
	var span = document.createAttribute('colSpan'); \
	span.value = '9'; \
	r2col5.setAttributeNode(span); \
	r2col5.innerHTML = '<input/>'; \
	var inputSize = document.createAttribute('size'); \
	inputSize.value = '160'; \
	r2col5.firstChild.setAttributeNode(inputSize); \
	var inputID = document.createAttribute('id'); \
	inputID.value = commentID.value + 'input'; \
	r2col5.childNodes[0].setAttributeNode(inputID); \
	var r2col6 = row2.insertCell(5); \
	r2col6.innerHTML = '<button>Del.</button><br/><button>Save</button>'; \
	var delOnClick = document.createAttribute('onclick'); \
	delOnClick.value = 'delRow(this)'; \
	r2col6.childNodes[0].setAttributeNode(delOnClick); \
	var delStyle = document.createAttribute('style'); \
	delStyle.value = 'width:75px'; \
	r2col6.childNodes[0].setAttributeNode(delStyle); \
	var saveOnClick = document.createAttribute('onclick'); \
	saveOnClick.value = 'saveComment(this)'; \
	r2col6.childNodes[2].setAttributeNode(saveOnClick); \
	var saveStyle = document.createAttribute('style'); \
	saveStyle.value = 'width:75px'; \
	r2col6.childNodes[2].setAttributeNode(saveStyle); \
	}; \
	";
	var type = document.createAttribute("type");
	type.value = "text/javascript";
	script.setAttributeNode(type);
	var lang = document.createAttribute("language");
	lang.value = "javascript";
	script.setAttributeNode(lang);
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
	var handString = el.getAttribute('hand')
	var hnd;
	if (handString.includes(";")) {
		var handArray = handString.split("; ");
		var handList = handArray.join('</li><li>');
		var handListFull = '<li>' + handList + '</li>';
		var hnd = '<ul style="list-style: none;margin:0;padding:0;">' + handListFull + '</ul>';
	} else {
		hnd = el.getAttribute('hand')
	}
	var date = el.getAttribute('date');
	var prob = el.getAttribute('cert');
	var abbrArray = el.getAttribute('abbrRefs').split(" ");
	var abbrList = abbrArray.join('</a></li><li><a>');
	var abbrListFull = '<li><a>' + abbrList + '</a></li>';
	var listID = 'li.' + id;
	var abbr = '<ul id="' + listID + '" style="list-style: none;margin:0;padding:0;">' + abbrListFull + '</ul>';
	var med = el.getAttribute('medium');
	var lineRef = el.getAttribute("msLine");
	var context = document.querySelectorAll("*[msLine=" + lineRef + "]");
	var contextLength = context.length;
	var msref = el.getAttribute('ref');
	var row = createdTable.insertRow(-1);
	row.style.fontSize = "16px";
	var rowID = document.createAttribute("id");
	rowID.value = "r" + rowNo;
	row.setAttributeNode(rowID);
	newRow();
	var rcol1 = row.insertCell(0);
	rcol1.innerHTML = form;
	var formChildren = rcol1.childNodes[0].childNodes.length;
	var x;
	for (x = formChildren -1; x >= 0; x--) {
		if (rcol1.childNodes[0].childNodes[x].tagName == "BUTTON") {
			rcol1.childNodes[0].removeChild(rcol1.childNodes[0].childNodes[x]);
			continue;
		} else if (rcol1.childNodes[0].childNodes[x].tagName == "TABLE") {
			rcol1.childNodes[0].removeChild(rcol1.childNodes[0].childNodes[x]);
			continue;
		} else if (rcol1.childNodes[0].childNodes[x].tagName == "BR") {
			rcol1.childNodes[0].removeChild(rcol1.childNodes[0].childNodes[x]);
			continue;
		}
	}
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
	var rcol3 = row.insertCell(2);
	var q;
	for (q = 0; q < contextLength; q++) {
		var contextElement = context[q];
		var contextElementCln = contextElement.cloneNode(true);
		rcol3.appendChild(contextElementCln);
	}
	rcol3.style.fontSize = "smaller";
	if (el.firstChild.innerText == "/alt") {
		var choiceID = el.getAttribute("choicePOS").slice(3);
		var corrID = "corr" + choiceID;
		var corrForm = rcol3.querySelector("a[choicePOS=" + corrID + "]");
		corrForm.setAttribute("hidden", "hidden");
	}
	var contextChildren = row.childNodes[2].childNodes;
	var contextChildrenCount = row.childNodes[2].childNodes.length;
	var w;
	for (w = contextChildrenCount - 1; w >= 0; w--) {
		var contextNode = contextChildren[w];
		if (contextNode.tagName == "BUTTON") {
			row.childNodes[2].removeChild(row.childNodes[2].childNodes[w]);
			continue;
		} else if (contextNode.tagName == "TABLE") {
			row.childNodes[2].removeChild(row.childNodes[2].childNodes[w]);
			continue;
		}
		continue;
	}
	var contextWords = row.childNodes[2].getElementsByTagName("a");
	var contextWordsCount = contextWords.length;
	var y;
	for (y = contextWordsCount -1; y >= 0; y--) {
		var contextWord = contextWords[y];
		var contextWordNodes = contextWords[y].childNodes;
		var contextWordNodeCount = contextWord.childNodes.length;
		var z;
		for (z = contextWordNodeCount -1; z >= 0; z--) {
			var contextWordNode = contextWordNodes[z];
			if (contextWordNode.tagName == "BUTTON") {
				contextWord.removeChild(contextWord.childNodes[z]);
				continue;
			} else if (contextWordNode.tagName == "TABLE") {
				contextWord.removeChild(contextWord.childNodes[z]);
				continue;
			} else if (contextWordNode.tagName == "BR") {
				contextWord.removeChild(contextWord.childNodes[z]);
				continue;
			}
			continue;
		}
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
	var lrefED = el.getAttribute("lemmaRefED");
	var lemED = el.getAttribute("lemmaED");
	var rcol10 = row.insertCell(9);
	rcol10.innerHTML = '<a target="' + lrefED + '" href="' + lrefED + '">' + lemED + '</a>';
	var lemDW = el.getAttribute("lemmaDW");
	var lemURLDW = el.getAttribute("lemmaRefDW");
	var rcol11 = row.insertCell(10);
	rcol11.innerHTML = '<a target="' + lemURLDW + '" href="' + lemURLDW + '">' + lemDW + '</a>';
	var lemSL = el.getAttribute("lemmaSL");
	var lemURLSL = el.getAttribute("slipRef");
	var rcol12 = row.insertCell(11);
	rcol12.innerHTML = '<a target="' + lemURLSL + '" href="' + lemURLSL + '">' + lemSL + '</a>';
	var rcol13 = row.insertCell(12);
	rcol13.innerHTML = '<a target="' + lref + '" href="' + lref + '">' + lref + '</a>';
	var finURIED;
	if (rcol13.firstChild.innerHTML.slice(11, 17) == "dil.ie") {
		finURIED = rcol13.firstChild.innerHTML.slice(18);
	} else if (rcol13.firstChild.innerHTML.slice(11, 22) == "faclair.com") {
		finURIED = rcol13.firstChild.innerHTML.slice(51);
	} else if (rcol12.firstChild.innerHTML.slice(6, 17) == "dasg.ac.uk") {
		finURIED = rcol13.firstChild.innerHTML.slice(36);
	}
	rcol13.firstChild.innerHTML = finURIED;
	var rcol14 = row.insertCell(13);
	rcol14.outerHTML = '<td><button onclick="delRow(this)" style="width:75px">Del Row</button><br/><button onclick="addComment(this)" style="font-size:12px; width:75px">Comment</button></td>';
	// opened.document.table.appendChild(tr);
}

function beginCS(b) {
	var csButtons = document.querySelectorAll("button[class=cs]");
	var r;
	for (r = 0; r < csButtons.length; r++) {
		csButtons[r].style.backgroundColor = "MediumSpringGreen";
		csButtons[r].innerHTML = "<b>Collect e-Slips</b>";
	}
	var wsButtons = document.querySelectorAll("button[class=ws]");
	var y;
	for (y = 0; y < wsButtons.length; y++) {
		wsButtons[y].setAttribute("disabled", "");
	}
	var words = document.querySelectorAll("a[lemmaRef]");
	var i;
	for (i = 0; i < words.length; i++) {
		words[i].setAttribute("onclick", "addSlip(this.id)");
	}
	var esButtons = document.querySelectorAll("button[class=es]");
	var j;
	for (j = 0; j < esButtons.length; j++) {
		esButtons[j].removeAttribute("hidden");
	}
	alert("You have enabled ''Collect e-Slips'' mode. Click on a word in the text to add a corresponding e-slip to the table.");
}

function beginWS(b) {
	var wsButtons = document.querySelectorAll("button[class=ws]");
	var r;
	for (r = 0; r < wsButtons.length; r++) {
		wsButtons[r].style.backgroundColor = "MediumSpringGreen";
		wsButtons[r].innerHTML = "<b>Headword Search</b>";
	}
	var csButtons = document.querySelectorAll("button[class=cs]");
	var y;
	for (y = 0; y < csButtons.length; y++) {
		csButtons[y].setAttribute("disabled", "");
	}
	var words = document.querySelectorAll("a[lemmaRef]");
	var i;
	for (i = 0; i < words.length; i++) {
		words[i].setAttribute("onclick", "wordSearch(this.id)");
	}
	var esButtons = document.querySelectorAll("button[class=es]");
	var j;
	for (j = 0; j < esButtons.length; j++) {
		esButtons[j].removeAttribute("hidden");
	}
	alert("You have enabled ''Headword Search'' mode. Click on a word in the text to add e-slips of all instances of this word in this text to the table.")
}

function endSearch(b) {
	var csButtons = document.querySelectorAll("button[class=cs]");
	var y;
	for (y = 0; y < csButtons.length; y++) {
		if (csButtons[y].hasAttribute("disabled")) {
			csButtons[y].removeAttribute("disabled");
		}
		csButtons[y].style.backgroundColor = "";
		if (csButtons[y].childNodes[0].tagName = "b") {
			var bText = csButtons[y].childNodes[0].textContent;
			csButtons[y].innerHTML = bText;
		}
	}
	var wsButtons = document.querySelectorAll("button[class=ws]");
	var j;
	for (j = 0; j < wsButtons.length; j++) {
		if (wsButtons[j].hasAttribute("disabled")) {
			wsButtons[j].removeAttribute("disabled");
		}
		wsButtons[j].style.backgroundColor = "";
		if (wsButtons[j].childNodes[0].tagName = "b") {
			var bText = wsButtons[j].childNodes[0].textContent;
			wsButtons[j].innerHTML = bText;
		}
	}
	var esButtons = document.querySelectorAll("button[class=es]");
	var i;
	for (i = 0; i < esButtons.length; i++) {
		esButtons[i].setAttribute("hidden", "true");
	}
	alert("Mode reset. Make sure to save or print any open e-slip table. Select either ''Collect e-Slips'' or ''Headword Search'' to begin a new table.");
}

function wordSearch(id) {
	var el = document.getElementById(id);
	var lref = el.attributes[6].value;
	var words = document.querySelectorAll("a[lemmaRef]");
	var arr =[];
	var i;
	for (i = 0; i < words.length; i++) {
		if (words[i].getAttribute("lemmaRef") == lref && words[i].getAttribute("class") !== "dip") {
			arr.push(words[i].id);
			continue;
		} else {
			continue;
		}
	}
	localStorage.setItem("formIDs", arr);
	var opened = window.open("", "FnaG MS Corpus Word Table");
	var arr = opened.localStorage.getItem("formIDs");
	var trueArr = arr.split(",");
	var i;
	for (i = 0; i < trueArr.length; i++) {
		var createdTable = opened.document.getElementById("slipTable");
		var row = createdTable.insertRow(-1);
		var rowID = document.createAttribute("id");
		rowID.value = "r" + rowNo;
		row.setAttributeNode(rowID);
		newRow();
		var el = document.getElementById(trueArr[i]);
		el.style.backgroundColor = "White";
		var form = el.outerHTML;
		var lem = el.getAttribute('lemma');
		var an = el.getAttribute('ana');
		var msref = el.getAttribute('ref');
		var lref = el.getAttribute('lemmaRef');
		var handString = el.getAttribute('hand')
		var hnd;
		if (handString.includes(";")) {
			var handArray = handString.split("; ");
			var handList = handArray.join('</li><li>');
			var handListFull = '<li>' + handList + '</li>';
			var hnd = '<ul style="list-style: none;margin:0;padding:0;">' + handListFull + '</ul>';
		} else {
			hnd = el.getAttribute('hand')
		}
		var date = el.getAttribute('date');
		var prob = el.getAttribute('cert');
		var med = el.getAttribute('medium');
		var abbrArray = el.getAttribute('abbrRefs').split(" ");
		var abbrList = abbrArray.join('</a></li><li><a>');
		var abbrListFull = '<li><a>' + abbrList + '</a></li>';
		var listID = 'li.' + id;
		var abbr = '<ul id="' + listID + '" style="list-style: none;margin:0;padding:0;">' + abbrListFull + '</ul>';
		var cell1 = row.insertCell(0);
		cell1.innerHTML = form;
		var formChildren = cell1.childNodes[0].childNodes.length;
		var x;
		for (x = formChildren -1; x >= 0; x--) {
			if (cell1.childNodes[0].childNodes[x].tagName == "BUTTON") {
				cell1.childNodes[0].removeChild(cell1.childNodes[0].childNodes[x]);
				continue;
			} else if (cell1.childNodes[0].childNodes[x].tagName == "TABLE") {
				cell1.childNodes[0].removeChild(cell1.childNodes[0].childNodes[x]);
				continue;
			} else if (cell1.childNodes[0].childNodes[x].tagName == "BR") {
				cell1.childNodes[0].removeChild(cell1.childNodes[0].childNodes[x]);
				continue;
			}
		}
		var cell2 = row.insertCell(1);
		cell2.innerHTML = msref;
		var cell3 = row.insertCell(2);
		var lineRef = el.getAttribute("msLine");
		var context = document.querySelectorAll("*[msLine=" + lineRef + "]");
		var contextLength = context.length;
		var textForm;
		if (el.firstChild.innerText == "/alt") {
			var sicForm = el.lastChild.innerHTML;
			var altTag = cell1.firstElementChild.firstElementChild;
			altTag.setAttribute("hidden", "hidden");
			cell1.firstElementChild.innerHTML = sicForm;
			var sicNode = cell1.firstElementChild.outerHTML;
			textForm = sicNode;
		} else {
			textForm = form
		}
		var q;
		for (q = 0; q < contextLength; q++) {
		var contextElement = context[q];
		var contextElementCln = contextElement.cloneNode(true);
		cell3.appendChild(contextElementCln);
		}
		var contextChildren = row.childNodes[2].childNodes.length;
		var contextWords = row.childNodes[2].getElementsByTagName("a");
		var contextWordsCount = contextWords.length;
		var y;
		for (y = contextWordsCount -1; y >= 0; y--) {
			var contextWord = contextWords[y];
			var contextWordNodes = contextWords[y].childNodes;
			var contextWordNodeCount = contextWord.childNodes.length;
			var z;
			for (z = contextWordNodeCount -1; z >= 0; z--) {
				var contextWordNode = contextWordNodes[z];
				if (contextWordNode.tagName == "BUTTON") {
					contextWord.removeChild(contextWord.childNodes[z]);
					continue;
				} else if (contextWordNode.tagName == "TABLE") {
					contextWord.removeChild(contextWord.childNodes[z]);
					continue;
				} else if (contextWordNode.tagName == "BR") {
					contextWord.removeChild(contextWord.childNodes[z]);
					continue;
				}
				continue;
			}
		}
		cell3.style.fontSize = "smaller";
		if (el.firstChild.innerText == "/alt") {
			var choiceID = el.getAttribute("choicePOS").slice(3);
			var corrID = "corr" + choiceID;
			var corrForm = cell3.querySelector("a[choicePOS=" + corrID + "]");
			corrForm.setAttribute("hidden", "hidden");
		}
		var contextChildren = row.childNodes[2].childNodes;
		var contextChildrenCount = row.childNodes[2].childNodes.length;
		var w;
		for (w = contextChildrenCount - 1; w >= 0; w--) {
			var contextNode = contextChildren[w];
			if (contextNode.tagName == "BUTTON") {
				row.childNodes[2].removeChild(row.childNodes[2].childNodes[w]);
				continue;
			} else if (contextNode.tagName == "TABLE") {
				row.childNodes[2].removeChild(row.childNodes[2].childNodes[w]);
				continue;
			}
			continue;
		}
		var cell4 = row.insertCell(3);
		cell4.innerHTML = med;
		var cell5 = row.insertCell(4);
		cell5.innerHTML = prob;
		var cell6 = row.insertCell(5);
		cell6.innerHTML = abbr;
		var lineCount = cell6.firstChild.childElementCount;
		var j;
		for (j = 0; j < lineCount; j++) {
			var rID = cell6.parentNode.getAttribute("id");
			var lineID = document.createAttribute("id");
			lineID.value = id + "," + rID + ",l" + j;
			cell6.firstChild.getElementsByTagName("li")[j].setAttributeNode(lineID);
			var abbrAnch = cell6.firstChild.getElementsByTagName("li")[j].firstChild;
			var URL = abbrAnch.innerHTML.startsWith("www.");
			var hiliteLinkIn = document.createAttribute("onmouseover");
			hiliteLinkIn.value = 'abbrHilite(this.id)';
			cell6.firstChild.getElementsByTagName("li")[j].setAttributeNode(hiliteLinkIn);
			var hiliteLinkOut = document.createAttribute("onmouseout");
			hiliteLinkOut.value = 'abbrDeHilite(this.id)';
			cell6.firstChild.getElementsByTagName("li")[j].setAttributeNode(hiliteLinkOut);
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
				continue;
			} else {
				var abbrName = abbrAnch.innerHTML;
				var line = abbrAnch.parentNode;
				line.innerHTML = abbrName;
				continue;
			}
		};
		var cell7 = row.insertCell(6);
		cell7.innerHTML = hnd;
		var cell8 = row.insertCell(7);
		cell8.innerHTML = date;
		var cell9 = row.insertCell(8);
		cell9.innerHTML = an;
		var lrefED = el.getAttribute("lemmaRefED");
		var lemED = el.getAttribute("lemmaED");
		var cell10 = row.insertCell(9);
		cell10.innerHTML = '<a target="' + lrefED + '" href="' + lrefED + '">' + lemED + '</a>';
		var lemDW = el.getAttribute("lemmaDW");
		var lemURLDW = el.getAttribute("lemmaRefDW");
		var cell11 = row.insertCell(10);
		cell11.innerHTML = '<a target="' + lemURLDW + '" href="' + lemURLDW + '">' + lemDW + '</a>';
		var lemSL = el.getAttribute("lemmaSL");
		var lemURLSL = el.getAttribute("slipRef");
		var cell12 = row.insertCell(11);
		cell12.innerHTML = '<a target="' + lemURLSL + '" href="' + lemURLSL + '">' + lemSL + '</a>';
		var cell13 = row.insertCell(12);
		cell13.innerHTML = '<a target="' + lref + '" href="' + lref + '">' + lref + '</a>';
		var finURIED;
		if (cell13.firstChild.innerHTML.slice(11, 17) == "dil.ie") {
			finURIED = cell13.firstChild.innerHTML.slice(18);
		} else if (cell13.firstChild.innerHTML.slice(11, 22) == "faclair.com") {
			finURIED = cell13.firstChild.innerHTML.slice(51);
		} else if (cell12.firstChild.innerHTML.slice(6, 17) == "dasg.ac.uk") {
			finURIED = cell13.firstChild.innerHTML.slice(36);
		}
		cell13.firstChild.innerHTML = finURIED;
		var cell14 = row.insertCell(13);
		cell14.outerHTML = '<td><button onclick="delRow(this)" style="width:75px">Del Row</button><br/><button onclick="addComment(this)" style="font-size:12px; width:75px">Comment</button></td>';
		continue;
	}
}