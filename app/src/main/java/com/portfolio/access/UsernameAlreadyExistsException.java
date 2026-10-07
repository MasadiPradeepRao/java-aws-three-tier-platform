package com.portfolio.access;

/** Signals that a registration request used an existing username. */
public class UsernameAlreadyExistsException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public UsernameAlreadyExistsException() {
		super("The username is already in use.");
	}

	public UsernameAlreadyExistsException(Throwable cause) {
		super("The username is already in use.", cause);
	}
}
