package com.awscalculator.calculator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping(value="/")
@RestController
public class Controller {
	
	@Autowired @Qualifier("MicroService")
	private ServiceProvider serviceProvider;
	
	@RequestMapping(value="/add/{a:[\\d]+}/{b:[\\d]+}", method = RequestMethod.GET)
	public Integer add(@PathVariable int a, @PathVariable int b) {
		return serviceProvider.add(a, b);
	}
	
	@RequestMapping(value="/subtract/{a:[\\d]+}/{b:[\\d]+}", method = RequestMethod.GET)
	public Integer subtract(@PathVariable int a, @PathVariable int b) {
		return serviceProvider.subtract(a, b);
	}
	
	@RequestMapping(value="/multiply/{a:[\\d]+}/{b:[\\d]+}", method = RequestMethod.GET)
	public Integer multiply(@PathVariable int a, @PathVariable int b) {
		return serviceProvider.multiply(a, b);
	}
	
	@RequestMapping(value="/divide/{a:[\\d]+}/{b:[\\d]+}", method = RequestMethod.GET)
	public Integer divide(@PathVariable int a, @PathVariable int b) {
		return serviceProvider.divide(a, b);
	}
}
