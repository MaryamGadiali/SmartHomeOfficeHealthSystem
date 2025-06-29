<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
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
    <title>Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.6.0/dist/echarts.min.js"></script>
    <script src="https://unpkg.com/intro.js/intro.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/intro.js/introjs.css">
    <script>
        <%-- Has to be placed here or will cause error --%>
        function showLineGraphTodaysData(typeName, graphName, title, legendName, unitName) {
            var times = [];
            var values = [];
            var firstHour = 25;
            var lastHour = -1;
            console.log("Type Name: " + typeName);
            if (typeName == "Light") {
                <c:forEach var="reading" items="${LightToday}">
                console.log("Time: " + "${reading.timestamp.getHour()}");
                console.log("Value: " + ${reading.value});

                var readingMinute = ${reading.timestamp.getMinute()};
                var readingHour = ${reading.timestamp.getHour()};

                if (readingMinute < 10) {
                    times.push("${reading.timestamp.hour}:0${reading.timestamp.minute}");
                } else {
                    times.push("${reading.timestamp.hour}:${reading.timestamp.minute}");
                }

                if (readingHour < firstHour) {
                    firstHour = ${reading.timestamp.getHour()};
                    console.log("First Hour updated: " + firstHour);
                }
                if (readingHour > lastHour) {
                    lastHour = ${reading.timestamp.getHour()};
                    console.log("Last Hour updated: " + lastHour);
                }
                var value =${reading.value}.toFixed(0);
                values.push(value);
                </c:forEach>
            } else if (typeName == "Heart") {
                <c:forEach var="reading" items="${HeartToday}">
                console.log("Time: " + "${reading.timestamp.getHour()}");
                console.log("Value: " + ${reading.value});

                var readingMinute = ${reading.timestamp.getMinute()};
                var readingHour = ${reading.timestamp.getHour()};

                if (readingMinute < 10) {
                    times.push("${reading.timestamp.hour}:0${reading.timestamp.minute}");
                } else {
                    times.push("${reading.timestamp.hour}:${reading.timestamp.minute}");
                }

                if (readingHour < firstHour) {
                    firstHour = ${reading.timestamp.getHour()};
                    console.log("First Hour updated: " + firstHour);
                }
                if (readingHour > lastHour) {
                    lastHour = ${reading.timestamp.getHour()};
                    console.log("Last Hour updated: " + lastHour);
                }
                var value =${reading.value}.toFixed(0);
                values.push(value);
                </c:forEach>
            } else {
                return;
            }

            var hours = [];
            var chartCreation = echarts.init(document.getElementById(graphName));

            var option = {
                color: ['#33B2E9'],
                title: {
                    text: title,
                    left: 'center'
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: [legendName]
                },
                grid: {
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: times,
                    axisLabel: {
                        interval: 0,
                        formatter: function (value, index) {
                            console.log("Index "+index)
                            console.log("Value: "+value)
                            var hourVal = value.split(":")[0];
                            var firstIndexOfHour = times.findIndex(val => val.startsWith(hourVal));
                            console.log("First Index of Hour: "+firstIndexOfHour);
                            if (firstIndexOfHour == index){
                                return hourVal + ":00";
                            }
                            else{
                                return "";
                            }
                        },
                        rotate: 90,
                        hideOverlap: true
                    }
                },
                yAxis: {
                    type: "value",
                    min: 'dataMin',
                    axisLabel: {
                        formatter: '{value} ' + unitName
                    }
                },
                series: [
                    {
                        animationDuration: 1000,
                        type: 'line',
                        data: values,
                        markPoint: {
                            data: [
                                {type: 'max', name: 'Max',label:{formatter:function (value){
                                            return Math.round(value.value);
                                        }}},
                                {type: 'min', symbolRotate:'180', name: 'Min',label:{formatter:function (value){
                                            return Math.round(value.value);
                                        },position:'insideBottom'}},
                            ]
                        },
                        markLine: {
                            data: [
                                {type: 'average', name: 'Avg',label:{formatter:function (value){
                                            return Math.round(value.value);
                                        },
                                        }
                                },
                            ]
                        }
                    }
                ]
            };
            chartCreation.setOption(option);
        }
    </script>
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
                    <a class="nav-link active btn btn-sm btn-outline-light" aria-current="page" href="/dashboard">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-sm btn-outline-light" href="/thresholdSettings">Threshold Settings</a>
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
                <button onclick="window.location.href='/accountSettings'" data-bs-toggle="tooltip" data-bs-title="Account Settings" data-bs-placement="bottom"
                        class="me-3 btn btn-sm themeButton" >
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


