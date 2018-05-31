<%-- Created by IntelliJ IDEA. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<html>
<head>
    <title>Medinx</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" href="assets/css/style.css" type="text/css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
            integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl"
            crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
            integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
            integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q"
            crossorigin="anonymous"></script>
</head>
<body>
<%
    String doctorID = (String)session.getAttribute("doctorID");
    if (StringUtils.isEmpty(doctorID)) {
        response.sendRedirect("index.html");
    }
%>
<div class="container-fluid">
    <div class="row navbar navbar-expand-lg navbar-light bg-light">
        <div class="col-md-1 offset-md-1">
            <a class="navbar-brand" href="index.html">M E D I N X</a>
        </div>
    </div>
</div>
<div class="container">
    <div class="row">
        <div class="col-md-3">
            <br>
            <ul>
                <li><a href="generate-report.jsp" class="active">Generate Report</a></li>
                <li><a href="show_all_patients.jsp">Show All Patients</a></li>
                <li><a href="search.jsp">Search</a></li>
                <li><a href="/Logout">Logout</a></li>
            </ul>
        </div>
        <div class="col-md-9">
            <form action="/Document" method="post">
                <br>
                <h3>Patient's Details</h3>
                <hr>
                <div class="row">
                    <div class="col-md-2">First Name</div>
                    <div class="col-md-4">
                        <input type="text" name="first_name" placeholder="First Name" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Last Name</div>
                    <div class="col-md-4">
                        <input type="text" name="last_name" placeholder="Last Name" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Age</div>
                    <div class="col-md-4">
                        <input type="text" name="age" placeholder="Age"required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Gender</div>
                    <div class="col-md-4">
                        <label><input type="radio" name="gender" value="Male" required> Male</label>
                        <label><input type="radio" name="gender" value="Female" required> Female</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Weight</div>
                    <div class="col-md-4">
                        <input type="text" name="weight" placeholder="Weight" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Height</div>
                    <div class="col-md-4">
                        <input type="text" name="height" placeholder="Height" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Blood Group</div>
                    <div class="col-md-4">
                        <select name="blood_group" required>
                            <option selected disabled>Select</option>
                            <option>A+</option>
                            <option>A-</option>
                            <option>B+</option>
                            <option>B-</option>
                            <option>O+</option>
                            <option>O-</option>
                            <option>AB+</option>
                            <option>AB-</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Allergies</div>
                    <div class="col-md-4">
                        <label><input type="radio" name="allergy" value="Yes" onclick="allergyRadio()" required> Yes</label>
                        <label><input type="radio" name="allergy" value="No" onclick="allergyRadio()" required> No</label>
                        <textarea name="allergy_desc" disabled placeholder="Description"></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Chronic Disease</div>
                    <div class="col-md-4">
                        <label><input type="radio" name="chronic_disease" value="Yes" onclick="chronicRadio()" required> Yes</label>
                        <label><input type="radio" name="chronic_disease" value="No" onclick="chronicRadio()" required> No</label>
                        <textarea name="chronic_disease_desc" disabled placeholder="Description"></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Test</div>
                    <div class="col-md-4">
                        <textarea name="test" placeholder="Test" required></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Symptoms</div>
                    <div class="col-md-4">
                        <textarea name="symptoms" placeholder="Symptoms" required></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Diagnosis</div>
                    <div class="col-md-4">
                        <textarea name="diagnosis" placeholder="Diagnosis" required></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    function allergyRadio(){
        var radioValue = $("input[name='allergy']:checked").val();
        if(radioValue=="Yes"){
            $("textarea[name='allergy_desc']").prop("disabled",false);
            $("textarea[name='allergy_desc']").prop("required",true);
        }
        else{
            $("textarea[name='allergy_desc']").prop("disabled",true);
            $("textarea[name='allergy_desc']").prop("required",false);
            $("textarea[name='allergy_desc']").val('').empty();
        }
    }

    function chronicRadio(){
        var radioValue = $("input[name='chronic_disease']:checked").val();
        if(radioValue=="Yes"){
            $("textarea[name='chronic_disease_desc']").prop("disabled",false);
            $("textarea[name='chronic_disease_desc']").prop("required",true);
        }
        else{
            $("textarea[name='chronic_disease_desc']").prop("disabled",true);
            $("textarea[name='chronic_disease_desc']").prop("required",false);
            $("textarea[name='chronic_disease_desc']").val('').empty();
        }
    }
</script>
</body>
</html>