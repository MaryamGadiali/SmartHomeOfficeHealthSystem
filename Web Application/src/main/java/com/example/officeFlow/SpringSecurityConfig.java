package com.example.officeFlow;


import com.example.officeFlow.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SpringSecurityConfig {

    @Autowired
    private UserService userService;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        return http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(authorize -> authorize
                                .requestMatchers("/register", "/login", "/WEB-INF/views/auth/*", "/audio/**", "/css/*", "/checkEmail").permitAll()
                                .requestMatchers("/getPendingCommands", "/pairHub", "/syncTime", "/updateSeatingSensor", "/updateDevice", "/uploadSensorReading", "/getSeatingSensorMacAddress", "/getSensorMacAddress", "/getActuatorMacAddress", "/getThresholds", "/switchActuatorState").hasRole("HUB")
                                .requestMatchers("/swagger-ui/**").hasRole("ADMIN")
                                .requestMatchers("/**").hasAnyRole("USER", "ADMIN")
                                .anyRequest().authenticated()
                ).httpBasic(Customizer.withDefaults())
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .defaultSuccessUrl("/dashboard", true) // Redirect to /dashboard after login
                        .failureUrl("/login?error=true")
                        .permitAll()
                )
                .exceptionHandling(exception -> exception
                        .accessDeniedPage("/accessDenied")
                )

                .rememberMe(rememberMe -> rememberMe
                        .key("uniqueAndSecret")
                        .tokenValiditySeconds(86400) // 1 day
                        .userDetailsService(userService)
                        .useSecureCookie(true)
                )

                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout")
                        .permitAll())
                .build();

    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
