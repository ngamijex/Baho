# Authentication Module for Baho Health AI
# Handles user login, signup, and session management

library(shiny)
library(shinyjs)

# Authentication UI Module
authUI <- function(id) {
  ns <- NS(id)
  
  div(
    class = "auth-container",
    
    # CSS for authentication pages
    tags$head(
      tags$style(HTML("
        .auth-container {
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          background: #ffffff;
          padding: 2rem;
          position: relative;
        }
        
        .auth-main-card {
          display: grid;
          grid-template-columns: 1fr 1fr;
          width: 100%;
          max-width: 1000px;
          min-height: 650px;
          border-radius: 1.5rem;
          overflow: hidden;
          box-shadow:
            0 25px 50px rgba(0, 0, 0, 0.15),
            0 10px 30px rgba(0, 0, 0, 0.1);
          position: relative;
          z-index: 2;
          background: #ffffff;
          border: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        /* Left side - Single Image */
        .auth-image-section {
          position: relative;
          display: flex;
          align-items: center;
          justify-content: center;
          overflow: hidden;
          background: #ffffff;
          border-radius: 1.5rem 0 0 1.5rem;
        }
        
        .auth-image-section::before {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background-image: url('login.png');
          background-size: cover;
          background-position: center;
          background-repeat: no-repeat;
          z-index: 1;
        }
        
        
        /* Right side - Form */
        .auth-form-section {
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 3rem 2.5rem;
          background: #ffffff;
          position: relative;
          border-radius: 0 1.5rem 1.5rem 0;
        }
        
        /* Language Switcher */
        .language-switcher {
          position: absolute;
          top: 1.5rem;
          right: 1.5rem;
          z-index: 10;
        }
        
        .lang-switcher-btn {
          display: flex;
          align-items: center;
          gap: 0.5rem;
          padding: 0.5rem 1rem;
          background: rgba(255, 255, 255, 0.9);
          border: 1px solid rgba(43, 122, 155, 0.2);
          border-radius: 1rem;
          font-size: 0.9rem;
          font-weight: 500;
          color: var(--color-text-primary);
          cursor: pointer;
          transition: all 0.3s ease;
          font-family: 'Inter', sans-serif;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .lang-switcher-btn:hover {
          background: rgba(255, 255, 255, 1);
          border-color: rgba(43, 122, 155, 0.3);
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .lang-flag {
          width: 20px;
          height: 15px;
          border-radius: 2px;
          object-fit: cover;
        }
        
        .lang-arrow {
          font-size: 0.8rem;
          transition: transform 0.3s ease;
        }
        
        .language-switcher.active .lang-arrow {
          transform: rotate(180deg);
        }
        
        .lang-dropdown {
          position: absolute;
          top: 100%;
          right: 0;
          background: white;
          border: 1px solid rgba(43, 122, 155, 0.2);
          border-radius: 0.75rem;
          box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
          min-width: 150px;
          opacity: 0;
          visibility: hidden;
          transform: translateY(-10px);
          transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
          z-index: 20;
        }
        
        .lang-dropdown.active {
          opacity: 1;
          visibility: visible;
          transform: translateY(0);
        }
        
        .lang-option {
          display: flex;
          align-items: center;
          gap: 0.75rem;
          padding: 0.75rem 1rem;
          color: var(--color-text-primary);
          text-decoration: none;
          font-size: 0.9rem;
          font-weight: 500;
          transition: all 0.2s ease;
          font-family: 'Inter', sans-serif;
        }
        
        .lang-option:first-child {
          border-radius: 0.75rem 0.75rem 0 0;
        }
        
        .lang-option:last-child {
          border-radius: 0 0 0.75rem 0.75rem;
        }
        
        .lang-option:hover {
          background: rgba(43, 122, 155, 0.05);
          color: var(--color-primary);
        }
        
        .lang-option.active {
          background: rgba(43, 122, 155, 0.1);
          color: var(--color-primary);
          font-weight: 600;
        }
        
        .auth-card {
          background: transparent;
          border-radius: 0;
          box-shadow: none;
          padding: 0;
          width: 100%;
          max-width: 380px;
          position: relative;
          border: none;
        }
        
        .auth-header {
          text-align: left;
          margin-bottom: 2.5rem;
        }
        
        .auth-logo {
          width: 60px;
          height: 60px;
          margin: 0 0 1.5rem 0;
          display: block;
          filter: drop-shadow(0 4px 8px rgba(43, 122, 155, 0.2));
        }
        
        .auth-title {
          font-family: 'Inter', sans-serif;
          font-size: 2.5rem;
          font-weight: 700;
          color: var(--color-text-primary);
          margin-bottom: 0.75rem;
          line-height: 1.2;
        }
        
        .auth-subtitle {
          color: var(--color-text-secondary);
          font-size: 1.1rem;
          font-family: 'Inter', sans-serif;
          line-height: 1.4;
        }
        
        .auth-form {
          margin-bottom: 1.5rem;
        }
        
        .form-group {
          margin-bottom: 1.5rem;
          position: relative;
        }
        
        .form-label {
          display: block;
          font-weight: 600;
          color: var(--color-text-primary);
          margin-bottom: 0.5rem;
          font-size: 0.9rem;
          font-family: 'Inter', sans-serif;
        }
        
        .form-input {
          width: 100%;
          padding: 1rem 1.25rem;
          border: 1px solid #E5E7EB;
          border-radius: 0.75rem;
          font-size: 1rem;
          transition: all 0.3s ease;
          box-sizing: border-box;
          background: #ffffff;
          font-family: 'Inter', sans-serif;
          position: relative;
          box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .form-input:focus {
          outline: none;
          border-color: var(--color-primary);
          box-shadow: 
            0 0 0 3px rgba(43, 122, 155, 0.1),
            0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .form-input:hover {
          border-color: rgba(43, 122, 155, 0.5);
        }
        
        .auth-btn {
          width: 100%;
          padding: 1rem 1.5rem;
          background: linear-gradient(135deg, var(--color-primary), var(--color-secondary));
          color: white;
          border: none;
          border-radius: 0.75rem;
          font-size: 1rem;
          font-weight: 600;
          cursor: pointer;
          transition: all 0.3s ease;
          margin-bottom: 1.5rem;
          position: relative;
          overflow: hidden;
          font-family: 'Inter', sans-serif;
          box-shadow: 0 4px 15px rgba(43, 122, 155, 0.3);
        }
        
        .auth-btn::before {
          content: '';
          position: absolute;
          top: 0;
          left: -100%;
          width: 100%;
          height: 100%;
          background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
          transition: left 0.5s ease;
        }
        
        .auth-btn:hover::before {
          left: 100%;
        }
        
        .auth-btn:hover {
          background: linear-gradient(135deg, var(--color-primary-dark), var(--color-secondary-dark));
          transform: translateY(-2px);
          box-shadow: 0 6px 20px rgba(43, 122, 155, 0.4);
        }
        
        .auth-btn:active {
          transform: translateY(-1px) scale(1.01);
        }
        
        .auth-btn:disabled {
          background: linear-gradient(135deg, #9CA3AF, #6B7280);
          cursor: not-allowed;
          transform: none;
          box-shadow: none;
        }
        
        .auth-btn:disabled::before {
          display: none;
        }
        
        .auth-switch {
          text-align: center;
          color: var(--color-text-secondary);
          font-size: 0.9rem;
          font-family: 'Inter', sans-serif;
        }
        
        .auth-switch a {
          color: var(--color-primary);
          text-decoration: none;
          font-weight: 600;
          transition: all 0.3s ease;
          position: relative;
        }
        
        .auth-switch a::after {
          content: '';
          position: absolute;
          bottom: -2px;
          left: 0;
          width: 0;
          height: 2px;
          background: var(--color-primary);
          transition: width 0.3s ease;
        }
        
        .auth-switch a:hover::after {
          width: 100%;
        }
        
        .auth-switch a:hover {
          color: var(--color-primary-dark);
        }
        
        .error-message {
          background: rgba(254, 226, 226, 0.9);
          backdrop-filter: blur(10px);
          color: #DC2626;
          padding: 1rem;
          border-radius: 1rem;
          margin-bottom: 1rem;
          font-size: 0.9rem;
          border: 1px solid rgba(254, 202, 202, 0.5);
          font-family: 'Inter', sans-serif;
        }
        
        .success-message {
          background: rgba(209, 250, 229, 0.9);
          backdrop-filter: blur(10px);
          color: #059669;
          padding: 1rem;
          border-radius: 1rem;
          margin-bottom: 1rem;
          font-size: 0.9rem;
          border: 1px solid rgba(167, 243, 208, 0.5);
          font-family: 'Inter', sans-serif;
        }
        
        .loading-spinner {
          display: inline-block;
          width: 20px;
          height: 20px;
          border: 2px solid #ffffff;
          border-radius: 50%;
          border-top-color: transparent;
          animation: spin 1s ease-in-out infinite;
        }
        
        @keyframes spin {
          to { transform: rotate(360deg); }
        }
        
        @keyframes float {
          0%, 100% {
            transform: translateY(0px);
          }
          50% {
            transform: translateY(-10px);
          }
        }
        
        @keyframes liquidFlow {
          0%, 100% {
            transform: translateX(0px) translateY(0px) rotate(0deg);
          }
          25% {
            transform: translateX(10px) translateY(-5px) rotate(1deg);
          }
          50% {
            transform: translateX(-5px) translateY(-10px) rotate(-1deg);
          }
          75% {
            transform: translateX(-10px) translateY(5px) rotate(0.5deg);
          }
        }
        
        @keyframes glassShimmer {
          0% {
            background-position: -200% 0;
          }
          100% {
            background-position: 200% 0;
          }
        }
        
        /* Responsive Design */
        @media (max-width: 1024px) {
          .auth-main-card {
            grid-template-columns: 1fr;
            max-width: 600px;
            min-height: auto;
          }
          
          .auth-image-section {
            min-height: 300px;
            border-radius: 1.5rem 1.5rem 0 0;
            padding: 2rem;
          }
          
          .auth-form-section {
            padding: 2rem;
            border-radius: 0 0 1.5rem 1.5rem;
          }
        }
        
        @media (max-width: 768px) {
          .auth-form-section {
            padding: 1.5rem;
          }
          
          .auth-card {
            padding: 2rem;
            max-width: 100%;
          }
          
          .welcome-content {
            padding: 2rem;
          }
          
          .welcome-title {
            font-size: 2rem;
          }
          
          .welcome-subtitle {
            font-size: 1.1rem;
          }
          
          .welcome-description {
            font-size: 0.95rem;
          }
          
          .auth-title {
            font-size: 1.75rem;
          }
          
          .form-input {
            padding: 0.875rem 1rem;
          }
          
          .auth-btn {
            padding: 0.875rem 1.25rem;
          }
        }
        
        @media (max-width: 480px) {
          .auth-form-section {
            padding: 1rem;
          }
          
          .auth-card {
            padding: 1.5rem;
            border-radius: 1.5rem;
          }
          
          .welcome-content {
            padding: 1.5rem;
          }
          
          .welcome-title {
            font-size: 1.75rem;
          }
          
          .welcome-subtitle {
            font-size: 1rem;
          }
          
          .welcome-description {
            font-size: 0.9rem;
          }
          
          .auth-title {
            font-size: 1.5rem;
          }
          
          .carousel-indicators {
            bottom: 1rem;
            gap: 0.5rem;
          }
          
          .indicator {
            width: 10px;
            height: 10px;
          }
        }
      "))
    ),
    
    # Main Card Container
    div(
      class = "auth-main-card",
      
      # Left Side - Single Image
      div(
        class = "auth-image-section"
      ),
      
      # Right Side - Forms
      div(
        class = "auth-form-section",
        
        # Login Form
        div(
          id = ns("login_form"),
          class = "auth-card",
          
          # Language Switcher
          div(
            class = "language-switcher",
            id = ns("lang_switcher"),
            tags$button(
              class = "lang-switcher-btn",
              id = ns("lang_btn"),
              tags$img(src = "en.png", alt = "English", class = "lang-flag"),
              tags$span(id = ns("current_lang"), "English"),
              tags$span(class = "lang-arrow", "▼")
            ),
            div(
              class = "lang-dropdown",
              id = ns("lang_dropdown"),
              tags$a(
                href = "#",
                class = "lang-option active",
                id = ns("lang_en"),
                tags$img(src = "en.png", alt = "English", class = "lang-flag"),
                "English"
              ),
              tags$a(
                href = "#",
                class = "lang-option",
                id = ns("lang_rw"),
                tags$img(src = "rw.png", alt = "Kinyarwanda", class = "lang-flag"),
                "Kinyarwanda"
              )
            )
          ),
          
          div(
            class = "auth-header",
            tags$img(src = "baho_logo.png", alt = "Baho Logo", class = "auth-logo"),
            tags$h1(class = "auth-title", id = ns("login_title"), "Sign In"),
            tags$p(class = "auth-subtitle", id = ns("login_subtitle"), "Enter your credentials to access your account")
          ),
      
          div(
            class = "auth-form",
            
            # Error/Success messages
            div(id = ns("login_message"), style = "display: none;"),
            
            # Email input
            div(
              class = "form-group",
              tags$label(class = "form-label", id = ns("email_label"), "Email"),
              textInput(
                inputId = ns("login_email"),
                label = NULL,
                placeholder = "Enter your email"
              ) %>% 
                tagAppendAttributes(class = "form-input")
            ),
            
            # Password input
            div(
              class = "form-group",
              tags$label(class = "form-label", id = ns("password_label"), "Password"),
              passwordInput(
                inputId = ns("login_password"),
                label = NULL,
                placeholder = "Enter your password"
              ) %>% 
                tagAppendAttributes(class = "form-input")
            ),
            
            # Login button
            actionButton(
              inputId = ns("login_btn"),
              label = tags$span(
                id = ns("login_btn_text"),
                "Sign In"
              ),
              class = "auth-btn"
            )
          ),
          
          # Switch to signup
          div(
            class = "auth-switch",
            tags$span(id = ns("no_account_text"), "Don't have an account? "),
            tags$a(
              href = "#",
              id = ns("switch_to_signup"),
              tags$span(id = ns("signup_link_text"), "Sign Up")
            )
          )
        ),
        
        # Signup Form
        div(
          id = ns("signup_form"),
          class = "auth-card",
          style = "display: none;",
          
          # Language Switcher (duplicate for signup)
          div(
            class = "language-switcher",
            id = ns("lang_switcher_signup"),
            tags$button(
              class = "lang-switcher-btn",
              id = ns("lang_btn_signup"),
              tags$img(src = "en.png", alt = "English", class = "lang-flag"),
              tags$span(id = ns("current_lang_signup"), "English"),
              tags$span(class = "lang-arrow", "▼")
            ),
            div(
              class = "lang-dropdown",
              id = ns("lang_dropdown_signup"),
              tags$a(
                href = "#",
                class = "lang-option active",
                id = ns("lang_en_signup"),
                tags$img(src = "en.png", alt = "English", class = "lang-flag"),
                "English"
              ),
              tags$a(
                href = "#",
                class = "lang-option",
                id = ns("lang_rw_signup"),
                tags$img(src = "rw.png", alt = "Kinyarwanda", class = "lang-flag"),
                "Kinyarwanda"
              )
            )
          ),
          
          div(
            class = "auth-header",
            tags$img(src = "baho_logo.png", alt = "Baho Logo", class = "auth-logo"),
            tags$h1(class = "auth-title", id = ns("signup_title"), "Sign Up"),
            tags$p(class = "auth-subtitle", id = ns("signup_subtitle"), "Create your account to get started")
          ),
          
          div(
            class = "auth-form",
            
            # Error/Success messages
            div(id = ns("signup_message"), style = "display: none;"),
            
            # Name input
            div(
              class = "form-group",
              tags$label(class = "form-label", id = ns("name_label"), "Full Name"),
              textInput(
                inputId = ns("signup_name"),
                label = NULL,
                placeholder = "Enter your full name"
              ) %>% 
                tagAppendAttributes(class = "form-input")
            ),
            
            # Email input
            div(
              class = "form-group",
              tags$label(class = "form-label", id = ns("signup_email_label"), "Email"),
              textInput(
                inputId = ns("signup_email"),
                label = NULL,
                placeholder = "Enter your email"
              ) %>% 
                tagAppendAttributes(class = "form-input")
            ),
            
            # Phone input
            div(
              class = "form-group",
              tags$label(class = "form-label", id = ns("phone_label"), "Phone Number"),
              textInput(
                inputId = ns("signup_phone"),
                label = NULL,
                placeholder = "+250788123456"
              ) %>% 
                tagAppendAttributes(class = "form-input")
            ),
            
            # Location input
            div(
              class = "form-group",
              tags$label(class = "form-label", id = ns("location_label"), "Location"),
              textInput(
                inputId = ns("signup_location"),
                label = NULL,
                placeholder = "Kigali, Rwanda"
              ) %>% 
                tagAppendAttributes(class = "form-input")
            ),
            
            # Password input
            div(
              class = "form-group",
              tags$label(class = "form-label", id = ns("signup_password_label"), "Password"),
              passwordInput(
                inputId = ns("signup_password"),
                label = NULL,
                placeholder = "Enter your password"
              ) %>% 
                tagAppendAttributes(class = "form-input")
            ),
            
            # Confirm password input
            div(
              class = "form-group",
              tags$label(class = "form-label", id = ns("confirm_password_label"), "Confirm Password"),
              passwordInput(
                inputId = ns("signup_confirm_password"),
                label = NULL,
                placeholder = "Confirm your password"
              ) %>% 
                tagAppendAttributes(class = "form-input")
            ),
            
            # Signup button
            actionButton(
              inputId = ns("signup_btn"),
              label = tags$span(
                id = ns("signup_btn_text"),
                "Sign Up"
              ),
              class = "auth-btn"
            )
          ),
          
          # Switch to login
          div(
            class = "auth-switch",
            tags$span(id = ns("have_account_text"), "Already have an account? "),
            tags$a(
              href = "#",
              id = ns("switch_to_login"),
              tags$span(id = ns("login_link_text"), "Sign In")
            )
          )
        )
      )
    ),
    
    # JavaScript for form switching, validation, and image carousel
    tags$script(HTML(paste0("
      $(document).ready(function() {
        
        // Language switching functionality
        let currentLanguage = 'en';
        
        const translations = {
          en: {
            login_title: 'Sign In',
            login_subtitle: 'Enter your credentials to access your account',
            signup_title: 'Sign Up',
            signup_subtitle: 'Create your account to get started',
            email_label: 'Email',
            password_label: 'Password',
            name_label: 'Full Name',
            phone_label: 'Phone Number',
            location_label: 'Location',
            confirm_password_label: 'Confirm Password',
            login_btn: 'Sign In',
            signup_btn: 'Sign Up',
            no_account_text: 'Don\\'t have an account? ',
            signup_link_text: 'Sign Up',
            have_account_text: 'Already have an account? ',
            login_link_text: 'Sign In',
            email_placeholder: 'Enter your email',
            password_placeholder: 'Enter your password',
            name_placeholder: 'Enter your full name',
            phone_placeholder: '+250788123456',
            location_placeholder: 'Kigali, Rwanda',
            confirm_password_placeholder: 'Confirm your password'
          },
          rw: {
            login_title: 'Injira',
            login_subtitle: 'Shyiramo amakuru yawe yo kwinjira',
            signup_title: 'Kwiyandikisha',
            signup_subtitle: 'Kontana na Baho kugira ngo ufashwe',
            email_label: 'Imeli',
            password_label: 'Ijambo ry\\'ibanga',
            name_label: 'Amazina',
            phone_label: 'Telefone',
            location_label: 'Aho utuye',
            confirm_password_label: 'Emeza ijambo ry\\'ibanga',
            login_btn: 'Injira',
            signup_btn: 'Kwiyandikisha',
            no_account_text: 'Nta konti ufite? ',
            signup_link_text: 'Kwiyandikisha',
            have_account_text: 'Ufite konti? ',
            login_link_text: 'Injira',
            email_placeholder: 'shyiramo imeli yawe',
            password_placeholder: 'shyiramo ijambo ry\\'ibanga',
            name_placeholder: 'shyiramo amazina yawe',
            phone_placeholder: '+250788123456',
            location_placeholder: 'Kigali, Rwanda',
            confirm_password_placeholder: 'emeza ijambo ry\\'ibanga'
          }
        };
        
        function updateLanguage(lang) {
          currentLanguage = lang;
          const t = translations[lang];
          
          // Update all text elements
          $('#", ns("login_title"), "').text(t.login_title);
          $('#", ns("login_subtitle"), "').text(t.login_subtitle);
          $('#", ns("signup_title"), "').text(t.signup_title);
          $('#", ns("signup_subtitle"), "').text(t.signup_subtitle);
          $('#", ns("email_label"), "').text(t.email_label);
          $('#", ns("password_label"), "').text(t.password_label);
          $('#", ns("name_label"), "').text(t.name_label);
          $('#", ns("phone_label"), "').text(t.phone_label);
          $('#", ns("location_label"), "').text(t.location_label);
          $('#", ns("confirm_password_label"), "').text(t.confirm_password_label);
          $('#", ns("login_btn_text"), "').text(t.login_btn);
          $('#", ns("signup_btn_text"), "').text(t.signup_btn);
          $('#", ns("no_account_text"), "').text(t.no_account_text);
          $('#", ns("signup_link_text"), "').text(t.signup_link_text);
          $('#", ns("have_account_text"), "').text(t.have_account_text);
          $('#", ns("login_link_text"), "').text(t.login_link_text);
          
          // Update placeholders
          $('#", ns("login_email"), "').attr('placeholder', t.email_placeholder);
          $('#", ns("login_password"), "').attr('placeholder', t.password_placeholder);
          $('#", ns("signup_name"), "').attr('placeholder', t.name_placeholder);
          $('#", ns("signup_email"), "').attr('placeholder', t.email_placeholder);
          $('#", ns("signup_phone"), "').attr('placeholder', t.phone_placeholder);
          $('#", ns("signup_location"), "').attr('placeholder', t.location_placeholder);
          $('#", ns("signup_password"), "').attr('placeholder', t.password_placeholder);
          $('#", ns("signup_confirm_password"), "').attr('placeholder', t.confirm_password_placeholder);
          
          // Update language switcher buttons
          const flagSrc = lang === 'en' ? 'en.png' : 'rw.png';
          const langText = lang === 'en' ? 'English' : 'Kinyarwanda';
          
          $('#", ns("current_lang"), "').text(langText);
          $('#", ns("lang_btn"), " img').attr('src', flagSrc);
          $('#", ns("current_lang_signup"), "').text(langText);
          $('#", ns("lang_btn_signup"), " img').attr('src', flagSrc);
          
          // Update active states
          $('.lang-option').removeClass('active');
          if (lang === 'en') {
            $('#", ns("lang_en"), "').addClass('active');
            $('#", ns("lang_en_signup"), "').addClass('active');
          } else {
            $('#", ns("lang_rw"), "').addClass('active');
            $('#", ns("lang_rw_signup"), "').addClass('active');
          }
        }
        
        // Language switcher functionality
        function initLanguageSwitcher() {
          // Toggle dropdown
          $('#", ns("lang_btn"), ", #", ns("lang_btn_signup"), "').click(function(e) {
            e.preventDefault();
            const switcher = $(this).closest('.language-switcher');
            const dropdown = switcher.find('.lang-dropdown');
            
            // Close other dropdowns
            $('.lang-dropdown').removeClass('active');
            $('.language-switcher').removeClass('active');
            
            // Toggle current dropdown
            dropdown.toggleClass('active');
            switcher.toggleClass('active');
          });
          
          // Handle language selection
          $('#", ns("lang_en"), ", #", ns("lang_rw"), ", #", ns("lang_en_signup"), ", #", ns("lang_rw_signup"), "').click(function(e) {
            e.preventDefault();
            const lang = $(this).attr('id').includes('en') ? 'en' : 'rw';
            updateLanguage(lang);
            
            // Close all dropdowns
            $('.lang-dropdown').removeClass('active');
            $('.language-switcher').removeClass('active');
          });
          
          // Close dropdown when clicking outside
          $(document).click(function(e) {
            if (!$(e.target).closest('.language-switcher').length) {
              $('.lang-dropdown').removeClass('active');
              $('.language-switcher').removeClass('active');
            }
          });
        }
        
        // Initialize language switcher
        initLanguageSwitcher();
        
        // Switch between login and signup forms
        $('#", ns("switch_to_signup"), "').click(function(e) {
          e.preventDefault();
          $('#", ns("login_form"), "').hide();
          $('#", ns("signup_form"), "').show();
        });
        
        $('#", ns("switch_to_login"), "').click(function(e) {
          e.preventDefault();
          $('#", ns("signup_form"), "').hide();
          $('#", ns("login_form"), "').show();
        });
        
        // Form validation
        function validateEmail(email) {
          return /^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$/.test(email);
        }
        
        function validatePhone(phone) {
          return /^\\+250[0-9]{9}$/.test(phone);
        }
        
        // Enhanced form validation with glassy effects
        function validateInput(input, validator, errorClass = 'border-red-500') {
          const value = input.val();
          const isValid = validator(value);
          
          if (value && !isValid) {
            input.css({
              'border-color': '#DC2626',
              'box-shadow': '0 0 0 4px rgba(220, 38, 38, 0.1)'
            });
            input.addClass('shake');
            setTimeout(() => input.removeClass('shake'), 500);
          } else {
            input.css({
              'border-color': 'rgba(43, 122, 155, 0.1)',
              'box-shadow': '0 0 0 4px rgba(43, 122, 155, 0.1)'
            });
          }
        }
        
        // Add shake animation
        $('<style>')
          .prop('type', 'text/css')
          .html(`
            .shake {
              animation: shake 0.5s ease-in-out;
            }
            @keyframes shake {
              0%, 100% { transform: translateX(0); }
              25% { transform: translateX(-5px); }
              75% { transform: translateX(5px); }
            }
          `)
          .appendTo('head');
        
        // Login form validation
        $('#", ns("login_email"), "').on('blur', function() {
          validateInput($(this), validateEmail);
        });
        
        $('#", ns("login_password"), "').on('blur', function() {
          const password = $(this).val();
          if (password && password.length < 6) {
            $(this).css({
              'border-color': '#DC2626',
              'box-shadow': '0 0 0 4px rgba(220, 38, 38, 0.1)'
            });
          } else {
            $(this).css({
              'border-color': 'rgba(43, 122, 155, 0.1)',
              'box-shadow': '0 0 0 4px rgba(43, 122, 155, 0.1)'
            });
          }
        });
        
        // Signup form validation
        $('#", ns("signup_email"), "').on('blur', function() {
          validateInput($(this), validateEmail);
        });
        
        $('#", ns("signup_phone"), "').on('blur', function() {
          validateInput($(this), validatePhone);
        });
        
        $('#", ns("signup_confirm_password"), "').on('blur', function() {
          const password = $('#", ns("signup_password"), "').val();
          const confirmPassword = $(this).val();
          
          if (confirmPassword && password !== confirmPassword) {
            $(this).css({
              'border-color': '#DC2626',
              'box-shadow': '0 0 0 4px rgba(220, 38, 38, 0.1)'
            });
            $(this).addClass('shake');
            setTimeout(() => $(this).removeClass('shake'), 500);
          } else {
            $(this).css({
              'border-color': 'rgba(43, 122, 155, 0.1)',
              'box-shadow': '0 0 0 4px rgba(43, 122, 155, 0.1)'
            });
          }
        });
        
        // Add focus effects
        $('.form-input').on('focus', function() {
          $(this).css({
            'transform': 'translateY(-2px)',
            'box-shadow': '0 8px 25px rgba(43, 122, 155, 0.15)'
          });
        }).on('blur', function() {
          $(this).css('transform', 'translateY(0)');
        });
      });
    ")))
  )
}

# Authentication Server Module
authServer <- function(id, navigate_to_chat = NULL, navigate_to_home = NULL) {
  moduleServer(id, function(input, output, session) {
    
    # Initialize database connection
    db_conn <- NULL
    current_user <- reactiveVal(NULL)
    login_in_progress <- FALSE
    
    # Function to get or create database connection
    get_db_connection <- function() {
      if (is.null(db_conn)) {
        tryCatch({
          db_conn <<- db_connect()
          if (!is.null(db_conn)) {
            cat("✅ Auth: Database connection successful!\n")
            
            # Test the connection
            test_query <- "SELECT 1 as test"
            test_result <- dbGetQuery(db_conn, test_query)
            if (nrow(test_result) > 0) {
              cat("✅ Auth: Database connection test successful!\n")
            } else {
              cat("❌ Auth: Database connection test failed\n")
              db_conn <<- NULL
            }
          } else {
            cat("❌ Auth: Database connection is NULL\n")
          }
        }, error = function(e) {
          cat("❌ Auth: Database connection failed:", e$message, "\n")
          db_conn <<- NULL
        })
      }
      return(db_conn)
    }
    
    # Show message function
    show_message <- function(message, type = "error", form = "login") {
      message_id <- paste0(form, "_message")
      message_html <- paste0('<div class="', type, '-message">', message, '</div>')
      shinyjs::html(message_id, message_html)
      shinyjs::show(message_id)
      
      # Hide message after 5 seconds
      shinyjs::delay(5000, shinyjs::hide(message_id))
    }
    
    # Set loading state
    set_loading <- function(btn_id, loading = TRUE) {
      if (loading) {
        shinyjs::html(btn_id, '<span class="loading-spinner"></span>')
        shinyjs::disable(btn_id)
      } else {
        shinyjs::html(btn_id, ifelse(grepl("login", btn_id), "Injira", "Kwiyandikisha"))
        shinyjs::enable(btn_id)
      }
    }
    
    # Login functionality
    observeEvent(input$login_btn, {
      # Prevent multiple clicks
      if (login_in_progress) {
        cat("⚠️ Login already in progress, ignoring click\n")
        return()
      }
      
      login_in_progress <<- TRUE
      
      email <- trimws(input$login_email)
      password <- input$login_password
      
      cat("🔐 Login attempt for:", email, "\n")
      
      # Validation
      if (email == "" || password == "") {
        show_message("Nyamuneka shyira imeli n'ijambo ry'ibanga", "error", "login")
        return()
      }
      
      if (!grepl("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$", email)) {
        show_message("Imeli ntabwo yemewe", "error", "login")
        return()
      }
      
      # Set loading state
      set_loading("login_btn_text", TRUE)
      
      # Check credentials in database
      tryCatch({
        db_conn <- get_db_connection()
        if (is.null(db_conn)) {
          show_message("Sisiteme ntabwo ikora. Nyamuneka gerageza nanone", "error", "login")
          set_loading("login_btn_text", FALSE)
          return()
        }
        
        # Use proper password verification
        auth_result <- db_functions$authenticate_user(db_conn, email, password)
        
        if (nrow(auth_result) > 0) {
          current_user(auth_result[1, ])
          cat("✅ User logged in:", current_user()$username, "\n")
          
          # Reset loading state
          set_loading("login_btn_text", FALSE)
          login_in_progress <<- FALSE
          
          # Navigate to chat
          cat("🚀 Triggering navigation to chat...\n")
          if (!is.null(navigate_to_chat)) {
            navigate_to_chat(navigate_to_chat() + 1)
          } else {
            # Fallback to custom message
            session$sendCustomMessage("navigateToChat", list(
              user_id = current_user$user_id,
              username = current_user$username
            ))
          }
          
        } else {
          show_message("Imeli cyangwa ijambo ry'ibanga ntabwo byemewe", "error", "login")
          set_loading("login_btn_text", FALSE)
          login_in_progress <<- FALSE
        }
        
      }, error = function(e) {
        cat("❌ Login error:", e$message, "\n")
        show_message("Habayeho ikibazo. Nyamuneka gerageza nanone", "error", "login")
        set_loading("login_btn_text", FALSE)
        login_in_progress <<- FALSE
      })
    })
    
    # Signup functionality
    observeEvent(input$signup_btn, {
      name <- trimws(input$signup_name)
      email <- trimws(input$signup_email)
      phone <- trimws(input$signup_phone)
      location <- trimws(input$signup_location)
      password <- input$signup_password
      confirm_password <- input$signup_confirm_password
      
      # Validation
      if (name == "" || email == "" || phone == "" || location == "" || password == "") {
        show_message("Nyamuneka shyira amakuru yose", "error", "signup")
        return()
      }
      
      if (!grepl("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$", email)) {
        show_message("Imeli ntabwo yemewe", "error", "signup")
        return()
      }
      
      if (!grepl("^\\+250[0-9]{9}$", phone)) {
        show_message("Numero ya telefone ntabwo yemewe. Shyiramo nk'uko: +250788123456", "error", "signup")
        return()
      }
      
      if (password != confirm_password) {
        show_message("Amajambo y'ibanga ntabwo ari kimwe", "error", "signup")
        return()
      }
      
      if (nchar(password) < 6) {
        show_message("Ijambo ry'ibanga rigomba kuba rifite imibare 6 byibuze", "error", "signup")
        return()
      }
      
      # Set loading state
      set_loading("signup_btn_text", TRUE)
      
      # Check if user already exists
      tryCatch({
        db_conn <- get_db_connection()
        if (is.null(db_conn)) {
          show_message("Sisiteme ntabwo ikora. Nyamuneka gerageza nanone", "error", "signup")
          set_loading("signup_btn_text", FALSE)
          return()
        }
        
        query <- "SELECT user_id FROM users WHERE email = $1"
        existing_user <- dbGetQuery(db_conn, query, params = list(email))
        
        if (nrow(existing_user) > 0) {
          show_message("Konti yarimo. Nyamuneka injira", "error", "signup")
          set_loading("signup_btn_text", FALSE)
          return()
        }
        
        # Create new user
        user_id <- db_functions$create_user(db_conn, name, email, phone, location, password)
        
        if (!is.null(user_id)) {
          # Get the created user
          query <- "SELECT * FROM users WHERE user_id = $1"
          new_user <- dbGetQuery(db_conn, query, params = list(user_id))
          current_user(new_user[1, ])
          
          cat("✅ New user created:", current_user()$username, "\n")
          
          # Reset loading state
          set_loading("signup_btn_text", FALSE)
          
          show_message("Konti yashyizweho neza! Murakaza neza!", "success", "signup")
          
          # Navigate to chat immediately
          cat("🚀 Triggering navigation to chat after signup...\n")
          if (!is.null(navigate_to_chat)) {
            navigate_to_chat(navigate_to_chat() + 1)
          } else {
            # Fallback to custom message
            session$sendCustomMessage("navigateToChat", list(
              user_id = current_user$user_id,
              username = current_user$username
            ))
          }
          
        } else {
          show_message("Habayeho ikibazo mu gushyiraho konti. Nyamuneka gerageza nanone", "error", "signup")
          set_loading("signup_btn_text", FALSE)
        }
        
      }, error = function(e) {
        cat("❌ Signup error:", e$message, "\n")
        show_message("Habayeho ikibazo. Nyamuneka gerageza nanone", "error", "signup")
        set_loading("signup_btn_text", FALSE)
      })
    })
    
    # Return current user for other modules
    return(list(
      get_current_user = reactive({ current_user() }),
      get_db_conn = function() get_db_connection()
    ))
    
    # Clean up on session end
    onStop(function() {
      if (!is.null(db_conn)) {
        dbDisconnect(db_conn)
        cat("✅ Auth: Database connection closed\n")
      }
    })
  })
}
