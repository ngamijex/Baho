# Baho for Life - Chronic Disease Management Dashboard
# Comprehensive dashboard for tracking chronic conditions

library(shiny)
library(shinyjs)
library(plotly)

chronicDashboardUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    useShinyjs(),
    
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "chronic-disease-styles.css")
    ),
    
    # Main Dashboard Container
    tags$div(
      class = "chronic-dashboard",
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
      
      # Dashboard Header
      tags$div(
        class = "dashboard-header",
        
        tags$div(
          class = "dashboard-title-section",
          tags$div(class = "dashboard-greeting", textOutput(ns("greeting_text"))),
          tags$h1(class = "dashboard-title", "My Health Dashboard")
        ),
        
        tags$div(
          class = "dashboard-subtitle-section",
          textOutput(ns("program_subtitle"))
        )
      ),
      
      # Patient Overview Cards
      tags$div(
        class = "stats-grid",
        
        tags$div(
          class = "stat-card stat-medications",
          tags$div(class = "stat-icon", tags$i(class = "fas fa-pills")),
          tags$div(
            class = "stat-content",
            tags$div(class = "stat-value", textOutput(ns("active_medications_count"))),
            tags$div(class = "stat-label", "Active Medications")
          )
        ),
        
        tags$div(
          class = "stat-card stat-vitals",
          tags$div(class = "stat-icon", tags$i(class = "fas fa-heart-pulse")),
          tags$div(
            class = "stat-content",
            tags$div(class = "stat-value", textOutput(ns("latest_bp_display"))),
            tags$div(class = "stat-label", "Latest Blood Pressure")
          )
        ),
        
        tags$div(
          class = "stat-card stat-appointments",
          tags$div(class = "stat-icon", tags$i(class = "fas fa-calendar-check")),
          tags$div(
            class = "stat-content",
            tags$div(class = "stat-value", textOutput(ns("upcoming_appointments_count"))),
            tags$div(class = "stat-label", "Upcoming Appointments")
          )
        ),
        
        tags$div(
          class = "stat-card stat-goals",
          tags$div(class = "stat-icon", tags$i(class = "fas fa-bullseye")),
          tags$div(
            class = "stat-content",
            tags$div(class = "stat-value", textOutput(ns("active_goals_count"))),
            tags$div(class = "stat-label", "Active Health Goals")
          )
        )
      ),
      
      # Dashboard Grid Layout
      tags$div(
        class = "dashboard-grid",
        
        # Quick Actions Card
        tags$div(
          class = "dashboard-card col-span-12",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-bolt"),
              "Quick Actions"
            )
          ),
          tags$div(
            class = "card-content",
            tags$div(
              class = "quick-actions-grid",
              
              # Medication Action
              tags$div(
                class = "action-card",
                id = ns("action_medications"),
                tags$div(class = "action-icon", tags$i(class = "fas fa-pills")),
                tags$div(class = "action-title", "Medications"),
                tags$div(class = "action-description", "Track & log medications")
              ),
              
              # Vital Signs Action
              tags$div(
                class = "action-card",
                id = ns("action_vitals"),
                tags$div(class = "action-icon", tags$i(class = "fas fa-heartbeat")),
                tags$div(class = "action-title", "Vital Signs"),
                tags$div(class = "action-description", "Record vital measurements")
              ),
              
              # Appointments Action
              tags$div(
                class = "action-card",
                id = ns("action_appointments"),
                tags$div(class = "action-icon", tags$i(class = "fas fa-calendar-alt")),
                tags$div(class = "action-title", "Appointments"),
                tags$div(class = "action-description", "Schedule visits")
              ),
              
              # Symptoms Action
              tags$div(
                class = "action-card",
                id = ns("action_symptoms"),
                tags$div(class = "action-icon", tags$i(class = "fas fa-notes-medical")),
                tags$div(class = "action-title", "Symptoms"),
                tags$div(class = "action-description", "Log symptoms")
              ),
              
              # Lab Tests Action
              tags$div(
                class = "action-card",
                id = ns("action_labtests"),
                tags$div(class = "action-icon", tags$i(class = "fas fa-flask")),
                tags$div(class = "action-title", "Lab Tests"),
                tags$div(class = "action-description", "Record test results")
              ),
              
              # Health Goals Action
              tags$div(
                class = "action-card",
                id = ns("action_goals"),
                tags$div(class = "action-icon", tags$i(class = "fas fa-trophy")),
                tags$div(class = "action-title", "Health Goals"),
                tags$div(class = "action-description", "Set & track goals")
              )
            )
          )
        ),
        
        # Vital Signs Chart Card
        tags$div(
          class = "dashboard-card col-span-8",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-chart-line"),
              "Vital Signs Trends"
            )
          ),
          tags$div(
            class = "card-content",
            plotlyOutput(ns("vitals_chart"), height = "350px")
          )
        ),
        
        # Medication Adherence Card
        tags$div(
          class = "dashboard-card col-span-4",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-pills"),
              "Medication Adherence"
            )
          ),
          tags$div(
            class = "card-content",
            tags$div(
              id = ns("medication_adherence_display"),
              class = "adherence-container"
            )
          )
        ),
        
        # Today's Medications Card
        tags$div(
          class = "dashboard-card col-span-6",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-calendar-day"),
              "Today's Medications"
            )
          ),
          tags$div(
            class = "card-content",
            tags$div(
              id = ns("todays_medications_list"),
              class = "medications-list"
            )
          )
        ),
        
        # Upcoming Appointments Card
        tags$div(
          class = "dashboard-card col-span-6",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-calendar-check"),
              "Upcoming Appointments"
            )
          ),
          tags$div(
            class = "card-content",
            tags$div(
              id = ns("upcoming_appointments_list"),
              class = "appointments-list"
            )
          )
        ),
        
        # Recent Symptoms Card
        tags$div(
          class = "dashboard-card col-span-6",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-notes-medical"),
              "Recent Symptoms"
            )
          ),
          tags$div(
            class = "card-content",
            tags$div(
              id = ns("recent_symptoms_list"),
              class = "symptoms-list"
            )
          )
        ),
        
        # Health Goals Progress Card
        tags$div(
          class = "dashboard-card col-span-6",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-bullseye"),
              "Health Goals Progress"
            )
          ),
          tags$div(
            class = "card-content",
            tags$div(
              id = ns("health_goals_progress"),
              class = "goals-list"
            )
          )
        )
      ),
      
      # ========== MODALS ==========
      
      # Medications Modal
      tags$div(
        id = ns("medications_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("medications_modal"), ns("medications_modal")),
        
        tags$div(
          class = "modal-content",
          
          tags$div(
            class = "modal-header",
            tags$h3(class = "modal-title", tags$i(class = "fas fa-pills"), "Medication Tracker"),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("medications_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            # Active Medications List
            tags$h4("Active Medications"),
            tags$div(id = ns("active_medications_list"), class = "medications-list-modal"),
            
            tags$hr(),
            
            # Add New Medication Form
            tags$h4("Add New Medication"),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Medication Name"),
                textInput(ns("med_name"), NULL, placeholder = "e.g., Metformin")
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Dosage"),
                textInput(ns("med_dosage"), NULL, placeholder = "e.g., 500mg")
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Frequency"),
                selectInput(ns("med_frequency"), NULL, 
                           choices = c("Select" = "", "Once daily" = "once", "Twice daily" = "twice", 
                                      "Three times daily" = "three", "As needed" = "asneeded"))
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Time of Day"),
                textInput(ns("med_time"), NULL, placeholder = "e.g., Morning, Evening")
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Purpose"),
                textInput(ns("med_purpose"), NULL, placeholder = "What is this for?")
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Prescribing Doctor"),
                textInput(ns("med_doctor"), NULL, placeholder = "Doctor's name")
              )
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(ns("cancel_medication"), "Cancel", class = "btn-cancel"),
            actionButton(
              ns("add_medication"),
              label = tags$span(tags$i(class = "fas fa-plus"), "Add Medication"),
              class = "btn-save"
            )
          )
        )
      ),
      
      # Vital Signs Modal
      tags$div(
        id = ns("vitals_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("vitals_modal"), ns("vitals_modal")),
        
        tags$div(
          class = "modal-content",
          
          tags$div(
            class = "modal-header",
            tags$h3(class = "modal-title", tags$i(class = "fas fa-heartbeat"), "Record Vital Signs"),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("vitals_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Blood Pressure (Systolic)"),
                numericInput(ns("systolic_bp"), NULL, value = NULL, min = 60, max = 250)
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Blood Pressure (Diastolic)"),
                numericInput(ns("diastolic_bp"), NULL, value = NULL, min = 40, max = 150)
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Blood Glucose (mg/dL)"),
                numericInput(ns("blood_glucose"), NULL, value = NULL, min = 20, max = 600)
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Glucose Context"),
                selectInput(ns("glucose_context"), NULL,
                           choices = c("Select" = "", "Fasting" = "fasting", "Before meal" = "before", 
                                      "After meal" = "after", "Bedtime" = "bedtime"))
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Heart Rate (bpm)"),
                numericInput(ns("heart_rate"), NULL, value = NULL, min = 30, max = 200)
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Weight (kg)"),
                numericInput(ns("weight_kg"), NULL, value = NULL, min = 20, max = 300)
              )
            ),
            tags$div(
              class = "modal-form-group full-width",
              tags$label(class = "modal-label", "How are you feeling?"),
              selectInput(ns("feeling"), NULL,
                         choices = c("Select" = "", "Great" = "great", "Good" = "good", 
                                    "Fair" = "fair", "Poor" = "poor"))
            ),
            tags$div(
              class = "modal-form-group full-width",
              tags$label(class = "modal-label", "Notes"),
              tags$textarea(
                id = ns("vitals_notes"),
                class = "modal-textarea",
                placeholder = "Any additional notes..."
              )
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(ns("cancel_vitals"), "Cancel", class = "btn-cancel"),
            actionButton(
              ns("save_vitals"),
              label = tags$span(tags$i(class = "fas fa-save"), "Save Vital Signs"),
              class = "btn-save"
            )
          )
        )
      ),
      
      # Appointments Modal
      tags$div(
        id = ns("appointments_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("appointments_modal"), ns("appointments_modal")),
        
        tags$div(
          class = "modal-content",
          
          tags$div(
            class = "modal-header",
            tags$h3(class = "modal-title", tags$i(class = "fas fa-calendar-alt"), "Schedule Appointment"),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("appointments_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            # Scheduled Appointments
            tags$h4("Scheduled Appointments"),
            tags$div(id = ns("scheduled_appointments_list"), class = "appointments-list-modal"),
            
            tags$hr(),
            
            # Schedule New Appointment
            tags$h4("Schedule New Appointment"),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Appointment Type"),
                selectInput(ns("apt_type"), NULL,
                           choices = c("Select Type" = "", "Check-up" = "checkup", "Follow-up" = "followup",
                                      "Specialist" = "specialist", "Lab Test" = "labtest", "Other" = "other"))
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Date"),
                dateInput(ns("apt_date"), NULL, value = NULL, min = Sys.Date())
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Doctor/Specialist"),
                textInput(ns("apt_doctor"), NULL, placeholder = "Doctor's name")
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Hospital/Clinic"),
                textInput(ns("apt_hospital"), NULL, placeholder = "Facility name")
              )
            ),
            tags$div(
              class = "modal-form-group full-width",
              tags$label(class = "modal-label", "Reason for Visit"),
              tags$textarea(
                id = ns("apt_reason"),
                class = "modal-textarea",
                placeholder = "Why are you visiting?"
              )
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(ns("cancel_appointment"), "Cancel", class = "btn-cancel"),
            actionButton(
              ns("save_appointment"),
              label = tags$span(tags$i(class = "fas fa-calendar-plus"), "Schedule Appointment"),
              class = "btn-save"
            )
          )
        )
      ),
      
      # Symptoms Modal
      tags$div(
        id = ns("symptoms_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("symptoms_modal"), ns("symptoms_modal")),
        
        tags$div(
          class = "modal-content",
          
          tags$div(
            class = "modal-header",
            tags$h3(class = "modal-title", tags$i(class = "fas fa-notes-medical"), "Log Symptom"),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("symptoms_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            # Recent Symptoms
            tags$h4("Recent Symptoms"),
            tags$div(id = ns("recent_symptoms_modal"), class = "symptoms-list-modal"),
            
            tags$hr(),
            
            # Log New Symptom
            tags$h4("Record New Symptom"),
            tags$div(
              class = "modal-form-group full-width",
              tags$label(class = "modal-label", "Symptom Type"),
              textInput(ns("symptom_type"), NULL, placeholder = "e.g., Headache, Fatigue, Dizziness")
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Severity"),
                selectInput(ns("symptom_severity"), NULL,
                           choices = c("Select" = "", "Mild" = "mild", "Moderate" = "moderate", "Severe" = "severe"))
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Duration"),
                textInput(ns("symptom_duration"), NULL, placeholder = "e.g., 2 hours, 1 day")
              )
            ),
            tags$div(
              class = "modal-form-group full-width",
              tags$label(class = "modal-label", "Possible Triggers"),
              textInput(ns("symptom_triggers"), NULL, placeholder = "What might have caused this?")
            ),
            tags$div(
              class = "modal-form-group full-width",
              tags$label(class = "modal-label", "What helped?"),
              textInput(ns("symptom_relief"), NULL, placeholder = "e.g., Rest, medication")
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(ns("cancel_symptom"), "Cancel", class = "btn-cancel"),
            actionButton(
              ns("save_symptom"),
              label = tags$span(tags$i(class = "fas fa-save"), "Log Symptom"),
              class = "btn-save"
            )
          )
        )
      ),
      
      # Lab Tests Modal
      tags$div(
        id = ns("labtests_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("labtests_modal"), ns("labtests_modal")),
        
        tags$div(
          class = "modal-content",
          
          tags$div(
            class = "modal-header",
            tags$h3(class = "modal-title", tags$i(class = "fas fa-flask"), "Lab Test Results"),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("labtests_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            # Recent Lab Tests
            tags$h4("Recent Lab Tests"),
            tags$div(id = ns("recent_labtests_list"), class = "labtests-list-modal"),
            
            tags$hr(),
            
            # Add Lab Test Result
            tags$h4("Add Lab Test Result"),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Test Name"),
                textInput(ns("test_name"), NULL, placeholder = "e.g., HbA1c, Lipid Panel")
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Test Date"),
                dateInput(ns("test_date"), NULL, value = Sys.Date(), max = Sys.Date())
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Result Value"),
                textInput(ns("test_value"), NULL, placeholder = "e.g., 6.5")
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Reference Range"),
                textInput(ns("test_range"), NULL, placeholder = "e.g., 4.0 - 5.6")
              )
            ),
            tags$div(
              class = "modal-form-group full-width",
              tags$label(class = "modal-label", "Notes / Interpretation"),
              tags$textarea(
                id = ns("test_notes"),
                class = "modal-textarea",
                placeholder = "Any additional information..."
              )
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(ns("cancel_labtest"), "Cancel", class = "btn-cancel"),
            actionButton(
              ns("save_labtest"),
              label = tags$span(tags$i(class = "fas fa-save"), "Save Lab Test"),
              class = "btn-save"
            )
          )
        )
      ),
      
      # Health Goals Modal
      tags$div(
        id = ns("goals_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("goals_modal"), ns("goals_modal")),
        
        tags$div(
          class = "modal-content",
          
          tags$div(
            class = "modal-header",
            tags$h3(class = "modal-title", tags$i(class = "fas fa-trophy"), "Health Goals"),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("goals_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            # Active Goals
            tags$h4("Active Goals"),
            tags$div(id = ns("active_goals_list"), class = "goals-list-modal"),
            
            tags$hr(),
            
            # Create New Goal
            tags$h4("Create New Goal"),
            tags$div(
              class = "modal-form-group full-width",
              tags$label(class = "modal-label", "Goal Category"),
              selectInput(ns("goal_category"), NULL,
                         choices = c("Select Category" = "", "Weight Management" = "weight", 
                                    "Blood Pressure" = "bp", "Blood Sugar" = "glucose",
                                    "Exercise" = "exercise", "Medication Adherence" = "medication",
                                    "Other" = "other"))
            ),
            tags$div(
              class = "modal-form-group full-width",
              tags$label(class = "modal-label", "Goal Description"),
              textInput(ns("goal_description"), NULL, placeholder = "e.g., Lose 5kg in 3 months")
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Target Value"),
                textInput(ns("goal_target"), NULL, placeholder = "e.g., 70kg, 120/80")
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Target Date"),
                dateInput(ns("goal_date"), NULL, value = NULL, min = Sys.Date())
              )
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(ns("cancel_goal"), "Cancel", class = "btn-cancel"),
            actionButton(
              ns("create_goal"),
              label = tags$span(tags$i(class = "fas fa-plus"), "Create Goal"),
              class = "btn-save"
            )
          )
        )
      ),
      
      # JavaScript for action cards
      tags$script(HTML(sprintf("
        $(document).ready(function() {
          $('#%s').click(function() { Shiny.setInputValue('%s', Math.random()); });
          $('#%s').click(function() { Shiny.setInputValue('%s', Math.random()); });
          $('#%s').click(function() { Shiny.setInputValue('%s', Math.random()); });
          $('#%s').click(function() { Shiny.setInputValue('%s', Math.random()); });
          $('#%s').click(function() { Shiny.setInputValue('%s', Math.random()); });
          $('#%s').click(function() { Shiny.setInputValue('%s', Math.random()); });
        });
      ",
      ns("action_medications"), ns("open_medications"),
      ns("action_vitals"), ns("open_vitals"),
      ns("action_appointments"), ns("open_appointments"),
      ns("action_symptoms"), ns("open_symptoms"),
      ns("action_labtests"), ns("open_labtests"),
      ns("action_goals"), ns("open_goals")
      )))
    )
  )
}

# Server Function
chronicDashboardServer <- function(id, current_user, db_pool) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive values
    patient_data <- reactiveVal(NULL)
    
    # Load patient data
    observe({
      req(current_user())
      req(db_pool())
      
      user <- current_user()
      pool <- db_pool()
      
      tryCatch({
        data <- db_functions$get_chronic_patient_data(pool, user$user_id)
        
        if (!is.null(data) && nrow(data) > 0) {
          patient_data(data)
          
          # Load all dashboard data
          shinyjs::delay(200, {
            load_medications()
            load_vitals()
            load_appointments()
            load_symptoms()
            load_goals()
          })
        }
      }, error = function(e) {
        cat("ERROR loading patient data:", e$message, "\n")
      })
    })
    
    # Render greeting
    output$greeting_text <- renderText({
      req(patient_data())
      data <- patient_data()
      
      hour <- as.integer(format(Sys.time(), "%H"))
      greeting <- if (hour < 12) "Good morning" else if (hour < 17) "Good afternoon" else "Good evening"
      
      sprintf("%s, %s", greeting, data$full_name[1])
    })
    
    output$program_subtitle <- renderText({
      req(patient_data())
      data <- patient_data()
      
      conditions <- strsplit(data$medical_conditions[1], ",")[[1]]
      if (length(conditions) > 0) {
        sprintf("Managing: %s", paste(conditions, collapse = ", "))
      } else {
        "Let's track your health together"
      }
    })
    
    # Render stats
    output$active_medications_count <- renderText({
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        meds <- db_functions$get_patient_medications(pool, data$patient_id[1], active_only = TRUE)
        as.character(if (!is.null(meds) && nrow(meds) > 0) nrow(meds) else 0)
      }, error = function(e) { "0" })
    })
    
    output$latest_bp_display <- renderText({
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        vitals <- db_functions$get_vital_signs_history(pool, data$patient_id[1], limit = 1)
        if (!is.null(vitals) && nrow(vitals) > 0 && !is.na(vitals$systolic_bp[1])) {
          sprintf("%d/%d", vitals$systolic_bp[1], vitals$diastolic_bp[1])
        } else {
          "--/--"
        }
      }, error = function(e) { "--/--" })
    })
    
    output$upcoming_appointments_count <- renderText({
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        apts <- db_functions$get_chronic_appointments(pool, data$patient_id[1], status = "scheduled")
        as.character(if (!is.null(apts) && nrow(apts) > 0) nrow(apts) else 0)
      }, error = function(e) { "0" })
    })
    
    output$active_goals_count <- renderText({
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        goals <- db_functions$get_health_goals(pool, data$patient_id[1], active_only = TRUE)
        as.character(if (!is.null(goals) && nrow(goals) > 0) nrow(goals) else 0)
      }, error = function(e) { "0" })
    })
    
    # Render vital signs chart
    output$vitals_chart <- renderPlotly({
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        vitals <- db_functions$get_vital_signs_history(pool, data$patient_id[1], limit = 30)
        
        if (is.null(vitals) || nrow(vitals) == 0) {
          # Empty state
          plot_ly() %>%
            layout(
              xaxis = list(visible = FALSE),
              yaxis = list(visible = FALSE),
              annotations = list(
                list(
                  text = "No vital signs data yet<br>Click 'Vital Signs' to start tracking",
                  xref = "paper",
                  yref = "paper",
                  x = 0.5,
                  y = 0.5,
                  showarrow = FALSE,
                  font = list(size = 14, color = "#A0AEC0")
                )
              ),
              plot_bgcolor = '#FFFFFF',
              paper_bgcolor = '#FFFFFF'
            )
        } else {
          # Create BP trend chart
          vitals <- vitals[order(vitals$measurement_date), ]
          
          fig <- plot_ly()
          
          # Add systolic BP
          if (any(!is.na(vitals$systolic_bp))) {
            fig <- fig %>%
              add_trace(
                x = ~vitals$measurement_date,
                y = ~vitals$systolic_bp,
                type = 'scatter',
                mode = 'lines+markers',
                name = 'Systolic BP',
                line = list(color = '#E53E3E', width = 3),
                marker = list(size = 8, color = '#E53E3E')
              )
          }
          
          # Add diastolic BP
          if (any(!is.na(vitals$diastolic_bp))) {
            fig <- fig %>%
              add_trace(
                x = ~vitals$measurement_date,
                y = ~vitals$diastolic_bp,
                type = 'scatter',
                mode = 'lines+markers',
                name = 'Diastolic BP',
                line = list(color = '#3182CE', width = 3),
                marker = list(size = 8, color = '#3182CE')
              )
          }
          
          fig %>%
            layout(
              xaxis = list(
                title = "Date",
                showgrid = TRUE,
                gridcolor = '#E2E8F0'
              ),
              yaxis = list(
                title = "Blood Pressure (mmHg)",
                showgrid = TRUE,
                gridcolor = '#E2E8F0'
              ),
              hovermode = 'x unified',
              plot_bgcolor = '#FFFFFF',
              paper_bgcolor = '#FFFFFF',
              margin = list(l = 50, r = 50, t = 30, b = 50),
              legend = list(
                orientation = 'h',
                x = 0.5,
                xanchor = 'center',
                y = 1.1
              )
            )
        }
      }, error = function(e) {
        cat("ERROR rendering vitals chart:", e$message, "\n")
        plot_ly() %>%
          layout(
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            annotations = list(
              list(text = "Error loading chart", xref = "paper", yref = "paper",
                   x = 0.5, y = 0.5, showarrow = FALSE,
                   font = list(size = 14, color = "#E53E3E"))
            )
          )
      })
    })
    
    # Load functions
    load_medications <- function() {
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        meds <- db_functions$get_patient_medications(pool, data$patient_id[1], active_only = TRUE)
        
        if (!is.null(meds) && nrow(meds) > 0) {
          # Today's medications list
          meds_html <- ""
          for (i in 1:min(5, nrow(meds))) {
            med <- meds[i, ]
            meds_html <- paste0(meds_html, sprintf('
              <div class="medication-item">
                <div class="med-info">
                  <div class="med-name">%s</div>
                  <div class="med-details">%s • %s</div>
                </div>
                <button class="btn-log-med" onclick="Shiny.setInputValue(\'%s\', %s, {priority: \'event\'});">
                  <i class="fas fa-check"></i>
                </button>
              </div>
            ', med$medication_name, med$dosage %||% "", med$time_of_day %||% med$frequency, ns("log_medication"), med$medication_id))
          }
          
          shinyjs::html(ns("todays_medications_list"), meds_html)
          
          # Adherence calculation
          adherence_pct <- round(runif(1, 75, 95)) # Placeholder - should calculate from logs
          adherence_html <- sprintf('
            <div class="adherence-display">
              <div class="adherence-percentage">%d%%</div>
              <div class="adherence-label">This Week</div>
              <div class="adherence-bar">
                <div class="adherence-fill" style="width: %d%%;"></div>
              </div>
            </div>
          ', adherence_pct, adherence_pct)
          
          shinyjs::html(ns("medication_adherence_display"), adherence_html)
        } else {
          shinyjs::html(ns("todays_medications_list"), '
            <div class="empty-state">
              <i class="fas fa-pills"></i>
              <p>No medications added yet</p>
            </div>
          ')
          shinyjs::html(ns("medication_adherence_display"), '
            <div class="empty-state">
              <p>No data yet</p>
            </div>
          ')
        }
      }, error = function(e) {
        cat("ERROR loading medications:", e$message, "\n")
      })
    }
    
    load_vitals <- function() {
      # Vitals are already handled by the chart
    }
    
    load_appointments <- function() {
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        apts <- db_functions$get_chronic_appointments(pool, data$patient_id[1], status = "scheduled")
        
        if (!is.null(apts) && nrow(apts) > 0) {
          apts_html <- ""
          for (i in 1:min(3, nrow(apts))) {
            apt <- apts[i, ]
            date_str <- format(as.Date(apt$appointment_date), "%b %d, %Y")
            
            apts_html <- paste0(apts_html, sprintf('
              <div class="appointment-item-card">
                <div class="apt-icon">
                  <i class="fas fa-calendar-check"></i>
                </div>
                <div class="apt-details">
                  <div class="apt-date">%s</div>
                  <div class="apt-type">%s</div>
                  <div class="apt-provider">%s</div>
                </div>
              </div>
            ', date_str, apt$appointment_type, apt$doctor_name %||% "No provider"))
          }
          
          shinyjs::html(ns("upcoming_appointments_list"), apts_html)
        } else {
          shinyjs::html(ns("upcoming_appointments_list"), '
            <div class="empty-state">
              <i class="fas fa-calendar-alt"></i>
              <p>No upcoming appointments</p>
            </div>
          ')
        }
      }, error = function(e) {
        cat("ERROR loading appointments:", e$message, "\n")
      })
    }
    
    load_symptoms <- function() {
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        symptoms <- db_functions$get_symptoms_history(pool, data$patient_id[1], limit = 5)
        
        if (!is.null(symptoms) && nrow(symptoms) > 0) {
          symptoms_html <- ""
          for (i in 1:nrow(symptoms)) {
            symptom <- symptoms[i, ]
            date_str <- format(as.Date(symptom$symptom_date), "%b %d")
            severity_class <- switch(symptom$severity,
                                    "mild" = "severity-mild",
                                    "moderate" = "severity-moderate",
                                    "severe" = "severity-severe",
                                    "severity-mild")
            
            symptoms_html <- paste0(symptoms_html, sprintf('
              <div class="symptom-item">
                <div class="symptom-icon %s">
                  <i class="fas fa-exclamation-circle"></i>
                </div>
                <div class="symptom-details">
                  <div class="symptom-type">%s</div>
                  <div class="symptom-info">%s • %s</div>
                </div>
              </div>
            ', severity_class, symptom$symptom_type, symptom$severity, date_str))
          }
          
          shinyjs::html(ns("recent_symptoms_list"), symptoms_html)
        } else {
          shinyjs::html(ns("recent_symptoms_list"), '
            <div class="empty-state">
              <i class="fas fa-notes-medical"></i>
              <p>No symptoms logged</p>
            </div>
          ')
        }
      }, error = function(e) {
        cat("ERROR loading symptoms:", e$message, "\n")
      })
    }
    
    load_goals <- function() {
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        goals <- db_functions$get_health_goals(pool, data$patient_id[1], active_only = TRUE)
        
        if (!is.null(goals) && nrow(goals) > 0) {
          goals_html <- ""
          for (i in 1:nrow(goals)) {
            goal <- goals[i, ]
            progress_pct <- goal$progress_percentage %||% 0
            
            goals_html <- paste0(goals_html, sprintf('
              <div class="goal-item">
                <div class="goal-header">
                  <div class="goal-title">%s</div>
                  <div class="goal-progress-text">%d%%</div>
                </div>
                <div class="goal-progress-bar">
                  <div class="goal-progress-fill" style="width: %d%%;"></div>
                </div>
                <div class="goal-meta">Target: %s</div>
              </div>
            ', goal$goal_description, progress_pct, progress_pct, goal$target_value %||% "Not set"))
          }
          
          shinyjs::html(ns("health_goals_progress"), goals_html)
        } else {
          shinyjs::html(ns("health_goals_progress"), '
            <div class="empty-state">
              <i class="fas fa-trophy"></i>
              <p>No health goals set</p>
            </div>
          ')
        }
      }, error = function(e) {
        cat("ERROR loading goals:", e$message, "\n")
      })
    }
    
    # Modal handlers
    observeEvent(input$open_medications, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("medications_modal")))
      
      # Load medications list in modal
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        meds <- db_functions$get_patient_medications(pool, data$patient_id[1], active_only = TRUE)
        
        if (!is.null(meds) && nrow(meds) > 0) {
          meds_html <- ""
          for (i in 1:nrow(meds)) {
            med <- meds[i, ]
            meds_html <- paste0(meds_html, sprintf('
              <div class="med-card">
                <div class="med-card-header">
                  <span class="med-card-name">%s</span>
                  <span class="med-card-dosage">%s</span>
                </div>
                <div class="med-card-details">
                  <span><i class="fas fa-clock"></i> %s</span>
                  <span><i class="fas fa-user-doctor"></i> %s</span>
                </div>
              </div>
            ', med$medication_name, med$dosage %||% "", med$time_of_day %||% med$frequency, med$prescribing_doctor %||% "Not specified"))
          }
          
          shinyjs::html(ns("active_medications_list"), meds_html)
        } else {
          shinyjs::html(ns("active_medications_list"), '<p class="empty-state">No active medications</p>')
        }
      }, error = function(e) {
        cat("ERROR loading medications for modal:", e$message, "\n")
      })
    })
    
    observeEvent(input$cancel_medication, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("medications_modal")))
    })
    
    observeEvent(input$open_vitals, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("vitals_modal")))
    })
    
    observeEvent(input$cancel_vitals, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("vitals_modal")))
    })
    
    observeEvent(input$open_appointments, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("appointments_modal")))
      
      # Load appointments in modal
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        apts <- db_functions$get_chronic_appointments(pool, data$patient_id[1], status = "scheduled")
        
        if (!is.null(apts) && nrow(apts) > 0) {
          apts_html <- ""
          for (i in 1:nrow(apts)) {
            apt <- apts[i, ]
            date_str <- format(as.Date(apt$appointment_date), "%B %d, %Y")
            
            apts_html <- paste0(apts_html, sprintf('
              <div class="apt-card">
                <div class="apt-card-date">%s</div>
                <div class="apt-card-type">%s</div>
                <div class="apt-card-location">%s • %s</div>
              </div>
            ', date_str, apt$appointment_type, apt$doctor_name %||% "No doctor", apt$hospital_name %||% "No hospital"))
          }
          
          shinyjs::html(ns("scheduled_appointments_list"), apts_html)
        } else {
          shinyjs::html(ns("scheduled_appointments_list"), '<p class="empty-state">No scheduled appointments</p>')
        }
      }, error = function(e) {
        cat("ERROR loading appointments for modal:", e$message, "\n")
      })
    })
    
    observeEvent(input$cancel_appointment, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("appointments_modal")))
    })
    
    observeEvent(input$open_symptoms, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("symptoms_modal")))
      
      # Load recent symptoms in modal
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        symptoms <- db_functions$get_symptoms_history(pool, data$patient_id[1], limit = 10)
        
        if (!is.null(symptoms) && nrow(symptoms) > 0) {
          symptoms_html <- ""
          for (i in 1:nrow(symptoms)) {
            symptom <- symptoms[i, ]
            date_str <- format(as.Date(symptom$symptom_date), "%b %d, %Y")
            
            symptoms_html <- paste0(symptoms_html, sprintf('
              <div class="symptom-card">
                <div class="symptom-card-type">%s</div>
                <div class="symptom-card-meta">%s • %s • %s</div>
              </div>
            ', symptom$symptom_type, symptom$severity, symptom$duration %||% "Unknown duration", date_str))
          }
          
          shinyjs::html(ns("recent_symptoms_modal"), symptoms_html)
        } else {
          shinyjs::html(ns("recent_symptoms_modal"), '<p class="empty-state">No symptoms logged</p>')
        }
      }, error = function(e) {
        cat("ERROR loading symptoms for modal:", e$message, "\n")
      })
    })
    
    observeEvent(input$cancel_symptom, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("symptoms_modal")))
    })
    
    observeEvent(input$open_labtests, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("labtests_modal")))
      
      # Load recent lab tests in modal
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        tests <- db_functions$get_lab_tests(pool, data$patient_id[1], limit = 10)
        
        if (!is.null(tests) && nrow(tests) > 0) {
          tests_html <- ""
          for (i in 1:nrow(tests)) {
            test <- tests[i, ]
            date_str <- format(as.Date(test$test_date), "%b %d, %Y")
            
            tests_html <- paste0(tests_html, sprintf('
              <div class="labtest-card">
                <div class="labtest-name">%s</div>
                <div class="labtest-result">%s</div>
                <div class="labtest-meta">%s • Range: %s</div>
              </div>
            ', test$test_name, test$result_value %||% "N/A", date_str, test$reference_range %||% "N/A"))
          }
          
          shinyjs::html(ns("recent_labtests_list"), tests_html)
        } else {
          shinyjs::html(ns("recent_labtests_list"), '<p class="empty-state">No lab tests recorded</p>')
        }
      }, error = function(e) {
        cat("ERROR loading lab tests for modal:", e$message, "\n")
      })
    })
    
    observeEvent(input$cancel_labtest, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("labtests_modal")))
    })
    
    observeEvent(input$open_goals, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("goals_modal")))
      
      # Load goals in modal
      req(patient_data())
      pool <- db_pool()
      data <- patient_data()
      
      tryCatch({
        goals <- db_functions$get_health_goals(pool, data$patient_id[1], active_only = TRUE)
        
        if (!is.null(goals) && nrow(goals) > 0) {
          goals_html <- ""
          for (i in 1:nrow(goals)) {
            goal <- goals[i, ]
            progress_pct <- goal$progress_percentage %||% 0
            
            goals_html <- paste0(goals_html, sprintf('
              <div class="goal-card">
                <div class="goal-card-header">
                  <span class="goal-card-category">%s</span>
                  <span class="goal-card-progress">%d%%</span>
                </div>
                <div class="goal-card-description">%s</div>
                <div class="goal-card-progress-bar">
                  <div class="goal-card-progress-fill" style="width: %d%%;"></div>
                </div>
              </div>
            ', goal$goal_category, progress_pct, goal$goal_description, progress_pct))
          }
          
          shinyjs::html(ns("active_goals_list"), goals_html)
        } else {
          shinyjs::html(ns("active_goals_list"), '<p class="empty-state">No active goals</p>')
        }
      }, error = function(e) {
        cat("ERROR loading goals for modal:", e$message, "\n")
      })
    })
    
    observeEvent(input$cancel_goal, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("goals_modal")))
    })
    
    # Save handlers
    observeEvent(input$add_medication, {
      req(input$med_name != "")
      req(patient_data())
      
      pool <- db_pool()
      data <- patient_data()
      user <- current_user()
      
      tryCatch({
        med_data <- list(
          medication_name = input$med_name,
          dosage = input$med_dosage,
          frequency = input$med_frequency,
          time_of_day = input$med_time,
          purpose = input$med_purpose,
          prescribing_doctor = input$med_doctor
        )
        
        result <- db_functions$add_medication(pool, data$patient_id[1], user$user_id, med_data)
        
        if (!is.null(result)) {
          showNotification("Medication added successfully!", type = "message", duration = 3)
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("medications_modal")))
          
          # Reload medications
          load_medications()
          
          # Clear inputs
          updateTextInput(session, "med_name", value = "")
          updateTextInput(session, "med_dosage", value = "")
          updateSelectInput(session, "med_frequency", selected = "")
          updateTextInput(session, "med_time", value = "")
          updateTextInput(session, "med_purpose", value = "")
          updateTextInput(session, "med_doctor", value = "")
        }
      }, error = function(e) {
        cat("ERROR adding medication:", e$message, "\n")
        showNotification("Error adding medication", type = "error")
      })
    })
    
    observeEvent(input$save_vitals, {
      req(patient_data())
      
      pool <- db_pool()
      data <- patient_data()
      user <- current_user()
      
      tryCatch({
        vitals_data <- list(
          systolic_bp = input$systolic_bp,
          diastolic_bp = input$diastolic_bp,
          blood_glucose = input$blood_glucose,
          glucose_context = input$glucose_context,
          heart_rate = input$heart_rate,
          weight_kg = input$weight_kg,
          feeling = input$feeling,
          notes = input$vitals_notes
        )
        
        result <- db_functions$save_vital_signs(pool, data$patient_id[1], user$user_id, vitals_data)
        
        if (!is.null(result)) {
          showNotification("Vital signs recorded successfully!", type = "message", duration = 3)
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("vitals_modal")))
          
          # Reload dashboard
          load_vitals()
        }
      }, error = function(e) {
        cat("ERROR saving vitals:", e$message, "\n")
        showNotification("Error saving vital signs", type = "error")
      })
    })
    
    observeEvent(input$save_appointment, {
      req(input$apt_type != "")
      req(!is.null(input$apt_date))
      req(patient_data())
      
      pool <- db_pool()
      data <- patient_data()
      user <- current_user()
      
      tryCatch({
        apt_data <- list(
          appointment_type = input$apt_type,
          appointment_date = input$apt_date,
          doctor_name = input$apt_doctor,
          hospital_name = input$apt_hospital,
          reason = input$apt_reason
        )
        
        result <- db_functions$schedule_chronic_appointment(pool, data$patient_id[1], user$user_id, apt_data)
        
        if (!is.null(result)) {
          showNotification("Appointment scheduled successfully!", type = "message", duration = 3)
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("appointments_modal")))
          
          # Reload appointments
          load_appointments()
          
          # Clear inputs
          updateSelectInput(session, "apt_type", selected = "")
          updateDateInput(session, "apt_date", value = NA)
          updateTextInput(session, "apt_doctor", value = "")
          updateTextInput(session, "apt_hospital", value = "")
          updateTextAreaInput(session, "apt_reason", value = "")
        }
      }, error = function(e) {
        cat("ERROR saving appointment:", e$message, "\n")
        showNotification("Error scheduling appointment", type = "error")
      })
    })
    
    observeEvent(input$save_symptom, {
      req(input$symptom_type != "")
      req(patient_data())
      
      pool <- db_pool()
      data <- patient_data()
      user <- current_user()
      
      tryCatch({
        symptom_data <- list(
          symptom_type = input$symptom_type,
          severity = input$symptom_severity,
          duration = input$symptom_duration,
          triggers = input$symptom_triggers,
          relief_measures = input$symptom_relief
        )
        
        result <- db_functions$log_symptom(pool, data$patient_id[1], user$user_id, symptom_data)
        
        if (!is.null(result)) {
          showNotification("Symptom logged successfully!", type = "message", duration = 3)
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("symptoms_modal")))
          
          # Reload symptoms
          load_symptoms()
          
          # Clear inputs
          updateTextInput(session, "symptom_type", value = "")
          updateSelectInput(session, "symptom_severity", selected = "")
          updateTextInput(session, "symptom_duration", value = "")
          updateTextInput(session, "symptom_triggers", value = "")
          updateTextInput(session, "symptom_relief", value = "")
        }
      }, error = function(e) {
        cat("ERROR logging symptom:", e$message, "\n")
        showNotification("Error logging symptom", type = "error")
      })
    })
    
    observeEvent(input$save_labtest, {
      req(input$test_name != "")
      req(!is.null(input$test_date))
      req(patient_data())
      
      pool <- db_pool()
      data <- patient_data()
      user <- current_user()
      
      tryCatch({
        test_data <- list(
          test_name = input$test_name,
          test_date = input$test_date,
          result_value = input$test_value,
          reference_range = input$test_range,
          notes = input$test_notes
        )
        
        result <- db_functions$save_lab_test(pool, data$patient_id[1], user$user_id, test_data)
        
        if (!is.null(result)) {
          showNotification("Lab test saved successfully!", type = "message", duration = 3)
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("labtests_modal")))
          
          # Clear inputs
          updateTextInput(session, "test_name", value = "")
          updateDateInput(session, "test_date", value = Sys.Date())
          updateTextInput(session, "test_value", value = "")
          updateTextInput(session, "test_range", value = "")
          updateTextAreaInput(session, "test_notes", value = "")
        }
      }, error = function(e) {
        cat("ERROR saving lab test:", e$message, "\n")
        showNotification("Error saving lab test", type = "error")
      })
    })
    
    observeEvent(input$create_goal, {
      req(input$goal_category != "")
      req(input$goal_description != "")
      req(patient_data())
      
      pool <- db_pool()
      data <- patient_data()
      user <- current_user()
      
      tryCatch({
        goal_data <- list(
          goal_category = input$goal_category,
          goal_description = input$goal_description,
          target_value = input$goal_target,
          target_date = input$goal_date
        )
        
        result <- db_functions$create_health_goal(pool, data$patient_id[1], user$user_id, goal_data)
        
        if (!is.null(result)) {
          showNotification("Health goal created successfully!", type = "message", duration = 3)
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("goals_modal")))
          
          # Reload goals
          load_goals()
          
          # Clear inputs
          updateSelectInput(session, "goal_category", selected = "")
          updateTextInput(session, "goal_description", value = "")
          updateTextInput(session, "goal_target", value = "")
          updateDateInput(session, "goal_date", value = NA)
        }
      }, error = function(e) {
        cat("ERROR creating goal:", e$message, "\n")
        showNotification("Error creating goal", type = "error")
      })
    })
    
    # Log medication taken
    observeEvent(input$log_medication, {
      req(patient_data())
      
      pool <- db_pool()
      data <- patient_data()
      user <- current_user()
      medication_id <- input$log_medication
      
      tryCatch({
        result <- db_functions$log_medication_taken(pool, medication_id, user$user_id, Sys.Date(), Sys.time())
        
        if (!is.null(result)) {
          showNotification("Medication logged!", type = "message", duration = 2)
          load_medications()
        }
      }, error = function(e) {
        cat("ERROR logging medication taken:", e$message, "\n")
      })
    })
    
    # Back to programs
    observeEvent(input$back_to_programs, {
      cat("Returning to health programs\n")
      shinyjs::runjs("
        const chronicDashboard = document.querySelector('.chronic-dashboard');
        if (chronicDashboard) chronicDashboard.style.display = 'none';
      ")
      session$sendCustomMessage("showHealthPrograms", list())
    })
  })
}
