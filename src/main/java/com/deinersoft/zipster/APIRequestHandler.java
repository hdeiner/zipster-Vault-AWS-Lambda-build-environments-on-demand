package com.deinersoft.zipster;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
public class APIRequestHandler implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {
    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent apiGatewayProxyRequestEvent, Context context) {
        System.out.println("APIGatewayProxyResponseEvent START");
        System.out.println("apiGatewayProxyRequestEvent="+apiGatewayProxyRequestEvent.toString());
        System.out.println("context="+context.toString());
        LambdaLogger logger = context.getLogger();
        APIGatewayProxyResponseEvent apiGatewayProxyResponseEvent = new APIGatewayProxyResponseEvent();
        try {
            String requestString = apiGatewayProxyRequestEvent.getBody();
            System.out.println("requestString="+requestString);
            logger.log("requestString="+requestString);
            JSONParser parser = new JSONParser();
            JSONObject requestJsonObject = (JSONObject) parser.parse(requestString);
            System.out.println("requestJsonObject="+requestJsonObject.toString());
            logger.log("requestJsonObject="+requestJsonObject.toString());
            String requestMessage = null;
            String responseMessage = null;
            String zipcode = "";
            String radius = "";
            if (requestJsonObject != null) {
                if (requestJsonObject.get("zipcode") != null) {
                    zipcode = requestJsonObject.get("zipcode").toString();
                }
                if (requestJsonObject.get("radius") != null) {
                    radius = requestJsonObject.get("radius").toString();
                }
            }
            Map<String, String> responseBody = new HashMap<String, String>();
            responseBody.put("ourprocessedreturn", "answer for zipcode="+zipcode+" and radius="+radius);
            responseMessage = new JSONObject(responseBody).toJSONString();
            generateResponse(apiGatewayProxyResponseEvent, responseMessage);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return apiGatewayProxyResponseEvent;
    }
    private void generateResponse(APIGatewayProxyResponseEvent apiGatewayProxyResponseEvent, String requestMessage) {
        apiGatewayProxyResponseEvent.setHeaders(Collections.singletonMap("timeStamp", String.valueOf(System.currentTimeMillis())));
        apiGatewayProxyResponseEvent.setStatusCode(200);
        apiGatewayProxyResponseEvent.setBody(requestMessage);
    }
}