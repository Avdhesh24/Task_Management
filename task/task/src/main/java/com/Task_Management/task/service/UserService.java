package com.Task_Management.task.service;

import com.Task_Management.task.models.User;

public interface UserService {
    User registerUser(User user);

    User getUserByUsername(String username);
}