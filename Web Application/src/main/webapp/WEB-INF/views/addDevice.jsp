<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css"/>
    <script src="https://cdn.lordicon.com/lordicon.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
          rel="stylesheet">
    <title>Add Device</title></head>
<script src="https://unpkg.com/intro.js/intro.js"></script> <!-- Intro.js -->
<link rel="stylesheet" href="https://unpkg.com/intro.js/introjs.css"> <!-- Intro.js CSS -->
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
                    <a class="nav-link btn btn-sm btn-outline-light" href="/thresholdSettings">Threshold Settings</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-sm btn-outline-light active" aria-current="page" href="/manageDevices">Manage
                        devices</a>
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
                <button onclick="window.location.href='/accountSettings'" data-bs-toggle="tooltip" data-bs-title="Account Settings" data-bs-placement="bottom" style="align-self: center"
                        class=" me-3 btn btn-sm themeButton">
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

                <button data-bs-toggle="modal" data-bs-target="#logoutModal" style="align-self: center"
                        class="btn btn-sm themeButton">
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

<%--Spinner code--%>
<div id="loadingScreen" class="container-fluid" style="display: none; ">
    <div class="d-flex flex-column align-items-center">
        <div class="spinner-grow text-info" style="width: 5rem; height: 5rem;" role="status">
        </div>
        <p>Working on the magic</p>
        <small>Do not refresh the page or navigate away</small>
    </div>
</div>


<div class="container" style="border-radius: 3%">
    <div class="row justify-content-center">
        <div class="card p-3 col-lg-6">
        <h2 class="text-center">Set up new Device</h2>
            <p class="text-muted"> Please ensure your new devices are switched off</p>
            <div class="card p-4 mb-2 card-body">
            <div id="formBox">
                <select class="form-select mb-4" id="deviceSelected">
                    <option selected>Select what you want to set up</option>
                    <c:forEach items="${unownedSensorType}"
                               var="device">
                        <c:choose>
                            <c:when test="${device.partnerActuatorType==null}">
                                <option value="${device.name},null">${device.name}</option>
                            </c:when>
                            <c:otherwise> <%--For displaying paired sensor and actuator --%>
                                <option value="${device.name},${device.partnerActuatorType.name}">${device.name}
                                    and ${device.partnerActuatorType.name}</option>
                            </c:otherwise>
                        </c:choose>

                    </c:forEach>
                </select>

                <button type="button" class="btn themeButton " data-bs-toggle="modal"
                        onclick="showSensorModalForm()">Confirm
                </button>
            </div>


            <!-- Sensor Modal -->
            <div class="modal fade" id="sensorModal" tabindex="-1" aria-labelledby="sensorModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="sensorModalLabel">Setting up </h1>
                            <button type="button" class="btn-close btn themeButton btn-secondary"
                                    data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" id="sensorPairCodeDiv">
                            <label class="mb-2" for="sensorPairCode">Please enter the pair code for the sensor:</label>
                            <input type="text" id="sensorPairCode" name="sensorPairCode"
                                   placeholder="Enter pair code" required>
                                <div id="sensorDiv" class="alert alert-warning mt-4" role="alert" style="display: none;">
                                    <p id="sensorResultMessage"></p>
                                </div>
                        </div>

                        <div class="modal-footer">
                            <button class="btn themeButton" type="submit" id="AddSensorButton"
                                    onclick="doSensorPairing()">Add Sensor
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Actuator Modal -->
            <div class="modal fade" id="actuatorModal" tabindex="-1" aria-labelledby="actuatorModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="actuatorModalLabel">Setting up </h1>
                            <button type="button" class="btn-close btn btn-secondary themeButton"
                                    data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <label for="actuatorPairCode">Please enter the pair code for the actuator:</label>
                            <input type="text" id="actuatorPairCode" name="actuatorPairCode" placeholder="Enter pair code" required>
                                <div id="actuatorDiv" class="alert alert-warning mt-4" role="alert" style="display: none;">
                                    <p id="actuatorResultMessage"></p>
                                </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn themeButton" type="submit" id="AddActuatorButton"
                                    onclick="doActuatorPairing()">Add Actuator
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <c:if test="${ownedSensorsSize<2}">
                <script>
                    introJs().setOptions({
                        tooltipClass: 'introStyle',
                        showProgress: true,
                        positionPrecedence: ['bottom', 'top'],
                        steps: [
                            {
                                element: document.querySelector('#formBox'),
                                intro: "Now we are going to set up your new sensor devices. Please select the item or item pair you are going to set up and have the pair code(s) ready before proceeding. Please do NOT switch on yet to ensure smooth setting up. Click the \"Confirm\" button when you are ready to proceed."
                            },
                        ]
                    }).start();
                </script>
            </c:if>

        </div>
    </div>
</div>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/notification.js"></script>

