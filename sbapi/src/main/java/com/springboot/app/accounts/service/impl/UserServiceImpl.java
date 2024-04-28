package com.springboot.app.accounts.service.impl;

import com.springboot.app.accounts.entity.DeletedUser;
import com.springboot.app.accounts.entity.PasswordReset;
import com.springboot.app.accounts.entity.Role;
import com.springboot.app.accounts.entity.User;
import com.springboot.app.accounts.enumeration.AuthProvider;
import com.springboot.app.accounts.enumeration.RoleName;
import com.springboot.app.accounts.repository.DeletedUserRepository;
import com.springboot.app.accounts.repository.PasswordResetRepository;
import com.springboot.app.accounts.repository.RoleRepository;
import com.springboot.app.accounts.repository.UserRepository;
import com.springboot.app.accounts.service.UserService;
import com.springboot.app.dto.response.AckCodeType;
import com.springboot.app.dto.response.ObjectResponse;
import com.springboot.app.dto.response.PaginateResponse;
import com.springboot.app.dto.response.ServiceResponse;
import com.springboot.app.security.dto.request.SignupRequest;
import com.springboot.app.security.jwt.JwtUtils;
import com.springboot.app.utils.Validators;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class UserServiceImpl implements UserService {

	private static final Logger logger = LoggerFactory.getLogger(JwtUtils.class);

	@Autowired
	private	UserRepository userRepository;

	@Autowired
	private RoleRepository roleRepository;

	@Autowired
	PasswordEncoder encoder;
	@Autowired
	private PasswordResetRepository passwordResetRepository;
	@Autowired
	private DeletedUserRepository deletedUserRepository;

	@Override
	public Optional<User> findById(Long id) {
		return userRepository.findById(id);
	}

	public Optional<User> findByUsername(String username) {
		return userRepository.findByUsername(username);
	}

	public Optional<User> findByEmail(String email) {
		return userRepository.findByEmail(email);
	}

	@Override
	public PaginateResponse getAllUsers(int pageNo, int pageSize, String orderBy, String sortDir) {
		Sort sort = sortDir.equalsIgnoreCase(Sort.Direction.ASC.name()) ? Sort.by(orderBy).ascending()
				: Sort.by(orderBy).descending();

		// create Pageable instance
		Pageable pageable = PageRequest.of(pageNo-1, pageSize, sort);
		// get the list of users from the UserRepository and return it as a Page object
		Page<User> usersPage = userRepository.findAll(pageable);

		return new PaginateResponse(
				usersPage.getNumber()+1,
				usersPage.getSize(),
				usersPage.getTotalPages(),
				usersPage.getContent().size(),
				usersPage.isLast(),
				usersPage.getContent());
	}

	@Override
	public User save(SignupRequest signUpRequest) {
		try{
			List<String> errorMessages = validateUser(signUpRequest);
			if(!errorMessages.isEmpty()) {
				logger.error("Error: User not created. %s".formatted(errorMessages));
				return null;
			}
			// Create new user's account
			User user = new User(
				signUpRequest.getUsername(),
				signUpRequest.getEmail(),
				encoder.encode(signUpRequest.getPassword()), // encode the password before saving it in the database
				AuthProvider.local);

			Set<String> strRoles = signUpRequest.getRoles();
			Set<Role> roles = new HashSet<>();
			if (strRoles == null) {
				Role userRole = roleRepository.findByName(RoleName.ROLE_USER)
					.orElseThrow(() -> new RuntimeException("Error: Role is not found."));
				roles.add(userRole);
			} else {
				strRoles.forEach(role -> {
				switch (role) {
					case "admin":
						Role adminRole = roleRepository.findByName(RoleName.ROLE_ADMIN)
								.orElseThrow(() -> new RuntimeException("Error: Role is not found."));
						roles.add(adminRole);
						break;
					case "mod":
						Role modRole = roleRepository.findByName(RoleName.ROLE_MODERATOR)
								.orElseThrow(() -> new RuntimeException("Error: Role is not found."));
						roles.add(modRole);
						break;
					default:
						Role userRole = roleRepository.findByName(RoleName.ROLE_USER)
								.orElseThrow(() -> new RuntimeException("Error: Role is not found."));
						roles.add(userRole);
				}
			});
			}
			user.setRoles(roles);
			userRepository.save(user);
			return userRepository.save(user);
		}catch (Exception e){
			logger.error("Error: User not created. %s".formatted(e.getMessage()));
			return null;

		}
	}

	@Transactional(readOnly = false)
	public ServiceResponse<Void> passwordReset(PasswordReset passwordReset, String newPassword) {
		ServiceResponse<Void> response = new ServiceResponse<>();
		User user = userRepository.findByEmail(passwordReset.getEmail()).orElse(null);
		if(user != null && !"".equals(newPassword)) {
			user.setPassword(encoder.encode(newPassword));
			userRepository.save(user);
			passwordResetRepository.delete(passwordReset);
		}
		else {
			response.setAckCode(AckCodeType.FAILURE);
			response.addMessage(String.format(
				"Unable to locate user with email %s", passwordReset.getEmail()));
		}
		return response;
	}

	@Transactional(readOnly=false)
	public ServiceResponse<Void> deleteUser(User user) {

		ServiceResponse<Void> response = new ServiceResponse<>();

		DeletedUser deletedUser = DeletedUser.fromUser(user);

		// clear up relationships before deleting
		user.setPerson(null);
		user.setStat(null);
		userRepository.delete(user);

		// save deletedUser
		deletedUserRepository.save(deletedUser);

		return response;
	}



	private List<String> validateUser(SignupRequest user) {

		List<String> messages = new ArrayList<>();

		if(user.getUsername().length() < 5) {
			messages.add("Username must be at least 5 characters");
		}
		else if(userRepository.existsByUsername(user.getUsername()) || deletedUserRepository.existsByUsername(user.getUsername())) {
			messages.add("Username already exists in the system");
		}

		if(!Validators.isEmailValid(user.getEmail())) {
			messages.add("Invalid Email Format");
		}
		else if(userRepository.existsByEmail(user.getEmail()) || deletedUserRepository.existsByEmail(user.getEmail())) {
			messages.add("Email already exists in the system");
		}

		if(user.getPassword().length() < 5) {
			messages.add("Password must be at least 5 characters");
		}

		return messages;
	}


}
