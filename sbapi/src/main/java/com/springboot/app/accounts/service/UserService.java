package com.springboot.app.accounts.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.springboot.app.accounts.dto.request.NewPasswordRequest;
import com.springboot.app.accounts.dto.request.UpdateRoleRequest;
import com.springboot.app.accounts.entity.User;
import com.springboot.app.dto.response.PaginateResponse;
import com.springboot.app.dto.response.ServiceResponse;
import com.springboot.app.security.dto.request.SignupRequest;

@Service
public interface UserService {

	Optional<User> findById(Long id);

	Optional<User> findByUsername(String username);

	Optional<User> findByEmail(String email);

	PaginateResponse getAllUsers(int page, int size, String orderBy, String sortDirection, String search);

	ServiceResponse<User> createNewUser(SignupRequest signupRequest);

	ServiceResponse<Void> deleteUser(User user);

	ServiceResponse<User> updateStatusUser(Long id, String status);

	void updateLastLogin(Long id);

	ServiceResponse<User> updateRoleUser(UpdateRoleRequest updateRoleRequest);

	ServiceResponse<Void> updateNewPassword(NewPasswordRequest newPasswordRequest, User user);

	ServiceResponse<List<User>> findUserByRoleMod();
}
