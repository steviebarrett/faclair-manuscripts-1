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
	document.getElementById(id).style.backgroundColor = "aqua";
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
	document.getElementById(id).style.backgroundColor = "white";
}