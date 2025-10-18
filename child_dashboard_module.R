# 1000 Days with Baho - Child Health Dashboard Module

library(shiny)
library(shinyjs)
library(plotly)

# UI Function
childDashboardUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "child-dashboard-styles.css")
    ),
    
    # Dashboard Container
    tags$div(
      class = "child-dashboard",
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
          tags$h1(class = "dashboard-title", textOutput(ns("child_name_display")))
        ),
        
        tags$div(
          class = "dashboard-actions",
          actionButton(
            inputId = ns("track_growth"),
            label = tags$span(
              tags$i(class = "fas fa-plus-circle"),
              "Track Growth"
            ),
            class = "btn-add"
          ),
          actionButton(
            inputId = ns("add_vaccine"),
            label = tags$span(
              tags$i(class = "fas fa-syringe"),
              "Record Vaccine"
            ),
            class = "btn-add"
          )
        )
      ),
      
      # Child Overview Card
      tags$div(
        class = "child-overview",
        tags$div(
          class = "overview-content",
          tags$div(
            class = "overview-main",
            
            tags$div(
              class = "child-photo-section",
              tags$div(
                class = "child-photo",
                tags$i(class = "fas fa-baby", style = "font-size: 3rem; color: #4895C7;")
              )
            ),
            
            tags$div(
              class = "overview-stats",
              
              tags$div(
                class = "stat-box",
                tags$div(class = "stat-icon", tags$i(class = "fas fa-calendar-days")),
                tags$div(
                  tags$span(class = "stat-value", textOutput(ns("age_display"))),
                  tags$span(class = "stat-label", "Current Age")
                )
              ),
              
              tags$div(
                class = "stat-box",
                tags$div(class = "stat-icon", tags$i(class = "fas fa-weight-scale")),
                tags$div(
                  tags$span(class = "stat-value", textOutput(ns("current_weight"))),
                  tags$span(class = "stat-label", "Current Weight")
                )
              ),
              
              tags$div(
                class = "stat-box",
                tags$div(class = "stat-icon", tags$i(class = "fas fa-ruler-vertical")),
                tags$div(
                  tags$span(class = "stat-value", textOutput(ns("current_height"))),
                  tags$span(class = "stat-label", "Current Height")
                )
              ),
              
              tags$div(
                class = "stat-box",
                tags$div(class = "stat-icon", tags$i(class = "fas fa-syringe")),
                tags$div(
                  tags$span(class = "stat-value", textOutput(ns("vaccines_count"))),
                  tags$span(class = "stat-label", "Vaccines Completed")
                )
              )
            )
          ),
          
          # Progress Bar
          tags$div(
            class = "child-progress",
            tags$div(
              class = "progress-label",
              tags$span("1000 Days Journey"),
              tags$span(textOutput(ns("days_completed")))
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
      
      # Dashboard Grid
      tags$div(
        class = "dashboard-grid",
        
        # Growth Chart Card
        tags$div(
          class = "dashboard-card col-span-8",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-chart-line"),
              "Growth Chart"
            ),
            tags$div(
              class = "card-actions",
              tags$button(
                class = "btn-icon",
                onclick = "alert('WHO standards coming soon')",
                tags$i(class = "fas fa-info-circle"),
                title = "WHO Growth Standards"
              )
            )
          ),
          tags$div(
            class = "card-content",
            tags$div(
              class = "growth-chart-container",
              plotlyOutput(ns("growth_chart"), height = "300px")
            )
          )
        ),
        
        # Vaccination Schedule Card
        tags$div(
          class = "dashboard-card col-span-4",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-syringe"),
              "Vaccination Schedule"
            )
          ),
          tags$div(
            class = "card-content",
            tags$div(
              id = ns("vaccination_list"),
              class = "vaccination-list"
            )
          )
        ),
        
        # Developmental Milestones Card
        tags$div(
          class = "dashboard-card col-span-6",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-baby-carriage"),
              "Developmental Milestones"
            )
          ),
          tags$div(
            class = "card-content",
            tags$div(
              id = ns("milestones_list"),
              class = "milestones-container"
            )
          )
        ),
        
        # Nutrition Tips Card
        tags$div(
          class = "dashboard-card col-span-6",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-utensils"),
              "Nutrition Tips"
            )
          ),
          tags$div(
            class = "card-content",
            tags$div(
              id = ns("nutrition_tips"),
              class = "tips-container"
            )
          )
        ),
        
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
              
              # Feeding Tracker
              tags$div(
                class = "action-card",
                id = ns("action_feeding"),
                tags$div(
                  class = "action-icon",
                  tags$i(class = "fas fa-baby-bottle")
                ),
                tags$div(class = "action-title", "Feeding Tracker"),
                tags$div(class = "action-description", "Log feeding times & meals")
              ),
              
              # Sleep Tracker
              tags$div(
                class = "action-card",
                id = ns("action_sleep"),
                tags$div(
                  class = "action-icon",
                  tags$i(class = "fas fa-moon")
                ),
                tags$div(class = "action-title", "Sleep Tracker"),
                tags$div(class = "action-description", "Track sleep patterns")
              ),
              
              # Appointments
              tags$div(
                class = "action-card",
                id = ns("action_appointments"),
                tags$div(
                  class = "action-icon",
                  tags$i(class = "fas fa-calendar-check")
                ),
                tags$div(class = "action-title", "Appointments"),
                tags$div(class = "action-description", "Manage health visits")
              ),
              
              # Activities
              tags$div(
                class = "action-card",
                id = ns("action_activities"),
                tags$div(
                  class = "action-icon",
                  tags$i(class = "fas fa-puzzle-piece")
                ),
                tags$div(class = "action-title", "Activities"),
                tags$div(class = "action-description", "Development activities")
              ),
              
              # Photo Gallery
              tags$div(
                class = "action-card",
                id = ns("action_photos"),
                tags$div(
                  class = "action-icon",
                  tags$i(class = "fas fa-images")
                ),
                tags$div(class = "action-title", "Photo Gallery"),
                tags$div(class = "action-description", "Capture precious moments")
              ),
              
              # Health Alerts
              tags$div(
                class = "action-card",
                id = ns("action_alerts"),
                tags$div(
                  class = "action-icon",
                  tags$i(class = "fas fa-bell")
                ),
                tags$div(class = "action-title", "Health Alerts"),
                tags$div(class = "action-description", "Important notifications")
              )
            )
          )
        ),
        
        # Growth History Card
        tags$div(
          class = "dashboard-card col-span-12",
          tags$div(
            class = "card-header",
            tags$h3(
              class = "card-title",
              tags$i(class = "fas fa-history"),
              "Growth History"
            )
          ),
          tags$div(
            class = "card-content",
            tags$div(
              id = ns("growth_history"),
              class = "growth-history-container"
            )
          )
        )
      ),
      
      # Growth Tracking Modal
      tags$div(
        id = ns("growth_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("growth_modal"), ns("growth_modal")),
        
        tags$div(
          class = "modal-content",
          
          tags$div(
            class = "modal-header",
            tags$h3(
              class = "modal-title",
              tags$i(class = "fas fa-chart-line"),
              "Track Growth"
            ),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("growth_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group full-width",
                tags$label(class = "modal-label", tags$i(class = "fas fa-calendar"), "Date"),
                dateInput(ns("growth_date"), NULL, value = Sys.Date(), max = Sys.Date())
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", tags$i(class = "fas fa-weight-scale"), "Weight (kg)"),
                numericInput(ns("growth_weight"), NULL, value = NULL, min = 1, max = 50, step = 0.1)
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", tags$i(class = "fas fa-ruler-vertical"), "Height (cm)"),
                numericInput(ns("growth_height"), NULL, value = NULL, min = 30, max = 120, step = 0.5)
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", tags$i(class = "fas fa-circle"), "Head Circumference (cm)"),
                numericInput(ns("growth_head"), NULL, value = NULL, min = 20, max = 60, step = 0.1)
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", tags$i(class = "fas fa-circle-notch"), "Arm Circumference (cm)"),
                numericInput(ns("growth_arm"), NULL, value = NULL, min = 5, max = 30, step = 0.1)
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group full-width",
                tags$label(class = "modal-label", tags$i(class = "fas fa-note-sticky"), "Notes"),
                tags$textarea(
                  id = ns("growth_notes"),
                  class = "modal-textarea",
                  placeholder = "Any observations or notes..."
                )
              )
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(ns("cancel_growth"), "Cancel", class = "btn-cancel"),
            actionButton(
              ns("save_growth"),
              label = tags$span(tags$i(class = "fas fa-save"), "Save Growth Data"),
              class = "btn-save"
            )
          )
        )
      ),
      
      # Vaccination Modal
      tags$div(
        id = ns("vaccine_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("vaccine_modal"), ns("vaccine_modal")),
        
        tags$div(
          class = "modal-content",
          
          tags$div(
            class = "modal-header",
            tags$h3(
              class = "modal-title",
              tags$i(class = "fas fa-syringe"),
              "Record Vaccination"
            ),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("vaccine_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          
          tags$div(
            class = "modal-body",
            
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Vaccine Name"),
                selectInput(
                  ns("vaccine_name"),
                  NULL,
                  choices = c(
                    "Select..." = "",
                    "BCG" = "BCG",
                    "OPV (Polio)" = "OPV",
                    "DTP (Diphtheria/Tetanus/Pertussis)" = "DTP",
                    "Hepatitis B" = "HepB",
                    "Hib" = "Hib",
                    "PCV (Pneumococcal)" = "PCV",
                    "Rotavirus" = "Rotavirus",
                    "Measles" = "Measles",
                    "Yellow Fever" = "Yellow Fever",
                    "Vitamin A" = "Vitamin A",
                    "Other" = "Other"
                  )
                )
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Dose Number"),
                numericInput(ns("vaccine_dose"), NULL, value = 1, min = 1, max = 5, step = 1)
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Scheduled Date"),
                dateInput(ns("vaccine_scheduled"), NULL, value = Sys.Date())
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Administered Date"),
                dateInput(ns("vaccine_administered"), NULL, value = Sys.Date(), max = Sys.Date())
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Health Facility"),
                textInput(ns("vaccine_facility"), NULL, placeholder = "Hospital or health center")
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Administered By"),
                textInput(ns("vaccine_admin_by"), NULL, placeholder = "Healthcare provider name")
              )
            ),
            
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group full-width",
                tags$label(class = "modal-label", "Notes"),
                tags$textarea(
                  id = ns("vaccine_notes"),
                  class = "modal-textarea",
                  placeholder = "Any reactions or notes..."
                )
              )
            )
          ),
          
          tags$div(
            class = "modal-footer",
            actionButton(ns("cancel_vaccine"), "Cancel", class = "btn-cancel"),
            actionButton(
              ns("save_vaccine"),
              label = tags$span(tags$i(class = "fas fa-save"), "Save Vaccination"),
              class = "btn-save"
            )
          )
        )
      ),
      
      # Feeding Tracker Modal
      tags$div(
        id = ns("feeding_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("feeding_modal"), ns("feeding_modal")),
        
        tags$div(
          class = "modal-content",
          tags$div(
            class = "modal-header",
            tags$h3(class = "modal-title", tags$i(class = "fas fa-baby-bottle"), "Feeding Tracker"),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("feeding_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          tags$div(
            class = "modal-body",
            tags$div(
              class = "feeding-tracker-content",
              tags$h4("Recent Feedings", style = "margin-bottom: 1rem;"),
              tags$div(id = ns("feeding_list"), class = "feeding-list"),
              tags$hr(style = "margin: 1.5rem 0;"),
              tags$h4("Log New Feeding", style = "margin-bottom: 1rem;"),
              tags$div(
                class = "modal-form-row",
                tags$div(
                  class = "modal-form-group",
                  tags$label(class = "modal-label", "Type"),
                  selectInput(ns("feeding_type"), NULL, choices = c("Breastfeeding" = "breast", "Formula" = "formula", "Solid Food" = "solid", "Water" = "water"))
                ),
                tags$div(
                  class = "modal-form-group",
                  tags$label(class = "modal-label", "Amount (if applicable)"),
                  textInput(ns("feeding_amount"), NULL, placeholder = "e.g., 120ml, 1 cup")
                )
              ),
              tags$div(
                class = "modal-form-row",
                tags$div(
                  class = "modal-form-group full-width",
                  tags$label(class = "modal-label", "Notes"),
                  tags$textarea(id = ns("feeding_notes"), class = "modal-textarea", placeholder = "Any notes...")
                )
              )
            )
          ),
          tags$div(
            class = "modal-footer",
            actionButton(ns("close_feeding"), "Close", class = "btn-cancel"),
            actionButton(ns("log_feeding"), label = tags$span(tags$i(class = "fas fa-check"), "Log Feeding"), class = "btn-save")
          )
        )
      ),
      
      # Sleep Tracker Modal
      tags$div(
        id = ns("sleep_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("sleep_modal"), ns("sleep_modal")),
        
        tags$div(
          class = "modal-content",
          tags$div(
            class = "modal-header",
            tags$h3(class = "modal-title", tags$i(class = "fas fa-moon"), "Sleep Tracker"),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("sleep_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          tags$div(
            class = "modal-body",
            tags$div(
              class = "sleep-tracker-content",
              tags$div(
                class = "sleep-summary",
                tags$h4("Today's Sleep Summary"),
                tags$div(class = "sleep-stat", 
                         tags$span(class = "sleep-label", "Total Sleep:"), 
                         tags$span(id = ns("total_sleep_display"), class = "sleep-value", "0h 0m")),
                tags$div(class = "sleep-stat", 
                         tags$span(class = "sleep-label", "Number of Naps:"), 
                         tags$span(id = ns("nap_count_display"), class = "sleep-value", "0"))
              ),
              tags$hr(style = "margin: 1.5rem 0;"),
              tags$h4("Log Sleep Session", style = "margin-bottom: 1rem;"),
              tags$div(
                class = "modal-form-row",
                tags$div(
                  class = "modal-form-group",
                  tags$label(class = "modal-label", "Start Time"),
                  textInput(ns("sleep_start"), NULL, placeholder = "HH:MM (e.g., 20:30)")
                ),
                tags$div(
                  class = "modal-form-group",
                  tags$label(class = "modal-label", "End Time"),
                  textInput(ns("sleep_end"), NULL, placeholder = "HH:MM (e.g., 06:30)")
                )
              ),
              tags$div(
                class = "modal-form-row",
                tags$div(
                  class = "modal-form-group full-width",
                  tags$label(class = "modal-label", "Notes"),
                  tags$textarea(id = ns("sleep_notes"), class = "modal-textarea", placeholder = "Sleep quality, interruptions...")
                )
              )
            )
          ),
          tags$div(
            class = "modal-footer",
            actionButton(ns("close_sleep"), "Close", class = "btn-cancel"),
            actionButton(ns("log_sleep"), label = tags$span(tags$i(class = "fas fa-check"), "Log Sleep"), class = "btn-save")
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
            tags$h3(class = "modal-title", tags$i(class = "fas fa-calendar-check"), "Health Appointments"),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("appointments_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          tags$div(
            class = "modal-body",
            tags$div(
              id = ns("appointments_list"),
              class = "appointments-list"
            ),
            tags$hr(style = "margin: 1.5rem 0;"),
            tags$h4("Schedule New Appointment", style = "margin-bottom: 1rem;"),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Type"),
                selectInput(ns("apt_type"), NULL, choices = c(
                  "Well-Child Visit" = "wellchild",
                  "Vaccination" = "vaccination",
                  "Sick Visit" = "sick",
                  "Specialist" = "specialist",
                  "Other" = "other"
                ))
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Date & Time"),
                dateInput(ns("apt_date"), NULL)
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Provider/Facility"),
                textInput(ns("apt_provider"), NULL, placeholder = "Doctor name or hospital")
              ),
              tags$div(
                class = "modal-form-group",
                tags$label(class = "modal-label", "Phone"),
                textInput(ns("apt_phone"), NULL, placeholder = "Contact number")
              )
            ),
            tags$div(
              class = "modal-form-row",
              tags$div(
                class = "modal-form-group full-width",
                tags$label(class = "modal-label", "Notes"),
                tags$textarea(id = ns("apt_notes"), class = "modal-textarea", placeholder = "Purpose, reminders...")
              )
            )
          ),
          tags$div(
            class = "modal-footer",
            actionButton(ns("close_appointments"), "Close", class = "btn-cancel"),
            actionButton(ns("save_appointment"), label = tags$span(tags$i(class = "fas fa-save"), "Save Appointment"), class = "btn-save")
          )
        )
      ),
      
      # Activities Modal
      tags$div(
        id = ns("activities_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("activities_modal"), ns("activities_modal")),
        
        tags$div(
          class = "modal-content",
          tags$div(
            class = "modal-header",
            tags$h3(class = "modal-title", tags$i(class = "fas fa-puzzle-piece"), "Developmental Activities"),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("activities_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          tags$div(
            class = "modal-body",
            tags$div(
              id = ns("activities_content"),
              class = "activities-content"
            )
          ),
          tags$div(
            class = "modal-footer",
            actionButton(ns("close_activities"), "Close", class = "btn-cancel")
          )
        )
      ),
      
      # Health Alerts Modal
      tags$div(
        id = ns("alerts_modal"),
        class = "modal-overlay",
        style = "display: none;",
        onclick = sprintf("if(event.target.id === '%s') { document.getElementById('%s').style.display = 'none'; }", ns("alerts_modal"), ns("alerts_modal")),
        
        tags$div(
          class = "modal-content",
          tags$div(
            class = "modal-header",
            tags$h3(class = "modal-title", tags$i(class = "fas fa-bell"), "Health Alerts"),
            tags$button(
              class = "modal-close",
              onclick = sprintf("document.getElementById('%s').style.display = 'none'", ns("alerts_modal")),
              tags$i(class = "fas fa-times")
            )
          ),
          tags$div(
            class = "modal-body",
            tags$div(
              id = ns("alerts_content"),
              class = "alerts-content"
            )
          ),
          tags$div(
            class = "modal-footer",
            actionButton(ns("close_alerts"), "Close", class = "btn-cancel")
          )
        )
      ),
      
      # JavaScript for Quick Actions
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
      ns("action_feeding"), ns("open_feeding"),
      ns("action_sleep"), ns("open_sleep"),
      ns("action_appointments"), ns("open_appointments"),
      ns("action_activities"), ns("open_activities"),
      ns("action_photos"), ns("open_photos"),
      ns("action_alerts"), ns("open_alerts")
      )))
    )
  )
}

