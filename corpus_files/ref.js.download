function refDetails(id) {
if (document.getElementById(id).hasAttribute("exp"))
{	
	var refID = id + '_exp';
	var refExp = document.getElementById(refID);
	refExp.style.display = "inline";
	document.getElementById(id).removeAttribute("exp");
	return;
}
else
{
	var refID = id + '_exp';
	var refExp = document.getElementById(refID);
	refExp.style.display = "none";
	document.getElementById(id).setAttribute("exp", "0");
	return;
}
}