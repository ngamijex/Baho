# Chronic Disease Dashboard Module (Baho for Life)
# Comprehensive dashboard for chronic disease management

library(shiny)
library(shinyjs)
library(plotly)

chronicDashboardUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    useShinyjs(),
    
    # Main Dashboard Container (hidden by default)
    tags$div(
      class = "chronic-dashboard",
      style = "display: none;",
      
      # Dashboard Header
      tags$div(
        class = "dashboard-header",
        tags$div(
          class = "header-content",
          tags$h1(class = "dashboard-title", "🏥 Baho for Life Dashboard"),
          uiOutput(ns("greeting_text")),
          actionButton(
            inputId = ns("back_to_programs"),
            label = tagList(
              tags$i(class = "fas fa-arrow-left"),
              "Back to Programs"
            ),
            class = "btn-back"
          )
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
            tags$div(class = "stat-value", uiOutput(ns("active_medications_display"))),
            tags$div(class = "stat-label", "Active Medications")
          )
        ),
        
        tags$div(
          class = "stat-card stat-vitals",
          tags$div(class = "stat-icon", tags$i(class = "fas fa-heart-pulse")),
          tags$div(
            class = "stat-content",
            tags$div(class = "stat-value", uiOutput(ns("latest_bp_display"))),
            tags$div(class = "stat-label", "Latest Blood Pressure")
          )
        ),
        
        tags$div(
          class = "stat-card stat-appointments",
          tags$div(class = "stat-icon", tags$i(class = "fas fa-calendar-check")),
          tags$div(
            class = "stat-content",
            tags$div(class = "stat-value", uiOutput(ns("upcoming_appointments_display"))),
            tags$div(class = "stat-label", "Upcoming Appointments")
          )
        ),
        
        tags$div(
          class = "stat-card stat-goals",
          tags$div(class = "stat-icon", tags$i(class = "fas fa-bullseye")),
          tags$div(
            class = "stat-content",
            tags$div(class = "stat-value", uiOutput(ns("active_goals_display"))),
            tags$div(class = "stat-label", "Active Health Goals")
          )
        )
      ),
      
      # Quick Actions Grid
      tags$div(
        class = "quick-actions-section",
        tags$h2(class = "section-title", "Quick Actions"),
        
        tags$div(
          class = "quick-actions-grid chronic-actions",
          
          tags$div(
            class = "action-card",
            id = ns("action_medications_card"),
            tags$div(class = "action-icon", tags$i(class = "fas fa-pills")),
            tags$h3(class = "action-title", "Medications"),
            tags$p(class = "action-description", "Track & log your medications")
          ),
          
          tags$div(
            class = "action-card",
            id = ns("action_vitals_card"),
            tags$div(class = "action-icon", tags$i(class = "fas fa-heartbeat")),
            tags$h3(class = "action-title", "Vital Signs"),
            tags$p(class = "action-description", "Record blood pressure, glucose, etc.")
          ),
          
          tags$div(
            class = "action-card",
            id = ns("action_appointments_card"),
            tags$div(class = "action-icon", tags$i(class = "fas fa-calendar-alt")),
            tags$h3(class = "action-title", "Appointments"),
            tags$p(class = "action-description", "Schedule & manage appointments")
          ),
          
          tags$div(
            class = "action-card",
            id = ns("action_symptoms_card"),
            tags$div(class = "action-icon", tags$i(class = "fas fa-notes-medical")),
            tags$h3(class = "action-title", "Symptoms"),
            tags$p(class = "action-description", "Log symptoms & track patterns")
          ),
          
          tags$div(
            class = "action-card",
            id = ns("action_labtests_card"),
            tags$div(class = "action-icon", tags$i(class = "fas fa-flask")),
            tags$h3(class = "action-title", "Lab Tests"),
            tags$p(class = "action-description", "Record test results & reports")
          ),
          
          tags$div(
            class = "action-card",
            id = ns("action_goals_card"),
            tags$div(class = "action-icon", tags$i(class = "fas fa-trophy")),
            tags$h3(class = "action-title", "Health Goals"),
            tags$p(class = "action-description", "Set & track your health goals")
          )
        )
      ),
      
      # Vital Signs Chart Section
      tags$div(
        class = "chart-section",
        tags$h2(class = "section-title", "📊 Vital Signs Trends"),
        plotlyOutput(ns("vitals_chart"), height = "400px")
      ),
      
      # Recent Activity Section
      tags$div(
        class = "recent-activity-section",
        
        tags$div(
          class = "activity-column",
          tags$h3(class = "section-subtitle", "💊 Today's Medications"),
          uiOutput(ns("todays_medications"))
        ),
        
        tags$div(
          class = "activity-column",
          tags$h3(class = "section-subtitle", "📅 Upcoming Appointments"),
          uiOutput(ns("upcoming_appointments"))
        )
      ),
      
      # Modals
      # Medications Modal
      tags$div(
        id = ns("medications_modal"),
        class = "modal-overlay",
        style = "display: none;",
        tags$div(
          class = "modal-content chronic-modal",
          tags$div(
            class = "modal-header",
            tags$h2(class = "modal-title", "💊 Medication Tracker"),
            actionButton(ns("close_medications"), "", icon = icon("times"), class = "modal-close")
          ),
          tags$div(
            class = "modal-body",
            
            # Active Medications List
            tags$h3("Active Medications"),
            uiOutput(ns("active_medications_list")),
            
            tags$hr(),
            
            # Add New Medication
            tags$h3("Add New Medication"),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Medication Name *"),
                textInput(ns("med_name"), NULL, placeholder = "e.g., Metformin", width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Dosage"),
                textInput(ns("med_dosage"), NULL, placeholder = "e.g., 500mg", width = "100%")
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Frequency"),
                selectInput(ns("med_frequency"), NULL, 
                           choices = c("Select" = "", "Once daily" = "once", "Twice daily" = "twice", 
                                      "Three times daily" = "three", "As needed" = "asneeded"),
                           width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Time of Day"),
                textInput(ns("med_time"), NULL, placeholder = "e.g., Morning, Evening", width = "100%")
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Purpose"),
                textInput(ns("med_purpose"), NULL, placeholder = "What is this for?", width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Prescribing Doctor"),
                textInput(ns("med_doctor"), NULL, placeholder = "Doctor's name", width = "100%")
              )
            ),
            actionButton(ns("add_medication"), "Add Medication", class = "btn-primary", icon = icon("plus"))
          )
        )
      ),
      
      # Vital Signs Modal
      tags$div(
        id = ns("vitals_modal"),
        class = "modal-overlay",
        style = "display: none;",
        tags$div(
          class = "modal-content chronic-modal",
          tags$div(
            class = "modal-header",
            tags$h2(class = "modal-title", "❤️ Record Vital Signs"),
            actionButton(ns("close_vitals"), "", icon = icon("times"), class = "modal-close")
          ),
          tags$div(
            class = "modal-body",
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Blood Pressure (Systolic)"),
                numericInput(ns("systolic_bp"), NULL, value = NULL, min = 60, max = 250, width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Blood Pressure (Diastolic)"),
                numericInput(ns("diastolic_bp"), NULL, value = NULL, min = 40, max = 150, width = "100%")
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Blood Glucose (mg/dL)"),
                numericInput(ns("blood_glucose"), NULL, value = NULL, min = 20, max = 600, width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Glucose Context"),
                selectInput(ns("glucose_context"), NULL,
                           choices = c("Select" = "", "Fasting" = "fasting", "Before meal" = "before", 
                                      "After meal" = "after", "Bedtime" = "bedtime"),
                           width = "100%")
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Heart Rate (bpm)"),
                numericInput(ns("heart_rate"), NULL, value = NULL, min = 30, max = 200, width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Weight (kg)"),
                numericInput(ns("weight_kg"), NULL, value = NULL, min = 20, max = 300, width = "100%")
              )
            ),
            tags$div(
              class = "form-group",
              tags$label("How are you feeling?"),
              selectInput(ns("feeling"), NULL,
                         choices = c("Select" = "", "Great" = "great", "Good" = "good", 
                                    "Fair" = "fair", "Poor" = "poor"),
                         width = "100%")
            ),
            tags$div(
              class = "form-group",
              tags$label("Notes"),
              textAreaInput(ns("vitals_notes"), NULL, placeholder = "Any additional notes...", rows = 2, width = "100%")
            ),
            actionButton(ns("save_vitals"), "Save Vital Signs", class = "btn-success", icon = icon("save"))
          )
        )
      ),
      
      # Appointments Modal
      tags$div(
        id = ns("appointments_modal"),
        class = "modal-overlay",
        style = "display: none;",
        tags$div(
          class = "modal-content chronic-modal",
          tags$div(
            class = "modal-header",
            tags$h2(class = "modal-title", "📅 Schedule Appointment"),
            actionButton(ns("close_appointments"), "", icon = icon("times"), class = "modal-close")
          ),
          tags$div(
            class = "modal-body",
            uiOutput(ns("scheduled_appointments")),
            tags$hr(),
            tags$h3("Schedule New Appointment"),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Appointment Type *"),
                selectInput(ns("apt_type"), NULL,
                           choices = c("Select Type" = "", "Check-up" = "checkup", "Follow-up" = "followup",
                                      "Specialist" = "specialist", "Lab Test" = "labtest", "Other" = "other"),
                           width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Date *"),
                dateInput(ns("apt_date"), NULL, value = NULL, min = Sys.Date(), width = "100%")
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Doctor/Specialist"),
                textInput(ns("apt_doctor"), NULL, placeholder = "Doctor's name", width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Hospital/Clinic"),
                textInput(ns("apt_hospital"), NULL, placeholder = "Facility name", width = "100%")
              )
            ),
            tags$div(
              class = "form-group",
              tags$label("Reason for Visit"),
              textAreaInput(ns("apt_reason"), NULL, placeholder = "Why are you visiting?", rows = 2, width = "100%")
            ),
            actionButton(ns("save_appointment"), "Schedule Appointment", class = "btn-success", icon = icon("calendar-plus"))
          )
        )
      ),
      
      # Symptoms Modal
      tags$div(
        id = ns("symptoms_modal"),
        class = "modal-overlay",
        style = "display: none;",
        tags$div(
          class = "modal-content chronic-modal",
          tags$div(
            class = "modal-header",
            tags$h2(class = "modal-title", "🩺 Log Symptom"),
            actionButton(ns("close_symptoms"), "", icon = icon("times"), class = "modal-close")
          ),
          tags$div(
            class = "modal-body",
            uiOutput(ns("recent_symptoms")),
            tags$hr(),
            tags$h3("Record New Symptom"),
            tags$div(
              class = "form-group",
              tags$label("Symptom Type *"),
              textInput(ns("symptom_type"), NULL, placeholder = "e.g., Headache, Fatigue, Dizziness", width = "100%")
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Severity"),
                selectInput(ns("symptom_severity"), NULL,
                           choices = c("Select" = "", "Mild" = "mild", "Moderate" = "moderate", "Severe" = "severe"),
                           width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Duration"),
                textInput(ns("symptom_duration"), NULL, placeholder = "e.g., 2 hours, 1 day", width = "100%")
              )
            ),
            tags$div(
              class = "form-group",
              tags$label("Possible Triggers"),
              textInput(ns("symptom_triggers"), NULL, placeholder = "What might have caused this?", width = "100%")
            ),
            tags$div(
              class = "form-group",
              tags$label("What helped?"),
              textInput(ns("symptom_relief"), NULL, placeholder = "e.g., Rest, medication", width = "100%")
            ),
            actionButton(ns("save_symptom"), "Log Symptom", class = "btn-primary", icon = icon("save"))
          )
        )
      ),
      
      # Lab Tests Modal
      tags$div(
        id = ns("labtests_modal"),
        class = "modal-overlay",
        style = "display: none;",
        tags$div(
          class = "modal-content chronic-modal",
          tags$div(
            class = "modal-header",
            tags$h2(class = "modal-title", "🧪 Lab Test Results"),
            actionButton(ns("close_labtests"), "", icon = icon("times"), class = "modal-close")
          ),
          tags$div(
            class = "modal-body",
            uiOutput(ns("recent_labtests")),
            tags$hr(),
            tags$h3("Add Lab Test Result"),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Test Name *"),
                textInput(ns("test_name"), NULL, placeholder = "e.g., HbA1c, Lipid Panel", width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Test Date *"),
                dateInput(ns("test_date"), NULL, value = Sys.Date(), max = Sys.Date(), width = "100%")
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Result Value"),
                textInput(ns("test_value"), NULL, placeholder = "e.g., 6.5", width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Reference Range"),
                textInput(ns("test_range"), NULL, placeholder = "e.g., 4.0 - 5.6", width = "100%")
              )
            ),
            tags$div(
              class = "form-group",
              tags$label("Notes / Interpretation"),
              textAreaInput(ns("test_notes"), NULL, placeholder = "Any additional information...", rows = 2, width = "100%")
            ),
            actionButton(ns("save_labtest"), "Save Lab Test", class = "btn-success", icon = icon("save"))
          )
        )
      ),
      
      # Health Goals Modal
      tags$div(
        id = ns("goals_modal"),
        class = "modal-overlay",
        style = "display: none;",
        tags$div(
          class = "modal-content chronic-modal",
          tags$div(
            class = "modal-header",
            tags$h2(class = "modal-title", "🎯 Health Goals"),
            actionButton(ns("close_goals"), "", icon = icon("times"), class = "modal-close")
          ),
          tags$div(
            class = "modal-body",
            uiOutput(ns("active_goals_list")),
            tags$hr(),
            tags$h3("Create New Goal"),
            tags$div(
              class = "form-group",
              tags$label("Goal Category *"),
              selectInput(ns("goal_category"), NULL,
                         choices = c("Select Category" = "", "Weight Management" = "weight", 
                                    "Blood Pressure" = "bp", "Blood Sugar" = "glucose",
                                    "Exercise" = "exercise", "Medication Adherence" = "medication",
                                    "Other" = "other"),
                         width = "100%")
            ),
            tags$div(
              class = "form-group",
              tags$label("Goal Description *"),
              textInput(ns("goal_description"), NULL, placeholder = "e.g., Lose 5kg in 3 months", width = "100%")
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "form-group",
                tags$label("Target Value"),
                textInput(ns("goal_target"), NULL, placeholder = "e.g., 70kg, 120/80", width = "100%")
              ),
              tags$div(
                class = "form-group",
                tags$label("Target Date"),
                dateInput(ns("goal_date"), NULL, value = NULL, min = Sys.Date(), width = "100%")
              )
            ),
            actionButton(ns("create_goal"), "Create Goal", class = "btn-primary", icon = icon("plus"))
          )
        )
      ),
      
      # JavaScript for clickable action cards
      tags$head(
        tags$script(HTML(sprintf("
          $(document).ready(function() {
            $('#%s').on('click', function() {
              Shiny.setInputValue('%s', Math.random());
            });
            $('#%s').on('click', function() {
              Shiny.setInputValue('%s', Math.random());
            });
            $('#%s').on('click', function() {
              Shiny.setInputValue('%s', Math.random());
            });
            $('#%s').on('click', function() {
              Shiny.setInputValue('%s', Math.random());
            });
            $('#%s').on('click', function() {
              Shiny.setInputValue('%s', Math.random());
            });
            $('#%s').on('click', function() {
              Shiny.setInputValue('%s', Math.random());
            });
          });
        ",
        ns("action_medications_card"), ns("open_medications"),
        ns("action_vitals_card"), ns("open_vitals"),
        ns("action_appointments_card"), ns("open_appointments"),
        ns("action_symptoms_card"), ns("open_symptoms"),
        ns("action_labtests_card"), ns("open_labtests"),
        ns("action_goals_card"), ns("open_goals")
        )))
      )
    )
  )
}

