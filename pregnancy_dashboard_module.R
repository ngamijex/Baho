# ===== PREGNANCY DASHBOARD MODULE =====

# UI Function
pregnancyDashboardUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Include CSS
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "pregnancy-dashboard-styles.css"),
      tags$script(HTML(sprintf("
        $(document).ready(function() {
          // Make action cards clickable
          $('#%s').click(function() { Shiny.setInputValue('%s', Math.random()); });
          $('#%s').click(function() { Shiny.setInputValue('%s', Math.random()); });
          $('#%s').click(function() { Shiny.setInputValue('%s', Math.random()); });
          $('#%s').click(function() { Shiny.setInputValue('%s', Math.random()); });
        });
      ", ns("action_kick_counter"), ns("action_kick_counter"),
         ns("action_contraction_timer"), ns("action_contraction_timer"),
         ns("action_medications"), ns("action_medications"),
         ns("action_emergency"), ns("action_emergency"))))
    ),
    
    # Dashboard Container
    tags$div(
      class = "pregnancy-dashboard",
      id = ns("dashboard_container"),
      style = "display: none;", # Hidden by default
      
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
          tags$h1(class = "dashboard-title", "My Pregnancy Journey")
        ),
        
        tags$div(
          class = "dashboard-actions",
          actionButton(
            inputId = ns("track_today"),
            label = tags$span(
              tags$i(class = "fas fa-plus-circle"),
              "Track Today"
            ),
            class = "btn-add"
          )
        )
      ),
      
      # Pregnancy Overview Card
      tags$div(
        class = "pregnancy-overview",
        tags$div(
          class = "overview-content",
          tags$div(
            class = "overview-main",
            
            tags$div(
              class = "overview-info",
              tags$h2(uiOutput(ns("current_week_display"))),
              tags$p(uiOutput(ns("trimester_display")))
            ),
            
            tags$div(
              class = "overview-stats",
              
              tags$div(
                class = "stat-box",
                tags$span(class = "stat-value", textOutput(ns("days_until_due"))),
                tags$span(class = "stat-label", "Days Until Due Date")
              ),
              
              tags$div(
                class = "stat-box",
                tags$span(class = "stat-value", textOutput(ns("weeks_completed"))),
                tags$span(class = "stat-label", "Weeks Completed")
              ),
              
              tags$div(
                class = "stat-box",
                tags$span(class = "stat-value", textOutput(ns("weeks_remaining"))),
                tags$span(class = "stat-label", "Weeks to Go")
              )
            )
          ),
          
          # Progress Bar
          tags$div(
            class = "pregnancy-progress",
            tags$div(
              class = "progress-label",
              tags$span("Pregnancy Progress"),
              tags$span(textOutput(ns("progress_percentage")))
            ),
            tags$div(
              class = "progress-bar-container",
              tags$div(
                class = "progress-bar-fill",
                id = ns("progress_bar"),
                style = "width: 0%;"
              )
            )
          )
        )
      ),
      
      # Quick Actions Grid
      tags$div(
        class = "quick-actions-grid",
        
        # Kick Counter
        tags$div(
          class = "action-card primary",
          id = ns("action_kick_counter"),
          tags$div(
            class = "action-card-icon",
            tags$i(class = "fas fa-baby")
          ),
          tags$div(class = "action-card-title", "Kick Counter"),
          tags$div(class = "action-card-description", "Track baby movements")
        ),
        
        # Contraction Timer
        tags$div(
          class = "action-card warning",
          id = ns("action_contraction_timer"),
          tags$div(
            class = "action-card-icon",
            tags$i(class = "fas fa-clock")
          ),
          tags$div(class = "action-card-title", "Contraction Timer"),
          tags$div(class = "action-card-description", "Time contractions for labor")
        ),
        
        # Medications
        tags$div(
          class = "action-card success",
          id = ns("action_medications"),
          tags$div(
            class = "action-card-icon",
            tags$i(class = "fas fa-pills")
          ),
          tags$div(class = "action-card-title", "Medications"),
          tags$div(class = "action-card-description", "Track prenatal vitamins")
        ),
        
        # Emergency
        tags$div(
          class = "action-card danger",
          id = ns("action_emergency"),
          tags$div(
            class = "action-card-icon",
            tags$i(class = "fas fa-phone")
          ),
          tags$div(class = "action-card-title", "Emergency"),
          tags$div(class = "action-card-description", "Quick access to help")
        )
      ),
      
      # Dashboard Grid
      tags$div(
        class = "dashboard-grid",
        
        # Baby Development Timeline
        tags$div(
          class = "dashboard-card col-span-8",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-baby"),
              "Baby Development Timeline"
            )
          ),
          tags$div(
            class = "timeline",
            id = ns("development_timeline")
          )
        ),
        
        # Upcoming Appointments
        tags$div(
          class = "dashboard-card col-span-4",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-calendar-check"),
              "Upcoming Appointments"
            ),
            actionButton(
              inputId = ns("add_appointment"),
              label = tags$i(class = "fas fa-plus"),
              class = "card-action"
            )
          ),
          tags$div(
            class = "appointments-list",
            id = ns("appointments_list")
          )
        ),
        
        # Health Metrics
        tags$div(
          class = "dashboard-card col-span-6",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-heartbeat"),
              "Health Metrics"
            )
          ),
          tags$div(
            class = "quick-stats",
            
            tags$div(
              class = "stat-item-card",
              tags$div(
                class = "stat-item-icon",
                tags$i(class = "fas fa-weight-scale")
              ),
              tags$div(class = "stat-item-value", textOutput(ns("current_weight"))),
              tags$div(class = "stat-item-label", "Current Weight (kg)")
            ),
            
            tags$div(
              class = "stat-item-card",
              tags$div(
                class = "stat-item-icon",
                tags$i(class = "fas fa-heart-pulse")
              ),
              tags$div(class = "stat-item-value", textOutput(ns("blood_pressure"))),
              tags$div(class = "stat-item-label", "Blood Pressure")
            ),
            
            tags$div(
              class = "stat-item-card",
              tags$div(
                class = "stat-item-icon",
                tags$i(class = "fas fa-person-pregnant")
              ),
              tags$div(class = "stat-item-value", textOutput(ns("weight_gain"))),
              tags$div(class = "stat-item-label", "Weight Gain (kg)")
            ),
            
            tags$div(
              class = "stat-item-card",
              tags$div(
                class = "stat-item-icon",
                tags$i(class = "fas fa-clock")
              ),
              tags$div(class = "stat-item-value", textOutput(ns("last_checkup"))),
              tags$div(class = "stat-item-label", "Last Checkup")
            )
          )
        ),
        
        # This Week's Tips
        tags$div(
          class = "dashboard-card col-span-6",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-lightbulb"),
              "This Week's Tips"
            )
          ),
          tags$div(
            class = "tips-list",
            id = ns("weekly_tips")
          )
        )
      ),
      
      # Daily Tracking Modal
      tags$div(
        id = ns("tracking_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("tracking_modal"), ns("tracking_modal")),
        
        tags$div(
          class = "modal-content",
          
          # Modal Header
          tags$div(
            class = "modal-header",
            tags$h3(
              class = "modal-title",
              tags$i(class = "fas fa-heartbeat"),
              "Daily Health Tracking"
            ),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("tracking_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          # Modal Body
          tags$div(
            class = "modal-body",
            
            # Date
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group full-width",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-calendar"),
                  "Date"
                ),
                dateInput(
                  inputId = ns("tracking_date"),
                  label = NULL,
                  value = Sys.Date(),
                  max = Sys.Date()
                )
              )
            ),
            
            # Vital Signs
            tags$h4(style = "margin: 1.5rem 0 1rem; color: #2B7A9B; font-size: 1.1rem;", 
                   tags$i(class = "fas fa-stethoscope"), " Vital Signs"),
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-weight-scale"),
                  "Current Weight (kg)"
                ),
                numericInput(
                  inputId = ns("tracking_weight"),
                  label = NULL,
                  value = NULL,
                  min = 30,
                  max = 200,
                  step = 0.1
                )
              ),
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-temperature-high"),
                  "Temperature (°C)"
                ),
                numericInput(
                  inputId = ns("tracking_temperature"),
                  label = NULL,
                  value = NULL,
                  min = 35,
                  max = 42,
                  step = 0.1
                )
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-heart-pulse"),
                  "Blood Pressure (Systolic)"
                ),
                numericInput(
                  inputId = ns("tracking_bp_systolic"),
                  label = NULL,
                  value = NULL,
                  min = 70,
                  max = 200,
                  step = 1
                )
              ),
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-heart-pulse"),
                  "Blood Pressure (Diastolic)"
                ),
                numericInput(
                  inputId = ns("tracking_bp_diastolic"),
                  label = NULL,
                  value = NULL,
                  min = 40,
                  max = 130,
                  step = 1
                )
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-heart"),
                  "Heart Rate (bpm)"
                ),
                numericInput(
                  inputId = ns("tracking_heart_rate"),
                  label = NULL,
                  value = NULL,
                  min = 40,
                  max = 200,
                  step = 1
                )
              ),
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-droplet"),
                  "Water Intake (liters)"
                ),
                numericInput(
                  inputId = ns("tracking_water"),
                  label = NULL,
                  value = NULL,
                  min = 0,
                  max = 10,
                  step = 0.25
                )
              )
            ),
            
            # Baby Movements
            tags$h4(style = "margin: 1.5rem 0 1rem; color: #2B7A9B; font-size: 1.1rem;", 
                   tags$i(class = "fas fa-baby"), " Baby Movements"),
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  "Felt Baby Movement?"
                ),
                checkboxInput(
                  inputId = ns("tracking_felt_movement"),
                  label = "Yes, I felt the baby moving",
                  value = FALSE
                )
              ),
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  "Movement Frequency"
                ),
                selectInput(
                  inputId = ns("tracking_movement_freq"),
                  label = NULL,
                  choices = c("Select..." = "", "None" = "none", "Rare" = "rare", "Moderate" = "moderate", "Frequent" = "frequent")
                )
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  "Movement Strength"
                ),
                selectInput(
                  inputId = ns("tracking_movement_strength"),
                  label = NULL,
                  choices = c("Select..." = "", "Weak" = "weak", "Moderate" = "moderate", "Strong" = "strong")
                )
              ),
              
              tags$div(
                class = "modal-form-group"
              )
            ),
            
            # Symptoms & Feelings
            tags$h4(style = "margin: 1.5rem 0 1rem; color: #2B7A9B; font-size: 1.1rem;", 
                   tags$i(class = "fas fa-notes-medical"), " Symptoms & Feelings"),
            
            tags$div(
              class = "modal-form-group full-width",
              tags$label(
                class = "modal-label",
                "Current Symptoms (select all that apply)"
              ),
              tags$div(
                class = "checkbox-group-modal",
                
                tags$div(
                  class = "checkbox-item-modal",
                  checkboxInput(ns("symptom_nausea"), label = "Nausea", value = FALSE),
                  tags$label(`for` = ns("symptom_nausea"), "Nausea")
                ),
                tags$div(
                  class = "checkbox-item-modal",
                  checkboxInput(ns("symptom_fatigue"), label = "Fatigue", value = FALSE),
                  tags$label(`for` = ns("symptom_fatigue"), "Fatigue")
                ),
                tags$div(
                  class = "checkbox-item-modal",
                  checkboxInput(ns("symptom_headache"), label = "Headache", value = FALSE),
                  tags$label(`for` = ns("symptom_headache"), "Headache")
                ),
                tags$div(
                  class = "checkbox-item-modal",
                  checkboxInput(ns("symptom_backpain"), label = "Back Pain", value = FALSE),
                  tags$label(`for` = ns("symptom_backpain"), "Back Pain")
                ),
                tags$div(
                  class = "checkbox-item-modal",
                  checkboxInput(ns("symptom_swelling"), label = "Swelling", value = FALSE),
                  tags$label(`for` = ns("symptom_swelling"), "Swelling")
                ),
                tags$div(
                  class = "checkbox-item-modal",
                  checkboxInput(ns("symptom_cramps"), label = "Cramps", value = FALSE),
                  tags$label(`for` = ns("symptom_cramps"), "Cramps")
                )
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-smile"),
                  "Mood Today"
                ),
                selectInput(
                  inputId = ns("tracking_mood"),
                  label = NULL,
                  choices = c("Select..." = "", "Happy" = "happy", "Anxious" = "anxious", "Tired" = "tired", 
                             "Excited" = "excited", "Worried" = "worried", "Peaceful" = "peaceful")
                )
              ),
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-battery-three-quarters"),
                  "Energy Level (1-10)"
                ),
                sliderInput(
                  inputId = ns("tracking_energy"),
                  label = NULL,
                  min = 1,
                  max = 10,
                  value = 5,
                  step = 1
                )
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-bed"),
                  "Hours Slept"
                ),
                numericInput(
                  inputId = ns("tracking_sleep"),
                  label = NULL,
                  value = NULL,
                  min = 0,
                  max = 24,
                  step = 0.5
                )
              ),
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-person-walking"),
                  "Exercise (minutes)"
                ),
                numericInput(
                  inputId = ns("tracking_exercise"),
                  label = NULL,
                  value = NULL,
                  min = 0,
                  max = 300,
                  step = 5
                )
              )
            ),
            
            # Notes
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group full-width",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-note-sticky"),
                  "Notes & Observations"
                ),
                tags$textarea(
                  id = ns("tracking_notes"),
                  class = "modal-textarea",
                  placeholder = "Any additional notes about how you're feeling today..."
                )
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group full-width",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-triangle-exclamation"),
                  "Concerns or Questions"
                ),
                tags$textarea(
                  id = ns("tracking_concerns"),
                  class = "modal-textarea",
                  placeholder = "Any concerns you want to discuss with your doctor..."
                )
              )
            )
          ),
          
          # Modal Footer
          tags$div(
            class = "modal-footer",
            actionButton(
              inputId = ns("cancel_tracking"),
              label = "Cancel",
              class = "btn-cancel"
            ),
            actionButton(
              inputId = ns("save_tracking"),
              label = tags$span(
                tags$i(class = "fas fa-save"),
                "Save Tracking"
              ),
              class = "btn-save"
            )
          )
        )
      ),
      
      # Appointment Scheduling Modal
      tags$div(
        id = ns("appointment_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("appointment_modal"), ns("appointment_modal")),
        
        tags$div(
          class = "modal-content",
          
          # Modal Header
          tags$div(
            class = "modal-header",
            tags$h3(
              class = "modal-title",
              tags$i(class = "fas fa-calendar-plus"),
              "Schedule Appointment"
            ),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("appointment_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          # Modal Body
          tags$div(
            class = "modal-body",
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-stethoscope"),
                  "Appointment Type"
                ),
                selectInput(
                  inputId = ns("appt_type"),
                  label = NULL,
                  choices = c(
                    "Select..." = "",
                    "Antenatal Checkup" = "antenatal",
                    "Ultrasound" = "ultrasound",
                    "Lab Tests" = "lab_test",
                    "Specialist Consultation" = "specialist",
                    "Delivery" = "delivery"
                  )
                )
              ),
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-calendar"),
                  "Appointment Date"
                ),
                dateInput(
                  inputId = ns("appt_date"),
                  label = NULL,
                  value = Sys.Date() + 7,
                  min = Sys.Date()
                )
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-clock"),
                  "Appointment Time"
                ),
                textInput(
                  inputId = ns("appt_time"),
                  label = NULL,
                  value = "09:00",
                  placeholder = "HH:MM (24-hour format)"
                )
              ),
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-hospital"),
                  "Hospital/Clinic"
                ),
                textInput(
                  inputId = ns("appt_hospital"),
                  label = NULL,
                  placeholder = "Hospital or health center name"
                )
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-user-doctor"),
                  "Doctor Name"
                ),
                textInput(
                  inputId = ns("appt_doctor"),
                  label = NULL,
                  placeholder = "Doctor's name"
                )
              ),
              
              tags$div(
                class = "modal-form-group",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-location-dot"),
                  "Location"
                ),
                textInput(
                  inputId = ns("appt_location"),
                  label = NULL,
                  placeholder = "Address or directions"
                )
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              
              tags$div(
                class = "modal-form-group full-width",
                tags$label(
                  class = "modal-label",
                  tags$i(class = "fas fa-note-sticky"),
                  "Notes"
                ),
                tags$textarea(
                  id = ns("appt_notes"),
                  class = "modal-textarea",
                  placeholder = "Any preparation needed, questions to ask, etc."
                )
              )
            )
          ),
          
          # Modal Footer
          tags$div(
            class = "modal-footer",
            actionButton(
              inputId = ns("cancel_appointment"),
              label = "Cancel",
              class = "btn-cancel"
            ),
            actionButton(
              inputId = ns("save_appointment"),
              label = tags$span(
                tags$i(class = "fas fa-save"),
                "Schedule Appointment"
              ),
              class = "btn-save"
            )
          )
        )
      ),
      
      # Kick Counter Modal
      tags$div(
        id = ns("kick_counter_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("kick_counter_modal"), ns("kick_counter_modal")),
        
        tags$div(
          class = "modal-content",
          
          tags$div(
            class = "modal-header",
            tags$h3(
              class = "modal-title",
              tags$i(class = "fas fa-baby"),
              "Kick Counter"
            ),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("kick_counter_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            tags$p(
              style = "text-align: center; color: #4A5568; margin-bottom: 2rem;",
              "Tap the button each time you feel your baby move. Aim for 10 movements within 2 hours."
            ),
            
            tags$div(
              class = "kick-counter-display",
              tags$div(class = "kick-count", textOutput(ns("kick_count_display"))),
              tags$div(class = "kick-label", "Baby Kicks Recorded"),
              
              actionButton(
                inputId = ns("record_kick"),
                label = tags$span(tags$i(class = "fas fa-hand-pointer"), "TAP"),
                class = "kick-button"
              ),
              
              tags$div(class = "kick-timer", textOutput(ns("kick_timer_display")))
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(
              inputId = ns("reset_kick_counter"),
              label = "Reset",
              class = "btn-cancel"
            ),
            actionButton(
              inputId = ns("save_kick_session"),
              label = tags$span(
                tags$i(class = "fas fa-save"),
                "Save Session"
              ),
              class = "btn-save"
            )
          )
        )
      ),
      
      # Contraction Timer Modal
      tags$div(
        id = ns("contraction_timer_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("contraction_timer_modal"), ns("contraction_timer_modal")),
        
        tags$div(
          class = "modal-content",
          
          tags$div(
            class = "modal-header",
            tags$h3(
              class = "modal-title",
              tags$i(class = "fas fa-clock"),
              "Contraction Timer"
            ),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("contraction_timer_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            tags$div(
              id = ns("contraction_alert"),
              style = "display: none;"
            ),
            
            tags$div(
              class = "contraction-display",
              
              tags$div(
                class = "contraction-metric",
                tags$div(class = "contraction-value", textOutput(ns("current_duration"))),
                tags$div(class = "contraction-label", "Current Duration")
              ),
              
              tags$div(
                class = "contraction-metric",
                tags$div(class = "contraction-value", textOutput(ns("average_frequency"))),
                tags$div(class = "contraction-label", "Average Frequency")
              )
            ),
            
            tags$div(
              class = "contraction-controls",
              actionButton(
                inputId = ns("start_contraction"),
                label = tags$span(
                  tags$i(class = "fas fa-play"),
                  "Start Contraction"
                ),
                class = "btn-save"
              ),
              actionButton(
                inputId = ns("end_contraction"),
                label = tags$span(
                  tags$i(class = "fas fa-stop"),
                  "End Contraction"
                ),
                class = "btn-cancel",
                style = "display: none;"
              )
            ),
            
            tags$div(
              class = "contraction-history",
              tags$h4(style = "margin-bottom: 1rem; color: #2B7A9B;", "Recent Contractions"),
              tags$div(id = ns("contraction_list"))
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(
              inputId = ns("clear_contractions"),
              label = "Clear All",
              class = "btn-cancel"
            ),
            actionButton(
              inputId = ns("close_contraction_timer"),
              label = "Close",
              class = "btn-save"
            )
          )
        )
      ),
      
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
            tags$h3(
              class = "modal-title",
              tags$i(class = "fas fa-pills"),
              "Daily Medications"
            ),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("medications_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            tags$h4(style = "margin-bottom: 1rem; color: #2B7A9B;", "Today's Medications"),
            
            tags$div(
              class = "medication-list",
              id = ns("medication_list"),
              
              # Default medications
              tags$div(
                class = "medication-item",
                tags$input(
                  type = "checkbox",
                  class = "medication-checkbox",
                  id = ns("med_prenatal"),
                  onchange = sprintf("Shiny.setInputValue('%s', this.checked)", ns("med_prenatal_checked"))
                ),
                tags$div(
                  class = "medication-details",
                  tags$div(class = "medication-name", "Prenatal Vitamin"),
                  tags$div(class = "medication-schedule", "Once daily with breakfast")
                )
              ),
              
              tags$div(
                class = "medication-item",
                tags$input(
                  type = "checkbox",
                  class = "medication-checkbox",
                  id = ns("med_iron"),
                  onchange = sprintf("Shiny.setInputValue('%s', this.checked)", ns("med_iron_checked"))
                ),
                tags$div(
                  class = "medication-details",
                  tags$div(class = "medication-name", "Iron Supplement"),
                  tags$div(class = "medication-schedule", "Once daily with lunch")
                )
              ),
              
              tags$div(
                class = "medication-item",
                tags$input(
                  type = "checkbox",
                  class = "medication-checkbox",
                  id = ns("med_folic"),
                  onchange = sprintf("Shiny.setInputValue('%s', this.checked)", ns("med_folic_checked"))
                ),
                tags$div(
                  class = "medication-details",
                  tags$div(class = "medication-name", "Folic Acid"),
                  tags$div(class = "medication-schedule", "400 mcg daily")
                )
              ),
              
              tags$div(
                class = "medication-item",
                tags$input(
                  type = "checkbox",
                  class = "medication-checkbox",
                  id = ns("med_calcium"),
                  onchange = sprintf("Shiny.setInputValue('%s', this.checked)", ns("med_calcium_checked"))
                ),
                tags$div(
                  class = "medication-details",
                  tags$div(class = "medication-name", "Calcium"),
                  tags$div(class = "medication-schedule", "Twice daily with meals")
                )
              )
            ),
            
            tags$div(
              style = "margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #E2E8F0;",
              tags$h4(style = "margin-bottom: 1rem; color: #2B7A9B;", "Add Custom Medication"),
              
              tags$div(
                class = "modal-form-row",
                
                tags$div(
                  class = "modal-form-group",
                  tags$label(class = "modal-label", "Medication Name"),
                  textInput(
                    inputId = ns("custom_med_name"),
                    label = NULL,
                    placeholder = "e.g., Vitamin D"
                  )
                ),
                
                tags$div(
                  class = "modal-form-group",
                  tags$label(class = "modal-label", "Schedule"),
                  textInput(
                    inputId = ns("custom_med_schedule"),
                    label = NULL,
                    placeholder = "e.g., Once daily"
                  )
                )
              ),
              
              actionButton(
                inputId = ns("add_custom_medication"),
                label = tags$span(
                  tags$i(class = "fas fa-plus"),
                  "Add Medication"
                ),
                class = "btn-save",
                style = "width: 100%;"
              )
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(
              inputId = ns("close_medications"),
              label = "Close",
              class = "btn-save"
            )
          )
        )
      ),
      
      # Emergency Modal
      tags$div(
        id = ns("emergency_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("emergency_modal"), ns("emergency_modal")),
        
        tags$div(
          class = "modal-content",
          
          tags$div(
            class = "modal-header",
            tags$h3(
              class = "modal-title",
              tags$i(class = "fas fa-phone"),
              "Emergency Contacts"
            ),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("emergency_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            tags$div(
              class = "emergency-card",
              tags$div(
                class = "emergency-title",
                tags$i(class = "fas fa-hospital"),
                "Emergency Services"
              ),
              tags$div(
                class = "emergency-contacts",
                tags$a(
                  class = "emergency-contact-btn",
                  href = "tel:912",
                  tags$i(class = "fas fa-phone-volume"),
                  "Call 912 - Emergency Ambulance"
                ),
                tags$a(
                  class = "emergency-contact-btn",
                  href = "tel:114",
                  tags$i(class = "fas fa-kit-medical"),
                  "Call 114 - Health Emergency Hotline"
                )
              )
            ),
            
            tags$h4(style = "margin: 2rem 0 1rem; color: #2B7A9B;", "Your Emergency Contacts"),
            
            tags$div(
              id = ns("user_emergency_contacts"),
              style = "display: flex; flex-direction: column; gap: 0.75rem;"
            ),
            
            tags$div(
              class = "warning-banner",
              style = "margin-top: 2rem;",
              tags$div(class = "warning-icon", tags$i(class = "fas fa-triangle-exclamation")),
              tags$div(
                class = "warning-content",
                tags$div(class = "warning-title", "When to Seek Immediate Help:"),
                tags$div(
                  class = "warning-text",
                  tags$ul(
                    style = "margin: 0.5rem 0 0 1.25rem; padding: 0;",
                    tags$li("Severe abdominal pain"),
                    tags$li("Heavy bleeding or fluid leakage"),
                    tags$li("Severe headache with vision changes"),
                    tags$li("Decreased or no baby movement"),
                    tags$li("Contractions before 37 weeks"),
                    tags$li("High fever (above 38°C/100.4°F)")
                  )
                )
              )
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(
              inputId = ns("close_emergency"),
              label = "Close",
              class = "btn-cancel"
            )
          )
        )
      )
    )
  )
}

# Server Function
pregnancyDashboardServer <- function(id, current_user, db_pool) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive values
    maternal_data <- reactiveVal(NULL)
    pregnancy_stats <- reactiveVal(NULL)
    
    # Load maternal data
    observe({
      req(current_user())
      req(db_pool())
      
      user <- current_user()
      pool <- db_pool()
      
      tryCatch({
        # Get maternal health data
        data <- db_functions$get_maternal_health_data(pool, user$user_id)
        
        if (!is.null(data) && nrow(data) > 0) {
          maternal_data(data)
          
          # Calculate pregnancy statistics
          lmp <- as.Date(data$last_menstrual_period[1])
          due_date <- as.Date(data$estimated_due_date[1])
          today <- Sys.Date()
          
          days_pregnant <- as.numeric(difftime(today, lmp, units = "days"))
          weeks_pregnant <- floor(days_pregnant / 7)
          days_until_due <- as.numeric(difftime(due_date, today, units = "days"))
          weeks_remaining <- ceiling(days_until_due / 7)
          progress_pct <- round((days_pregnant / 280) * 100, 1)
          
          trimester <- if (weeks_pregnant <= 13) 1 else if (weeks_pregnant <= 26) 2 else 3
          
          stats <- list(
            weeks_pregnant = weeks_pregnant,
            days_pregnant = days_pregnant,
            days_until_due = max(0, days_until_due),
            weeks_remaining = max(0, weeks_remaining),
            progress_percentage = min(100, progress_pct),
            trimester = trimester,
            due_date = due_date,
            full_name = data$full_name[1],
            pre_pregnancy_weight = data$pre_pregnancy_weight_kg[1],
            current_weight = data$current_weight_kg[1]
          )
          
          pregnancy_stats(stats)
          
          cat("✅ Pregnancy data loaded:", stats$weeks_pregnant, "weeks\n")
        }
      }, error = function(e) {
        cat("❌ Error loading maternal data:", e$message, "\n")
      })
    })
    
    # Greeting text
    output$greeting_text <- renderText({
      req(pregnancy_stats())
      stats <- pregnancy_stats()
      paste("Welcome back,", stats$full_name)
    })
    
    # Current week display
    output$current_week_display <- renderUI({
      req(pregnancy_stats())
      stats <- pregnancy_stats()
      tags$span(paste("Week", stats$weeks_pregnant))
    })
    
    # Trimester display
    output$trimester_display <- renderUI({
      req(pregnancy_stats())
      stats <- pregnancy_stats()
      trimester_names <- c("First Trimester", "Second Trimester", "Third Trimester")
      tags$span(trimester_names[stats$trimester])
    })
    
    # Days until due
    output$days_until_due <- renderText({
      req(pregnancy_stats())
      pregnancy_stats()$days_until_due
    })
    
    # Weeks completed
    output$weeks_completed <- renderText({
      req(pregnancy_stats())
      pregnancy_stats()$weeks_pregnant
    })
    
    # Weeks remaining
    output$weeks_remaining <- renderText({
      req(pregnancy_stats())
      pregnancy_stats()$weeks_remaining
    })
    
    # Progress percentage
    output$progress_percentage <- renderText({
      req(pregnancy_stats())
      paste0(pregnancy_stats()$progress_percentage, "%")
    })
    
    # Update progress bar
    observe({
      req(pregnancy_stats())
      stats <- pregnancy_stats()
      
      shinyjs::runjs(sprintf("
        const progressBar = document.getElementById('%s');
        if (progressBar) {
          progressBar.style.width = '%s%%';
        }
      ", ns("progress_bar"), stats$progress_percentage))
    })
    
    # Current weight
    output$current_weight <- renderText({
      req(pregnancy_stats())
      stats <- pregnancy_stats()
      if (!is.null(stats$current_weight) && !is.na(stats$current_weight)) {
        sprintf("%.1f", stats$current_weight)
      } else if (!is.null(stats$pre_pregnancy_weight) && !is.na(stats$pre_pregnancy_weight)) {
        sprintf("%.1f", stats$pre_pregnancy_weight)
      } else {
        "--"
      }
    })
    
    # Blood pressure
    output$blood_pressure <- renderText({
      "--/--"  # Will be from tracking data
    })
    
    # Weight gain
    output$weight_gain <- renderText({
      req(pregnancy_stats())
      stats <- pregnancy_stats()
      if (!is.null(stats$current_weight) && !is.null(stats$pre_pregnancy_weight) &&
          !is.na(stats$current_weight) && !is.na(stats$pre_pregnancy_weight)) {
        gain <- stats$current_weight - stats$pre_pregnancy_weight
        sprintf("+%.1f", gain)
      } else {
        "--"
      }
    })
    
    # Last checkup
    output$last_checkup <- renderText({
      "Not yet"  # Will be from appointments data
    })
    
    # Render development timeline
    observe({
      req(pregnancy_stats())
      stats <- pregnancy_stats()
      
      # Week-by-week milestones
      milestones <- list(
        list(week = 8, title = "Baby's Heart Beating", desc = "Your baby's heart is beating about 150 times per minute", completed = stats$weeks_pregnant >= 8),
        list(week = 12, title = "End of First Trimester", desc = "Major organs are formed and baby is moving", completed = stats$weeks_pregnant >= 12),
        list(week = 20, title = "Halfway There!", desc = "You might feel baby's movements now", completed = stats$weeks_pregnant >= 20),
        list(week = 24, title = "Viability Milestone", desc = "Baby could survive with medical care if born", completed = stats$weeks_pregnant >= 24),
        list(week = 28, title = "Third Trimester Begins", desc = "Baby's eyes can open and close", completed = stats$weeks_pregnant >= 28),
        list(week = 36, title = "Full Term Approaching", desc = "Baby is practicing breathing movements", completed = stats$weeks_pregnant >= 36),
        list(week = 40, title = "Due Date!", desc = "Your baby is ready to meet you", completed = stats$weeks_pregnant >= 40)
      )
      
      timeline_html <- ""
      for (milestone in milestones) {
        status_class <- if (milestone$completed) "completed" else if (milestone$week == stats$weeks_pregnant) "active" else "upcoming"
        
        timeline_html <- paste0(timeline_html, sprintf('
          <div class="timeline-item %s">
            <div class="timeline-week">Week %d</div>
            <div class="timeline-title">%s</div>
            <div class="timeline-description">%s</div>
          </div>
        ', status_class, milestone$week, milestone$title, milestone$desc))
      }
      
      shinyjs::html(ns("development_timeline"), timeline_html)
    })
    
    # Render appointments
    observe({
      # Sample appointments - will be from database
      appointments_html <- '
        <div class="empty-state">
          <i class="fas fa-calendar-plus"></i>
          <p>No upcoming appointments yet</p>
          <p style="font-size: 0.85rem;">Schedule your first antenatal visit</p>
        </div>
      '
      
      shinyjs::html(ns("appointments_list"), appointments_html)
    })
    
    # Render weekly tips
    observe({
      req(pregnancy_stats())
      stats <- pregnancy_stats()
      
      # Tips based on trimester
      tips <- if (stats$trimester == 1) {
        list(
          list(icon = "droplet", text = "Drink plenty of water - aim for 8-10 glasses daily"),
          list(icon = "pills", text = "Take prenatal vitamins with folic acid every day"),
          list(icon = "bed", text = "Get enough rest - your body is working hard"),
          list(icon = "apple-whole", text = "Eat small, frequent meals to manage nausea")
        )
      } else if (stats$trimester == 2) {
        list(
          list(icon = "person-walking", text = "Stay active with gentle exercise like walking"),
          list(icon = "heart", text = "Monitor baby's movements - they're getting stronger"),
          list(icon = "fish", text = "Include omega-3 rich foods for baby's brain development"),
          list(icon = "yoga", text = "Practice relaxation techniques and prenatal yoga")
        )
      } else {
        list(
          list(icon = "bag-shopping", text = "Prepare your hospital bag - better early than late"),
          list(icon = "baby", text = "Learn about labor signs and when to call your doctor"),
          list(icon = "bed-pulse", text = "Rest on your left side to improve blood flow"),
          list(icon = "users", text = "Attend childbirth classes with your partner")
        )
      }
      
      tips_html <- ""
      for (tip in tips) {
        tips_html <- paste0(tips_html, sprintf('
          <div class="tip-item">
            <div class="tip-icon">
              <i class="fas fa-%s"></i>
            </div>
            <div class="tip-text">%s</div>
          </div>
        ', tip$icon, tip$text))
      }
      
      shinyjs::html(ns("weekly_tips"), tips_html)
    })
    
    # Navigation handlers
    observeEvent(input$back_to_programs, {
      cat("🔙 Returning to health programs\n")
      shinyjs::runjs("
        const dashboardContainer = document.querySelector('.pregnancy-dashboard');
        if (dashboardContainer) dashboardContainer.style.display = 'none';
      ")
      session$sendCustomMessage("showHealthPrograms", list())
    })
    
    # Show tracking modal
    observeEvent(input$track_today, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("tracking_modal")))
    })
    
    # Cancel tracking
    observeEvent(input$cancel_tracking, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("tracking_modal")))
    })
    
    # Save tracking data
    observeEvent(input$save_tracking, {
      req(maternal_data())
      req(pregnancy_stats())
      
      pool <- db_pool()
      user <- current_user()
      data <- maternal_data()
      stats <- pregnancy_stats()
      
      # Collect symptoms
      symptoms <- c()
      if (input$symptom_nausea) symptoms <- c(symptoms, "Nausea")
      if (input$symptom_fatigue) symptoms <- c(symptoms, "Fatigue")
      if (input$symptom_headache) symptoms <- c(symptoms, "Headache")
      if (input$symptom_backpain) symptoms <- c(symptoms, "Back Pain")
      if (input$symptom_swelling) symptoms <- c(symptoms, "Swelling")
      if (input$symptom_cramps) symptoms <- c(symptoms, "Cramps")
      
      tryCatch({
        # Prepare tracking data
        tracking_data <- list(
          tracking_date = input$tracking_date,
          pregnancy_week = stats$weeks_pregnant,
          weight_kg = input$tracking_weight,
          blood_pressure_systolic = input$tracking_bp_systolic,
          blood_pressure_diastolic = input$tracking_bp_diastolic,
          heart_rate = input$tracking_heart_rate,
          temperature_celsius = input$tracking_temperature,
          symptoms = paste(symptoms, collapse = ", "),
          mood = input$tracking_mood,
          energy_level = input$tracking_energy,
          felt_baby_movement = input$tracking_felt_movement,
          movement_frequency = input$tracking_movement_freq,
          movement_strength = input$tracking_movement_strength,
          hours_slept = input$tracking_sleep,
          exercise_minutes = input$tracking_exercise,
          water_intake_liters = input$tracking_water,
          notes = input$tracking_notes,
          concerns = input$tracking_concerns
        )
        
        # Save to database
        db_functions$save_pregnancy_tracking(pool, data$maternal_id[1], tracking_data)
        
        # Update current weight in maternal data if provided
        if (!is.null(input$tracking_weight)) {
          dbExecute(pool, "
            UPDATE public.maternal_health_data 
            SET current_weight_kg = $1, updated_at = CURRENT_TIMESTAMP 
            WHERE maternal_id = $2
          ", params = list(input$tracking_weight, data$maternal_id[1]))
        }
        
        # Close modal
        shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("tracking_modal")))
        
        showNotification("Tracking data saved successfully!", type = "message", duration = 3)
        
        # Reload data
        maternal_data(db_functions$get_maternal_health_data(pool, user$user_id))
        
      }, error = function(e) {
        cat("ERROR saving tracking:", e$message, "\n")
        showNotification("Error saving tracking data. Please try again.", type = "error")
      })
    })
    
    # Show appointment modal
    observeEvent(input$add_appointment, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("appointment_modal")))
    })
    
    # Cancel appointment
    observeEvent(input$cancel_appointment, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("appointment_modal")))
    })
    
    # Save appointment
    observeEvent(input$save_appointment, {
      req(maternal_data())
      req(input$appt_type != "")
      req(input$appt_date)
      
      pool <- db_pool()
      data <- maternal_data()
      
      tryCatch({
        # Prepare appointment data
        appointment_data <- list(
          appointment_type = input$appt_type,
          appointment_date = input$appt_date,
          appointment_time = input$appt_time,
          hospital_name = input$appt_hospital,
          doctor_name = input$appt_doctor,
          location = input$appt_location,
          notes = input$appt_notes,
          status = "scheduled"
        )
        
        # Save to database
        db_functions$schedule_pregnancy_appointment(pool, data$maternal_id[1], appointment_data)
        
        # Close modal
        shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("appointment_modal")))
        
        showNotification("Appointment scheduled successfully!", type = "message", duration = 3)
        
        # Reload appointments
        load_appointments()
        
      }, error = function(e) {
        cat("ERROR saving appointment:", e$message, "\n")
        showNotification("Error scheduling appointment. Please try again.", type = "error")
      })
    })
    
    # Load appointments function
    load_appointments <- function() {
      req(maternal_data())
      
      pool <- db_pool()
      data <- maternal_data()
      
      tryCatch({
        appointments <- db_functions$get_upcoming_appointments(pool, data$maternal_id[1])
        
        if (!is.null(appointments) && nrow(appointments) > 0) {
          appointments_html <- ""
          
          for (i in 1:min(nrow(appointments), 5)) {
            appt <- appointments[i, ]
            appt_date <- as.Date(appt$appointment_date)
            month <- format(appt_date, "%b")
            day <- format(appt_date, "%d")
            
            # Type labels
            type_labels <- list(
              antenatal = "Antenatal Checkup",
              ultrasound = "Ultrasound",
              lab_test = "Lab Tests",
              specialist = "Specialist",
              delivery = "Delivery"
            )
            
            type_label <- type_labels[[appt$appointment_type]]
            if (is.null(type_label)) type_label <- appt$appointment_type
            
            appointments_html <- paste0(appointments_html, sprintf('
              <div class="appointment-item">
                <div class="appointment-date">
                  <div class="appointment-month">%s</div>
                  <div class="appointment-day">%s</div>
                </div>
                <div class="appointment-details">
                  <div class="appointment-title">%s</div>
                  <div class="appointment-info">
                    <span><i class="fas fa-clock"></i> %s</span>
                    <span><i class="fas fa-hospital"></i> %s</span>
                  </div>
                </div>
              </div>
            ', month, day, type_label, 
               if(!is.na(appt$appointment_time)) appt$appointment_time else "Time TBD",
               if(!is.na(appt$hospital_name) && appt$hospital_name != "") appt$hospital_name else "Location TBD"))
          }
          
          shinyjs::html(ns("appointments_list"), appointments_html)
        } else {
          shinyjs::html(ns("appointments_list"), '
            <div class="empty-state">
              <i class="fas fa-calendar-plus"></i>
              <p>No upcoming appointments yet</p>
              <p style="font-size: 0.85rem;">Schedule your first antenatal visit</p>
            </div>
          ')
        }
      }, error = function(e) {
        cat("ERROR loading appointments:", e$message, "\n")
      })
    }
    
    # Load appointments when dashboard loads
    observe({
      req(maternal_data())
      shinyjs::delay(1000, load_appointments())
    })
    
    # ========== NEW ADVANCED FEATURES ==========
    
    # Quick Action Card Handlers
    observeEvent(input$action_kick_counter, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("kick_counter_modal")))
    })
    
    observeEvent(input$action_contraction_timer, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("contraction_timer_modal")))
    })
    
    observeEvent(input$action_medications, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("medications_modal")))
    })
    
    observeEvent(input$action_emergency, {
      req(maternal_data())
      
      # Load emergency contacts
      data <- maternal_data()
      contacts_html <- sprintf('
        <div style="padding: 1rem; background: #F0F8FA; border-radius: 0.75rem; border: 1px solid #E2E8F0;">
          <div style="font-weight: 600; color: #1A202C; margin-bottom: 0.5rem;">
            <i class="fas fa-user"></i> %s
          </div>
          <div style="display: flex; gap: 1rem; font-size: 0.9rem; color: #4A5568;">
            <span><i class="fas fa-phone"></i> %s</span>
          </div>
        </div>
      ', data$emergency_contact[1], data$emergency_phone[1])
      
      shinyjs::html(ns("user_emergency_contacts"), contacts_html)
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("emergency_modal")))
    })
    
    observeEvent(input$close_emergency, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("emergency_modal")))
    })
    
    # ========== KICK COUNTER LOGIC ==========
    kick_count <- reactiveVal(0)
    kick_start_time <- reactiveVal(NULL)
    kick_times <- reactiveVal(c())
    
    output$kick_count_display <- renderText({
      as.character(kick_count())
    })
    
    output$kick_timer_display <- renderText({
      if (is.null(kick_start_time())) {
        return("Timer not started")
      }
      
      elapsed <- as.numeric(difftime(Sys.time(), kick_start_time(), units = "mins"))
      hours <- floor(elapsed / 60)
      mins <- floor(elapsed %% 60)
      
      if (hours > 0) {
        sprintf("Time Elapsed: %dh %dm", hours, mins)
      } else {
        sprintf("Time Elapsed: %d minutes", mins)
      }
    })
    
    # Auto-update timer display
    observe({
      req(kick_start_time())
      invalidateLater(30000, session)  # Update every 30 seconds
      kick_start_time()  # Just trigger reactivity
    })
    
    observeEvent(input$record_kick, {
      # Start timer on first kick
      if (is.null(kick_start_time())) {
        kick_start_time(Sys.time())
      }
      
      # Increment count
      kick_count(kick_count() + 1)
      kick_times(c(kick_times(), Sys.time()))
      
      # Check if reached 10 kicks
      if (kick_count() >= 10) {
        elapsed <- as.numeric(difftime(Sys.time(), kick_start_time(), units = "mins"))
        
        if (elapsed <= 120) {
          showNotification(
            sprintf("Great! 10 movements in %d minutes. Your baby is active and healthy!", round(elapsed)),
            type = "message",
            duration = 5
          )
        }
      }
    })
    
    observeEvent(input$reset_kick_counter, {
      kick_count(0)
      kick_start_time(NULL)
      kick_times(c())
    })
    
    observeEvent(input$save_kick_session, {
      req(maternal_data())
      req(kick_count() > 0)
      
      pool <- db_pool()
      data <- maternal_data()
      stats <- pregnancy_stats()
      
      tryCatch({
        # Save kick session as tracking data
        tracking_data <- list(
          tracking_date = Sys.Date(),
          pregnancy_week = stats$weeks_pregnant,
          felt_baby_movement = TRUE,
          movement_frequency = if(kick_count() >= 10) "frequent" else if(kick_count() >= 5) "moderate" else "rare",
          notes = sprintf("Kick counter session: %d movements recorded", kick_count())
        )
        
        db_functions$save_pregnancy_tracking(pool, data$maternal_id[1], tracking_data)
        
        showNotification("Kick session saved successfully!", type = "message", duration = 3)
        
        # Reset and close
        kick_count(0)
        kick_start_time(NULL)
        kick_times(c())
        shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("kick_counter_modal")))
        
      }, error = function(e) {
        cat("ERROR saving kick session:", e$message, "\n")
        showNotification("Error saving session. Please try again.", type = "error")
      })
    })
    
    # ========== CONTRACTION TIMER LOGIC ==========
    contraction_active <- reactiveVal(FALSE)
    contraction_start <- reactiveVal(NULL)
    contraction_list <- reactiveVal(data.frame(
      start_time = character(),
      duration_seconds = numeric(),
      stringsAsFactors = FALSE
    ))
    
    output$current_duration <- renderText({
      if (!contraction_active()) {
        return("--")
      }
      
      elapsed <- as.numeric(difftime(Sys.time(), contraction_start(), units = "secs"))
      sprintf("%ds", round(elapsed))
    })
    
    output$average_frequency <- renderText({
      contractions <- contraction_list()
      
      if (nrow(contractions) < 2) {
        return("--")
      }
      
      times <- as.POSIXct(contractions$start_time)
      intervals <- diff(times)
      avg_mins <- mean(as.numeric(intervals, units = "mins"))
      
      sprintf("%.1f min", avg_mins)
    })
    
    # Auto-update duration
    observe({
      req(contraction_active())
      invalidateLater(1000, session)  # Update every second
      contraction_start()  # Just trigger reactivity
    })
    
    observeEvent(input$start_contraction, {
      contraction_active(TRUE)
      contraction_start(Sys.time())
      
      # Show end button, hide start button
      shinyjs::runjs(sprintf("
        document.querySelector('#%s').style.display = 'none';
        document.querySelector('#%s').style.display = 'inline-flex';
      ", ns("start_contraction"), ns("end_contraction")))
    })
    
    observeEvent(input$end_contraction, {
      req(contraction_start())
      
      duration <- as.numeric(difftime(Sys.time(), contraction_start(), units = "secs"))
      
      # Add to list
      new_entry <- data.frame(
        start_time = format(contraction_start(), "%H:%M:%S"),
        duration_seconds = duration,
        stringsAsFactors = FALSE
      )
      
      contractions <- rbind(contraction_list(), new_entry)
      contraction_list(contractions)
      
      # Reset
      contraction_active(FALSE)
      contraction_start(NULL)
      
      # Show start button, hide end button
      shinyjs::runjs(sprintf("
        document.querySelector('#%s').style.display = 'inline-flex';
        document.querySelector('#%s').style.display = 'none';
      ", ns("start_contraction"), ns("end_contraction")))
      
      # Update display
      update_contraction_display()
      
      # Check for labor warning
      check_contraction_pattern()
    })
    
    update_contraction_display <- function(){
      contractions <- contraction_list()
      
      if (nrow(contractions) == 0) {
        shinyjs::html(ns("contraction_list"), '
          <p style="text-align: center; color: #A0AEC0; padding: 2rem;">
            No contractions recorded yet
          </p>
        ')
        return()
      }
      
      html <- ""
      for (i in nrow(contractions):max(1, nrow(contractions)-9)) {
        html <- paste0(html, sprintf('
          <div class="contraction-entry">
            <span class="contraction-entry-time">%s</span>
            <span class="contraction-entry-duration">%d seconds</span>
          </div>
        ', contractions$start_time[i], round(contractions$duration_seconds[i])))
      }
      
      shinyjs::html(ns("contraction_list"), html)
    }
    
    check_contraction_pattern <- function() {
      contractions <- contraction_list()
      
      if (nrow(contractions) < 3) return()
      
      # Get last 3 contractions
      recent <- tail(contractions, 3)
      times <- as.POSIXct(recent$start_time, format = "%H:%M:%S")
      
      if (length(times) >= 3) {
        intervals <- diff(times)
        avg_interval_mins <- mean(as.numeric(intervals, units = "mins"))
        
        # Check if contractions are regular and close together
        if (avg_interval_mins < 10) {
          shinyjs::html(ns("contraction_alert"), '
            <div class="warning-banner" style="margin-bottom: 1.5rem;">
              <div class="warning-icon"><i class="fas fa-triangle-exclamation"></i></div>
              <div class="warning-content">
                <div class="warning-title">⚠️ Active Labor Pattern Detected</div>
                <div class="warning-text">Your contractions are getting closer together. 
                Contact your healthcare provider or go to the hospital.</div>
              </div>
            </div>
          ')
          
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'block'", ns("contraction_alert")))
        }
      }
    }
    
    observeEvent(input$clear_contractions, {
      contraction_list(data.frame(
        start_time = character(),
        duration_seconds = numeric(),
        stringsAsFactors = FALSE
      ))
      
      shinyjs::html(ns("contraction_list"), '
        <p style="text-align: center; color: #A0AEC0; padding: 2rem;">
          No contractions recorded yet
        </p>
      ')
      
      shinyjs::html(ns("contraction_alert"), "")
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("contraction_alert")))
    })
    
    observeEvent(input$close_contraction_timer, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("contraction_timer_modal")))
    })
    
    # ========== MEDICATION TRACKER ==========
    observeEvent(input$close_medications, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("medications_modal")))
    })
    
    # Handle medication checkbox changes
    observeEvent(input$med_prenatal_checked, {
      if (input$med_prenatal_checked) {
        shinyjs::runjs(sprintf("
          document.querySelector('#%s').parentElement.classList.add('medication-taken')
        ", ns("med_prenatal")))
        showNotification("✅ Prenatal vitamin marked as taken", type = "message", duration = 2)
      }
    })
    
    observeEvent(input$med_iron_checked, {
      if (input$med_iron_checked) {
        shinyjs::runjs(sprintf("
          document.querySelector('#%s').parentElement.classList.add('medication-taken')
        ", ns("med_iron")))
        showNotification("✅ Iron supplement marked as taken", type = "message", duration = 2)
      }
    })
    
    observeEvent(input$med_folic_checked, {
      if (input$med_folic_checked) {
        shinyjs::runjs(sprintf("
          document.querySelector('#%s').parentElement.classList.add('medication-taken')
        ", ns("med_folic")))
        showNotification("✅ Folic acid marked as taken", type = "message", duration = 2)
      }
    })
    
    observeEvent(input$med_calcium_checked, {
      if (input$med_calcium_checked) {
        shinyjs::runjs(sprintf("
          document.querySelector('#%s').parentElement.classList.add('medication-taken')
        ", ns("med_calcium")))
        showNotification("✅ Calcium marked as taken", type = "message", duration = 2)
      }
    })
    
    observeEvent(input$add_custom_medication, {
      req(input$custom_med_name != "")
      
      med_name <- input$custom_med_name
      med_schedule <- if(input$custom_med_schedule != "") input$custom_med_schedule else "As prescribed"
      
      # Add new medication to list
      new_med_html <- sprintf('
        <div class="medication-item">
          <input type="checkbox" class="medication-checkbox" />
          <div class="medication-details">
            <div class="medication-name">%s</div>
            <div class="medication-schedule">%s</div>
          </div>
        </div>
      ', med_name, med_schedule)
      
      shinyjs::runjs(sprintf("
        document.getElementById('%s').insertAdjacentHTML('beforeend', %s)
      ", ns("medication_list"), jsonlite::toJSON(new_med_html, auto_unbox = TRUE)))
      
      # Clear inputs
      updateTextInput(session, "custom_med_name", value = "")
      updateTextInput(session, "custom_med_schedule", value = "")
      
      showNotification(sprintf("✅ %s added to your medication list", med_name), type = "message", duration = 3)
    })
    
  })
}

