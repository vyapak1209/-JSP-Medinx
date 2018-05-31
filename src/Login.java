import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;

import org.json.JSONArray;
import org.json.JSONObject;

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

@WebServlet(urlPatterns = "/Login")
public class Login extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        HttpClient req = HttpClients.createDefault();
        HttpPost post = new HttpPost("http://localhost:9200/medinx/doctors/_search");

        StringEntity params = new StringEntity("{\"query\":{\"bool\":{\"must\":[{\"match\":{\"email\": \""+email+"\"}},{\"match\":{\"password\":\""+password+"\"}}]}}}");

        post.addHeader("content-type", "application/json");
        post.setEntity(params);
        HttpResponse res = req.execute(post);

        HttpEntity entity = res.getEntity();
        InputStream instream = entity.getContent();
        String result = convertStreamToString(instream);
        System.out.println("Result : " + result);

        int total=0;
        String doctorID=null;
        try {

            JSONObject json = new JSONObject(result);
            JSONObject hits = (JSONObject) json.get("hits");
            total = (int)hits.get("total");
            System.out.println("Total Hits : " + total);
            System.out.println("Hits : " + hits.get("hits"));
            JSONArray hitsArray = hits.getJSONArray("hits");

            int length = hitsArray.length();
            System.out.println("Array Length : " + length);
            if(length!=0){
                JSONObject doctorInfo = hitsArray.getJSONObject(0);
                doctorID = (String)doctorInfo.get("_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        if(total==0){
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
