package com.awscalculator.calculator;

import org.springframework.stereotype.Component;

@Component("Local")
public class ServiceProviderLocalImplementation implements ServiceProvider {

	@Override
	public Integer add(int a, int b) {
		return a + b;
	}

	@Override
	public Integer subtract(int a, int b) {
		return a - b;
	}

	@Override
	public Integer multiply(int a, int b) {
		return a*b;
	}

	@Override
	public Integer divide(int a, int b) {
		return a/b;
	}

}