</body>
<script>
    function showSensorModalForm() {
        console.log("Show modal form clicked");
        var deviceSelected = $('#deviceSelected').val();
        $('#sensorModalLabel').text("Setting up " + deviceSelected.split(",")[0] + " Sensor");
        $('#sensorModal').modal('show');
        introJs().exit();
        setTimeout(function () { //Needed because it needs to wait for the modal to fully show
            introJs().setOptions({
                tooltipClass: 'introStyle',
                showProgress: true,
                positionPrecedence: ['bottom', 'top'],
                steps: [
                    {
                        element: document.querySelector('#sensorPairCodeDiv'),
                        intro: "Please enter the pair code for the " + deviceSelected.split(",")[0] + " Sensor in here and then click the \"Add Sensor\" button to proceed"
                    },

                ]
            }).start();
        }, 500);
    }

    function doSensorPairing() {
        console.log("sensor pairing function clicked");
        const sensorPairCode = $('#sensorPairCode').val();
        console.log("Sensor pair code is " + sensorPairCode);
        $.ajax({
            url: "/verifySensorPairCode",
            type: "POST",
            data: {
                sensorPairCode: sensorPairCode,
                sensorTypeName: $('#deviceSelected').val().split(",")[0]
            },
            success: function (response) {
                if (response.Status == "Success") {
                    console.log(response.Status);
                    console.log(response.Message);
                    $('#sensorDiv').hide();
                    //Whilst it's trying to sync, let the user fill out the actuator form
                    setUpPairedActuator();

                    var deviceSelected = $('#deviceSelected').val();
                    if (deviceSelected.split(",")[1] == "null") {
                        console.log("No paired actuator");
                        waitForHubToSyncWithSensor(false);
                    } else {
                        console.log("Paired actuator");
                        waitForHubToSyncWithSensor(true);
                    }
                } else {
                    console.log(response.Status);
                    console.log(response.Message);
                    $('#sensorResultMessage').text(response.Message);
                    $('#sensorDiv').show();
                }
            },
            error: function (response) {
                console.log(response.Status);
                console.log(response.Message);
                $('#sensorResultMessage').text(response.Message);
                $('#sensorDiv').show();
            }
        });
    }

    function waitForHubToSyncWithSensor(withActuator) {
        console.log("Starting waitForHubToSyncWithSensor");
        const checkInterval = 5000; //5 seconds

        let polling = setInterval(function () {
            $.ajax({
                url: "/checkIfHubSyncedWithSensor",
                type: "GET",
                data: {
                    sensorPairCode: $('#sensorPairCode').val()
                },
                success: function (response) {
                    console.log(response);
                    console.log(withActuator);
                    if (response.Status == "Success") {
                        clearInterval(polling);
                        console.log("Hub has synced with sensor");
                        if (withActuator === false) {
                            introJs().exit();

                            var sensorType=$('#deviceSelected').val().split(",")[0]
                            if (sensorType=="Heart"){
                                introJs().setOptions({
                                    tooltipClass: 'introStyle',
                                    showProgress: true,
                                    steps: [
                                        {
                                            intro: "Your heart sensor has been set up! This is used to detect your heart rate whilst you are working, so please ensure you are wearing it whilst it is powered on, or else it will pick up inaccurate noise data instead. Please wear the glove on your left hand, and tie the pink ribbon around your forefinger so that the front of the sensor is snugly against your skin."
                                        },
                                    ],
                                }).oncomplete(function(){
                                    window.location.href = "/dashboard";
                                }).onbeforeexit(function(){
                                    window.location.href = "/dashboard";
                                }).start();
                            }

                        }
                    } else if (response.Status == "Waiting") {
                        console.log("Hub has not synced with Sensor yet");
                    } else {
                    }
                },
                error: function () {
                    console.log("Reached the error part");
                }
            })
        }, checkInterval)
    }

    function setUpPairedActuator() {
        console.log("Setting up paired actuator");
        var deviceSelected = $('#deviceSelected').val();
        if (deviceSelected.split(",")[1] == "null") {
            console.log("No paired actuator");
            introJs().exit();
            introJs().setOptions({
                tooltipClass: 'introStyle',
                showProgress: true,
                positionPrecedence: ['bottom', 'top'],
                steps: [
                    {
                        intro: "Please switch the new device on, you should see the Hub's indicator change to pink which means the Hub will start the set up process. Please wait for the syncing to complete."
                    },
                ]
            }).start();
            callLoadingScreen();
            return;
        } else {
            $('#sensorModal').modal('hide');
            $('#actuatorModalLabel').text("Setting up " + deviceSelected.split(",")[1] + " Actuator");
            $('#actuatorModal').modal('show');

            introJs().exit();
            setTimeout(function () { //Needed because it needs to wait for the modal to fully show
                introJs().setOptions({
                    tooltipClass: 'introStyle',
                    showProgress: true,
                    positionPrecedence: ['bottom', 'top'],
                    steps: [
                        {
                            intro: "Please switch the first device on only, you should see the Hub's indicator change to pink which means the Hub will start the set up process. Click Next when you have turned on the sensor device."
                        },
                        {
                            element: document.querySelector('#actuatorPairCode'),
                            intro: "Please enter the pair code for the " + deviceSelected.split(",")[1] + " Actuator in here and then click the \"Add Actuator\" button to proceed"
                        },

                    ]
                }).start();
            }, 500);
        }
    }


    function doActuatorPairing() {
        console.log("Actuator pairing function clicked");
        const actuatorPairCode = $('#actuatorPairCode').val();
        console.log("actuator pair code is " + actuatorPairCode);
        $.ajax({
            url: "/verifyActuatorPairCode",
            type: "POST",
            data: {
                actuatorPairCode: actuatorPairCode,
                actuatorTypeName: $('#deviceSelected').val().split(",")[1]
            },
            success: function (response) {
                if (response.Status == "Success") {
                    console.log(response.Status);
                    console.log(response.Message);
                    $('#actuatorDiv').hide();

                    introJs().exit();
                    introJs().setOptions({
                        tooltipClass: 'introStyle',
                        showProgress: true,
                        positionPrecedence: ['bottom', 'top'],
                        steps: [
                            {
                                intro: "When the new sensor's indicator has turned purple and hub's indicator has momentarily turned pink or is orange again, then please switch your actuator device on"
                            },
                        ]
                    }).start();
                    callLoadingScreen();
                    waitForHubToSyncWithActuator();
                } else {
                    console.log(response.Status);
                    console.log(response.Message);
                    $('#actuatorResultMessage').text(response.Message);
                    $('#actuatorDiv').show();
                }
            },
            error: function (response) {
                console.log(response.Status);
                console.log(response.Message);
                $('#actuatorResultMessage').text(response.Message);
                $('#actuatorDiv').show();
            }
        });
    }


    function waitForHubToSyncWithActuator() {
        console.log("Starting waitForHubToSyncWithActuator");
        const checkInterval = 5000; //5 seconds

        let polling = setInterval(function () {
            $.ajax({
                url: "/checkIfHubSyncedWithActuator",
                type: "GET",
                data: {
                    actuatorPairCode: $('#actuatorPairCode').val()
                },
                success: function (response) {
                    if (response.Status == "Success") {
                        clearInterval(polling);
                        console.log("Hub has synced with Actuator");

                        introJs().exit();

                        var sensorType=$('#deviceSelected').val().split(",")[0]
                        if (sensorType=="Light"){
                            introJs().setOptions({
                                tooltipClass: 'introStyle',
                                showProgress: true,
                                steps: [
                                    {
                                        intro: "Your light sensor and your lamp has been set up! The light sensor is used to detect the light levels in your room. The optimum light levels suggested by CIBSE (Chartered Institution of Building Services Engineers) is for a room to be at least 500 lux (which you can adjust in \"Thresholds Settings\"). You can place this on your desk. You can choose to automate the lamp to switch on based on if the light levels are below the threshold, or just keep the lamp to remote control only. Please note the lamp is powered by the mains, and will only turn on if it is plugged in and switched on."
                                    },
                                ],
                            }).oncomplete(function(){
                                window.location.href = "/dashboard";
                            }).onbeforeexit(function(){
                                window.location.href = "/dashboard";
                            }).start();
                        }
                        else if(sensorType=="Temperature"){
                            introJs().setOptions({
                                tooltipClass: 'introStyle',
                                showProgress: true,
                                steps: [
                                    {
                                        intro: "Your temperature sensor and your fan has been set up! The temperature sensor is used to detect the temperature in your room. You can choose to automate the fan to switch on based on if the temperature levels are below the threshold, or just keep the fan to remote control only. Please note the fan will only work if it is powered on."
                                    },
                                ],
                            }).oncomplete(function(){
                                window.location.href = "/dashboard";
                            }).onbeforeexit(function(){
                                window.location.href = "/dashboard";
                            }).start();
                        }
                    } else if (response.Status == "Waiting") {
                        console.log("Hub has not synced with actuator yet");
                    } else {
                    }
                },
                error: function () {
                    console.log("Reached the error part");
                }
            })
        }, checkInterval)
    }

    function callLoadingScreen() {
        $('#loadingScreen').show();
        $('#loadingScreen').css('visibility', 'visible');
        $('#loadingScreen').css('z-index', '9999');
        $('#loadingScreen').css('display', 'flex');
        $('#loadingScreen').css('position', 'fixed');
        $('#loadingScreen').css('top', '0');
        $('#loadingScreen').css('left', '0');
        $('#loadingScreen').css('width', '100%');
        $('#loadingScreen').css('height', '100%');
        $('#loadingScreen').css('align-items', 'center');
        $('#loadingScreen').css('justify-content', 'center');
        $('#loadingScreen').css('background-color', 'rgba(255, 255, 255, 0.5)');
    }

    $(document).ready(function () {
        //Every 30 seconds, it polls /checkNotification
        setInterval(function () {
            console.log("Checking notification");
            $.ajax({
                url: "/checkNotification",
                type: "GET",
                success: function (response) {
                    if (response !== "null") {
                        showNotification(response);
                    }
                }
            })
        }, 30000);
        $('[data-bs-toggle="tooltip"]').tooltip();
    });
</script>

</html>