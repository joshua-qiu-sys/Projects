-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

CREATE TABLE Department
(Department_ID NUMBER(6,0),
Department_Name VARCHAR2(50),
Location VARCHAR2(4),
CONSTRAINT Department_Department_ID_pk PRIMARY KEY(Department_ID));

CREATE TABLE Department_Facilities
(Room# NUMBER(4,0),
Department_ID NUMBER(6,0),
Facility_Type VARCHAR2(25),
Floor# NUMBER(1,0),
Room_Status VARCHAR2(25),
CONSTRAINT Department_Facilities_Room#_pk PRIMARY KEY(Room#),
CONSTRAINT DEPARTMENT_FACILITIES_FLOOR#_CK CHECK (floor# IN ('1','2','3')),
CONSTRAINT DEPARTMENT_FACILITIES_DEPARTMENT_ID_FK FOREIGN KEY (DEPARTMENT_ID)
REFERENCES DEPARTMENT (DEPARTMENT_ID));

CREATE TABLE Ward
(Room# NUMBER(4,0),
No_Of_Beds NUMBER(1,0),
Charges_Per_Day NUMBER(4,0),
CONSTRAINT ward_room_pk PRIMARY KEY(Room#));

CREATE TABLE Patient_Details
(Patient_ID VARCHAR2(10),
First_Name VARCHAR2(50),
Last_Name VARCHAR2(50),
Age NUMBER(3,0),
Gender VARCHAR2(3),
Medicare# NUMBER(10,0),
Address VARCHAR2(50),
Suburb VARCHAR2(30),
State VARCHAR2(5),
Postcode NUMBER(4,0),
Phone# VARCHAR2(12),
Patient_Type VARCHAR2(15),
CONSTRAINT patient_details_patient_ID_pk PRIMARY KEY(Patient_ID));

CREATE TABLE Patient_Payment
(Patient_ID VARCHAR2(10),
Payment NUMBER(8,2),
Payment_Type VARCHAR2(15),
Health_Insurance VARCHAR2(15),
Room_Charges NUMBER(6,0),
Operation_Charges NUMBER(8,0),
Test_Charges NUMBER(7,0),
Blood_Charges NUMBER(7,0),
Payment_Date DATE,
Excess_Fees NUMBER(3,0),
Outstanding_Balance_Charges AS (room_charges + operation_charges + test_charges + blood_charges + excess_fees - payment),
CONSTRAINT patient_payment_patient_ID_pk PRIMARY KEY(Patient_ID));

CREATE TABLE Patient_Condition
(Patient_ID VARCHAR2(10),
Initial_Condition VARCHAR2(50),
Current_Condition VARCHAR2(50),
CONSTRAINT patient_condition_patient_ID_pk PRIMARY KEY(Patient_ID));

CREATE TABLE Treatment_Appointments
(Appointment# NUMBER(6,0),
Appointment_Time VARCHAR2(7),
Appointment_Date DATE,
Appointment_Type VARCHAR2(13),
Emp_ID NUMBER(6,0),
Patient_ID VARCHAR2(10),
CONSTRAINT treatment_appointments_appointment#_pk PRIMARY KEY(Appointment#));

CREATE TABLE Treatment
(Patient_ID VARCHAR2(10),
Emp_ID NUMBER(6,0),
Room# NUMBER(4,0),
Appointment# NUMBER(6,0),
CONSTRAINT treatment_pk PRIMARY KEY(Patient_ID,Emp_ID,Room#),
CONSTRAINT treatment_appointment#_fk FOREIGN KEY(appointment#)
REFERENCES treatment_appointments (appointment#),
CONSTRAINT treatment_room#_fk FOREIGN KEY(room#)
REFERENCES department_facilities (room#));

CREATE TABLE Patient_Treatment
(Patient_ID VARCHAR2(10),
Emp_ID NUMBER(6,0),
Diagnosis VARCHAR2(50),
Treatment_Type VARCHAR2(13),
Treatment_Status VARCHAR2(25),
Treatment_Advice VARCHAR2(50),
Follow_Up_Appointment VARCHAR2(3),
Follow_Up_Appointment# NUMBER(6),
CONSTRAINT patient_treatment_pk PRIMARY KEY(Patient_ID,Emp_ID),
CONSTRAINT patient_treatment_follow_up_appointment#_fk FOREIGN KEY(follow_up_appointment#)
REFERENCES treatment_appointments (appointment#));

CREATE TABLE Regular_Treatment
(Patient_ID VARCHAR2(10),
Emp_ID NUMBER(6,0),
Time_Of_Visit VARCHAR2(7),
Date_Of_Visit DATE,
Medicine_Prescribed VARCHAR2(50),
Operation_Referral VARCHAR2(3),
CONSTRAINT regular_treatment_pk PRIMARY KEY(Patient_ID,Emp_ID));

CREATE TABLE Operational_Treatment
(Patient_ID VARCHAR2(10),
Emp_ID NUMBER(6,0),
Operation_Type VARCHAR2(50),
Admission_Time VARCHAR2(7),
Admission_Date DATE,
Operation_Time VARCHAR2(7),
Operation_Date DATE,
Discharge_Time VARCHAR2(7),
Discharge_Date DATE,
Ward# NUMBER(4,0),
CONSTRAINT operational_treatment_pk PRIMARY KEY(Patient_ID,Emp_ID),
CONSTRAINT operational_treatment_ward#_fk FOREIGN KEY(ward#)
REFERENCES ward (room#));

CREATE TABLE Staff_Details
(Emp_ID NUMBER(6,0),
Department_ID NUMBER(6,0),
First_Name VARCHAR2(50),
Last_Name VARCHAR2(50),
Age NUMBER(3,0),
Gender VARCHAR2(3),
Address VARCHAR2(50),
Suburb VARCHAR2(30),
State VARCHAR2(5),
Postcode NUMBER(4,0),
Phone# VARCHAR2(12),
Emp_Type VARCHAR2(25),
Job_Title VARCHAR2(25),
CONSTRAINT staff_details_emp_ID_pk PRIMARY KEY(Emp_ID),
CONSTRAINT staff_details_department_id_fk FOREIGN KEY(department_id)
REFERENCES department (department_id));

CREATE TABLE Staff_Qualifications
(Certificate# NUMBER(10),
Certificate_Level NUMBER(1,0),
Emp_ID NUMBER(6,0),
Qualification VARCHAR2(50),
CONSTRAINT staff_qualifications_certificate#_pk PRIMARY KEY(certificate#),
CONSTRAINT staff_qualifications_emp_id_fk FOREIGN KEY(emp_id)
REFERENCES staff_details (emp_id));

CREATE TABLE Staff_Shifts
(Shift# NUMBER(6,0),
Emp_ID NUMBER(6,0),
Shift_Start_Time VARCHAR2(7),
Shift_End_Time VARCHAR2(7),
Shift_Date DATE,
Hours_Worked NUMBER(1,0),
CONSTRAINT staff_shifts_shift#_pk PRIMARY KEY(Shift#),
CONSTRAINT staff_shifts_emp_id_fk FOREIGN KEY(emp_id)
REFERENCES staff_details (emp_id));

CREATE TABLE Regular_Doctors
(Emp_ID NUMBER(6,0),
Salary NUMBER(10,2),
Hire_Date DATE,
CONSTRAINT regular_doctors_emp_id_pk PRIMARY KEY(Emp_ID));

CREATE TABLE On_Call_Doctors
(Emp_ID NUMBER(6,0),
Fees_Per_Call NUMBER(9,2),
Payment_Due_Date DATE,
CONSTRAINT on_call_doctors_emp_id_pk PRIMARY KEY(Emp_ID));

CREATE TABLE Full_Time_Nurses
(Emp_ID NUMBER(6,0),
Salary NUMBER(10,2),
Hire_Date DATE,
CONSTRAINT full_time_nurses_emp_id_pk PRIMARY KEY(Emp_ID));

CREATE TABLE Part_Time_Nurses
(Emp_ID NUMBER(6,0),
Hourly_Pay NUMBER(7,2),
Payment_Due_Date DATE,
CONSTRAINT part_time_nurses_emp_id_pk PRIMARY KEY(Emp_ID));

CREATE TABLE Other_Staff
(Emp_ID NUMBER(6,0),
Hourly_Pay NUMBER(7,2),
Payment_Due_Date DATE,
CONSTRAINT other_staff_emp_id_pk PRIMARY KEY(Emp_ID));

INSERT ALL
INTO department (department_id, department_name, location) VALUES(345671,'emergency','A1')
INTO department (department_id, department_name, location) VALUES(	345672	,'	cardiology	','	B1	')
INTO department (department_id, department_name, location) VALUES(	345673	,'	cancer	','	C1	')
INTO department (department_id, department_name, location) VALUES(	345674	,'	neurology	','	D1	')
INTO department (department_id, department_name, location) VALUES(	345675	,'	nutrition	','	E1	')
INTO department (department_id, department_name, location) VALUES(	345676	,'	outpatient	','	F1	')
INTO department (department_id, department_name, location) VALUES(	345677	,'	dermatology	','	G1	')
INTO department (department_id, department_name, location) VALUES(	345678	,'	infection control	','	H1	')
INTO department (department_id, department_name, location) VALUES(	345679	,'	blood bank	','	I1	')
INTO department (department_id, department_name, location) VALUES(	345680	,'	laboratories	','	J1	')
SELECT * FROM DUAL;

INSERT ALL
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1101	,'	operation theatre	',	345671	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1102	,'	operation theatre	',	345671	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1103	,'	operation theatre	',	345671	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1104	,'	operation theatre	',	345671	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1105	,'	operation theatre	',	345671	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2101	,'	ward	',	345671	,	1	,'	occupied	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2102	,'	ward	',	345671	,	1	,'	occupied	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2103	,'	ward	',	345671	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2104	,'	ward	',	345671	,	2	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2105	,'	ward	',	345671	,	3	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1201	,'	operation theatre	',	345672	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1202	,'	operation theatre	',	345672	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1203	,'	operation theatre	',	345672	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1204	,'	operation theatre	',	345672	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1205	,'	operation theatre	',	345672	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2201	,'	ward	',	345672	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2202	,'	ward	',	345672	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2203	,'	ward	',	345672	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2204	,'	ward	',	345672	,	2	,'	2 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2205	,'	ward	',	345672	,	3	,'	occupied	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1301	,'	operation theatre	',	345673	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1302	,'	operation theatre	',	345673	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1303	,'	operation theatre	',	345673	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1304	,'	operation theatre	',	345673	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1305	,'	operation theatre	',	345673	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2301	,'	ward	',	345673	,	1	,'	occupied	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2302	,'	ward	',	345673	,	1	,'	occupied	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2303	,'	ward	',	345673	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2304	,'	ward	',	345673	,	2	,'	2 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2305	,'	ward	',	345673	,	3	,'	3 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1401	,'	operation theatre	',	345674	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1402	,'	operation theatre	',	345674	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1403	,'	operation theatre	',	345674	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1404	,'	operation theatre	',	345674	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1405	,'	operation theatre	',	345674	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2401	,'	ward	',	345674	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2402	,'	ward	',	345674	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2403	,'	ward	',	345674	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2404	,'	ward	',	345674	,	2	,'	2 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2405	,'	ward	',	345674	,	3	,'	3 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1501	,'	operation theatre	',	345675	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1502	,'	operation theatre	',	345675	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1503	,'	operation theatre	',	345675	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1504	,'	operation theatre	',	345675	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1505	,'	operation theatre	',	345675	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2501	,'	ward	',	345675	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2502	,'	ward	',	345675	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2503	,'	ward	',	345675	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2504	,'	ward	',	345675	,	2	,'	2 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2505	,'	ward	',	345675	,	3	,'	3 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1601	,'	check-up room	',	345676	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1602	,'	check-up room	',	345676	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1603	,'	check-up room	',	345676	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1604	,'	check-up room	',	345676	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1605	,'	check-up room	',	345676	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1701	,'	operation theatre	',	345677	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1702	,'	operation theatre	',	345677	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1703	,'	operation theatre	',	345677	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1704	,'	operation theatre	',	345677	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1705	,'	operation theatre	',	345677	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2701	,'	ward	',	345677	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2702	,'	ward	',	345677	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2703	,'	ward	',	345677	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2704	,'	ward	',	345677	,	2	,'	2 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2705	,'	ward	',	345677	,	3	,'	3 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1801	,'	operation theatre	',	345678	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1802	,'	operation theatre	',	345678	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1803	,'	operation theatre	',	345678	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1804	,'	operation theatre	',	345678	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1805	,'	operation theatre	',	345678	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2801	,'	ward	',	345678	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2802	,'	ward	',	345678	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2803	,'	ward	',	345678	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2804	,'	ward	',	345678	,	2	,'	2 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2805	,'	ward	',	345678	,	3	,'	3 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1901	,'	operation theatre	',	345679	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1902	,'	operation theatre	',	345679	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1903	,'	operation theatre	',	345679	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1904	,'	operation theatre	',	345679	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1905	,'	operation theatre	',	345679	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2901	,'	ward	',	345679	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2902	,'	ward	',	345679	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2903	,'	ward	',	345679	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2904	,'	ward	',	345679	,	2	,'	2 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2905	,'	ward	',	345679	,	3	,'	3 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1001	,'	operation theatre	',	345680	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1002	,'	operation theatre	',	345680	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1003	,'	operation theatre	',	345680	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1004	,'	operation theatre	',	345680	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	1005	,'	operation theatre	',	345680	,	1	,'	vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2001	,'	ward	',	345680	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2002	,'	ward	',	345680	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2003	,'	ward	',	345680	,	1	,'	1 bed vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2004	,'	ward	',	345680	,	2	,'	2 beds vacant	')
INTO department_facilities(room#, facility_type, department_id, floor#, room_status) VALUES(	2005	,'	ward	',	345680	,	3	,'	3 beds vacant	')
SELECT * FROM DUAL;

INSERT ALL
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2101	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2102	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2103	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2104	,	2	,	2500	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2105	,	3	,	2000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2201	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2202	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2203	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2204	,	2	,	2500	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2205	,	3	,	2000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2301	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2302	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2303	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2304	,	2	,	2500	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2305	,	3	,	2000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2401	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2402	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2403	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2404	,	2	,	2500	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2405	,	3	,	2000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2501	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2502	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2503	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2504	,	2	,	2500	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2505	,	3	,	2000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2701	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2702	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2703	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2704	,	2	,	2500	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2705	,	3	,	2000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2801	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2802	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2803	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2804	,	2	,	2500	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2805	,	3	,	2000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2901	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2902	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2903	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2904	,	2	,	2500	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2905	,	3	,	2000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2001	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2002	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2003	,	1	,	5000	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2004	,	2	,	2500	)
INTO ward(room#, no_of_beds,charges_per_day) VALUES(	2005	,	3	,	2000	)
SELECT * FROM DUAL;

INSERT ALL
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123456	','	Jorge	','	Smeeth	','	1 Breeje Road	','	Liverpool	','	NSW	',	2170	,	65	,'	M	','	0412345678'	,'	inpatient	',	2000000000	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123457	','	Gymmy	','	Djones	','	2 Cuupar Street	','	Punchbowl	','	NSW	',	2196	,	76	,'	M	','	0423456789'	,'	inpatient	',	2000000001	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123458	','	Ryleigh	','	Tesererious	','	3 Chur-chee Avenue	','	Bankstown	','	NSW	',	2200	,	89	,'	M	','	0434567890'	,'	inpatient	',	2000000002	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123459	','	Aubri	','	Hayman	','	4 Pit Crescent	','	Bankstown	','	NSW	',	2200	,	64	,'	F	','	0445678901'	,'	inpatient	',	2000000003	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123460	','	Tiphaniee	','	Schweig	','	5 Purseival Highway	','	Bankstown	','	NSW	',	2200	,	57	,'	F	','	0456789012'	,'	inpatient	',	2000000004	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123461	','	Emmalee	','	Belarki	','	6 Hayzul Street	','	Bankstown	','	NSW	',	2200	,	13	,'	F	','	0412345679'	,'	inpatient	',	2000000005	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123462	','	Johnafern	','	Schott	','	7 Towahr Way	','	Bankstown	','	NSW	',	2200	,	72	,'	M	','	0412345680'	,'	inpatient	',	2000000006	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123463	','	Kristoffer	','	Brentarri	','	8 Heathve Street	','	Bankstown	','	NSW	',	2200	,	31	,'	M	','	0412345681'	,'	inpatient	',	2000000007	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123464	','	Rebekkah	','	Higer	','	9 Bruksighde Avenue	','	Bankstown	','	NSW	',	2200	,	56	,'	F	','	0412345682'	,'	inpatient	',	2000000008	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123465	','	Jazzmyn	','	Guberman	','	10 Devuhnshiyarr Street	','	Bankstown	','	NSW	',	2200	,	68	,'	F	','	0412345683'	,'	inpatient	',	2000000009	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123466	','	Mykel	','	Pak	','	11 Morysun Drive	','	Granville	','	NSW	',	2142	,	36	,'	M	','	0467890123'	,'	outpatient	',	2000000010	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123467	','	Pheona	','	Taylar	','	12 Mane Boulevard	','	Auburn	','	NSW	',	2144	,	21	,'	F	','	0478901234'	,'	outpatient	',	2000000011	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123468	','	Kai-tuu	','	Browyn	','	13 Straya Place	','	Auburn	','	NSW	',	2144	,	48	,'	F	','	0489012345'	,'	outpatient	',	2000000012	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123469	','	Kurssandra	','	Willsun	','	14 Cleavelearned Street	','	Auburn	','	NSW	',	2144	,	16	,'	F	','	0490123456'	,'	outpatient	',	2000000013	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123470	','	Sabastchin	','	Jaxsin	','	15 Charmurs Street	','	Merrylands	','	NSW	',	2200	,	15	,'	M	','	0401234567'	,'	outpatient	',	2000000014	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123471	','	Jerrymiah	','	Lokhus	','	16 Illizurburth Road	','	Merrylands	','	NSW	',	2200	,	57	,'	M	','	0412345684'	,'	outpatient	',	2000000015	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123472	','	Kaytlynn	','	Stoico	','	17 Heruhn Avenue	','	Merrylands	','	NSW	',	2200	,	21	,'	F	','	0412345685'	,'	outpatient	',	2000000016	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123476	','	Caytie	','	Meeler	','	21 Landslide Avenue	','	Bankstown	','	NSW	',	2200	,	45	,'	F	','	0412345689'	,'	inpatient	',	2000000020	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123477	','	Alyyzabeth	','	Dayverse	','	22 Disaster Street	','	Bankstown	','	NSW	',	2200	,	56	,'	F	','	0412345690'	,'	inpatient	',	2000000021	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123478	','	Danyal	','	Willsuhrn	','	23 Earthquake Avenue	','	Bankstown	','	NSW	',	2200	,	83	,'	M	','	0412345691'	,'	inpatient	',	2000000022	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123479	','	Jorja	','	Marrturn	','	24 Tsunami Boulevard	','	Bankstown	','	NSW	',	2200	,	72	,'	F	','	0412345692'	,'	inpatient	',	2000000023	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123480	','	Bekki	','	Wheeliams	','	25 Bushfire Corner	','	Bankstown	','	NSW	',	2200	,	35	,'	F	','	0412345693'	,'	inpatient	',	2000000024	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123481	','	Jenni	','	Harrace	','	26 Flood Parade	','	Bankstown	','	NSW	',	2200	,	36	,'	F	','	0412345694'	,'	inpatient	',	2000000025	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123482	','	Nikki	','	Roburnsurn	','	27 Tornado Street	','	Bankstown	','	NSW	',	2200	,	42	,'	F	','	0412345695'	,'	inpatient	',	2000000026	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123483	','	Jaymiee	','	Andarsurn	','	28 Hurricane Junction	','	Bankstown	','	NSW	',	2200	,	53	,'	M	','	0412345696'	,'	inpatient	',	2000000027	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123484	','	Verohnicca	','	Johrnson	','	29 Volcano Lane	','	Bankstown	','	NSW	',	2200	,	64	,'	F	','	0412345697'	,'	inpatient	',	2000000028	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123485	','	Myah	','	Roight	','	30 Cyclone Avenue	','	Bankstown	','	NSW	',	2200	,	12	,'	F	','	0412345698'	,'	inpatient	',	2000000029	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123473	','	Kamryn	','	Lincurn	','	18 Horkk Street	','	Merrylands	','	NSW	',	2200	,	29	,'	M	','	0412345686'	,'	outpatient	',	2000000017	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123474	','	Maddisyn	','	Godfreay	','	19 Lejournd Parade	','	Deception Bay	','	QLD	',	4508	,	67	,'	F	','	0412345687'	,'	outpatient	',	2000000018	)
INTO Patient_Details (Patient_ID, First_Name, Last_Name, Address, Suburb, State, Postcode, Age, Gender, Phone#, Patient_Type, Medicare#) VALUES('	PT123475	','	Jayceson	','	Thomsurn	','	20 Kowahla Lane	','	Clyde	','	VIC	',	3978	,	41	,'	M	','	0412345688'	,'	outpatient	',	2000000019	)
SELECT * FROM DUAL;

INSERT ALL
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123456	',	96500	,	75000	,	20000	,	500	,	500	,'	EFTPOS	','	No	','	16-Jan-2018	',	500	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123457	',	96250	,	75000	,	20000	,	500	,	500	,'	Cash	','	Basic	','	17-Jan-2018	',	250	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123458	',	96000	,	75000	,	20000	,	500	,	500	,'	Cheque	','	Premium	','	18-Jan-2018	',	0	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123459	',	96500	,	75000	,	20000	,	500	,	500	,'	EFTPOS	','	No	','	19-Jan-2018	',	500	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123460	',	96250	,	75000	,	20000	,	500	,	500	,'	Cash	','	Basic	','	20-Jan-2018	',	250	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123461	',	96000	,	75000	,	20000	,	500	,	500	,'	Cheque	','	Premium	','	21-Jan-2018	',	0	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123462	',	96500	,	75000	,	20000	,	500	,	500	,'	EFTPOS	','	No	','	22-Jan-2018	',	500	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123463	',	58750	,	37500	,	20000	,	500	,	500	,'	Cash	','	Basic	','	23-Jan-2018	',	250	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123464	',	96000	,	75000	,	20000	,	500	,	500	,'	Cheque	','	Premium	','	24-Jan-2018	',	0	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123465	',	96500	,	75000	,	20000	,	500	,	500	,'	EFTPOS	','	No	','	25-Jan-2018	',	500	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123466	',	1250	,	0	,	0	,	500	,	500	,'	Cash	','	Basic	','	01-Jan-2019	',	250	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123467	',	1000	,	0	,	0	,	500	,	500	,'	Cheque	','	Premium	','	02-Jan-19	',	0	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123468	',	1500	,	0	,	0	,	500	,	500	,'	EFTPOS	','	No	','	03-Jan-2019	',	500	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123469	',	1250	,	0	,	0	,	500	,	500	,'	Cash	','	Basic	','	04-Jan-19	',	250	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123470	',	1000	,	0	,	0	,	500	,	500	,'	Cheque	','	Premium	','	05-Jan-2019	',	0	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123471	',	1500	,	0	,	0	,	500	,	500	,'	EFTPOS	','	No	','	06-Jan-19	',	500	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123472	',	1250	,	0	,	0	,	500	,	500	,'	Cash	','	Basic	','	07-Jan-2019	',	250	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123476	',	51000	,	30000	,	20000	,	500	,	500	,'	Cheque	','	Premium	','	15-Jul-2019	',	0	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123477	',	51500	,	30000	,	20000	,	500	,	500	,'	EFTPOS	','	No	','	15-Jul-2019	',	500	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123478	',	58750	,	37500	,	20000	,	500	,	500	,'	Cash	','	Basic	','	15-Jul-2019	',	250	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123479	',	96000	,	75000	,	20000	,	500	,	500	,'	Cheque	','	Premium	','	15-Jul-2019	',	0	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123480	',	96500	,	75000	,	20000	,	500	,	500	,'	EFTPOS	','	No	','	15-Jul-2019	',	500	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123481	',	51250	,	30000	,	20000	,	500	,	500	,'	Cash	','	Basic	','	15-Jul-2019	',	250	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123482	',	51000	,	30000	,	20000	,	500	,	500	,'	Cheque	','	Premium	','	16-Jul-2019	',	0	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123483	',	0	,	30000	,	20000	,	500	,	500	,'	EFTPOS	','	No	',NULL,	500	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123484	',	0	,	75000	,	20000	,	500	,	500	,'	Cash	','	Basic	',NULL,	250	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123485	',	0	,	75000	,	20000	,	500	,	500	,'	Cheque	','	Premium	',NULL,	0	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123473	',	1500	,	0	,	0	,	500	,	500	,'	EFTPOS	','	No	','	19-Jul-19	',	500	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123474	',	1250	,	0	,	0	,	500	,	500	,'	Cash	','	Basic	','	19-Jul-19	',	250	)
INTO Patient_Payment (Patient_ID, payment, room_charges, operation_charges, test_charges, blood_charges, payment_type, health_insurance, payment_date, excess_fees) VALUES('	PT123475	',	1000	,	0	,	0	,	500	,	500	,'	Cheque	','	Premium	','	19-Jul-19	',	0	)
SELECT * FROM DUAL;

INSERT ALL
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123456	','	critical	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123457	','	critical	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123458	','	critical	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123459	','	critical	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123460	','	critical	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123461	','	critical	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123462	','	critical	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123463	','	critical	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123464	','	critical	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123465	','	critical	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123466	','	fair	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123467	','	fair	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123468	','	fair	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123469	','	fair	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123470	','	fair	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123471	','	fair	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123472	','	fair	','	good	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123476	','	critical	','	serious	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123477	','	critical	','	serious	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123478	','	critical	','	serious	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123479	','	critical	','	serious	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123480	','	critical	','	serious	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123481	','	critical	','	fair	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123482	','	critical	','	fair	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123483	','	critical	','	fair	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123484	','	critical	','	fair	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123485	','	critical	','	fair	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123473	','	serious	','	fair	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123474	','	serious	','	fair	')
INTO patient_condition (patient_id, initial_condition, current_condition) VALUES('	PT123475	','	serious	','	fair	')
SELECT * FROM DUAL;

INSERT ALL
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100000	,'	PT123456	',	234567	,'	Operational	','	8:00	','	01-Jan-2018	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100001	,'	PT123457	',	234568	,'	Operational	','	9:00	','	02-Jan-18	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100002	,'	PT123458	',	234569	,'	Operational	','	10:00	','	03-Jan-2018	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100003	,'	PT123459	',	234570	,'	Operational	','	11:00	','	04-Jan-18	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100004	,'	PT123460	',	234571	,'	Operational	','	12:00	','	05-Jan-2018	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100005	,'	PT123461	',	234572	,'	Operational	','	13:00	','	06-Jan-18	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100006	,'	PT123462	',	234573	,'	Operational	','	8:00	','	07-Jan-2018	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100007	,'	PT123463	',	234574	,'	Operational	','	9:00	','	08-Jan-18	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100008	,'	PT123464	',	234575	,'	Operational	','	10:00	','	09-Jan-2018	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100009	,'	PT123465	',	234576	,'	Operational	','	11:00	','	10-Jan-2018	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100010	,'	PT123466	',	234577	,'	Regular	','	12:00	','	01-Jan-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100011	,'	PT123467	',	234578	,'	Regular	','	13:00	','	02-Jan-19	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100012	,'	PT123468	',	234579	,'	Regular	','	8:00	','	03-Jan-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100013	,'	PT123469	',	234580	,'	Regular	','	9:00	','	04-Jan-19	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100014	,'	PT123470	',	234581	,'	Regular	','	10:00	','	05-Jan-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100015	,'	PT123471	',	234582	,'	Regular	','	11:00	','	06-Jan-19	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100016	,'	PT123472	',	234583	,'	Regular	','	12:00	','	07-Jan-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100023	,'	PT123476	',	234587	,'	Operational	','	8:00	','	15-Jul-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100024	,'	PT123477	',	234588	,'	Operational	','	9:00	','	15-Jul-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100025	,'	PT123478	',	234589	,'	Operational	','	10:00	','	15-Jul-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100026	,'	PT123479	',	234590	,'	Operational	','	11:00	','	15-Jul-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100027	,'	PT123480	',	234591	,'	Operational	','	12:00	','	15-Jul-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100028	,'	PT123481	',	234592	,'	Operational	','	13:00	','	15-Jul-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100029	,'	PT123482	',	234593	,'	Operational	','	8:00	','	16-Jul-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100030	,'	PT123483	',	234594	,'	Operational	','	9:00	','	17-Jul-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100031	,'	PT123484	',	234595	,'	Operational	','	10:00	','	18-Jul-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100032	,'	PT123485	',	234596	,'	Operational	','	11:00	','	18-Jul-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100017	,'	PT123473	',	234584	,'	Regular	','	7:00	','	19-Jul-19	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100018	,'	PT123474	',	234585	,'	Regular	','	8:00	','	19-Jul-19	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100019	,'	PT123475	',	234586	,'	Regular	','	9:00	','	19-Jul-19	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100020	,'	PT123473	',	234567	,'	Operational	','	10:00	','	19-Aug-19	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100021	,'	PT123474	',	234568	,'	Operational	','	11:00	','	19-Aug-2019	')
INTO treatment_appointments(appointment#, patient_id, emp_id, appointment_type, appointment_time, appointment_date) VALUES (	100022	,'	PT123475	',	234569	,'	Operational	','	12:00	','	19-Aug-2019	')
SELECT * FROM DUAL;

INSERT ALL
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123456	',	234567	,	1101	,	100000	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123457	',	234568	,	1201	,	100001	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123458	',	234569	,	1301	,	100002	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123459	',	234570	,	1401	,	100003	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123460	',	234571	,	1501	,	100004	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123461	',	234572	,	1502	,	100005	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123462	',	234573	,	1503	,	100006	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123463	',	234574	,	1504	,	100007	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123464	',	234575	,	1701	,	100008	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123465	',	234576	,	1801	,	100009	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123466	',	234577	,	1601	,	100010	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123467	',	234578	,	1602	,	100011	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123468	',	234579	,	1603	,	100012	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123469	',	234580	,	1604	,	100013	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123470	',	234581	,	1605	,	100014	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123471	',	234582	,	1601	,	100015	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123472	',	234583	,	1605	,	100016	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123476	',	234587	,	1101	,	100023	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123477	',	234588	,	1102	,	100024	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123478	',	234589	,	1103	,	100025	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123479	',	234590	,	1104	,	100026	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123480	',	234591	,	1105	,	100027	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123481	',	234592	,	1201	,	100028	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123482	',	234593	,	1202	,	100029	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123483	',	234594	,	1203	,	100030	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123484	',	234595	,	1301	,	100031	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123485	',	234596	,	1302	,	100032	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123473	',	234584	,	1603	,	100017	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123474	',	234585	,	1602	,	100018	)
INTO treatment(patient_id, emp_id, room#, appointment#) VALUES('	PT123475	',	234586	,	1604	,	100019	)
SELECT * FROM DUAL;

INSERT ALL
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123456	',	234567	,'	asthma attack	','	Operational	','	Operation Completed	','	No exercise for 2 weeks	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123457	',	234568	,'	heart attack	','	Operational	','	Operation Completed	','	No exercise for 2 weeks	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123458	',	234569	,'	lung cancer	','	Operational	','	Operation Completed	','	No exercise for 2 weeks	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123459	',	234570	,'	motor neuron disease	','	Operational	','	Operation Completed	','	No exercise for 2 weeks	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123460	',	234571	,'	obesity	','	Operational	','	Operation Completed	','	No exercise for 2 weeks	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123461	',	234572	,'	obesity	','	Operational	','	Operation Completed	','	No exercise for 2 weeks	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123462	',	234573	,'	obesity	','	Operational	','	Operation Completed	','	No food for first 4 hours	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123463	',	234574	,'	obesity	','	Operational	','	Operation Completed	','	No food for first 4 hours	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123464	',	234575	,'	dermatitis	','	Operational	','	Operation Completed	','	No food for first 4 hours	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123465	',	234576	,'	wound infection	','	Operational	','	Operation Completed	','	No food for first 4 hours	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123466	',	234577	,'	common cold	','	Regular	','	Check-Up Completed	','	Drink water	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123467	',	234578	,'	frostbite	','	Regular	','	Check-Up Completed	','	Drink water	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123468	',	234579	,'	swine flu	','	Regular	','	Check-Up Completed	','	Drink water	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123469	',	234580	,'	malaria	','	Regular	','	Check-Up Completed	','	Drink water	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123470	',	234581	,'	Ebola	','	Regular	','	Check-Up Completed	','	Sleep more	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123471	',	234582	,'	E. coli bacteria infection	','	Regular	','	Check-Up Completed	','	Sleep more	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123472	',	234583	,'	measles	','	Regular	','	Check-Up Completed	','	Sleep more	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123476	',	234587	,'	asthma attack	','	Operational	','	Operation Completed	','	Drink water	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123477	',	234588	,'	asthma attack	','	Operational	','	Operation Completed	','	Drink water	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123478	',	234589	,'	asthma attack	','	Operational	','	Operation Completed	','	Drink water	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123479	',	234590	,'	asthma attack	','	Operational	','	Operation Completed	','	Drink water	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123480	',	234591	,'	asthma attack	','	Operational	','	Operation Completed	','	Sleep more	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123481	',	234592	,'	heart attack	','	Operational	','	Operation Completed	','	Sleep more	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123482	',	234593	,'	heart attack	','	Operational	','	Operation Completed	','	Sleep more	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123483	',	234594	,'	heart attack	','	Operational	','	Operation Completed	','	Sleep more	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123484	',	234595	,'	skin cancer	','	Operational	','	Operation Completed	','	Sleep more	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123485	',	234596	,'	lung cancer	','	Operational	','	Operation Completed	','	Sleep more	','	N	',	NULL	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123473	',	234584	,'	chickenpox	','	Regular	','	Check-Up Completed	','	Sleep more	','	Y	',	100020	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123474	',	234585	,'	muscle spasm	','	Regular	','	Check-Up Completed	','	Sleep more	','	Y	',	100021	)
INTO patient_treatment(patient_id, emp_id, diagnosis, treatment_type, treatment_status, treatment_advice, follow_up_appointment, follow_up_appointment#) VALUES ('	PT123475	',	234586	,'	heat rash	','	Regular	','	Check-Up Completed	','	Sleep more	','	Y	',	100022	)
SELECT * FROM DUAL;

INSERT ALL
INTO regular_treatment (patient_id, emp_id, time_of_visit, date_of_visit, medicine_prescribed, operation_referral) VALUES ('	PT123466	',	234577	,'	12:00	','	01-Jan-2019	','	panadol	','	N	')
INTO regular_treatment (patient_id, emp_id, time_of_visit, date_of_visit, medicine_prescribed, operation_referral) VALUES ('	PT123467	',	234578	,'	13:00	','	02-Jan-19	','	panadol	','	N	')
INTO regular_treatment (patient_id, emp_id, time_of_visit, date_of_visit, medicine_prescribed, operation_referral) VALUES ('	PT123468	',	234579	,'	8:00	','	03-Jan-2019	','	nurofen	','	N	')
INTO regular_treatment (patient_id, emp_id, time_of_visit, date_of_visit, medicine_prescribed, operation_referral) VALUES ('	PT123469	',	234580	,'	9:00	','	04-Jan-19	','	penicillin	','	N	')
INTO regular_treatment (patient_id, emp_id, time_of_visit, date_of_visit, medicine_prescribed, operation_referral) VALUES ('	PT123470	',	234581	,'	10:00	','	05-Jan-2019	','	green tea	','	N	')
INTO regular_treatment (patient_id, emp_id, time_of_visit, date_of_visit, medicine_prescribed, operation_referral) VALUES ('	PT123471	',	234582	,'	11:00	','	06-Jan-19	','	chyrsanthemum tea	','	N	')
INTO regular_treatment (patient_id, emp_id, time_of_visit, date_of_visit, medicine_prescribed, operation_referral) VALUES ('	PT123472	',	234583	,'	12:00	','	07-Jan-2019	','	laxatives	','	N	')
INTO regular_treatment (patient_id, emp_id, time_of_visit, date_of_visit, medicine_prescribed, operation_referral) VALUES ('	PT123473	',	234584	,'	7:00	','	19-Jul-19	','	Vitamin C	','	Y	')
INTO regular_treatment (patient_id, emp_id, time_of_visit, date_of_visit, medicine_prescribed, operation_referral) VALUES ('	PT123474	',	234585	,'	8:00	','	19-Jul-19	','	strepsils	','	Y	')
INTO regular_treatment (patient_id, emp_id, time_of_visit, date_of_visit, medicine_prescribed, operation_referral) VALUES ('	PT123475	',	234586	,'	9:00	','	19-Jul-19	','	clindamycin	','	Y	')
SELECT * FROM DUAL;

INSERT ALL
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123456	',	234567	,'	Appendectomy	','	8:00	','	01-Jan-2018	','	10:00	','	2-Jan-2018	','	10:00	','	16-Jan-2018	',	2101	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123457	',	234568	,'	Carotid endarterectomy	','	9:00	','	02-Jan-18	','	11:00	','	03-Jan-2018	','	10:00	','	17-Jan-2018	',	2201	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123458	',	234569	,'	Cataract surgery	','	10:00	','	03-Jan-2018	','	12:00	','	4-Jan-2018	','	10:00	','	18-Jan-2018	',	2301	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123459	',	234570	,'	Cholecystectomy	','	11:00	','	04-Jan-18	','	13:00	','	05-Jan-2018	','	10:00	','	19-Jan-2018	',	2401	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123460	',	234571	,'	Coronary artery bypass	','	12:00	','	05-Jan-2018	','	8:00	','	6-Jan-2018	','	10:00	','	20-Jan-2018	',	2501	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123461	',	234572	,'	Coronary artery bypass	','	13:00	','	06-Jan-18	','	9:00	','	07-Jan-2018	','	10:00	','	21-Jan-2018	',	2502	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123462	',	234573	,'	Coronary artery bypass	','	8:00	','	07-Jan-2018	','	10:00	','	8-Jan-2018	','	10:00	','	22-Jan-2018	',	2503	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123463	',	234574	,'	Coronary artery bypass	','	9:00	','	08-Jan-18	','	11:00	','	09-Jan-2018	','	10:00	','	23-Jan-2018	',	2504	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123464	',	234575	,'	Free skin graft	','	10:00	','	09-Jan-2018	','	12:00	','	10-Jan-2018	','	10:00	','	24-Jan-2018	',	2701	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123465	',	234576	,'	Debridement of wound	','	11:00	','	10-Jan-2018	','	13:00	','	11-Jan-2018	','	10:00	','	25-Jan-2018	',	2801	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123476	',	234587	,'	Appendectomy	','	8:00	','	15-Jul-2019	','	10:00	','	16-Jul-2019	','	10:00	','	30-Jul-2019	',	2105	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123477	',	234588	,'	Carotid endarterectomy	','	9:00	','	15-Jul-2019	','	11:00	','	16-Jul-2019	','	10:00	','	30-Jul-2019	',	2105	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123478	',	234589	,'	Cataract surgery	','	10:00	','	15-Jul-2019	','	12:00	','	16-Jul-2019	','	10:00	','	30-Jul-2019	',	2104	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123479	',	234590	,'	Cholecystectomy	','	11:00	','	15-Jul-2019	','	13:00	','	16-Jul-2019	','	10:00	','	30-Jul-2019	',	2101	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123480	',	234591	,'	Coronary artery bypass	','	12:00	','	15-Jul-2019	','	14:00	','	16-Jul-2019	','	10:00	','	30-Jul-2019	',	2102	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123481	',	234592	,'	Coronary artery bypass	','	13:00	','	15-Jul-2019	','	15:00	','	16-Jul-2019	','	10:00	','	30-Jul-2019	',	2205	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123482	',	234593	,'	Coronary artery bypass	','	8:00	','	16-Jul-2019	','	10:00	','	17-Jul-2019	','	10:00	','	31-Jul-2019	',	2205	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123483	',	234594	,'	Coronary artery bypass	','	9:00	','	17-Jul-2019	','	11:00	','	18-Jul-2019	','	10:00	','	1-Aug-2019	',	2205	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123484	',	234595	,'	Free skin graft	','	10:00	','	18-Jul-2019	','	12:00	','	19-Jul-2019	','	10:00	','	2-Aug-2019	',	2301	)
INTO operational_treatment(patient_id, emp_id, operation_type, admission_time, admission_date, operation_time, operation_date, discharge_time, discharge_date, ward#) VALUES ('	PT123485	',	234596	,'	Debridement of wound	','	11:00	','	18-Jul-2019	','	13:00	','	19-Jul-2019	','	10:00	','	2-Aug-2019	',	2302	)
SELECT * FROM DUAL;

INSERT ALL
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234567	,	345671	,'	James	','	Du	','	1 Wenntwurth Junction	','	Bankstown	','	NSW	',	2200	,	26	,'	M	','	0422345678'	,'	Regular Doctor	','	Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234568	,	345672	,'	Bryttnee	','	Hathawei	','	2 St Peta''s Road	','	Bankstown	','	NSW	',	2200	,	45	,'	F	','	0433456789'	,'	Regular Doctor	','	Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234569	,	345673	,'	Ahlysa	','	Geiger	','	3 Hammilturn Street	','	Bankstown	','	NSW	',	2200	,	34	,'	F	','	0444567890'	,'	Regular Doctor	','	Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234570	,	345674	,'	Jehfrie	','	Chevallier	','	4 Carsurhl Avenue	','	Granville	','	NSW	',	2142	,	39	,'	M	','	0455678901'	,'	Regular Doctor	','	Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234571	,	345675	,'	Soosin	','	Culombow	','	5 Dayell Crescent	','	Auburn	','	NSW	',	2144	,	24	,'	F	','	0466789012'	,'	Regular Doctor	','	Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234572	,	345675	,'	Jessieighkah	','	Odurn	','	6 Hedder Parade	','	Auburn	','	NSW	',	2144	,	22	,'	F	','	0422345679'	,'	On-Call Doctor	','	Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234573	,	345675	,'	Vyolette	','	Rowe	','	7 Preemrohse Street	','	Auburn	','	NSW	',	2144	,	36	,'	F	','	0422345680'	,'	On-Call Doctor	','	Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234574	,	345675	,'	Thyeson	','	Whight	','	8 Meddough Highway	','	Merrylands	','	NSW	',	2200	,	48	,'	M	','	0422345681'	,'	On-Call Doctor	','	Specialist Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234575	,	345677	,'	Sofhiyah	','	Witbek	','	9 Ferrie Boulevard	','	Merrylands	','	NSW	',	2200	,	54	,'	F	','	0422345682'	,'	On-Call Doctor	','	Specialist Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234576	,	345678	,'	Red	','	Sandstoan	','	10 Ralewayy Parade	','	Merrylands	','	NSW	',	2200	,	32	,'	M	','	0422345683'	,'	On-Call Doctor	','	Specialist Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234577	,	345676	,'	Aliviyah	','	Leeki	','	11 Bruhnsweek Street	','	Merrylands	','	NSW	',	2200	,	31	,'	F	','	0477890123'	,'	Regular Doctor	','	Physician	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234578	,	345676	,'	Khaileigh	','	Warllace	','	12 Lawrell Drive	','	Merrylands	','	NSW	',	2200	,	30	,'	F	','	0488901234'	,'	Regular Doctor	','	Physician	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234579	,	345676	,'	Klowee	','	Moregurn	','	13 Lyme Avenue	','	Merrylands	','	NSW	',	2200	,	22	,'	F	','	0499012345'	,'	Regular Doctor	','	Physician	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234580	,	345676	,'	Lukiss	','	Wallastern	','	14 Howlwurd Street	','	Merrylands	','	NSW	',	2200	,	27	,'	M	','	0400123456'	,'	Regular Doctor	','	Physician	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234581	,	345676	,'	Ehyrnn	','	Garrutt	','	15 Arguyall Street	','	Merrylands	','	NSW	',	2200	,	28	,'	F	','	0411234567'	,'	On-Call Doctor	','	Physician	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234582	,	345676	,'	Viktoriyah	','	O''Connar	','	16 Konturnentool Drive	','	Merrylands	','	NSW	',	2200	,	25	,'	F	','	0422345684'	,'	Regular Doctor	','	GP	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234583	,	345676	,'	Grayss	','	Kyeeting	','	17 Buurch Corner	','	Merrylands	','	NSW	',	2200	,	24	,'	F	','	0422345685'	,'	On-Call Doctor	','	GP	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234587	,	345671	,'	Crowlea	','	Baykar	','	21 Gagguar Street	','	Merrylands	','	NSW	',	2200	,	39	,'	M	','	0422345689'	,'	Regular Doctor	','	Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234588	,	345671	,'	Xzavier	','	Limozeen	','	22 Chitarr Road	','	Merrylands	','	NSW	',	2200	,	24	,'	M	','	0422345690'	,'	Regular Doctor	','	Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234589	,	345671	,'	Ayden	','	Lamborginny	','	23 Jiraff Street	','	Merrylands	','	NSW	',	2200	,	22	,'	M	','	0422345691'	,'	Regular Doctor	','	Specialist Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234590	,	345671	,'	Austyn	','	Mazzdar	','	24 Heeppo Junction	','	Merrylands	','	NSW	',	2200	,	36	,'	M	','	0422345692'	,'	Regular Doctor	','	Specialist Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234591	,	345671	,'	Jaxon	','	Teryoda	','	25 Champeeon Road	','	Merrylands	','	NSW	',	2200	,	48	,'	M	','	0422345693'	,'	Regular Doctor	','	Specialist Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234592	,	345672	,'	Cyndee	','	Honderr	','	26 Tygre Street	','	Merrylands	','	NSW	',	2200	,	54	,'	F	','	0422345694'	,'	Regular Doctor	','	Specialist Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234593	,	345672	,'	Romio	','	Volkkswaygurn	','	27 Lyon Lane	','	Merrylands	','	NSW	',	2200	,	32	,'	M	','	0422345695'	,'	Regular Doctor	','	Specialist Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234594	,	345672	,'	Zepplinn	','	Lowpezz	','	28 Kangahru Street	','	Merrylands	','	NSW	',	2200	,	31	,'	M	','	0422345696'	,'	Regular Doctor	','	Specialist Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234595	,	345673	,'	Camrie	','	Adumms	','	29 Parut Lane	','	Deception Bay	','	QLD	',	4508	,	30	,'	M	','	0422345697'	,'	Regular Doctor	','	Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234596	,	345673	,'	Soobaroo	','	Cambull	','	30 Eegull Street	','	Clyde	','	VIC	',	3978	,	22	,'	M	','	0422345698'	,'	Regular Doctor	','	Surgeon	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234584	,	345676	,'	Sharlotte	','	Joans	','	18 Klarurnce Road	','	Merrylands	','	NSW	',	2200	,	38	,'	F	','	0422345686'	,'	On-Call Doctor	','	Medical Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234585	,	345676	,'	Nikoliss	','	McCafferee	','	19 Knellson Street	','	Merrylands	','	NSW	',	2200	,	36	,'	M	','	0422345687'	,'	On-Call Doctor	','	Medical Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234586	,	345676	,'	Ameelyah	','	Shellbee	','	20 Durrbee Parade	','	Merrylands	','	NSW	',	2200	,	26	,'	F	','	0422345688'	,'	On-Call Doctor	','	Medical Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234597	,	345679	,'	Meenee	','	Cooparr	','	31 Semester Street	','	Auburn	','	NSW	',	2144	,	26	,'	F	','	0422345689'	,'	Full-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234598	,	345679	,'	Holedern	','	Fawd	','	32 Bimester Street	','	Auburn	','	NSW	',	2144	,	45	,'	F	','	0422345690'	,'	Full-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234599	,	345679	,'	Nisten	','	Maxzdar	','	33 Trimester Street	','	Auburn	','	NSW	',	2144	,	34	,'	M	','	0422345691'	,'	Full-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234600	,	345679	,'	Muhseedeez	','	Bensz	','	34 Quadmester Street	','	Auburn	','	NSW	',	2144	,	39	,'	F	','	0422345692'	,'	Full-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234601	,	345679	,'	Hyundye	','	Keya	','	35 Pentmester Street	','	Auburn	','	NSW	',	2144	,	24	,'	F	','	0422345693'	,'	Full-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234602	,	345679	,'	Peujot	','	Alpha	','	36 Hexmester Street	','	Auburn	','	NSW	',	2144	,	22	,'	F	','	0422345694'	,'	Full-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234603	,	345679	,'	Shevvralet	','	Kaddilack	','	37 Heptmester Street	','	Auburn	','	NSW	',	2144	,	36	,'	M	','	0422345695'	,'	Full-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234604	,	345680	,'	Feeat	','	Infinurtea	','	38 Octmester Street	','	Auburn	','	NSW	',	2144	,	48	,'	F	','	0422345696'	,'	Full-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234605	,	345680	,'	Mitsirbishee	','	Soozukey	','	39 Novmester Street	','	Auburn	','	NSW	',	2144	,	54	,'	M	','	0422345697'	,'	Full-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234606	,	345680	,'	Rova	','	Pawshe	','	40 Decmester Street	','	Auburn	','	NSW	',	2144	,	32	,'	F	','	0422345698'	,'	Full-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234607	,	345680	,'	Cryslar	','	Sitroyen	','	41 Nonamester Street	','	Auburn	','	NSW	',	2144	,	31	,'	F	','	0422345699'	,'	Part-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234608	,	345680	,'	Scodarr	','	Renolte	','	42 Dodecmester Street	','	Auburn	','	NSW	',	2144	,	30	,'	F	','	0422345700'	,'	Part-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234609	,	345680	,'	Leksurs	','	Jenesurs	','	43 Enjurkneering Road	','	Auburn	','	NSW	',	2144	,	22	,'	M	','	0422345701'	,'	Part-Time Nurse	','	Nurse Practitioner	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234610	,	345680	,'	Abbarrth	','	Dohje	','	44 Akchooreeal Parade	','	Auburn	','	NSW	',	2144	,	27	,'	F	','	0422345702'	,'	Part-Time Nurse	','	Vocational Nurse	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234611	,	345680	,'	Raynje	','	Duhmane	','	45 Medisuhrn Junction	','	Auburn	','	NSW	',	2144	,	28	,'	F	','	0422345703'	,'	Part-Time Nurse	','	Vocational Nurse	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234612	,	345680	,'	Asuhmptoat	','	Intuhrsept	','	46 Commuhrs Road	','	Auburn	','	NSW	',	2144	,	25	,'	F	','	0422345704'	,'	Part-Time Nurse	','	Vocational Nurse	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234613	,	345680	,'	Akcis	','	Commpleks	','	47 Lorr Avenue	','	Auburn	','	NSW	',	2144	,	24	,'	F	','	0422345705'	,'	Part-Time Nurse	','	Vocational Nurse	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234614	,	345680	,'	Cowordernurt	','	Skwared	','	48 Fale Road	','	Auburn	','	NSW	',	2144	,	39	,'	F	','	0422345706'	,'	Part-Time Nurse	','	Vocational Nurse	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234615	,	345679	,'	Regreshuhn	','	Lyne	','	49 Pahrs Lane	','	Auburn	','	NSW	',	2144	,	24	,'	M	','	0422345707'	,'	Part-Time Nurse	','	Vocational Nurse	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234616	,	345679	,'	Seegmah	','	Notayshun	','	50 Merurt Boulevard	','	Auburn	','	NSW	',	2144	,	22	,'	F	','	0422345708'	,'	Part-Time Nurse	','	Vocational Nurse	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234617	,	345679	,'	Standerrd	','	Deeveeashun	','	51 Disstinkshurn Street	','	Auburn	','	NSW	',	2144	,	36	,'	F	','	0422345709'	,'	Compounder	','	Pharmacist	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234618	,	345679	,'	Couhfishunt	','	Vehriashun	','	52 Hie-dee Road	','	Auburn	','	NSW	',	2144	,	48	,'	F	','	0422345710'	,'	Compounder	','	Pharmacist	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234619	,	345679	,'	Dertuhrminaytion	','	Esse	','	53 Treeguhred Road	','	Auburn	','	NSW	',	2144	,	54	,'	M	','	0422345711'	,'	Compounder	','	Pharmacist	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234620	,	345679	,'	Mooyle	','	Cuebed	','	54 Sulteeh Lane	','	Auburn	','	NSW	',	2144	,	32	,'	F	','	0422345712'	,'	Compounder	','	Pharmacist	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234621	,	345679	,'	Zeeye	','	Scuhre	','	55 Ansighyurtee Street	','	Auburn	','	NSW	',	2144	,	31	,'	M	','	0422345713'	,'	Compounder	','	Pharmacist	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234622	,	345679	,'	Conferduhnce	','	Intuhrvool	','	56 Depreshurn Lane	','	Auburn	','	NSW	',	2144	,	30	,'	F	','	0422345714'	,'	Anaesthetist	','	Senior Staff Specialist	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234623	,	345679	,'	Teeye	','	Dissjrabuushurn	','	57 Byeuhs Street	','	Auburn	','	NSW	',	2144	,	22	,'	F	','	0422345715'	,'	Anaesthetist	','	Senior Staff Specialist	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234624	,	345679	,'	Kyie	','	Mowd	','	58 Tendonsee Parade	','	Auburn	','	NSW	',	2144	,	24	,'	F	','	0422345716'	,'	Anaesthetist	','	Senior Staff Specialist	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234625	,	345679	,'	Meediyurn	','	Avuhridge	','	59 Sentrool Street	','	Auburn	','	NSW	',	2144	,	39	,'	M	','	0422345717'	,'	Janitor	','	Custodian	')
INTO staff_details (emp_id, department_id, first_name, last_name, address, suburb, state, postcode, age, gender, phone#, emp_type, job_title) VALUES (	234626	,	345679	,'	Intakwartiyle	','	Ranjje	','	60 Olimpick Drive	','	Auburn	','	NSW	',	2144	,	24	,'	F	','	0422345718'	,'	Janitor	','	Custodian	')
SELECT * FROM DUAL;

INSERT ALL
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234567	,'	Doctor of Surgery	',	1010000000	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234568	,'	Doctor of Surgery	',	1010000001	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234569	,'	Doctor of Surgery	',	1010000002	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234570	,'	Doctor of Surgery	',	1010000003	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234571	,'	Doctor of Surgery	',	1010000004	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234572	,'	Doctor of Surgery	',	1010000005	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234573	,'	Doctor of Surgery	',	1010000006	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234574	,'	Doctor of Surgery	',	1010000007	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234575	,'	Doctor of Surgery	',	1010000008	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234576	,'	Doctor of Surgery	',	1010000009	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234577	,'	Doctor of Medicine	',	1010000010	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234578	,'	Doctor of Medicine	',	1010000011	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234579	,'	Doctor of Medicine	',	1010000012	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234580	,'	Doctor of Medicine	',	1010000013	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234581	,'	Doctor of Medicine	',	1010000014	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234582	,'	Doctor of Medicine	',	1010000015	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234583	,'	Doctor of Medicine	',	1010000016	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234587	,'	Doctor of Surgery	',	1010000017	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234588	,'	Doctor of Surgery	',	1010000018	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234589	,'	Doctor of Surgery	',	1010000019	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234590	,'	Doctor of Surgery	',	1010000020	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234591	,'	Doctor of Surgery	',	1010000021	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234592	,'	Doctor of Surgery	',	1010000022	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234593	,'	Doctor of Surgery	',	1010000023	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234594	,'	Doctor of Surgery	',	1010000024	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234595	,'	Doctor of Surgery	',	1010000025	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234596	,'	Doctor of Surgery	',	1010000026	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234584	,'	Doctor of Medicine	',	1010000027	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234585	,'	Doctor of Medicine	',	1010000028	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234586	,'	Doctor of Medicine	',	1010000029	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234567	,'	Doctor of Medical Science	',	1010000086	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234567	,'	Doctor of Clinical Medicine	',	1010000087	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234567	,'	Doctor of Clinical Surgery	',	1010000088	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234567	,'	Doctor of Philosophy (Medicine)	',	1010000030	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234568	,'	Doctor of Medical Science	',	1010000031	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234568	,'	Doctor of Clinical Medicine	',	1010000032	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234568	,'	Doctor of Clinical Surgery	',	1010000033	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234568	,'	Doctor of Philosophy (Medicine)	',	1010000034	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234597	,'	Bachelor of Nursing	',	1010000035	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234598	,'	Bachelor of Nursing	',	1010000036	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234599	,'	Bachelor of Nursing	',	1010000037	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234600	,'	Bachelor of Nursing	',	1010000038	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234601	,'	Bachelor of Nursing	',	1010000039	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234602	,'	Bachelor of Nursing	',	1010000040	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234603	,'	Bachelor of Nursing	',	1010000041	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234604	,'	Bachelor of Nursing	',	1010000042	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234605	,'	Bachelor of Nursing	',	1010000043	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234606	,'	Bachelor of Nursing	',	1010000044	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234607	,'	Bachelor of Nursing	',	1010000045	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234608	,'	Bachelor of Nursing	',	1010000046	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234609	,'	Bachelor of Nursing	',	1010000047	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234610	,'	Bachelor of Nursing	',	1010000048	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234611	,'	Bachelor of Nursing	',	1010000049	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234612	,'	Bachelor of Nursing	',	1010000050	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234613	,'	Bachelor of Nursing	',	1010000051	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234614	,'	Bachelor of Nursing	',	1010000052	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234615	,'	Bachelor of Nursing	',	1010000053	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234616	,'	Bachelor of Nursing	',	1010000054	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234597	,'	Diploma of Nursing	',	1010000055	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234598	,'	Diploma of Nursing	',	1010000056	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234599	,'	Diploma of Nursing	',	1010000057	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234600	,'	Diploma of Nursing	',	1010000058	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234601	,'	Diploma of Nursing	',	1010000059	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234602	,'	Diploma of Nursing	',	1010000060	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234603	,'	Diploma of Nursing	',	1010000061	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234604	,'	Diploma of Nursing	',	1010000062	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234605	,'	Diploma of Nursing	',	1010000063	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234606	,'	Diploma of Nursing	',	1010000064	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234607	,'	Diploma of Nursing	',	1010000065	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234608	,'	Diploma of Nursing	',	1010000066	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234609	,'	Diploma of Nursing	',	1010000067	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234610	,'	Diploma of Nursing	',	1010000068	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234611	,'	Diploma of Nursing	',	1010000069	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234612	,'	Diploma of Nursing	',	1010000070	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234613	,'	Diploma of Nursing	',	1010000071	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234614	,'	Diploma of Nursing	',	1010000072	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234615	,'	Diploma of Nursing	',	1010000073	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234616	,'	Diploma of Nursing	',	1010000074	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234617	,'	Bachelor of Pharmacy	',	1010000075	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234618	,'	Bachelor of Pharmacy	',	1010000076	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234619	,'	Bachelor of Pharmacy	',	1010000077	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234620	,'	Bachelor of Pharmacy	',	1010000078	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234621	,'	Bachelor of Pharmacy	',	1010000079	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234622	,'	Master of Science in Anaesthesia	',	1010000080	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234623	,'	Master of Science in Anaesthesia	',	1010000081	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234624	,'	Master of Science in Anaesthesia	',	1010000082	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234622	,'	Diploma of Anaesthetic Technology	',	1010000083	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234623	,'	Diploma of Anaesthetic Technology	',	1010000084	,	4	)
INTO staff_qualifications (emp_id, qualification, certificate#, certificate_level) VALUES(	234624	,'	Diploma of Anaesthetic Technology	',	1010000085	,	4	)
SELECT * FROM DUAL;

INSERT ALL
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100000,	234567	,'	7:00	','	15:00	','	01-Jan-2018	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100001,	234568	,'	7:00	','	15:00	','	02-Jan-18	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100002,	234569	,'	7:00	','	15:00	','	03-Jan-2018	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100003,	234570	,'	7:00	','	15:00	','	04-Jan-18	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100004,	234571	,'	7:00	','	15:00	','	05-Jan-2018	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100005,	234572	,'	7:00	','	15:00	','	06-Jan-18	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100006,	234573	,'	7:00	','	15:00	','	07-Jan-2018	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100007,	234574	,'	7:00	','	15:00	','	08-Jan-18	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100008,	234575	,'	7:00	','	15:00	','	09-Jan-2018	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100009,	234576	,'	7:00	','	15:00	','	10-Jan-2018	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100010,	234577	,'	7:00	','	15:00	','	01-Jan-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100011,	234578	,'	7:00	','	15:00	','	02-Jan-19	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100012,	234579	,'	7:00	','	15:00	','	03-Jan-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100013,	234580	,'	7:00	','	15:00	','	04-Jan-19	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100014,	234581	,'	7:00	','	15:00	','	05-Jan-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100015,	234582	,'	7:00	','	15:00	','	06-Jan-19	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100016,	234583	,'	7:00	','	15:00	','	07-Jan-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100017,	234587	,'	7:00	','	15:00	','	15-Jul-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100018,	234588	,'	7:00	','	15:00	','	15-Jul-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100019,	234589	,'	7:00	','	15:00	','	15-Jul-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100020,	234590	,'	7:00	','	15:00	','	15-Jul-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100021,	234591	,'	7:00	','	15:00	','	15-Jul-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100022,	234592	,'	7:00	','	15:00	','	15-Jul-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100023,	234593	,'	7:00	','	15:00	','	16-Jul-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100024,	234594	,'	7:00	','	15:00	','	17-Jul-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100025,	234595	,'	7:00	','	15:00	','	18-Jul-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100026,	234596	,'	7:00	','	15:00	','	18-Jul-2019	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100027,	234584	,'	7:00	','	15:00	','	19-Jul-19	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100028,	234585	,'	7:00	','	15:00	','	19-Jul-19	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100029,	234586	,'	7:00	','	15:00	','	19-Jul-19	',	8	)
INTO staff_shifts(shift#, emp_id, shift_start_time, shift_end_time, shift_date, hours_worked) VALUES(100030,	234586	,'	7:00	','	15:00	','	20-Jul-19	',	8	)
SELECT * FROM DUAL;

INSERT ALL
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234567	,	50000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234568	,	50000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234569	,	50000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234570	,	50000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234571	,	50000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234577	,	45000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234578	,	45000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234579	,	45000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234580	,	45000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234582	,	40000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234587	,	50000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234588	,	50000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234589	,	55000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234590	,	55000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234591	,	55000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234592	,	55000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234593	,	55000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234594	,	55000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234595	,	50000	,'	01-Jan-15	')
INTO regular_doctors(emp_id, salary, hire_date) VALUES(	234596	,	50000	,'	01-Jan-15	')
SELECT * FROM DUAL;

INSERT ALL
INTO on_call_doctors (emp_id, fees_per_call, payment_due_date) VALUES(	234572	,	200	,'	13-Jan-18	')
INTO on_call_doctors (emp_id, fees_per_call, payment_due_date) VALUES(	234573	,	200	,'	14-Jan-18	')
INTO on_call_doctors (emp_id, fees_per_call, payment_due_date) VALUES(	234574	,	200	,'	15-Jan-18	')
INTO on_call_doctors (emp_id, fees_per_call, payment_due_date) VALUES(	234575	,	200	,'	16-Jan-18	')
INTO on_call_doctors (emp_id, fees_per_call, payment_due_date) VALUES(	234576	,	200	,'	17-Jan-18	')
INTO on_call_doctors (emp_id, fees_per_call, payment_due_date) VALUES(	234581	,	100	,'	12-Jan-19	')
INTO on_call_doctors (emp_id, fees_per_call, payment_due_date) VALUES(	234583	,	100	,'	14-Jan-19	')
INTO on_call_doctors (emp_id, fees_per_call, payment_due_date) VALUES(	234584	,	150	,'	15-Jan-19	')
INTO on_call_doctors (emp_id, fees_per_call, payment_due_date) VALUES(	234585	,	150	,'	15-Jan-19	')
INTO on_call_doctors (emp_id, fees_per_call, payment_due_date) VALUES(	234586	,	150	,'	15-Jan-19	')
SELECT * FROM DUAL;

INSERT ALL
INTO full_time_nurses (emp_id, salary, hire_date) VALUES (	234597	,	25000	,'	01-Jan-15	')
INTO full_time_nurses (emp_id, salary, hire_date) VALUES (	234598	,	25000	,'	01-Jan-15	')
INTO full_time_nurses (emp_id, salary, hire_date) VALUES (	234599	,	25000	,'	01-Jan-15	')
INTO full_time_nurses (emp_id, salary, hire_date) VALUES (	234600	,	25000	,'	01-Jan-15	')
INTO full_time_nurses (emp_id, salary, hire_date) VALUES (	234601	,	25000	,'	01-Jan-15	')
INTO full_time_nurses (emp_id, salary, hire_date) VALUES (	234602	,	25000	,'	01-Jan-15	')
INTO full_time_nurses (emp_id, salary, hire_date) VALUES (	234603	,	25000	,'	01-Jan-15	')
INTO full_time_nurses (emp_id, salary, hire_date) VALUES (	234604	,	25000	,'	01-Jan-15	')
INTO full_time_nurses (emp_id, salary, hire_date) VALUES (	234605	,	25000	,'	01-Jan-15	')
INTO full_time_nurses (emp_id, salary, hire_date) VALUES (	234606	,	25000	,'	01-Jan-15	')
SELECT * FROM DUAL;

INSERT ALL
INTO part_time_nurses(emp_id, payment_due_date, hourly_pay) VALUES(	234607	,'	01-Aug-19	',	75	)
INTO part_time_nurses(emp_id, payment_due_date, hourly_pay) VALUES(	234608	,'	01-Aug-19	',	75	)
INTO part_time_nurses(emp_id, payment_due_date, hourly_pay) VALUES(	234609	,'	01-Aug-19	',	75	)
INTO part_time_nurses(emp_id, payment_due_date, hourly_pay) VALUES(	234610	,'	01-Aug-19	',	75	)
INTO part_time_nurses(emp_id, payment_due_date, hourly_pay) VALUES(	234611	,'	01-Aug-19	',	75	)
INTO part_time_nurses(emp_id, payment_due_date, hourly_pay) VALUES(	234612	,'	01-Aug-19	',	75	)
INTO part_time_nurses(emp_id, payment_due_date, hourly_pay) VALUES(	234613	,'	01-Aug-19	',	75	)
INTO part_time_nurses(emp_id, payment_due_date, hourly_pay) VALUES(	234614	,'	01-Aug-19	',	75	)
INTO part_time_nurses(emp_id, payment_due_date, hourly_pay) VALUES(	234615	,'	01-Aug-19	',	75	)
INTO part_time_nurses(emp_id, payment_due_date, hourly_pay) VALUES(	234616	,'	01-Aug-19	',	75	)
SELECT * FROM DUAL;

INSERT ALL
INTO other_staff (emp_id, payment_due_date, hourly_pay) VALUES(	234617	,'	01-Aug-19	',	75	)
INTO other_staff (emp_id, payment_due_date, hourly_pay) VALUES(	234618	,'	01-Aug-19	',	75	)
INTO other_staff (emp_id, payment_due_date, hourly_pay) VALUES(	234619	,'	01-Aug-19	',	75	)
INTO other_staff (emp_id, payment_due_date, hourly_pay) VALUES(	234620	,'	01-Aug-19	',	75	)
INTO other_staff (emp_id, payment_due_date, hourly_pay) VALUES(	234621	,'	01-Aug-19	',	75	)
INTO other_staff (emp_id, payment_due_date, hourly_pay) VALUES(	234622	,'	01-Aug-19	',	100	)
INTO other_staff (emp_id, payment_due_date, hourly_pay) VALUES(	234623	,'	01-Aug-19	',	100	)
INTO other_staff (emp_id, payment_due_date, hourly_pay) VALUES(	234624	,'	01-Aug-19	',	100	)
INTO other_staff (emp_id, payment_due_date, hourly_pay) VALUES(	234625	,'	01-Aug-19	',	20	)
INTO other_staff (emp_id, payment_due_date, hourly_pay) VALUES(	234626	,'	01-Aug-19	',	20	)
SELECT * FROM DUAL;

UPDATE department SET department_id = LTRIM(RTRIM(REPLACE(department_id, CHR(9), '')));
UPDATE department SET department_id = LTRIM(RTRIM(REPLACE(department_id, CHR(10), '')));
UPDATE department SET department_id = LTRIM(RTRIM(REPLACE(department_id, CHR(13), '')));

UPDATE department SET department_name = LTRIM(RTRIM(REPLACE(department_name, CHR(9), '')));
UPDATE department SET department_name = LTRIM(RTRIM(REPLACE(department_name, CHR(10), '')));
UPDATE department SET department_name = LTRIM(RTRIM(REPLACE(department_name, CHR(13), '')));

UPDATE department SET location = LTRIM(RTRIM(REPLACE(location, CHR(9), '')));
UPDATE department SET location = LTRIM(RTRIM(REPLACE(location, CHR(10), '')));
UPDATE department SET location = LTRIM(RTRIM(REPLACE(location, CHR(13), '')));

UPDATE department_facilities SET room# = LTRIM(RTRIM(REPLACE(room#, CHR(9), '')));
UPDATE department_facilities SET room# = LTRIM(RTRIM(REPLACE(room#, CHR(10), '')));
UPDATE department_facilities SET room# = LTRIM(RTRIM(REPLACE(room#, CHR(13), '')));

UPDATE department_facilities SET department_id = LTRIM(RTRIM(REPLACE(department_id, CHR(9), '')));
UPDATE department_facilities SET department_id = LTRIM(RTRIM(REPLACE(department_id, CHR(10), '')));
UPDATE department_facilities SET department_id = LTRIM(RTRIM(REPLACE(department_id, CHR(13), '')));

UPDATE department_facilities SET facility_type = LTRIM(RTRIM(REPLACE(facility_type, CHR(9), '')));
UPDATE department_facilities SET facility_type = LTRIM(RTRIM(REPLACE(facility_type, CHR(10), '')));
UPDATE department_facilities SET facility_type = LTRIM(RTRIM(REPLACE(facility_type, CHR(13), '')));

UPDATE department_facilities SET floor# = LTRIM(RTRIM(REPLACE(floor#, CHR(9), '')));
UPDATE department_facilities SET floor# = LTRIM(RTRIM(REPLACE(floor#, CHR(10), '')));
UPDATE department_facilities SET floor# = LTRIM(RTRIM(REPLACE(floor#, CHR(13), '')));

UPDATE department_facilities SET room_status = LTRIM(RTRIM(REPLACE(room_status, CHR(9), '')));
UPDATE department_facilities SET room_status = LTRIM(RTRIM(REPLACE(room_status, CHR(10), '')));
UPDATE department_facilities SET room_status = LTRIM(RTRIM(REPLACE(room_status, CHR(13), '')));

UPDATE full_time_nurses SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE full_time_nurses SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE full_time_nurses SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE full_time_nurses SET salary = LTRIM(RTRIM(REPLACE(salary, CHR(9), '')));
UPDATE full_time_nurses SET salary = LTRIM(RTRIM(REPLACE(salary, CHR(10), '')));
UPDATE full_time_nurses SET salary = LTRIM(RTRIM(REPLACE(salary, CHR(13), '')));

UPDATE full_time_nurses SET hire_date = LTRIM(RTRIM(REPLACE(hire_date, CHR(9), '')));
UPDATE full_time_nurses SET hire_date = LTRIM(RTRIM(REPLACE(hire_date, CHR(10), '')));
UPDATE full_time_nurses SET hire_date = LTRIM(RTRIM(REPLACE(hire_date, CHR(13), '')));

UPDATE on_call_doctors SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE on_call_doctors SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE on_call_doctors SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE on_call_doctors SET fees_per_call = LTRIM(RTRIM(REPLACE(fees_per_call, CHR(9), '')));
UPDATE on_call_doctors SET fees_per_call = LTRIM(RTRIM(REPLACE(fees_per_call, CHR(10), '')));
UPDATE on_call_doctors SET fees_per_call = LTRIM(RTRIM(REPLACE(fees_per_call, CHR(13), '')));

UPDATE on_call_doctors SET payment_due_date = LTRIM(RTRIM(REPLACE(payment_due_date, CHR(9), '')));
UPDATE on_call_doctors SET payment_due_date = LTRIM(RTRIM(REPLACE(payment_due_date, CHR(10), '')));
UPDATE on_call_doctors SET payment_due_date = LTRIM(RTRIM(REPLACE(payment_due_date, CHR(13), '')));

UPDATE operational_treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(9), '')));
UPDATE operational_treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(10), '')));
UPDATE operational_treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(13), '')));

UPDATE operational_treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE operational_treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE operational_treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE operational_treatment SET operation_type = LTRIM(RTRIM(REPLACE(operation_type, CHR(9), '')));
UPDATE operational_treatment SET operation_type = LTRIM(RTRIM(REPLACE(operation_type, CHR(10), '')));
UPDATE operational_treatment SET operation_type = LTRIM(RTRIM(REPLACE(operation_type, CHR(13), '')));

UPDATE operational_treatment SET admission_time = LTRIM(RTRIM(REPLACE(admission_time, CHR(9), '')));
UPDATE operational_treatment SET admission_time = LTRIM(RTRIM(REPLACE(admission_time, CHR(10), '')));
UPDATE operational_treatment SET admission_time = LTRIM(RTRIM(REPLACE(admission_time, CHR(13), '')));

UPDATE operational_treatment SET admission_date = LTRIM(RTRIM(REPLACE(admission_date, CHR(9), '')));
UPDATE operational_treatment SET admission_date = LTRIM(RTRIM(REPLACE(admission_date, CHR(10), '')));
UPDATE operational_treatment SET admission_date = LTRIM(RTRIM(REPLACE(admission_date, CHR(13), '')));

UPDATE operational_treatment SET operation_time = LTRIM(RTRIM(REPLACE(operation_time, CHR(9), '')));
UPDATE operational_treatment SET operation_time = LTRIM(RTRIM(REPLACE(operation_time, CHR(10), '')));
UPDATE operational_treatment SET operation_time = LTRIM(RTRIM(REPLACE(operation_time, CHR(13), '')));

UPDATE operational_treatment SET operation_date = LTRIM(RTRIM(REPLACE(operation_date, CHR(9), '')));
UPDATE operational_treatment SET operation_date = LTRIM(RTRIM(REPLACE(operation_date, CHR(10), '')));
UPDATE operational_treatment SET operation_date = LTRIM(RTRIM(REPLACE(operation_date, CHR(13), '')));

UPDATE operational_treatment SET discharge_time = LTRIM(RTRIM(REPLACE(discharge_time, CHR(9), '')));
UPDATE operational_treatment SET discharge_time = LTRIM(RTRIM(REPLACE(discharge_time, CHR(10), '')));
UPDATE operational_treatment SET discharge_time = LTRIM(RTRIM(REPLACE(discharge_time, CHR(13), '')));

UPDATE operational_treatment SET discharge_date = LTRIM(RTRIM(REPLACE(discharge_date, CHR(9), '')));
UPDATE operational_treatment SET discharge_date = LTRIM(RTRIM(REPLACE(discharge_date, CHR(10), '')));
UPDATE operational_treatment SET discharge_date = LTRIM(RTRIM(REPLACE(discharge_date, CHR(13), '')));

UPDATE operational_treatment SET ward# = LTRIM(RTRIM(REPLACE(ward#, CHR(9), '')));
UPDATE operational_treatment SET ward# = LTRIM(RTRIM(REPLACE(ward#, CHR(10), '')));
UPDATE operational_treatment SET ward# = LTRIM(RTRIM(REPLACE(ward#, CHR(13), '')));

UPDATE other_staff SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE other_staff SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE other_staff SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE other_staff SET hourly_pay = LTRIM(RTRIM(REPLACE(hourly_pay, CHR(9), '')));
UPDATE other_staff SET hourly_pay = LTRIM(RTRIM(REPLACE(hourly_pay, CHR(10), '')));
UPDATE other_staff SET hourly_pay = LTRIM(RTRIM(REPLACE(hourly_pay, CHR(13), '')));

UPDATE other_staff SET payment_due_date = LTRIM(RTRIM(REPLACE(payment_due_date, CHR(9), '')));
UPDATE other_staff SET payment_due_date = LTRIM(RTRIM(REPLACE(payment_due_date, CHR(10), '')));
UPDATE other_staff SET payment_due_date = LTRIM(RTRIM(REPLACE(payment_due_date, CHR(13), '')));

UPDATE part_time_nurses SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE part_time_nurses SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE part_time_nurses SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE part_time_nurses SET hourly_pay = LTRIM(RTRIM(REPLACE(hourly_pay, CHR(9), '')));
UPDATE part_time_nurses SET hourly_pay = LTRIM(RTRIM(REPLACE(hourly_pay, CHR(10), '')));
UPDATE part_time_nurses SET hourly_pay = LTRIM(RTRIM(REPLACE(hourly_pay, CHR(13), '')));

UPDATE part_time_nurses SET payment_due_date = LTRIM(RTRIM(REPLACE(payment_due_date, CHR(9), '')));
UPDATE part_time_nurses SET payment_due_date = LTRIM(RTRIM(REPLACE(payment_due_date, CHR(10), '')));
UPDATE part_time_nurses SET payment_due_date = LTRIM(RTRIM(REPLACE(payment_due_date, CHR(13), '')));

UPDATE patient_condition SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(9), '')));
UPDATE patient_condition SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(10), '')));
UPDATE patient_condition SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(13), '')));