<c:if test="${not empty Lamp || not empty Fan}">
    <div class="row container-fluid"  >
        <div class="container card col-md-12 shadow-sm mb-2 mt-3" style=" background-color: #EFF4F6">
            <div class="row justify-content-evenly">
                <c:if test="${not empty Lamp}">
                    <div class="col-auto deviceParent" id="Lamp" style="background-color: #FDFEFF; border-radius: 13%">
                        <div class="row justify-content-end">
                            <div class="col-auto">
                                <p class="state">
                                    <c:if test="${Lamp.state==true}">
                                        ON
                                    </c:if>
                                    <c:if test="${Lamp.state==false}">
                                        OFF
                                    </c:if>
                                </p>
                            </div>
                            <div class="form-check form-switch col-auto ">
                                <c:if test="${Lamp.state==true}">
                                    <input class="form-check-input switchInput" type="checkbox" role="switch"
                                           onclick="sendDeviceCommandToHub(this)" checked>
                                </c:if>
                                <c:if test="${Lamp.state==false}">
                                    <input class="form-check-input switchInput" type="checkbox" role="switch"
                                           onclick="sendDeviceCommandToHub(this)">
                                </c:if>
                            </div>
                        </div>
                        <div class="row justify-content-center">
                            <div class="col-auto">
                                <lord-icon
                                        src="https://cdn.lordicon.com/ftkqrswy.json"
                                        trigger="hover"
                                        stroke="bold"
                                        colors="primary:#33b2e9,secondary:#33b2e9">
                                </lord-icon>
                            </div>
                        </div>
                        <div class="row justify-content-center">
                            <div class="col-auto">
                                <p class="actuatorName">Lamp</p>
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty Fan}">

                    <div class="col-auto deviceParent " id="Fan" style="background-color: #FDFEFF; border-radius: 13%">
                        <div class="row justify-content-end">
                            <div class="col-auto">
                                <p class="state">
                                    <c:if test="${Fan.state==true}">
                                        ON
                                    </c:if>
                                    <c:if test="${Fan.state==false}">
                                        OFF
                                    </c:if>
                                </p>
                            </div>
                            <div class="form-check form-switch col-auto ">
                                <c:if test="${Fan.state==true}">
                                    <input class="form-check-input switchInput" type="checkbox" role="switch"
                                           onclick="sendDeviceCommandToHub(this)" checked>
                                </c:if>
                                <c:if test="${Fan.state==false}">
                                    <input class="form-check-input switchInput" type="checkbox" role="switch"
                                           onclick="sendDeviceCommandToHub(this)">
                                </c:if>

                            </div>
                        </div>
                        <div class="row justify-content-center">
                            <div class="col-auto">
                                <lord-icon
                                        src="https://cdn.lordicon.com/xjritjum.json"
                                        trigger="hover"
                                        stroke="bold"
                                        colors="primary:#33b2e9,secondary:#33b2e9">
                                </lord-icon>
                            </div>
                        </div>
                        <div class="row justify-content-center">
                            <div class="col-auto">
                                <p class="actuatorName">Fan</p>
                            </div>
                        </div>
                    </div>
                </c:if>

            </div>
        </div>
    </div>
</c:if>

<ul class="nav nav-tabs justify-content-center">
    <li class="nav-item">
        <a class="nav-link themeButton btn" id="TodaysData" style="cursor: pointer; background-color: #179AD2; color: #FDFEFF "
           onclick="displayTodaysData()">Today</a>
    </li>
    <li class="nav-item">
        <a class="nav-link themeButton btn" id="AllData" style="cursor: pointer; background-color: #33B2E9; color: #FDFEFF" onclick="displayAllData()">All time</a>
    </li>
</ul>

