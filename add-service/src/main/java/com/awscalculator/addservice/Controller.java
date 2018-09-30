package com.awscalculator.addservice;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {
	
	@RequestMapping(value="/{a:[\\d]+}/{b:[\\d]+}", method = RequestMethod.GET)
	public Response add(@PathVariable int a, @PathVariable int b) {
		Response response = new Response();
		response.setValue(a + b);
		return response;
	}
}
