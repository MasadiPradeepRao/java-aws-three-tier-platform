package com.portfolio.access;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class RegistrationForm {

	@NotBlank
	@Size(min = 3, max = 50)
	@Pattern(regexp = "[A-Za-z0-9._-]+", message = "Use letters, numbers, dots, underscores, or hyphens.")
	private String username;

	@NotBlank
	@Size(min = 12, max = 72, message = "Use between 12 and 72 characters.")
	private String password;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
}