UPDATE patient_condition SET initial_condition = LTRIM(RTRIM(REPLACE(initial_condition, CHR(9), '')));
UPDATE patient_condition SET initial_condition = LTRIM(RTRIM(REPLACE(initial_condition, CHR(10), '')));
UPDATE patient_condition SET initial_condition = LTRIM(RTRIM(REPLACE(initial_condition, CHR(13), '')));

UPDATE patient_condition SET current_condition = LTRIM(RTRIM(REPLACE(current_condition, CHR(9), '')));
UPDATE patient_condition SET current_condition = LTRIM(RTRIM(REPLACE(current_condition, CHR(10), '')));
UPDATE patient_condition SET current_condition = LTRIM(RTRIM(REPLACE(current_condition, CHR(13), '')));

UPDATE patient_details SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(9), '')));
UPDATE patient_details SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(10), '')));
UPDATE patient_details SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(13), '')));

UPDATE patient_details SET first_name = LTRIM(RTRIM(REPLACE(first_name, CHR(9), '')));
UPDATE patient_details SET first_name = LTRIM(RTRIM(REPLACE(first_name, CHR(10), '')));
UPDATE patient_details SET first_name = LTRIM(RTRIM(REPLACE(first_name, CHR(13), '')));

UPDATE patient_details SET last_name = LTRIM(RTRIM(REPLACE(last_name, CHR(9), '')));
UPDATE patient_details SET last_name = LTRIM(RTRIM(REPLACE(last_name, CHR(10), '')));
UPDATE patient_details SET last_name = LTRIM(RTRIM(REPLACE(last_name, CHR(13), '')));

