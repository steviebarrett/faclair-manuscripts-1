function hilite(id) {
	if (document.getElementById(id).hasAttribute("data-compoundWord")) {
		var compWID = document.getElementById(id).getAttribute("data-compoundWord");
		var wComps = document.querySelectorAll("a[data-compoundWord='" + compWID + "']");
		var wCompsCount = wComps.length;
		var x;
		for (x = 0; x < wCompsCount; x++) {
			wComps[x].style.backgroundColor = "PaleTurquoise";
		}
	}
	var wordFrags = document.querySelectorAll("a[id="+id+"]");
	var wordFragsCount = wordFrags.length;
	var wfs;
	for(wfs=0;wfs<wordFragsCount;wfs++){
		wordFrags[wfs].style.backgroundColor = "aqua";
	}
}
function dhilite(id) {
	if (document.getElementById(id).hasAttribute("data-compoundWord")) {
		var compWID = document.getElementById(id).getAttribute("data-compoundWord");
		var wComps = document.querySelectorAll("a[data-compoundWord='" + compWID + "']");
		var wCompsCount = wComps.length;
		var x;
		for (x = 0; x < wCompsCount; x++) {
			wComps[x].style.backgroundColor = "white";
		}
	}
	var wordFrags = document.querySelectorAll("a[id="+id+"]");
	var wordFragsCount = wordFrags.length;
	var wfs;
	for(wfs=0;wfs<wordFragsCount;wfs++){
		wordFrags[wfs].style.backgroundColor = "white";
	}
}