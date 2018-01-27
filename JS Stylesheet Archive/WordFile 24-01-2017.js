function createTable() {
					var table = document.createElement("table");
					document.getElementsByTagName("table");
					var script = document.createElement("script");			
					var tblBorder = document.createAttribute ("border");
					tblBorder.value = "solid 0.1mm black";
					table.setAttributeNode(tblBorder);
					var tblId = document.createAttribute ("id");
					tblId.value = "slipTable";
					table.setAttributeNode(tblId);
					var row1 = table.insertRow(0);
					var r1col1 = row1.insertCell(0);
					r1col1.outerHTML = "<th><b>MS Form</b></th>";
					var r1col2 = row1.insertCell(1);
					r1col2.outerHTML = "<th><b>MS Reference</b></th>";
					var r1col3 = row1.insertCell(2);
					r1col3.outerHTML = "<th><b>Problem(s) with reading?</b></th>";
					var r1col4 = row1.insertCell(3);
					r1col4.outerHTML = "<th><b>Scribe</b></th>";
					var r1col5 = row1.insertCell(4);
					r1col5.outerHTML = "<th><b>Scribe Date</b></th>";
					var r1col6 = row1.insertCell(5);
					r1col6.outerHTML = "<th><b>Lemma (eDIL)</b></th>";
					var r1col7 = row1.insertCell(6);
					r1col7.outerHTML = "<th><b>URL (eDIL)</b></th>";
					var r1col8 = row1.insertCell(7);
					r1col8.outerHTML = "<th><b>Lemma (Faclair Beag)</b></th>";
					var r1col9 = row1.insertCell(8);
					r1col9.outerHTML = "<th><b>URL (Faclair Beag)</b></th>";
					var r1col10 = row1.insertCell(9);
					r1col10.outerHTML = "<button onclick='tblDownload('msSlips.csv')' id='dloadBtn'>Download as CSV</button>";
					var opened = window.open("", "FnaG MS Corpus Word Table"); 
					opened.document.body.appendChild(table);
					opened.document.head.appendChild(script);
					script.innerHTML = 'function delRow(r) \
					{ \
					var i = r.parentNode.rowIndex; \
					document.getElementById("slipTable").deleteRow(i); \
					} \
					function tblDownload(csv, filename) \
					{ \
					var csvFile; \
					var downloadLink; \
					csvFile = new msSlips([csv], {type:"text/csv"}); \
					downloadLink = document.createElement("a"); \
					downloadLink.download = filename; \
					downloadLink.href = window.URL.createObjectURL(csvFile); \
					downloadLink.style.display = "none"; \
					document.body.appendChild(downloadLink); \
					downloadLink.click(); \
					} \
					function exportTableToCSV(filename) { \
					var csv = [];\
					var rows = document.querySelectorAll("table tr");\
					for (var i = 0; i < rows.length; i++) \
      					var row = [], cols = rows[i].querySelectorAll("td, th"); \
        					for (var j = 0; j < cols.length; j++) \
            					row.push(cols[j].innerText); \
        					csv.push(row.join(",")); \
        					} \
        					'}
					function addSlip(id) {
					var opened = window.open("", "FnaG MS Corpus Word Table");
					var createdTable = opened.document.getElementById("slipTable");
					var el = document.getElementById(id);
					var form = el.innerHTML;
					var lem = el.getAttribute('lemma');
					var an = el.getAttribute('ana');
					var lref = el.getAttribute('lemmaRef');
					var hnd = el.getAttribute('hand');
					var date = el.getAttribute('date');
					var prob = el.getAttribute('problem');
					var msref = el.getAttribute('ref');
					var row = createdTable.insertRow(-1);
					var rcol1 = row.insertCell(0);
					rcol1.innerHTML = form;
					var rcol2 = row.insertCell(1);
					rcol2.innerHTML = msref;
					var rcol3 = row.insertCell(2);
					rcol3.innerHTML = prob;
					var rcol4 = row.insertCell(3);
					rcol4.innerHTML = hnd;
					var rcol5 = row.insertCell(4);
					rcol5.innerHTML = date;
					var rcol6 = row.insertCell(5);
					rcol6.innerHTML = lem;
					var rcol7 = row.insertCell(6);		
					rcol7.innerHTML = '<a href="'+lref+'">'+lref+'</a>';
					var rcol8 = row.insertCell(7);
					rcol8.innerHTML = "[Faclair Beag lemma here]";
					var rcol9 = row.insertCell(8);
					rcol9.innerHTML = "[Faclair Beag URL here]";
					var rcol10 = row.insertCell(9);
					rcol10.outerHTML = '<button onclick="delRow(this)">Delete Row</button>';
					opened.document.table.appendChild(tr);
					}