# ===== 9 MONTHS WITH BAHO - PREGNANCY PROGRAM MODULE =====

# UI Function
pregnancyProgramUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Include CSS
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "pregnancy-program-styles.css")
    ),
    
    # Main Container
    tags$div(
      class = "pregnancy-program-container",
      id = ns("pregnancy_container"),
      
      # Back Button
      actionButton(
        inputId = ns("back_to_programs"),
        label = tags$span(
          tags$i(class = "fas fa-arrow-left"),
          "Back to Programs"
        ),
        class = "program-back-btn"
      ),
      
      # Program Header
      tags$div(
        class = "pregnancy-program-header",
        tags$h1(class = "pregnancy-program-title", "9 Months with Baho"),
        tags$p(
          class = "pregnancy-program-subtitle",
          "Welcome to your personalized pregnancy journey! We'll guide you through every step of these precious 9 months with expert care, monitoring, and support."
        )
      ),
      
      # Enrollment Steps Container
      tags$div(
        class = "enrollment-steps-container",
        
        # Step Progress Indicator
        tags$div(
          class = "step-progress",
          id = ns("step_progress"),
          
          # Step 1
          tags$div(
            class = "step-item active",
            `data-step` = "1",
            tags$div(class = "step-circle", "1"),
            tags$div(class = "step-label", "Personal Info")
          ),
          
          # Step 2
          tags$div(
            class = "step-item",
            `data-step` = "2",
            tags$div(class = "step-circle", "2"),
            tags$div(class = "step-label", "Pregnancy Details")
          ),
          
          # Step 3
          tags$div(
            class = "step-item",
            `data-step` = "3",
            tags$div(class = "step-circle", "3"),
            tags$div(class = "step-label", "Medical History")
          ),
          
          # Step 4
          tags$div(
            class = "step-item",
            `data-step` = "4",
            tags$div(class = "step-circle", "4"),
            tags$div(class = "step-label", "Health Goals")
          )
        ),
        
        # Step 1: Personal Information
        tags$div(
          class = "step-content-card",
          id = ns("step1_content"),
          
          tags$h2(class = "step-content-title", "Let's Get to Know You"),
          tags$p(class = "step-content-description", 
            "Please provide your basic information so we can personalize your pregnancy journey."
          ),
          
          # Info Cards
          tags$div(
            class = "info-cards-grid",
            
            tags$div(
              class = "info-card",
              tags$div(
                class = "info-card-icon",
                tags$i(class = "fas fa-shield-heart")
              ),
              tags$div(class = "info-card-title", "Privacy First"),
              tags$div(class = "info-card-text", "Your data is secure and confidential")
            ),
            
            tags$div(
              class = "info-card",
              tags$div(
                class = "info-card-icon",
                tags$i(class = "fas fa-user-doctor")
              ),
              tags$div(class = "info-card-title", "Expert Care"),
              tags$div(class = "info-card-text", "Guidance from healthcare professionals")
            ),
            
            tags$div(
              class = "info-card",
              tags$div(
                class = "info-card-icon",
                tags$i(class = "fas fa-clock")
              ),
              tags$div(class = "info-card-title", "24/7 Support"),
              tags$div(class = "info-card-text", "We're here whenever you need us")
            )
          ),
          
          # Form Fields
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-user"),
                "Full Name",
                tags$span(class = "required", "*")
              ),
              textInput(
                inputId = ns("full_name"),
                label = NULL,
                placeholder = "Enter your full name"
              )
            ),
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-calendar"),
                "Date of Birth",
                tags$span(class = "required", "*")
              ),
              dateInput(
                inputId = ns("date_of_birth"),
                label = NULL,
                format = "yyyy-mm-dd",
                max = Sys.Date()
              )
            )
          ),
          
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-phone"),
                "Phone Number",
                tags$span(class = "required", "*")
              ),
              textInput(
                inputId = ns("phone"),
                label = NULL,
                placeholder = "+250 XXX XXX XXX"
              )
            ),
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-envelope"),
                "Email Address"
              ),
              textInput(
                inputId = ns("email"),
                label = NULL,
                placeholder = "your.email@example.com"
              )
            )
          ),
          
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group full-width",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-map-marker-alt"),
                "Address",
                tags$span(class = "required", "*")
              ),
              textInput(
                inputId = ns("address"),
                label = NULL,
                placeholder = "Sector, District, Province"
              )
            )
          ),
          
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-user-friends"),
                "Emergency Contact Name",
                tags$span(class = "required", "*")
              ),
              textInput(
                inputId = ns("emergency_name"),
                label = NULL,
                placeholder = "Contact person name"
              )
            ),
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-phone"),
                "Emergency Contact Phone",
                tags$span(class = "required", "*")
              ),
              textInput(
                inputId = ns("emergency_phone"),
                label = NULL,
                placeholder = "+250 XXX XXX XXX"
              )
            )
          ),
          
          # Actions
          tags$div(
            class = "step-actions",
            tags$div(),  # Empty div for spacing
            actionButton(
              inputId = ns("next_step1"),
              label = tags$span(
                "Next: Pregnancy Details",
                tags$i(class = "fas fa-arrow-right")
              ),
              class = "btn-primary"
            )
          )
        ),
        
        # Step 2: Pregnancy Details (Initially Hidden)
        tags$div(
          class = "step-content-card",
          id = ns("step2_content"),
          style = "display: none;",
          
          tags$h2(class = "step-content-title", "Your Pregnancy Journey"),
          tags$p(class = "step-content-description", 
            "Tell us about your pregnancy so we can provide the most accurate tracking and support."
          ),
          
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-calendar-check"),
                "Last Menstrual Period (LMP)",
                tags$span(class = "required", "*")
              ),
              dateInput(
                inputId = ns("lmp_date"),
                label = NULL,
                format = "yyyy-mm-dd",
                max = Sys.Date()
              ),
              tags$div(class = "form-hint", "First day of your last period")
            ),
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-baby"),
                "Expected Due Date"
              ),
              dateInput(
                inputId = ns("due_date"),
                label = NULL,
                format = "yyyy-mm-dd",
                min = Sys.Date()
              ),
              tags$div(class = "form-hint", "Calculated automatically from LMP")
            )
          ),
          
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-hashtag"),
                "Number of Pregnancies",
                tags$span(class = "required", "*")
              ),
              selectInput(
                inputId = ns("num_pregnancies"),
                label = NULL,
                choices = c("First pregnancy" = "1", "2", "3", "4", "5+")
              )
            ),
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-heart"),
                "Number of Live Births",
                tags$span(class = "required", "*")
              ),
              selectInput(
                inputId = ns("num_births"),
                label = NULL,
                choices = c("None" = "0", "1", "2", "3", "4", "5+")
              )
            )
          ),
          
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-weight-scale"),
                "Pre-Pregnancy Weight (kg)",
                tags$span(class = "required", "*")
              ),
              numericInput(
                inputId = ns("pre_pregnancy_weight"),
                label = NULL,
                value = NULL,
                min = 30,
                max = 200,
                step = 0.1
              )
            ),
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-ruler-vertical"),
                "Height (cm)",
                tags$span(class = "required", "*")
              ),
              numericInput(
                inputId = ns("height"),
                label = NULL,
                value = NULL,
                min = 100,
                max = 220,
                step = 1
              )
            )
          ),
          
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-droplet"),
                "Blood Type"
              ),
              selectInput(
                inputId = ns("blood_type"),
                label = NULL,
                choices = c("Not sure" = "", "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")
              )
            ),
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-hospital"),
                "Preferred Health Facility"
              ),
              textInput(
                inputId = ns("health_facility"),
                label = NULL,
                placeholder = "Hospital or Health Center name"
              )
            )
          ),
          
          # Actions
          tags$div(
            class = "step-actions",
            actionButton(
              inputId = ns("prev_step2"),
              label = tags$span(
                tags$i(class = "fas fa-arrow-left"),
                "Previous"
              ),
              class = "btn-secondary"
            ),
            actionButton(
              inputId = ns("next_step2"),
              label = tags$span(
                "Next: Medical History",
                tags$i(class = "fas fa-arrow-right")
              ),
              class = "btn-primary"
            )
          )
        ),
        
        # Step 3: Medical History (Initially Hidden)
        tags$div(
          class = "step-content-card",
          id = ns("step3_content"),
          style = "display: none;",
          
          tags$h2(class = "step-content-title", "Medical History"),
          tags$p(class = "step-content-description", 
            "Understanding your medical background helps us provide better care and identify any potential risks early."
          ),
          
          # Pre-existing Conditions
          tags$div(
            class = "form-group full-width",
            tags$label(
              class = "form-label",
              tags$i(class = "fas fa-notes-medical"),
              "Do you have any pre-existing medical conditions?"
            ),
            tags$div(
              class = "checkbox-group",
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("condition_diabetes"), label = NULL, value = FALSE),
                tags$label(class = "checkbox-label", `for` = ns("condition_diabetes"), "Diabetes")
              ),
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("condition_hypertension"), label = NULL, value = FALSE),
                tags$label(class = "checkbox-label", `for` = ns("condition_hypertension"), "High Blood Pressure")
              ),
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("condition_asthma"), label = NULL, value = FALSE),
                tags$label(class = "checkbox-label", `for` = ns("condition_asthma"), "Asthma")
              ),
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("condition_heart"), label = NULL, value = FALSE),
                tags$label(class = "checkbox-label", `for` = ns("condition_heart"), "Heart Disease")
              ),
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("condition_thyroid"), label = NULL, value = FALSE),
                tags$label(class = "checkbox-label", `for` = ns("condition_thyroid"), "Thyroid Problems")
              ),
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("condition_other"), label = NULL, value = FALSE),
                tags$label(class = "checkbox-label", `for` = ns("condition_other"), "Other")
              )
            )
          ),
          
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group full-width",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-pills"),
                "Current Medications"
              ),
              tags$textarea(
                class = "form-textarea",
                id = ns("current_medications"),
                placeholder = "List any medications you're currently taking (including vitamins and supplements)"
              )
            )
          ),
          
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group full-width",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-allergies"),
                "Known Allergies"
              ),
              tags$textarea(
                class = "form-textarea",
                id = ns("allergies"),
                placeholder = "List any allergies (medications, food, environmental)"
              )
            )
          ),
          
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group full-width",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-dna"),
                "Family Medical History"
              ),
              tags$textarea(
                class = "form-textarea",
                id = ns("family_history"),
                placeholder = "Any relevant family medical history (genetic conditions, pregnancy complications, etc.)"
              )
            )
          ),
          
          # Actions
          tags$div(
            class = "step-actions",
            actionButton(
              inputId = ns("prev_step3"),
              label = tags$span(
                tags$i(class = "fas fa-arrow-left"),
                "Previous"
              ),
              class = "btn-secondary"
            ),
            actionButton(
              inputId = ns("next_step3"),
              label = tags$span(
                "Next: Health Goals",
                tags$i(class = "fas fa-arrow-right")
              ),
              class = "btn-primary"
            )
          )
        ),
        
        # Step 4: Health Goals & Preferences (Initially Hidden)
        tags$div(
          class = "step-content-card",
          id = ns("step4_content"),
          style = "display: none;",
          
          tags$h2(class = "step-content-title", "Your Health Goals"),
          tags$p(class = "step-content-description", 
            "Let's personalize your journey based on what matters most to you during this pregnancy."
          ),
          
          # Goals Selection
          tags$div(
            class = "form-group full-width",
            tags$label(
              class = "form-label",
              tags$i(class = "fas fa-bullseye"),
              "What are your main health goals? (Select all that apply)"
            ),
            tags$div(
              class = "checkbox-group",
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("goal_healthy_weight"), label = NULL, value = TRUE),
                tags$label(class = "checkbox-label", `for` = ns("goal_healthy_weight"), "Maintain healthy weight gain")
              ),
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("goal_nutrition"), label = NULL, value = TRUE),
                tags$label(class = "checkbox-label", `for` = ns("goal_nutrition"), "Follow proper nutrition")
              ),
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("goal_exercise"), label = NULL, value = FALSE),
                tags$label(class = "checkbox-label", `for` = ns("goal_exercise"), "Stay physically active")
              ),
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("goal_stress"), label = NULL, value = FALSE),
                tags$label(class = "checkbox-label", `for` = ns("goal_stress"), "Manage stress and mental health")
              ),
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("goal_education"), label = NULL, value = TRUE),
                tags$label(class = "checkbox-label", `for` = ns("goal_education"), "Learn about pregnancy and childbirth")
              ),
              
              tags$div(
                class = "checkbox-item",
                checkboxInput(ns("goal_track"), label = NULL, value = TRUE),
                tags$label(class = "checkbox-label", `for` = ns("goal_track"), "Track baby's development")
              )
            )
          ),
          
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group full-width",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-comment-dots"),
                "Any specific concerns or questions?"
              ),
              tags$textarea(
                class = "form-textarea",
                id = ns("concerns"),
                placeholder = "Share any concerns, questions, or special needs you have"
              )
            )
          ),
          
          # Notification Preferences
          tags$div(
            class = "form-row",
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-bell"),
                "Reminder Frequency"
              ),
              selectInput(
                inputId = ns("reminder_frequency"),
                label = NULL,
                choices = c(
                  "Daily" = "daily",
                  "Every other day" = "alternate",
                  "Weekly" = "weekly",
                  "Only for appointments" = "appointments"
                ),
                selected = "daily"
              )
            ),
            
            tags$div(
              class = "form-group",
              tags$label(
                class = "form-label",
                tags$i(class = "fas fa-language"),
                "Preferred Language"
              ),
              selectInput(
                inputId = ns("preferred_language"),
                label = NULL,
                choices = c("English" = "en", "Kinyarwanda" = "rw", "French" = "fr"),
                selected = "rw"
              )
            )
          ),
          
          # Actions
          tags$div(
            class = "step-actions",
            actionButton(
              inputId = ns("prev_step4"),
              label = tags$span(
                tags$i(class = "fas fa-arrow-left"),
                "Previous"
              ),
              class = "btn-secondary"
            ),
            actionButton(
              inputId = ns("complete_enrollment"),
              label = tags$span(
                "Complete Enrollment",
                tags$i(class = "fas fa-check")
              ),
              class = "btn-primary"
            )
          )
        ),
        
        # Success Message (Initially Hidden)
        tags$div(
          class = "enrollment-success",
          id = ns("success_content"),
          style = "display: none;",
          
          tags$div(
            class = "success-icon",
            tags$i(class = "fas fa-check")
          ),
          
          tags$h2(class = "success-title", "Welcome to 9 Months with Baho!"),
          
          tags$p(
            class = "success-message",
            "Your enrollment is complete! We're excited to support you throughout your pregnancy journey. Your personalized dashboard is ready with tracking tools, educational resources, and expert guidance."
          ),
          
          actionButton(
            inputId = ns("go_to_dashboard"),
            label = tags$span(
              "Go to My Dashboard",
              tags$i(class = "fas fa-arrow-right")
            ),
            class = "btn-primary"
          )
        )
      )
    )
  )
}

