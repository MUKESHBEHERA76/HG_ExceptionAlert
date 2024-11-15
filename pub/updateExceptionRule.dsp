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
            width: 600px;
        }

        .input-group, .input-row, .exclude-error-row {
            display: flex;
            align-items: center;
            margin: 10px 0;
        }

        input[type="text"] {
            flex: 2;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-right: 10px;
            width: calc(100% - 60px); /* Adjust for button width */
        }

        .add-row-btn,
        .remove-btn,
        .remove-row-btn,
        .add-btn {
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            padding: 5px 10px;
            margin-left: 10px;
        }

        .add-row-btn:hover,
        .remove-btn:hover
        .remove-row-btn:hover,
        .add-btn:hover {
            background-color: #0056b3;
        }

        input[type="submit"] {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
            width: 100%;
        }

        input[type="submit"]:hover {
            background-color: #218838;
        }

        label {
            margin-right: 10px;
            flex: 1; /* Adjust label to take a fixed width */
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Update Exception Alert</h2>
        %ifvar formSubmitted equals('true')%
        %invoke HG_ExceptionAlert.v1.ui.updateAlert.services:updateExceptionRule%
        <h5 style="color: #28a745;">%value message%!!!</h5>
        %onerror%
        <h5 style="color:red;">%value errorMessage% !!!</h5>
        %endinvoke%
        %endifvar%
        
        %ifvar exceptionService%
        %invoke HG_ExceptionAlert.v1.ui.updateAlert.services:getExceptionRule%
        <form id="dynamic-form">
            <input type="hidden" name="formSubmitted" value="true">
            <div class="input-group">
                <label for="serviceName">Service Name:</label>
                <input type="text" id="serviceName" placeholder="Enter full qualified main service name" name="serviceName" required value="%value ExceptionRule/SERVICE_NAME%">
            </div>
            <div class="input-group">
                <label for="source">Source System:</label>
                <input type="text" id="source" placeholder="Enter source system name" name="sourceSystem" required value="%value ExceptionRule/SOURCE%">
            </div>
            <div class="input-group">
                <label for="target">Target System:</label>
                <input type="text" id="target" placeholder="Enter target system name" name="targetSystem" required value="%value ExceptionRule/TARGET%">
            </div>
            <div class="input-group">
                <label for="emailSubject">Email Subject:</label>
                <input type="text" id="emailSubject" placeholder="Enter Exception Email subject" name="emailSubject" required value="%value ExceptionRule/SUBJECT%">
            </div>
            <div class="input-group">
                <label for="emailRecipient">Email Recipient:</label>
                <input type="text" id="emailRecipient" placeholder="Enter Email to receive Exception Email" name="emailRecipient" required value="%value ExceptionRule/EMAIL_ADDRESS%">
            </div>
            <div class="input-group">
                <label for="alertType">Alert Status:</label>
                <select id="alertType" name="alertStatus" required>
                    %ifvar ExceptionRule/STATUS equals('Enabled')%
                    <option>Enabled</option>
                    <option>Disabled</option>
                    %else%
                    <option>Disabled</option>
                    <option>Enabled</option>
                    %end%
                </select>
            </div>
            <div id="input-row-multi">
                %loop ExceptionRule/EXCLUDE_EXCEPTION_ALERT%
                <div class="input-group">
                    <label for="excludeError">Exclude Error:</label>
                    <input type="text" id="excludeError" placeholder="Exclude Error" name="excludeError" value="%value ExceptionRule/EXCLUDE_EXCEPTION_ALERT%">
                    <button type="button" class="remove-btn">-</button>
                </div>
                %endloop%
            </div>
            
            <div class="input-group">
                <input type="text" id="excludeError" placeholder="Exclude Error" name="excludeError">
                <button type="button" class="add-btn">+</button>
            </div>
            <div id="exclude-rows"></div>
            <label>Define Variable and it's path to extract:</label>
            <div id="input-row-multi">
                %loop ExceptionRule/Pipeline%
                <div class="input-row">
                    <input type="text" placeholder="Variable name" name="variableName" value="%value VARIABLE_NAME%" />
                    <input type="text" placeholder="Path" name="variablePath" value="%value VARIABLE_PATH%" />
                    <button type="button" class="remove-row-btn">-</button>
                </div>
                %endloop%
            </div>
            <div class="input-row">
                <input type="text" placeholder="Variable name" name="variableName">
                <input type="text" placeholder="Path" name="variablePath">
                <button type="button" class="add-row-btn">+</button>
            </div>
            <input type="submit" value="Update Alert">
        </form>
        %endinvoke%
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Add new Exclude Error input
            document.querySelector('.add-btn').addEventListener('click', function () {
                const excludeRowsContainer = document.getElementById('exclude-rows');
                const newExcludeRow = document.createElement('div');
                newExcludeRow.className = 'exclude-error-row';

                const newExcludeInput = document.createElement('input');
                newExcludeInput.type = 'text';
                newExcludeInput.placeholder = 'Exclude Error';
                newExcludeInput.name = 'excludeErrorList[]'; // Use array notation for multiple entries

                const deleteBtn = document.createElement('button');
                deleteBtn.type = 'button';
                deleteBtn.className = 'remove-row-btn';
                deleteBtn.textContent = '-';

                deleteBtn.addEventListener('click', function () {
                    excludeRowsContainer.removeChild(newExcludeRow);
                });

                newExcludeRow.appendChild(newExcludeInput);
                newExcludeRow.appendChild(deleteBtn);
                excludeRowsContainer.appendChild(newExcludeRow);
            });

            // Add new input row for variable name and path
            document.querySelector('.add-row-btn').addEventListener('click', function () {
                const inputRowsContainer = document.getElementById('input-row-multi');
                const newInputRow = document.createElement('div');
                newInputRow.className = 'input-row';

                const newInput1 = document.createElement('input');
                newInput1.type = 'text';
                newInput1.placeholder = 'Variable name';
                newInput1.name = 'variableName';

                const newInput2 = document.createElement('input');
                newInput2.type = 'text';
                newInput2.placeholder = 'Path';
                newInput2.name = 'variablePath';

                const deleteBtn = document.createElement('button');
                deleteBtn.type = 'button';
                deleteBtn.className = 'remove-row-btn';
                deleteBtn.textContent = '-';

                deleteBtn.addEventListener('click', function () {
                    inputRowsContainer.removeChild(newInputRow);
                });

                newInputRow.appendChild(newInput1);
                newInputRow.appendChild(newInput2);
                newInputRow.appendChild(deleteBtn);
                inputRowsContainer.appendChild(newInputRow);
            });

            // Remove existing rows for variables
            document.getElementById('input-row-multi').addEventListener('click', function (event) {
                if (event.target.classList.contains('remove-row-btn')) {
                    event.target.parentElement.remove();
                }
            });
        });


        function removeInputRow(button) {
        // Find the input group that contains the button
        const inputGroup = button.closest('.input-group');
        // Remove the input group from the DOM
        if (inputGroup) {
            inputGroup.remove();
        }
    }

    // Attach event listener to all remove buttons
    document.addEventListener('DOMContentLoaded', function() {
        const removeButtons = document.querySelectorAll('.remove-btn');
        removeButtons.forEach(button => {
            button.addEventListener('click', function() {
                removeInputRow(button);
            });
        });
    });
    </script>
</body>
</html>
