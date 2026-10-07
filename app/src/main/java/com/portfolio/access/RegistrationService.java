package com.portfolio.access;

import java.util.Locale;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RegistrationService {

	private final UserDetailsManager users;
	private final PasswordEncoder passwordEncoder;

	public RegistrationService(UserDetailsManager users, PasswordEncoder passwordEncoder) {
		this.users = users;
		this.passwordEncoder = passwordEncoder;
	}

	@Transactional
	public void register(String requestedUsername, String rawPassword) {
		String username = requestedUsername.trim().toLowerCase(Locale.ROOT);
		UserDetails account = User.withUsername(username)
				.password(passwordEncoder.encode(rawPassword))
				.roles("USER")
				.build();

		if (users.userExists(username)) {
			throw new UsernameAlreadyExistsException();
		}

		try {
			users.createUser(account);
		} catch (DuplicateKeyException exception) {
			throw new UsernameAlreadyExistsException(exception);
		}
	}
}
