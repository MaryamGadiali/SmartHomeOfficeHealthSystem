<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css"  />
    <script src="https://cdn.lordicon.com/lordicon.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <title>Add Device</title>
    <script src="https://unpkg.com/intro.js/intro.js"></script> <!-- Intro.js -->
    <link rel="stylesheet" href="https://unpkg.com/intro.js/introjs.css"> <!-- Intro.js CSS -->
</head>
<body>
<%--Spinner code--%>
<div id="loadingScreen" class="container-fluid" style="display: none; ">
    <div class="d-flex flex-column align-items-center">
        <div class="spinner-grow text-info" style="width: 5rem; height: 5rem;" role="status">
        </div>
        <p>Working on the magic</p>
        <small>Do not refresh the page or navigate away</small>
    </div>
</div>

<%--Navbar--%>
<nav class="navbar navbar-expand-lg rounded-bottom" style=" min-height: 3rem; margin-bottom: 2rem">
    <div class="container-fluid d-flex" >
        <div class="row" onclick="window.location.href='/dashboard'" onmouseover="this.style.cursor='pointer'">
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
        <div class="collapse navbar-collapse justify-content-end" id="expandNavBar">
            <div class="justify-content-end" style="text-align: center">
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
                <button data-bs-toggle="modal" data-bs-target="#logoutModal" style="" class="btn btn-sm themeButton">
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
            <h2 class="text-center">Set up Occupancy Sensor</h2>
            <p class="text-muted"> Please ensure your occupancy sensor is switched off</p>
                <div class="card p-4 mb-2">
                    <div class="card-body">
                        <form id = "seatingSensorForm" method="post">
                            <div class="mb-3">
                                <label class="form-label" for="seatingSensorCode">Occupancy sensor code:</label>
                                <input class="form-control" type="text" id="seatingSensorCode" name="seatingSensorCode" placeholder="Enter the pair code" required>
                            </div>

                            <div>
                                <button type="submit" id="AddSeatingSensorButton" class="btn themeButton">
                                    <div class="row g-1 align-items-center">
                                        <div class="col">
                                            Add Device
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

                            <%--This is only for error messages--%>
                            <div id="seatingSensorDiv" class="alert alert-warning mt-2" role="alert" style="display: none;">
                                <p id="seatingSensorResultMessage"></p>
                            </div>

                        </form>
                    </div>
                </div>

        <script>
            introJs().setOptions({
                tooltipClass: 'introStyle',
                showProgress: true,
                positionPrecedence: ['bottom', 'top'],
                steps: [
                    {
                        intro: "Your Hub has been successfully set up! As the hub needs to be able to connect to WiFi as a requirement, please place it somewhere where there is good WiFi signal. Click Next when you are ready to proceed"
                    },
                    {
                        intro: "Now please identify which device is your Occupancy device, and have your pair code ready before proceeding. Please do NOT switch on your Occupancy device yet to ensure smooth setting up. Click the \"Next\" button when you are ready to proceed."
                    },
                    {
                        element: document.querySelector('#seatingSensorForm'),
                        intro: "Please enter the pair code for the Occupancy device in here and then click the \"Add Device\" button to proceed"
                    }
                ]
            }).start();
        </script>

        </div>
    </div>
</div>

<script>
    $(document).ready(function(){
        $('#AddSeatingSensorButton').click(function(){
            console.log("Add Seating Sensor Button Clicked");
            event.preventDefault(); //Prevents form submission
            introJs().exit();
            const seatingSensorCode = $('#seatingSensorCode').val();
            console.log("Seating sensor code is "+seatingSensorCode);
            $.ajax({
                url: "/verifySeatingSensorCode",
                type: "POST",
                data: {
                    seatingSensorCode: seatingSensorCode
                },
                success: function (response){
                    if (response.Status=="Success"){
                        console.log(response.Status);
                        console.log(response.Message);
                        introJs().setOptions({
                            tooltipClass: 'introStyle',
                            showProgress: true,
                            steps: [
                                {
                                    intro: "Please turn on your Occupancy device now and wait for the syncing to complete."
                                },
                            ]
                        }).start();
                        waitForHubToSyncWithSeatingSensor();
                    }
                    else{
                        console.log(response.Status);
                        console.log(response.Message);
                        $('#seatingSensorResultMessage').text(response.Message);
                        $('#seatingSensorDiv').show();
                    }
                },
                error: function (response){
                    console.log(response.Status);
                    console.log(response.Message);
                    $('#seatingSensorResultMessage').text(response.Message);
                    $('#seatingSensorDiv').show();
                }
            })  //End of ajax function
    })  //End of AddSeatingSensorButton click function

    function waitForHubToSyncWithSeatingSensor(){
        callLoadingScreen();
        console.log("Starting waitForHubToSyncWithSeatingSensor");
        const checkInterval = 5000; //5 seconds

        let polling = setInterval(function(){
            $.ajax({
                url: "/checkIfHubSyncedWithSeatingSensor",
                type: "GET",
                data: {
                    seatingSensorCode: $('#seatingSensorCode').val()
                },
                success: function(response){
                    if (response.Status == "Success"){
                        clearInterval(polling);
                        console.log("Hub has synced with seating sensor");
                        introJs().exit();
                        introJs().setOptions({
                            tooltipClass: 'introStyle',
                            showProgress: true,
                            steps: [
                                {
                                    intro: "Your occupancy device has been set up! This is used to detect when you are present in your chair or if you are away, as readings are only gathered when you are present. Please place this in close distance to yourself, such as on the desk in front of you, or on the head of your chair. By default, the sensor detects if you are present if you are within 60cm of it. This threshold can be changed later in the \"Thresholds Settings\" page. Click Next to proceed."
                                },
                                {
                                    intro: "To get the most out of your system, please leave the website open in the background and pinned (to prevent falling asleep) whilst you are logged in and working, so that you can receive instant alert notifications based on your reading thresholds. Click Done when you are happy to proceed."
                                },
                            ],

                        }).oncomplete(function(){
                            window.location.href = "/setUpDevice";
                        }).onbeforeexit(function(){
                            window.location.href = "/setUpDevice";
                        }).start();

                    }
                    else if (response.Status == "Waiting"){
                        console.log("Still waiting");
                    }
                    else{
                    }
                },
                error: function(){
                    console.log("Reached the error part");
                }
            })
        }, checkInterval);
    }
        function callLoadingScreen(){
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

        function closeLoadingScreen(){
            $('#loadingScreen').hide();
        }

        $('[data-bs-toggle="tooltip"]').tooltip();
    })  //End of document ready function
</script>
</body>
</html>
