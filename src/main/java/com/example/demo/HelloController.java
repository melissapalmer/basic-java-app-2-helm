package com.example.demo;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.util.RandomNumber;

@RestController()
public class HelloController {

	@Autowired
	private GreetingRepository greetingRepo;

	@GetMapping("/hello")
	public GreetingResponse sayHello() {
		Greeting greeting = greetingRepo.getOne(RandomNumber.getRandomNumberInRange(1, 3));

		GreetingResponse greetingResponse = new GreetingResponse();
		BeanUtils.copyProperties(greeting, greetingResponse);

		return greetingResponse;
	}
}
