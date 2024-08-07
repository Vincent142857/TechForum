package com.springboot.app.accounts.entity;

import com.springboot.app.accounts.enumeration.Gender;
import com.springboot.app.model.BaseEntity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "person")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Person extends BaseEntity {
	@PrePersist
	public void prePersist() {
		LocalDateTime now = LocalDateTime.now();
		this.setCreatedAt(now);
		this.setUpdatedAt(now);
	}

	@PreUpdate
	public void preUpdate() {
		LocalDateTime now = LocalDateTime.now();
		this.setUpdatedAt(now);
	}


	@Id
	@GeneratedValue(strategy= GenerationType.IDENTITY)
	private Long id;

	@Column(name="first_name", length=100)
	private String firstName;

	@Column(name="last_name", length=100)
	private String lastName;

	@Column(name="birth_date", columnDefinition="DATE")
	private LocalDate birthDate;

	@Column(name="gender")
	@Enumerated(EnumType.STRING)
	private Gender gender;

	@Column(name="phone", length=50)
	private String phone;

	@Column(name="address", length=255)
	private String address;

	@Column(name="bio", length=255)
	private String bio;

	@Column(name="profile_banner", length=255)
	@Lob
	private byte[] profileBanner;

}