chronicDashboardServer <- function(id, current_user, db_conn) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive values
    patient_data <- reactiveVal(NULL)
    active_medications <- reactiveVal(NULL)
    vitals_history <- reactiveVal(NULL)
    upcoming_appointments_data <- reactiveVal(NULL)
    health_goals <- reactiveVal(NULL)
    
    # Load patient data when dashboard is accessed
    load_patient_data <- function() {
      pool <- db_conn
      user <- current_user
      
      if (!is.null(pool) && !is.null(user)) {
        tryCatch({
          data <- db_functions$get_chronic_patient_data(pool, user$user_id)
          if (nrow(data) > 0) {
            patient_data(data)
            load_medications()
            load_vitals_history()
            load_appointments()
            load_goals()
          }
        }, error = function(e) {
          cat("Error loading patient data:", e$message, "\n")
        })
      }
    }
    
    # Load medications
    load_medications <- function() {
      data <- patient_data()
      if (!is.null(data) && nrow(data) > 0) {
        tryCatch({
          meds <- db_functions$get_patient_medications(db_conn, data$patient_id[1], active_only = TRUE)
          active_medications(meds)
        }, error = function(e) {
          cat("Error loading medications:", e$message, "\n")
        })
      }
    }
    
    # Load vitals history
    load_vitals_history <- function() {
      data <- patient_data()
      if (!is.null(data) && nrow(data) > 0) {
        tryCatch({
          vitals <- db_functions$get_vital_signs_history(db_conn, data$patient_id[1], limit = 30)
          vitals_history(vitals)
        }, error = function(e) {
          cat("Error loading vitals:", e$message, "\n")
        })
      }
    }
    
    # Load appointments
    load_appointments <- function() {
      data <- patient_data()
      if (!is.null(data) && nrow(data) > 0) {
        tryCatch({
          apts <- db_functions$get_chronic_appointments(db_conn, data$patient_id[1], status = "scheduled")
          upcoming_appointments_data(apts)
        }, error = function(e) {
          cat("Error loading appointments:", e$message, "\n")
        })
      }
    }
    
    # Load health goals
    load_goals <- function() {
      data <- patient_data()
      if (!is.null(data) && nrow(data) > 0) {
        tryCatch({
          goals <- db_functions$get_health_goals(db_conn, data$patient_id[1], active_only = TRUE)
          health_goals(goals)
        }, error = function(e) {
          cat("Error loading goals:", e$message, "\n")
        })
      }
    }
    
    # Initialize data load
    observe({
      load_patient_data()
    })
    
    # Greeting text
    output$greeting_text <- renderUI({
      data <- patient_data()
      if (!is.null(data) && nrow(data) > 0) {
        hour <- as.numeric(format(Sys.time(), "%H"))
        greeting <- if (hour < 12) "Good Morning" else if (hour < 18) "Good Afternoon" else "Good Evening"
        tags$p(class = "dashboard-subtitle", paste0(greeting, ", ", data$full_name[1], "! 👋"))
      } else {
        tags$p(class = "dashboard-subtitle", "Welcome to your health dashboard!")
      }
    })
    
    # Dashboard stats
    output$active_medications_display <- renderUI({
      meds <- active_medications()
      count <- if (!is.null(meds) && nrow(meds) > 0) nrow(meds) else 0
      tags$span(count)
    })
    
    output$latest_bp_display <- renderUI({
      vitals <- vitals_history()
      if (!is.null(vitals) && nrow(vitals) > 0) {
        latest <- vitals[1, ]
        if (!is.na(latest$systolic_bp) && !is.na(latest$diastolic_bp)) {
          tags$span(paste0(latest$systolic_bp, "/", latest$diastolic_bp))
        } else {
          tags$span("--/--")
        }
      } else {
        tags$span("--/--")
      }
    })
    
    output$upcoming_appointments_display <- renderUI({
      apts <- upcoming_appointments_data()
      count <- if (!is.null(apts) && nrow(apts) > 0) nrow(apts) else 0
      tags$span(count)
    })
    
    output$active_goals_display <- renderUI({
      goals <- health_goals()
      count <- if (!is.null(goals) && nrow(goals) > 0) nrow(goals) else 0
      tags$span(count)
    })
    
    # Vital signs chart
    output$vitals_chart <- renderPlotly({
      vitals <- vitals_history()
      
      if (is.null(vitals) || nrow(vitals) == 0) {
        plot_ly() %>%
          layout(
            title = "No vital signs data yet",
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            annotations = list(
              text = "Start tracking your vital signs!",
              xref = "paper", yref = "paper",
              x = 0.5, y = 0.5,
              showarrow = FALSE,
              font = list(size = 16, color = "#888")
            )
          )
      } else {
        # Create traces for different vitals
        vitals <- vitals[order(vitals$measurement_date), ]
        
        p <- plot_ly()
        
        # Blood Pressure
        if (any(!is.na(vitals$systolic_bp))) {
          p <- p %>% add_trace(
            x = vitals$measurement_date,
            y = vitals$systolic_bp,
            type = "scatter",
            mode = "lines+markers",
            name = "Systolic BP",
            line = list(color = "#E74C3C")
          ) %>% add_trace(
            x = vitals$measurement_date,
            y = vitals$diastolic_bp,
            type = "scatter",
            mode = "lines+markers",
            name = "Diastolic BP",
            line = list(color = "#3498DB")
          )
        }
        
        p %>% layout(
          title = "Blood Pressure Trends",
          xaxis = list(title = "Date"),
          yaxis = list(title = "mmHg"),
          hovermode = "x unified",
          legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.2)
        )
      }
    })
    
    # Today's medications
    output$todays_medications <- renderUI({
      meds <- active_medications()
      
      if (is.null(meds) || nrow(meds) == 0) {
        tags$p(class = "empty-state", "No active medications")
      } else {
        lapply(1:min(5, nrow(meds)), function(i) {
          med <- meds[i, ]
          tags$div(
            class = "medication-item",
            tags$div(
              class = "med-info",
              tags$strong(med$medication_name),
              tags$span(class = "med-dosage", med$dosage %||% ""),
              tags$span(class = "med-frequency", med$frequency %||% "")
            ),
            actionButton(
              inputId = ns(paste0("log_med_", med$medication_id)),
              label = "✓",
              class = "btn-log-med",
              onclick = sprintf("Shiny.setInputValue('%s', %s, {priority: 'event'});",
                              ns("med_logged"), med$medication_id)
            )
          )
        })
      }
    })
    
    # Upcoming appointments
    output$upcoming_appointments <- renderUI({
      apts <- upcoming_appointments_data()
      
      if (is.null(apts) || nrow(apts) == 0) {
        tags$p(class = "empty-state", "No upcoming appointments")
      } else {
        lapply(1:min(3, nrow(apts)), function(i) {
          apt <- apts[i, ]
          tags$div(
            class = "appointment-item",
            tags$div(class = "apt-date", format(as.Date(apt$appointment_date), "%b %d, %Y")),
            tags$div(class = "apt-type", apt$appointment_type),
            tags$div(class = "apt-doctor", apt$doctor_name %||% "")
          )
        })
      }
    })
    
    # Modal handlers
    observeEvent(input$open_medications, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex';", ns("medications_modal")))
      load_medications()
    })
    
    observeEvent(input$close_medications, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none';", ns("medications_modal")))
    })
    
    observeEvent(input$open_vitals, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex';", ns("vitals_modal")))
    })
    
    observeEvent(input$close_vitals, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none';", ns("vitals_modal")))
    })
    
    observeEvent(input$open_appointments, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex';", ns("appointments_modal")))
      load_appointments()
    })
    
    observeEvent(input$close_appointments, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none';", ns("appointments_modal")))
    })
    
    observeEvent(input$open_symptoms, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex';", ns("symptoms_modal")))
    })
    
    observeEvent(input$close_symptoms, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none';", ns("symptoms_modal")))
    })
    
    observeEvent(input$open_labtests, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex';", ns("labtests_modal")))
    })
    
    observeEvent(input$close_labtests, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none';", ns("labtests_modal")))
    })
    
    observeEvent(input$open_goals, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex';", ns("goals_modal")))
      load_goals()
    })
    
    observeEvent(input$close_goals, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none';", ns("goals_modal")))
    })
    
    # Add medication
    observeEvent(input$add_medication, {
      if (input$med_name == "") {
        showNotification("Please enter medication name", type = "error")
        return()
      }
      
      data <- patient_data()
      user <- current_user
      
      if (!is.null(data) && nrow(data) > 0) {
        med_data <- list(
          medication_name = input$med_name,
          dosage = input$med_dosage,
          frequency = input$med_frequency,
          time_of_day = input$med_time,
          purpose = input$med_purpose,
          prescribing_doctor = input$med_doctor
        )
        
        result <- db_functions$add_medication(db_conn, data$patient_id[1], user$user_id, med_data)
        
        if (!is.null(result)) {
          showNotification("✅ Medication added successfully!", type = "message")
          load_medications()
          updateTextInput(session, "med_name", value = "")
          updateTextInput(session, "med_dosage", value = "")
          updateSelectInput(session, "med_frequency", selected = "")
        } else {
          showNotification("Error adding medication", type = "error")
        }
      }
    })
    
    # Save vital signs
    observeEvent(input$save_vitals, {
      data <- patient_data()
      user <- current_user
      
      if (!is.null(data) && nrow(data) > 0) {
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
        
        result <- db_functions$save_vital_signs(db_conn, data$patient_id[1], user$user_id, vitals_data)
        
        if (!is.null(result)) {
          showNotification("✅ Vital signs recorded!", type = "message")
          load_vitals_history()
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none';", ns("vitals_modal")))
        } else {
          showNotification("Error saving vital signs", type = "error")
        }
      }
    })
    
    # Save appointment
    observeEvent(input$save_appointment, {
      if (input$apt_type == "" || is.null(input$apt_date)) {
        showNotification("Please fill in required fields", type = "error")
        return()
      }
      
      data <- patient_data()
      user <- current_user
      
      if (!is.null(data) && nrow(data) > 0) {
        apt_data <- list(
          appointment_type = input$apt_type,
          appointment_date = input$apt_date,
          doctor_name = input$apt_doctor,
          hospital_name = input$apt_hospital,
          reason = input$apt_reason
        )
        
        result <- db_functions$schedule_chronic_appointment(db_conn, data$patient_id[1], user$user_id, apt_data)
        
        if (!is.null(result)) {
          showNotification("✅ Appointment scheduled!", type = "message")
          load_appointments()
          updateSelectInput(session, "apt_type", selected = "")
          updateDateInput(session, "apt_date", value = NA)
        } else {
          showNotification("Error scheduling appointment", type = "error")
        }
      }
    })
    
    # Save symptom
    observeEvent(input$save_symptom, {
      if (input$symptom_type == "") {
        showNotification("Please enter symptom type", type = "error")
        return()
      }
      
      data <- patient_data()
      user <- current_user
      
      if (!is.null(data) && nrow(data) > 0) {
        symptom_data <- list(
          symptom_type = input$symptom_type,
          severity = input$symptom_severity,
          duration = input$symptom_duration,
          triggers = input$symptom_triggers,
          relief_measures = input$symptom_relief
        )
        
        result <- db_functions$log_symptom(db_conn, data$patient_id[1], user$user_id, symptom_data)
        
        if (!is.null(result)) {
          showNotification("✅ Symptom logged!", type = "message")
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none';", ns("symptoms_modal")))
        } else {
          showNotification("Error logging symptom", type = "error")
        }
      }
    })
    
    # Save lab test
    observeEvent(input$save_labtest, {
      if (input$test_name == "" || is.null(input$test_date)) {
        showNotification("Please fill in required fields", type = "error")
        return()
      }
      
      data <- patient_data()
      user <- current_user
      
      if (!is.null(data) && nrow(data) > 0) {
        test_data <- list(
          test_name = input$test_name,
          test_date = input$test_date,
          result_value = input$test_value,
          reference_range = input$test_range,
          notes = input$test_notes
        )
        
        result <- db_functions$save_lab_test(db_conn, data$patient_id[1], user$user_id, test_data)
        
        if (!is.null(result)) {
          showNotification("✅ Lab test saved!", type = "message")
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none';", ns("labtests_modal")))
        } else {
          showNotification("Error saving lab test", type = "error")
        }
      }
    })
    
    # Create goal
    observeEvent(input$create_goal, {
      if (input$goal_category == "" || input$goal_description == "") {
        showNotification("Please fill in required fields", type = "error")
        return()
      }
      
      data <- patient_data()
      user <- current_user
      
      if (!is.null(data) && nrow(data) > 0) {
        goal_data <- list(
          goal_category = input$goal_category,
          goal_description = input$goal_description,
          target_value = input$goal_target,
          target_date = input$goal_date
        )
        
        result <- db_functions$create_health_goal(db_conn, data$patient_id[1], user$user_id, goal_data)
        
        if (!is.null(result)) {
          showNotification("✅ Health goal created!", type = "message")
          load_goals()
          updateSelectInput(session, "goal_category", selected = "")
          updateTextInput(session, "goal_description", value = "")
        } else {
          showNotification("Error creating goal", type = "error")
        }
      }
    })
    
    # Back to programs
    observeEvent(input$back_to_programs, {
      shinyjs::runjs("
        const chronicDashboard = document.querySelector('.chronic-dashboard');
        if (chronicDashboard) chronicDashboard.style.display = 'none';
        
        const programsSection = document.querySelector('.health-programs-section');
        if (programsSection) programsSection.style.display = 'block';
        window.scrollTo({ top: 0, behavior: 'smooth' });
      ")
    })
  })
}