UPDATE patient_details SET age = LTRIM(RTRIM(REPLACE(age, CHR(9), '')));
UPDATE patient_details SET age = LTRIM(RTRIM(REPLACE(age, CHR(10), '')));
UPDATE patient_details SET age = LTRIM(RTRIM(REPLACE(age, CHR(13), '')));

UPDATE patient_details SET gender = LTRIM(RTRIM(REPLACE(gender, CHR(9), '')));
UPDATE patient_details SET gender = LTRIM(RTRIM(REPLACE(gender, CHR(10), '')));
UPDATE patient_details SET gender = LTRIM(RTRIM(REPLACE(gender, CHR(13), '')));

UPDATE patient_details SET medicare# = LTRIM(RTRIM(REPLACE(medicare#, CHR(9), '')));
UPDATE patient_details SET medicare# = LTRIM(RTRIM(REPLACE(medicare#, CHR(10), '')));
UPDATE patient_details SET medicare# = LTRIM(RTRIM(REPLACE(medicare#, CHR(13), '')));

UPDATE patient_details SET address = LTRIM(RTRIM(REPLACE(address, CHR(9), '')));
UPDATE patient_details SET address = LTRIM(RTRIM(REPLACE(address, CHR(10), '')));
UPDATE patient_details SET address = LTRIM(RTRIM(REPLACE(address, CHR(13), '')));

