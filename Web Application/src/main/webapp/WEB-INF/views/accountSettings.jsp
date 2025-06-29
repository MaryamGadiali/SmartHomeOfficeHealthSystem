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
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
          rel="stylesheet">
    <title>Account Settings</title></head>
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

<div class="container" style="border-radius: 3%">
<div class="row justify-content-center" >
    <div class="card p-3 col-lg-6 " >
        <h2 class="text-center mb-3">Account Settings</h2>
        <div class="row inputField mb-3 card p-3" >
            <div class="col-auto">
                <h5 class="card-title" for="name">Name:</h5>
                <input type="text" id="name" name="name" value="${user.name}" class="form-control" disabled/>
            </div>
            <div class="mt-2">
                <button class="btn btn-sm themeButton editButton" onclick="edit(this)">Edit</button>
                <button class="btn btn-sm themeButton saveButton" onclick="saveChange(this)" style="display: none; background-color: #33E9C5; color: #172A32">Save</button>
            </div>
            <div class="alert mt-2 alertMessage" role="alert" style="display: none"></div>
        </div>
        <div class="row inputField mb-3 card p-3" >
            <div class="col-auto">
                <h5 class="card-title" for="email">Email:</h5>
                <input type="email" id="email" name="email" value="${user.email}" class="form-control " onkeyup="emailCheck(this)" disabled/>
            </div>
            <div class="mt-2">
                <button class="btn btn-sm themeButton editButton" onclick="edit(this)">Edit</button>
                <button class="btn btn-sm themeButton saveButton" onclick="saveChange(this)" style="display: none; background-color: #33E9C5; color: #172A32">Save</button>
            </div>
            <div class="alert mt-2 alertMessage" role="alert" style="display: none"></div>
        </div>
        <div class="row inputField mb-3 card p-3" >
            <div class="col-auto">
                <h5 class="card-title" for="dateOfBirth">Date of Birth:</h5>
                <input type="date" id="dateOfBirth" name="dateOfBirth" value="${user.dateOfBirth}" class="form-control " disabled/>
            </div>
            <div class="mt-2">
                <button class="btn btn-sm themeButton editButton" onclick="edit(this)">Edit</button>
                <button class="btn btn-sm themeButton saveButton" onclick="saveChange(this)" style="display: none; background-color: #33E9C5; color: #172A32; ">Save</button>
            </div>
            <div class="alert mt-2 alertMessage" role="alert" style="display: none"></div>
        </div>
        <div class="row inputField mb-3 card p-3" >
            <div class="col-auto passwordFields" style="display: none">
                <h5 class="card-title" for="currentPassword">Current Password:</h5>
                <input type="password" id="currentPassword" name="currentPassword" placeholder="Please enter your current password" onkeyup="checkCurrentPasswordErrorClear(this)" class="form-control mb-3"/>
                <div class="alert mt-2" role="alert" id="currentPasswordAlertMessage" style="display: none"></div>
                <h5 class="card-title" for="password">New Password:</h5>
                <input type="password" id="password" name="password" placeholder="Enter a new password" class="form-control mb-3"  onclick="checkCurrentPassword(this)"/>
                <h5 class="card-title" for="confirmPassword">Confirm your Password:</h5>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" class="form-control" onclick="checkCurrentPassword(this)"/>
            </div>
            <div class="mt-2">
                <button class="btn btn-sm themeButton editButton" onclick="changePassword(this)">Change Password</button>
                <button class="btn btn-sm themeButton saveButton" onclick="savePassword(this)" style="display: none; background-color: #33E9C5; color: #172A32">Save</button>
                <button class="btn btn-sm btn-secondary cancelButton" style="display: none; border-radius: 0.5rem; ">Cancel</button>
            </div>
            <div class="alert mt-2" role="alert" id="alertMessage" style="display: none"></div>
            <div class="mt-2">
                <button id="removeAccountButton" class="col-auto btn btn-sm btn-danger mt-4 mb-4" type="button"
                        onclick="showRemovalModalForAccount()">Delete Account
                </button>
            </div>
        </div>
    </div>
</div>
</div>


