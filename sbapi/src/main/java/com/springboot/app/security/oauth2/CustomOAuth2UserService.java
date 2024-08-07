package com.springboot.app.security.oauth2;

import com.springboot.app.accounts.entity.Person;
import com.springboot.app.accounts.entity.User;
import com.springboot.app.accounts.entity.UserStat;
import com.springboot.app.accounts.enumeration.AccountStatus;
import com.springboot.app.accounts.enumeration.AuthProvider;
import com.springboot.app.accounts.enumeration.RoleName;
import com.springboot.app.accounts.repository.RoleRepository;
import com.springboot.app.accounts.repository.UserRepository;
import com.springboot.app.security.exception.OAuth2AuthenticationProcessingException;
import com.springboot.app.security.oauth2.user.OAuth2UserInfo;
import com.springboot.app.security.oauth2.user.OAuth2UserInfoFactory;
import com.springboot.app.security.service.UserDetailsImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

	@Autowired
	private UserRepository userRepository;

	@Autowired
	private RoleRepository roleRepository;

	@Autowired
	@Lazy
	private PasswordEncoder encoder;

	@Override
	public OAuth2User loadUser(OAuth2UserRequest oAuth2UserRequest) throws OAuth2AuthenticationException {
		OAuth2User oAuth2User = super.loadUser(oAuth2UserRequest);

		try {
			return processOAuth2User(oAuth2UserRequest, oAuth2User);
		} catch (AuthenticationException ex) {
			throw ex;
		} catch (Exception ex) {
			// Throwing an instance of AuthenticationException will trigger the OAuth2AuthenticationFailureHandler
			throw new InternalAuthenticationServiceException(ex.getMessage(), ex.getCause());
		}
	}

	private OAuth2User processOAuth2User(OAuth2UserRequest oAuth2UserRequest, OAuth2User oAuth2User) {
		OAuth2UserInfo oAuth2UserInfo = OAuth2UserInfoFactory.getOAuth2UserInfo(oAuth2UserRequest.getClientRegistration().getRegistrationId(), oAuth2User.getAttributes());
		if(StringUtils.isEmpty(oAuth2UserInfo.getEmail())) {
			throw new OAuth2AuthenticationProcessingException("Email not found from OAuth2 provider");
		}

		Optional<User> userOptional = userRepository.findByEmail(oAuth2UserInfo.getEmail());
		User user;
		if(userOptional.isPresent()) {
			user = userOptional.get();
			if(!user.getProvider().equals(AuthProvider.valueOf(oAuth2UserRequest.getClientRegistration().getRegistrationId()))) {
				throw new OAuth2AuthenticationProcessingException("Looks like you're signed up with " +
						user.getProvider() + " account. Please use your " + user.getProvider() +
						" account to login.");
			}
			user = updateExistingUser(user, oAuth2UserInfo);
		} else {
			user = registerNewUser(oAuth2UserRequest, oAuth2UserInfo);
		}

		return UserDetailsImpl.create(user, oAuth2User.getAttributes());
	}

	private User registerNewUser(OAuth2UserRequest oAuth2UserRequest, OAuth2UserInfo oAuth2UserInfo) {
		User user = new User();
		user.setUsername(oAuth2UserInfo.getEmail()); // Set a default username
		user.setPassword(encoder.encode("user" + (int)(Math.random()*10000))); // Set a default password
		// Encode the password before saving it in the database
		user.setProvider(AuthProvider.valueOf(oAuth2UserRequest.getClientRegistration().getRegistrationId()));
		user.setProviderId(oAuth2UserInfo.getId());
		user.setName(oAuth2UserInfo.getName());
		user.setEmail(oAuth2UserInfo.getEmail());
		user.setImageUrl(oAuth2UserInfo.getImageUrl());
		user.setAccountStatus(AccountStatus.ACTIVE);

		user.setCreatedBy(user.getUsername());

		Person person = new Person();
		person.setCreatedBy(user.getUsername());
		user.setPerson(person);

		UserStat userStat = new UserStat();
		userStat.setCreatedBy(user.getUsername());
		user.setStat(userStat);

		// Assign the user role by default
		// if the user does not specify the role during registration process
		// or if the user is registered using OAuth2 provider
		roleRepository.findByName(RoleName.ROLE_USER).ifPresent(role -> user.setRoles(new HashSet<>(Set.of(role))));

		return userRepository.save(user);
	}

	private User updateExistingUser(User existingUser, OAuth2UserInfo oAuth2UserInfo) {
		existingUser.setName(oAuth2UserInfo.getName());
		existingUser.setImageUrl(oAuth2UserInfo.getImageUrl());
		existingUser.setUpdatedBy(existingUser.getUsername());
		return userRepository.save(existingUser);
	}

	private String createUsername(){
		String username = null;
		while (username==null){
			username = "user" + (int)(Math.random()*10000);
			if(userRepository.findByUsername(username).isPresent()){
				username = null;
			}
		}
		return username;
	}

}
