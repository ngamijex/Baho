-- Health Programs Database Schema for BahoAI
-- Programs: 9 Months with Baho, 1000 Days with Baho, Baho for Life

-- =============================================
-- 1. HEALTH PROGRAMS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS public.health_programs (
    program_id SERIAL PRIMARY KEY,
    program_name VARCHAR(100) NOT NULL UNIQUE,
    program_type VARCHAR(50) NOT NULL, -- 'pregnancy', 'childcare', 'chronic_care'
    description TEXT,
    duration_days INTEGER, -- Total program duration
    icon VARCHAR(50), -- Emoji or icon identifier
    color VARCHAR(20), -- UI color theme
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default programs
INSERT INTO public.health_programs (program_name, program_type, description, duration_days, icon, color) VALUES
('9 Months with Baho', 'pregnancy', 'Comprehensive pregnancy monitoring from conception to childbirth. Track your health, baby development, appointments, and receive personalized guidance.', 280, '🤰', '#FF6B9D'),
('1000 Days with Baho', 'childcare', 'Child development tracking from birth through age 2. Monitor growth milestones, vaccinations, nutrition, and get expert childcare advice.', 1000, '👶', '#4ECDC4'),
('Baho for Life', 'chronic_care', 'Chronic disease management and healthy lifestyle support. Track medications, appointments, vitals, and maintain long-term wellness.', NULL, '❤️', '#95E1D3')
ON CONFLICT (program_name) DO NOTHING;

-- =============================================
-- 2. PROGRAM ENROLLMENTS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS public.program_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE,
    program_id INTEGER NOT NULL REFERENCES public.health_programs(program_id) ON DELETE CASCADE,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active', -- 'active', 'completed', 'paused', 'cancelled'
    start_date DATE NOT NULL,
    expected_end_date DATE,
    actual_end_date DATE,
    completion_percentage DECIMAL(5,2) DEFAULT 0.00,
    notes TEXT,
    UNIQUE(user_id, program_id, status) -- One active enrollment per program per user
);

