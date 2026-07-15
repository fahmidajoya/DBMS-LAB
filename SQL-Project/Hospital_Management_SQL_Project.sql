-- ============================================================
-- HOSPITAL MANAGEMENT SYSTEM - MINI SQL PROJECT
-- ============================================================
-- Instructions: Open this file in MySQL Workbench and run the
-- entire script (Ctrl+Shift+Enter) to create the database,
-- tables, insert sample data, and run example queries.
-- ============================================================

DROP DATABASE IF EXISTS hospital_management;
CREATE DATABASE hospital_management;
USE hospital_management;

-- ============================================================
-- 1. TABLE CREATION
-- ============================================================

-- Department Table
CREATE TABLE department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL,
    floor_no INT
);

-- Doctor Table
CREATE TABLE doctor (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50),
    phone VARCHAR(15),
    dept_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- Patient Table
CREATE TABLE patient (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100) NOT NULL,
    age INT,
    gender ENUM('Male','Female','Other'),
    phone VARCHAR(15),
    address VARCHAR(150),
    blood_group VARCHAR(5)
);

-- Appointment Table
CREATE TABLE appointment (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    appointment_time TIME,
    status ENUM('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
);

-- Admission Table (for admitted patients)
CREATE TABLE admission (
    admission_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    room_no VARCHAR(10),
    admission_date DATE,
    discharge_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

-- Medicine Table
CREATE TABLE medicine (
    medicine_id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_name VARCHAR(100) NOT NULL,
    price DECIMAL(8,2),
    stock_quantity INT
);

-- Prescription Table
CREATE TABLE prescription (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT,
    medicine_id INT,
    dosage VARCHAR(50),
    duration_days INT,
    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
    FOREIGN KEY (medicine_id) REFERENCES medicine(medicine_id)
);

-- Billing Table
CREATE TABLE billing (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    amount DECIMAL(10,2),
    bill_date DATE,
    payment_status ENUM('Paid','Unpaid') DEFAULT 'Unpaid',
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

-- ============================================================
-- 2. SAMPLE DATA INSERTION
-- ============================================================

INSERT INTO department (dept_name, floor_no) VALUES
('Cardiology', 2),
('Neurology', 3),
('Orthopedics', 1),
('Pediatrics', 1),
('General Medicine', 2);

INSERT INTO doctor (doctor_name, specialization, phone, dept_id, salary) VALUES
('Dr. Kamal Hossain', 'Cardiologist', '01711111111', 1, 85000.00),
('Dr. Nusrat Jahan', 'Neurologist', '01722222222', 2, 90000.00),
('Dr. Rafiqul Islam', 'Orthopedic Surgeon', '01733333333', 3, 78000.00),
('Dr. Shirin Akter', 'Pediatrician', '01744444444', 4, 70000.00),
('Dr. Mahmudul Hasan', 'General Physician', '01755555555', 5, 65000.00);

INSERT INTO patient (patient_name, age, gender, phone, address, blood_group) VALUES
('Rahim Uddin', 45, 'Male', '01811111111', 'Dhanmondi, Dhaka', 'O+'),
('Fatema Begum', 32, 'Female', '01822222222', 'Mirpur, Dhaka', 'A+'),
('Karim Sheikh', 60, 'Male', '01833333333', 'Uttara, Dhaka', 'B+'),
('Ayesha Siddiqua', 8, 'Female', '01844444444', 'Natore Sadar, Natore', 'AB+'),
('Jamal Hossain', 28, 'Male', '01855555555', 'Rajshahi City', 'O-');

INSERT INTO appointment (patient_id, doctor_id, appointment_date, appointment_time, status) VALUES
(1, 1, '2026-07-01', '10:00:00', 'Completed'),
(2, 2, '2026-07-02', '11:30:00', 'Completed'),
(3, 3, '2026-07-03', '09:00:00', 'Scheduled'),
(4, 4, '2026-07-03', '14:00:00', 'Scheduled'),
(5, 5, '2026-07-04', '16:00:00', 'Cancelled');

INSERT INTO admission (patient_id, room_no, admission_date, discharge_date) VALUES
(1, '201A', '2026-07-01', '2026-07-05'),
(3, '105B', '2026-07-03', NULL);

INSERT INTO medicine (medicine_name, price, stock_quantity) VALUES
('Paracetamol', 2.50, 500),
('Amoxicillin', 5.00, 300),
('Metformin', 3.75, 250),
('Aspirin', 1.50, 400),
('Cetirizine', 2.00, 350);

INSERT INTO prescription (appointment_id, medicine_id, dosage, duration_days) VALUES
(1, 1, '1 tablet twice daily', 5),
(1, 4, '1 tablet daily', 7),
(2, 3, '1 tablet after meal', 30);

INSERT INTO billing (patient_id, amount, bill_date, payment_status) VALUES
(1, 5000.00, '2026-07-05', 'Paid'),
(2, 1500.00, '2026-07-02', 'Unpaid'),
(3, 3200.00, '2026-07-03', 'Unpaid');

-- ============================================================
-- 3. SAMPLE QUERIES (run individually to see output)
-- ============================================================

-- View all patients with their appointment details
SELECT p.patient_name, d.doctor_name, a.appointment_date, a.status
FROM patient p
JOIN appointment a ON p.patient_id = a.patient_id
JOIN doctor d ON a.doctor_id = d.doctor_id;

-- Find all doctors in the Cardiology department
SELECT doctor_name, specialization, phone
FROM doctor
WHERE dept_id = (SELECT dept_id FROM department WHERE dept_name = 'Cardiology');

-- List currently admitted patients (not yet discharged)
SELECT p.patient_name, ad.room_no, ad.admission_date
FROM admission ad
JOIN patient p ON ad.patient_id = p.patient_id
WHERE ad.discharge_date IS NULL;

-- Total unpaid billing amount
SELECT SUM(amount) AS total_unpaid
FROM billing
WHERE payment_status = 'Unpaid';

-- Number of appointments handled per doctor
SELECT d.doctor_name, COUNT(a.appointment_id) AS total_appointments
FROM doctor d
LEFT JOIN appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name
ORDER BY total_appointments DESC;

-- Prescriptions given during a specific appointment
SELECT pr.appointment_id, m.medicine_name, pr.dosage, pr.duration_days
FROM prescription pr
JOIN medicine m ON pr.medicine_id = m.medicine_id
WHERE pr.appointment_id = 1;

-- ============================================================
-- 4. A VIEW: Quick summary of patient bills
-- ============================================================
CREATE VIEW patient_bill_summary AS
SELECT p.patient_name, b.amount, b.payment_status, b.bill_date
FROM patient p
JOIN billing b ON p.patient_id = b.patient_id;

SELECT * FROM patient_bill_summary;

-- ============================================================
-- 5. A STORED PROCEDURE: Mark a bill as Paid
-- ============================================================
DELIMITER //
CREATE PROCEDURE mark_bill_paid(IN p_bill_id INT)
BEGIN
    UPDATE billing
    SET payment_status = 'Paid'
    WHERE bill_id = p_bill_id;
END //
DELIMITER ;

-- Example usage:
CALL mark_bill_paid(2);
SELECT * FROM billing;

-- ============================================================
-- END OF SCRIPT
-- ============================================================
