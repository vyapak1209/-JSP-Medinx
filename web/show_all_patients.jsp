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
                <li><a href="generate-report.jsp">Generate Report</a></li>
                <li><a href="show_all_patients.jsp" class="active">Show All Patients</a></li>
                <li><a href="search.jsp">Search</a></li>
                <li><a href="/Logout">Logout</a></li>
            </ul>
        </div>
        <div class="col-md-9">
            <br>
            <h3>Patients</h3>
            <hr>
             <%
                HttpClient req = HttpClients.createDefault();
                HttpPost post = new HttpPost("http://localhost:9200/medinx/reports/_search");

                StringEntity params = new StringEntity("{\"query\":{\"match_all\":{}}}");

                post.addHeader("content-type", "application/json");
                post.setEntity(params);
                HttpResponse res = req.execute(post);

                HttpEntity entity = res.getEntity();
                InputStream instream = entity.getContent();
                String result = convertStreamToString(instream);
                System.out.println("Result : " + result);

                 try {

                     JSONObject json = new JSONObject(result);
                     JSONObject hits = (JSONObject) json.get("hits");
                     System.out.println("Hits : " + hits.get("hits"));
                     JSONArray hitsArray = hits.getJSONArray("hits");

                     int length = hitsArray.length();
                     System.out.println("Array Length : " + length);
                     for(int i=0;i<length;i++){
                         JSONObject obj = hitsArray.getJSONObject(i);
                         String id = (String)obj.get("_id");
                         obj = obj.getJSONObject("_source");
                         out.println("<a href='patient.jsp?id="+ id +"' target='_blank'>" + obj.get("first_name") + " " + obj.get("last_name") + "</a><br>" );
                     }

                 } catch (Exception e) {
                     e.printStackTrace();
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
        </div>
    </div>
</div>
</body>
</html>