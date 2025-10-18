# Chronic Disease Enrollment Module (Baho for Life)
# Multi-step enrollment form for chronic disease management program

library(shiny)
library(shinyjs)

chronicDiseaseUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    useShinyjs(),
    
    # Main Container (hidden by default)
    tags$div(
      class = "chronic-disease-container",
      style = "display: none;",
      
      # Back Button
      actionButton(
        inputId = ns("back_to_programs"),
        label = tagList(
          tags$i(class = "fas fa-arrow-left"),
          "Back to Programs"
        ),
        class = "program-back-btn"
      ),
      
      # Enrollment Form Card
      tags$div(
        class = "chronic-enrollment-form",
        
        # Header with Image
        tags$div(
          class = "program-header",
          tags$img(
            src = "chronic.png",
            alt = "Baho for Life",
            class = "program-header-img"
          ),
          tags$h1(class = "program-title", "Baho for Life"),
          tags$p(class = "program-subtitle", 
            "Comprehensive Chronic Disease Management & Wellness Support"
          )
        ),
        
        # Step Progress Indicator
        tags$div(
          class = "step-progress",
          tags$div(class = "step-item active", id = ns("step_indicator_1"),
            tags$div(class = "step-number", "1"),
            tags$div(class = "step-label", "Personal Info")
          ),
          tags$div(class = "step-item", id = ns("step_indicator_2"),
            tags$div(class = "step-number", "2"),
            tags$div(class = "step-label", "Health Conditions")
          ),
          tags$div(class = "step-item", id = ns("step_indicator_3"),
            tags$div(class = "step-number", "3"),
            tags$div(class = "step-label", "Medical History")
          ),
          tags$div(class = "step-item", id = ns("step_indicator_4"),
            tags$div(class = "step-number", "4"),
            tags$div(class = "step-label", "Lifestyle & Confirm")
          )
        ),
        
        # Form Steps
        # STEP 1: Personal Information
        tags$div(
          class = "form-section",
          id = ns("step_1"),
          
          tags$h3(class = "section-title", "Personal Information"),
          tags$p(class = "section-description", "Let's start with your basic information"),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label(class = "form-label", "Full Name *"),
              textInput(
                inputId = ns("full_name"),
                label = NULL,
                placeholder = "Enter your full name",
                width = "100%"
              )
            ),
            tags$div(
              class = "form-group",
              tags$label(class = "form-label", "Date of Birth *"),
              dateInput(
                inputId = ns("date_of_birth"),
                label = NULL,
                value = NULL,
                max = Sys.Date(),
                width = "100%"
              )
            )
          ),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label(class = "form-label", "Gender *"),
              selectInput(
                inputId = ns("gender"),
                label = NULL,
                choices = c("Select Gender" = "", "Male" = "male", "Female" = "female", "Other" = "other"),
                width = "100%"
              )
            ),
            tags$div(
              class = "form-group",
              tags$label(class = "form-label", "Phone Number *"),
              textInput(
                inputId = ns("phone"),
                label = NULL,
                placeholder = "+250 XXX XXX XXX",
                width = "100%"
              )
            )
          ),
          
          tags$h4(class = "subsection-title", "Emergency Contact"),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label(class = "form-label", "Emergency Contact Name"),
              textInput(
                inputId = ns("emergency_contact_name"),
                label = NULL,
                placeholder = "Full name",
                width = "100%"
              )
            ),
            tags$div(
              class = "form-group",
              tags$label(class = "form-label", "Emergency Contact Phone"),
              textInput(
                inputId = ns("emergency_contact_phone"),
                label = NULL,
                placeholder = "+250 XXX XXX XXX",
                width = "100%"
              )
            )
          )
        ),
        
        # STEP 2: Health Conditions
        tags$div(
          class = "form-section",
          id = ns("step_2"),
          style = "display: none;",
          
          tags$h3(class = "section-title", "Health Conditions"),
          tags$p(class = "section-description", "Select all conditions that apply to you"),
          
          tags$div(
            class = "checkbox-group",
            tags$div(
              class = "checkbox-item",
              checkboxInput(
                inputId = ns("has_diabetes"),
                label = tagList(
                  tags$i(class = "fas fa-heartbeat", style = "color: #E74C3C;"),
                  tags$span("Diabetes")
                ),
                value = FALSE,
                width = "100%"
              )
            ),
            tags$div(
              class = "checkbox-item",
              checkboxInput(
                inputId = ns("has_hypertension"),
                label = tagList(
                  tags$i(class = "fas fa-heart-pulse", style = "color: #3498DB;"),
                  tags$span("Hypertension (High Blood Pressure)")
                ),
                value = FALSE,
                width = "100%"
              )
            ),
            tags$div(
              class = "checkbox-item",
              checkboxInput(
                inputId = ns("has_heart_disease"),
                label = tagList(
                  tags$i(class = "fas fa-heart", style = "color: #E74C3C;"),
                  tags$span("Heart Disease")
                ),
                value = FALSE,
                width = "100%"
              )
            ),
            tags$div(
              class = "checkbox-item",
              checkboxInput(
                inputId = ns("has_asthma"),
                label = tagList(
                  tags$i(class = "fas fa-lungs", style = "color: #1ABC9C;"),
                  tags$span("Asthma")
                ),
                value = FALSE,
                width = "100%"
              )
            ),
            tags$div(
              class = "checkbox-item",
              checkboxInput(
                inputId = ns("has_kidney_disease"),
                label = tagList(
                  tags$i(class = "fas fa-droplet", style = "color: #9B59B6;"),
                  tags$span("Kidney Disease")
                ),
                value = FALSE,
                width = "100%"
              )
            ),
            tags$div(
              class = "checkbox-item",
              checkboxInput(
                inputId = ns("has_arthritis"),
                label = tagList(
                  tags$i(class = "fas fa-bone", style = "color: #F39C12;"),
                  tags$span("Arthritis")
                ),
                value = FALSE,
                width = "100%"
              )
            )
          ),
          
          tags$div(
            class = "form-group",
            tags$label(class = "form-label", "Other Conditions"),
            textAreaInput(
              inputId = ns("other_conditions"),
              label = NULL,
              placeholder = "Please specify any other chronic conditions...",
              rows = 3,
              width = "100%"
            )
          ),
          
          tags$div(
            class = "form-group",
            tags$label(class = "form-label", "Approximate Diagnosis Date"),
            dateInput(
              inputId = ns("diagnosis_date"),
              label = NULL,
              value = NULL,
              max = Sys.Date(),
              width = "100%"
            )
          )
        ),
        
        # STEP 3: Medical History
        tags$div(
          class = "form-section",
          id = ns("step_3"),
          style = "display: none;",
          
          tags$h3(class = "section-title", "Medical History"),
          tags$p(class = "section-description", "Help us understand your medical background"),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label(class = "form-label", "Primary Physician"),
              textInput(
                inputId = ns("primary_physician"),
                label = NULL,
                placeholder = "Dr. [Name]",
                width = "100%"
              )
            ),
            tags$div(
              class = "form-group",
              tags$label(class = "form-label", "Hospital/Clinic Name"),
              textInput(
                inputId = ns("hospital_name"),
                label = NULL,
                placeholder = "Hospital or clinic name",
                width = "100%"
              )
            )
          ),
          
          tags$h4(class = "subsection-title", "Insurance Information"),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label(class = "form-label", "Insurance Type"),
              selectInput(
                inputId = ns("insurance_type"),
                label = NULL,
                choices = c("Select Type" = "", "Mutuelle de Santé" = "mutuelle", 
                           "RAMA" = "rama", "MMI" = "mmi", "Private" = "private", 
                           "None" = "none"),
                width = "100%"
              )
            ),
            tags$div(
              class = "form-group",
              tags$label(class = "form-label", "Insurance Number"),
              textInput(
                inputId = ns("insurance_number"),
                label = NULL,
                placeholder = "Insurance ID number",
                width = "100%"
              )
            )
          ),
          
          tags$div(
            class = "form-group",
            tags$label(class = "form-label", "Allergies"),
            textAreaInput(
              inputId = ns("allergies"),
              label = NULL,
              placeholder = "List any known allergies (medications, food, etc.)",
              rows = 2,
              width = "100%"
            )
          ),
          
          tags$div(
            class = "form-group",
            tags$label(class = "form-label", "Previous Surgeries"),
            textAreaInput(
              inputId = ns("previous_surgeries"),
              label = NULL,
              placeholder = "List any previous surgeries or major procedures",
              rows = 2,
              width = "100%"
            )
          ),
          
          tags$div(
            class = "form-group",
            tags$label(class = "form-label", "Family Medical History"),
            textAreaInput(
              inputId = ns("family_history"),
              label = NULL,
              placeholder = "Note any relevant family medical history (e.g., diabetes, heart disease)",
              rows = 2,
              width = "100%"
            )
          )
        ),
        
        # STEP 4: Lifestyle & Confirmation
        tags$div(
          class = "form-section",
          id = ns("step_4"),
          style = "display: none;",
          
          tags$h3(class = "section-title", "Lifestyle Information"),
          tags$p(class = "section-description", "This helps us provide personalized care recommendations"),
          
          tags$div(
            class = "form-group",
            tags$label(class = "form-label", "Smoking Status"),
            selectInput(
              inputId = ns("smoking_status"),
              label = NULL,
              choices = c("Select Status" = "", "Never" = "never", "Former Smoker" = "former", 
                         "Current Smoker" = "current"),
              width = "100%"
            )
          ),
          
          tags$div(
            class = "form-group",
            tags$label(class = "form-label", "Alcohol Consumption"),
            selectInput(
              inputId = ns("alcohol_consumption"),
              label = NULL,
              choices = c("Select Frequency" = "", "Never" = "never", "Occasionally" = "occasional", 
                         "Regularly" = "regular"),
              width = "100%"
            )
          ),
          
          tags$div(
            class = "form-group",
            tags$label(class = "form-label", "Exercise Frequency"),
            selectInput(
              inputId = ns("exercise_frequency"),
              label = NULL,
              choices = c("Select Frequency" = "", "Rarely" = "rarely", "1-2 times/week" = "1-2", 
                         "3-4 times/week" = "3-4", "5+ times/week" = "5+"),
              width = "100%"
            )
          ),
          
          # Confirmation Summary
          tags$div(
            class = "confirmation-summary",
            tags$h4(class = "summary-title", "📋 Enrollment Summary"),
            tags$p(class = "summary-text", 
              "You're about to enroll in the Baho for Life program. This program will help you:"
            ),
            tags$ul(
              class = "summary-list",
              tags$li("Track and manage your medications with reminders"),
              tags$li("Monitor vital signs (blood pressure, glucose, weight)"),
              tags$li("Schedule and track medical appointments"),
              tags$li("Log symptoms and identify patterns"),
              tags$li("Set and achieve health goals"),
              tags$li("Access personalized health education"),
              tags$li("Connect with healthcare professionals")
            ),
            tags$p(class = "summary-note", 
              "✓ Your data is secure and confidential"
            )
          )
        ),
        
        # Success Screen
        tags$div(
          class = "success-screen",
          id = ns("success_screen"),
          style = "display: none;",
          
          tags$div(class = "success-icon", "✅"),
          tags$h2(class = "success-title", "Welcome to Baho for Life!"),
          tags$p(class = "success-message", 
            "Your enrollment is complete. You can now access your personalized health dashboard."
          ),
          
          actionButton(
            inputId = ns("go_to_dashboard"),
            label = tagList(
              "Go to My Dashboard",
              tags$i(class = "fas fa-arrow-right")
            ),
            class = "btn-primary",
            style = "margin-top: 2rem;"
          )
        ),
        
        # Navigation Buttons
        tags$div(
          class = "form-navigation",
          
          actionButton(
            inputId = ns("prev_step"),
            label = tagList(
              tags$i(class = "fas fa-arrow-left"),
              "Previous"
            ),
            class = "btn-navigation btn-secondary",
            style = "display: none;"
          ),
          
          actionButton(
            inputId = ns("next_step"),
            label = tagList(
              "Next",
              tags$i(class = "fas fa-arrow-right")
            ),
            class = "btn-navigation btn-primary"
          ),
          
          actionButton(
            inputId = ns("submit_enrollment"),
            label = tagList(
              "Complete Enrollment",
              tags$i(class = "fas fa-check")
            ),
            class = "btn-navigation btn-success",
            style = "display: none;"
          )
        )
      )
    )
  )
}