# Server Function
pregnancyProgramServer <- function(id, current_user, db_pool) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive value for current step
    current_step <- reactiveVal(1)
    
    # Navigation: Back to Programs
    observeEvent(input$back_to_programs, {
      session$sendCustomMessage("showHealthPrograms", list())
    })
    
    # Step Navigation: Next buttons
    observeEvent(input$next_step1, {
      # Validate Step 1
      if (is.null(input$full_name) || input$full_name == "" ||
          is.null(input$date_of_birth) ||
          is.null(input$phone) || input$phone == "" ||
          is.null(input$address) || input$address == "" ||
          is.null(input$emergency_name) || input$emergency_name == "" ||
          is.null(input$emergency_phone) || input$emergency_phone == "") {
        
        showNotification("Please fill in all required fields", type = "error")
        return()
      }
      
      # Move to Step 2
      shinyjs::hide("step1_content")
      shinyjs::show("step2_content")
      current_step(2)
      
      # Update progress indicator
      session$sendCustomMessage("updateStepProgress", list(step = 2))
    })
    
    observeEvent(input$next_step2, {
      # Validate Step 2
      if (is.null(input$lmp_date) ||
          is.null(input$num_pregnancies) ||
          is.null(input$num_births) ||
          is.null(input$pre_pregnancy_weight) ||
          is.null(input$height)) {
        
        showNotification("Please fill in all required fields", type = "error")
        return()
      }
      
      # Calculate due date if not provided
      if (is.null(input$due_date) && !is.null(input$lmp_date)) {
        calculated_due_date <- input$lmp_date + 280  # 40 weeks
        updateDateInput(session, "due_date", value = calculated_due_date)
      }
      
      # Move to Step 3
      shinyjs::hide("step2_content")
      shinyjs::show("step3_content")
      current_step(3)
      
      # Update progress indicator
      session$sendCustomMessage("updateStepProgress", list(step = 3))
    })
    
    observeEvent(input$next_step3, {
      # Move to Step 4
      shinyjs::hide("step3_content")
      shinyjs::show("step4_content")
      current_step(4)
      
      # Update progress indicator
      session$sendCustomMessage("updateStepProgress", list(step = 4))
    })
    
    # Step Navigation: Previous buttons
    observeEvent(input$prev_step2, {
      shinyjs::hide("step2_content")
      shinyjs::show("step1_content")
      current_step(1)
      session$sendCustomMessage("updateStepProgress", list(step = 1))
    })
    
    observeEvent(input$prev_step3, {
      shinyjs::hide("step3_content")
      shinyjs::show("step2_content")
      current_step(2)
      session$sendCustomMessage("updateStepProgress", list(step = 2))
    })
    
    observeEvent(input$prev_step4, {
      shinyjs::hide("step4_content")
      shinyjs::show("step3_content")
      current_step(3)
      session$sendCustomMessage("updateStepProgress", list(step = 3))
    })
    
    # Complete Enrollment
    observeEvent(input$complete_enrollment, {
      tryCatch({
        pool <- db_pool()
        if (is.null(pool)) {
          showNotification("Database connection error", type = "error")
          return()
        }
        
        user <- current_user()
        if (is.null(user)) {
          showNotification("User not found", type = "error")
          return()
        }
        
        # Collect medical conditions
        conditions <- c()
        if (input$condition_diabetes) conditions <- c(conditions, "Diabetes")
        if (input$condition_hypertension) conditions <- c(conditions, "Hypertension")
        if (input$condition_asthma) conditions <- c(conditions, "Asthma")
        if (input$condition_heart) conditions <- c(conditions, "Heart Disease")
        if (input$condition_thyroid) conditions <- c(conditions, "Thyroid Problems")
        if (input$condition_other) conditions <- c(conditions, "Other")
        
        # Collect health goals
        goals <- c()
        if (input$goal_healthy_weight) goals <- c(goals, "Healthy Weight")
        if (input$goal_nutrition) goals <- c(goals, "Nutrition")
        if (input$goal_exercise) goals <- c(goals, "Exercise")
        if (input$goal_stress) goals <- c(goals, "Stress Management")
        if (input$goal_education) goals <- c(goals, "Education")
        if (input$goal_track) goals <- c(goals, "Track Development")
        
        # Prepare maternal data
        maternal_data <- list(
          full_name = input$full_name,
          date_of_birth = as.character(input$date_of_birth),
          phone = input$phone,
          email = input$email,
          address = input$address,
          emergency_contact_name = input$emergency_name,
          emergency_contact_phone = input$emergency_phone,
          lmp_date = as.character(input$lmp_date),
          due_date = as.character(input$due_date),
          num_pregnancies = as.integer(input$num_pregnancies),
          num_births = as.integer(input$num_births),
          pre_pregnancy_weight = input$pre_pregnancy_weight,
          height = input$height,
          blood_type = input$blood_type,
          health_facility = input$health_facility,
          medical_conditions = paste(conditions, collapse = ", "),
          current_medications = input$current_medications,
          allergies = input$allergies,
          family_history = input$family_history,
          health_goals = paste(goals, collapse = ", "),
          concerns = input$concerns,
          reminder_frequency = input$reminder_frequency,
          preferred_language = input$preferred_language
        )
        
        # Enroll in program (program_id = 1 for 9 Months with Baho)
        enrollment_id <- db_functions$enroll_in_program(
          pool = pool,
          user_id = user$user_id,
          program_id = 1,
          start_date = Sys.Date(),
          expected_end_date = input$due_date
        )
        
        # Save maternal health data
        db_functions$save_maternal_health_data(
          pool = pool,
          enrollment_id = enrollment_id,
          user_id = user$user_id,
          maternal_data = maternal_data
        )
        
        # Show success message
        shinyjs::hide("step4_content")
        shinyjs::show("success_content")
        
        showNotification("Enrollment completed successfully!", type = "message")
        
      }, error = function(e) {
        cat("ERROR in enrollment:", e$message, "\n")
        showNotification("An error occurred. Please try again.", type = "error")
      })
    })
    
    # Go to Dashboard
    observeEvent(input$go_to_dashboard, {
      cat("📊 Navigating to pregnancy dashboard...\n")
      
      # Show pregnancy dashboard
      session$sendCustomMessage("showPregnancyDashboard", list())
      
      # Show success notification
      showNotification(
        "Welcome to your pregnancy dashboard!", 
        type = "message", 
        duration = 3
      )
    })
    
    # JavaScript for step progress
    observe({
      shinyjs::runjs("
        Shiny.addCustomMessageHandler('updateStepProgress', function(message) {
          const step = message.step;
          const stepItems = document.querySelectorAll('.step-item');
          
          stepItems.forEach((item, index) => {
            const itemStep = index + 1;
            item.classList.remove('active', 'completed');
            
            if (itemStep < step) {
              item.classList.add('completed');
            } else if (itemStep === step) {
              item.classList.add('active');
            }
          });
          
          // Scroll to top
          window.scrollTo({ top: 0, behavior: 'smooth' });
        });
        
        Shiny.addCustomMessageHandler('showHealthPrograms', function(message) {
          // Hide pregnancy program
          const pregnancyContainer = document.querySelector('.pregnancy-program-container');
          if (pregnancyContainer) {
            pregnancyContainer.style.display = 'none';
          }
          
          // Show health programs section
          const programsSection = document.querySelector('.health-programs-section');
          if (programsSection) {
            programsSection.style.display = 'block';
          }
        });
      ")
    })
  })
}

