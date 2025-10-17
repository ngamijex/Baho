library(shiny)
library(shinyjs)
library(dplyr)
library(digest)

# Chat Module UI
chatModuleUI <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    # Include custom CSS for chat interface
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "chat-styles.css"),
      tags$link(rel = "preconnect", href = "https://fonts.googleapis.com"),
      tags$link(rel = "preconnect", href = "https://fonts.gstatic.com", crossorigin = ""),
      tags$link(href = "https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap", rel = "stylesheet"),
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
      tags$title("Baho AI Chat - Your Health Assistant"),
      # Font Awesome for icons
      tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css")
    ),
    
    # Main Chat Container
    tags$div(
      class = "chat-container",
      
      # Left Sidebar - Dark Theme
      tags$div(
        class = "chat-sidebar",
        
        # Brand Section
        tags$div(
          class = "sidebar-brand",
          tags$div(
            class = "brand-content",
            tags$img(src = "baho.png", alt = "Baho", class = "sidebar-logo")
          )
        ),
        
        # New Chat Button
        tags$div(
          class = "new-chat-section",
          actionButton(
            inputId = ns("new_chat"),
            label = tags$div(
              class = "new-chat-content",
              tags$div(
                class = "new-chat-icon",
                tags$span(class = "icon-plus")
              ),
              tags$span("New chat")
            ),
            class = "new-chat-btn"
          )
        ),
        
        # Navigation Menu
        tags$nav(
          class = "sidebar-nav",
          tags$ul(
            class = "nav-list",
            tags$li(
              tags$a(
                href = "#",
                class = "nav-item active",
                tags$span(class = "nav-icon", tags$span(class = "icon-chat")),
                tags$span("Chats")
              )
            ),
            tags$li(
              tags$a(
                href = "#",
                class = "nav-item",
                tags$span(class = "nav-icon", tags$span(class = "icon-projects")),
                tags$span("Health Programs")
              )
            ),
            tags$li(
              tags$a(
                href = "#",
                class = "nav-item",
                tags$span(class = "nav-icon", tags$span(class = "icon-settings")),
                tags$span("Settings")
              )
            )
          )
        ),
        
        # Recent Chats Section
        tags$div(
          class = "recent-section",
          tags$h3(class = "section-title", "Recent Charts"),
          tags$div(
            class = "recent-chats",
            id = ns("recent_chats_list")
            # Will be populated dynamically
          )
        ),
        
        # User Profile Section
        tags$div(
          class = "user-profile",
          tags$div(
            class = "profile-avatar",
            tags$span(id = ns("user_avatar"), "U")
          ),
          tags$div(
            class = "profile-info",
            tags$span(class = "profile-name", id = ns("user_name"), "User"),
            tags$span(class = "profile-plan", id = ns("user_location"), "Kigali, Rwanda")
          ),
          tags$button(
            class = "profile-dropdown",
            tags$span(class = "icon-chevron-down")
          )
        )
      ),
      
      # Main Chat Area
      tags$div(
        class = "chat-main",
        
        # Chat Header
        tags$div(
          class = "chat-header",
          tags$div(
            class = "header-left",
            tags$h1(class = "chat-title", "Baho Health Assistant")
          ),
          tags$div(
            class = "header-right",
            tags$div(
              class = "plan-badge",
              tags$span("Free plan"),
              tags$a(href = "#", class = "upgrade-link", "Upgrade")
            ),
            tags$button(
              class = "header-btn",
              id = ns("profile_btn"),
              tags$span(class = "icon-profile")
            ),
            actionButton(
              inputId = ns("back_to_home"),
              label = tags$span(class = "icon-home"),
              class = "header-btn"
            )
          )
        ),
        
        # Welcome Section
        tags$div(
          class = "welcome-section",
          tags$div(
            class = "welcome-content",
            tags$div(
              class = "welcome-icon",
              tags$img(src = "baho_logo.png", alt = "Baho Logo", class = "welcome-logo")
            ),
            tags$h2(class = "welcome-title", "Welcome back!")
          )
        ),
        
        # Chat Messages Area
        tags$div(
          class = "chat-messages",
          id = ns("messages_container")
          # Messages will be populated dynamically
        ),
        
        # Input Area
        tags$div(
          class = "chat-input-area",
          tags$div(
            class = "input-container",
            tags$div(
              class = "input-wrapper",
              tags$div(
                class = "input-actions-left",
                tags$button(
                  class = "input-btn attach-btn",
                  id = ns("attach_file"),
                  tags$span(class = "icon-attach")
                ),
                tags$button(
                  class = "input-btn options-btn",
                  id = ns("options"),
                  tags$span(class = "icon-options")
                )
              ),
              tags$textarea(
                id = ns("message_input"),
                class = "message-input",
                placeholder = "How can I help you today?",
                rows = 1,
                maxlength = 2000
              ),
              tags$div(
                class = "input-actions-right",
                tags$div(
                  class = "model-selector",
                    tags$select(
                      id = ns("model_select"),
                      class = "model-dropdown",
                      tags$option(value = "baho-v1", "Baho v1"),
                      tags$option(value = "baho-pro", "Baho Pro"),
                      tags$option(value = "baho-medical", "Baho Medical")
                    )
                  ),
                actionButton(
                  inputId = ns("send_message"),
                  label = tags$span(class = "icon-send"),
                  class = "input-btn send-btn",
                  width = "auto"
                )
              )
            )
          ),
          
          # Quick Action Chips
          tags$div(
            class = "quick-actions",
            tags$div(
              class = "action-chip",
              tags$span(class = "chip-icon", tags$span(class = "icon-write")),
              tags$span("Health Check")
            ),
            tags$div(
              class = "action-chip",
              tags$span(class = "chip-icon", tags$span(class = "icon-learn")),
              tags$span("Learn")
            ),
            tags$div(
              class = "action-chip",
              tags$span(class = "chip-icon", tags$span(class = "icon-code")),
              tags$span("Symptoms")
            ),
            tags$div(
              class = "action-chip",
              tags$span(class = "chip-icon", tags$span(class = "icon-life")),
              tags$span("Life stuff")
            ),
            tags$div(
              class = "action-chip",
              tags$span(class = "chip-icon", tags$span(class = "icon-lightbulb")),
              tags$span("Baho's choice")
            )
          )
        )
      )
    ),
    
    # JavaScript for chat functionality
     tags$script(HTML("
       // Wait for DOM to be ready
       function initializeChat() {
         // Global timeout variable
         window.aiResponseTimeout = null;
         
         // Global session ID for tracking current chat session
         window.currentSessionId = null;
         
         // Try to find elements by ID with namespace
         const messageInput = document.getElementById('", ns("message_input"), "') || 
                             document.querySelector('textarea[id*=\"message_input\"]');
         const sendBtn = document.getElementById('", ns("send_message"), "') || 
                        document.querySelector('button[id*=\"send_message\"]');
         const messagesContainer = document.getElementById('", ns("messages_container"), "') || 
                                  document.querySelector('div[id*=\"messages_container\"]');
         
         // Try alternative selectors if primary ones fail
         const finalMessageInput = messageInput || document.querySelector('textarea.message-input') || 
                                  document.querySelector('textarea[placeholder*=\"help\"]');
         const finalSendBtn = sendBtn || document.querySelector('button.send-btn') || 
                             document.querySelector('button[class*=\"send\"]');
         const finalMessagesContainer = messagesContainer || document.querySelector('.chat-messages') || 
                                       document.querySelector('div[class*=\"messages\"]');
         
         // Automatic system theme detection
         function initializeTheme() {
           const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
           document.body.classList.toggle('dark-mode', prefersDark);
         }
         
         // Listen for system theme changes
         window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function(e) {
           document.body.classList.toggle('dark-mode', e.matches);
         });
         
         // Initialize theme on page load
         initializeTheme();
        
        // Auto-resize textarea
        if (finalMessageInput) {
          finalMessageInput.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 120) + 'px';
          });
        }
        
        // Send message on Enter (but not Shift+Enter)
        if (finalMessageInput) {
          finalMessageInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
              e.preventDefault();
              sendMessage();
            }
          });
        }
        
        // Handle send button click for UI updates
        if (finalSendBtn) {
          finalSendBtn.addEventListener('click', function() {
            sendMessage();
          });
        }
        
        // Custom message handlers
        Shiny.addCustomMessageHandler('registerMessageHandler', function(message) {
          // Chat module message handler registered
        });
        
         function sendMessage() {
           if (!finalMessageInput) return;
           
           const message = finalMessageInput.value.trim();
           if (message) {
             // Show chat messages area on first message
             const messagesContainer = document.querySelector('.chat-messages');
             if (messagesContainer && !messagesContainer.classList.contains('active')) {
               messagesContainer.classList.add('active');
             }
             
             // Hide welcome section
             const welcomeSection = document.querySelector('.welcome-section');
             if (welcomeSection) {
               welcomeSection.style.display = 'none';
             }
             
             // Hide action chips
             const quickActions = document.querySelector('.quick-actions');
             if (quickActions) {
               quickActions.style.display = 'none';
             }
             
             // Add user message to UI
             addMessage(message, 'user');
             
             // Clear input
             finalMessageInput.value = '';
             finalMessageInput.style.height = 'auto';
             
             // Show typing indicator
             showTypingIndicator();
             
             // Clear any existing timeout
             if (window.aiResponseTimeout) {
               clearTimeout(window.aiResponseTimeout);
             }
             
             // Set timeout to hide typing indicator if no response
             window.aiResponseTimeout = setTimeout(() => {
               const typingIndicator = document.getElementById('typing-indicator');
               if (typingIndicator) {
                 hideTypingIndicator();
                 addMessage('Sorry, the AI is taking longer than expected. Please try again.', 'ai');
               }
             }, 30000);
             
             // Send message to main app for processing with session ID
             Shiny.setInputValue('global_message_process', {
               message: message,
               session_id: window.currentSessionId || null,
               timestamp: Date.now()
             }, {priority: 'event'});
           }
         }
        
         function addMessage(content, sender) {
           const messageDiv = document.createElement('div');
           messageDiv.className = `message ${sender}-message`;
           
           const avatar = sender === 'user' ? 
             '<div class=\"message-avatar user-avatar\"><span class=\"icon-user\"></span></div>' :
             '<div class=\"message-avatar ai-avatar\"><span class=\"icon-ai\"></span></div>';
           
           messageDiv.innerHTML = `
             ${avatar}
             <div class=\"message-content\">
               <div class=\"message-text\">${content}</div>
               <div class=\"message-time\">${new Date().toLocaleTimeString()}</div>
             </div>
           `;
           
           if (finalMessagesContainer) {
             finalMessagesContainer.appendChild(messageDiv);
             finalMessagesContainer.scrollTop = finalMessagesContainer.scrollHeight;
           }
         }
        
        function showTypingIndicator() {
          const typingDiv = document.createElement('div');
          typingDiv.className = 'message ai-message typing-indicator';
          typingDiv.id = 'typing-indicator';
          
          typingDiv.innerHTML = `
            <div class=\"message-avatar ai-avatar\"><span class=\"icon-ai\"></span></div>
            <div class=\"message-content\">
              <div class=\"message-text typing-text\">
                <span class=\"typing-dot\"></span>
                <span class=\"typing-dot\"></span>
                <span class=\"typing-dot\"></span>
                <span class=\"typing-text-label\">Baho is typing...</span>
              </div>
            </div>
          `;
          
          if (finalMessagesContainer) {
            finalMessagesContainer.appendChild(typingDiv);
            finalMessagesContainer.scrollTop = finalMessagesContainer.scrollHeight;
          }
        }
        
        function hideTypingIndicator() {
          console.log('Hiding typing indicator...');
          const typingIndicator = document.getElementById('typing-indicator');
          console.log('Typing indicator element:', typingIndicator);
          if (typingIndicator) {
            typingIndicator.remove();
            console.log('Typing indicator removed');
          } else {
            console.log('Typing indicator not found');
          }
        }
        
        // Handle user profile updates
        Shiny.addCustomMessageHandler('updateUserName', function(message) {
          const userNameElement = document.getElementById('", ns("user_name"), "');
          if (userNameElement) {
            userNameElement.textContent = message.name;
          }
        });
        
        Shiny.addCustomMessageHandler('updateUserLocation', function(message) {
          const userLocationElement = document.getElementById('", ns("user_location"), "');
          if (userLocationElement) {
            userLocationElement.textContent = message.location;
          }
        });
        
        Shiny.addCustomMessageHandler('updateUserAvatar', function(message) {
          const userAvatarElement = document.getElementById('", ns("user_avatar"), "');
          if (userAvatarElement) {
            userAvatarElement.textContent = message.avatar;
          }
        });
        
        // Handle AI response
        Shiny.addCustomMessageHandler('aiResponse', function(message) {
          console.log('AI Response received:', message);
          console.log('Message content:', message.content);
          console.log('Message type:', typeof message.content);
          
          // Clear the timeout since we got a response
          if (window.aiResponseTimeout) {
            clearTimeout(window.aiResponseTimeout);
            window.aiResponseTimeout = null;
            console.log('✅ AI response timeout cleared');
          }
          
          hideTypingIndicator();
          addMessage(message.content, 'ai');
          console.log('AI message added to UI');
        });
        
        // Handle loading existing messages
        Shiny.addCustomMessageHandler('loadMessages', function(message) {
          const messagesContainer = document.querySelector('.chat-messages');
          if (messagesContainer && message.messages && message.messages.length > 0) {
            // Show chat area if there are existing messages
            messagesContainer.classList.add('active');
            
            // Hide welcome section
            const welcomeSection = document.querySelector('.welcome-section');
            if (welcomeSection) {
              welcomeSection.style.display = 'none';
            }
            
            // Hide action chips
            const quickActions = document.querySelector('.quick-actions');
            if (quickActions) {
              quickActions.style.display = 'none';
            }
            
            // Add existing messages
            message.messages.forEach(function(msg) {
              addMessage(msg.content, msg.sender);
            });
          }
        });
        
        // Handle session ID updates
        Shiny.addCustomMessageHandler('updateSessionId', function(message) {
          window.currentSessionId = message.session_id;
          console.log('Current session ID updated:', window.currentSessionId);
        });
        
        // Handle recent chats updates
        Shiny.addCustomMessageHandler('updateRecentChats', function(message) {
          // Update recent chats list in sidebar
          const recentChatsList = document.getElementById('", ns("recent_chats_list"), "');
          if (recentChatsList && message.sessions) {
            recentChatsList.innerHTML = '';
            message.sessions.forEach(function(session) {
              const chatItem = document.createElement('div');
              chatItem.className = 'recent-chat-item';
              chatItem.innerHTML = `
                <div class=\"chat-item-content\" onclick=\"loadSession('${session.session_id}')\">
                  <div class=\"chat-item-name\">${session.session_name}</div>
                  <div class=\"chat-item-time\">${new Date(session.last_active).toLocaleDateString()}</div>
                </div>
              `;
              recentChatsList.appendChild(chatItem);
            });
          }
        });
        
        // Function to load a specific session
        window.loadSession = function(sessionId) {
          window.currentSessionId = sessionId;
          // Trigger session load in R
          Shiny.setInputValue('load_session', sessionId, {priority: 'event'});
        };
        
        // Handle AI error
        Shiny.addCustomMessageHandler('aiError', function(message) {
          console.log('AI Error received:', message);
          
          // Clear the timeout since we got an error response
          if (window.aiResponseTimeout) {
            clearTimeout(window.aiResponseTimeout);
            window.aiResponseTimeout = null;
            console.log('✅ AI error timeout cleared');
          }
          
          hideTypingIndicator();
          addMessage('Sorry, I encountered an error. Please try again.', 'ai');
          console.log('AI error message added to UI');
        });
        
        // Handle add message (for compatibility)
        Shiny.addCustomMessageHandler('addMessage', function(message) {
          if (message.sender === 'ai') {
            hideTypingIndicator();
          }
          addMessage(message.content, message.sender);
        });
        
         // Handle clear input
         Shiny.addCustomMessageHandler('clearInput', function(message) {
           if (finalMessageInput) {
             finalMessageInput.value = '';
             finalMessageInput.style.height = 'auto';
           }
         });
       }
       
       // Initialize when DOM is ready
       if (document.readyState === 'loading') {
         document.addEventListener('DOMContentLoaded', initializeChat);
       } else {
         initializeChat();
       }
       
       // Also try after a delay
       setTimeout(initializeChat, 1000);
     "))
  )
}

