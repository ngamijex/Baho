library(shiny)
library(shinyjs)

# Source all modules
source("landing.R")
source("chat_module.R")
source("auth_module.R")
source("database.R")
source("openai_integration.R")

# Define UI for the main application
ui <- fluidPage(
  useShinyjs(),
  
  # Add CSS to prevent flash of interfaces
  tags$head(
    tags$style(HTML("
      #chat-module-container,
      #auth-module-container {
        display: none;
      }
    "))
  ),
  
  # Main navigation container
  div(
    id = "main-container",
    
    # Landing Page Module
    div(
      id = "landing-module-container",
      landingPageUI("landing")
    ),
    
    # Authentication Module
    div(
      id = "auth-module-container",
      authUI("auth")
    ),
    
    # Chat Module
    div(
      id = "chat-module-container",
      chatModuleUI("chat")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Current page reactive value
  current_page <- reactiveVal("landing")
  
  # Navigation trigger reactive value
  navigate_to_chat <- reactiveVal(0)
  navigate_to_home <- reactiveVal(0)
  
  # Initialize modules
  landingPageServer("landing")
  auth_module <- authServer("auth", navigate_to_chat, navigate_to_home)
  chatModuleServer("chat", auth_module)
  
  # Global message processing with chat history
  observeEvent(input$global_message_process, {
    if (!is.null(input$global_message_process)) {
      message_content <- input$global_message_process$message
      session_id <- input$global_message_process$session_id
      
      # Process the message directly
      tryCatch({
        # Test if openai_functions is accessible
        if (!exists("openai_functions")) {
          return()
        }
        
        # Get database connection
        db_conn <- db_connect()
        if (is.null(db_conn)) {
          session$sendCustomMessage("aiError", list())
          return()
        }
        
        # Save user message to database
        if (!is.null(session_id)) {
          db_functions$save_message(db_conn, session_id, message_content, "user")
          db_functions$update_session_timestamp(db_conn, session_id)
        }
        
        # Get conversation history for context
        conversation_history <- NULL
        if (!is.null(session_id)) {
          conversation_history <- db_functions$get_session_messages(db_conn, session_id)
          # Remove the current message from history (it was just added)
          if (nrow(conversation_history) > 0) {
            conversation_history <- conversation_history[-nrow(conversation_history), ]
          }
        }
        
        # Get AI response with conversation history
        ai_response <- openai_functions$send_message(message_content, conversation_history)
        
        # Save AI response to database
        if (!is.null(session_id)) {
          db_functions$save_message(db_conn, session_id, ai_response, "ai")
          db_functions$update_session_timestamp(db_conn, session_id)
        }
        
        # Send AI response to UI
        session$sendCustomMessage("aiResponse", list(content = ai_response))
        
        # Close database connection
        dbDisconnect(db_conn)
        
      }, error = function(e) {
        cat("❌ Error in global message processing:", e$message, "\n")
        session$sendCustomMessage("aiError", list())
      })
    }
  })
  
  # Navigation event handlers
  observeEvent(input$start_chatting, {
    current_page("auth")
    shinyjs::hide("landing-module-container")
    shinyjs::show("auth-module-container")
  })
  
  observeEvent(input$back_to_home, {
    current_page("landing")
    shinyjs::hide("chat-module-container")
    shinyjs::hide("auth-module-container")
    shinyjs::show("landing-module-container")
  })
  
  # Navigation handlers using reactive values
  observeEvent(navigate_to_chat(), {
    if (navigate_to_chat() > 0) {
      current_page("chat")
      shinyjs::hide("auth-module-container")
      shinyjs::show("chat-module-container")
      navigate_to_chat(0)  # Reset
    }
  })
  
  observeEvent(navigate_to_home(), {
    if (navigate_to_home() > 0) {
      current_page("landing")
      shinyjs::hide("chat-module-container")
      shinyjs::show("landing-module-container")
      navigate_to_home(0)  # Reset
    }
  })
}

# Run the application
shinyApp(
  ui = ui,
  server = server,
  options = list(host = "0.0.0.0", port = 4542)
)

