<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css"  />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=info" />
    <script src="https://cdn.lordicon.com/lordicon.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <title>Threshold settings</title>
</head>
<body>
<%--Navbar--%>
<nav class="navbar navbar-expand-lg rounded-bottom" style=" min-height: 3rem; margin-bottom: 2rem">
    <div class="container-fluid">
        <div class="row g-0" onclick="window.location.href='/dashboard'" onmouseover="this.style.cursor='pointer'">
            <div class="col">
                <lord-icon
                        class="ms-1"
                        src="https://cdn.lordicon.com/rqeluyar.json"
                        trigger="hover"
                        stroke="bold"
                        colors="primary:#33B2E9,secondary:#33B2E9">
                </lord-icon>
            </div>
            <div class="col">
                <a class="navbar-brand ms-2" href="/dashboard">OfficeFlow</a>
            </div>
        </div>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#expandNavBar">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse " id="expandNavBar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link btn btn-sm btn-outline-light" href="/dashboard">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-sm btn-outline-light active" aria-current="page" href="/thresholdSettings">Threshold Settings</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-sm btn-outline-light" href="/manageDevices">Manage devices</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-sm btn-outline-light" href="/faq">FAQ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-sm btn-outline-light" href="/about">About</a>
                </li>
            </ul>

            <div style="text-align: center">
                <span class="navbar-text me-3">${userName}</span>
                <button onclick="window.location.href='/accountSettings'" data-bs-toggle="tooltip" data-bs-title="Account Settings" data-bs-placement="bottom" style="align-self: center" class=" me-3 btn btn-sm themeButton">
                    <div class="row align-items-center">
                        <div class="col">
                            <lord-icon
                                    src="https://cdn.lordicon.com/whvtbbby.json"
                                    trigger="hover"
                                    stroke="bold"
                                    colors="primary:#FFFFFF,secondary:#FFFFFF">
                            </lord-icon>
                        </div>
                    </div>
                </button>

                <button data-bs-toggle="modal" data-bs-target="#logoutModal" style="align-self: center" class="btn btn-sm themeButton">
                    <div class="row g-1 align-items-center">
                        <div class="col">
                            Logout
                        </div>
                        <div class="col">
                            <lord-icon
                                    src="https://cdn.lordicon.com/pbalszem.json"
                                    trigger="hover"
                                    stroke="bold"
                                    colors="primary:#FFFFFF,secondary:#FFFFFF">
                            </lord-icon>
                        </div>
                    </div>
                </button>
            </div>
        </div>
    </div>
</nav>

<!-- Logout modal -->
<div class="modal fade" id="logoutModal" tabindex="-1">
    <div class="modal-dialog ">
        <div class="modal-content container" >
            <div class="modal-header row">
                <h1 class="modal-title text-center fs-5 col-11" >Are you sure you want to logout?</h1>
                <button type="button" class="btn-close text-end col-1" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-footer justify-content-center ">
                <button id="closeButton" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button onclick="window.location.href='/logout'" type="button" class="btn btn-danger">Logout</button>
            </div>
        </div>
    </div>
</div>

<div class="container" style="border-radius: 3%">
    <div class="row justify-content-center">
        <div class="card p-3 col-lg-6">
        <h2 class="text-center mb-3">Thresholds</h2>
        <c:forEach items="${sensors}" var="sensor">
        <div class="card mb-3 sensorCard">
        <div class="card-body" >
            <h5 class="card-title">${sensor.sensorType.name} <span class="material-symbols-outlined" id="tooltipInfo" data-bs-toggle="tooltip" data-bs-html="true" data-bs-title="${
            sensor.sensorType.name == 'Light' ? 'For office work, 500 lux is the recommended minimum light level, by CIBSE (Chartered Institution of Building Services Engineers). Turning on automation will make the lamp turn on automatically when your room\'s light levels are below the threshold '
            : sensor.sensorType.name == 'Temperature' ? 'This value is used to detect if it is too hot in your room. Please set it to the value that you want your room temperature to stay below. Turning on automation will make the fan turn on when your room\'s temperature levels are above the threshold '
            : sensor.sensorType.name == 'Occupancy' ? 'This value is used to detect if you are present or not, by seeing if you are a certain specified distance away from the occupancy sensor.'
            : sensor.sensorType.name == 'Heart' ? 'This value is used to detect elevated heart rate which may be to do with stress. You will receive an alert if a heart rate reading is detected that exceeds this.'
            : "Unknown"

            }"  style="font-size: 20px;" onmouseover="this.style.cursor='pointer'">info</span></h5>
            <p style="display: none" id="sensorId">${sensor.sensorId}</p>
            <div>
                <div class="col-auto">
                    <label for="sensorThreshold" class="form-label">Threshold (${sensor.sensorType.unit}):</label>
                    <input type="number" id="sensorThreshold" name="sensorThreshold" value="${sensor.threshold}"
                           class="form-control form-control-sm" disabled min="0">
                </div>
                <div class="mt-3">
                    <button id="editButton" class="btn btn-sm themeButton mb-4" onclick="editSensorThreshold(this)">Edit</button>
                    <button id="saveButton" class="btn btn-sm mb-4" onclick="saveSensorThreshold(this)" style="display: none; background-color: #33E9C5; color: #172A32">Save</button>
                </div>
                <div id="sensorThresholdAlertDiv" class="alert alert-warning mt-2" role="alert" style="display: none;">
                    <p id="sensorThresholdAlertMessage"></p>
                </div>

                <div class="row justify-content-between">
                <div class="col-auto">
                <c:if test="${sensor.showNotifications==true}">
                    <div class="form-check form-switch notifications">
                        <input class="form-check-input" type="checkbox" role="switch" onclick="switchNotificationState(this)" checked id="notificationOn">
                        <label class="form-check-label" for="notificationOn">Notifications are on</label>
                    </div>
                </c:if>
                <c:if test="${sensor.showNotifications==false}">
                    <div class="form-check form-switch notifications">
                        <input class="form-check-input" type="checkbox" role="switch" onclick="switchNotificationState(this)" id="notificationOff">
                        <label class="form-check-label" for="notificationOff">Notifications are off</label>
                    </div>
                </c:if>
                </div>
                    <div class="col-auto automation">
                        <c:if test="${sensor.partnerActuator!=null && sensor.automatePartnerActuatorBasedOnThresholds==false}">
                            <div class="form-check form-switch ">
                                <input class="form-check-input" type="checkbox" role="switch" onclick="switchAutomationState(this)" id="automationOff">
                                <label class="form-check-label" for="automationOff">Automation turned off</label>
                            </div>
                        </c:if>
                        <c:if test="${sensor.partnerActuator != null && sensor.automatePartnerActuatorBasedOnThresholds == true}">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" id="automationOn" onclick="switchAutomationState(this)" checked>
                                <label class="form-check-label" for="automationOff" >Automation turned on</label>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</c:forEach>


    </div>
