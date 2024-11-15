<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Exception Alert</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            height: 100vh;
        }
    
        .form-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 1000px; /* Adjust the width as needed */
            /* Removed max-height and overflow-y */
        }
    
        .input-group, .input-row {
            display: flex;
            align-items: center;
            margin: 10px 0; /* Space between rows */
        }
    
        label {
            flex: 1;
            margin-right: 10px;
            font-weight: bold;
            min-width: 120px; /* Ensure consistent label width */
        }
    
        input[type="text"] {
            flex: 2;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 100%; /* Ensure inputs fill the available space */
        }
    
        .add-btn, .remove-btn, .add-row-btn, .delete-row-btn {
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 50%; /* Make it circular */
            cursor: pointer;
            height: 30px; /* Set height for buttons */
            width: 30px; /* Set width for buttons */
            display: flex; /* Use flex for centering */
            justify-content: center; /* Center the icon */
            align-items: center; /* Center the icon */
            line-height: 1; /* Ensures the icon is vertically centered */
            font-size: 14px; /* Adjust size for visibility */
            padding: 0; /* Remove padding */
            margin-left: 10px; /* Space between input and button */
        }
    
        .add-btn:hover, .remove-btn:hover, .add-row-btn:hover, .delete-row-btn:hover {
            background-color: #0056b3; /* Darker color on hover */
        }
    
        input[type="submit"] {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }
    
        input[type="submit"]:hover {
            background-color: #218838;
        }
    
        .equals {
            margin: 0 10px; /* Space around equals sign */
            font-weight: bold;
        }
    
        select {
            flex: 2; /* Match the input width */
            padding: 10px; /* Same padding as input boxes */
            border: 1px solid #ccc; /* Same border */
            border-radius: 4px; /* Same border radius */
            width: 100%; /* Ensure it fills the space */
            font-size: 14px; /* Same font size */
        }
    </style>
    
</head>
<body>
    <div class="form-container">
        <h2><center>Create Exception Alert</center></h2>
        %ifvar formSubmitted equals('true')%
        %invoke HG_ExceptionAlert.v1.ui.configureAlert.services:registerNewAlert%
        <h5 style="color: #28a745;">%value message%!!!</h5>
        %onerror%
        <h5 style="color:red;">%value errorMessage% !!!</h5>
        %endinvoke%
        %endifvar%
        <form id="dynamic-form">
            <input type="hidden" name="formSubmitted" value="true">
            <div class="input-group">
                <label for="serviceName">Service Name:</label>
                <input type="text" id="serviceName" placeholder="Enter full qualified main service name" name="serviceName" required>
            </div>
            <div class="input-group">
                <label for="source">Source System:</label>
                <input type="text" id="source" placeholder="Enter source system name" name="sourceSystem" required>
            </div>
            <div class="input-group">
                <label for="target">Target System:</label>
                <input type="text" id="target" placeholder="Enter target system name" name="targetSystem" required>
            </div>
            <div class="input-group">
                <label for="emailSubject">Email Subject:</label>
                <input type="text" id="emailSubject" placeholder="Enter Exception Email subject" name="emailSubject" required>
            </div>
            <div class="input-group">
                <label for="emailRecipient">Email Recipient:</label>
                <input type="text" id="emailRecipient" placeholder="Enter Email to receive Exception Email" name="emailRecipient" required>
            </div>
            <div class="input-group">
                <label for="alertType">Alert Status :</label>
                <select id="alertType" name="alertStatus" required>
                    <option>Disabled</option>
                    <option>Enabled</option>
                </select>
            </div>
            <div class="input-group">
                <label for="excludeError">Exclude Error:</label>
                <input type="text" id="excludeError" placeholder="Exclude Error" name="excludeError">
                <button type="button" class="add-btn">+</button>
            </div>
            <div id="input-rows"></div>
            <label>Define Variable and it's path to extract:</label>
            <div id="input-row-multi"></div>
            <div class="input-row">
                <input type="text" placeholder="Variable name" name="variableName">
                <span class="equals">=</span>
                <input type="text" placeholder="Path" name="variablePath">
                <button type="button" class="add-row-btn">+</button>
            </div>
            <input type="submit" value="Create Alert">
        </form>
    </div>

    <script>
        // Add new exclude error input
        document.querySelector('.add-btn').addEventListener('click', function () {
            const additionalInputsContainer = document.getElementById('input-rows');

            const newInputGroup = document.createElement('div');
            newInputGroup.className = 'input-group';

            const newInputLabel = document.createElement('label');
            newInputLabel.textContent = 'Exclude Error';
            newInputGroup.appendChild(newInputLabel);

            const newInput = document.createElement('input');
            newInput.type = 'text';
            newInput.placeholder = 'Exclude Error';
            newInput.name='excludeError';

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.textContent = '-';
            removeBtn.className = 'remove-btn';

            removeBtn.addEventListener('click', function () {
                additionalInputsContainer.removeChild(newInputGroup);
            });

            newInputGroup.appendChild(newInput);
            newInputGroup.appendChild(removeBtn);
            additionalInputsContainer.appendChild(newInputGroup);
        });

        // Add new input row with delete option
        document.querySelector('.add-row-btn').addEventListener('click', function () {
            const inputRowsContainer = document.getElementById('input-row-multi');

            const newInputRow = document.createElement('div');
            newInputRow.className = 'input-row';

            const newInput1 = document.createElement('input');
            newInput1.type = 'text';
            newInput1.placeholder = 'Variable name';
            newInput1.name='variableName';

            const equals = document.createElement('span');
            equals.className = 'equals';
            equals.textContent = '=';

            const newInput2 = document.createElement('input');
            newInput2.type = 'text';
            newInput2.placeholder = 'Path';
            newInput2.name='variablePath';

            const addBtn = document.createElement('button');
            addBtn.type = 'button';
            addBtn.className = 'add-row-btn';
            addBtn.textContent = '+';

            const deleteBtn = document.createElement('button');
            deleteBtn.type = 'button';
            deleteBtn.className = 'delete-row-btn';
            deleteBtn.textContent = '-';

            deleteBtn.addEventListener('click', function () {
                inputRowsContainer.removeChild(newInputRow);
            });

            newInputRow.appendChild(newInput1);
            newInputRow.appendChild(equals);
            newInputRow.appendChild(newInput2);
            newInputRow.appendChild(addBtn);
            newInputRow.appendChild(deleteBtn);
            inputRowsContainer.appendChild(newInputRow);
        });
    </script>
</body>
</html>
