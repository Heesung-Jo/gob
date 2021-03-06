package com.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Component;

import com.repository.memberdao;
import com.entity.member;

/**
 * NOTE: This is no longer used. See {@link SpringSecurityUserContext}.
 *
 * Returns the same user for every call to {@link #getCurrentUser()}. This is used prior to adding security, so that the
 * rest of the application can be used.
 *
 * @author Rob Winch
 * @see SpringSecurityUserContext
 *
 * @deprecated
 */
@Deprecated
//@Component
public class UserContextStub implements UserContext {
    private final memberdao userService;
    /**
     * The {@link member#getId()} for the user that is representing the currently logged in user. This can be
     * modified using {@link #setCurrentUser(member)}
     */
    private int currentUserId = 0;

    @Autowired
    public UserContextStub(memberdao userService) {
        if (userService == null) {
            throw new IllegalArgumentException("userService cannot be null");
        }
        this.userService = userService;
    }

    @Override
    public member getCurrentUser() {
        return userService.getUser(currentUserId);
    }

    @Override
    public void setCurrentUser(member user) {
        if (user == null) {
            throw new IllegalArgumentException("user cannot be null");
        }
        Integer currentId = user.getId();
        if(currentId == null) {
            throw new IllegalArgumentException("user.getId() cannot be null");
        }
        this.currentUserId = currentId;
    }
}