UPDATE patient_details SET suburb = LTRIM(RTRIM(REPLACE(suburb, CHR(9), '')));
UPDATE patient_details SET suburb = LTRIM(RTRIM(REPLACE(suburb, CHR(10), '')));
UPDATE patient_details SET suburb = LTRIM(RTRIM(REPLACE(suburb, CHR(13), '')));

UPDATE patient_details SET state = LTRIM(RTRIM(REPLACE(state, CHR(9), '')));
UPDATE patient_details SET state = LTRIM(RTRIM(REPLACE(state, CHR(10), '')));
UPDATE patient_details SET state = LTRIM(RTRIM(REPLACE(state, CHR(13), '')));

UPDATE patient_details SET postcode = LTRIM(RTRIM(REPLACE(postcode, CHR(9), '')));
UPDATE patient_details SET postcode = LTRIM(RTRIM(REPLACE(postcode, CHR(10), '')));
UPDATE patient_details SET postcode = LTRIM(RTRIM(REPLACE(postcode, CHR(13), '')));

UPDATE patient_details SET phone# = LTRIM(RTRIM(REPLACE(phone#, CHR(9), '')));
UPDATE patient_details SET phone# = LTRIM(RTRIM(REPLACE(phone#, CHR(10), '')));
UPDATE patient_details SET phone# = LTRIM(RTRIM(REPLACE(phone#, CHR(13), '')));

