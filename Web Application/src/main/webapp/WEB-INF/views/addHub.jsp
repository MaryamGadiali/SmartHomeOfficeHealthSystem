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
    <title>Add Hub</title>

    <script src="https://unpkg.com/intro.js/intro.js"></script> <!-- Intro.js -->
    <link rel="stylesheet" href="https://unpkg.com/intro.js/introjs.css"> <!-- Intro.js CSS -->

</head>
<body>

<%--Spinner code--%>
<div id="loadingScreen" class="container-fluid" style="display: none;">
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
        <h2 class="text-center mb-3">Set up your Hub</h2>
        <div class="card p-4 mb-2">
            <div class="card-body">
                <p> Please ensure your hub is switched off</p>
                <form id = "HubForm" method="post">
                <div class="mb-3">
                <label class="form-label" for="hubCode">Hub Code:</label>
                <input class="form-control" type="text" id="hubCode" name="hubCode" placeholder="Enter your hub pair code" required>
                </div>
                <div>
                    <button type="submit" id="AddHubButton" class="btn themeButton">
                        <div class="row g-1 align-items-center">
                            <div class="col">
                                Add Hub
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

                <div id="hubResultDiv" class="alert alert-warning mt-2" role="alert" style="display: none;">
                    <p id="hubResultMessage"></p>
                </div>
                </form>
            </div>
        </div>
        </div>

        <script>
            introJs().setOptions({
                tooltipClass: 'introStyle',
                showProgress: true,
                positionPrecedence: ['bottom', 'top'],
                steps: [
                    {
                        intro: "First off, we are going to start off by setting up your hub. Please identify which device is your hub, and have your pair code ready before proceeding. Please do NOT switch on your hub yet to ensure smooth setting up. Click the \"Next\" button when you are ready to proceed."
                    },
                    {
                        element: document.querySelector('#HubForm'),
                        intro: "Please enter the pair code for the hub in here and then click the \"Add Hub\" button to proceed"
                    }
                ]
            }).start();
        </script>
</div>
</div>

<script>
    $(document).ready(function(){
        $('#AddHubButton').click(function(){
            console.log("Add Hub Button Clicked");
            event.preventDefault(); //Prevents form submission

            const hubCode = $('#hubCode').val();
            console.log("Hub code is "+hubCode);

            $.ajax({ //Checks if the hub code is valid
                url: "/verifyHubCode",
                type: "POST",
                data: {
                    hubCode: hubCode
                },
                success: function (response) {
                    if (response.Status == "Success") {
                        console.log(response.Status);
                        console.log(response);
                        $('#hubResultDiv').hide();

                        //Here the user needs to turn on hub and set wifi config with steps
                        introJs().exit()
                        introJs().setOptions({
                            tooltipClass: 'introStyle',
                            showProgress: true,
                            steps: [
                                {
                                    intro: "Please turn on your hub now and click \"Next\" to proceed"
                                },
                                {
                                    intro: "Your hub is now trying to connect to the WiFi which is why the hub's indicator is red. Please connect to the new WiFi access point called \"HubSetup\". It is recommended to use another device for this as this will temporarily disconnect you from the internet. The password for this network is \"HubPassword\" . Please click Next when you have connected to \"HubSetup\"" +
                                        "<img src=\"${pageContext.request.contextPath}/img/hubSetUp.png\" style=\"max-width: 100%; height: auto;\"/>"
                                },
                                {
                                    intro:"Once you have connected to this WiFi network, please open a browser page and go to \"192.168.4.1/wifi\" (If you are redirected automatically, click on the Configure WiFi button). You should see a page like this: <img style=\"max-width: 100%; height: auto;\" src=\"${pageContext.request.contextPath}/img/hubWiFiManager.png\"/>"
                                },
                                {
                                    intro: "Please select your home WiFi, enter your WiFi password, and then click the Save button so the hub can automatically connect to it in the future."
                                }
                            ]
                        }).start();

                        waitForHubResponse(); // Starts polling
                    }
                    else {
                        console.log(response.Status);
                        $("#hubResultMessage").text(response.Message);
                        $('#hubResultDiv').show();
                    }
                },
                error:function (response) {
                    $("#hubResultMessage").text(response.Message);
                    $('#hubResultDiv').show();
                }
            });
        });
        function waitForHubResponse(){
            callLoadingScreen();
            const checkInterval = 5000; //5 seconds

            let myVar = setInterval(function(){
                $.ajax({
                    url: "/checkHubPairingResponse",
                    type: "GET",
                    data : {
                        hubCode: $('#hubCode').val(),
                    },
                    success: function(response){
                        if (response.Status == "Paired"){
                            $.ajax({
                                url: "/SyncUserAndHubDetails",
                                type: "POST",
                                data: {
                                    hubCode: $('#hubCode').val(),
                                },
                                success: function(response){
                                    if (response.Status == "Success"){
                                        console.log("Hub has been paired");
                                        console.log(response.Message);

                                        window.location.href = "/setUpOccupancySensor";
                                    }
                                    else{
                                        console.log("Hub has not been paired, something's gone wrong");
                                        $("#hubResultMessage").text(response.Message);
                                        $('#hubResultDiv').show();
                                        closeLoadingScreen();
                                    }
                                },
                                error: function(){
                                    console.log("Hub has not been paired - Method was not reached");
                                    $("#hubResultMessage").text("Hub has not been paired - Method was not reached");
                                    $('#hubResultDiv').show();
                                    closeLoadingScreen();
                                }
                            })
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
            } , checkInterval);
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
            $('#loadingScreen').css('background-color', 'rgba(255, 255, 255, 0.5)'); //this is the opacity
        }

        function closeLoadingScreen(){
            $('#loadingScreen').hide();
        }

        $('[data-bs-toggle="tooltip"]').tooltip();
    })
</script>

</body>
</html>