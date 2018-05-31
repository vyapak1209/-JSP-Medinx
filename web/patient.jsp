<%-- Created by IntelliJ IDEA. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.http.client.HttpClient" %>
<%@ page import="org.apache.http.impl.client.HttpClients" %>
<%@ page import="org.apache.http.client.methods.HttpPost" %>
<%@ page import="org.apache.http.entity.StringEntity" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="org.apache.http.HttpEntity" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>

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
    String doctorID = (String) session.getAttribute("doctorID");
    if (StringUtils.isEmpty(doctorID)) {
        response.sendRedirect("index.html");
    }

    String id = request.getParameter("id");

    HttpClient req = HttpClients.createDefault();
    HttpPost post = new HttpPost("http://localhost:9200/medinx/reports/_search");

    StringEntity params = new StringEntity("{\"query\":{\"bool\":{\"must\":[{\"match\":{\"_id\": \"" + id + "\"}}]}}}");

    post.addHeader("content-type", "application/json");
    post.setEntity(params);
    HttpResponse res = req.execute(post);

    HttpEntity entity = res.getEntity();
    InputStream instream = entity.getContent();
    String result = convertStreamToString(instream);
    System.out.println("Result : " + result);

    JSONObject json = new JSONObject(result);
    JSONObject hits = (JSONObject) json.get("hits");
    System.out.println("Hits : " + hits.get("hits"));
    JSONArray hitsArray = hits.getJSONArray("hits");

    JSONObject obj= new JSONObject();
    int length = hitsArray.length();
    System.out.println("Array Length : " + length);
    for (int i = 0; i < length; i++) {
        obj = hitsArray.getJSONObject(i);
        obj = obj.getJSONObject("_source");
    }


%>
<%!
    private static String convertStreamToString(InputStream is) {

        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        StringBuilder sb = new StringBuilder();

        String line = null;
        try {
            while ((line = reader.readLine()) != null) {
                sb.append(line + "\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return sb.toString();
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
            <form action="/Save" method="post">
                <br>
                <h3>Report</h3>
                <hr>
                <div class="row">
                    <div class="col-md-2">First Name</div>
                    <div class="col-md-4">
                       <input type="text" name="first_name" value="<%= obj.get("first_name") %>" placeholder="First Name" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Last Name</div>
                    <div class="col-md-4">
                        <input type="text" name="last_name" placeholder="Last Name" value="<%= obj.get("last_name") %>" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Age</div>
                    <div class="col-md-4">
                        <input type="text" name="age" placeholder="Age" value="<%= obj.get("age") %>" required>
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
                        <input type="text" name="weight" placeholder="Weight" value="<%= obj.get("weight") %>" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Height</div>
                    <div class="col-md-4">
                        <input type="text" name="height" placeholder="Height" value="<%= obj.get("height") %>" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Blood Group</div>
                    <div class="col-md-4">
                        <select id="blood_group" name="blood_group" required>
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
                        <label><input type="radio" name="allergy" value="Yes" onclick="allergyRadio()" required>
                            Yes</label>
                        <label><input type="radio" name="allergy" value="No" onclick="allergyRadio()" required>
                            No</label>
                        <textarea name="allergy_desc" disabled placeholder="Description"><%= obj.get("allergy_desc") %></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Chronic Disease</div>
                    <div class="col-md-4">
                        <label><input type="radio" name="chronic_disease" value="Yes" onclick="chronicRadio()" required>
                            Yes</label>
                        <label><input type="radio" name="chronic_disease" value="No" onclick="chronicRadio()" required>
                            No</label>
                        <textarea name="chronic_disease_desc" disabled placeholder="Description"><%= obj.get("chronic_disease_desc") %></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Test</div>
                    <div class="col-md-4">
                        <textarea name="test" placeholder="Test" required><%= obj.get("test") %></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Symptoms</div>
                    <div class="col-md-4">
                        <textarea name="symptoms" placeholder="Symptoms" required><%= obj.get("symptoms") %></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">Diagnosis</div>
                    <div class="col-md-4">
                        <textarea name="diagnosis" placeholder="Diagnosis" required><%= obj.get("diagnosis") %></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <input hidden name="id" type="text" value="<%= id %>">
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<div id="variables">
    <p hidden id="gender"><%= obj.get("gender") %></p>
    <p hidden id="allergy"><%= obj.get("allergy") %></p>
    <p hidden id="chronic_disease"><%= obj.get("chronic_disease") %></p>
    <p hidden id="blood_group_val"><%= obj.get("blood_group") %></p>
</div>
<script>
    blood_group = document.getElementById("blood_group_val").textContent;
    $("#blood_group").val(blood_group);
    var gender=document.getElementById("gender").textContent;
    if(gender=="Male"){
        $("input:radio[name='gender']").filter('[value=Male]').prop('checked', true);
    }
    else{
        $("input:radio[name='gender']").filter('[value=Female]').prop('checked', true);
    }

    var allergy=document.getElementById("allergy").textContent;
    if(allergy=="Yes"){
        $("input:radio[name='allergy']").filter('[value=Yes]').prop('checked', true);
        $("textarea[name='allergy_desc']").prop("disabled", false);
        $("textarea[name='allergy_desc']").prop("required", true);
    }
    else{
        $("input:radio[name='allergy']").filter('[value=No]').prop('checked', true);
        $("textarea[name='allergy_desc']").prop("disabled", true);
        $("textarea[name='allergy_desc']").prop("required", false);
        $("textarea[name='allergy_desc']").val('').empty();
    }

    var chronic_disease=document.getElementById("chronic_disease").textContent;
    if(chronic_disease=="Yes"){
        $("input:radio[name='chronic_disease']").filter('[value=Yes]').prop('checked', true);
        $("textarea[name='chronic_disease_desc']").prop("disabled", false);
        $("textarea[name='chronic_disease_desc']").prop("required", true);
    }
    else{
        $("input:radio[name='chronic_disease']").filter('[value=No]').prop('checked', true);
        $("textarea[name='chronic_disease_desc']").prop("disabled", true);
        $("textarea[name='chronic_disease_desc']").prop("required", false);
        $("textarea[name='chronic_disease_desc']").val('').empty();
    }

    function allergyRadio() {
        var radioValue = $("input[name='allergy']:checked").val();
        if (radioValue == "Yes") {
            $("textarea[name='allergy_desc']").prop("disabled", false);
            $("textarea[name='allergy_desc']").prop("required", true);
        }
        else {
            $("textarea[name='allergy_desc']").prop("disabled", true);
            $("textarea[name='allergy_desc']").prop("required", false);
            $("textarea[name='allergy_desc']").val('').empty();

        }
    }

    function chronicRadio() {
        var radioValue = $("input[name='chronic_disease']:checked").val();
        if (radioValue == "Yes") {
            $("textarea[name='chronic_disease_desc']").prop("disabled", false);
            $("textarea[name='chronic_disease_desc']").prop("required", true);
        }
        else {
            $("textarea[name='chronic_disease_desc']").prop("disabled", true);
            $("textarea[name='chronic_disease_desc']").prop("required", false);
            $("textarea[name='chronic_disease_desc']").val('').empty();
        }
    }
</script>
</body>
</html>