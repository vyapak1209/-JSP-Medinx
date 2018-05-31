import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.json.simple.JSONArray;
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

@WebServlet(urlPatterns = "/SignUp")
public class SignUp extends HttpServlet {


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String first_name = request.getParameter("first_name");
        String last_name = request.getParameter("last_name");
        String qualification = request.getParameter("qualification");
        String specialization = request.getParameter("specialization");
        String contact = request.getParameter("contact");
        String associated_hospital = request.getParameter("associated_hospital");
        String hospital_id = request.getParameter("hospital_id");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        HttpClient req = HttpClients.createDefault();
        HttpPost post = new HttpPost("http://localhost:9200/medinx/doctors");

        StringEntity params = new StringEntity("{\"first_name\":\"" + first_name + "\"," +
                                                "\"last_name\":\"" + last_name + "\"," +
                                                "\"qualification\":\"" + qualification + "\"," +
                                                "\"specialization\":\"" + specialization + "\"," +
                                                "\"contact\":\"" + contact + "\"," +
                                                "\"associated_hospital\":\"" + associated_hospital + "\"," +
                                                "\"hospital_id\":\"" + hospital_id + "\"," +
                                                "\"email\":\"" + email + "\"," +
                                                "\"password\":\"" + password + "\"}");

        post.addHeader("content-type", "application/json");
        post.setEntity(params);
        HttpResponse res = req.execute(post);

        HttpEntity entity = res.getEntity();
        InputStream instream = entity.getContent();
        String result = convertStreamToString(instream);
        System.out.println("Result : " + result);

        String status = null;
        String doctorID=null;
        try {
            JSONParser parser = new JSONParser();
            Object obj = parser.parse(result);
            JSONObject json = (JSONObject)obj;
            status = (String)json.get("result");
            doctorID = (String)json.get("_id");
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if(status.equals("failed")){
            response.sendRedirect("index.html");
        }
        else{
            HttpSession session = request.getSession();
            session.setAttribute("doctorID",doctorID);
            response.sendRedirect("generate-report.jsp");
        }
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
