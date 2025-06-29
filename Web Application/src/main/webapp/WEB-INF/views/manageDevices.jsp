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
    <title>Manage Device</title></head>
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
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button onclick="window.location.href='/logout'" type="button" class="btn btn-danger">Logout</button>
            </div>
        </div>
    </div>
</div>

<!-- Removal Modal -->
<div class="modal fade" id="removalConfirmModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5">Are you sure you want to remove this from your network?</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                This will delete all data connecting you and the device.
            </div>
            <div class="modal-footer">
                <button id="closeButton" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button id="removeConfirmButton" type="button" class="btn btn-danger">Remove Device</button>
            </div>
        </div>
    </div>
</div>

<div class="container" style="border-radius: 3%">
    <div class="row justify-content-center">
        <div class="card p-3 col-lg-6">
            <h2 class="text-center">Your Devices</h2>
            <c:if test="${sensors.size()>0}">
            <small class="text-center text-muted mb-3">You cannot remove the Hub and the Occupancy device unless
                everything else is removed </small>
            </c:if>

            <div class="container-fluid">
            <div class="row justify-content-evenly">
            <button class="col-auto btn themeButton mb-4" onclick="window.location.href='/setUpDevice'">
                <div class="row g-1 align-items-center">
                    <div class="col">
                        Add new Device(s)
                    </div>
                    <div class="col">
                        <lord-icon
                                src="https://cdn.lordicon.com/sbnjyzil.json"
                                trigger="hover"
                                stroke="bold"
                                colors="primary:#FFFFFF,secondary:#FFFFFF">
                        </lord-icon>
                    </div>
                </div>
            </button>
                <c:if test="${not empty hub}">
                <button class="col-auto btn themeButton mb-4" id="wifiButton" onclick="resetHubWifi()">
                    <div class="row g-1 align-items-center">
                        <div class="col-auto">
                            Reset WiFi details for Hub
                        </div>
                        <div class="col-auto">
                            <lord-icon
                                    src="https://cdn.lordicon.com/bvdjlgnl.json"
                                    trigger="hover"
                                    stroke="bold"
                                    state="loop-cycle"
                                    colors="primary:#FFFFFF,secondary:#FFFFFF">
                            </lord-icon>
                        </div>
                    </div>
                </button>
                </c:if>
            </div>
                <div id="successAlert" class="alert alert-success" style="display: none" role="alert">
                    Successfully reset Hub's WiFi details. Please note that repeatedly resetting the WiFi will require the Hub to repeatedly ask you to re-enter the credentials in the WiFi set up process. Please see the FAQ section on "How can I connect my Hub to my home WiFi network" for details on how to reset the WiFi details.
                </div>
                <c:if test="${not empty removal}">
                    <div class="alert alert-success" role="alert">
                        Successfully removed device(s) from your network
                    </div>
                </c:if>
            </div>




            <%-- If there are no other sensors, then user can fully delete the hub and occupancy sensor--%>
            <c:if test="${sensors.size()==1}">
                <div class="col-auto">
                <div class="card mb-3 deviceCard">
                    <div class="row ">
                    <div class="card-body col-6">
                        <p><b class="card-title">Hub:</b></p>
                    </div>
                        <div class="card-body col-6">
                            <div class="row justify-content-center">
                                <p class="col-auto"><b class="card-title">Added on: ${hub.implementationTimestamp.toLocalDate()}</b></p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card mb-3 deviceCard">
                    <div class="row ">
                        <div class="card-body col-6">
                            <p><b class="card-title">Occupancy:</b></p>
                        </div>
                        <div class="card-body col-6">
                            <div class="row justify-content-center">
                                <p class="col-auto"><b class="card-title">Added on: ${sensors.iterator().next().implementationTimestamp.toLocalDate()}</b></p>
                            </div>
                        </div>
                    </div>
                </div>
                </div>

                <div class="col-auto">
                <button id="removeHubAndOccupancyButton" class="btn btn-sm btn-danger mb-4" type="button"
                        onclick="showRemovalModalForCoreDevices()">Remove Both Devices
                </button>
                </div>
            </c:if>

            <c:if test="${sensors.size()>1}">
                <div class="card mb-3 deviceCard">
                    <div class="row ">
                        <div class="card-body col-6">
                            <p><b class="card-title">Hub</b></p>
                        </div>
                        <div class="card-body col-6">
                            <div class="row justify-content-center">
                            <p class="col-auto"><b class="card-title">Added on: ${hub.implementationTimestamp.toLocalDate()}</b></p>
                            </div>
                        </div>
                    </div>
                </div>


                <c:forEach items="${sensors}" var="sensor">
                    <div class="card mb-3 deviceCard">
                        <div class="row ">
                            <p style="display: none" id="sensorId">${sensor.sensorId}</p>
                            <div class="card-body col-6">
                                <p><b class="card-title">${sensor.sensorType.name}</b></p>

                            <c:if test="${sensor.partnerActuator != null}">
                                <p><b class="card-title">${sensor.partnerActuator.actuatorType.name}</b></p>
                            </c:if>
                            </div>
                            <div class="card-body  col-6">
                                <div class="row justify-content-center">
                                <p class="col-auto"><b class="card-title">Added on: ${sensor.implementationTimestamp.toLocalDate()}</b></p>
                                </div>

                            <div class="row justify-content-center">
                            <c:if test="${!sensor.sensorType.name.equals(\"Occupancy\") && sensor.partnerActuator != null}">
                                <button id="removeButton" class="col-auto btn btn-sm btn-danger mb-4" type="button"
                                        onclick="showRemovalModalForDevices(this)">Remove Both Devices
                                </button>
                            </c:if>
                            <c:if test="${!sensor.sensorType.name.equals(\"Occupancy\") && sensor.partnerActuator == null}">
                                <button id="removeButton" class="col-auto btn btn-sm btn-danger mb-4" type="button"
                                        onclick="showRemovalModalForDevice(this)">Remove Device
                                </button>
                            </c:if>
                            </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
        </div>
    </div>
