package com.portfolio.access;

import org.springframework.security.core.userdetails.UsernameAlreadyExistsException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/register")
public class RegistrationController {

	private final RegistrationService registrationService;

	public RegistrationController(RegistrationService registrationService) {
		this.registrationService = registrationService;
	}

	@GetMapping
	public String form(Model model) {
		if (!model.containsAttribute("registrationForm")) {
			model.addAttribute("registrationForm", new RegistrationForm());
		}
		return "register";
	}

	@PostMapping
	public String register(@Valid @ModelAttribute RegistrationForm registrationForm,
			BindingResult bindingResult,
			Model model) {
		if (bindingResult.hasErrors()) {
			return "register";
		}

		try {
			registrationService.register(registrationForm.getUsername(), registrationForm.getPassword());
			return "redirect:/login?registered";
		} catch (UsernameAlreadyExistsException exception) {
			model.addAttribute("errorMessage", "That username is already in use.");
			return "register";
		}
	}
}
