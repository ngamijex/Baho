library(httr)
library(jsonlite)

# Load environment variables from .env file
env_file <- file.path(getwd(), ".env")
if (file.exists(env_file)) {
  readRenviron(env_file)
  print(paste("✅ Loaded .env file from:", env_file))
} else {
  print(paste("⚠️ .env file not found at:", env_file))
}

# Get API key from environment
api_key <- Sys.getenv("OPENAI_API_KEY")

# Check if API key is loaded
if (api_key == "" || is.null(api_key)) {
  # Try alternative: load from .Renviron
  renviron_file <- file.path(Sys.getenv("HOME"), ".Renviron")
  if (file.exists(renviron_file)) {
    readRenviron(renviron_file)
    api_key <- Sys.getenv("OPENAI_API_KEY")
  }
  
  if (api_key == "" || is.null(api_key)) {
    stop("ERROR: OPENAI_API_KEY not found. Please create a .env file with your API key in the project directory.")
  }
}

# Confirm API key is loaded (show only first few characters)
print(paste("✅ API Key loaded:", substr(api_key, 1, 15), "..."))

# OpenAI configuration
OPENAI_CONFIG <- list(
  api_key = api_key,
  model = "gpt-4.1-nano",
  max_tokens = 1000,
  temperature = 0.7
)

# Rwanda-specific system prompt
RWANDA_HEALTH_PROMPT <- "
You are Baho, Rwanda's AI Health Assistant. You are a knowledgeable, compassionate, and culturally sensitive health advisor who speaks fluent Kinyarwanda.

Your expertise includes:
- Rwanda's healthcare system and infrastructure
- All hospitals and health centers across Rwanda (CHUK, King Faisal, Butaro, etc.)
- Local health protocols and procedures
- Common diseases and conditions in Rwanda
- Medication availability and alternatives
- Emergency procedures and contacts
- Traditional medicine integration
- Community health practices
- Maternal and child health
- Infectious disease prevention
- Non-communicable disease management
- Vaccination schedules and programs
- Health insurance (RAMA, Mituelle de Santé)
- Telemedicine services

Guidelines:
1. Always respond in Kinyarwanda unless specifically asked to respond in another language
2. Provide accurate, evidence-based health information
3. Include relevant Rwanda-specific information (hospitals, health centers, contacts)
4. Be culturally appropriate and respectful
5. Encourage professional medical consultation when needed
6. Provide emergency contacts when relevant (112 for emergencies)
7. Use simple, clear language that is easy to understand
8. Include practical advice and next steps
9. Mention relevant health centers or hospitals when appropriate
10. Consider local context and accessibility

Remember: You are not a replacement for professional medical care, but a helpful guide for health information and advice. Always encourage users to seek professional medical help when needed.

Common Rwanda Health Contacts:
- Emergency: 112
- CHUK (Central Hospital): +250 788 123 456
- King Faisal Hospital: +250 788 789 012
- Butaro Hospital: +250 788 345 678
- Rwanda Biomedical Center: +250 788 567 890
"

# OpenAI API functions
openai_functions <- list(
  
  # Send message to OpenAI
  send_message = function(user_message, conversation_history = NULL) {
    
    # Prepare messages array
    messages <- list(
      list(
        role = "system",
        content = RWANDA_HEALTH_PROMPT
      )
    )
    
    # Add conversation history if provided
    if (!is.null(conversation_history) && nrow(conversation_history) > 0) {
      for (i in 1:nrow(conversation_history)) {
        messages <- append(messages, list(
          list(
            role = ifelse(conversation_history$sender[i] == "user", "user", "assistant"),
            content = conversation_history$content[i]
          )
        ))
      }
    }
    
    # Add current user message
    messages <- append(messages, list(
      list(
        role = "user",
        content = user_message
      )
    ))
    
    # Prepare request body
    request_body <- list(
      model = OPENAI_CONFIG$model,
      messages = messages,
      max_tokens = OPENAI_CONFIG$max_tokens,
      temperature = OPENAI_CONFIG$temperature
    )
    
    # Make API request
    response <- httr::POST(
      url = "https://api.openai.com/v1/chat/completions",
      httr::add_headers(
        "Authorization" = paste("Bearer", OPENAI_CONFIG$api_key),
        "Content-Type" = "application/json"
      ),
      body = toJSON(request_body, auto_unbox = TRUE)
    )
    
    # Check for errors
    if (httr::status_code(response) != 200) {
      error_content <- httr::content(response, "text")
      print(paste("❌ OpenAI API Error Status:", httr::status_code(response)))
      print(paste("❌ Error Details:", error_content))
      stop(paste("OpenAI API error:", error_content))
    }
    
    # Parse response
    response_content <- httr::content(response, "parsed")
    
    # Extract AI response
    ai_response <- response_content$choices[[1]]$message$content
    
    return(ai_response)
  },
  
  # Test connection
  test_connection = function() {
    tryCatch({
      test_response <- openai_functions$send_message("Muraho! Ni iki?")
      return(TRUE)
    }, error = function(e) {
      cat("OpenAI API Error:", e$message, "\n")
      return(FALSE)
    })
  }
)
