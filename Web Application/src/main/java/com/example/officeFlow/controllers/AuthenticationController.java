package com.example.officeFlow.controllers;

import com.example.officeFlow.model.User;
import com.example.officeFlow.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDateTime;

/**
 * Controller for handling authentication actions
 */
@Controller
public class AuthenticationController {

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Displays the registration form
     *
     * @param model for passing a new user object to the form
     * @return the register form view
     */
    @GetMapping("/register")
    public String register(Model model) {
        model.addAttribute("user", new User());
        return "auth/register";
    }

    /**
     * Handles the registration of a new user
     *
     * @param user   - new user object to be saved
     * @param result - validation result that checks for input errors
     * @param model  - passes the success or error message to the next view
     * @return the login view if successful, or the error view if not
     */
    @PostMapping("/register")
    public ModelAndView register(@ModelAttribute("user") User user, BindingResult result, Model model) {
        if (result.hasErrors()) {
            return new ModelAndView("error", "error", result.getAllErrors());
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setCreationTimestamp(LocalDateTime.now());
        userService.save(user);

        return new ModelAndView("redirect:/login", "success", "Successful registration");
    }

    /**
     * Displays the login form
     *
     * @return the login view
     */
    @GetMapping("/login")
    public String login() {
        return "auth/login";
    }


    /**
     * The register form calls this to check if the email is already in use
     *
     * @param email - the email to be checked
     * @return true if the email is already in use, false if not
     */
    @PostMapping("/checkEmail")
    @ResponseBody
    public String checkEmail(@RequestParam("userEmail") String email, @RequestParam(value="loggedIn", defaultValue = "False") String loggedIn) {
        User user = userService.findByEmail(email);
        if (user == null) {
            System.out.println("No match");
            return "false";
        } else {
            System.out.println("Email already in use");
            if (loggedIn.equals("True")) {
                User loggedInUser = userService.findLoggedInUser();
                if (loggedInUser != null && loggedInUser.getEmail().equals(email)) {
                    return "false";
                }
            }
            return "true";
        }
    }

}
