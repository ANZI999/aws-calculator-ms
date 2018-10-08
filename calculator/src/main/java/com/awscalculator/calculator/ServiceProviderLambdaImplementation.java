package com.awscalculator.calculator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component("Lambda")
public class ServiceProviderLambdaImplementation implements ServiceProvider {
	
	@Autowired
	private ExternalAPI externalAPI;

	@Override
	public Integer add(int a, int b) {
		return externalAPI.query(ExternalAPI.ADD, a, b).getValue();
	}

	@Override
	public Integer subtract(int a, int b) {
		return externalAPI.query(ExternalAPI.SUBTRACT, a, b)
				.getValue();
	}

	@Override
	public Integer multiply(int a, int b) {
		return externalAPI.query(ExternalAPI.MULTIPLY, a, b)
				.getValue();
	}

	@Override
	public Integer divide(int a, int b) {
		return externalAPI.query(ExternalAPI.DIVIDE, a, b)
				.getValue();
	}

}
