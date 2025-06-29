<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css"  />
    <script src="https://cdn.lordicon.com/lordicon.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <title>Login</title>
    <style>
        .form-check-input {
            background-color: #FDFEFF !important;
        }
    </style>

</head>
<body>

<!--Navbar-->
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

<div class="container" style="border-radius: 3%">
    <div class="row justify-content-center">
    <div class="card p-3 col-lg-6">
    <h2 class="text-center mb-3" >Login</h2>

<form action="/login" method="post" class="p-4" >
    <div class="form-group mb-4">
        <label class="form-label" for="username">Email:</label>
        <input type="email" id="username" name="username" class="form-control"  placeholder="Enter email" required>
    </div>
    <div class="form-group mb-4">
        <label class="form-label" for="password">Password:</label>
        <input type="password" id="password" name="password" class="form-control" placeholder="Enter password" required>
    </div>
    <div class="form-group mb-4 form-check" onmouseover="this.style.cursor='pointer'">
        <input type="checkbox" class="form-check-input" id="remember-me" name="remember-me" onmouseover="this.style.cursor='pointer'">
        <label class="form-check-label" for="remember-me" onmouseover="this.style.cursor='pointer'">Remember me</label>
    </div>
    <div class="row">
    <div>
        <button type="submit" class="btn themeButton">
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
    </div>

    <c:if test="${not empty param.error}">
        <div class="alert alert-danger mb-2 mt-2" role="alert">
            Incorrect username or password, please try again
        </div>
    </c:if>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success mb-2 mt-2" role="alert">
                Registration successful! Please log in.
            </div>
        </c:if>
    </div>
    <div class="row mt-4">
    <p class="text-center text-muted">If you don't have a username or password, please
        <button onclick="window.location.href='/register';return false;" class="btn btn-sm themeButton">
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
    </p>
    </div>

</form></div>
</div>
</div>

</body>
</html>
