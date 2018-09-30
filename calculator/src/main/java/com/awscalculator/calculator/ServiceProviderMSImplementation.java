package com.awscalculator.calculator;

import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component("MicroService")
public class ServiceProviderMSImplementation implements ServiceProvider {
	

	@Override
	public Integer add(int a, int b) {
		//RestTemplate restTemplate = new RestTemplate();
		return 42;
	}

	@Override
	public Integer subtract(int a, int b) {
		return 42;
	}

	@Override
	public Integer multiply(int a, int b) {
		return 42;
	}

	@Override
	public Integer divide(int a, int b) {
		return 42;
	}

}
