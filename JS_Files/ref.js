function refDetails(id) {
if (document.getElementById(id).hasAttribute("exp"))
{	
	var refID = id + '_exp';
	var refExp = document.getElementById(refID);
	refExp.hidden = "";
	document.getElementById(id).removeAttribute("exp");
	refExp.style.backgroundColor = "Aquamarine";
	return;
}
else
{
	var refID = id + '_exp';
	var refExp = document.getElementById(refID);
	refExp.hidden = "hidden";
	document.getElementById(id).setAttribute("exp", "0");
	refExp.style.backgroundColor = "";
	return;
}
}