UPDATE patient_details SET patient_type = LTRIM(RTRIM(REPLACE(patient_type, CHR(9), '')));
UPDATE patient_details SET patient_type = LTRIM(RTRIM(REPLACE(patient_type, CHR(10), '')));
UPDATE patient_details SET patient_type = LTRIM(RTRIM(REPLACE(patient_type, CHR(13), '')));

UPDATE patient_payment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(9), '')));
UPDATE patient_payment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(10), '')));
UPDATE patient_payment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(13), '')));

UPDATE patient_payment SET payment = LTRIM(RTRIM(REPLACE(payment, CHR(9), '')));
UPDATE patient_payment SET payment = LTRIM(RTRIM(REPLACE(payment, CHR(10), '')));
UPDATE patient_payment SET payment = LTRIM(RTRIM(REPLACE(payment, CHR(13), '')));

UPDATE patient_payment SET payment_type = LTRIM(RTRIM(REPLACE(payment_type, CHR(9), '')));
UPDATE patient_payment SET payment_type = LTRIM(RTRIM(REPLACE(payment_type, CHR(10), '')));
UPDATE patient_payment SET payment_type = LTRIM(RTRIM(REPLACE(payment_type, CHR(13), '')));

UPDATE patient_payment SET payment_date = LTRIM(RTRIM(REPLACE(payment_date, CHR(9), '')));
UPDATE patient_payment SET payment_date = LTRIM(RTRIM(REPLACE(payment_date, CHR(10), '')));
UPDATE patient_payment SET payment_date = LTRIM(RTRIM(REPLACE(payment_date, CHR(13), '')));