<div class=" p-1 container-fluid"  >
    <div class="row justify-content-center"  >
        <div class="row">
            <c:choose>
            <c:when test="${!hasHub}">
                <div class="row justify-content-center">
                    <div class=" col-auto mt-2">
                        <button id="setUpHubButton" type="submit" class="btn themeButton"
                                onclick="directToAddHubPage()">
                            <div class="row g-1 align-items-center">
                                <div class="col">
                                    Set up Hub
                                </div>
                                <div class="col">
                                    <lord-icon
                                            src="https://cdn.lordicon.com/bnxnryzv.json"
                                            trigger="in"
                                            delay="750"
                                            state="in-reveal"
                                            stroke="bold"
                                            colors="primary:#FFFFFF,secondary:#FFFFFF">
                                    </lord-icon>
                                </div>
                            </div>
                        </button>
                    </div>
                </div>

                <c:if test="${!hasReadings}">
                    <script>
                        introJs().setOptions({
                            tooltipClass: 'introStyle', confine: 'true',
                            showProgress: true,
                            steps: [
                                {
                                    intro: "Hi there, I can see you are a new user!"
                                },
                                {
                                    element: document.querySelector('#setUpHubButton'),
                                    intro: "Click here to start setting up your system!"
                                }
                            ]
                        }).start();
                    </script>
                </c:if>
            </c:when>
                    <%-- For if the user has hub, but not seating sensor--%>
            <c:when test="${hasHub && (amountOfSensors==0)}">
                <div class="row justify-content-center">
                    <div class=" col-auto mt-2">
                        <button type="submit" class="btn themeButton"
                                onclick="window.location.href='/setUpOccupancySensor'">
                            <div class="row g-1 align-items-center">
                                <div class="col">
                                    Set up Occupancy Sensor
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
                    </div>
                </div>
            </c:when>
            <c:otherwise>
        </div>
    </div>


    </c:otherwise>
    </c:choose>

    <%--Todays section--%>
    <div id="todaySection" class="container-fluid" style="display: block;">
        <div class="row justify-content-evenly" style="background-color: #FDFEFF; border-radius: 3%;" >
            <c:if test="${hasHub && (amountOfSensors==1)}">
                <div class="col-md-6 col-sm-12">
                    <c:if test="${not empty OccupancyToday || not empty ongoingOccupancyTime}">
                        <div class="apacheChart" id="occupancyGraph" style="min-height: 400px; width: 100%;"></div>
                    </c:if>
                </div>
            </c:if>

            <c:if test="${not empty TemperatureToday}">
                <div class="row justify-content-evenly">
                <div style="background-color: #33B2E9; border-radius: 7%" class="col-auto p-3 m-1">
                    <div class=" row justify-content-evenly container-fluid" >
                        <div class="col-4" >
                            <lord-icon
                                    src="https://cdn.lordicon.com/efxlyrtc.json"
                                    trigger="hover"
                                    stroke="bold"
                                    colors="primary:#FDFEFF,secondary:#FDFEFF"
                                    style="width:100%;height:100%; min-width: 50px; "
                            >
                            </lord-icon>
                        </div>
                        <div class="col-8" >
                            <div class="row">
                                <p><b style="color: #FDFEFF">Temperature</b></p>
                            </div>
                            <div class="row">
                                <b style="color: #FDFEFF"><p id="tempTodayVal">A</p></b>
                            </div>
                        </div>
                    </div></div>


                    <script>
                        var total = 0;
                        var average = 0;

                        <c:if test="${TemperatureToday.size()<3}">
                            <c:forEach items="${TemperatureToday}" var="tempObj">
                            total += ${tempObj.value};
                            average = (parseFloat(total)) / ${TemperatureToday.size()};
                            </c:forEach>
                        </c:if>

                        <c:if test="${TemperatureToday.size()>=3}">
                            <c:forEach items="${TemperatureToday.subList(TemperatureToday.size()-3,TemperatureToday.size())}" var="tempObj" >
                            total += ${tempObj.value};
                            average = total / 3.0;
                            </c:forEach>
                        </c:if>
                        console.log("Total is: ");
                        console.log(total);
                        average = average.toFixed(0);
                        $('#tempTodayVal').text(average + " \u00B0C");

                    </script>
                </div>
            </c:if>
            <c:if test="${not empty LightToday}">
            <div style="border: 1px solid #FDFEFF; background-color: #FDFEFF; border-radius: 7%" class="col-md-6 col-sm-12">
                    <div class="apacheChart" id="lightGraph" style="min-height: 400px; width: 100%"></div>
                </div>
                <script>
                    showLineGraphTodaysData("Light", "lightGraph", "Today's Light Levels", "Light", "Lux");
                </script>
            </c:if>

            <c:if test="${not empty OccupancyToday || not empty ongoingOccupancyTime}">
                <div style="border: 1px solid #FDFEFF; background-color: #FDFEFF; border-radius: 7%" class="col-md-6 col-sm-12">
                    <div class="apacheChart" id="occupancyGraph" style="min-height: 400px; width: 100%;"></div>
                </div>
                <script>
                    var occupancyChart = echarts.init(document.getElementById('occupancyGraph'));
                    var valueM = 0; //this is in minutes
                    <c:forEach var="occupancyReading" items="${OccupancyToday}">
                    valueM += ${occupancyReading.getValue()};
                    console.log("Occupancy reading:");
                    console.log(${occupancyReading.getValue()});
                    </c:forEach>
                    <c:if test="${not empty ongoingOccupancyTime}">
                    valueM += ${ongoingOccupancyTime};
                    console.log("Ongoing occupancy reading:");
                    console.log(${ongoingOccupancyTime});
                    </c:if>
                    valueM = valueM.toFixed(0);
                    console.log("ValueM: " + valueM);
                    var remainingTimeOfDay = (24 * 60) - valueM;
                    option = {
                        color: ['#e0507d','#33b2e9'],
                        title: {
                            text: 'Amount of time spent sitting today',
                            left: 'center'
                        },
                        tooltip: {
                            trigger: 'item', confine: 'true',
                        },
                        grid: {
                            containLabel: true
                        },
                        series: [
                            {
                                type: 'pie',
                                radius: '50%',
                                label: {
                                    position: 'outside',
                                    fontSize: 14,
                                },
                                data: [
                                    {value: valueM, name: valueM + " minutes spent sitting"},
                                    {value: remainingTimeOfDay, name: "Minutes today not sitting"}
                                ],
                            }
                        ]
                    };
                    occupancyChart.setOption(option);
                </script>
            </c:if>

            <c:if test="${not empty HeartToday}">
                <div style="border: 1px solid #FDFEFF; background-color: #FDFEFF; border-radius: 7%" class="col-md-6 col-sm-12">
                    <div class="apacheChart" id="heartGraph" style="min-height: 400px; width: 100%"></div>
                </div>
                <script>
                    console.log("Showing heart graph");
                    showLineGraphTodaysData("Heart", "heartGraph", "Today's Heart Levels", "Heart", "BPM");
                </script>
            </c:if>
        </div>
    </div>

    <div id="allSection" class="container-fluid" style="display: none">
        <c:if test="${hasPastData}">
            <div class="row justify-content-center mb-4">
                <div class="col-md-6 col-sm-12">
                <select class="form-select" onchange="showSelectedOption(this)">
                    <option selected>Open this select menu</option>
                    <option value="Week">Last 7 days</option>
                    <option value="Month">Last 30 days</option>
                    <option value="All">All time</option>
                    <option value="Custom">Custom range</option>
                </select>
                </div>
            </div>
        </c:if>

        <div class="container mb-2 " id="customDateSelector" style="display: none;  border: 1px solid rgba(0, 0, 0, 0.176);">
            <div class="row align-items-center p-1" style=" border-radius: 7%; background-color: #FDFEFF">
                <div class="col">
                    <label for="startDate">Start date</label>
                    <input type="date" class="form-control" id="startDate" placeholder="Start date"
                           aria-label="Start date" required>
                </div>
                <div class="col">
                    <label for="endDate">End date</label>
                    <input type="date" class="form-control" id="endDate" placeholder="End date" aria-label="End date"
                           required>
                </div>
                <div class="col">
                    <button type="submit" onclick="showCustomGraphs()" class="btn themeButton">Confirm</button>
                </div>
            </div>
            <div class="alert alert-warning mt-2" role="alert" id="alertMessage" style="display: none">
                Please enter valid start and end dates in both fields
            </div>
        </div>

        <%--Graphs that can be reused and repopulated depending on which option is selected--%>
        <div class="row">
            <div class="col-md-6 col-sm-12">
                <div class="apacheChart" id="customLightGraph" style="min-height: 400px; width: 100%;display: none "></div>
            </div>
            <div class="col-md-6 col-sm-12">
                <div class="apacheChart" id="customOccupancyGraph" style="min-height: 400px; width: 100%; display: none"></div>
            </div>
            <div class="col-md-6 col-sm-12">
                <div class="apacheChart" id="customTemperatureGraph" style="min-height: 400px; width: 100%;display: none"></div>
            </div>
            <div class="col-md-6 col-sm-12">
                <div class="apacheChart" id="customHeartGraph" style="min-height: 400px; width: 100%;display: none"></div>
            </div>
        </div>
    </div>
