library(DBI)
library(RPostgres)
library(pool)
library(uuid)
library(digest)  # For password hashing

# Database configuration
# Using Neon cloud database
DB_CONFIG <- list(
  host = Sys.getenv("DB_HOST", "ep-icy-paper-advzlb2s-pooler.c-2.us-east-1.aws.neon.tech"),
  port = as.integer(Sys.getenv("DB_PORT", "5432")),
  dbname = Sys.getenv("DB_NAME", "neondb"),
  user = Sys.getenv("DB_USER", "neondb_owner"),
  password = Sys.getenv("DB_PASSWORD", "npg_j0rKI9WUVbCS"),
  sslmode = "require"  # Required for Neon
)


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
      password = DB_CONFIG$password,
      sslmode = DB_CONFIG$sslmode
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
      sslmode = DB_CONFIG$sslmode,
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
      INSERT INTO public.users (username, email, phone, location, password_hash)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING user_id
    "
    result <- dbGetQuery(pool, query, params = list(username, email, phone, location, hashed_password))
    return(result$user_id)
  },
  
  authenticate_user = function(pool, email, password) {
    # Get user by email first
    query <- "SELECT * FROM public.users WHERE email = $1"
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
    query <- "SELECT * FROM public.users WHERE user_id = $1"
    result <- dbGetQuery(pool, query, params = list(user_id))
    return(result)
  },
  
  get_or_create_user = function(pool, username = "demo_user") {
    # Try to get existing user first
    query <- "SELECT user_id FROM public.users WHERE username = $1 LIMIT 1"
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
      INSERT INTO public.chat_sessions (user_id, session_name)
      VALUES ($1, $2)
      RETURNING session_id
    "
    result <- dbGetQuery(pool, query, params = list(user_id, session_name))
    return(result$session_id)
  },
  
  get_user_sessions = function(pool, user_id) {
    query <- "
      SELECT session_id, session_name, created_at
      FROM public.chat_sessions
      WHERE user_id = $1
      ORDER BY created_at DESC
    "
    result <- dbGetQuery(pool, query, params = list(user_id))
    return(result)
  },
  
  get_latest_session = function(pool, user_id) {
    query <- "
      SELECT session_id, session_name, created_at
      FROM public.chat_sessions
      WHERE user_id = $1
      ORDER BY created_at DESC
      LIMIT 1
    "
    result <- dbGetQuery(pool, query, params = list(user_id))
    return(result)
  },
  
  # Message management
  save_message = function(pool, session_id, content, sender) {
    query <- "
      INSERT INTO public.messages (session_id, content, sender)
      VALUES ($1, $2, $3)
      RETURNING message_id
    "
    result <- dbGetQuery(pool, query, params = list(session_id, content, sender))
    return(result$message_id)
  },
  
  get_session_messages = function(pool, session_id) {
    query <- "
      SELECT message_id, content, sender, created_at
      FROM public.messages
      WHERE session_id = $1
      ORDER BY created_at ASC
    "
    result <- dbGetQuery(pool, query, params = list(session_id))
    return(result)
  },
  
  update_session_timestamp = function(pool, session_id) {
    # Note: last_active column doesn't exist in current schema
    # This function is kept for future use when column is added
    # For now, it does nothing
    return(NULL)
  },
  
  # Delete a chat session and all its messages
  delete_session = function(pool, session_id) {
    tryCatch({
      # First delete all messages in the session
      delete_messages_query <- "
        DELETE FROM public.messages
        WHERE session_id = $1
      "
      dbExecute(pool, delete_messages_query, params = list(session_id))
      
      # Then delete the session itself
      delete_session_query <- "
        DELETE FROM public.chat_sessions
      WHERE session_id = $1
    "
      dbExecute(pool, delete_session_query, params = list(session_id))
      
      cat("✅ Session deleted:", session_id, "\n")
      return(TRUE)
    }, error = function(e) {
      cat("❌ Error deleting session:", e$message, "\n")
      return(FALSE)
    })
  },
  
  # ============================================
  # HEALTH PROGRAMS FUNCTIONS
  # ============================================
  
  # Get all health programs
  get_health_programs = function(pool) {
    tryCatch({
      query <- "SELECT * FROM public.health_programs WHERE is_active = TRUE ORDER BY program_id"
      programs <- dbGetQuery(pool, query)
      return(programs)
    }, error = function(e) {
      cat("Error getting health programs:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Get user's program enrollments
  get_user_enrollments = function(pool, user_id) {
    tryCatch({
      query <- "
        SELECT 
          pe.*,
          hp.program_name,
          hp.program_type,
          hp.description,
          hp.icon,
          hp.color,
          hp.duration_days
        FROM public.program_enrollments pe
        JOIN public.health_programs hp ON pe.program_id = hp.program_id
        WHERE pe.user_id = $1 AND pe.status = 'active'
        ORDER BY pe.enrollment_date DESC
      "
      enrollments <- dbGetQuery(pool, query, params = list(user_id))
      return(enrollments)
    }, error = function(e) {
      cat("Error getting user enrollments:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Enroll user in a program
  enroll_in_program = function(pool, user_id, program_id, start_date, expected_end_date = NULL) {
    tryCatch({
      query <- "
        INSERT INTO public.program_enrollments 
        (user_id, program_id, start_date, expected_end_date, status)
        VALUES ($1, $2, $3, $4, 'active')
        RETURNING enrollment_id
      "
      result <- dbGetQuery(pool, query, params = list(user_id, program_id, start_date, expected_end_date))
      return(result$enrollment_id[1])
    }, error = function(e) {
      cat("Error enrolling in program:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Save maternal health data (9 Months with Baho)
  save_maternal_health_data = function(pool, enrollment_id, user_id, maternal_data) {
    tryCatch({
      query <- "
        INSERT INTO public.maternal_health_data 
        (enrollment_id, user_id, full_name, date_of_birth, phone_number, email, address,
         emergency_contact, emergency_phone, last_menstrual_period, estimated_due_date,
         is_first_pregnancy, number_of_previous_pregnancies, number_of_living_children,
         blood_type, height_cm, pre_pregnancy_weight_kg, chronic_conditions, 
         current_medications, allergies, family_history, health_goals, concerns,
         hospital_name, preferred_language, reminder_frequency)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26)
        RETURNING maternal_id
      "
      result <- dbGetQuery(pool, query, params = list(
        enrollment_id, 
        user_id, 
        maternal_data$full_name, 
        maternal_data$date_of_birth,
        maternal_data$phone, 
        maternal_data$email, 
        maternal_data$address,
        maternal_data$emergency_contact_name, 
        maternal_data$emergency_contact_phone,
        maternal_data$lmp_date, 
        maternal_data$due_date,
        maternal_data$num_pregnancies == 1, 
        as.integer(maternal_data$num_pregnancies),
        as.integer(maternal_data$num_births), 
        maternal_data$blood_type, 
        maternal_data$height,
        maternal_data$pre_pregnancy_weight, 
        maternal_data$medical_conditions, 
        maternal_data$current_medications, 
        maternal_data$allergies, 
        maternal_data$family_history, 
        maternal_data$health_goals, 
        maternal_data$concerns,
        maternal_data$health_facility, 
        maternal_data$preferred_language, 
        maternal_data$reminder_frequency
      ))
      return(result$maternal_id[1])
    }, error = function(e) {
      cat("Error saving maternal health data:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get maternal health data for a user
  get_maternal_health_data = function(pool, user_id) {
    tryCatch({
      query <- "
        SELECT mhd.*, pe.enrollment_date, pe.status as enrollment_status
        FROM public.maternal_health_data mhd
        JOIN public.program_enrollments pe ON mhd.enrollment_id = pe.enrollment_id
        WHERE mhd.user_id = $1 AND pe.status = 'active'
        ORDER BY mhd.created_at DESC
        LIMIT 1
      "
      data <- dbGetQuery(pool, query, params = list(user_id))
      return(data)
    }, error = function(e) {
      cat("Error getting maternal health data:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Save pregnancy tracking data
  save_pregnancy_tracking = function(pool, maternal_id, tracking_data) {
    tryCatch({
      query <- "
        INSERT INTO public.pregnancy_tracking 
        (maternal_id, tracking_date, pregnancy_week, weight_kg, blood_pressure_systolic,
         blood_pressure_diastolic, symptoms, mood, energy_level, felt_baby_movement,
         hours_slept, water_intake_liters, notes)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
        RETURNING tracking_id
      "
      result <- dbGetQuery(pool, query, params = list(
        maternal_id, tracking_data$tracking_date, tracking_data$pregnancy_week,
        tracking_data$weight_kg, tracking_data$blood_pressure_systolic,
        tracking_data$blood_pressure_diastolic, tracking_data$symptoms,
        tracking_data$mood, tracking_data$energy_level, tracking_data$felt_baby_movement,
        tracking_data$hours_slept, tracking_data$water_intake_liters, tracking_data$notes
      ))
      return(result$tracking_id[1])
    }, error = function(e) {
      cat("Error saving pregnancy tracking:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get pregnancy tracking history
  get_pregnancy_tracking_history = function(pool, maternal_id, limit = 30) {
    tryCatch({
      query <- "
        SELECT * FROM public.pregnancy_tracking
        WHERE maternal_id = $1
        ORDER BY tracking_date DESC
        LIMIT $2
      "
      tracking <- dbGetQuery(pool, query, params = list(maternal_id, limit))
      return(tracking)
    }, error = function(e) {
      cat("Error getting pregnancy tracking history:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Schedule pregnancy appointment
  schedule_pregnancy_appointment = function(pool, maternal_id, appointment_data) {
    tryCatch({
      query <- "
        INSERT INTO public.pregnancy_appointments 
        (maternal_id, appointment_type, appointment_date, appointment_time,
         hospital_name, doctor_name, location, notes)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        RETURNING appointment_id
      "
      result <- dbGetQuery(pool, query, params = list(
        maternal_id, appointment_data$appointment_type, appointment_data$appointment_date,
        appointment_data$appointment_time, appointment_data$hospital_name,
        appointment_data$doctor_name, appointment_data$location, appointment_data$notes
      ))
      return(result$appointment_id[1])
    }, error = function(e) {
      cat("Error scheduling appointment:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get upcoming appointments
  get_upcoming_appointments = function(pool, maternal_id) {
    tryCatch({
      query <- "
        SELECT * FROM public.pregnancy_appointments
        WHERE maternal_id = $1 AND appointment_date >= CURRENT_DATE
        AND status IN ('scheduled')
        ORDER BY appointment_date ASC, appointment_time ASC
      "
      appointments <- dbGetQuery(pool, query, params = list(maternal_id))
      return(appointments)
    }, error = function(e) {
      cat("Error getting upcoming appointments:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # ========== CHILD HEALTH FUNCTIONS (1000 Days with Baho) ==========
  
  # Save child health data
  save_child_health_data = function(pool, enrollment_id, user_id, child_data) {
    tryCatch({
      query <- "
        INSERT INTO public.child_health_data 
        (enrollment_id, user_id, child_name, date_of_birth, gender, 
         birth_weight_kg, birth_length_cm, birth_hospital, blood_type, 
         delivery_place, birth_complications, health_conditions, 
         current_medications, caregiver_relationship, caregiver_phone, 
         address, emergency_contact_name, emergency_contact_phone, 
         preferred_health_facility, pediatrician_name)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20)
        RETURNING child_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        enrollment_id,
        user_id,
        child_data$child_name,
        child_data$date_of_birth,
        child_data$gender,
        child_data$birth_weight_kg,
        child_data$birth_length_cm,
        child_data$birth_hospital,
        child_data$blood_type,
        child_data$delivery_place,
        child_data$birth_complications,
        child_data$health_conditions,
        child_data$current_medications,
        child_data$caregiver_relationship,
        child_data$caregiver_phone,
        child_data$address,
        child_data$emergency_contact_name,
        child_data$emergency_contact_phone,
        child_data$preferred_health_facility,
        child_data$pediatrician_name
      ))
      
      return(result$child_id[1])
    }, error = function(e) {
      cat("Error saving child health data:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get child health data for a user
  get_child_health_data = function(pool, user_id) {
    tryCatch({
      query <- "
        SELECT chd.*, pe.enrollment_date, pe.status as enrollment_status
        FROM public.child_health_data chd
        JOIN public.program_enrollments pe ON chd.enrollment_id = pe.enrollment_id
        WHERE chd.user_id = $1 AND pe.status = 'active'
        ORDER BY chd.created_at DESC
        LIMIT 1
      "
      
      result <- dbGetQuery(pool, query, params = list(user_id))
      return(result)
    }, error = function(e) {
      cat("Error getting child health data:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Save child growth tracking
  save_child_growth = function(pool, child_id, growth_data) {
    tryCatch({
      query <- "
        INSERT INTO public.child_growth_tracking 
        (child_id, tracking_date, age_days, weight_kg, height_cm, 
         head_circumference_cm, arm_circumference_cm, notes)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        RETURNING growth_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        child_id,
        growth_data$tracking_date,
        growth_data$age_days,
        growth_data$weight_kg,
        growth_data$height_cm,
        growth_data$head_circumference_cm,
        growth_data$arm_circumference_cm,
        growth_data$notes
      ))
      
      return(result$growth_id[1])
    }, error = function(e) {
      cat("Error saving child growth:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get child growth history
  get_child_growth_history = function(pool, child_id, limit = 30) {
    tryCatch({
      query <- "
        SELECT * FROM public.child_growth_tracking
        WHERE child_id = $1
        ORDER BY tracking_date DESC
        LIMIT $2
      "
      
      result <- dbGetQuery(pool, query, params = list(child_id, limit))
      return(result)
    }, error = function(e) {
      cat("Error getting child growth history:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Save vaccination record
  save_vaccination = function(pool, child_id, vaccination_data) {
    tryCatch({
      query <- "
        INSERT INTO public.child_vaccinations 
        (child_id, vaccine_name, scheduled_date, administered_date, 
         dose_number, health_facility, administered_by, notes, status)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
        RETURNING vaccination_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        child_id,
        vaccination_data$vaccine_name,
        vaccination_data$scheduled_date,
        vaccination_data$administered_date,
        vaccination_data$dose_number,
        vaccination_data$health_facility,
        vaccination_data$administered_by,
        vaccination_data$notes,
        vaccination_data$status
      ))
      
      return(result$vaccination_id[1])
    }, error = function(e) {
      cat("Error saving vaccination:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get vaccination records
  get_child_vaccinations = function(pool, child_id) {
    tryCatch({
      query <- "
        SELECT * FROM public.child_vaccinations
        WHERE child_id = $1
        ORDER BY scheduled_date ASC
      "
      
      result <- dbGetQuery(pool, query, params = list(child_id))
      return(result)
    }, error = function(e) {
      cat("Error getting child vaccinations:", e$message, "\n")
      return(data.frame())
    })
  }
)
