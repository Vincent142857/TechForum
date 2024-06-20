package com.springboot.app.forums.controller.mobile;

import com.springboot.app.forums.dto.request.MobileDiscussionRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/mobile/discussion")
public class MobileDiscussionController {

	private static final Logger logger = LoggerFactory.getLogger(MobileDiscussionController.class);

	//create a new discussion
	@PostMapping("/add")
	public ResponseEntity<MobileDiscussionRequest> addDiscussion(@RequestBody MobileDiscussionRequest newDiscussion) {
		logger.info("MobileDiscussionController.addDiscussion() called");

		return ResponseEntity.ok(newDiscussion);
	}


}