</div>

<script>
    function directToAddHubPage() {
        window.location.href = "/addHub";
    }

    function sendDeviceCommandToHub(currentObject) {
        var deviceName = $(currentObject).closest('.deviceParent').find('.actuatorName').text();
        console.log(deviceName);
        var state = $(currentObject).closest('.deviceParent').find('.state').text().trim();
        console.log(state);
        var macAddress;
        if (deviceName === "Lamp") {
            macAddress = "${Lamp.macAddress}";
        } else {
            macAddress = "${Fan.macAddress}";
        }
        if (state === "OFF") {
            $(currentObject).closest('.deviceParent').find('.state').text("ON");
            $.ajax({
                url: "/addActuatorCommandForHub",
                type: "POST",
                data: {
                    actuatorMacAddress: macAddress,
                    command: "TurnOn"
                },
                success: function (response) {
                    console.log("Response: " + response);
                }
            })
        } else {
            $(currentObject).closest('.deviceParent').find('.state').text("OFF");
            $.ajax({
                url: "/addActuatorCommandForHub",
                type: "POST",
                data: {
                    actuatorMacAddress: macAddress,
                    command: "TurnOff"
                },
                success: function (response) {
                    console.log("Response: " + response);
                }
            })
        }
    }
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/notification.js"></script>
</body>
<script>
    $(document).ready(function () {
        //Every 30 seconds, checks for notifications
        setInterval(function () {
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

        //Every 10 seconds, checks state of lamp and fan
        setInterval(function () {
            var actuatorAddress = "${Lamp.macAddress}";
            if (actuatorAddress != null && actuatorAddress.trim() !== "") {
                $.ajax({
                    url: "/checkActuatorState",
                    type: "GET",
                    data: {
                        actuatorAddress: "${Lamp.macAddress}"
                    },
                    success: function (response) {
                        if (response) {
                            $('#Lamp').closest('.deviceParent').find('.state').text("ON");
                            $('#Lamp').closest('.deviceParent').find('.switchInput').prop("checked", true);
                        } else {
                            $('#Lamp').closest('.deviceParent').find('.state').text("OFF");
                            $('#Lamp').closest('.deviceParent').find('.switchInput').prop("checked", false);
                        }
                    }
                })
            }
            var actuatorAddress = "${Fan.macAddress}";
            if (actuatorAddress != null && actuatorAddress.trim() !== "") {
                $.ajax({
                    url: "/checkActuatorState",
                    type: "GET",
                    data: {
                        actuatorAddress: "${Fan.macAddress}"
                    },
                    success: function (response) {
                        if (response) {
                            $('#Fan').closest('.deviceParent').find('.state').text("ON");
                            $('#Fan').closest('.deviceParent').find('.switchInput').prop("checked", true);
                        } else {
                            $('#Fan').closest('.deviceParent').find('.state').text("OFF");
                            $('#Fan').closest('.deviceParent').find('.switchInput').prop("checked", false);
                        }
                    }
                })
            }
        }, 10000);

        $('[data-bs-toggle="tooltip"]').tooltip();
    });

    $(window).on('resize', function () {
        $('.chart').resize();
    });

    function displayTodaysData() {
        if ($("#todaySection").css("display") == "none") {
            $("#todaySection").css("display", "block");
            $("#allSection").css("display", "none");
            // $("#TodaysData").addClass("active");
            $("#TodaysData").css("background-color", "#179AD2");
            $("#AllData").css("background-color", "#33b2e9");
            // $("#AllData").removeClass("active");
        }
    }


    function displayAllData() {
        if ($("#allSection").css("display") == "none") {
            $("#allSection").css("display", "block");
            $("#todaySection").css("display", "none");
            $("#AllData").css("background-color", "#179AD2");
            $("#TodaysData").css("background-color", "#33b2e9");
            // $("#AllData").addClass("active");
            // $("#TodaysData").removeClass("active");
        }
    }

    function showBarChartOfTotals(response, customChart, title) {
        const totalValuesPerDay = [];
        var jsonResp = JSON.parse(response);
        var keyArray = Object.keys(jsonResp).sort((a,b) => new Date(a) - new Date(b));
        console.log("CHECK KEYS");
        console.log(keyArray);
        for (const key of keyArray) {
            console.log("Check Key: " + key);
            var total = 0;
            for (var value in jsonResp[key]) {
                // console.log("Value: " + jsonResp[key][value]);
                total += jsonResp[key][value];
            }
            console.log("Total: " + total);
            totalValuesPerDay.push(total.toFixed(0));
        }


        if (totalValuesPerDay.length > 0) {

            //show bar chart
            var option = {
                color: ['#33B2E9'],
                title: {
                    text: title,
                    left: 'center'
                },
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    }
                },
                grid: {
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    data: keyArray,
                    axisLabel: {
                        interval: 0,
                        rotate: 90,
                        hideOverlap: true
                    }
                },
                yAxis: {
                    type: "value",
                    axisLabel: {
                        formatter: '{value} Minutes'
                    }
                },
                series: [
                    {
                        animationDuration: 1000,
                        type: 'bar',
                        barWidth: '70%',
                        data: totalValuesPerDay,
                        markPoint: {
                            data: [
                                {type: 'max', name: 'Max', label:{formatter:function (value){
                                    return Math.round(value.value);
                                        }}},
                                {type: 'min', name: 'Min',label:{formatter:function (value){
                                            return Math.round(value.value);
                                        }}}
                            ]
                        },
                        markLine: {
                            data: [
                                {type: 'average', name: 'Avg', label: {formatter: function (value) {
                                            return Math.round(value.value);
                                        }}},
                            ]
                        }
                    }
                ]
            }
            customChart.setOption(option);
            customChart.resize();
            console.log("Finished");
        } else {
            console.log("Didn't start");
        }
    }


    function showGraphOfAverages(response, customChart, title,unitName) {
        //Response is a hashmap where the keys are hours, and the values are a list of relevant sensor readings
        const averageValues = [];
        var jsonResp = JSON.parse(response);
        var keyArray = Object.keys(jsonResp);
        if (keyArray[0].includes("-")){
            keyArray.sort((a,b) => new Date(a) - new Date(b));
        }

        //Get the averages of the json response
        for (var key of keyArray) {
            console.log("Key: " + key);
            var total = 0;
            for (var value in jsonResp[key]) {
                console.log("Value: " + jsonResp[key][value]);
                total += jsonResp[key][value];
            }
            console.log("Total: " + total);
            console.log("Size: " + jsonResp[key].length);
            console.log("Average: " + Math.round(total / jsonResp[key].length));
            averageValues.push(Math.round(total / jsonResp[key].length));
        }

        console.log(averageValues);
        plotReadings=[];
        if(keyArray[0].includes("-")){
            for (var readingTime in keyArray) {
                plotReadings.push(keyArray[readingTime]);
            }
        }
        else {
            for (var readingTime in keyArray) {
                plotReadings.push(keyArray[readingTime] + ":00");
            }
        }

        console.log(averageValues.length);
        <c:if test="averageValues.length == 0">
        console.log("No data found");
        </c:if>
        if (averageValues.length > 0) {
            var option = {
                color: ['#33B2E9'],
                title: {
                    text: title,
                    left: 'center'
                },
                tooltip: {
                    trigger: 'axis'
                },
                grid: {
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: plotReadings,
                    axisLabel: {
                        interval: 0,
                        formatter: function (value, index) {
                            if (value.includes("-")) {
                                return value;

                            }
                            return value.split(":")[0] + ":00";
                        },
                        rotate: 90,
                        hideOverlap: true
                    },
                },
                yAxis: {
                    type: "value",
                    axisLabel: {
                        formatter: '{value} '+unitName
                    }
                },
                series: [
                    {
                        animationDuration: 1000,
                        type: 'line',
                        data: averageValues,
                        markPoint: {
                            data: [
                                {type: 'max', name: 'Max',label:{formatter:function (value){
                                            return Math.round(value.value);
                                        }}},
                                {type: 'min', symbolRotate:'180',  name: 'Min',label:{formatter:function (value){
                                            return Math.round(value.value);
                                        }, position: 'insideBottom'}},
                            ]
                        },
                        markLine: {
                            data: [
                                {type: 'average', name: 'Avg',label:{formatter:function (value){
                                            return Math.round(value.value);
                                        }}},
                            ],

                        }
                    }
                ]
            };
            customChart.setOption(option);
            customChart.resize();
            console.log("Finished");
        }
        else {
            console.log("Didn't start");
        }
    }


    function showWeek() { //Does not include todays data
        var customLightChart = echarts.init(document.getElementById('customLightGraph'));
        var customOccupancyChart = echarts.init(document.getElementById('customOccupancyGraph'));
        var customTemperatureChart = echarts.init(document.getElementById('customTemperatureGraph'));
        var customHeartChart = echarts.init(document.getElementById('customHeartGraph'));
        $('#customLightGraph').css("display", "block");
        $('#customOccupancyGraph').css("display", "block");
        $('#customTemperatureGraph').css("display", "block");
        $('#customHeartGraph').css("display", "block");

        //Light data
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Week",
                type: "Light"
            },
            success: function (response) {
                console.log("Response for light data: " + response);
                if (response != "null") {
                    var title = "Average light levels per hour";
                    showGraphOfAverages(response, customLightChart, title,"Lux");
                } else {
                    $('#customLightGraph').css("display", "none");
                }
            }
        })

        //Occupancy data
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Week",
                type: "Occupancy"
            },
            success: function (response) {
                console.log("Response for Occupancy data: " + response);
                if (response != "null") {
                    var title = "Sitting time per day";
                    showBarChartOfTotals(response, customOccupancyChart, title);
                } else {
                    console.log("No data found");
                    $('#customOccupancyGraph').css("display", "none");
                }
            }
        })

        //Temperature data
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Week",
                type: "Temperature"
            },
            success: function (response) {
                console.log("Response for Temperature data: " + response);
                if (response != "null") {
                    var title = "Average Temperature levels per day";
                    showGraphOfAverages(response, customTemperatureChart, title,"\u00B0C");
                } else {
                    console.log("No data found");
                    $('#customTemperatureGraph').css("display", "none");
                }
            }
        })

        //Heart data
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Week",
                type: "Heart"
            },
            success: function (response) {
                console.log("Response for Heart data: " + response);
                if (response != "null") {
                    var title = "Average Heart rate per hour";
                    showGraphOfAverages(response, customHeartChart, title, "BPM");
                } else {
                    console.log("No data found");
                    $('#customHeartGraph').css("display", "none");
                }
            }
        })
    }

    function showMonth() {
        var customLightChart = echarts.init(document.getElementById('customLightGraph'));
        var customOccupancyChart = echarts.init(document.getElementById('customOccupancyGraph'));
        var customTemperatureChart = echarts.init(document.getElementById('customTemperatureGraph'));
        var customHeartChart = echarts.init(document.getElementById('customHeartGraph'));
        $('#customLightGraph').css("display", "block");
        $('#customOccupancyGraph').css("display", "block");
        $('#customTemperatureGraph').css("display", "block");
        $('#customHeartGraph').css("display", "block");

        //Light data
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Month",
                type: "Light"
            },
            success: function (response) {
                console.log("Response for light data: " + response);
                if (response != "null") {
                    var title = "Average light levels per hour";
                    showGraphOfAverages(response, customLightChart, title,"Lux");
                } else {
                    console.log("No data found");
                    $('#customLightGraph').css("display", "none");
                }
            }
        })

        //Occupancy
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Month",
                type: "Occupancy"
            },
            success: function (response) {
                console.log("Response for Occupancy data: " + response);
                if (response != "null") {
                    var title = "Sitting time per day";
                    showBarChartOfTotals(response, customOccupancyChart, title);
                } else {
                    console.log("No data found");
                    $('#customOccupancyGraph').css("display", "none");
                }
            }
        })

        //Temperature data
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Month",
                type: "Temperature"
            },
            success: function (response) {
                console.log("Response for Temperature data: " + response);
                if (response != "null") {
                    var title = "Average Temperature levels per day";
                    showGraphOfAverages(response, customTemperatureChart, title,"\u00B0C");
                } else {
                    console.log("No data found");
                    $('#customTemperatureGraph').css("display", "none");
                }
            }
        })

        //Heart data
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Month",
                type: "Heart"
            },
            success: function (response) {
                console.log("Response for Heart data: " + response);
                if (response != "null") {
                    var title = "Average Heart rate per hour";
                    showGraphOfAverages(response, customHeartChart, title,"BPM");
                } else {
                    console.log("No data found");
                    $('#customHeartGraph').css("display", "none");
                }
            }
        })
    }

    function showAll() {
        var customLightChart = echarts.init(document.getElementById('customLightGraph'));
        var customOccupancyChart = echarts.init(document.getElementById('customOccupancyGraph'));
        var customTemperatureChart = echarts.init(document.getElementById('customTemperatureGraph'));
        var customHeartChart = echarts.init(document.getElementById('customHeartGraph'));

        $('#customLightGraph').css("display", "block");
        $('#customOccupancyGraph').css("display", "block");
        $('#customTemperatureGraph').css("display", "block");
        $('#customHeartGraph').css("display", "block");


        //Light
        $.ajax({
            url: "/getPastData",
            data: {
                option: "All",
                type: "Light"
            },
            success: function (response) {
                console.log("Response for light data: " + response);
                if (response != "null") {
                    var title = "Average light levels per hour";
                    showGraphOfAverages(response, customLightChart, title,"Lux");
                } else {
                    console.log("No data found");
                    $('#customLightGraph').css("display", "none");
                }
            }
        })


        //Occupancy
        $.ajax({
            url: "/getPastData",
            data: {
                option: "All",
                type: "Occupancy"
            },
            success: function (response) {
                console.log("Response for Occupancy data: " + response);
                if (response != "null") {
                    var title = "Sitting time per day";
                    showBarChartOfTotals(response, customOccupancyChart, title);
                } else {
                    console.log("No data found");
                    $('#customOccupancyGraph').css("display", "none");
                }
            }
        })

        //Temperature
        $.ajax({
            url: "/getPastData",
            data: {
                option: "All",
                type: "Temperature"
            },
            success: function (response) {
                console.log("Response for Temperature data: " + response);
                if (response != "null") {
                    var title = "Average Temperature levels per day";
                    showGraphOfAverages(response, customTemperatureChart, title,"\u00B0C");
                } else {
                    console.log("No data found");
                    $('#customTemperatureGraph').css("display", "none");
                }
            }
        })

        //Heart
        $.ajax({
            url: "/getPastData",
            data: {
                option: "All",
                type: "Heart"
            },
            success: function (response) {
                console.log("Response for Heart data: " + response);
                if (response != "null") {
                    var title = "Average Heart rate per hour";
                    showGraphOfAverages(response, customHeartChart, title,"BPM");
                } else {
                    console.log("No data found");
                    $('#customHeartGraph').css("display", "none");
                }
            }
        })
    }

    function showCustomSelectors() {
        console.log("Show custom");
        $('#customDateSelector').css("display", "block");
    }

    function showSelectedOption(selectedOption) {
        console.log(selectedOption.value);
        if (selectedOption.value == "Week") {
            showWeek();
            $('#customDateSelector').css("display", "none");
        } else if (selectedOption.value == "Month") {
            showMonth();
            $('#customDateSelector').css("display", "none");
        } else if (selectedOption.value == "All") {
            showAll();
            $('#customDateSelector').css("display", "none");
        } else if (selectedOption.value == "Custom") {
            showCustomSelectors();
        }
    }

    function showCustomGraphs() {
        console.log("Reached show custom ghraphs");

        var startDate = $('#startDate').val();
        var endDate = $('#endDate').val();

        if (startDate == "" || endDate == "") {
            //show bootstrap alert message here
            $('#alertMessage').css("display", "block");
            console.log(startDate);
            console.log(endDate);
            return;
        } else if (startDate > endDate) {
            $('#alertMessage').css("display", "block");
            console.log(startDate);
            console.log(endDate);
            return;
        } else {
            $('#alertMessage').css("display", "none");
        }

        console.log("Start date: " + startDate);
        console.log("End date: " + endDate);


        var customLightChart = echarts.init(document.getElementById('customLightGraph'));
        var customOccupancyChart = echarts.init(document.getElementById('customOccupancyGraph'));
        var customTemperatureChart = echarts.init(document.getElementById('customTemperatureGraph'));
        var customHeartChart = echarts.init(document.getElementById('customHeartGraph'));

        $('#customLightGraph').css("display", "block");
        $('#customOccupancyGraph').css("display", "block");
        $('#customTemperatureGraph').css("display", "block");
        $('#customHeartGraph').css("display", "block");

        //Light
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Custom",
                type: "Light",
                startDate: startDate,
                endDate: endDate
            },
            success: function (response) {
                console.log("Response for light data: " + response);
                if (response != "null") {
                    var title = "Average light levels per hour";
                    showGraphOfAverages(response, customLightChart, title,"Lux");
                } else {
                    console.log("No data found");
                    $('#customLightGraph').css("display", "none");
                }
            }
        })

        //Occupancy
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Custom",
                type: "Occupancy",
                startDate: startDate,
                endDate: endDate
            },
            success: function (response) {
                console.log("Response for Occupancy data: " + response);
                if (response != "null") {
                    var title = "Sitting time per day";
                    showBarChartOfTotals(response, customOccupancyChart, title);
                } else {
                    console.log("No data found");
                    $('#customOccupancyGraph').css("display", "none");
                }
            }
        })

        //Temperature
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Custom",
                type: "Temperature",
                startDate: startDate,
                endDate: endDate
            },
            success: function (response) {
                console.log("Response for Temperature data: " + response);
                if (response != "null") {
                    var title = "Average Temperature levels per day";
                    showGraphOfAverages(response, customTemperatureChart, title,"\u00B0C");
                } else {
                    console.log("No data found");
                    $('#customTemperatureGraph').css("display", "none");
                }
            }
        })

        //Heart
        $.ajax({
            url: "/getPastData",
            data: {
                option: "Custom",
                type: "Heart",
                startDate: startDate,
                endDate: endDate
            },
            success: function (response) {
                console.log("Response for Heart data: " + response);
                if (response != "null") {
                    var title = "Average Heart rate per hour";
                    showGraphOfAverages(response, customHeartChart, title,"BPM");
                } else {
                    console.log("No data found");
                    $('#customHeartGraph').css("display", "none");
                }
            }
        })
    }

</script>
</html>