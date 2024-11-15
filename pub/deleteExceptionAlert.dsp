<html>
    <body>
        %ifvar action equals('Delete')%
%invoke HG_ExceptionAlert.v1.ui.DeleteAlert.services:deleteExceptionAlert%
<h5 style="color: #28a745;">%value message%!!!</h5>
%onerror%
        <h5 style="color:red;">%value errorMessage% !!!</h5>
%endinvoke%
%endifvar%
    </body>
    <script>
        setTimeout(function() {
            window.location.replace('viewAlerts.dsp');
},2000);
    </script>
</html>