<!-- Deleting account modal -->
<div class="modal fade" id="removalConfirmModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="exampleModalLabel">Are you sure you want to permanently delete your account?</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                This is an irreversible action and your account will not be able to be recovered.
            </div>
            <div class="modal-footer">
                <button id="closeButton" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button id="removeConfirmButton" type="button" class="btn btn-danger">Delete Account</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/notification.js"></script>
</body>

<script>
    $(document).ready(function () {
        //Every 30 seconds, it checks for notifications
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

    function edit(currentObject){
        console.log("edit function");
        $(currentObject).closest('.inputField').find('input').prop('disabled', false);
        $(currentObject).closest('.inputField').find('.editButton').hide();
        $(currentObject).closest('.inputField').find('.saveButton').show();
    }

    function saveChange(currentObject){
        console.log("saveChange function");

        const fieldChange = $(currentObject).closest('.inputField').find('input').attr('id');
        const newValue = $(currentObject).closest('.inputField').find('input').val();
        console.log("Field change is: "+fieldChange);
        console.log("New value is "+newValue);
        var hasNumber = /\d/;

        if(fieldChange=="name" || fieldChange=="email"){
            console.log("Name or Email field");
            if(newValue === ""){
                $(currentObject).closest('.inputField').find('.alertMessage').removeClass('alert-success');
                $(currentObject).closest('.inputField').find('.alertMessage').addClass('alert-danger');
                $(currentObject).closest('.inputField').find('.alertMessage').text("Field cannot be empty").show();
                return;
            }
            else if(fieldChange=="email" && !newValue.includes("@")){
                $(currentObject).closest('.inputField').find('.alertMessage').removeClass('alert-success');
                $(currentObject).closest('.inputField').find('.alertMessage').addClass('alert-danger');
                $(currentObject).closest('.inputField').find('.alertMessage').text("Invalid email address").show();
                return;
            }
            else if(parseInt(newValue) || parseFloat(newValue)){
                $(currentObject).closest('.inputField').find('.alertMessage').removeClass('alert-success');
                $(currentObject).closest('.inputField').find('.alertMessage').addClass('alert-danger');
                $(currentObject).closest('.inputField').find('.alertMessage').text("Value cannot be a number").show();
            }
            else if(fieldChange=="name" && hasNumber.test(newValue)){
                $(currentObject).closest('.inputField').find('.alertMessage').removeClass('alert-success');
                $(currentObject).closest('.inputField').find('.alertMessage').addClass('alert-danger');
                $(currentObject).closest('.inputField').find('.alertMessage').text("Name cannot contain numbers").show();
                return;
            }
        }

        $(currentObject).closest('.inputField').find('.alertMessage').removeClass('alert-danger');
        $(currentObject).closest('.inputField').find('.alertMessage').addClass('alert-success');
        $(currentObject).closest('.inputField').find('.alertMessage').text("Successfully updated").show();

        $(currentObject).closest('.inputField').find('input').prop('disabled', true);
        $(currentObject).closest('.inputField').find('.editButton').show();
        $(currentObject).closest('.inputField').find('.saveButton').hide();

        $.ajax({
            url: "/updateAccountDetail",
            type: "POST",
            data:{
                accountDetail : fieldChange,
                newValue: newValue
            }
        })

    }

    function changePassword(currentObject){
        console.log("changePassword function");
        $(currentObject).closest('.inputField').find('#currentPassword').val("");
        $(currentObject).closest('.inputField').find('#password').val("");
        $(currentObject).closest('.inputField').find('#confirmPassword').val("");
        $(currentObject).closest('.inputField').find('.passwordFields').show();
        $(currentObject).closest('.inputField').find('.editButton').hide();
        $(currentObject).closest('.inputField').find('.saveButton').show();
        $(currentObject).closest('.inputField').find('.cancelButton').show();
        $('#alertMessage').hide();

        $('.cancelButton').click(function(){
            console.log("Cancel button clicked");
            $(currentObject).closest('.inputField').find('.passwordFields').hide();
            $(currentObject).closest('.inputField').find('.editButton').show();
            $(currentObject).closest('.inputField').find('.saveButton').hide();
            $(currentObject).closest('.inputField').find('.cancelButton').hide();
            $('#alertMessage').hide();
        });
    }

    function savePassword(currentObject){
        console.log("savePassword function");

        const firstField = $(currentObject).closest('.inputField').find('#password').val();
        const secondField = $(currentObject).closest('.inputField').find('#confirmPassword').val();

        if (firstField===secondField && firstField !== "" && secondField !== ""){
            console.log("Passwords match");
            $(currentObject).closest('.inputField').find('.passwordFields').hide();
            $(currentObject).closest('.inputField').find('.editButton').show();
            $(currentObject).closest('.inputField').find('.saveButton').hide();
            $(currentObject).closest('.inputField').find('.cancelButton').hide();

            $.ajax({
                url: "/updateAccountDetail",
                type: "POST",
                data:{
                    accountDetail : "password",
                    newValue: firstField
                },
                success: function(response){
                    console.log("Response:"+response);
                }
            })

            $('#alertMessage').removeClass('alert-danger');
            $('#alertMessage').addClass('alert-success');
            $('#alertMessage').text("Password has been successfully updated").show();
        }
        else if (firstField !== secondField){
            console.log("Passwords do not match");
            $('#alertMessage').removeClass('alert-success');
            $('#alertMessage').addClass('alert-danger');
            $('#alertMessage').text("Passwords do not match").show();
        }
        else{
            console.log("Fields are empty");
            $('#alertMessage').removeClass('alert-success');
            $('#alertMessage').addClass('alert-danger');
            $('#alertMessage').text("Please enter your new password in both fields").show();
        }
    }


    function showRemovalModalForAccount(){
        $('#removalConfirmModal').modal('show');
        $('#removeConfirmButton').on('click', function () {
            console.log("Remove button clicked");
            deleteAccount();
        });
        $('#closeButton').on('click', function () {
            console.log("Close button clicked");
            return;
        });
    }

    function emailCheck(currentObject){
        $.ajax({
            url: "/checkEmail",
            type:"POST",
            data:{
                userEmail: $('#email').val(),
                loggedIn: "True"
            },
            success: function (response){
                if(response == "true"){
                    $(currentObject).closest('.inputField').find('.alertMessage').removeClass('alert-success');
                    $(currentObject).closest('.inputField').find('.alertMessage').addClass('alert-danger');
                    $(currentObject).closest('.inputField').find('.alertMessage').text("Email is already in use").show();
                    $(currentObject).closest('.inputField').find('.saveButton').prop('disabled', true);
                }
                else if (response=="false"){
                    $(currentObject).closest('.inputField').find('.alertMessage').hide();
                    $(currentObject).closest('.inputField').find('.saveButton').prop('disabled', false);
                }
            }
        })
    }

    function deleteAccount(){
        console.log("Deleting account");
        $.ajax({
            url:"/deleteAccount",
            type:"POST",
            success:function(response){
                if(response=="Success"){
                    window.location.href="/logout"; //Removes cookies influence
                }
            }
        })
    }

    function checkCurrentPassword(currentObject){
        console.log("checkCurrentPassword function");
        const enteredPassword = $(currentObject).closest('.inputField').find('#currentPassword').val();

        $.ajax({
            url:"/checkCurrentPassword",
            type:"POST",
            data:{
                currentPassword: enteredPassword
            },
            success: function(response){
                console.log(response);
                if(response=="False"){
                    $('#currentPasswordAlertMessage').removeClass('alert-success');
                    $('#currentPasswordAlertMessage').addClass('alert-danger');
                    $('#currentPasswordAlertMessage').text("Current password is incorrect").show();
                    $(currentObject).closest('.inputField').find('.saveButton').prop('disabled', true);
                }
                else if (response=="True"){
                    $('#currentPasswordAlertMessage').hide();
                    $(currentObject).closest('.inputField').find('.saveButton').prop('disabled', false);
                }

            }
        })
    }

    function checkCurrentPasswordErrorClear(currentObject){
        console.log("checkCurrentPasswordErrorClear function");
        const enteredPassword = $(currentObject).closest('.inputField').find('#currentPassword').val();

        $.ajax({
            url:"/checkCurrentPassword",
            type:"POST",
            data:{
                currentPassword: enteredPassword
            },
            success: function(response){
                console.log(response);
                if(response=="True"){
                    $('#currentPasswordAlertMessage').hide();
                    $(currentObject).closest('.inputField').find('.saveButton').prop('disabled', false);
                }
            }
        })
    }
</script>
</html>