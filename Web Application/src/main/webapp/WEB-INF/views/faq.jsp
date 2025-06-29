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
    <title>FAQ</title>
    <script src="https://unpkg.com/intro.js/intro.js"></script> <!-- Intro.js -->
    <link rel="stylesheet" href="https://unpkg.com/intro.js/introjs.css"> <!-- Intro.js CSS -->
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
                    <a class="nav-link btn btn-sm btn-outline-light" href="/thresholdSettings">Threshold Settings</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-sm btn-outline-light" href="/manageDevices">Manage devices</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-sm btn-outline-light active" aria-current="page" href="/faq">FAQ</a>
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


<div class="container">
    <div class="row justify-content-center">
        <div class="card p-3 col-lg-6 col-sm-12">
            <h2 class="text-center mb-3">Frequently Asked Questions</h2>

            <form class="d-flex mb-3" role="search">
                <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" onkeyup="searchFunction(this.value)" oninput="searchFunction(this.value)" >
            </form>

            <div class="accordion" id="accordionParent">
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                            What do the colours mean on the Hub?
                        </button>
                    </h2>
                    <div id="collapseOne" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body container" >
                            <div class="row">
                            The Hub shows different colours depending on what action it is performing. They are as follows:
                            </div>
                            <div class="row">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th scope="col">Colour</th>
                                    <th scope="col">Meaning</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th scope="row">Red</th>
                                    <td>The Hub has been unable to locate your home WiFi network. Please see <a href="#" onclick="
                                    $('#collapseOne').collapse('hide');
                                        $('#collapseFour').closest('.accordion-item').show();
                                        $('#collapseFour').collapse('show');
                                        document.getElementById('collapseFour').scrollIntoView({behavior: 'smooth'});">here</a> on how to proceed</td>
                                </tr>
                                <tr>
                                    <th scope="row">Purple</th>
                                    <td>The Hub is unable to connect to our server. The website may be down, or the hub is somewhere where there is weak WiFi signal. </td>
                                </tr>
                                <tr>
                                    <th scope="row">Green</th>
                                    <td>The Hub is actively communicating to our server over WiFi</td>
                                </tr>
                                <tr>
                                    <th scope="row">Blue</th>
                                    <td >The Hub is functioning normally</td>
                                </tr>
                                <tr>
                                    <th scope="row">Orange</th>
                                    <td >The Hub is trying to broadcast to the other devices in your network so they can connect and start taking readings</td>
                                </tr>
                                <tr>
                                    <th scope="row">Pink</th>
                                    <td >The Hub has detected that you are trying to add a new device to the network</td>
                                </tr>
                                </tbody>
                            </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                            What do the colours mean on the other devices?
                        </button>
                    </h2>
                    <div id="collapseTwo" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body container" >
                            <div class="row">
                                The Devices shows different colours depending on what action it is performing. They are as follows:
                            </div>
                            <div class="row">
                                <table class="table">
                                    <thead>
                                    <tr>
                                        <th scope="col">Colour</th>
                                        <th scope="col">Meaning</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <th scope="row">Orange</th>
                                        <td>The device is still waiting to connect to the Hub</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">Red</th>
                                        <td>The device has paused and stopped taking readings. Either because it has detected that you are no longer present in the room, or it is handling the setup of a new device</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">Green</th>
                                        <td>The device is currently taking readings</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">Purple</th>
                                        <td>The device is waiting for permission to start from the Hub</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">Blue</th>
                                        <td>The device is functioning normally</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                            How can I add a new device to my network?
                        </button>
                    </h2>
                    <div id="collapseThree" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body">
                            Please go to <a href="/manageDevices">Manage Devices</a> and click on the "Add New Device" button where you can start the setup.
                        </div>
                    </div>
                </div>
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
                            How can I connect my Hub to my home Wi-Fi network?
                        </button>
                    </h2>
                    <div id="collapseFour" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body">
                            When your Hub is red, that indicates that it is unable to locate your home WiFi network. If you are expecting your network to be available, then please place the Hub somewhere where there is strong WiFi signal, and restart the Hub by powering off then on again. If you are not expecting your network to be available, and want your Hub to connect to a new network then please follow the steps below: <br><ol><li>On your phone or computer, please connect to the new WiFi access point called "HubSetup". The password for this network is "HubPassword". Note that this will temporarily disconnect your chosen device from the internet.</li><li>After you have successfully connected, please open a browser page and go to "192.168.4.1/wifi".</li><li>Please select your home WiFi, enter your WiFi password, and then click the Save button so the hub can automatically connect to it in the future.</li><li>Once this is completed, you should see the Hub's colour change from red which indicates successful connection</li></ol>
                        </div>
                    </div>
                </div>
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseFive" aria-expanded="false" aria-controls="collapseFive">
                            I accidentally closed the page whilst my new device was syncing with the system and the loading screen was showing, and now I cannot use my pair code again, what should I do?
                        </button>
                    </h2>
                    <div id="collapseFive" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body">
                            Please go to <a href="/manageDevices">Manage Devices</a> and remove the device that did not fully set up. You can now add the device again using the same pair code.
                        </div>
                    </div>
                </div>
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseSix" aria-expanded="false" aria-controls="collapseSix">
                            What is the best device to use for using the website?
                        </button>
                    </h2>
                    <div id="collapseSix" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body">
                            We recommend using Google Chrome on a desktop computer for the best website experience but the website can also be used on a tablet or mobile phone.
                        </div>
                    </div>
                </div>
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseSeven" aria-expanded="false" aria-controls="collapseSeven">
                            How can I receive the alerts for my readings whilst I am working?
                        </button>
                    </h2>
                    <div id="collapseSeven" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body">
                            We recommend keeping this website open in the background and pinned (to prevent falling asleep) whilst you are logged in and working , so the alerts will show when they are triggered.
                        </div>
                    </div>
                </div>
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseEight" aria-expanded="false" aria-controls="collapseEight">
                            Why am I not receiving alert notifications when my readings have exceeded their threshold?
                        </button>
                    </h2>
                    <div id="collapseEight" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body">
                            Please ensure you have not blocked or turned off your notifications for this website in your browser's notification settings.
                        </div>
                    </div>
                </div>
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseNine" aria-expanded="false" aria-controls="collapseNine">
                            What does "Sensor" and "Actuator" mean?
                        </button>
                    </h2>
                    <div id="collapseNine" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body">
                            A Sensor is a device that takes readings from you or the room, such as the light sensor, the temperature sensor, and the heart rate sensor. An Actuator is a non sensor device, and it can be controlled to perform an action, such as the Lamp and Fan.
                        </div>
                    </div>
                </div>
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseTen" aria-expanded="false" aria-controls="collapseTen">
                            Does removing any/all the devices from my network delete my readings?
                        </button>
                    </h2>
                    <div id="collapseTen" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body">
                            No, removing the devices from your network does not delete your previous data. You can view your previous data in the "All time" section of your dashboard.
                        </div>
                    </div>
                </div>
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseEleven" aria-expanded="false" aria-controls="collapseEleven">
                            What is the effect of light on my health and performance?
                        </button>
                    </h2>
                    <div id="collapseEleven" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body">
                            For office work, CIBSE (UK professional body) recommends working in over 500 lux. Research has found that working in well-lit areas can improve our productivity, stress levels, and reduce mistakes. In comparison, working in poorly lit areas can disrupt our circadian rhythm (which affects our sleep quality), and has also been associated with other medical issues such as depression.
                        </div>
                    </div>
                </div>
                <div class="accordion-item p-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseTwelve" aria-expanded="false" aria-controls="collapseTwelve">
                            What is the effect of sitting for too long on my health?
                        </button>
                    </h2>
                    <div id="collapseTwelve" class="accordion-collapse collapse" data-bs-parent="#accordionParent">
                        <div class="accordion-body">
                            Sitting for too long has been associated with a number of health issues, such as increased risk of obesity, diabetes, cardiovascular disease, and cancer. It is recommended to take breaks from sitting every 30 minutes to help reduce the risks.
                        </div>
                    </div>
                </div>
            </div>
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

    function searchFunction(searchString){
        // console.log("Searching for: " + searchString);
        var accordionItems = document.querySelectorAll('.accordion-item');

        if(!searchString){
            for (var i=0; i<accordionItems.length; i++){
                accordionItems[i].style.display = "block";
            }
            return;
        }
        console.log(accordionItems.length);
        for (var i=0; i<accordionItems.length; i++){
            var item = accordionItems[i];
            var itemTitle = $(item).find('.accordion-header').find('.accordion-button').text();
            var itemContent = $(item).find('.accordion-body').text();

            if (itemTitle.toLowerCase().includes(searchString.toLowerCase()) || itemContent.toLowerCase().includes(searchString.toLowerCase())){
                item.style.display = "block";
            } else {
                item.style.display = "none";
            }
        }
    }
</script>
</html>