UPDATE patient_payment SET room_charges = LTRIM(RTRIM(REPLACE(room_charges, CHR(9), '')));
UPDATE patient_payment SET room_charges = LTRIM(RTRIM(REPLACE(room_charges, CHR(10), '')));
UPDATE patient_payment SET room_charges = LTRIM(RTRIM(REPLACE(room_charges, CHR(13), '')));

UPDATE patient_payment SET operation_charges = LTRIM(RTRIM(REPLACE(operation_charges, CHR(9), '')));
UPDATE patient_payment SET operation_charges = LTRIM(RTRIM(REPLACE(operation_charges, CHR(10), '')));
UPDATE patient_payment SET operation_charges = LTRIM(RTRIM(REPLACE(operation_charges, CHR(13), '')));

UPDATE patient_payment SET test_charges = LTRIM(RTRIM(REPLACE(test_charges, CHR(9), '')));
UPDATE patient_payment SET test_charges = LTRIM(RTRIM(REPLACE(test_charges, CHR(10), '')));
UPDATE patient_payment SET test_charges = LTRIM(RTRIM(REPLACE(test_charges, CHR(13), '')));

UPDATE patient_payment SET blood_charges = LTRIM(RTRIM(REPLACE(blood_charges, CHR(9), '')));
UPDATE patient_payment SET blood_charges = LTRIM(RTRIM(REPLACE(blood_charges, CHR(10), '')));
UPDATE patient_payment SET blood_charges = LTRIM(RTRIM(REPLACE(blood_charges, CHR(13), '')));

