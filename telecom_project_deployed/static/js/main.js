// Simple Search/Filter for Tables
function filterTable(inputId, tableId) {
    let input = document.getElementById(inputId);
    let filter = input.value.toUpperCase();
    let table = document.getElementById(tableId);
    let tr = table.getElementsByTagName("tr");

    for (let i = 1; i < tr.length; i++) { // Skip header row
        let match = false;
        let tds = tr[i].getElementsByTagName("td");
        
        for (let j = 0; j < tds.length; j++) {
            if (tds[j]) {
                let txtValue = tds[j].textContent || tds[j].innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    match = true;
                    break;
                }
            }
        }
        
        if (match) {
            tr[i].style.display = "";
        } else {
            tr[i].style.display = "none";
        }
    }
}

// Auto dismiss flash messages after 5 seconds
document.addEventListener("DOMContentLoaded", function() {
    setTimeout(function() {
        let alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            // Check if it hasn't been manually closed
            if (alert.style.display !== 'none') {
                alert.style.opacity = '0';
                setTimeout(() => {
                    alert.style.display = 'none';
                }, 300); // match fade out
            }
        });
    }, 5000);
});

// Close modals when clicking outside
window.onclick = function(event) {
    let modals = document.querySelectorAll('.modal');
    modals.forEach(function(modal) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    });
}