</div>
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/notification.js"></script>
<script>
    $(document).ready(function(){
        $('[data-bs-toggle="tooltip"]').tooltip();
    });
</script>
</body>
<script>

    function switchAutomationState(currentObject){
        console.log("switching automation state");
        const isChecked = currentObject.checked;
        console.log("Is checked :"+isChecked);

        if(isChecked){
            $(currentObject).closest('.automation').find('.form-check-label').text("Automation turned on");
        }
        else{
            $(currentObject).closest('.automation').find('.form-check-label').text("Automation turned off");
        }

        const sensorId = $(currentObject).closest('.sensorCard').find('#sensorId').text();
        $.ajax({
            url:"/switchAutomationState",
            type:"POST",
            data : {
                sensorId: sensorId,
                state: isChecked
            },
            success: function(response){
                if(response == "Success"){
                    console.log("Success");
                }
                else{
                    console.log("Error");
                }
            }
        })
    }

    function switchNotificationState(currentObject){
        console.log("switching notification state");
        const isChecked = currentObject.checked;
        console.log("Is checked :"+isChecked);

        if(isChecked){
            $(currentObject).closest('.notifications').find('.form-check-label').text("Notifications are on");
        }
        else{
            $(currentObject).closest('.notifications').find('.form-check-label').text("Notifications are off");
        }

        const sensorId = $(currentObject).closest('.sensorCard').find('#sensorId').text();
        $.ajax({
            url:"/switchNotificationState",
            type:"POST",
            data : {
                sensorId: sensorId,
                state: isChecked
            },
            success: function(response){
                if(response == "Success"){
                    console.log("Success");
                }
                else{
                    console.log("Error");
                }
            }
        })
    }


    function editSensorThreshold(currentObject) {
        $(currentObject).closest('.sensorCard').find('#sensorThreshold').prop('disabled', false);
        $(currentObject).closest('.sensorCard').find('#editButton').hide();
        $(currentObject).closest('.sensorCard').find('#saveButton').show();

    }

    function saveSensorThreshold(currentObject) {
        const newSensorThreshold = $(currentObject).closest('.sensorCard').find('#sensorThreshold').val();
        if (newSensorThreshold < 0){
            $(currentObject).closest('.sensorCard').find('#sensorThresholdAlertMessage').text("Please enter a positive number");
            $(currentObject).closest('.sensorCard').find('#sensorThresholdAlertDiv').show();
            return;
        }

        $(currentObject).closest('.sensorCard').find('#sensorThresholdAlertDiv').hide();
        const sensorId= $(currentObject).closest('.sensorCard').find('#sensorId').text();
        $(currentObject).closest('.sensorCard').find('#sensorThreshold').prop('disabled', true);
        $(currentObject).closest('.sensorCard').find('#editButton').show();
        $(currentObject).closest('.sensorCard').find('#saveButton').hide();
        $.ajax({
            url:"/updateThreshold",
            type:"POST",
            data : {
                sensorId: sensorId,
                newThresholdValue: newSensorThreshold
            },
            success: function(response){
                if(response == "Success"){
                    console.log("Success");
                }
                else{
                    console.log("Error");
                }
            }
        })

    }

    $(document).ready(function () {
        //Every 30 seconds, it polls /checkNotification
        setInterval(function(){
            console.log("Checking notification");
            $.ajax({
                url: "/checkNotification",
                type: "GET",
                success: function(response){
                    if(response!=="null"){
                        showNotification(response);
                    }
                }
            })
        }, 30000);
    });

</script>
</html>