</div>


<script type="text/javascript" src="${pageContext.request.contextPath}/js/notification.js"></script>

</body>
<script>
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

    function showRemovalModalForDevices(currentObject) { //For both sensor and actuator
        console.log("Reached showRemovalModalForDevices");

        $('#removalConfirmModal').modal('show');
        $('#removeConfirmButton').on('click', function () {
            console.log("Remove button clicked");
            removeConnectedDevice(currentObject, 2);
        });
        $('#closeButton').on('click', function () {
            console.log("Close button clicked");
            return;
        });
    }

    function showRemovalModalForDevice(currentObject) { //Only for no-partner sensor
        console.log("Reached showRemovalModalForDevice");
        $('#removalConfirmModal').modal('show');
        $('#removeConfirmButton').on('click', function () {
            console.log("Remove button clicked");
            removeConnectedDevice(currentObject, 1);
        });
        $('#closeButton').on('click', function () {
            console.log("Close button clicked");
            return;
        });
    }

    function showRemovalModalForCoreDevices() {
        console.log("Reached showRemovalModalForCoreDevices");
        $('#removalConfirmModal').modal('show');
        $('#removeConfirmButton').on('click', function () {
            console.log("Remove button clicked");
            removeCoreDevices();
        });
        $('#closeButton').on('click', function () {
            console.log("Close button clicked");
            return;
        });
    }

    function removeConnectedDevice(currentObject, numOfDevices) {
        console.log("Removing device");
        const sensorId = $(currentObject).closest('.deviceCard').find('#sensorId').text();

        if (numOfDevices == 2) {
            $.ajax({
                url: "/removeDevicesFromUserNetwork",
                type: "POST",
                data: {
                    sensorId: sensorId
                },
                success: function (response) {
                    if (response == "Success") {
                        console.log("Success");
                        window.location.href = "/manageDevices?removal=true";
                    } else {
                        console.log("Failed");
                    }
                }
            })
        } else if (numOfDevices == 1) {
            $.ajax({
                url: "/removeDeviceFromUserNetwork",
                type: "POST",
                data: {
                    sensorId: sensorId
                },
                success: function (response) {
                    if (response == "Success") {
                        console.log("Success");
                        window.location.href = "/manageDevices?removal=true";
                    } else {
                        console.log("Failed");
                    }
                }
            })
        }
    }

    function removeCoreDevices() { //Removes hub and occupancy from user's list
        console.log("Removing hub and occupancy");
        $.ajax({
            url: "/removeCoreDevicesFromUserNetwork",
            type: "POST",
            data: {
                hubId: "${hub.hubMacAddress}",
            },
            success: function (response) {
                if (response == "Success") {
                    console.log("Success");
                    window.location.href = "/manageDevices?removal=true";
                } else {
                    console.log("Failed");
                }
            }
        })
    }

    function resetHubWifi() {
        $.ajax({
            url: "/resetHubWifi",
            type: "POST",
            success: function (response) {
                if (response == "Success") {
                    console.log("Success");
                    $('#successAlert').show();
                    $('#wifiButton').prop('disabled', true);
                } else {
                    console.log("Failed");
                }
            }
        })
    }
</script>
</html>
