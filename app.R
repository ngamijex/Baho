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
  
  # Global message processing (bypasses module restart issues)
  observeEvent(input$global_message_process, {
    if (!is.null(input$global_message_process)) {
      message_content <- input$global_message_process$message
      
      # Process the message directly
      tryCatch({
        # Test if openai_functions is accessible
        if (!exists("openai_functions")) {
          return()
        }
        
        # Get AI response
        ai_response <- openai_functions$send_message(message_content)
        
        # Send AI response to UI
        session$sendCustomMessage("aiResponse", list(content = ai_response))
        
      }, error = function(e) {
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

