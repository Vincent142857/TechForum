package com.springboot.app.forums.repository;

import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.springboot.app.forums.entity.Forum;
import com.springboot.app.forums.entity.ForumGroup;

import java.util.List;

@Repository("forumGroupRepository")
public interface ForumGroupRepository extends JpaRepository<ForumGroup, Long> {

	@Transactional
	@Modifying
	@Query("UPDATE ForumGroup fg SET fg.sortOrder = fg.sortOrder - 1 WHERE fg.sortOrder > :sortOrderBy")
	void decrementSortOrder(int sortOrderBy);

	//findBySortOrder
	@Query("SELECT fg FROM ForumGroup fg WHERE fg.sortOrder = :sortOrder")
	ForumGroup findBySortOrder(@Param("sortOrder") Integer sortOrder);

}
