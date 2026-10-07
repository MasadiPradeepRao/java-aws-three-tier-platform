package com.portfolio.access;

import java.security.Principal;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PageController {

	@GetMapping("/")
	public String home() {
		return "index";
	}

	@GetMapping("/login")
	public String login(@RequestParam(required = false) String error,
			@RequestParam(required = false) String logout,
			@RequestParam(required = false) String registered,
			Model model) {
		if (error != null) {
			model.addAttribute("errorMessage", "The username or password was not accepted.");
		}
		if (logout != null) {
			model.addAttribute("message", "You are signed out.");
		}
		if (registered != null) {
			model.addAttribute("message", "Account created. You can sign in now.");
		}
		return "login";
	}

	@GetMapping("/dashboard")
	public String dashboard(Principal principal, Model model) {
		model.addAttribute("username", principal.getName());
		return "dashboard";
	}
}
