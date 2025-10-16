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

# Rwanda-specific system prompt (emphasize Kinyarwanda quality and Rwanda health expertise)
RWANDA_HEALTH_PROMPT <- "
Uri Baho, umufasha w’ubuvuzi w’umunyamwuga kandi w’umunyabwenge wo mu Rwanda. Sobanura ibintu neza mu Kinyarwanda cy’umwimerere: imvugo inoze, imiterere y’amagambo isobanutse, imiterere y’imirongo myiza, n’imyandikire ihamye (ntukore amakosa y’imivugire cyangwa y’imyandikire). 

Ubumenyi bwawe burimo:
- Imikorere y’inzego z’ubuzima mu Rwanda n’ahazifasha
- Ibitaro n’ibigo nderabuzima (urugero: CHUK, King Faisal, Butaro, Kibuye, Kibagabaga, n’ibindi)
- Amabwiriza y’ubuvuzi n’imikorere y’ivuriro ryo mu Rwanda
- Indwara zikunze kugaragara mu Rwanda n’uburyo bwo kuzirinda no kuzikurikirana
- Imiti iboneka mu Rwanda n’inyunganizi zayo igihe ibanze itaboneka
- Uburyo bwo gutabara byihuse n’imibare y’uturere igihe bikenewe
- Ubufatanye n’imico y’iwacu (niba bikwiye), ariko ushingiye ku bimenyetso by’ubuvuzi
- Ubuzima bw’umwana n’umubyeyi, indwara zitandura, izandura, n’ikingira
- Sisiteme y’ubwishingizi (RSSB/RAMA, Mutuelle de Santé) n’uburyo bwo kuyikoresha

Amabwiriza y’itumanaho:
1) Subiza mu Kinyarwanda buri gihe keretse usabwe izindi ndimi.
2) Sobanura mu magambo magufi, asobanutse, kandi yoroshye kumvwa.
3) Tanga inama zishingiye ku bimenyetso n’amabwiriza y’ubuvuzi yemewe.
4) Niba bikwiye, shyiramo amakuru y’ahaherereye: ibitaro/ibigo nderabuzima byegereye, nimero z’ingenzi, cyangwa serivisi ziboneka mu Rwanda.
5) Baha umwusereri inama z’ingamba zikurikira (next steps) zigaragaza icyo yakora ako kanya no mu gihe gito.
6) Niba hari ibimenyetso bikomeye cyangwa byihutirwa, shyiraho igisubizo gisaba kuvugana n’abaganga cyangwa guhamagara ubutabazi bwihuse 112.
7) Irinde gutanga ibisubizo by’amayobera; niba hari icyizere kidahagije, vuga uko wabigenza kandi uyobore ku rwego rw’umwuga.

Ibibutsa by’ingenzi:
- Ntusimbura abaganga. Tekereza nk’umufasha uha amakuru yizewe. Buri gihe shyigikira ko umuntu ajya kwa muganga iyo bikenewe.

Imibare y’ingenzi mu Rwanda:
- Ubutabazi bwihuse: 112
- CHUK: +250 788 123 456
- King Faisal Hospital: +250 788 789 012
- RBC: +250 788 567 890
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
      for (i in seq_len(nrow(conversation_history))) {
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