# Server Function
childDashboardServer <- function(id, current_user, db_pool) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive values
    child_data <- reactiveVal(NULL)
    child_stats <- reactiveVal(NULL)
    
    # Load child data
    observe({
      req(current_user())
      req(db_pool())
      
      user <- current_user()
      pool <- db_pool()
      
      tryCatch({
        # Get child health data
        data <- db_functions$get_child_health_data(pool, user$user_id)
        
        if (!is.null(data) && nrow(data) > 0) {
          child_data(data)
          
          # Calculate child statistics
          dob <- as.Date(data$date_of_birth[1])
          today <- Sys.Date()
          
          age_days <- as.numeric(difftime(today, dob, units = "days"))
          age_months <- floor(age_days / 30.44)
          age_years <- floor(age_months / 12)
          remaining_months <- age_months %% 12
          
          days_completed <- min(age_days, 1000)
          progress_pct <- round((days_completed / 1000) * 100, 1)
          
          stats <- list(
            age_days = age_days,
            age_months = age_months,
            age_years = age_years,
            remaining_months = remaining_months,
            days_completed = days_completed,
            progress_percentage = progress_pct,
            child_name = data$child_name[1],
            birth_weight = data$birth_weight_kg[1],
            birth_height = data$birth_length_cm[1]
          )
          
          child_stats(stats)
          
          # Load latest growth data
          growth_history <- db_functions$get_child_growth_history(pool, data$child_id[1], limit = 1)
          if (!is.null(growth_history) && nrow(growth_history) > 0) {
            stats$current_weight <- growth_history$weight_kg[1]
            stats$current_height <- growth_history$height_cm[1]
            child_stats(stats)
          }
        }
      }, error = function(e) {
        cat("ERROR loading child data:", e$message, "\n")
      })
    })
    
    # Render outputs
    output$greeting_text <- renderText({
      req(child_stats())
      stats <- child_stats()
      
      hour <- as.integer(format(Sys.time(), "%H"))
      greeting <- if (hour < 12) "Good morning" else if (hour < 17) "Good afternoon" else "Good evening"
      
      sprintf("%s! Let's check on", greeting)
    })
    
    output$child_name_display <- renderText({
      req(child_data())
      child_data()$child_name[1]
    })
    
    output$age_display <- renderText({
      req(child_stats())
      stats <- child_stats()
      
      if (stats$age_years > 0) {
        sprintf("%d year%s %d month%s", 
                stats$age_years, if(stats$age_years > 1) "s" else "",
                stats$remaining_months, if(stats$remaining_months != 1) "s" else "")
      } else {
        sprintf("%d month%s", stats$age_months, if(stats$age_months != 1) "s" else "")
      }
    })
    
    output$current_weight <- renderText({
      req(child_stats())
      stats <- child_stats()
      
      if (!is.null(stats$current_weight)) {
        sprintf("%.1f kg", stats$current_weight)
      } else {
        "Not tracked"
      }
    })
    
    output$current_height <- renderText({
      req(child_stats())
      stats <- child_stats()
      
      if (!is.null(stats$current_height)) {
        sprintf("%.1f cm", stats$current_height)
      } else {
        "Not tracked"
      }
    })
    
    output$vaccines_count <- renderText({
      req(child_data())
      pool <- db_pool()
      data <- child_data()
      
      tryCatch({
        vaccines <- db_functions$get_child_vaccinations(pool, data$child_id[1])
        completed <- sum(!is.na(vaccines$administered_date))
        total <- nrow(vaccines)
        
        sprintf("%d / %d", completed, total)
      }, error = function(e) {
        "0 / 0"
      })
    })
    
    output$days_completed <- renderText({
      req(child_stats())
      stats <- child_stats()
      sprintf("%d / 1000 days (%s%%)", stats$days_completed, stats$progress_percentage)
    })
    
    # Update progress bar
    observe({
      req(child_stats())
      stats <- child_stats()
      
      shinyjs::runjs(sprintf("
        document.getElementById('%s').style.width = '%s%%';
      ", ns("progress_bar"), stats$progress_percentage))
    })
    
    # Render growth chart
    output$growth_chart <- renderPlotly({
      req(child_data())
      pool <- db_pool()
      data <- child_data()
      
      tryCatch({
        growth <- db_functions$get_child_growth_history(pool, data$child_id[1], limit = 50)
        
        if (!is.null(growth) && nrow(growth) > 0) {
          # Prepare data
          growth$tracking_date <- as.Date(growth$tracking_date)
          
          # Create plotly chart
          fig <- plot_ly(growth) %>%
            add_trace(
              x = ~tracking_date,
              y = ~weight_kg,
              type = 'scatter',
              mode = 'lines+markers',
              name = 'Weight (kg)',
              line = list(color = '#2B7A9B', width = 3),
              marker = list(size = 8, color = '#2B7A9B')
            ) %>%
            add_trace(
              x = ~tracking_date,
              y = ~height_cm / 10,  # Scale for dual axis effect
              type = 'scatter',
              mode = 'lines+markers',
              name = 'Height (cm ÷ 10)',
              line = list(color = '#48BB78', width = 3, dash = 'dash'),
              marker = list(size = 8, color = '#48BB78')
            ) %>%
            layout(
              xaxis = list(
                title = "Date",
                showgrid = TRUE,
                gridcolor = '#E2E8F0'
              ),
              yaxis = list(
                title = "Measurements",
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
          
          return(fig)
        } else {
          # Empty state chart
          fig <- plot_ly() %>%
            layout(
              xaxis = list(visible = FALSE),
              yaxis = list(visible = FALSE),
              annotations = list(
                list(
                  text = "No growth data yet<br>Click 'Track Growth' to start",
                  xref = "paper",
                  yref = "paper",
                  x = 0.5,
                  y = 0.5,
                  showarrow = FALSE,
                  font = list(size = 14, color = '#A0AEC0')
                )
              ),
              plot_bgcolor = '#FFFFFF',
              paper_bgcolor = '#FFFFFF'
            )
          
          return(fig)
        }
      }, error = function(e) {
        cat("ERROR rendering growth chart:", e$message, "\n")
        
        # Error state chart
        fig <- plot_ly() %>%
          layout(
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            annotations = list(
              list(
                text = "Error loading chart",
                xref = "paper",
                yref = "paper",
                x = 0.5,
                y = 0.5,
                showarrow = FALSE,
                font = list(size = 14, color = '#E53E3E')
              )
            )
          )
        
        return(fig)
      })
    })
    
    # Load vaccinations
    load_vaccinations <- function() {
      req(child_data())
      pool <- db_pool()
      data <- child_data()
      
      tryCatch({
        vaccines <- db_functions$get_child_vaccinations(pool, data$child_id[1])
        
        if (!is.null(vaccines) && nrow(vaccines) > 0) {
          vaccines_html <- ""
          
          for (i in 1:min(nrow(vaccines), 10)) {
            vac <- vaccines[i, ]
            status_class <- if (!is.na(vac$administered_date)) "completed" else "pending"
            status_icon <- if (!is.na(vac$administered_date)) "check-circle" else "clock"
            status_text <- if (!is.na(vac$administered_date)) {
              format(as.Date(vac$administered_date), "%b %d, %Y")
            } else {
              format(as.Date(vac$scheduled_date), "Due: %b %d")
            }
            
            vaccines_html <- paste0(vaccines_html, sprintf('
              <div class="vaccine-item %s">
                <div class="vaccine-icon">
                  <i class="fas fa-%s"></i>
                </div>
                <div class="vaccine-details">
                  <div class="vaccine-name">%s</div>
                  <div class="vaccine-date">%s</div>
                </div>
              </div>
            ', status_class, status_icon, vac$vaccine_name, status_text))
          }
          
          shinyjs::html(ns("vaccination_list"), vaccines_html)
        } else {
          shinyjs::html(ns("vaccination_list"), '
            <div class="empty-state">
              <i class="fas fa-syringe"></i>
              <p>No vaccinations recorded yet</p>
              <p style="font-size: 0.85rem;">Click "Record Vaccine" to add</p>
            </div>
          ')
        }
      }, error = function(e) {
        cat("ERROR loading vaccinations:", e$message, "\n")
      })
    }
    
    # Load milestones based on age
    load_milestones <- function() {
      req(child_stats())
      req(child_data())
      stats <- child_stats()
      pool <- db_pool()
      data <- child_data()
      user <- current_user()
      
      age_months <- stats$age_months
      
      # Define milestones by age range
      milestones_template <- if (age_months < 3) {
        list(
          list(icon = "smile", text = "Smiles at people", category = "social"),
          list(icon = "eye", text = "Follows things with eyes", category = "cognitive"),
          list(icon = "volume-up", text = "Makes cooing sounds", category = "language")
        )
      } else if (age_months < 6) {
        list(
          list(icon = "laugh", text = "Laughs out loud", category = "social"),
          list(icon = "hand", text = "Reaches for toys", category = "motor"),
          list(icon = "head-side", text = "Holds head steady", category = "motor")
        )
      } else if (age_months < 12) {
        list(
          list(icon = "chair", text = "Sits without support", category = "motor"),
          list(icon = "baby", text = "Crawls", category = "motor"),
          list(icon = "comment", text = "Says simple words", category = "language")
        )
      } else if (age_months < 24) {
        list(
          list(icon = "walking", text = "Walks independently", category = "motor"),
          list(icon = "utensils", text = "Uses spoon/cup", category = "self_care"),
          list(icon = "comments", text = "Says 2-word phrases", category = "language")
        )
      } else {
        list(
          list(icon = "running", text = "Runs and jumps", category = "motor"),
          list(icon = "shapes", text = "Knows colors/shapes", category = "cognitive"),
          list(icon = "user-friends", text = "Plays with other children", category = "social")
        )
      }
      
      # Get saved milestones from database
      saved_milestones <- tryCatch({
        db_functions$get_milestones(pool, data$child_id[1])
      }, error = function(e) {
        data.frame()
      })
      
      milestones_html <- ""
      milestone_idx <- 0
      
      for (milestone in milestones_template) {
        milestone_idx <- milestone_idx + 1
        
        # Check if milestone is already saved
        saved <- saved_milestones[saved_milestones$milestone_name == milestone$text, ]
        achieved <- if (nrow(saved) > 0 && !is.null(saved$achieved[1])) saved$achieved[1] else FALSE
        milestone_id <- if (nrow(saved) > 0) saved$milestone_id[1] else paste0("new_", milestone_idx)
        
        status_class <- if (achieved) "achieved" else "pending"
        icon_class <- if (achieved) "fa-check-circle" else "fa-circle"
        
        milestones_html <- paste0(milestones_html, sprintf('
          <div class="milestone-item %s clickable-milestone" data-milestone-name="%s" data-milestone-category="%s" data-milestone-id="%s" onclick="Shiny.setInputValue(\'%s\', {name: \'%s\', category: \'%s\', id: \'%s\', achieved: %s, random: Math.random()}, {priority: \'event\'})">
            <div class="milestone-icon">
              <i class="fas fa-%s"></i>
            </div>
            <div class="milestone-text">%s</div>
            <div class="milestone-status">
              <i class="fas %s"></i>
            </div>
          </div>
        ', status_class, milestone$text, milestone$category, milestone_id,
           ns("milestone_click"), milestone$text, milestone$category, milestone_id, 
           tolower(as.character(achieved)), milestone$icon, milestone$text, icon_class))
      }
      
      shinyjs::html(ns("milestones_list"), milestones_html)
    }
    
    # Load nutrition tips based on age
    load_nutrition_tips <- function() {
      req(child_stats())
      stats <- child_stats()
      
      age_months <- stats$age_months
      
      tips <- if (age_months < 6) {
        list(
          list(icon = "droplet", title = "Exclusive Breastfeeding", text = "Breast milk only for first 6 months"),
          list(icon = "clock", title = "Feed on Demand", text = "8-12 times per day"),
          list(icon = "moon", title = "Night Feeding", text = "Continue nighttime feeds")
        )
      } else if (age_months < 12) {
        list(
          list(icon = "seedling", title = "Start Solid Foods", text = "Introduce pureed vegetables and fruits"),
          list(icon = "bread-slice", title = "Gradual Texture", text = "Move from purees to mashed foods"),
          list(icon = "water", title = "Offer Water", text = "Small amounts with meals")
        )
      } else if (age_months < 24) {
        list(
          list(icon = "drumstick-bite", title = "Protein Sources", text = "Eggs, beans, fish, and meat"),
          list(icon = "carrot", title = "Variety", text = "Mix of vegetables and fruits daily"),
          list(icon = "glass-water", title = "Hydration", text = "6-8 cups of water daily")
        )
      } else {
        list(
          list(icon = "utensils", title = "Family Meals", text = "Eat together at table"),
          list(icon = "apple-alt", title = "Healthy Snacks", text = "Fruits, nuts, yogurt"),
          list(icon = "bowl-rice", title = "Balanced Diet", text = "Include all food groups")
        )
      }
      
      tips_html <- ""
      for (tip in tips) {
        tips_html <- paste0(tips_html, sprintf('
          <div class="tip-card">
            <div class="tip-icon">
              <i class="fas fa-%s"></i>
            </div>
            <div class="tip-content">
              <div class="tip-title">%s</div>
              <div class="tip-description">%s</div>
            </div>
          </div>
        ', tip$icon, tip$title, tip$text))
      }
      
      shinyjs::html(ns("nutrition_tips"), tips_html)
    }
    
    # Load data when dashboard opens
    observe({
      req(child_data())
      shinyjs::delay(500, {
        load_vaccinations()
        load_milestones()
        load_nutrition_tips()
      })
    })
    
    # Show modals
    observeEvent(input$track_growth, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("growth_modal")))
    })
    
    observeEvent(input$add_vaccine, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("vaccine_modal")))
    })
    
    # Cancel buttons
    observeEvent(input$cancel_growth, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("growth_modal")))
    })
    
    observeEvent(input$cancel_vaccine, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("vaccine_modal")))
    })
    
    # Save growth data
    observeEvent(input$save_growth, {
      req(child_data())
      req(child_stats())
      req(input$growth_weight)
      
      pool <- db_pool()
      data <- child_data()
      stats <- child_stats()
      
      tryCatch({
        growth_data <- list(
          tracking_date = input$growth_date,
          age_days = stats$age_days,
          weight_kg = input$growth_weight,
          height_cm = input$growth_height,
          head_circumference_cm = input$growth_head,
          arm_circumference_cm = input$growth_arm,
          notes = input$growth_notes
        )
        
        db_functions$save_child_growth(pool, data$child_id[1], growth_data)
        
        shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("growth_modal")))
        showNotification("Growth data saved successfully!", type = "message", duration = 3)
        
        # Reload child data and growth history
        child_data(db_functions$get_child_health_data(pool, current_user()$user_id))
        load_growth_history()
        
      }, error = function(e) {
        cat("ERROR saving growth:", e$message, "\n")
        showNotification("Error saving growth data", type = "error")
      })
    })
    
    # Save vaccination
    observeEvent(input$save_vaccine, {
      req(child_data())
      req(input$vaccine_name != "")
      
      pool <- db_pool()
      data <- child_data()
      
      tryCatch({
        vaccine_data <- list(
          vaccine_name = input$vaccine_name,
          scheduled_date = input$vaccine_scheduled,
          administered_date = input$vaccine_administered,
          dose_number = input$vaccine_dose,
          health_facility = input$vaccine_facility,
          administered_by = input$vaccine_admin_by,
          notes = input$vaccine_notes,
          status = "completed"
        )
        
        db_functions$save_vaccination(pool, data$child_id[1], vaccine_data)
        
        shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("vaccine_modal")))
        showNotification("Vaccination recorded successfully!", type = "message", duration = 3)
        
        # Reload vaccinations
        load_vaccinations()
        
      }, error = function(e) {
        cat("ERROR saving vaccination:", e$message, "\n")
        showNotification("Error recording vaccination", type = "error")
      })
    })
    
    # Load growth history
    load_growth_history <- function() {
      req(child_data())
      pool <- db_pool()
      data <- child_data()
      
      tryCatch({
        growth <- db_functions$get_child_growth_history(pool, data$child_id[1], limit = 10)
        
        if (!is.null(growth) && nrow(growth) > 0) {
          history_html <- '<div class="growth-history-table">'
          history_html <- paste0(history_html, '<div class="history-header">')
          history_html <- paste0(history_html, '<div class="history-col">Date</div>')
          history_html <- paste0(history_html, '<div class="history-col">Weight</div>')
          history_html <- paste0(history_html, '<div class="history-col">Height</div>')
          history_html <- paste0(history_html, '<div class="history-col">Head</div>')
          history_html <- paste0(history_html, '</div>')
          
          for (i in 1:nrow(growth)) {
            g <- growth[i, ]
            history_html <- paste0(history_html, sprintf('
              <div class="history-row">
                <div class="history-col">%s</div>
                <div class="history-col">%s</div>
                <div class="history-col">%s</div>
                <div class="history-col">%s</div>
              </div>
            ', 
            format(as.Date(g$tracking_date), "%b %d, %Y"),
            if(!is.na(g$weight_kg)) paste0(g$weight_kg, " kg") else "-",
            if(!is.na(g$height_cm)) paste0(g$height_cm, " cm") else "-",
            if(!is.na(g$head_circumference_cm)) paste0(g$head_circumference_cm, " cm") else "-"
            ))
          }
          
          history_html <- paste0(history_html, '</div>')
          shinyjs::html(ns("growth_history"), history_html)
        } else {
          shinyjs::html(ns("growth_history"), '
            <div class="empty-state">
              <i class="fas fa-chart-line"></i>
              <p>No growth data yet</p>
              <p style="font-size: 0.85rem;">Start tracking to see history</p>
            </div>
          ')
        }
      }, error = function(e) {
        cat("ERROR loading growth history:", e$message, "\n")
      })
    }
    
    # Open modal handlers
    observeEvent(input$open_feeding, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("feeding_modal")))
      
      # Load recent feedings
      req(child_data())
      pool <- db_pool()
      data <- child_data()
      
      tryCatch({
        feedings <- db_functions$get_feeding_logs(pool, data$child_id[1], limit = 10)
        
        if (!is.null(feedings) && nrow(feedings) > 0) {
          feedings_html <- ""
          for (i in 1:nrow(feedings)) {
            f <- feedings[i, ]
            type_icon <- switch(f$feeding_type,
                               "breast" = "heart",
                               "formula" = "baby-bottle",
                               "solid" = "utensils",
                               "water" = "glass-water",
                               "baby-bottle")
            
            time_str <- format(as.POSIXct(paste(f$feeding_date, f$feeding_time)), "%b %d, %I:%M %p")
            amount_str <- if (!is.na(f$amount)) f$amount else ""
            
            feedings_html <- paste0(feedings_html, sprintf('
              <div class="feeding-item">
                <i class="fas fa-%s" style="color: #2B7A9B; font-size: 1.2rem;"></i>
                <div class="feeding-details">
                  <div class="feeding-type">%s</div>
                  <div class="feeding-time">%s %s</div>
                </div>
              </div>
            ', type_icon, f$feeding_type, time_str, amount_str))
          }
          
          shinyjs::html(ns("feeding_list"), feedings_html)
        } else {
          shinyjs::html(ns("feeding_list"), '<p style="text-align: center; color: #A0AEC0;">No feeding logs yet</p>')
        }
      }, error = function(e) {
        cat("ERROR loading feedings:", e$message, "\n")
        shinyjs::html(ns("feeding_list"), '<p style="text-align: center; color: #A0AEC0;">Error loading feedings</p>')
      })
    })
    
    observeEvent(input$open_sleep, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("sleep_modal")))
      
      # Load today's sleep summary
      req(child_data())
      pool <- db_pool()
      data <- child_data()
      
      tryCatch({
        summary <- db_functions$get_today_sleep_summary(pool, data$child_id[1])
        
        if (!is.null(summary) && nrow(summary) > 0) {
          total_minutes <- summary$total_sleep_minutes[1]
          nap_count <- summary$nap_count[1]
          
          if (!is.na(total_minutes) && total_minutes > 0) {
            hours <- floor(total_minutes / 60)
            minutes <- total_minutes %% 60
            sleep_text <- sprintf("%dh %dm", hours, minutes)
          } else {
            sleep_text <- "0h 0m"
          }
          
          shinyjs::html(ns("total_sleep_display"), sleep_text)
          shinyjs::html(ns("nap_count_display"), as.character(nap_count))
        }
      }, error = function(e) {
        cat("ERROR loading sleep summary:", e$message, "\n")
      })
    })
    
    observeEvent(input$open_appointments, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("appointments_modal")))
      
      # Load appointments
      req(child_data())
      pool <- db_pool()
      data <- child_data()
      
      tryCatch({
        appointments <- db_functions$get_appointments(pool, data$child_id[1], status = "scheduled")
        
        if (!is.null(appointments) && nrow(appointments) > 0) {
          apt_html <- ""
          for (i in 1:nrow(appointments)) {
            apt <- appointments[i, ]
            date_str <- format(as.Date(apt$appointment_date), "%b %d, %Y")
            
            type_icon <- switch(apt$appointment_type,
                               "wellchild" = "heart-pulse",
                               "vaccination" = "syringe",
                               "sick" = "stethoscope",
                               "specialist" = "user-doctor",
                               "calendar-check")
            
            apt_html <- paste0(apt_html, sprintf('
              <div class="appointment-item">
                <div class="apt-icon">
                  <i class="fas fa-%s"></i>
                </div>
                <div class="apt-details">
                  <div class="apt-type">%s</div>
                  <div class="apt-date">%s</div>
                  <div class="apt-provider">%s</div>
                </div>
              </div>
            ', type_icon, apt$appointment_type, date_str, apt$provider_name %||% "No provider"))
          }
          
          shinyjs::html(ns("appointments_list"), apt_html)
        } else {
          shinyjs::html(ns("appointments_list"), '
            <div class="empty-state" style="padding: 2rem;">
              <i class="fas fa-calendar-alt" style="font-size: 2rem; color: #A0AEC0;"></i>
              <p style="color: #A0AEC0; margin-top: 1rem;">No upcoming appointments</p>
            </div>
          ')
        }
      }, error = function(e) {
        cat("ERROR loading appointments:", e$message, "\n")
      })
    })
    
    observeEvent(input$open_activities, {
      req(child_stats())
      stats <- child_stats()
      age_months <- stats$age_months
      
      # Generate age-appropriate activities
      activities <- if (age_months < 3) {
        list(
          list(title = "Tummy Time", desc = "Place baby on tummy for 5-10 minutes, 2-3 times daily", icon = "baby"),
          list(title = "Eye Contact", desc = "Make eye contact while talking and singing to baby", icon = "eye"),
          list(title = "Gentle Massage", desc = "Give gentle massages to promote bonding", icon = "hand-sparkles")
        )
      } else if (age_months < 6) {
        list(
          list(title = "Reach & Grasp", desc = "Hold toys within reach to encourage grasping", icon = "hand"),
          list(title = "Mirror Play", desc = "Show baby their reflection in a mirror", icon = "mirror"),
          list(title = "Read Together", desc = "Show colorful picture books", icon = "book")
        )
      } else if (age_months < 12) {
        list(
          list(title = "Peek-a-Boo", desc = "Play peek-a-boo to teach object permanence", icon = "smile"),
          list(title = "Stack Blocks", desc = "Practice stacking soft blocks", icon = "cubes"),
          list(title = "Crawling Games", desc = "Encourage crawling with toys", icon = "baby-carriage")
        )
      } else {
        list(
          list(title = "Shape Sorting", desc = "Use shape sorters to teach problem-solving", icon = "shapes"),
          list(title = "Outdoor Play", desc = "Explore nature and play in open spaces", icon = "tree"),
          list(title = "Music & Dance", desc = "Dance to music and play instruments", icon = "music")
        )
      }
      
      activities_html <- ""
      for (act in activities) {
        activities_html <- paste0(activities_html, sprintf('
          <div class="activity-card">
            <div class="activity-icon"><i class="fas fa-%s"></i></div>
            <div class="activity-details">
              <div class="activity-title">%s</div>
              <div class="activity-desc">%s</div>
            </div>
          </div>
        ', act$icon, act$title, act$desc))
      }
      
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("activities_modal")))
      shinyjs::html(ns("activities_content"), activities_html)
    })
    
    observeEvent(input$open_photos, {
      showNotification("Photo Gallery - Coming Soon! 📸", type = "message", duration = 3)
    })
    
    observeEvent(input$open_alerts, {
      req(child_stats())
      stats <- child_stats()
      
      # Generate health alerts based on age and data
      alerts_html <- '
        <div class="alert-item alert-info">
          <i class="fas fa-info-circle"></i>
          <div class="alert-content">
            <div class="alert-title">Next Vaccine Due</div>
            <div class="alert-message">Check vaccination schedule for upcoming vaccines</div>
          </div>
        </div>
        <div class="alert-item alert-success">
          <i class="fas fa-check-circle"></i>
          <div class="alert-content">
            <div class="alert-title">Growth on Track</div>
            <div class="alert-message">Your child is developing well</div>
          </div>
        </div>
        <div class="alert-item alert-tip">
          <i class="fas fa-lightbulb"></i>
          <div class="alert-content">
            <div class="alert-title">Health Tip</div>
            <div class="alert-message">Remember to schedule regular check-ups</div>
          </div>
        </div>
      '
      
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'flex'", ns("alerts_modal")))
      shinyjs::html(ns("alerts_content"), alerts_html)
    })
    
    # Close modal handlers
    observeEvent(input$close_feeding, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("feeding_modal")))
    })
    
    observeEvent(input$close_sleep, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("sleep_modal")))
    })
    
    observeEvent(input$close_appointments, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("appointments_modal")))
    })
    
    observeEvent(input$close_activities, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("activities_modal")))
    })
    
    observeEvent(input$close_alerts, {
      shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("alerts_modal")))
    })
    
    # Log feeding
    observeEvent(input$log_feeding, {
      req(child_data())
      req(current_user())
      
      pool <- db_pool()
      data <- child_data()
      user <- current_user()
      
      tryCatch({
        feeding_data <- list(
          feeding_type = input$feeding_type,
          feeding_date = Sys.Date(),
          feeding_time = format(Sys.time(), "%H:%M:%S"),
          amount = input$feeding_amount,
          notes = input$feeding_notes
        )
        
        feeding_id <- db_functions$save_feeding_log(pool, data$child_id[1], user$user_id, feeding_data)
        
        if (!is.null(feeding_id)) {
          showNotification("Feeding logged successfully!", type = "message", duration = 3)
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("feeding_modal")))
          
          # Clear inputs
          updateTextInput(session, "feeding_amount", value = "")
          updateTextAreaInput(session, "feeding_notes", value = "")
        } else {
          showNotification("Error logging feeding", type = "error")
        }
      }, error = function(e) {
        cat("ERROR logging feeding:", e$message, "\n")
        showNotification("Error logging feeding", type = "error")
      })
    })
    
    # Log sleep
    observeEvent(input$log_sleep, {
      req(child_data())
      req(current_user())
      req(input$sleep_start != "")
      req(input$sleep_end != "")
      
      pool <- db_pool()
      data <- child_data()
      user <- current_user()
      
      tryCatch({
        sleep_data <- list(
          sleep_date = Sys.Date(),
          start_time = input$sleep_start,
          end_time = input$sleep_end,
          notes = input$sleep_notes
        )
        
        sleep_id <- db_functions$save_sleep_session(pool, data$child_id[1], user$user_id, sleep_data)
        
        if (!is.null(sleep_id)) {
          showNotification("Sleep session logged successfully!", type = "message", duration = 3)
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("sleep_modal")))
          
          # Clear inputs
          updateTextInput(session, "sleep_start", value = "")
          updateTextInput(session, "sleep_end", value = "")
          updateTextAreaInput(session, "sleep_notes", value = "")
        } else {
          showNotification("Error logging sleep", type = "error")
        }
      }, error = function(e) {
        cat("ERROR logging sleep:", e$message, "\n")
        showNotification(paste("Error:", e$message), type = "error")
      })
    })
    
    # Save appointment
    observeEvent(input$save_appointment, {
      req(child_data())
      req(current_user())
      req(input$apt_type != "")
      
      pool <- db_pool()
      data <- child_data()
      user <- current_user()
      
      tryCatch({
        appointment_data <- list(
          appointment_type = input$apt_type,
          appointment_date = input$apt_date,
          provider_name = input$apt_provider,
          phone = input$apt_phone,
          notes = input$apt_notes,
          status = "scheduled"
        )
        
        apt_id <- db_functions$save_appointment(pool, data$child_id[1], user$user_id, appointment_data)
        
        if (!is.null(apt_id)) {
          showNotification("Appointment scheduled successfully!", type = "message", duration = 3)
          shinyjs::runjs(sprintf("document.getElementById('%s').style.display = 'none'", ns("appointments_modal")))
          
          # Clear inputs
          updateTextInput(session, "apt_provider", value = "")
          updateTextInput(session, "apt_phone", value = "")
          updateTextAreaInput(session, "apt_notes", value = "")
          
          # Create notification reminder
          notification_data <- list(
            notification_type = "appointment_reminder",
            title = paste("Upcoming", appointment_data$appointment_type),
            message = sprintf("Appointment scheduled for %s", format(appointment_data$appointment_date, "%B %d, %Y")),
            due_date = appointment_data$appointment_date - 1,  # Day before
            priority = "normal"
          )
          
          db_functions$create_notification(pool, data$child_id[1], user$user_id, notification_data)
        } else {
          showNotification("Error scheduling appointment", type = "error")
        }
      }, error = function(e) {
        cat("ERROR saving appointment:", e$message, "\n")
        showNotification("Error scheduling appointment", type = "error")
      })
    })
    
    # Handle milestone click
    observeEvent(input$milestone_click, {
      req(child_data())
      req(current_user())
      
      pool <- db_pool()
      data <- child_data()
      user <- current_user()
      milestone_info <- input$milestone_click
      
      tryCatch({
        # Toggle achievement status
        new_achieved <- !as.logical(milestone_info$achieved)
        
        if (grepl("^new_", milestone_info$id)) {
          # Create new milestone
          milestone_data <- list(
            milestone_name = milestone_info$name,
            milestone_category = milestone_info$category,
            expected_age_months = child_stats()$age_months,
            achieved = new_achieved,
            achieved_date = if (new_achieved) Sys.Date() else NA
          )
          
          db_functions$save_milestone(pool, data$child_id[1], user$user_id, milestone_data)
        } else {
          # Update existing milestone
          db_functions$update_milestone_achievement(
            pool,
            as.integer(milestone_info$id),
            new_achieved,
            if (new_achieved) Sys.Date() else NULL
          )
        }
        
        # Refresh milestones
        load_milestones()
        
        if (new_achieved) {
          showNotification(paste("🎉", milestone_info$name, "achieved!"), type = "message", duration = 3)
        } else {
          showNotification("Milestone unmarked", type = "message", duration = 2)
        }
      }, error = function(e) {
        cat("ERROR updating milestone:", e$message, "\n")
        showNotification("Error updating milestone", type = "error")
      })
    })
    
    # Load all data when dashboard opens
    observe({
      req(child_data())
      shinyjs::delay(500, {
        load_vaccinations()
        load_milestones()
        load_nutrition_tips()
        load_growth_history()
      })
    })
    
    # Back to programs
    observeEvent(input$back_to_programs, {
      cat("🔙 Returning to health programs\n")
      shinyjs::runjs("
        const childDashboard = document.querySelector('.child-dashboard');
        if (childDashboard) childDashboard.style.display = 'none';
      ")
      session$sendCustomMessage("showHealthPrograms", list())
    })
    
  })
}

