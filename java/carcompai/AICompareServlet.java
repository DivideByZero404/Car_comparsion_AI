package carcompai;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import com.google.gson.*;

public class AICompareServlet extends HttpServlet {

    private static final String API_KEY = "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";

   
   @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String question = req.getParameter("question");
        String context  = req.getParameter("context");

        if (question == null) question = "";
        if (context == null) context = "";

        // Build request for OpenAI Responses API
        JsonObject root = new JsonObject();
        root.addProperty("model", "gpt-4.1-mini");

        JsonArray inputArr = new JsonArray();
        JsonObject messageObj = new JsonObject();
        messageObj.addProperty("role", "user");
        messageObj.addProperty("content", context + "\n\n" + question);
        inputArr.add(messageObj);
        root.add("input", inputArr);

        HttpClient client = HttpClient.newHttpClient();

        HttpRequest httpReq = HttpRequest.newBuilder()
                .uri(URI.create("https://api.openai.com/v1/responses"))
                .header("Authorization", "Bearer " + API_KEY)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(root.toString()))
                .build();

        String answer = "";

        try {
            HttpResponse<String> apiResp =
                    client.send(httpReq, HttpResponse.BodyHandlers.ofString());

            JsonObject res = JsonParser.parseString(apiResp.body()).getAsJsonObject();

            if (res.has("output") && res.getAsJsonArray("output").size() > 0) {
                JsonObject firstOutput = res.getAsJsonArray("output").get(0).getAsJsonObject();
                if (firstOutput.has("content") && firstOutput.getAsJsonArray("content").size() > 0) {
                    JsonObject firstContent = firstOutput.getAsJsonArray("content").get(0).getAsJsonObject();
                    if (firstContent.has("text")) {
                        answer = firstContent.get("text").getAsString();
                    }
                }
            } else {
                answer = "API returned unexpected format:\n" + apiResp.body();
            }

        } catch (Exception e) {
            answer = "AI Exception: " + e.getMessage();
        }

        // Clean markdown symbols
        answer = answer.replace("####", "");
        answer = answer.replace("###", "");
        answer = answer.replace("##", "");
        answer = answer.replace("#", "");
        answer = answer.replace("**", "");
        answer = answer.replace("---", "");
        answer = answer.replace("|", "                    ");  // Replace pipes with spaces
        
        // FIX: SAFE JSON ESCAPING
        answer = escapeJson(answer);

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        out.write("{\"answer\":\"" + answer + "\"}");
        out.flush();
    }

    // Escape JSON properly
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r");
    }
}