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
                        colors="primary:#33B2E9,secondary:#33B2E9"
                >
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
                    <a class="nav-link btn btn-sm btn-outline-light" aria-current="page" href="/faq">FAQ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-sm btn-outline-light active" aria-current="page" href="/about">About</a>
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

<div class="container card col-lg-6 col-sm-12 "  style="border-radius: 3%">
    <div class="row justify-content-center mt-3 mb-3">
            <h2 class="text-center">About OfficeFlow</h2>
    </div>
    <div class=" row justify-content-center align-items-center px-5">
        <lord-icon class="col-auto"
                src="https://cdn.lordicon.com/kkjdkiwn.json"
                trigger="hover"
                stroke="bold"
                colors="primary:#33B2E9,secondary:#33B2E9"
                   style="width:45px;height:45px"
        >
        </lord-icon>
        <h4 class="col-auto">Our mission</h4>

    </div>
    <div class="row justify-content-center px-5 mb-3">
        We aim to improve the health, productivity, and comfort of home workers by creating a smart and customisable system
    </div>
    <div class="row justify-content-center align-items-center px-5">
        <lord-icon class="col-auto"
                   src="https://cdn.lordicon.com/zywwafpn.json"
                   trigger="hover"
                   stroke="bold"
                   colors="primary:#33B2E9,secondary:#33B2E9"
                   style="width:45px;height:45px">
        </lord-icon>
        <h4 class="col-auto ">What it does</h4>
    </div>
    <div class=" row justify-content-center px-5 mb-3">
       <ul>
           <li>
               Depending on which devices you buy, you can monitor different aspects of your home office and yourself, such as temperature, light, and heart rate
           </li>
           <li>
               You can set and customise thresholds which can trigger notifications to be sent to you, and automatically turn on devices
           </li>
           <li>
               You can choose to enable/disable your notifications and/or automation of devices such as a lamp or fan
           </li>
       </ul>
    </div>
    <div class=" row justify-content-center align-items-center px-5">
        <lord-icon class="col-auto"
                   src="https://cdn.lordicon.com/zhiiqoue.json"
                   trigger="hover"
                   stroke="bold"
                   colors="primary:#33B2E9,secondary:#33B2E9"
                   style="width:45px;height:45px" >
        </lord-icon>
        <h4 class="col-auto">How to use it when working</h4>
    </div>
    <div class=" row justify-content-center px-5 mb-3">
        <div>
            When you start your work day, log into OfficeFlow and pin it to your browser so it can be open in the background. Whilst you are working, the devices will collect data that you can view in <a href="/dashboard">Dashboard</a>, and depending on the data and options enabled, you will receive desktop notifications, and automated devices will turn on
        </div>
    </div>
    <div class=" row justify-content-center align-items-center px-5">
        <lord-icon class="col-auto"
                   src="https://cdn.lordicon.com/lsdujvto.json"
                   trigger="hover"
                   stroke="bold"
                   colors="primary:#33B2E9,secondary:#33B2E9"
                   style="width:45px;height:45px">
        </lord-icon>
        <h4 class="col-auto">Contact</h4>
    </div>
    <div class=" row justify-content-center px-5 mb-3">
        <div>
            If you have a question not covered in the <a href="/faq">FAQ</a> page and wish to contact us, please email <a href="mailto:maryamgadiali@outlook.com">MaryamGadiali@outlook.com</a>
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

</script>
</html>