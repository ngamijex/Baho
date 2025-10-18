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
        
        # Sidebar Header (fixed at top)
        tags$div(
          class = "sidebar-header",
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
          )
        ),
        
        # Sidebar Content (scrollable)
        tags$div(
          class = "sidebar-content",
          # Recent Chats Section
          tags$div(
            class = "recent-section",
            tags$h3(class = "section-title", "Recent Chats"),
            tags$div(
              class = "recent-chats",
              id = ns("recent_chats_list")
              # Will be populated dynamically
            )
          )
        ),
        
        # Sidebar Footer (fixed at bottom)
        tags$div(
          class = "sidebar-footer",
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
             
            // Get session and user IDs from data attributes
            const sessionId = document.body.getAttribute('data-session-id');
            const userId = document.body.getAttribute('data-user-id');
            
            // Send message to main app for processing
            Shiny.setInputValue('global_message_process', {
              message: message,
              session_id: sessionId,
              user_id: userId,
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
          console.log('📝 Received updateUserName:', message.name);
          console.log('Looking for element with ID:', '", ns("user_name"), "');
          
          // Try multiple approaches to find the element
          let userNameElement = document.getElementById('", ns("user_name"), "');
          
          if (!userNameElement) {
            // Try querySelector as backup
            userNameElement = document.querySelector('.profile-name');
            console.log('Trying querySelector .profile-name:', userNameElement);
          }
          
          if (userNameElement) {
            userNameElement.textContent = message.name;
            console.log('✅ Updated user name to:', message.name);
          } else {
            console.log('❌ User name element not found');
            console.log('All elements with profile-name class:', document.querySelectorAll('.profile-name'));
          }
        });
        
        Shiny.addCustomMessageHandler('updateUserLocation', function(message) {
          console.log('📝 Received updateUserLocation:', message.location);
          let userLocationElement = document.getElementById('", ns("user_location"), "');
          
          if (!userLocationElement) {
            userLocationElement = document.querySelector('.profile-plan');
            console.log('Trying querySelector .profile-plan:', userLocationElement);
          }
          
          if (userLocationElement) {
            userLocationElement.textContent = message.location;
            console.log('✅ Updated user location to:', message.location);
          } else {
            console.log('❌ User location element not found');
          }
        });
        
        Shiny.addCustomMessageHandler('updateUserAvatar', function(message) {
          console.log('📝 Received updateUserAvatar:', message.avatar);
          let userAvatarElement = document.getElementById('", ns("user_avatar"), "');
          
          if (!userAvatarElement) {
            userAvatarElement = document.querySelector('.profile-avatar span');
            console.log('Trying querySelector .profile-avatar span:', userAvatarElement);
          }
          
          if (userAvatarElement) {
            userAvatarElement.textContent = message.avatar;
            console.log('✅ Updated user avatar to:', message.avatar);
          } else {
            console.log('❌ User avatar element not found');
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
          console.log('📨 Received loadMessages:', message);
          console.log('Number of messages:', message.messages ? message.messages.length : 0);
          
          const messagesContainer = document.querySelector('.chat-messages');
          if (messagesContainer && message.messages && message.messages.length > 0) {
            console.log('✅ Loading', message.messages.length, 'messages');
            
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
            message.messages.forEach(function(msg, index) {
              console.log('Adding message', index + 1, ':', msg.sender, '-', msg.content.substring(0, 50) + '...');
              addMessage(msg.content, msg.sender);
            });
            
            console.log('✅ All messages loaded successfully');
          } else {
            console.log('❌ Cannot load messages:', {
              container: !!messagesContainer,
              messages: !!message.messages,
              length: message.messages ? message.messages.length : 0
            });
          }
        });
        
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
         
         // Handle update recent chats
         // Show loading indicator for recent chats
         Shiny.addCustomMessageHandler('showRecentChatsLoader', function(data) {
           let recentChatsContainer = document.getElementById('", ns("recent_chats_list"), "');
           if (!recentChatsContainer) {
             recentChatsContainer = document.querySelector('.recent-chats');
           }
           
           if (recentChatsContainer) {
             recentChatsContainer.innerHTML = `
               <div class='recent-chats-loader'>
                 <div class='recent-chats-spinner'></div>
                 <div class='recent-chats-loader-text'>Loading your chats...</div>
               </div>
             `;
           }
         });
         
         Shiny.addCustomMessageHandler('updateRecentChats', function(data) {
           console.log('📂 Received updateRecentChats:', data);
           console.log('Looking for element with ID:', '", ns("recent_chats_list"), "');
           
           // Try multiple approaches to find the container
           let recentChatsContainer = document.getElementById('", ns("recent_chats_list"), "');
           
           if (!recentChatsContainer) {
             recentChatsContainer = document.querySelector('.recent-chats');
             console.log('Trying querySelector .recent-chats:', recentChatsContainer);
           }
           
           console.log('Recent chats container:', recentChatsContainer);
           
           if (recentChatsContainer && data.sessions) {
             console.log('Updating', data.sessions.length, 'sessions');
             recentChatsContainer.innerHTML = '';
             
             data.sessions.forEach(function(session, index) {
               console.log('Adding session', index + 1, ':', session.session_name, '(ID:', session.session_id, ')');
               const chatItem = document.createElement('div');
               chatItem.className = 'recent-chat-item';
               chatItem.setAttribute('data-session-id', session.session_id);
               chatItem.style.cursor = 'pointer'; // Make sure it's clickable
               chatItem.innerHTML = `
                 <div class='chat-item-icon'>
                   <i class='fas fa-comment-dots'></i>
                 </div>
                 <div class='chat-item-content'>
                   <div class='chat-item-title'>${session.session_name}</div>
                   <div class='chat-item-time'>${session.last_active}</div>
                 </div>
                 <div class='chat-item-actions'>
                   <button class='chat-delete-btn' data-session-id='${session.session_id}' title='Delete chat'>
                     <i class='fas fa-trash-alt'></i>
                   </button>
                 </div>
               `;
               
               // Add hover effect
               chatItem.addEventListener('mouseenter', function() {
                 console.log('🖱️ Hovering over session:', session.session_name);
               });
               
               // Handle delete button click
               const deleteBtn = chatItem.querySelector('.chat-delete-btn');
               deleteBtn.addEventListener('click', function(e) {
                 e.stopPropagation(); // Prevent triggering the chat item click
                 console.log('🗑️ Delete button clicked for session:', session.session_id);
                 
                 // Confirm deletion
                 if (confirm('Are you sure you want to delete this chat?')) {
                   try {
                     Shiny.setInputValue('global_delete_session', {
                       session_id: session.session_id,
                       timestamp: Date.now()
                     }, {priority: 'event'});
                     console.log('✅ Delete request sent for session:', session.session_id);
                   } catch (err) {
                     console.error('❌ Error deleting session:', err);
                   }
                 }
               });
               
               chatItem.addEventListener('click', function(e) {
                 // Don't trigger if clicking on delete button
                 if (e.target.closest('.chat-delete-btn')) return;
                 
                 console.log('🖱️ Chat item clicked! Session:', session.session_name);
                 console.log('Session ID:', session.session_id);
                 
                 try {
                   // Use GLOBAL input (not module-scoped)
                   const inputValue = {
                     session_id: session.session_id,
                     timestamp: Date.now()
                   };
                   Shiny.setInputValue('global_load_session', inputValue, {priority: 'event'});
                   console.log('✅ Global method - Shiny.setInputValue called with:', inputValue);
                 } catch (err) {
                   console.error('❌ Error:', err);
                 }
               });
               
               recentChatsContainer.appendChild(chatItem);
               console.log('✅ Session', index + 1, 'added to DOM');
             });
             console.log('✅ Recent chats updated successfully');
           } else {
             if (!recentChatsContainer) {
               console.log('❌ Recent chats container not found');
               console.log('Available elements with .recent-chats class:', document.querySelectorAll('.recent-chats'));
             }
             if (!data.sessions) {
               console.log('❌ No sessions data');
             } else if (data.sessions.length === 0) {
               console.log('ℹ️ User has no chat sessions yet');
             }
           }
         });
         
         // Handle clear chat
         Shiny.addCustomMessageHandler('clearChat', function(message) {
           if (finalMessagesContainer) {
             finalMessagesContainer.innerHTML = '';
             finalMessagesContainer.classList.remove('active');
           }
           
           const welcomeSection = document.querySelector('.welcome-section');
           if (welcomeSection) {
             welcomeSection.style.display = 'flex';
           }
           
           const quickActions = document.querySelector('.quick-actions');
           if (quickActions) {
             quickActions.style.display = 'flex';
           }
         });
         
         // Handle set session ID
         Shiny.addCustomMessageHandler('setSessionId', function(data) {
           console.log('📂 Setting session ID:', data.session_id);
           document.body.setAttribute('data-session-id', data.session_id);
           console.log('✅ Session ID attribute set');
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
      if (!is.null(db_conn)) {
        cat("✅ Chat: Database connection successful!\n")
      } else {
        cat("❌ Chat: Database connection returned NULL\n")
      }
    }, error = function(e) {
      cat("❌ Chat: Database connection error:", e$message, "\n")
      db_conn <<- NULL
    })
    
    # Get current user from auth module - observe the reactive
    observe({
      req(auth_module)
      user <- auth_module$get_current_user()
      
      if (!is.null(user)) {
        current_user <<- user
        cat("✅ Current user loaded:", current_user$username, "\n")
        
        # Minimal delay to ensure DOM is ready (50ms)
        shinyjs::delay(50, {
          cat("🔄 Delayed execution starting...\n")
          # Update user profile in UI
          update_user_profile()
          
          # Set user and session IDs in data attributes
          shinyjs::runjs(sprintf("document.body.setAttribute('data-user-id', '%s');", current_user$user_id))
          
          # Load sessions list and create a fresh new session (without loading history)
          load_user_sessions()
          initialize_new_session()
        })
      }
    })
    
    # Function to update user profile in UI
    update_user_profile <- function() {
      if (!is.null(current_user)) {
        cat("📝 Updating user profile for:", current_user$username, "\n")
        
        # Update user name
        session$sendCustomMessage("updateUserName", list(
          name = current_user$username
        ))
        cat("✅ Sent updateUserName:", current_user$username, "\n")
        
        # Update user location
        location <- ifelse(!is.na(current_user$location) && current_user$location != "", 
                          current_user$location, "Kigali, Rwanda")
        session$sendCustomMessage("updateUserLocation", list(
          location = location
        ))
        cat("✅ Sent updateUserLocation:", location, "\n")
        
        # Update user avatar (first two letters of username)
        avatar_text <- toupper(substr(current_user$username, 1, 2))
        session$sendCustomMessage("updateUserAvatar", list(
          avatar = avatar_text
        ))
        cat("✅ Sent updateUserAvatar:", avatar_text, "\n")
      }
    }
    
    
    # Load user sessions
    load_user_sessions <- function() {
      # Show loading indicator first
      session$sendCustomMessage("showRecentChatsLoader", list())
      
      # Retry database connection if needed
      if (is.null(db_conn)) {
        cat("🔄 Retrying database connection...\n")
        tryCatch({
          db_conn <<- db_connect()
          if (!is.null(db_conn)) {
            cat("✅ Chat: Database reconnection successful!\n")
          }
        }, error = function(e) {
          cat("❌ Chat: Database reconnection failed:", e$message, "\n")
        })
      }
      
      if (!is.null(db_conn) && !is.null(current_user)) {
        tryCatch({
          cat("📂 Loading sessions for user:", current_user$user_id, "\n")
          chat_sessions <<- db_functions$get_user_sessions(db_conn, current_user$user_id)
          cat("📂 Found", nrow(chat_sessions), "sessions\n")
          
          # Update recent chats in UI
          if (nrow(chat_sessions) > 0) {
            # OPTIMIZATION: Get all first messages in ONE query using IN clause
            first_msg_map <- list()
            tryCatch({
              cat("🔍 Fetching first messages for", nrow(chat_sessions), "sessions\n")
              
              # Create placeholders for IN clause: $1, $2, $3, ...
              placeholders <- paste0("$", 1:nrow(chat_sessions), collapse = ", ")
              first_messages_query <- sprintf("
                SELECT DISTINCT ON (m.session_id) 
                  m.session_id, 
                  m.content as first_message
                FROM public.messages m
                WHERE m.session_id IN (%s) AND m.sender = 'user'
                ORDER BY m.session_id, m.created_at ASC
              ", placeholders)
              
              # Pass session IDs as separate parameters
              first_messages <- dbGetQuery(db_conn, first_messages_query, 
                                          params = as.list(chat_sessions$session_id))
              
              cat("✅ Fetched", nrow(first_messages), "first messages\n")
              
              # Create a lookup map for fast access
              if (nrow(first_messages) > 0) {
                first_msg_map <- setNames(first_messages$first_message, first_messages$session_id)
                cat("✅ Created lookup map with", length(first_msg_map), "entries\n")
              }
            }, error = function(e) {
              cat("⚠️ Could not fetch first messages in batch:", e$message, "\n")
            })
            
            # Now create titles using the pre-fetched data
            sessions_with_titles <- lapply(1:nrow(chat_sessions), function(i) {
              session_row <- chat_sessions[i, ]
              
              # Try to get first message from our batch query (safely)
              first_msg <- tryCatch({
                if (length(first_msg_map) > 0 && session_row$session_id %in% names(first_msg_map)) {
                  first_msg_map[[session_row$session_id]]
                } else {
                  NULL
                }
              }, error = function(e) NULL)
              
              # Generate title
              title <- tryCatch({
                if (!is.null(first_msg) && !is.na(first_msg) && nchar(first_msg) > 0) {
                  words <- strsplit(first_msg, " ")[[1]]
                  if (length(words) > 0) {
                    msg_title <- paste(words[1:min(5, length(words))], collapse = " ")
                    if (length(words) > 5) msg_title <- paste0(msg_title, "...")
                    msg_title
                  } else {
                    "New Chat"
                  }
                } else if (!is.na(session_row$session_name) && nchar(session_row$session_name) > 0 && session_row$session_name != "New Chat") {
                  session_row$session_name
                } else {
                  "New Chat"
                }
              }, error = function(e) {
                "New Chat"
              })
              
              list(
                session_id = session_row$session_id,
                session_name = title,
                last_active = format(session_row$created_at, "%Y-%m-%d %H:%M")
              )
            })
            
            cat("✅ Sending updateRecentChats with", length(sessions_with_titles), "sessions\n")
            session$sendCustomMessage("updateRecentChats", list(
              sessions = sessions_with_titles
            ))
          } else {
            cat("ℹ️ No sessions found for user\n")
          }
        }, error = function(e) {
          cat("❌ Error loading user sessions:", e$message, "\n")
        })
      } else {
        cat("❌ Cannot load sessions: db_conn=", !is.null(db_conn), ", current_user=", !is.null(current_user), "\n")
      }
    }
    
    # Initialize a new session (without loading history)
    initialize_new_session <- function() {
      # Retry database connection if needed
      if (is.null(db_conn)) {
        cat("🔄 Retrying database connection for new session...\n")
        tryCatch({
          db_conn <<- db_connect()
        }, error = function(e) {
          cat("❌ Chat: Database reconnection failed\n")
        })
      }
      
      if (!is.null(db_conn) && !is.null(current_user)) {
        tryCatch({
          # Always create a fresh new session on login
          current_session_id <<- db_functions$create_chat_session(db_conn, current_user$user_id, "New Chat")
          cat("✅ Created new session:", current_session_id, "\n")
          # Set session ID in data attribute
          shinyjs::runjs(sprintf("document.body.setAttribute('data-session-id', '%s');", current_session_id))
          # Don't load any history - start with clean chat
        }, error = function(e) {
          cat("❌ Error creating new session:", e$message, "\n")
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
          
          # Set session ID in data attribute
          shinyjs::runjs(sprintf("document.body.setAttribute('data-session-id', '%s');", current_session_id))
          
          # Clear UI
          session$sendCustomMessage("clearChat", list())
          
          # Reload sessions to update recent chats
          load_user_sessions()
          
        }, error = function(e) {
          cat("❌ Error creating new chat:", e$message, "\n")
        })
      }
    })
    
    # Debug: Monitor all changes to load_session input
    observe({
      if (!is.null(input$load_session)) {
        cat("🔍 DEBUG Method 1: input$load_session changed\n")
        cat("  Type:", class(input$load_session), "\n")
        cat("  Value:", toString(input$load_session), "\n")
      }
    })
    
    # Debug: Monitor alternative method
    observe({
      if (!is.null(input$load_session_direct)) {
        cat("🔍 DEBUG Method 2: input$load_session_direct changed\n")
        cat("  Type:", class(input$load_session_direct), "\n")
        cat("  Value:", toString(input$load_session_direct), "\n")
      }
    })
    
    # Debug: Monitor socket method
    observe({
      if (!is.null(input$load_session_socket)) {
        cat("🔍 DEBUG Method 3: input$load_session_socket changed\n")
        cat("  Type:", class(input$load_session_socket), "\n")
        cat("  Value:", toString(input$load_session_socket), "\n")
      }
    })
    
    # Helper function to load a session by ID
    load_session_by_id <- function(session_id) {
      cat("🔄 Loading session by ID:", session_id, "\n")
      
      # Retry database connection if needed
      if (is.null(db_conn)) {
        cat("🔄 Retrying database connection for session loading...\n")
        tryCatch({
          db_conn <<- db_connect()
        }, error = function(e) {
          cat("❌ Database reconnection failed\n")
          return()
        })
      }
      
      if (!is.null(db_conn)) {
        tryCatch({
          current_session_id <<- session_id
          cat("✅ Loading session:", current_session_id, "\n")
          
          # Set session ID in data attribute
          shinyjs::runjs(sprintf("document.body.setAttribute('data-session-id', '%s');", current_session_id))
          
          # Load messages for this session
          messages <- db_functions$get_session_messages(db_conn, current_session_id)
          cat("📨 Found", nrow(messages), "messages in session\n")
          
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
            cat("✅ Sending", length(messages_list), "messages to UI\n")
            session$sendCustomMessage("loadMessages", list(messages = messages_list))
          } else {
            cat("ℹ️ No messages in this session\n")
          }
          
        }, error = function(e) {
          cat("❌ Error loading session:", e$message, "\n")
        })
      } else {
        cat("❌ Cannot load session: db_conn is NULL\n")
      }
    }
    
    # Observer for trigger_load (from global app via custom message)
    observeEvent(input$trigger_load, {
      cat("📂 Trigger load received in module\n")
      req(input$trigger_load)
      
      session_id <- if (is.list(input$trigger_load)) {
        input$trigger_load$session_id
      } else {
        input$trigger_load
      }
      
      if (!is.null(session_id) && nzchar(session_id)) {
        cat("✅ Triggering load_session_by_id with:", session_id, "\n")
        load_session_by_id(session_id)
      }
    })
    
    # Alternative observer for load_session_direct
    observeEvent(input$load_session_direct, {
      cat("📂 Method 2 triggered - load_session_direct\n")
      req(input$load_session_direct)
      
      session_id <- if (is.list(input$load_session_direct)) {
        input$load_session_direct$session_id
      } else {
        input$load_session_direct
      }
      
      if (!is.null(session_id) && nzchar(session_id)) {
        load_session_by_id(session_id)
      }
    })
    
    # Alternative observer for load_session_socket
    observeEvent(input$load_session_socket, {
      cat("📂 Method 3 triggered - load_session_socket\n")
      req(input$load_session_socket)
      
      session_id <- if (is.list(input$load_session_socket)) {
        input$load_session_socket$session_id
      } else {
        input$load_session_socket
      }
      
      if (!is.null(session_id) && nzchar(session_id)) {
        load_session_by_id(session_id)
      }
    })
    
    # Main observer for load_session
    observeEvent(input$load_session, {
      req(input$load_session)  # Require non-NULL value
      
      # Extract session_id from the object
      session_id <- if (is.list(input$load_session)) {
        input$load_session$session_id
      } else {
        input$load_session
      }
      
      req(session_id)  # Require non-NULL session_id
      req(nzchar(session_id))  # Require non-empty string
      
      cat("📂 Load session triggered with ID:", session_id, "\n")
      
      # Retry database connection if needed
      if (is.null(db_conn)) {
        cat("🔄 Retrying database connection for session loading...\n")
        tryCatch({
          db_conn <<- db_connect()
        }, error = function(e) {
          cat("❌ Database reconnection failed\n")
        })
      }
      
      if (!is.null(db_conn)) {
        tryCatch({
          current_session_id <<- session_id
          cat("✅ Loading session:", current_session_id, "\n")
          
          # Set session ID in data attribute
          shinyjs::runjs(sprintf("document.body.setAttribute('data-session-id', '%s');", current_session_id))
          
          # Load messages for this session
          messages <- db_functions$get_session_messages(db_conn, current_session_id)
          cat("📨 Found", nrow(messages), "messages in session\n")
          
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
            cat("✅ Sending", length(messages_list), "messages to UI\n")
            session$sendCustomMessage("loadMessages", list(messages = messages_list))
          } else {
            cat("ℹ️ No messages in this session\n")
          }
          
        }, error = function(e) {
          cat("❌ Error loading session:", e$message, "\n")
        })
      } else {
        cat("❌ Cannot load session: db_conn=", !is.null(db_conn), ", input$load_session=", !is.null(input$load_session), "\n")
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
      
      # Update user profile and sessions when module is ready
      if (!is.null(current_user)) {
        cat("🔄 Module flushed, updating profile and sessions\n")
        update_user_profile()
        load_user_sessions()
      }
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
