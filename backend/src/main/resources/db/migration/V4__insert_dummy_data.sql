-- Insert dummy data for user@example.com
-- Password: password123 (BCrypt hash)

-- Insert user
INSERT INTO users (email, password, first_name, last_name, phone_number, enabled, mfa_enabled, created_at, updated_at)
VALUES (
    'user@example.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', -- BCrypt hash for 'password123'
    'John',
    'Doe',
    '+1234567890',
    true,
    false,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (email) DO NOTHING;

-- Get user ID (using a variable approach for PostgreSQL)
DO $$
DECLARE
    v_user_id BIGINT;
    v_family_member_1_id BIGINT;
    v_family_member_2_id BIGINT;
    v_medication_1_id BIGINT;
    v_medication_2_id BIGINT;
    v_medication_3_id BIGINT;
BEGIN
    -- Get user ID
    SELECT id INTO v_user_id FROM users WHERE email = 'user@example.com';
    
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'User not found';
    END IF;
    
    -- Insert user role
    INSERT INTO user_roles (user_id, role)
    VALUES (v_user_id, 'USER')
    ON CONFLICT (user_id, role) DO NOTHING;
    
    -- Insert family members (only if they don't already exist)
    INSERT INTO family_members (user_id, first_name, last_name, date_of_birth, relationship, phone_number, email, created_at, updated_at)
    SELECT v_user_id, 'Jane', 'Doe', '1985-05-15', 'Spouse', '+1234567891', 'jane.doe@example.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    WHERE NOT EXISTS (
        SELECT 1 FROM family_members WHERE user_id = v_user_id AND first_name = 'Jane' AND last_name = 'Doe'
    );
    
    INSERT INTO family_members (user_id, first_name, last_name, date_of_birth, relationship, phone_number, email, created_at, updated_at)
    SELECT v_user_id, 'Alice', 'Doe', '2010-08-20', 'Daughter', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    WHERE NOT EXISTS (
        SELECT 1 FROM family_members WHERE user_id = v_user_id AND first_name = 'Alice' AND last_name = 'Doe'
    );
    
    -- Get family member IDs
    SELECT id INTO v_family_member_1_id FROM family_members WHERE user_id = v_user_id AND first_name = 'Jane' LIMIT 1;
    SELECT id INTO v_family_member_2_id FROM family_members WHERE user_id = v_user_id AND first_name = 'Alice' LIMIT 1;
    
    -- Insert health records for family member 1 (Jane)
    INSERT INTO health_records (family_member_id, record_type, title, description, value, unit, recorded_date, doctor_name, notes, created_at, updated_at)
    VALUES 
        (v_family_member_1_id, 'CONDITION', 'Hypertension', 'High blood pressure condition diagnosed in 2020', NULL, NULL, '2020-03-15', 'Dr. Smith', 'Monitor blood pressure regularly', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (v_family_member_1_id, 'VITAL', 'Blood Pressure', 'Regular blood pressure check', '120/80', 'mmHg', '2024-01-15', 'Dr. Smith', 'Within normal range', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (v_family_member_1_id, 'VITAL', 'Weight', 'Monthly weight check', '65', 'kg', '2024-01-10', 'Dr. Smith', 'Stable weight', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (v_family_member_1_id, 'ALLERGY', 'Penicillin Allergy', 'Allergic reaction to penicillin', NULL, NULL, '2015-06-20', 'Dr. Johnson', 'Avoid all penicillin-based medications', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    
    -- Insert health records for family member 2 (Alice)
    INSERT INTO health_records (family_member_id, record_type, title, description, value, unit, recorded_date, doctor_name, notes, created_at, updated_at)
    VALUES 
        (v_family_member_2_id, 'CONDITION', 'Asthma', 'Childhood asthma diagnosed at age 5', NULL, NULL, '2015-09-10', 'Dr. Williams', 'Use inhaler as needed', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (v_family_member_2_id, 'VITAL', 'Height', 'Annual height measurement', '145', 'cm', '2024-01-05', 'Dr. Williams', 'Growing normally', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (v_family_member_2_id, 'ALLERGY', 'Peanut Allergy', 'Severe allergic reaction to peanuts', NULL, NULL, '2012-04-12', 'Dr. Williams', 'Carry epinephrine pen at all times', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    
    -- Insert medications for family member 1 (Jane)
    INSERT INTO medications (family_member_id, name, dosage, frequency, start_date, end_date, instructions, prescribed_by, created_at, updated_at)
    VALUES 
        (v_family_member_1_id, 'Lisinopril', '10mg', 'DAILY', '2020-03-20', NULL, 'Take with food in the morning', 'Dr. Smith', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (v_family_member_1_id, 'Aspirin', '81mg', 'DAILY', '2021-01-01', NULL, 'Low dose aspirin for heart health', 'Dr. Smith', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    
    -- Get medication IDs for family member 1
    SELECT id INTO v_medication_1_id FROM medications WHERE family_member_id = v_family_member_1_id AND name = 'Lisinopril' LIMIT 1;
    SELECT id INTO v_medication_2_id FROM medications WHERE family_member_id = v_family_member_1_id AND name = 'Aspirin' LIMIT 1;
    
    -- Insert medications for family member 2 (Alice)
    INSERT INTO medications (family_member_id, name, dosage, frequency, start_date, end_date, instructions, prescribed_by, created_at, updated_at)
    VALUES 
        (v_family_member_2_id, 'Albuterol Inhaler', '90mcg', 'AS_NEEDED', '2015-09-15', NULL, 'Use 2 puffs when experiencing shortness of breath', 'Dr. Williams', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    
    -- Get medication 3 ID
    SELECT id INTO v_medication_3_id FROM medications WHERE family_member_id = v_family_member_2_id AND name = 'Albuterol Inhaler' LIMIT 1;
    
    -- Insert medication reminders for Lisinopril (daily at 8:00 AM, all days)
    INSERT INTO medication_reminders (medication_id, reminder_time, days_of_week, reminder_type, status, next_reminder_at, created_at, updated_at)
    VALUES 
        (v_medication_1_id, '08:00:00', ARRAY[0,1,2,3,4,5,6], 'BOTH', 'PENDING', 
         (CURRENT_DATE + INTERVAL '1 day')::date + TIME '08:00:00', 
         CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    
    -- Insert medication reminders for Aspirin (daily at 9:00 AM, all days)
    INSERT INTO medication_reminders (medication_id, reminder_time, days_of_week, reminder_type, status, next_reminder_at, created_at, updated_at)
    VALUES 
        (v_medication_2_id, '09:00:00', ARRAY[0,1,2,3,4,5,6], 'EMAIL', 'PENDING', 
         (CURRENT_DATE + INTERVAL '1 day')::date + TIME '09:00:00', 
         CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    
    -- Insert medication reminders for Albuterol (as needed - no specific schedule, but set for weekdays)
    INSERT INTO medication_reminders (medication_id, reminder_time, days_of_week, reminder_type, status, next_reminder_at, created_at, updated_at)
    VALUES 
        (v_medication_3_id, '12:00:00', ARRAY[1,2,3,4,5], 'SMS', 'PENDING', 
         (CURRENT_DATE + INTERVAL '1 day')::date + TIME '12:00:00', 
         CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    
END $$;
