# 1000 Days with Baho - Child Health Monitoring Module
# Comprehensive child health tracking from birth to 1000 days

library(shiny)
library(shinyjs)

# UI Function
childHealthUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "child-health-styles.css")
    ),
    
    # Child Health Container
    tags$div(
      class = "child-health-container",
      style = "display: none;",
      
      # Back Button
      actionButton(
        inputId = ns("back_to_programs"),
        label = tags$span(
          tags$i(class = "fas fa-arrow-left"),
          "Back to Programs"
        ),
        class = "program-back-btn"
      ),
      
      # Enrollment Form
      tags$div(
        class = "child-enrollment-form",
        id = ns("enrollment_section"),
        
        tags$div(
          class = "program-header",
          tags$img(src = "1000.png", class = "program-header-img"),
          tags$h1("1000 Days with Baho"),
          tags$p("Track your child's health journey from birth to 1000 days")
        ),
        
        # Progress Indicator
        tags$div(
          class = "step-progress",
          id = ns("step_progress"),
          tags$div(class = "step-item active", tags$span(class = "step-number", "1"), tags$span(class = "step-label", "Child Info")),
          tags$div(class = "step-item", tags$span(class = "step-number", "2"), tags$span(class = "step-label", "Health Details")),
          tags$div(class = "step-item", tags$span(class = "step-number", "3"), tags$span(class = "step-label", "Caregiver Info")),
          tags$div(class = "step-item", tags$span(class = "step-number", "4"), tags$span(class = "step-label", "Confirm"))
        ),
        
        # Step 1: Child Information
        tags$div(
          class = "form-section",
          id = ns("step_1"),
          
          tags$h2("Child Information"),
          tags$p(class = "section-description", "Tell us about your child"),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label("Child's Full Name *"),
              textInput(ns("child_name"), NULL, placeholder = "e.g., Jean Claude Nkurunziza")
            ),
            tags$div(
              class = "form-group",
              tags$label("Date of Birth *"),
              dateInput(ns("date_of_birth"), NULL, max = Sys.Date())
            )
          ),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label("Gender *"),
              selectInput(ns("gender"), NULL, choices = c("Select..." = "", "Male" = "male", "Female" = "female"))
            ),
            tags$div(
              class = "form-group",
              tags$label("Birth Weight (kg) *"),
              numericInput(ns("birth_weight"), NULL, value = NULL, min = 0.5, max = 10, step = 0.1)
            )
          ),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label("Birth Length (cm)"),
              numericInput(ns("birth_length"), NULL, value = NULL, min = 30, max = 70, step = 0.5)
            ),
            tags$div(
              class = "form-group",
              tags$label("Birth Hospital/Health Center *"),
              textInput(ns("birth_hospital"), NULL, placeholder = "e.g., King Faisal Hospital")
            )
          ),
          
          tags$div(
            class = "info-cards",
            tags$div(
              class = "info-card",
              tags$i(class = "fas fa-info-circle"),
              tags$div(
                tags$strong("Why 1000 Days?"),
                tags$p("The first 1000 days from conception to age 2 are critical for your child's physical and cognitive development.")
              )
            )
          )
        ),
        
        # Step 2: Health Details
        tags$div(
          class = "form-section",
          id = ns("step_2"),
          style = "display: none;",
          
          tags$h2("Health Details"),
          tags$p(class = "section-description", "Medical and health information"),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label("Blood Type"),
              selectInput(ns("blood_type"), NULL, choices = c("Select..." = "", "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"))
            ),
            tags$div(
              class = "form-group",
              tags$label("Place of Delivery"),
              selectInput(ns("delivery_place"), NULL, choices = c("Select..." = "", "Hospital" = "hospital", "Health Center" = "health_center", "Home" = "home"))
            )
          ),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group full-width",
              tags$label("Birth Complications (if any)"),
              tags$textarea(id = ns("birth_complications"), class = "form-textarea", placeholder = "e.g., Premature birth, jaundice, breathing issues...")
            )
          ),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group full-width",
              tags$label("Current Health Conditions"),
              tags$textarea(id = ns("health_conditions"), class = "form-textarea", placeholder = "e.g., Allergies, chronic conditions...")
            )
          ),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group full-width",
              tags$label("Current Medications"),
              tags$textarea(id = ns("current_medications"), class = "form-textarea", placeholder = "List any medications or supplements...")
            )
          )
        ),
        
        # Step 3: Caregiver Information
        tags$div(
          class = "form-section",
          id = ns("step_3"),
          style = "display: none;",
          
          tags$h2("Caregiver Information"),
          tags$p(class = "section-description", "Primary caregiver details"),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label("Relationship to Child *"),
              selectInput(ns("relationship"), NULL, choices = c("Select..." = "", "Mother" = "mother", "Father" = "father", "Guardian" = "guardian", "Other" = "other"))
            ),
            tags$div(
              class = "form-group",
              tags$label("Phone Number *"),
              textInput(ns("caregiver_phone"), NULL, placeholder = "e.g., +250 788 000 000")
            )
          ),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group full-width",
              tags$label("Address *"),
              tags$textarea(id = ns("address"), class = "form-textarea", placeholder = "Province, District, Sector, Cell, Village")
            )
          ),
          
          tags$h3(style = "margin-top: 2rem; margin-bottom: 1rem;", "Emergency Contact"),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label("Emergency Contact Name *"),
              textInput(ns("emergency_name"), NULL, placeholder = "Full name")
            ),
            tags$div(
              class = "form-group",
              tags$label("Emergency Phone *"),
              textInput(ns("emergency_phone"), NULL, placeholder = "+250 7XX XXX XXX")
            )
          ),
          
          tags$div(
            class = "form-row",
            tags$div(
              class = "form-group",
              tags$label("Preferred Health Facility"),
              textInput(ns("preferred_facility"), NULL, placeholder = "Your regular health center")
            ),
            tags$div(
              class = "form-group",
              tags$label("Pediatrician Name"),
              textInput(ns("pediatrician"), NULL, placeholder = "Doctor's name")
            )
          )
        ),
        
        # Step 4: Confirmation
        tags$div(
          class = "form-section",
          id = ns("step_4"),
          style = "display: none;",
          
          tags$h2("Confirmation"),
          tags$p(class = "section-description", "Review and confirm your information"),
          
          tags$div(
            class = "confirmation-summary",
            id = ns("confirmation_summary")
          ),
          
          tags$div(
            class = "checkbox-group",
            tags$div(
              class = "checkbox-item",
              checkboxInput(ns("terms_agree"), label = NULL),
              tags$label(
                `for` = ns("terms_agree"),
                "I agree to share this health information with Baho AI for monitoring and care purposes"
              )
            )
          )
        ),
        
        # Success Screen
        tags$div(
          class = "success-screen",
          id = ns("success_screen"),
          style = "display: none;",
          
          tags$div(class = "success-icon", tags$i(class = "fas fa-check-circle")),
          tags$h2("Enrollment Successful!"),
          tags$p("Welcome to 1000 Days with Baho. Let's track your child's healthy development together."),
          
          actionButton(
            inputId = ns("go_to_dashboard"),
            label = tags$span(
              tags$i(class = "fas fa-chart-line"),
              "Go to Dashboard"
            ),
            class = "btn-navigation success"
          )
        ),
        
        # Navigation Buttons
        tags$div(
          class = "form-navigation",
          id = ns("form_navigation"),
          
          actionButton(
            inputId = ns("prev_step"),
            label = tags$span(
              tags$i(class = "fas fa-arrow-left"),
              "Previous"
            ),
            class = "btn-navigation secondary",
            style = "display: none;"
          ),
          
          actionButton(
            inputId = ns("next_step"),
            label = tags$span(
              "Next",
              tags$i(class = "fas fa-arrow-right")
            ),
            class = "btn-navigation primary"
          ),
          
          actionButton(
            inputId = ns("submit_enrollment"),
            label = tags$span(
              tags$i(class = "fas fa-check"),
              "Complete Enrollment"
            ),
            class = "btn-navigation primary",
            style = "display: none;"
          )
        )
      )
    )
  )
}

