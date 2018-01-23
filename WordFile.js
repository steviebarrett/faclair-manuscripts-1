var first_click = true;
					function GetWordFile(id) {
					if (first_click = true) {
					var el = document.getElementById(id);
					var form = el.innerHTML;
					var lem = el.getAttribute('lemma');
					var an = el.getAttribute('ana');
					var lref = el.getAttribute('lemmaRef');
					var hnd = el.getAttribute('hand');
					var leman = lem + ", " + an;
					var msref = el.getAttribute('ref');
					var table = document.createElement("table");
						document.getElementsByTagName("table");
						var tblBorder = document.createAttribute ("border");
						tblBorder.value = "solid 0.1mm black";
						table.setAttributeNode(tblBorder);
					var row1 = table.insertRow(0);
					var r1col1 = row1.insertCell(0);
					r1col1.outerHTML = "<th><b>MS Form</b></th>";
					var r1col2 = row1.insertCell(1);
					r1col2.outerHTML = "<th><b>MS Reference</b></th>";
					var r1col3 = row1.insertCell(2);
					r1col3.outerHTML = "<th><b>Scribe</b></th>";
					var r1col4 = row1.insertCell(3);
					r1col4.outerHTML = "<th><b>Lemma (eDIL)</b></th>";
					var r1col5 = row1.insertCell(4);
					r1col5.outerHTML = "<th><b>URL (eDIL)</b></th>";
					var r1col6 = row1.insertCell(5);
					r1col6.outerHTML = "<th><b>Lemma (Faclair Beag)</b></th>";
					var r1col7 = row1.insertCell(6);
					r1col7.outerHTML = "<th><b>URL (Faclair Beag)</b></th>";
					var row2 = table.insertRow(-1);
					var r2col1 = row2.insertCell(0);
					r2col1.innerHTML = form;
					var r2col2 = row2.insertCell(1);
					r2col2.innerHTML = msref;
					var r2col3 = row2.insertCell(2);
					r2col3.innerHTML = hnd;
					var r2col4 = row2.insertCell(3);
					r2col4.innerHTML = lem;
					var r2col5 = row2.insertCell(4);		
					r2col5.innerHTML = '<a href="'+lref+'">'+lref+'</a>';
					var r2col6 = row2.insertCell(5);
					r2col6.innerHTML = "[Faclair Beag lemma here]";
					var r2col7 = row2.insertCell(6);
					r2col7.innerHTML = "[Faclair Beag URL here]";
					var opened = window.open("", "FnaG MS Corpus Word Table");
					opened.document.body.appendChild(table);
					first_click = false;
					}
					else {
					var row = table.insertRow(-1);
					var rcol1 = row.insertCell(0);
					rcol1.innerHTML = form;
					var rcol2 = row.insertCell(1);
					rcol2.innerHTML = msref;
					var rcol3 = row.insertCell(2);
					rcol3.innerHTML = hnd;
					var rcol4 = row.insertCell(3);
					rcol4.innerHTML = lem;
					var rcol5 = row.insertCell(4);		
					rcol5.innerHTML = '<a href="'+lref+'">'+lref+'</a>';
					var rcol6 = row.insertCell(5);
					rcol6.innerHTML = "[Faclair Beag lemma here]";
					var rcol7 = row.insertCell(6);
					rcol7.innerHTML = "[Faclair Beag URL here]";
					opened.document.body.table.appendChild(row);
					}
					}