UPDATE patient_payment SET excess_fees = LTRIM(RTRIM(REPLACE(excess_fees, CHR(9), '')));
UPDATE patient_payment SET excess_fees = LTRIM(RTRIM(REPLACE(excess_fees, CHR(10), '')));
UPDATE patient_payment SET excess_fees = LTRIM(RTRIM(REPLACE(excess_fees, CHR(13), '')));

UPDATE patient_payment SET health_insurance = LTRIM(RTRIM(REPLACE(health_insurance, CHR(9), '')));
UPDATE patient_payment SET health_insurance = LTRIM(RTRIM(REPLACE(health_insurance, CHR(10), '')));
UPDATE patient_payment SET health_insurance = LTRIM(RTRIM(REPLACE(health_insurance, CHR(13), '')));

UPDATE patient_treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(9), '')));
UPDATE patient_treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(10), '')));
UPDATE patient_treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(13), '')));

UPDATE patient_treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE patient_treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE patient_treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE patient_treatment SET diagnosis = LTRIM(RTRIM(REPLACE(diagnosis, CHR(9), '')));
UPDATE patient_treatment SET diagnosis = LTRIM(RTRIM(REPLACE(diagnosis, CHR(10), '')));
UPDATE patient_treatment SET diagnosis = LTRIM(RTRIM(REPLACE(diagnosis, CHR(13), '')));

UPDATE patient_treatment SET treatment_type = LTRIM(RTRIM(REPLACE(treatment_type, CHR(9), '')));
UPDATE patient_treatment SET treatment_type = LTRIM(RTRIM(REPLACE(treatment_type, CHR(10), '')));
UPDATE patient_treatment SET treatment_type = LTRIM(RTRIM(REPLACE(treatment_type, CHR(13), '')));

UPDATE patient_treatment SET treatment_status = LTRIM(RTRIM(REPLACE(treatment_status, CHR(9), '')));
UPDATE patient_treatment SET treatment_status = LTRIM(RTRIM(REPLACE(treatment_status, CHR(10), '')));
UPDATE patient_treatment SET treatment_status = LTRIM(RTRIM(REPLACE(treatment_status, CHR(13), '')));

UPDATE patient_treatment SET treatment_advice = LTRIM(RTRIM(REPLACE(treatment_advice, CHR(9), '')));
UPDATE patient_treatment SET treatment_advice = LTRIM(RTRIM(REPLACE(treatment_advice, CHR(10), '')));
UPDATE patient_treatment SET treatment_advice = LTRIM(RTRIM(REPLACE(treatment_advice, CHR(13), '')));

UPDATE patient_treatment SET follow_up_appointment = LTRIM(RTRIM(REPLACE(follow_up_appointment, CHR(9), '')));
UPDATE patient_treatment SET follow_up_appointment = LTRIM(RTRIM(REPLACE(follow_up_appointment, CHR(10), '')));
UPDATE patient_treatment SET follow_up_appointment = LTRIM(RTRIM(REPLACE(follow_up_appointment, CHR(13), '')));

UPDATE patient_treatment SET follow_up_appointment# = LTRIM(RTRIM(REPLACE(follow_up_appointment#, CHR(9), '')));
UPDATE patient_treatment SET follow_up_appointment# = LTRIM(RTRIM(REPLACE(follow_up_appointment#, CHR(10), '')));
UPDATE patient_treatment SET follow_up_appointment# = LTRIM(RTRIM(REPLACE(follow_up_appointment#, CHR(13), '')));

UPDATE regular_doctors SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE regular_doctors SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE regular_doctors SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE regular_doctors SET salary = LTRIM(RTRIM(REPLACE(salary, CHR(9), '')));
UPDATE regular_doctors SET salary = LTRIM(RTRIM(REPLACE(salary, CHR(10), '')));
UPDATE regular_doctors SET salary = LTRIM(RTRIM(REPLACE(salary, CHR(13), '')));

UPDATE regular_doctors SET hire_date = LTRIM(RTRIM(REPLACE(hire_date, CHR(9), '')));
UPDATE regular_doctors SET hire_date = LTRIM(RTRIM(REPLACE(hire_date, CHR(10), '')));
UPDATE regular_doctors SET hire_date = LTRIM(RTRIM(REPLACE(hire_date, CHR(13), '')));

UPDATE regular_treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(9), '')));
UPDATE regular_treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(10), '')));
UPDATE regular_treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(13), '')));

UPDATE regular_treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE regular_treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE regular_treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE regular_treatment SET time_of_visit = LTRIM(RTRIM(REPLACE(time_of_visit, CHR(9), '')));
UPDATE regular_treatment SET time_of_visit = LTRIM(RTRIM(REPLACE(time_of_visit, CHR(10), '')));
UPDATE regular_treatment SET time_of_visit = LTRIM(RTRIM(REPLACE(time_of_visit, CHR(13), '')));

UPDATE regular_treatment SET date_of_visit = LTRIM(RTRIM(REPLACE(date_of_visit, CHR(9), '')));
UPDATE regular_treatment SET date_of_visit = LTRIM(RTRIM(REPLACE(date_of_visit, CHR(10), '')));
UPDATE regular_treatment SET date_of_visit = LTRIM(RTRIM(REPLACE(date_of_visit, CHR(13), '')));

UPDATE regular_treatment SET medicine_prescribed = LTRIM(RTRIM(REPLACE(medicine_prescribed, CHR(9), '')));
UPDATE regular_treatment SET medicine_prescribed = LTRIM(RTRIM(REPLACE(medicine_prescribed, CHR(10), '')));
UPDATE regular_treatment SET medicine_prescribed = LTRIM(RTRIM(REPLACE(medicine_prescribed, CHR(13), '')));

UPDATE regular_treatment SET operation_referral = LTRIM(RTRIM(REPLACE(operation_referral, CHR(9), '')));
UPDATE regular_treatment SET operation_referral = LTRIM(RTRIM(REPLACE(operation_referral, CHR(10), '')));
UPDATE regular_treatment SET operation_referral = LTRIM(RTRIM(REPLACE(operation_referral, CHR(13), '')));

UPDATE staff_details SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE staff_details SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE staff_details SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE staff_details SET department_id = LTRIM(RTRIM(REPLACE(department_id, CHR(9), '')));
UPDATE staff_details SET department_id = LTRIM(RTRIM(REPLACE(department_id, CHR(10), '')));
UPDATE staff_details SET department_id = LTRIM(RTRIM(REPLACE(department_id, CHR(13), '')));

UPDATE staff_details SET first_name = LTRIM(RTRIM(REPLACE(first_name, CHR(9), '')));
UPDATE staff_details SET first_name = LTRIM(RTRIM(REPLACE(first_name, CHR(10), '')));
UPDATE staff_details SET first_name = LTRIM(RTRIM(REPLACE(first_name, CHR(13), '')));

