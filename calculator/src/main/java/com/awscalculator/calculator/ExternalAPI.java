package com.awscalculator.calculator;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

@Component
public class ExternalAPI {
	private static final RestTemplate REST_TEMPLATE = new RestTemplate();
	
	public static final String ADD = "add";
	public static final String SUBTRACT = "subtract";
	public static final String MULTIPLY = "multiply";
	public static final String DIVIDE = "divide";
	
	private static String apiRoot;// = "https://6qs53q76s7.execute-api.eu-central-1.amazonaws.com/prod/";
	
	public static void setAPIRoot(String url) {
		apiRoot = url;
	}
	
	public Response query(String action, int a, int b) {
		final String url = apiRoot + "/" + action;
		
		Request request = new Request();
		request.setA(a);
		request.setB(b);
		
		return REST_TEMPLATE.postForObject(url, request, Response.class);
	}
}
