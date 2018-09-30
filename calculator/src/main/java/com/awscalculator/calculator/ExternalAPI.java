package com.awscalculator.calculator;

import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class ExternalAPI {
	private static final String API_ROOT = "http://localhost:";
	private static final RestTemplate REST_TEMPLATE = new RestTemplate();
	
	public static final int ADD_API_PORT = 8079;
	public static final int SUBTRACT_API_PORT = 8078;
	public static final int MULTIPLY_API_PORT = 8077;
	public static final int DIVIDE_API_PORT = 8076;
	
	public Response query(int port, int param1, int param2) {
		final String uri = API_ROOT + port + "/" + param1 + "/" + param2;
		
		return REST_TEMPLATE.getForObject(uri, Response.class);
	}
}