UPDATE staff_details SET last_name = LTRIM(RTRIM(REPLACE(last_name, CHR(9), '')));
UPDATE staff_details SET last_name = LTRIM(RTRIM(REPLACE(last_name, CHR(10), '')));
UPDATE staff_details SET last_name = LTRIM(RTRIM(REPLACE(last_name, CHR(13), '')));

UPDATE staff_details SET age = LTRIM(RTRIM(REPLACE(age, CHR(9), '')));
UPDATE staff_details SET age = LTRIM(RTRIM(REPLACE(age, CHR(10), '')));
UPDATE staff_details SET age = LTRIM(RTRIM(REPLACE(age, CHR(13), '')));

UPDATE staff_details SET gender = LTRIM(RTRIM(REPLACE(gender, CHR(9), '')));
UPDATE staff_details SET gender = LTRIM(RTRIM(REPLACE(gender, CHR(10), '')));
UPDATE staff_details SET gender = LTRIM(RTRIM(REPLACE(gender, CHR(13), '')));

UPDATE staff_details SET address = LTRIM(RTRIM(REPLACE(address, CHR(9), '')));
UPDATE staff_details SET address = LTRIM(RTRIM(REPLACE(address, CHR(10), '')));
UPDATE staff_details SET address = LTRIM(RTRIM(REPLACE(address, CHR(13), '')));

UPDATE staff_details SET suburb = LTRIM(RTRIM(REPLACE(suburb, CHR(9), '')));
UPDATE staff_details SET suburb = LTRIM(RTRIM(REPLACE(suburb, CHR(10), '')));
UPDATE staff_details SET suburb = LTRIM(RTRIM(REPLACE(suburb, CHR(13), '')));

UPDATE staff_details SET state = LTRIM(RTRIM(REPLACE(state, CHR(9), '')));
UPDATE staff_details SET state = LTRIM(RTRIM(REPLACE(state, CHR(10), '')));
UPDATE staff_details SET state = LTRIM(RTRIM(REPLACE(state, CHR(13), '')));

UPDATE staff_details SET postcode = LTRIM(RTRIM(REPLACE(postcode, CHR(9), '')));
UPDATE staff_details SET postcode = LTRIM(RTRIM(REPLACE(postcode, CHR(10), '')));
UPDATE staff_details SET postcode = LTRIM(RTRIM(REPLACE(postcode, CHR(13), '')));

UPDATE staff_details SET phone# = LTRIM(RTRIM(REPLACE(phone#, CHR(9), '')));
UPDATE staff_details SET phone# = LTRIM(RTRIM(REPLACE(phone#, CHR(10), '')));
UPDATE staff_details SET phone# = LTRIM(RTRIM(REPLACE(phone#, CHR(13), '')));

UPDATE staff_details SET emp_type = LTRIM(RTRIM(REPLACE(emp_type, CHR(9), '')));
UPDATE staff_details SET emp_type = LTRIM(RTRIM(REPLACE(emp_type, CHR(10), '')));
UPDATE staff_details SET emp_type = LTRIM(RTRIM(REPLACE(emp_type, CHR(13), '')));

UPDATE staff_details SET job_title = LTRIM(RTRIM(REPLACE(job_title, CHR(9), '')));
UPDATE staff_details SET job_title = LTRIM(RTRIM(REPLACE(job_title, CHR(10), '')));
UPDATE staff_details SET job_title = LTRIM(RTRIM(REPLACE(job_title, CHR(13), '')));

UPDATE staff_qualifications SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE staff_qualifications SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE staff_qualifications SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE staff_qualifications SET qualification = LTRIM(RTRIM(REPLACE(qualification, CHR(9), '')));
UPDATE staff_qualifications SET qualification = LTRIM(RTRIM(REPLACE(qualification, CHR(10), '')));
UPDATE staff_qualifications SET qualification = LTRIM(RTRIM(REPLACE(qualification, CHR(13), '')));

UPDATE staff_qualifications SET certificate# = LTRIM(RTRIM(REPLACE(certificate#, CHR(9), '')));
UPDATE staff_qualifications SET certificate# = LTRIM(RTRIM(REPLACE(certificate#, CHR(10), '')));
UPDATE staff_qualifications SET certificate# = LTRIM(RTRIM(REPLACE(certificate#, CHR(13), '')));

UPDATE staff_qualifications SET certificate_level = LTRIM(RTRIM(REPLACE(certificate_level, CHR(9), '')));
UPDATE staff_qualifications SET certificate_level = LTRIM(RTRIM(REPLACE(certificate_level, CHR(10), '')));
UPDATE staff_qualifications SET certificate_level = LTRIM(RTRIM(REPLACE(certificate_level, CHR(13), '')));

UPDATE staff_shifts SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE staff_shifts SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE staff_shifts SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE staff_shifts SET shift_start_time = LTRIM(RTRIM(REPLACE(shift_start_time, CHR(9), '')));
UPDATE staff_shifts SET shift_start_time = LTRIM(RTRIM(REPLACE(shift_start_time, CHR(10), '')));
UPDATE staff_shifts SET shift_start_time = LTRIM(RTRIM(REPLACE(shift_start_time, CHR(13), '')));

UPDATE staff_shifts SET shift_end_time = LTRIM(RTRIM(REPLACE(shift_end_time, CHR(9), '')));
UPDATE staff_shifts SET shift_end_time = LTRIM(RTRIM(REPLACE(shift_end_time, CHR(10), '')));
UPDATE staff_shifts SET shift_end_time = LTRIM(RTRIM(REPLACE(shift_end_time, CHR(13), '')));

UPDATE staff_shifts SET shift_date = LTRIM(RTRIM(REPLACE(shift_date, CHR(9), '')));
UPDATE staff_shifts SET shift_date = LTRIM(RTRIM(REPLACE(shift_date, CHR(10), '')));
UPDATE staff_shifts SET shift_date = LTRIM(RTRIM(REPLACE(shift_date, CHR(13), '')));

UPDATE staff_shifts SET hours_worked = LTRIM(RTRIM(REPLACE(hours_worked, CHR(9), '')));
UPDATE staff_shifts SET hours_worked = LTRIM(RTRIM(REPLACE(hours_worked, CHR(10), '')));
UPDATE staff_shifts SET hours_worked = LTRIM(RTRIM(REPLACE(hours_worked, CHR(13), '')));

UPDATE treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(9), '')));
UPDATE treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(10), '')));
UPDATE treatment SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(13), '')));

UPDATE treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE treatment SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE treatment SET room# = LTRIM(RTRIM(REPLACE(room#, CHR(9), '')));
UPDATE treatment SET room# = LTRIM(RTRIM(REPLACE(room#, CHR(10), '')));
UPDATE treatment SET room# = LTRIM(RTRIM(REPLACE(room#, CHR(13), '')));

UPDATE treatment SET appointment# = LTRIM(RTRIM(REPLACE(appointment#, CHR(9), '')));
UPDATE treatment SET appointment# = LTRIM(RTRIM(REPLACE(appointment#, CHR(10), '')));
UPDATE treatment SET appointment# = LTRIM(RTRIM(REPLACE(appointment#, CHR(13), '')));

UPDATE treatment_appointments SET appointment# = LTRIM(RTRIM(REPLACE(appointment#, CHR(9), '')));
UPDATE treatment_appointments SET appointment# = LTRIM(RTRIM(REPLACE(appointment#, CHR(10), '')));
UPDATE treatment_appointments SET appointment# = LTRIM(RTRIM(REPLACE(appointment#, CHR(13), '')));

UPDATE treatment_appointments SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(9), '')));
UPDATE treatment_appointments SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(10), '')));
UPDATE treatment_appointments SET patient_id = LTRIM(RTRIM(REPLACE(patient_id, CHR(13), '')));

UPDATE treatment_appointments SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(9), '')));
UPDATE treatment_appointments SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(10), '')));
UPDATE treatment_appointments SET emp_id = LTRIM(RTRIM(REPLACE(emp_id, CHR(13), '')));

UPDATE treatment_appointments SET appointment_time = LTRIM(RTRIM(REPLACE(appointment_time, CHR(9), '')));
UPDATE treatment_appointments SET appointment_time = LTRIM(RTRIM(REPLACE(appointment_time, CHR(10), '')));
UPDATE treatment_appointments SET appointment_time = LTRIM(RTRIM(REPLACE(appointment_time, CHR(13), '')));

UPDATE treatment_appointments SET appointment_type = LTRIM(RTRIM(REPLACE(appointment_type, CHR(9), '')));
UPDATE treatment_appointments SET appointment_type = LTRIM(RTRIM(REPLACE(appointment_type, CHR(10), '')));
UPDATE treatment_appointments SET appointment_type = LTRIM(RTRIM(REPLACE(appointment_type, CHR(13), '')));

UPDATE treatment_appointments SET appointment_date = LTRIM(RTRIM(REPLACE(appointment_date, CHR(9), '')));
UPDATE treatment_appointments SET appointment_date = LTRIM(RTRIM(REPLACE(appointment_date, CHR(10), '')));
UPDATE treatment_appointments SET appointment_date = LTRIM(RTRIM(REPLACE(appointment_date, CHR(13), '')));

UPDATE ward SET room# = LTRIM(RTRIM(REPLACE(room#, CHR(9), '')));
UPDATE ward SET room# = LTRIM(RTRIM(REPLACE(room#, CHR(10), '')));
UPDATE ward SET room# = LTRIM(RTRIM(REPLACE(room#, CHR(13), '')));

UPDATE ward SET no_of_beds = LTRIM(RTRIM(REPLACE(no_of_beds, CHR(9), '')));
UPDATE ward SET no_of_beds = LTRIM(RTRIM(REPLACE(no_of_beds, CHR(10), '')));
UPDATE ward SET no_of_beds = LTRIM(RTRIM(REPLACE(no_of_beds, CHR(13), '')));

UPDATE ward SET charges_per_day = LTRIM(RTRIM(REPLACE(charges_per_day, CHR(9), '')));
UPDATE ward SET charges_per_day = LTRIM(RTRIM(REPLACE(charges_per_day, CHR(10), '')));
UPDATE ward SET charges_per_day = LTRIM(RTRIM(REPLACE(charges_per_day, CHR(13), '')));

ALTER TABLE ward
ADD CONSTRAINT ward_no_of_beds_ck CHECK(no_of_beds IN ('1','2','3'));

ALTER TABLE Patient_Details
ADD (CONSTRAINT patient_details_patient_id_ck CHECK(patient_id LIKE 'PT%'),
CONSTRAINT patient_details_gender_ck CHECK(gender IN('M','F')),
CONSTRAINT patient_details_state_ck CHECK(state IN('NSW','VIC','QLD','WA','NT','ACT','SA','TAS')),
CONSTRAINT patient_details_patient_type CHECK(patient_type IN('inpatient','outpatient')));

ALTER TABLE Patient_Payment
ADD (CONSTRAINT patient_payment_patient_id_ck CHECK(patient_id LIKE 'PT%'),
CONSTRAINT patient_payment_payment_type_ck CHECK(payment_type IN('EFTPOS','Cash','Cheque')),
CONSTRAINT patient_payment_health_insurance_ck CHECK(health_insurance IN('No','Basic','Premium')),
CONSTRAINT patient_payment_excess_fees CHECK(excess_fees IN('0','250','500')));

ALTER TABLE Patient_Condition
ADD (CONSTRAINT patient_condition_patient_id_ck CHECK(patient_id LIKE 'PT%'),
CONSTRAINT patient_condition_initial_condition_ck CHECK(initial_condition IN('good','fair','serious','critical')),
CONSTRAINT patient_condition_current_condition_ck CHECK(current_condition IN('good','fair','serious','critical')));

ALTER TABLE treatment_appointments
ADD (CONSTRAINT treatment_appointments_patient_id_ck CHECK(patient_id LIKE 'PT%'),
CONSTRAINT treatment_appointments_appointment_type_ck CHECK(appointment_type IN('Regular','Operational')));

ALTER TABLE treatment
ADD CONSTRAINT treatment_patient_id_ck CHECK(patient_id LIKE 'PT%');

ALTER TABLE patient_treatment
ADD (CONSTRAINT patient_treatment_patient_id_ck CHECK(patient_id LIKE 'PT%'),
CONSTRAINT patient_treatment_treatment_type_ck CHECK(treatment_type IN('Operational','Regular')));

ALTER TABLE regular_treatment
ADD (CONSTRAINT regular_treatment_patient_id_ck CHECK(patient_id LIKE 'PT%'),
CONSTRAINT regular_treatment_operation_referral_ck CHECK(operation_referral IN('Y','N')));

ALTER TABLE operational_treatment
ADD (CONSTRAINT operational_treatment_patient_id_ck CHECK(patient_id LIKE 'PT%'),
CONSTRAINT operational_treatment_admission_date_ck CHECK(admission_date <= operation_date AND operation_date <= discharge_date));

ALTER TABLE Staff_Details
ADD (CONSTRAINT staff_details_gender_ck CHECK(gender IN('M','F')),
CONSTRAINT staff_details_state_ck CHECK(state IN('NSW','VIC','QLD','ACT','NT','SA','WA','TAS')));