# Server Function
childHealthServer <- function(id, current_user, db_pool) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive values
    current_step <- reactiveVal(1)
    
    # Initialize UI state on load
    observe({
      # Ensure submit button is hidden on initial load
      shinyjs::hide("submit_enrollment")
      shinyjs::hide("prev_step")
      shinyjs::show("next_step")
    })
    
    # Step navigation
    observeEvent(input$next_step, {
      step <- current_step()
      
      # Validate current step
      if (step == 1) {
        if (is.null(input$child_name) || input$child_name == "" ||
            is.null(input$date_of_birth) || input$gender == "" ||
            is.null(input$birth_weight) || input$birth_hospital == "") {
          showNotification("Please fill in all required fields", type = "error")
          return()
        }
      }
      
      if (step == 3) {
        if (input$relationship == "" || input$caregiver_phone == "" ||
            input$address == "" || input$emergency_name == "" || input$emergency_phone == "") {
          showNotification("Please fill in all required fields", type = "error")
          return()
        }
      }
      
      # Move to next step
      if (step < 4) {
        current_step(step + 1)
        update_step_ui(step + 1)
      }
    })
    
    observeEvent(input$prev_step, {
      step <- current_step()
      if (step > 1) {
        current_step(step - 1)
        update_step_ui(step - 1)
      }
    })
    
    # Update UI based on step
    update_step_ui <- function(step) {
      # Hide all steps
      for (i in 1:4) {
        shinyjs::hide(sprintf("step_%d", i))
      }
      
      # Show current step
      shinyjs::show(sprintf("step_%d", step))
      
      # Update progress
      shinyjs::runjs(sprintf("
        document.querySelectorAll('#%s .step-item').forEach((item, index) => {
          if (index < %d) {
            item.classList.add('active');
            item.classList.add('completed');
          } else if (index === %d - 1) {
            item.classList.add('active');
            item.classList.remove('completed');
          } else {
            item.classList.remove('active');
            item.classList.remove('completed');
          }
        });
      ", ns("step_progress"), step, step))
      
      # Update navigation buttons
      if (step == 1) {
        shinyjs::hide("prev_step")
      } else {
        shinyjs::show("prev_step")
      }
      
      if (step == 4) {
        shinyjs::hide("next_step")
        shinyjs::show("submit_enrollment")
        generate_confirmation_summary()
      } else {
        shinyjs::show("next_step")
        shinyjs::hide("submit_enrollment")
      }
    }
    
    # Generate confirmation summary
    generate_confirmation_summary <- function() {
      summary_html <- sprintf('
        <div class="summary-section">
          <h3><i class="fas fa-child"></i> Child Information</h3>
          <div class="summary-item"><strong>Name:</strong> %s</div>
          <div class="summary-item"><strong>Date of Birth:</strong> %s</div>
          <div class="summary-item"><strong>Gender:</strong> %s</div>
          <div class="summary-item"><strong>Birth Weight:</strong> %s kg</div>
          <div class="summary-item"><strong>Birth Hospital:</strong> %s</div>
        </div>
        
        <div class="summary-section">
          <h3><i class="fas fa-user"></i> Caregiver Information</h3>
          <div class="summary-item"><strong>Relationship:</strong> %s</div>
          <div class="summary-item"><strong>Phone:</strong> %s</div>
          <div class="summary-item"><strong>Emergency Contact:</strong> %s (%s)</div>
        </div>
      ',
      input$child_name,
      format(input$date_of_birth, "%B %d, %Y"),
      tools::toTitleCase(input$gender),
      input$birth_weight,
      input$birth_hospital,
      tools::toTitleCase(input$relationship),
      input$caregiver_phone,
      input$emergency_name,
      input$emergency_phone
      )
      
      shinyjs::html("confirmation_summary", summary_html)
    }
    
    # Submit enrollment
    observeEvent(input$submit_enrollment, {
      if (!input$terms_agree) {
        showNotification("Please agree to the terms to continue", type = "error")
        return()
      }
      
      req(current_user())
      req(db_pool())
      
      pool <- db_pool()
      user <- current_user()
      
      tryCatch({
        cat("📝 Starting child health enrollment...\n")
        
        # Calculate age in days
        age_days <- as.numeric(difftime(Sys.Date(), input$date_of_birth, units = "days"))
        
        # Get or create "1000 Days with Baho" program
        program <- dbGetQuery(pool, "
          SELECT program_id FROM public.health_programs 
          WHERE program_name = '1000 Days with Baho' AND is_active = TRUE
          LIMIT 1
        ")
        
        if (nrow(program) == 0) {
          stop("1000 Days with Baho program not found")
        }
        
        program_id <- program$program_id[1]
        
        # Enroll in program
        enrollment_id <- db_functions$enroll_in_program(
          pool,
          user$user_id,
          program_id,
          Sys.Date(),
          Sys.Date() + 1000  # 1000 days from now
        )
        
        if (is.null(enrollment_id)) {
          stop("Failed to enroll in program")
        }
        
        cat("✅ Enrolled with ID:", enrollment_id, "\n")
        
        # Save child health data
        child_data <- list(
          child_name = input$child_name,
          date_of_birth = input$date_of_birth,
          gender = input$gender,
          birth_weight_kg = input$birth_weight,
          birth_length_cm = input$birth_length,
          birth_hospital = input$birth_hospital,
          blood_type = input$blood_type,
          delivery_place = input$delivery_place,
          birth_complications = input$birth_complications,
          health_conditions = input$health_conditions,
          current_medications = input$current_medications,
          caregiver_relationship = input$relationship,
          caregiver_phone = input$caregiver_phone,
          address = input$address,
          emergency_contact_name = input$emergency_name,
          emergency_contact_phone = input$emergency_phone,
          preferred_health_facility = input$preferred_facility,
          pediatrician_name = input$pediatrician
        )
        
        db_functions$save_child_health_data(pool, enrollment_id, user$user_id, child_data)
        
        cat("✅ Child health data saved\n")
        
        # Show success screen
        shinyjs::hide("form_navigation")
        for (i in 1:4) {
          shinyjs::hide(sprintf("step_%d", i))
        }
        shinyjs::show("success_screen")
        
        showNotification("Enrollment successful!", type = "message", duration = 3)
        
      }, error = function(e) {
        cat("❌ Error enrolling in child health program:", e$message, "\n")
        showNotification(paste("Error enrolling:", e$message), type = "error")
      })
    })
    
    # Go to dashboard
    observeEvent(input$go_to_dashboard, {
      cat("📊 Navigating to child health dashboard...\n")
      
      # Show dashboard
      session$sendCustomMessage("showChildHealthDashboard", list())
      
      showNotification("Welcome to your child's health dashboard!", type = "message", duration = 3)
    })
    
    # Back to programs
    observeEvent(input$back_to_programs, {
      cat("🔙 Returning to health programs\n")
      shinyjs::runjs("
        const childContainer = document.querySelector('.child-health-container');
        if (childContainer) childContainer.style.display = 'none';
      ")
      session$sendCustomMessage("showHealthPrograms", list())
    })
    
  })
}

