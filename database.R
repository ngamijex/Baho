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
      SELECT DISTINCT cs.session_id, cs.session_name, cs.created_at
      FROM public.chat_sessions cs
      INNER JOIN public.messages m ON cs.session_id = m.session_id
      WHERE cs.user_id = $1
      ORDER BY cs.created_at DESC
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
  
  # Get health program by name
  get_health_program_by_name = function(pool, program_name) {
    tryCatch({
      query <- "SELECT * FROM public.health_programs WHERE program_name = $1 AND is_active = TRUE"
      program <- dbGetQuery(pool, query, params = list(program_name))
      return(program)
    }, error = function(e) {
      cat("Error getting health program by name:", e$message, "\n")
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
  },
  
  # ============= FEEDING LOGS =============
  
  # Save feeding log
  save_feeding_log = function(pool, child_id, user_id, feeding_data) {
    tryCatch({
      # Calculate duration if start and end times provided
      duration <- NULL
      if (!is.null(feeding_data$duration_minutes)) {
        duration <- feeding_data$duration_minutes
      }
      
      query <- "
        INSERT INTO public.feeding_logs 
        (child_id, user_id, feeding_type, feeding_date, feeding_time, 
         amount, duration_minutes, notes)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        RETURNING feeding_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        child_id,
        user_id,
        feeding_data$feeding_type,
        feeding_data$feeding_date %||% Sys.Date(),
        feeding_data$feeding_time %||% format(Sys.time(), "%H:%M:%S"),
        feeding_data$amount %||% NA,
        duration,
        feeding_data$notes %||% NA
      ))
      
      return(result$feeding_id[1])
    }, error = function(e) {
      cat("Error saving feeding log:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get feeding logs
  get_feeding_logs = function(pool, child_id, limit = 20) {
    tryCatch({
      query <- "
        SELECT * FROM public.feeding_logs
        WHERE child_id = $1
        ORDER BY feeding_date DESC, feeding_time DESC
        LIMIT $2
      "
      
      result <- dbGetQuery(pool, query, params = list(child_id, limit))
      return(result)
    }, error = function(e) {
      cat("Error getting feeding logs:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # ============= SLEEP SESSIONS =============
  
  # Save sleep session
  save_sleep_session = function(pool, child_id, user_id, sleep_data) {
    tryCatch({
      # Calculate duration in minutes
      start_time <- as.POSIXct(paste(sleep_data$sleep_date, sleep_data$start_time))
      end_time <- as.POSIXct(paste(sleep_data$sleep_date, sleep_data$end_time))
      
      # Handle overnight sleep
      if (end_time < start_time) {
        end_time <- end_time + 86400  # Add 24 hours
      }
      
      duration_minutes <- as.numeric(difftime(end_time, start_time, units = "mins"))
      
      query <- "
        INSERT INTO public.sleep_sessions 
        (child_id, user_id, sleep_date, start_time, end_time, 
         duration_minutes, sleep_type, quality, notes)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
        RETURNING sleep_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        child_id,
        user_id,
        sleep_data$sleep_date,
        sleep_data$start_time,
        sleep_data$end_time,
        duration_minutes,
        sleep_data$sleep_type %||% "night",
        sleep_data$quality %||% NA,
        sleep_data$notes %||% NA
      ))
      
      return(result$sleep_id[1])
    }, error = function(e) {
      cat("Error saving sleep session:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get sleep sessions
  get_sleep_sessions = function(pool, child_id, limit = 30) {
    tryCatch({
      query <- "
        SELECT * FROM public.sleep_sessions
        WHERE child_id = $1
        ORDER BY sleep_date DESC, start_time DESC
        LIMIT $2
      "
      
      result <- dbGetQuery(pool, query, params = list(child_id, limit))
      return(result)
    }, error = function(e) {
      cat("Error getting sleep sessions:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Get today's sleep summary
  get_today_sleep_summary = function(pool, child_id) {
    tryCatch({
      query <- "
        SELECT 
          COUNT(*) as nap_count,
          SUM(duration_minutes) as total_sleep_minutes
        FROM public.sleep_sessions
        WHERE child_id = $1 AND sleep_date = CURRENT_DATE
      "
      
      result <- dbGetQuery(pool, query, params = list(child_id))
      return(result)
    }, error = function(e) {
      cat("Error getting today's sleep summary:", e$message, "\n")
      return(data.frame(nap_count = 0, total_sleep_minutes = 0))
    })
  },
  
  # ============= APPOINTMENTS =============
  
  # Save appointment
  save_appointment = function(pool, child_id, user_id, appointment_data) {
    tryCatch({
      query <- "
        INSERT INTO public.child_appointments 
        (child_id, user_id, appointment_type, appointment_date, appointment_time,
         provider_name, facility_name, phone, address, purpose, notes, status)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
        RETURNING appointment_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        child_id,
        user_id,
        appointment_data$appointment_type,
        appointment_data$appointment_date,
        appointment_data$appointment_time %||% NA,
        appointment_data$provider_name %||% NA,
        appointment_data$facility_name %||% NA,
        appointment_data$phone %||% NA,
        appointment_data$address %||% NA,
        appointment_data$purpose %||% NA,
        appointment_data$notes %||% NA,
        appointment_data$status %||% "scheduled"
      ))
      
      return(result$appointment_id[1])
    }, error = function(e) {
      cat("Error saving appointment:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get appointments
  get_appointments = function(pool, child_id, status = NULL) {
    tryCatch({
      if (is.null(status)) {
        query <- "
          SELECT * FROM public.child_appointments
          WHERE child_id = $1
          ORDER BY appointment_date ASC
        "
        result <- dbGetQuery(pool, query, params = list(child_id))
      } else {
        query <- "
          SELECT * FROM public.child_appointments
          WHERE child_id = $1 AND status = $2
          ORDER BY appointment_date ASC
        "
        result <- dbGetQuery(pool, query, params = list(child_id, status))
      }
      return(result)
    }, error = function(e) {
      cat("Error getting appointments:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Update appointment status
  update_appointment_status = function(pool, appointment_id, status) {
    tryCatch({
      query <- "
        UPDATE public.child_appointments 
        SET status = $1, updated_at = CURRENT_TIMESTAMP
        WHERE appointment_id = $2
      "
      
      dbExecute(pool, query, params = list(status, appointment_id))
      return(TRUE)
    }, error = function(e) {
      cat("Error updating appointment:", e$message, "\n")
      return(FALSE)
    })
  },
  
  # ============= PHOTOS =============
  
  # Save photo
  save_child_photo = function(pool, child_id, user_id, photo_data) {
    tryCatch({
      query <- "
        INSERT INTO public.child_photos 
        (child_id, user_id, photo_url, photo_data, caption, photo_date,
         age_at_photo_days, milestone_tag, is_milestone)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
        RETURNING photo_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        child_id,
        user_id,
        photo_data$photo_url %||% "",
        photo_data$photo_data %||% NA,
        photo_data$caption %||% NA,
        photo_data$photo_date %||% Sys.Date(),
        photo_data$age_at_photo_days %||% NA,
        photo_data$milestone_tag %||% NA,
        photo_data$is_milestone %||% FALSE
      ))
      
      return(result$photo_id[1])
    }, error = function(e) {
      cat("Error saving photo:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get photos
  get_child_photos = function(pool, child_id, limit = 50) {
    tryCatch({
      query <- "
        SELECT * FROM public.child_photos
        WHERE child_id = $1
        ORDER BY photo_date DESC, created_at DESC
        LIMIT $2
      "
      
      result <- dbGetQuery(pool, query, params = list(child_id, limit))
      return(result)
    }, error = function(e) {
      cat("Error getting photos:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Delete photo
  delete_child_photo = function(pool, photo_id) {
    tryCatch({
      query <- "DELETE FROM public.child_photos WHERE photo_id = $1"
      dbExecute(pool, query, params = list(photo_id))
      return(TRUE)
    }, error = function(e) {
      cat("Error deleting photo:", e$message, "\n")
      return(FALSE)
    })
  },
  
  # ============= MILESTONES =============
  
  # Save or update milestone
  save_milestone = function(pool, child_id, user_id, milestone_data) {
    tryCatch({
      query <- "
        INSERT INTO public.milestone_tracking 
        (child_id, user_id, milestone_name, milestone_category, 
         expected_age_months, achieved, achieved_date, notes)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        ON CONFLICT ON CONSTRAINT milestone_tracking_pkey 
        DO UPDATE SET 
          achieved = EXCLUDED.achieved,
          achieved_date = EXCLUDED.achieved_date,
          notes = EXCLUDED.notes
        RETURNING milestone_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        child_id,
        user_id,
        milestone_data$milestone_name,
        milestone_data$milestone_category %||% NA,
        milestone_data$expected_age_months %||% NA,
        milestone_data$achieved %||% FALSE,
        milestone_data$achieved_date %||% NA,
        milestone_data$notes %||% NA
      ))
      
      return(result$milestone_id[1])
    }, error = function(e) {
      cat("Error saving milestone:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get milestones
  get_milestones = function(pool, child_id) {
    tryCatch({
      query <- "
        SELECT * FROM public.milestone_tracking
        WHERE child_id = $1
        ORDER BY expected_age_months ASC, milestone_name ASC
      "
      
      result <- dbGetQuery(pool, query, params = list(child_id))
      return(result)
    }, error = function(e) {
      cat("Error getting milestones:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Update milestone achievement
  update_milestone_achievement = function(pool, milestone_id, achieved, achieved_date = NULL) {
    tryCatch({
      if (is.null(achieved_date)) {
        achieved_date <- Sys.Date()
      }
      
      query <- "
        UPDATE public.milestone_tracking 
        SET achieved = $1, achieved_date = $2
        WHERE milestone_id = $3
      "
      
      dbExecute(pool, query, params = list(achieved, achieved_date, milestone_id))
      return(TRUE)
    }, error = function(e) {
      cat("Error updating milestone:", e$message, "\n")
      return(FALSE)
    })
  },
  
  # ============= NOTIFICATIONS =============
  
  # Create notification
  create_notification = function(pool, child_id, user_id, notification_data) {
    tryCatch({
      query <- "
        INSERT INTO public.child_notifications 
        (child_id, user_id, notification_type, title, message, 
         due_date, priority)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        RETURNING notification_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        child_id,
        user_id,
        notification_data$notification_type,
        notification_data$title,
        notification_data$message,
        notification_data$due_date %||% NA,
        notification_data$priority %||% "normal"
      ))
      
      return(result$notification_id[1])
    }, error = function(e) {
      cat("Error creating notification:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get notifications
  get_notifications = function(pool, child_id, unread_only = FALSE) {
    tryCatch({
      if (unread_only) {
        query <- "
          SELECT * FROM public.child_notifications
          WHERE child_id = $1 AND is_read = FALSE
          ORDER BY due_date ASC, created_at DESC
        "
      } else {
        query <- "
          SELECT * FROM public.child_notifications
          WHERE child_id = $1
          ORDER BY due_date ASC, created_at DESC
          LIMIT 50
        "
      }
      
      result <- dbGetQuery(pool, query, params = list(child_id))
      return(result)
    }, error = function(e) {
      cat("Error getting notifications:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Mark notification as read
  mark_notification_read = function(pool, notification_id) {
    tryCatch({
      query <- "
        UPDATE public.child_notifications 
        SET is_read = TRUE
        WHERE notification_id = $1
      "
      
      dbExecute(pool, query, params = list(notification_id))
      return(TRUE)
    }, error = function(e) {
      cat("Error marking notification as read:", e$message, "\n")
      return(FALSE)
    })
  },
  
  # ============= CHRONIC DISEASE MANAGEMENT (BAHO FOR LIFE) =============
  
  # Save chronic disease patient
  save_chronic_patient = function(pool, enrollment_id, user_id, patient_data) {
    tryCatch({
      query <- "
        INSERT INTO public.chronic_disease_patients 
        (enrollment_id, user_id, full_name, date_of_birth, gender, phone,
         emergency_contact_name, emergency_contact_phone,
         has_diabetes, has_hypertension, has_heart_disease, has_asthma,
         has_kidney_disease, has_arthritis, other_conditions,
         diagnosis_date, primary_physician, hospital_name,
         insurance_type, insurance_number,
         smoking_status, alcohol_consumption, exercise_frequency,
         allergies, previous_surgeries, family_history)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26)
        RETURNING patient_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        enrollment_id, user_id,
        patient_data$full_name, patient_data$date_of_birth, patient_data$gender, patient_data$phone,
        patient_data$emergency_contact_name %||% NA, patient_data$emergency_contact_phone %||% NA,
        patient_data$has_diabetes %||% FALSE, patient_data$has_hypertension %||% FALSE,
        patient_data$has_heart_disease %||% FALSE, patient_data$has_asthma %||% FALSE,
        patient_data$has_kidney_disease %||% FALSE, patient_data$has_arthritis %||% FALSE,
        patient_data$other_conditions %||% NA,
        patient_data$diagnosis_date %||% NA, patient_data$primary_physician %||% NA,
        patient_data$hospital_name %||% NA,
        patient_data$insurance_type %||% NA, patient_data$insurance_number %||% NA,
        patient_data$smoking_status %||% NA, patient_data$alcohol_consumption %||% NA,
        patient_data$exercise_frequency %||% NA,
        patient_data$allergies %||% NA, patient_data$previous_surgeries %||% NA,
        patient_data$family_history %||% NA
      ))
      
      return(result$patient_id[1])
    }, error = function(e) {
      cat("Error saving chronic patient:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get chronic patient data
  get_chronic_patient_data = function(pool, user_id) {
    tryCatch({
      query <- "
        SELECT * FROM public.chronic_disease_patients
        WHERE user_id = $1
        ORDER BY created_at DESC
        LIMIT 1
      "
      result <- dbGetQuery(pool, query, params = list(user_id))
      return(result)
    }, error = function(e) {
      cat("Error getting chronic patient data:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Add medication
  add_medication = function(pool, patient_id, user_id, med_data) {
    tryCatch({
      query <- "
        INSERT INTO public.patient_medications
        (patient_id, user_id, medication_name, dosage, frequency, time_of_day,
         start_date, end_date, purpose, side_effects, prescribing_doctor,
         is_active, reminder_enabled, notes)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
        RETURNING medication_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        patient_id, user_id,
        med_data$medication_name, med_data$dosage %||% NA, med_data$frequency %||% NA,
        med_data$time_of_day %||% NA, med_data$start_date %||% Sys.Date(),
        med_data$end_date %||% NA, med_data$purpose %||% NA,
        med_data$side_effects %||% NA, med_data$prescribing_doctor %||% NA,
        med_data$is_active %||% TRUE, med_data$reminder_enabled %||% TRUE,
        med_data$notes %||% NA
      ))
      
      return(result$medication_id[1])
    }, error = function(e) {
      cat("Error adding medication:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get patient medications
  get_patient_medications = function(pool, patient_id, active_only = TRUE) {
    tryCatch({
      if (active_only) {
        query <- "
          SELECT * FROM public.patient_medications
          WHERE patient_id = $1 AND is_active = TRUE
          ORDER BY created_at DESC
        "
      } else {
        query <- "
          SELECT * FROM public.patient_medications
          WHERE patient_id = $1
          ORDER BY created_at DESC
        "
      }
      
      result <- dbGetQuery(pool, query, params = list(patient_id))
      return(result)
    }, error = function(e) {
      cat("Error getting medications:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Log medication taken
  log_medication_taken = function(pool, medication_id, patient_id, status, notes = NULL) {
    tryCatch({
      query <- "
        INSERT INTO public.medication_logs
        (medication_id, patient_id, taken_date, taken_time, status, notes)
        VALUES ($1, $2, $3, $4, $5, $6)
        RETURNING log_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        medication_id, patient_id, Sys.Date(),
        format(Sys.time(), "%H:%M:%S"), status, notes %||% NA
      ))
      
      return(result$log_id[1])
    }, error = function(e) {
      cat("Error logging medication:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get medication adherence
  get_medication_adherence = function(pool, patient_id, days = 30) {
    tryCatch({
      query <- "
        SELECT 
          COUNT(*) as total_logs,
          SUM(CASE WHEN status = 'taken' THEN 1 ELSE 0 END) as taken_count
        FROM public.medication_logs
        WHERE patient_id = $1 
        AND taken_date >= CURRENT_DATE - $2
      "
      
      result <- dbGetQuery(pool, query, params = list(patient_id, days))
      return(result)
    }, error = function(e) {
      cat("Error getting adherence:", e$message, "\n")
      return(data.frame(total_logs = 0, taken_count = 0))
    })
  },
  
  # Save vital signs
  save_vital_signs = function(pool, patient_id, user_id, vitals_data) {
    tryCatch({
      query <- "
        INSERT INTO public.vital_signs_records
        (patient_id, user_id, measurement_date, measurement_time,
         systolic_bp, diastolic_bp, blood_glucose, glucose_context,
         heart_rate, temperature, weight_kg, oxygen_saturation,
         cholesterol, bmi, notes, feeling)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
        RETURNING vital_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        patient_id, user_id,
        vitals_data$measurement_date %||% Sys.Date(),
        vitals_data$measurement_time %||% format(Sys.time(), "%H:%M:%S"),
        vitals_data$systolic_bp %||% NA, vitals_data$diastolic_bp %||% NA,
        vitals_data$blood_glucose %||% NA, vitals_data$glucose_context %||% NA,
        vitals_data$heart_rate %||% NA, vitals_data$temperature %||% NA,
        vitals_data$weight_kg %||% NA, vitals_data$oxygen_saturation %||% NA,
        vitals_data$cholesterol %||% NA, vitals_data$bmi %||% NA,
        vitals_data$notes %||% NA, vitals_data$feeling %||% NA
      ))
      
      return(result$vital_id[1])
    }, error = function(e) {
      cat("Error saving vital signs:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get vital signs history
  get_vital_signs_history = function(pool, patient_id, limit = 50) {
    tryCatch({
      query <- "
        SELECT * FROM public.vital_signs_records
        WHERE patient_id = $1
        ORDER BY measurement_date DESC, measurement_time DESC
        LIMIT $2
      "
      
      result <- dbGetQuery(pool, query, params = list(patient_id, limit))
      return(result)
    }, error = function(e) {
      cat("Error getting vital signs history:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Get latest vitals
  get_latest_vitals = function(pool, patient_id) {
    tryCatch({
      query <- "
        SELECT * FROM public.vital_signs_records
        WHERE patient_id = $1
        ORDER BY measurement_date DESC, measurement_time DESC
        LIMIT 1
      "
      
      result <- dbGetQuery(pool, query, params = list(patient_id))
      return(result)
    }, error = function(e) {
      cat("Error getting latest vitals:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Save lab test
  save_lab_test = function(pool, patient_id, user_id, test_data) {
    tryCatch({
      query <- "
        INSERT INTO public.lab_tests
        (patient_id, user_id, test_name, test_category, test_date,
         result_value, reference_range, unit, status,
         ordered_by, lab_facility, interpretation, notes)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
        RETURNING test_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        patient_id, user_id,
        test_data$test_name, test_data$test_category %||% NA, test_data$test_date,
        test_data$result_value %||% NA, test_data$reference_range %||% NA,
        test_data$unit %||% NA, test_data$status %||% "completed",
        test_data$ordered_by %||% NA, test_data$lab_facility %||% NA,
        test_data$interpretation %||% NA, test_data$notes %||% NA
      ))
      
      return(result$test_id[1])
    }, error = function(e) {
      cat("Error saving lab test:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get lab tests
  get_lab_tests = function(pool, patient_id, limit = 20) {
    tryCatch({
      query <- "
        SELECT * FROM public.lab_tests
        WHERE patient_id = $1
        ORDER BY test_date DESC
        LIMIT $2
      "
      
      result <- dbGetQuery(pool, query, params = list(patient_id, limit))
      return(result)
    }, error = function(e) {
      cat("Error getting lab tests:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Log symptom
  log_symptom = function(pool, patient_id, user_id, symptom_data) {
    tryCatch({
      query <- "
        INSERT INTO public.symptoms_diary
        (patient_id, user_id, symptom_date, symptom_time,
         symptom_type, severity, duration, triggers, relief_measures, notes)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
        RETURNING symptom_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        patient_id, user_id,
        symptom_data$symptom_date %||% Sys.Date(),
        symptom_data$symptom_time %||% format(Sys.time(), "%H:%M:%S"),
        symptom_data$symptom_type, symptom_data$severity %||% NA,
        symptom_data$duration %||% NA, symptom_data$triggers %||% NA,
        symptom_data$relief_measures %||% NA, symptom_data$notes %||% NA
      ))
      
      return(result$symptom_id[1])
    }, error = function(e) {
      cat("Error logging symptom:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get symptoms history
  get_symptoms_history = function(pool, patient_id, limit = 30) {
    tryCatch({
      query <- "
        SELECT * FROM public.symptoms_diary
        WHERE patient_id = $1
        ORDER BY symptom_date DESC, symptom_time DESC
        LIMIT $2
      "
      
      result <- dbGetQuery(pool, query, params = list(patient_id, limit))
      return(result)
    }, error = function(e) {
      cat("Error getting symptoms:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Schedule chronic appointment
  schedule_chronic_appointment = function(pool, patient_id, user_id, apt_data) {
    tryCatch({
      query <- "
        INSERT INTO public.chronic_care_appointments
        (patient_id, user_id, appointment_type, appointment_date, appointment_time,
         doctor_name, specialty, hospital_name, location, phone,
         reason, notes, status)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
        RETURNING appointment_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        patient_id, user_id,
        apt_data$appointment_type, apt_data$appointment_date, apt_data$appointment_time %||% NA,
        apt_data$doctor_name %||% NA, apt_data$specialty %||% NA,
        apt_data$hospital_name %||% NA, apt_data$location %||% NA,
        apt_data$phone %||% NA, apt_data$reason %||% NA,
        apt_data$notes %||% NA, apt_data$status %||% "scheduled"
      ))
      
      return(result$appointment_id[1])
    }, error = function(e) {
      cat("Error scheduling appointment:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get chronic appointments
  get_chronic_appointments = function(pool, patient_id, status = NULL) {
    tryCatch({
      if (is.null(status)) {
        query <- "
          SELECT * FROM public.chronic_care_appointments
          WHERE patient_id = $1
          ORDER BY appointment_date ASC
        "
        result <- dbGetQuery(pool, query, params = list(patient_id))
      } else {
        query <- "
          SELECT * FROM public.chronic_care_appointments
          WHERE patient_id = $1 AND status = $2
          ORDER BY appointment_date ASC
        "
        result <- dbGetQuery(pool, query, params = list(patient_id, status))
      }
      return(result)
    }, error = function(e) {
      cat("Error getting appointments:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Create health goal
  create_health_goal = function(pool, patient_id, user_id, goal_data) {
    tryCatch({
      query <- "
        INSERT INTO public.health_goals
        (patient_id, user_id, goal_category, goal_description,
         target_value, current_value, start_date, target_date,
         status, progress_percentage, notes)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
        RETURNING goal_id
      "
      
      result <- dbGetQuery(pool, query, params = list(
        patient_id, user_id,
        goal_data$goal_category, goal_data$goal_description,
        goal_data$target_value %||% NA, goal_data$current_value %||% NA,
        goal_data$start_date %||% Sys.Date(), goal_data$target_date %||% NA,
        goal_data$status %||% "active", goal_data$progress_percentage %||% 0,
        goal_data$notes %||% NA
      ))
      
      return(result$goal_id[1])
    }, error = function(e) {
      cat("Error creating goal:", e$message, "\n")
      return(NULL)
    })
  },
  
  # Get health goals
  get_health_goals = function(pool, patient_id, active_only = TRUE) {
    tryCatch({
      if (active_only) {
        query <- "
          SELECT * FROM public.health_goals
          WHERE patient_id = $1 AND status = 'active'
          ORDER BY created_at DESC
        "
      } else {
        query <- "
          SELECT * FROM public.health_goals
          WHERE patient_id = $1
          ORDER BY created_at DESC
        "
      }
      
      result <- dbGetQuery(pool, query, params = list(patient_id))
      return(result)
    }, error = function(e) {
      cat("Error getting goals:", e$message, "\n")
      return(data.frame())
    })
  },
  
  # Update goal progress
  update_goal_progress = function(pool, goal_id, progress_percentage, current_value = NULL) {
    tryCatch({
      if (!is.null(current_value)) {
        query <- "
          UPDATE public.health_goals
          SET progress_percentage = $1, current_value = $2
          WHERE goal_id = $3
        "
        dbExecute(pool, query, params = list(progress_percentage, current_value, goal_id))
      } else {
        query <- "
          UPDATE public.health_goals
          SET progress_percentage = $1
          WHERE goal_id = $2
        "
        dbExecute(pool, query, params = list(progress_percentage, goal_id))
      }
      
      return(TRUE)
    }, error = function(e) {
      cat("Error updating goal progress:", e$message, "\n")
      return(FALSE)
    })
  }
)
