package com.config;

import org.springframework.context.annotation.*;

/**
 * @author Mick Knutson
 * @since chapter 01.00
 */
@Configuration
@Import({SecurityConfig.class}) // , CachingConfig.class
public class JavaConfig {

	
} // The end...
