<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css"/>
    <script src="https://cdn.lordicon.com/lordicon.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <title>Register</title>
</head>
<body>

<nav class="navbar navbar-expand-lg rounded-bottom " style=" min-height: 3rem; margin-bottom: 2rem">
    <div class="container-fluid">
        <div class="row g-0">
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
                <a class="navbar-brand ms-2">OfficeFlow</a>
            </div>
        </div>
    </div>
</nav>

<div class="container " style="border-radius: 3%">
    <div class="row  justify-content-center">
    <div class="card p-3 col-lg-6">
        <h2 class="text-center mb-1">Register</h2>

<form:form action="/register" method="post" class="p-4" modelAttribute="user">
        <div class="form-group mb-4">
    <form:label class="form-label" path="name">Please enter your name:</form:label>
    <form:input path="name" id="name" class="form-control" placeholder="Enter name" type="text" required="true"/>
    <form:errors path="name"/>
        </div>

        <div class="form-group mb-4">
    <form:label class="form-label" path="email">Please enter your email:</form:label>
    <form:input path="email" id="email" type="email" class="form-control" required="true" placeholder="Enter email" onkeyup="emailCheck()" name="username"/>
    <form:errors path="email"/>
            <div class="alert alert-warning mt-2" role="alert" id="emailAlertMessage" style="display: none">
                Email is already in use!
            </div>
        </div>

        <div class="form-group mb-4">
    <form:label class="form-label" path="dateOfBirth">Please enter your date of birth:</form:label>
    <form:input path="dateOfBirth" id="dateOfBirth" type="date"  class="form-control" required="true"/>
    <form:errors path="dateOfBirth"/>
        </div>

        <div class="form-group mb-4">
    <form:label class="form-label" path="password">Please enter your password:</form:label>
    <form:input path="password" id="password" type="password" name="password"  class="form-control" placeholder="Enter a strong password" required="true"/>
    <form:errors path="password"/>
        </div>

    <div>
        <button type="submit" id="submit" class="btn themeButton">
            <div class="row g-1 align-items-center">
                <div class="col">
                    Register
                </div>
                <div class="col">
                    <lord-icon
                            src="https://cdn.lordicon.com/oymjxfrg.json"
                            trigger="hover"
                            stroke="bold"
                            colors="primary:#FFFFFF,secondary:#FFFFFF">
                    </lord-icon>
                </div>
            </div>
        </button>
    </div>



    <div class="row mt-4">
        <p class="text-center text-muted">If you have an account, please
            <button onclick="window.location.href='/login';return false;" class="btn btn-sm themeButton">
                <div class="row g-1 align-items-center">
                    <div class="col">
                        Login
                    </div>
                    <div class="col">
                        <lord-icon
                                src="https://cdn.lordicon.com/ljupbvfa.json"
                                trigger="hover"
                                stroke="bold"
                                colors="primary:#FFFFFF,secondary:#FFFFFF">
                        </lord-icon>
                    </div>
                </div>
            </button>
        </p>
    </div>
</form:form>

    </div>

    </div>
</div>
</body>

<script>
    function checkRegistrationForm(){
        console.log("checkRegistrationForm");
        //If any of the alert messages are showing, submit button disables
        if ($('.alert').css('display') == "block"){
            $('#submit').prop('disabled', true);
        }
        else{
            $('#submit').prop('disabled', false);
        }
    }

    function emailCheck(){
        console.log("Email is");
        console.log($('#email').val());
        $.ajax({
            url: "/checkEmail",
            type:"POST",
            data:{
                userEmail: $('#email').val()
            },
            success: function (response){
                if(response == "true"){
                    $('#emailAlertMessage').show();
                    checkRegistrationForm();

                }
                else if (response=="false"){
                    $('#emailAlertMessage').hide();
                    checkRegistrationForm();
                }
            }
        })
    }
</script>
</html>
