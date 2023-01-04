CREATE DATABASE retirement_home;

CREATE TABLE residents(
    resident_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    resident_name VARCHAR (300) NOT NULL,
    date_of_birth INT,
    incontenent BOOLEAN, --is the resident incontenent
    organ_donor BOOLEAN, --is the resident an organ donor
    gender VARCHAR (10)
);

-- Room Information

CREATE TABLE rooms(
    room_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    room_num INT UNIQUE NOT NULL,
    capacity INT, --how many indivduals can stay in the room
    floor_num INT, --what floor the room is on
);

CREATE TABLE room_history( --a record of what rooms a resident has stayed in
    room_history_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    room_id INT REFERENCES rooms(room_id),
    resident_id INT REFERENCES residents(resident_id),
    move_in_date DATE,
    current_room BOOLEAN -- does the resident currently reside in this room
);

CREATE TABLE move_out(
    move_out_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    move_out_date DATE NOT NULL,
    reason VARCHAR (1000),
    room_history_id INT NOT NULL REFERENCES room_history(room_history_id)
);

-- Medical Information

CREATE TABLE doctors(
    doctor_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    doctor_name VARCHAR(300) NOT NULL,
    contact_sheet_id INT NOT NULL REFERENCES contacts(contact_sheet_id)
);

CREATE TABLE assessments(
    assessment_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    resident_id INT NOT NULL REFERENCES residents(resident_id),
    doctor_id INT NOT NULL REFERENCES doctors(doctor_id),
    assessment_date DATE NOT NULL,
    treatment_id INT REFERENCES tratment_plans(treatment_id)
);

CREATE TABLE tratment_plans(
    treatment_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    treatment_description VARCHAR(1000) NOT NULL
);

CREATE TABLE perscriptions(
    perscription_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    med_id INT NOT NULL REFERENCES meds(med_id),
    dose VARCHAR(100) NOT NULL, -- how much to administer
    frequency VARCHAR(100) NOT NULL, -- how often to administer
    refill_date DATE, -- when the next refill is scheduled
    date_discontinued DATE, -- an optional collumn for prescriptions that are no longer active
    treatment_id INT REFERENCES treatment_plans(treatment_id)
);

CREATE TABLE falls_assessment( -- a specific assessment type that tracks injuries from falls
    fall_assessment_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    head_injury BOOLEAN NOT NULL,
    severity INT NOT NULL, -- from 1 to 3 with 3 being most severe
    assessment_id INT NOT NULL REFERENCES assessments(assessment_id)
);

CREATE TABLE diagnoses(
    diagnosis_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    assessment_description VARCHAR(1000),
    assessment_id INT NOT NULL REFERENCES assessments(assessment_id),
    allergy_id INT REFERENCES allergies(allergy_id),
    dementia_id INT REFERENCES dementia(dementia_id),
    injury_id INT REFERENCES injuries(injury_id),
    adverse_reaction_id INT REFERENCES adverse_reactions(adverse_reaction_id),
    condition_id INT REFERENCES conditions(condition_id),
    resolved_date DATE -- an optional collumn that allows for a diagnosis to be discontinued such as in temporary illnesses
);

CREATE TABLE allergies(
    allergy_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    allergy_type VARCHAR(100) NOT NULL,
    severity INT NOT NULL, -- from 1 to 10 with 10 being most severe
    condition_description VARCHAR(1000) NOT NULL 
);

CREATE TABLE adverse_reactions(
    adverse_reaction_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    side_effect VARCHAR(1000) NOT NULL,
    perscription_id INT REFERENCES perscriptions(perscription_id)
);

CREATE TABLE injuries(
    injury_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    injury_type VARCHAR(300) NOT NULL, 
    severity INT NOT NULL -- from 1 to 10 with 10 being most severe
);

CREATE TABLE dementia(
    dementia_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    severity INT NOT NULL -- from 1 to 5 with 5 being most severe
);

CREATE TABLE conditions( -- a record of conditions that have not already been covered in other tables
    condition_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    condition_name VARCHAR(100) NOT NULL,
    condition_description VARCHAR(1000) NOT NULL
);

-- Medication Information

CREATE TABLE meds(
    med_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    supply_in_mg INT NOT NULL -- measured in milligrams
);

CREATE TABLE shipments(
    shipment_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    med_id INT NOT NULL REFERENCES meds(med_id),
    date_ordered DATE NOT NULL,
    date_arrived DATE,
    size_in_mg INT NOT NULL, -- measured in milligrams
    supplier_id INT REFERENCES suppliers(supplier_id)
);

CREATE TABLE suppliers(
    supplier_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    supplier_name VARCHAR(200) UNIQUE NOT NULL,
    contact_sheet_id INT REFERENCES contacts(contact_sheet_id)
)

-- Next of Kin Information

CREATE TABLE next_of_kin(
    kin_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    kin_name VARCHAR(300) NOT NULL,
    contact_sheet_id INT REFERENCES contacts(contact_sheet_id)
);

CREATE TABLE relationships( -- A unique sheet for the relationship between a resident and their kin. This allows for families to have many next of kin and many residents in care
    relationship_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    resident_id INT REFERENCES residents(resident_id),
    kin_id INT REFERENCES next_of_kin(kin_id),
    relationship_type VARCHAR(1000) NOT NULL, -- ex. daughter, husband, sister, etc.
    primary_contact BOOLEAN -- is the next of kin the primary contact (one per resident)
);

-- Fall information

CREATE TABLE fall_report(
    fall_report_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    fall_date DATE NOT NULL,
    assessment_id INT NOT NULL REFERENCES assessments(assessment_id), -- a fall must be connected to an assessment which is in turn connected to a fall assessment
    room_id INT NOT NULL REFERENCES rooms(room_id) -- where the fall occurred
);

-- Contact Information

CREATE TABLE contacts(
    contact_sheet_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
);

CREATE TABLE emails(
    email_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    email_address VARCHAR(200) NOT NULL,
    contact_sheet_id INT NOT NULL REFERENCES contacts(contact_sheet_id)
);

CREATE TABLE phones(
    phone_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    phone_number VARCHAR(200),
    contact_sheet_id INT NOT NULL REFERENCES contacts(contact_sheet_id)
);

CREATE TABLE faxes(
    fax_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    fax_number VARCHAR(200),
    contact_sheet_id INT NOT NULL REFERENCES contacts(contact_sheet_id)
);