package com.springboot.app.forums.controller.mobile;

import com.springboot.app.dto.response.ObjectResponse;
import com.springboot.app.dto.response.ServiceResponse;
import com.springboot.app.forums.dto.request.MobileAllDiscussion;
import com.springboot.app.forums.service.mobile.MobileDiscussionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/mobile/discussions")
public class MobileDiscussionController {
    @Autowired
    private MobileDiscussionService mobileDiscussionService;

    @GetMapping("/all")
    public ResponseEntity<ObjectResponse> getAllDiscussions(@RequestParam(value = "title", defaultValue = "", required = false) String title) {
        ServiceResponse<List<MobileAllDiscussion>> response = mobileDiscussionService.getAllDiscussion(title);
        if(response.getDataObject() == null || response.getDataObject().isEmpty()){
            return ResponseEntity.ok(new ObjectResponse("401","No discussions found", null));
        }

        return ResponseEntity.ok(new ObjectResponse("200","Discussions found", response.getDataObject()));
     }
}