-- =============================================
-- 3. MATERNAL HEALTH DATA (9 Months with Baho)
-- =============================================
CREATE TABLE IF NOT EXISTS public.maternal_health_data (
    maternal_id SERIAL PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES public.program_enrollments(enrollment_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE,
    
    -- Personal Information
    full_name VARCHAR(200) NOT NULL,
    date_of_birth DATE NOT NULL,
    age INTEGER,
    phone_number VARCHAR(20),
    emergency_contact VARCHAR(200),
    emergency_phone VARCHAR(20),
    
    -- Pregnancy Details
    last_menstrual_period DATE NOT NULL,
    estimated_due_date DATE NOT NULL,
    current_week INTEGER DEFAULT 1,
    current_trimester INTEGER DEFAULT 1, -- 1, 2, or 3
    is_first_pregnancy BOOLEAN DEFAULT FALSE,
    number_of_previous_pregnancies INTEGER DEFAULT 0,
    number_of_living_children INTEGER DEFAULT 0,
    
    -- Health Information
    blood_type VARCHAR(10),
    height_cm DECIMAL(5,2),
    pre_pregnancy_weight_kg DECIMAL(5,2),
    current_weight_kg DECIMAL(5,2),
    bmi DECIMAL(5,2),
    
    -- Medical History
    chronic_conditions TEXT[], -- Array of conditions
    allergies TEXT[], -- Array of allergies
    previous_pregnancy_complications TEXT,
    current_medications TEXT[],
    
    -- Healthcare Provider
    hospital_name VARCHAR(200),
    doctor_name VARCHAR(200),
    doctor_phone VARCHAR(20),
    insurance_type VARCHAR(100), -- 'Mutuelle', 'RAMA', 'Private', etc.
    insurance_number VARCHAR(100),
    
    -- Preferences
    preferred_language VARCHAR(20) DEFAULT 'kinyarwanda',
    preferred_contact_method VARCHAR(20) DEFAULT 'app', -- 'app', 'sms', 'call'
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 4. PREGNANCY TRACKING DATA
-- =============================================
CREATE TABLE IF NOT EXISTS public.pregnancy_tracking (
    tracking_id SERIAL PRIMARY KEY,
    maternal_id INTEGER NOT NULL REFERENCES public.maternal_health_data(maternal_id) ON DELETE CASCADE,
    tracking_date DATE NOT NULL,
    pregnancy_week INTEGER NOT NULL,
    
    -- Vital Signs
    weight_kg DECIMAL(5,2),
    blood_pressure_systolic INTEGER,
    blood_pressure_diastolic INTEGER,
    heart_rate INTEGER,
    temperature_celsius DECIMAL(4,2),
    
    -- Symptoms & Feelings
    symptoms TEXT[], -- Array: 'nausea', 'fatigue', 'headache', etc.
    mood VARCHAR(50), -- 'happy', 'anxious', 'tired', 'excited', etc.
    energy_level INTEGER, -- 1-10 scale
    pain_level INTEGER, -- 1-10 scale
    pain_location TEXT,
    
    -- Baby Movements
    felt_baby_movement BOOLEAN,
    movement_frequency VARCHAR(50), -- 'none', 'rare', 'moderate', 'frequent'
    movement_strength VARCHAR(50), -- 'weak', 'moderate', 'strong'
    
    -- Daily Activities
    hours_slept DECIMAL(4,2),
    exercise_minutes INTEGER,
    water_intake_liters DECIMAL(4,2),
    
    -- Notes
    notes TEXT,
    concerns TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 5. APPOINTMENTS & CHECKUPS
-- =============================================
CREATE TABLE IF NOT EXISTS public.pregnancy_appointments (
    appointment_id SERIAL PRIMARY KEY,
    maternal_id INTEGER NOT NULL REFERENCES public.maternal_health_data(maternal_id) ON DELETE CASCADE,
    
    appointment_type VARCHAR(50) NOT NULL, -- 'antenatal', 'ultrasound', 'lab_test', 'specialist', 'delivery'
    appointment_date DATE NOT NULL,
    appointment_time TIME,
    
    hospital_name VARCHAR(200),
    doctor_name VARCHAR(200),
    location TEXT,
    
    status VARCHAR(20) DEFAULT 'scheduled', -- 'scheduled', 'completed', 'cancelled', 'missed'
    
    -- Results (if completed)
    weight_kg DECIMAL(5,2),
    blood_pressure VARCHAR(20),
    fundal_height_cm DECIMAL(4,1),
    fetal_heart_rate INTEGER,
    baby_position VARCHAR(50),
    
    tests_performed TEXT[],
    test_results TEXT,
    medications_prescribed TEXT[],
    
    notes TEXT,
    next_appointment_date DATE,
    
    reminder_sent BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 6. PREGNANCY MILESTONES
-- =============================================
CREATE TABLE IF NOT EXISTS public.pregnancy_milestones (
    milestone_id SERIAL PRIMARY KEY,
    maternal_id INTEGER NOT NULL REFERENCES public.maternal_health_data(maternal_id) ON DELETE CASCADE,
    
    milestone_type VARCHAR(50) NOT NULL, -- 'trimester_change', 'first_movement', 'first_ultrasound', 'baby_shower', etc.
    milestone_title VARCHAR(200) NOT NULL,
    milestone_date DATE NOT NULL,
    pregnancy_week INTEGER,
    
    description TEXT,
    image_url TEXT,
    celebration_message TEXT,
    
    is_achieved BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 7. EDUCATIONAL CONTENT DELIVERY
-- =============================================
CREATE TABLE IF NOT EXISTS public.pregnancy_education (
    education_id SERIAL PRIMARY KEY,
    
    week_number INTEGER NOT NULL, -- 1-40
    trimester INTEGER NOT NULL, -- 1, 2, or 3
    
    title_kinyarwanda VARCHAR(300) NOT NULL,
    title_english VARCHAR(300),
    
    content_kinyarwanda TEXT NOT NULL,
    content_english TEXT,
    
    category VARCHAR(50), -- 'baby_development', 'mother_health', 'nutrition', 'exercise', 'preparation'
    
    tips_kinyarwanda TEXT[],
    tips_english TEXT[],
    
    warnings TEXT[],
    
    icon VARCHAR(50),
    image_url TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 8. NUTRITION & DIET TRACKING
-- =============================================
CREATE TABLE IF NOT EXISTS public.pregnancy_nutrition (
    nutrition_id SERIAL PRIMARY KEY,
    maternal_id INTEGER NOT NULL REFERENCES public.maternal_health_data(maternal_id) ON DELETE CASCADE,
    tracking_date DATE NOT NULL,
    
    meals_eaten INTEGER, -- Number of meals
    fruits_servings INTEGER,
    vegetables_servings INTEGER,
    protein_servings INTEGER,
    dairy_servings INTEGER,
    grains_servings INTEGER,
    
    prenatal_vitamin_taken BOOLEAN DEFAULT FALSE,
    iron_supplement_taken BOOLEAN DEFAULT FALSE,
    folic_acid_taken BOOLEAN DEFAULT FALSE,
    
    food_cravings TEXT[],
    food_aversions TEXT[],
    
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 9. REMINDERS & NOTIFICATIONS
-- =============================================
CREATE TABLE IF NOT EXISTS public.program_reminders (
    reminder_id SERIAL PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES public.program_enrollments(enrollment_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE,
    
    reminder_type VARCHAR(50) NOT NULL, -- 'appointment', 'medication', 'checkup', 'milestone', 'education'
    reminder_title VARCHAR(200) NOT NULL,
    reminder_message TEXT NOT NULL,
    
    scheduled_date DATE NOT NULL,
    scheduled_time TIME,
    
    is_sent BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP,
    
    is_recurring BOOLEAN DEFAULT FALSE,
    recurrence_pattern VARCHAR(50), -- 'daily', 'weekly', 'monthly'
    
    priority VARCHAR(20) DEFAULT 'normal', -- 'low', 'normal', 'high', 'urgent'
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================
CREATE INDEX IF NOT EXISTS idx_enrollments_user ON public.program_enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_program ON public.program_enrollments(program_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_status ON public.program_enrollments(status);

CREATE INDEX IF NOT EXISTS idx_maternal_enrollment ON public.maternal_health_data(enrollment_id);
CREATE INDEX IF NOT EXISTS idx_maternal_user ON public.maternal_health_data(user_id);
CREATE INDEX IF NOT EXISTS idx_maternal_due_date ON public.maternal_health_data(estimated_due_date);

CREATE INDEX IF NOT EXISTS idx_tracking_maternal ON public.pregnancy_tracking(maternal_id);
CREATE INDEX IF NOT EXISTS idx_tracking_date ON public.pregnancy_tracking(tracking_date);

CREATE INDEX IF NOT EXISTS idx_appointments_maternal ON public.pregnancy_appointments(maternal_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON public.pregnancy_appointments(appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON public.pregnancy_appointments(status);

CREATE INDEX IF NOT EXISTS idx_reminders_user ON public.program_reminders(user_id);
CREATE INDEX IF NOT EXISTS idx_reminders_date ON public.program_reminders(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_reminders_sent ON public.program_reminders(is_sent);

-- =============================================
-- FUNCTIONS FOR AUTOMATIC UPDATES
-- =============================================

-- Function to update pregnancy week and trimester
CREATE OR REPLACE FUNCTION update_pregnancy_progress()
RETURNS TRIGGER AS $$
BEGIN
    -- Calculate current week based on LMP
    NEW.current_week := FLOOR(EXTRACT(EPOCH FROM (CURRENT_DATE - NEW.last_menstrual_period)) / (7 * 24 * 60 * 60));
    
    -- Determine trimester (1-13 weeks = 1st, 14-26 = 2nd, 27+ = 3rd)
    IF NEW.current_week <= 13 THEN
        NEW.current_trimester := 1;
    ELSIF NEW.current_week <= 26 THEN
        NEW.current_trimester := 2;
    ELSE
        NEW.current_trimester := 3;
    END IF;
    
    -- Calculate age if date of birth provided
    IF NEW.date_of_birth IS NOT NULL THEN
        NEW.age := EXTRACT(YEAR FROM AGE(NEW.date_of_birth));
    END IF;
    
    -- Calculate BMI if height and weight provided
    IF NEW.height_cm IS NOT NULL AND NEW.current_weight_kg IS NOT NULL THEN
        NEW.bmi := NEW.current_weight_kg / ((NEW.height_cm / 100) * (NEW.height_cm / 100));
    END IF;
    
    NEW.updated_at := CURRENT_TIMESTAMP;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for maternal health data updates
DROP TRIGGER IF EXISTS trigger_update_pregnancy_progress ON public.maternal_health_data;
CREATE TRIGGER trigger_update_pregnancy_progress
    BEFORE INSERT OR UPDATE ON public.maternal_health_data
    FOR EACH ROW
    EXECUTE FUNCTION update_pregnancy_progress();

-- Function to update enrollment completion percentage
CREATE OR REPLACE FUNCTION update_enrollment_progress()
RETURNS TRIGGER AS $$
DECLARE
    total_days INTEGER;
    days_completed INTEGER;
BEGIN
    -- Get program duration
    SELECT duration_days INTO total_days
    FROM public.health_programs hp
    JOIN public.program_enrollments pe ON hp.program_id = pe.program_id
    WHERE pe.enrollment_id = NEW.enrollment_id;
    
    IF total_days IS NOT NULL THEN
        -- Calculate days since start
        days_completed := EXTRACT(EPOCH FROM (CURRENT_DATE - NEW.start_date)) / (24 * 60 * 60);
        
        -- Update completion percentage
        UPDATE public.program_enrollments
        SET completion_percentage = LEAST(100, (days_completed::DECIMAL / total_days) * 100)
        WHERE enrollment_id = NEW.enrollment_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for enrollment progress updates
DROP TRIGGER IF EXISTS trigger_update_enrollment_progress ON public.program_enrollments;
CREATE TRIGGER trigger_update_enrollment_progress
    AFTER INSERT OR UPDATE ON public.program_enrollments
    FOR EACH ROW
    EXECUTE FUNCTION update_enrollment_progress();

