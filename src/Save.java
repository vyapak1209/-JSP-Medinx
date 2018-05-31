import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

@WebServlet(urlPatterns = "/Save")
public class Save extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String patientID = id;
        String first_name = request.getParameter("first_name");
        String last_name = request.getParameter("last_name");
        String age = request.getParameter("age");
        String gender = request.getParameter("gender");
        String weight = request.getParameter("weight");
        String height = request.getParameter("height");
        String blood_group = request.getParameter("blood_group");
        String allergy = request.getParameter("allergy");
        String allergy_desc = request.getParameter("allergy_desc");
        String chronic_disease = request.getParameter("chronic_disease");
        String chronic_disease_desc = request.getParameter("chronic_disease_desc");
        String test = request.getParameter("test");
        String symptoms = request.getParameter("symptoms");
        String diagnosis = request.getParameter("diagnosis");

        HttpSession session = request.getSession();
        String doctorID = (String)session.getAttribute("doctorID");

        HttpClient req = HttpClients.createDefault();
        HttpPost post = new HttpPost("http://localhost:9200/medinx/reports/"+id);

        StringEntity params = new StringEntity("{\"first_name\":\"" + first_name + "\"," +
                "\"last_name\":\"" + last_name + "\"," +
                "\"age\":\"" + age + "\"," +
                "\"gender\":\"" + gender + "\"," +
                "\"weight\":\"" + weight + "\"," +
                "\"height\":\"" + height + "\"," +
                "\"blood_group\":\"" + blood_group + "\"," +
                "\"allergy\":\"" + allergy + "\"," +
                "\"allergy_desc\":\"" + allergy_desc + "\"," +
                "\"chronic_disease\":\"" + chronic_disease + "\"," +
                "\"chronic_disease_desc\":\"" + chronic_disease_desc + "\"," +
                "\"test\":\"" + test + "\"," +
                "\"symptoms\":\"" + symptoms + "\"," +
                "\"doctorID\":\"" + doctorID + "\"," +
                "\"diagnosis\":\"" + diagnosis + "\"}");

        post.addHeader("content-type", "application/json");
        post.setEntity(params);
        HttpResponse res = req.execute(post);

        HttpEntity entity = res.getEntity();
        InputStream instream = entity.getContent();
        String result = convertStreamToString(instream);
        System.out.println("Result : " + result);

        String str = "patient.jsp?id="+patientID;
        System.out.println(str);
        response.sendRedirect("patient.jsp?id="+patientID);
    }

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
}
