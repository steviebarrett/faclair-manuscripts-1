function sortTable(n) {
    //document.write(n);  // I am not sure what this statement does.
    var table, rows, switching, i, x, y, dir, switchcount = 0;
    table = document.getElementById("tbl");
    switching = true;
    dir = "asc";   //The value for dir will (I assume) be from user input eventually.
    if (dir === "asc") {
        while (switching) {
            rows = table.getElementsByTagName("tr");
            for (i = 1; i < rows.length - 1; i++) {
                shouldSwitch = false;
                x = rows[i].getElementsByTagName("td")[n];
                y = rows[i + 1].getElementsByTagName("td")[n];
                if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                    rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                    switching = true;
                    switchcount++;
                }
            }
        } 
    }
    else {
        //So  dir === "desc"
        while (switching) {
            switching = false;
            rows = table.getElementsByTagName("tr");
            for (i = 1; i < rows.length - 1; i++) {
                console.log("In loop");
                shouldSwitch = false;
                x = rows[i].getElementsByTagName("td")[n];
                y = rows[i + 1].getElementsByTagName("td")[n];
                if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                    rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                    switching = true;
                    switchcount++;
                }
            }
        }
    }
}