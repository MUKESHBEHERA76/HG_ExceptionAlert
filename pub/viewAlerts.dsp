<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stylish Form</title>
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
</head>

<body>
    <table class="table table-bordered" id="myTable">
        <thead>
            <tr class="table-primary">
                <td colspan="3"><center><b>View Existing Exception Rules</b></center></td>
              </tr>
          <tr class="table-info">
            <th scope="col">Exception Service Name</th>
            <th scope="col">Status</th>
            <th scope="col">Delete</th>
          </tr>
        </thead>
        <tbody>
%invoke HG_ExceptionAlert.v1.ui.viewAlerts.services:viewExceptionRules%
%loop selectExceptionRulesOutput/results%
</tr>
    <td><a href="#" class="capture-row"><b>%value SERVICE_NAME%</b></a></td>
    %ifvar STATUS equals('Enabled')%
    <td><b style="color: green;">%value STATUS%</b></td>
    %else%
    <td><b style="color: red;">%value STATUS%</b></td>
    %end%
    <td><button style="background-color: chocolate;" onclick="getRowData(this)">Delete</button></td>
  </tr>
%endloop%

%endinvoke%
        </tbody>
      </table>

</body>
<script>
 let exceptionService = '';  // Declare variable outside of if block
let status = '';            // Declare variable outside of if block

const anchors = document.querySelectorAll('.capture-row');

anchors.forEach(anchor => {
  anchor.addEventListener('click', function(event) {
    event.preventDefault(); // Prevent default anchor behavior

    // Get the row containing the clicked anchor
    const row = this.closest('tr');
    const cells = row.querySelectorAll('td');

    if (cells.length >= 2) {  // Ensure there are at least 2 cells
      exceptionService = cells[0]?.innerText.trim();  // Assign value to variable
      status = cells[1]?.innerText.trim();            // Assign value to variable

      var url="updateExceptionRule.dsp?exceptionService=" + exceptionService + "&status=" + status;
    window.location.replace(url);

      // You can now access exceptionService and status outside of the if block
      console.log('Exception Service:', exceptionService);
      console.log('Status:', status);
    } else {
      console.error('The row does not have enough columns.');
    }
  });
});



function getRowData(button) {
    // Find the closest row to the clicked button
    var row = button.closest('tr');
    
    // Get the values of the cells in the row
    var exceptionService = row.querySelector('td a b').innerText;
    var status = row.querySelector('td:nth-child(2) b').innerText;
    
    
    var url="deleteExceptionAlert.dsp?exceptionService=" + exceptionService + "&status=" + status +'&action='+'Delete';
    // You can further process the data, like making an API call
    if (confirm("Are you sure you want to Delete the exception rule for service: " + exceptionService + "?")) {
        // If the user confirms, proceed with the redirection
        window.location.replace(url);
    } else {
        // If the user cancels, do nothing
        console.log("User canceled the action.");
    }
  }
  </script>
  
</html>