chronicDiseaseServer <- function(id, current_user, db_conn) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive values
    current_step <- reactiveVal(1)
    patient_id <- reactiveVal(NULL)
    
    # Initialize: Hide prev button and submit button initially
    observe({
      shinyjs::hide("prev_step")
      shinyjs::hide("submit_enrollment")
    })
    
    # Update step UI
    update_step_ui <- function(step) {
      # Hide all steps
      for (i in 1:4) {
        shinyjs::hide(paste0("step_", i))
        shinyjs::runjs(sprintf("
          document.getElementById('%s').classList.remove('active', 'completed');
        ", ns(paste0("step_indicator_", i))))
      }
      
      # Show current step
      shinyjs::show(paste0("step_", step))
      
      # Update step indicators
      for (i in 1:4) {
        if (i < step) {
          shinyjs::runjs(sprintf("
            document.getElementById('%s').classList.add('completed');
          ", ns(paste0("step_indicator_", i))))
        } else if (i == step) {
          shinyjs::runjs(sprintf("
            document.getElementById('%s').classList.add('active');
          ", ns(paste0("step_indicator_", i))))
        }
      }
      
      # Update button visibility
      if (step == 1) {
        shinyjs::hide("prev_step")
      } else {
        shinyjs::show("prev_step")
      }
      
      if (step == 4) {
        shinyjs::hide("next_step")
        shinyjs::show("submit_enrollment")
      } else {
        shinyjs::show("next_step")
        shinyjs::hide("submit_enrollment")
      }
    }
    
    # Next button
    observeEvent(input$next_step, {
      step <- current_step()
      
      # Validation for each step
      if (step == 1) {
        if (input$full_name == "" || is.null(input$date_of_birth) || 
            input$gender == "" || input$phone == "") {
          showNotification("Please fill in all required fields (*)", type = "error")
          return()
        }
      }
      
      if (step < 4) {
        current_step(step + 1)
        update_step_ui(step + 1)
      }
    })
    
    # Previous button
    observeEvent(input$prev_step, {
      step <- current_step()
      if (step > 1) {
        current_step(step - 1)
        update_step_ui(step - 1)
      }
    })
    
    # Submit enrollment
    observeEvent(input$submit_enrollment, {
      cat("💾 Submitting chronic disease enrollment...\n")
      
      pool <- db_conn
      user <- current_user
      
      if (is.null(pool) || is.null(user)) {
        showNotification("Database connection error. Please try again.", type = "error")
        return()
      }
      
      tryCatch({
        # Enroll in program
        cat("📝 Enrolling in Baho for Life program...\n")
        enrollment_id <- db_functions$enroll_in_program(pool, user$user_id, "Baho for Life")
        
        if (is.null(enrollment_id)) {
          showNotification("Error enrolling in program. Please try again.", type = "error")
          return()
        }
        
        cat("✅ Enrolled with ID:", enrollment_id, "\n")
        
        # Prepare patient data
        patient_data <- list(
          full_name = input$full_name,
          date_of_birth = input$date_of_birth,
          gender = input$gender,
          phone = input$phone,
          emergency_contact_name = if (input$emergency_contact_name != "") input$emergency_contact_name else NULL,
          emergency_contact_phone = if (input$emergency_contact_phone != "") input$emergency_contact_phone else NULL,
          has_diabetes = input$has_diabetes,
          has_hypertension = input$has_hypertension,
          has_heart_disease = input$has_heart_disease,
          has_asthma = input$has_asthma,
          has_kidney_disease = input$has_kidney_disease,
          has_arthritis = input$has_arthritis,
          other_conditions = if (input$other_conditions != "") input$other_conditions else NULL,
          diagnosis_date = if (!is.null(input$diagnosis_date)) input$diagnosis_date else NULL,
          primary_physician = if (input$primary_physician != "") input$primary_physician else NULL,
          hospital_name = if (input$hospital_name != "") input$hospital_name else NULL,
          insurance_type = if (input$insurance_type != "") input$insurance_type else NULL,
          insurance_number = if (input$insurance_number != "") input$insurance_number else NULL,
          smoking_status = if (input$smoking_status != "") input$smoking_status else NULL,
          alcohol_consumption = if (input$alcohol_consumption != "") input$alcohol_consumption else NULL,
          exercise_frequency = if (input$exercise_frequency != "") input$exercise_frequency else NULL,
          allergies = if (input$allergies != "") input$allergies else NULL,
          previous_surgeries = if (input$previous_surgeries != "") input$previous_surgeries else NULL,
          family_history = if (input$family_history != "") input$family_history else NULL
        )
        
        # Save patient data
        cat("💾 Saving chronic patient data...\n")
        saved_patient_id <- db_functions$save_chronic_patient(pool, enrollment_id, user$user_id, patient_data)
        
        if (is.null(saved_patient_id)) {
          showNotification("Error saving patient data. Please try again.", type = "error")
          return()
        }
        
        cat("✅ Patient data saved with ID:", saved_patient_id, "\n")
        patient_id(saved_patient_id)
        
        # Show success screen
        for (i in 1:4) {
          shinyjs::hide(paste0("step_", i))
        }
        shinyjs::hide("prev_step")
        shinyjs::hide("next_step")
        shinyjs::hide("submit_enrollment")
        
        shinyjs::runjs("
          document.querySelector('.step-progress').style.display = 'none';
        ")
        
        shinyjs::show("success_screen")
        
        showNotification("🎉 Enrollment successful! Welcome to Baho for Life!", type = "message", duration = 5)
        
      }, error = function(e) {
        cat("ERROR enrolling in chronic disease program:", e$message, "\n")
        showNotification(paste("Error enrolling in program:", e$message), type = "error", duration = 10)
      })
    })
    
    # Go to dashboard
    observeEvent(input$go_to_dashboard, {
      cat("📊 Navigating to chronic disease dashboard...\n")
      
      # Hide enrollment form
      shinyjs::runjs("
        const chronicContainer = document.querySelector('.chronic-disease-container');
        if (chronicContainer) chronicContainer.style.display = 'none';
      ")
      
      # Show dashboard
      shinyjs::runjs("
        const chronicDashboard = document.querySelector('.chronic-dashboard');
        if (chronicDashboard) chronicDashboard.style.display = 'block';
        window.scrollTo({ top: 0, behavior: 'smooth' });
      ")
      
      showNotification("Welcome to your health dashboard!", type = "message", duration = 3)
    })
    
    # Back to programs
    observeEvent(input$back_to_programs, {
      cat("🔙 Returning to health programs...\n")
      
      # Hide enrollment form
      shinyjs::runjs("
        const chronicContainer = document.querySelector('.chronic-disease-container');
        if (chronicContainer) chronicContainer.style.display = 'none';
      ")
      
      # Show health programs section
      shinyjs::runjs("
        const programsSection = document.querySelector('.health-programs-section');
        if (programsSection) programsSection.style.display = 'block';
        window.scrollTo({ top: 0, behavior: 'smooth' });
      ")
    })
  })
}

