library(shiny)
library(shinyjs)

# Source all modules
source("landing.R")
source("chat_module.R")
source("auth_module.R")
source("database.R")
source("openai_integration.R")
source("pregnancy_program_module.R")
source("pregnancy_dashboard_module.R")
source("child_health_module.R")
source("child_dashboard_module.R")
source("chronic_disease_module.R")
source("chronic_dashboard_module.R")

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
  
  # Shared database connection pool
  db_pool <- reactiveVal(NULL)
  current_session_id <- reactiveVal(NULL)
  current_user_id <- reactiveVal(NULL)
  
  # Global reactive for session loading (to bypass module communication issues)
  session_to_load <- reactiveVal(NULL)
  
  # Initialize database connection pool
  observe({
    tryCatch({
      pool <- create_db_pool()
      db_pool(pool)
    }, error = function(e) {
      cat("❌ Failed to create database pool:", e$message, "\n")
    })
  })
  
  # Global session loading (bypasses module communication issues)
  # Global handler for deleting a session
  observeEvent(input$global_delete_session, {
    req(input$global_delete_session)
    session_data <- input$global_delete_session
    
    if (is.list(session_data)) {
      session_id <- session_data$session_id
      cat("🗑️ Global: Delete session requested:", session_id, "\n")
      
      pool <- db_pool()
      
      if (!is.null(pool) && !is.null(session_id)) {
        # Delete the session
        success <- db_functions$delete_session(pool, session_id)
        
        if (success) {
          cat("✅ Global: Session deleted successfully\n")
          
          # If the deleted session is the current one, create a new session
          if (!is.null(current_session_id()) && current_session_id() == session_id) {
            user <- auth_module$get_current_user()
            if (!is.null(user)) {
              new_session_id <- db_functions$create_chat_session(pool, user$user_id, "New Chat")
              current_session_id(new_session_id)
              
              # Clear the chat UI
              session$sendCustomMessage("clearChat", list())
              session$sendCustomMessage("setSessionId", list(session_id = new_session_id))
              cat("✅ Created new session after deletion:", new_session_id, "\n")
            }
          }
          
          # Reload the sessions list for the user
          user <- auth_module$get_current_user()
          if (!is.null(user)) {
            chat_sessions <- db_functions$get_user_sessions(pool, user$user_id)
            
            # Fetch first messages for titles
            if (nrow(chat_sessions) > 0) {
              session_ids <- chat_sessions$session_id
              placeholders <- paste0("$", seq_along(session_ids), collapse = ", ")
              first_msg_query <- sprintf("
                SELECT DISTINCT ON (session_id) session_id, content as first_message
                FROM public.messages
                WHERE session_id IN (%s) AND sender = 'user'
                ORDER BY session_id, created_at ASC
              ", placeholders)
              first_messages <- dbGetQuery(pool, first_msg_query, params = as.list(session_ids))
              first_msg_map <- setNames(first_messages$first_message, first_messages$session_id)
              
              # Build sessions list with titles
              sessions_with_titles <- lapply(1:nrow(chat_sessions), function(i) {
                session_row <- chat_sessions[i, ]
                first_msg <- if (session_row$session_id %in% names(first_msg_map)) {
                  first_msg_map[[session_row$session_id]]
                } else {
                  NULL
                }
                
                title <- if (!is.null(first_msg) && !is.na(first_msg) && nchar(first_msg) > 0) {
                  words <- strsplit(first_msg, " ")[[1]]
                  if (length(words) > 0) {
                    msg_title <- paste(words[1:min(5, length(words))], collapse = " ")
                    if (length(words) > 5) paste0(msg_title, "...") else msg_title
                  } else {
                    "New Chat"
                  }
                } else {
                  "New Chat"
                }
                
                list(
                  session_id = session_row$session_id,
                  session_name = title,
                  last_active = format(session_row$created_at, "%Y-%m-%d %H:%M")
                )
              })
              
              session$sendCustomMessage("updateRecentChats", list(sessions = sessions_with_titles))
              cat("✅ Updated recent chats after deletion\n")
            } else {
              # No sessions left, show empty state
              session$sendCustomMessage("updateRecentChats", list(sessions = list()))
            }
          }
        } else {
          cat("❌ Global: Failed to delete session\n")
        }
      }
    }
  })
  
  observeEvent(input$global_load_session, {
    req(input$global_load_session)
    session_data <- input$global_load_session
    
    if (is.list(session_data)) {
      session_id <- session_data$session_id
      cat("🌐 Global: Load session requested:", session_id, "\n")
      
      # Load the session directly from app level
      pool <- db_pool()
      
      if (!is.null(pool) && !is.null(session_id)) {
        tryCatch({
          # Set current session
          current_session_id(session_id)
          
          # Load messages
          messages <- db_functions$get_session_messages(pool, session_id)
          cat("📨 Global: Found", nrow(messages), "messages in session\n")
          
          # Send clear chat command
          session$sendCustomMessage("clearChat", list())
          
          # Send messages to UI
          if (nrow(messages) > 0) {
            messages_list <- list()
            for (i in 1:nrow(messages)) {
              messages_list[[i]] <- list(
                content = messages$content[i],
                sender = messages$sender[i],
                timestamp = messages$created_at[i]
              )
            }
            cat("✅ Global: Sending", length(messages_list), "messages to UI\n")
            session$sendCustomMessage("loadMessages", list(messages = messages_list))
            
            # Also update the session ID attribute
            session$sendCustomMessage("setSessionId", list(session_id = session_id))
          } else {
            cat("ℹ️ Global: No messages in this session\n")
          }
          
        }, error = function(e) {
          cat("❌ Global: Error loading session:", e$message, "\n")
        })
      } else {
        cat("❌ Global: Cannot load - pool or session_id is NULL\n")
      }
    }
  })
  
  # Global message processing (bypasses module restart issues)
  observeEvent(input$global_message_process, {
    if (!is.null(input$global_message_process)) {
      message_content <- input$global_message_process$message
      session_id <- input$global_message_process$session_id
      user_id <- input$global_message_process$user_id
      
      # Update reactive values
      if (!is.null(session_id)) current_session_id(session_id)
      if (!is.null(user_id)) current_user_id(user_id)
      
      # Process the message directly
      tryCatch({
        # Test if openai_functions is accessible
        if (!exists("openai_functions")) {
          return()
        }
        
        # Get database pool
        pool <- db_pool()
        
        # Save user message to database FIRST
        if (!is.null(pool) && !is.null(session_id)) {
          db_functions$save_message(pool, session_id, message_content, "user")
          db_functions$update_session_timestamp(pool, session_id)
          cat("✅ Saved user message to database\n")
        }
        
        # Load COMPLETE conversation history including the message we just saved
        conversation_history <- NULL
        if (!is.null(pool) && !is.null(session_id)) {
          messages <- db_functions$get_session_messages(pool, session_id)
          cat("📖 Loaded", nrow(messages), "messages for context (including current message)\n")
          if (nrow(messages) > 0) {
            conversation_history <- messages
            cat("📖 Conversation history:\n")
            for (i in 1:nrow(messages)) {
              cat("  ", i, ".", messages$sender[i], ":", substr(messages$content[i], 1, 50), "...\n")
            }
          }
        }
        
        # Get AI response with FULL conversation history for context awareness
        cat("🤖 Sending to AI with", ifelse(is.null(conversation_history), 0, nrow(conversation_history)), "messages of context\n")
        ai_response <- openai_functions$send_message(message_content, conversation_history)
        
        # Save AI response to database
        if (!is.null(pool) && !is.null(session_id)) {
          db_functions$save_message(pool, session_id, ai_response, "ai")
          db_functions$update_session_timestamp(pool, session_id)
        }
        
        # Send AI response to UI
        session$sendCustomMessage("aiResponse", list(content = ai_response))
        
      }, error = function(e) {
        cat("❌ Error processing message:", e$message, "\n")
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

