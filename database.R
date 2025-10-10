library(DBI)
library(RPostgres)
library(pool)
library(uuid)
library(digest)  # For password hashing

# Database configuration
DB_CONFIG <- list( host = "localhost", port = 5432, dbname = "baho_health_ai", user = "postgres", password = "didier" )


# Password hashing functions
hash_password <- function(password) {
  # Use SHA-256 with salt for password hashing
  salt <- "baho_health_ai_salt_2024"
  hashed <- digest(paste0(password, salt), algo = "sha256")
  return(hashed)
}

verify_password <- function(password, hashed_password) {
  # Verify password against hash
  salt <- "baho_health_ai_salt_2024"
  test_hash <- digest(paste0(password, salt), algo = "sha256")
  return(test_hash == hashed_password)
}

# Database Connection
db_connect <- function() {
  tryCatch({
    conn <- dbConnect(
      RPostgres::Postgres(),
      host = DB_CONFIG$host,
      port = DB_CONFIG$port,
      dbname = DB_CONFIG$dbname,
      user = DB_CONFIG$user,
      password = DB_CONFIG$password
    )
    return(conn)
  }, error = function(e) {
    cat("❌ Database connection failed:", e$message, "\n")
    return(NULL)
  })
}

# Create connection pool (alternative method)
create_db_pool <- function() {
  tryCatch({
    pool::dbPool(
      RPostgres::Postgres(),
      host = DB_CONFIG$host,
      port = DB_CONFIG$port,
      dbname = DB_CONFIG$dbname,
      user = DB_CONFIG$user,
      password = DB_CONFIG$password,
      minSize = 1,
      maxSize = 10
    )
  }, error = function(e) {
    cat("❌ Pool creation failed:", e$message, "\n")
    return(NULL)
  })
}

# Database functions
db_functions <- list(
  
  # User management
  create_user = function(pool, username, email = NULL, phone = NULL, location = NULL, password = NULL) {
    # Hash the password before storing
    hashed_password <- hash_password(password)
    
    query <- "
      INSERT INTO users (username, email, phone, location, password_hash)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING user_id
    "
    result <- dbGetQuery(pool, query, params = list(username, email, phone, location, hashed_password))
    return(result$user_id)
  },
  
  authenticate_user = function(pool, email, password) {
    # Get user by email first
    query <- "SELECT * FROM users WHERE email = $1"
    user <- dbGetQuery(pool, query, params = list(email))
    
    if (nrow(user) > 0) {
      # Verify password
      if (verify_password(password, user$password_hash[1])) {
        return(user)
      } else {
        return(data.frame())  # Return empty data frame for wrong password
      }
    } else {
      return(data.frame())  # Return empty data frame for user not found
    }
  },
  
  get_user = function(pool, user_id) {
    query <- "SELECT * FROM users WHERE user_id = $1"
    result <- dbGetQuery(pool, query, params = list(user_id))
    return(result)
  },
  
  get_or_create_user = function(pool, username = "demo_user") {
    # Try to get existing user first
    query <- "SELECT user_id FROM users WHERE username = $1 LIMIT 1"
    result <- dbGetQuery(pool, query, params = list(username))
    
    if (nrow(result) > 0) {
      return(result$user_id)
    } else {
      # Create new user
      return(db_functions$create_user(pool, username, "demo@baho.rw", NULL, "Kigali"))
    }
  },
  
  # Chat session management
  create_chat_session = function(pool, user_id, session_name = "New Chat") {
    query <- "
      INSERT INTO chat_sessions (user_id, session_name)
      VALUES ($1, $2)
      RETURNING session_id
    "
    result <- dbGetQuery(pool, query, params = list(user_id, session_name))
    return(result$session_id)
  },
  
  get_user_sessions = function(pool, user_id) {
    query <- "
      SELECT session_id, session_name, created_at, updated_at
      FROM chat_sessions
      WHERE user_id = $1
      ORDER BY updated_at DESC
    "
    result <- dbGetQuery(pool, query, params = list(user_id))
    return(result)
  },
  
  get_latest_session = function(pool, user_id) {
    query <- "
      SELECT session_id, session_name, created_at, updated_at
      FROM chat_sessions
      WHERE user_id = $1
      ORDER BY updated_at DESC
      LIMIT 1
    "
    result <- dbGetQuery(pool, query, params = list(user_id))
    return(result)
  },
  
  # Message management
  save_message = function(pool, session_id, user_id, content, sender) {
    query <- "
      INSERT INTO messages (session_id, user_id, content, sender)
      VALUES ($1, $2, $3, $4)
      RETURNING message_id
    "
    result <- dbGetQuery(pool, query, params = list(session_id, user_id, content, sender))
    return(result$message_id)
  },
  
  get_session_messages = function(pool, session_id) {
    query <- "
      SELECT message_id, content, sender, created_at
      FROM messages
      WHERE session_id = $1
      ORDER BY created_at ASC
    "
    result <- dbGetQuery(pool, query, params = list(session_id))
    return(result)
  },
  
  update_session_timestamp = function(pool, session_id) {
    query <- "
      UPDATE chat_sessions
      SET updated_at = CURRENT_TIMESTAMP
      WHERE session_id = $1
    "
    dbExecute(pool, query, params = list(session_id))
  }
)
