package com.springboot.app.forums.entity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.springboot.app.model.BaseEntity;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.OrderBy;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "forums")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Forum extends BaseEntity {
	@PrePersist
	public void prePersist() {
		LocalDateTime now = LocalDateTime.now();
		this.setCreatedAt(now);
	}

	@PreUpdate
	public void preUpdate() {
		LocalDateTime now = LocalDateTime.now();
		this.setUpdatedAt(now);
	}

	@Id
	@GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
	private Long id;

	@Column(name = "title", length = 100, unique = true)
	private String title;

	@Column(name = "description", length = 200)
	private String description;

	@Column(name = "icon", length = 30)
	private String icon;

	@Column(name = "color", length = 30)
	private String color;

	@Column(name = "active")
	private boolean active;

	@Column(name = "sort_order")
	private Integer sortOrder;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "forum_group_id", foreignKey = @ForeignKey(name = "FK_FORUM_FORUM_GROUP"))
	private ForumGroup forumGroup; // point to group that this forum belongs to

	@OneToMany(mappedBy = "forum", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	@OrderBy("createdAt DESC")
	private List<Discussion> discussions = new ArrayList<>();

	@OneToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	@JoinColumn(name = "forum_stat_id", foreignKey = @ForeignKey(name = "FK_FORUM_FORUM_STAT"))
	private ForumStat stat;

}