# Chat Module Server
chatModuleServer <- function(id, auth_module = NULL) {
  moduleServer(id, function(input, output, session) {
    
    # Initialize variables
    db_conn <- NULL
    current_user <- NULL
    current_session_id <- NULL
    chat_sessions <- data.frame()
    
    # Initialize database connection
    tryCatch({
      db_conn <<- db_connect()
    }, error = function(e) {
      db_conn <<- NULL
    })
    
    # Get current user from auth module
    if (!is.null(auth_module)) {
      current_user <<- auth_module$get_current_user()
      if (!is.null(current_user)) {
        # Update user profile in UI
        update_user_profile()
        
        load_user_sessions()
        load_latest_session()
      }
    }
    
    # Function to update user profile in UI
    update_user_profile <- function() {
      if (!is.null(current_user)) {
        # Update user name
        session$sendCustomMessage("updateUserName", list(
          name = current_user$username
        ))
        
        # Update user location
        session$sendCustomMessage("updateUserLocation", list(
          location = ifelse(!is.na(current_user$location) && current_user$location != "", 
                           current_user$location, "Kigali, Rwanda")
        ))
        
        # Update user avatar (first two letters of username)
        avatar_text <- toupper(substr(current_user$username, 1, 2))
        session$sendCustomMessage("updateUserAvatar", list(
          avatar = avatar_text
        ))
        
      }
    }
    
    
    # Load user sessions
    load_user_sessions <- function() {
      if (!is.null(db_conn) && !is.null(current_user)) {
        tryCatch({
          chat_sessions <<- db_functions$get_user_sessions(db_conn, current_user$user_id)
          
          # Update recent chats in UI
          if (nrow(chat_sessions) > 0) {
            session$sendCustomMessage("updateRecentChats", list(
              sessions = chat_sessions
            ))
          }
        }, error = function(e) {
          cat("❌ Error loading user sessions:", e$message, "\n")
        })
      }
    }
    
    # Load latest session
    load_latest_session <- function() {
      if (!is.null(db_conn) && !is.null(current_user)) {
        tryCatch({
          latest_session <- db_functions$get_latest_session(db_conn, current_user$user_id)
          if (nrow(latest_session) > 0) {
            current_session_id <<- latest_session$session_id
            # Send session ID to JavaScript
            session$sendCustomMessage("updateSessionId", list(session_id = current_session_id))
            load_chat_history()
          } else {
            # Create new session if none exist
            current_session_id <<- db_functions$create_chat_session(db_conn, current_user$user_id, "New Chat")
            # Send session ID to JavaScript
            session$sendCustomMessage("updateSessionId", list(session_id = current_session_id))
          }
        }, error = function(e) {
          cat("❌ Error loading latest session:", e$message, "\n")
        })
      }
    }
    
    # Load chat history
    load_chat_history <- function() {
      if (!is.null(db_conn) && !is.null(current_session_id)) {
        tryCatch({
          messages <- db_functions$get_session_messages(db_conn, current_session_id)
          if (nrow(messages) > 0) {
            # Send all messages to UI at once
            messages_list <- list()
            for (i in 1:nrow(messages)) {
              messages_list[[i]] <- list(
                content = messages$content[i],
                sender = messages$sender[i],
                timestamp = messages$created_at[i]
              )
            }
            session$sendCustomMessage("loadMessages", list(messages = messages_list))
          }
        }, error = function(e) {
          cat("❌ Error loading chat history:", e$message, "\n")
        })
      }
    }
    
    # New chat functionality
    observeEvent(input$new_chat, {
      if (!is.null(db_conn) && !is.null(current_user)) {
        tryCatch({
          # Create new session
          current_session_id <<- db_functions$create_chat_session(
            db_conn,
            current_user$user_id,
            "New Chat"
          )
          
          # Send session ID to JavaScript
          session$sendCustomMessage("updateSessionId", list(session_id = current_session_id))
          
          # Clear UI
          session$sendCustomMessage("clearChat", list())
          
          # Reload sessions to update recent chats
          load_user_sessions()
          
        }, error = function(e) {
          cat("❌ Error creating new chat:", e$message, "\n")
        })
      }
    })
    
    # Load specific session
    observeEvent(input$load_session, {
      if (!is.null(db_conn) && !is.null(input$load_session)) {
        tryCatch({
          current_session_id <<- input$load_session
          
          # Send session ID to JavaScript
          session$sendCustomMessage("updateSessionId", list(session_id = current_session_id))
          
          # Load messages for this session
          messages <- db_functions$get_session_messages(db_conn, current_session_id)
          
          # Clear UI and load messages
          session$sendCustomMessage("clearChat", list())
          
          if (nrow(messages) > 0) {
            # Send all messages to UI at once
            messages_list <- list()
            for (i in 1:nrow(messages)) {
              messages_list[[i]] <- list(
                content = messages$content[i],
                sender = messages$sender[i],
                timestamp = messages$created_at[i]
              )
            }
            session$sendCustomMessage("loadMessages", list(messages = messages_list))
          }
          
        }, error = function(e) {
          cat("❌ Error loading session:", e$message, "\n")
        })
      }
    })
    
    # Back to home
    observeEvent(input$back_to_home, {
      # Navigate back to landing page
      session$sendCustomMessage("navigateToHome", list())
    })
    
    
    # Add custom message handler for direct communication
    session$onFlushed(function() {
      session$sendCustomMessage("chatModuleReady", list(ready = TRUE))
    })
    
    # Custom message handler for direct message processing
    session$onFlushed(function() {
      session$sendCustomMessage("registerMessageHandler", list())
    })
    
    
    # Load chat history on startup
    load_chat_history()
    
    # Update user profile when user changes
    observe({
      if (!is.null(auth_module)) {
        current_user <<- auth_module$get_current_user()
        if (!is.null(current_user)) {
          update_user_profile()
        }
      }
    })
    
    # Clean up on session end
    onStop(function() {
      if (!is.null(db_conn)) {
        dbDisconnect(db_conn)
      }
    })
  })
}
