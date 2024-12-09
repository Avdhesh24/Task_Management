package com.Task_Management.task.security;

import com.Task_Management.task.models.User;
import com.Task_Management.task.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class MyUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        Optional<User> user  = userRepository.findByUsername(username);

        if(user.isEmpty())
        {
            throw new UsernameNotFoundException("user not found with this email : "+username);
        }

        return new MyUserDetails(user.orElse(null));
    }
}
