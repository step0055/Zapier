/*
Created: 8/1/2017
Modified: 8/4/2017
Model: PostgreSQL 9.5
Database: PostgreSQL 9.5
*/


-- Create tables section -------------------------------------------------

-- Table Dim_User

CREATE TABLE "Dim_User"(
 "User_ID" Bigint NOT NULL,
 "Date_DT" Date NOT NULL,
 "User_Last_Name_TXT" Varchar,
 "User_Email_Address_1_TXT" Varchar NOT NULL,
 "User_Email_Address_2_TXT" Varchar,
 "User_Current_Password_TXT" Varchar NOT NULL,
 "User_Current_Password_Reminder_TXT" Varchar NOT NULL,
 "User_Created_DTS" Timestamp with time zone NOT NULL,
 "Last_Modified_DTS" Timestamp with time zone
)
;

-- Add keys for table Dim_User

ALTER TABLE "Dim_User" ADD CONSTRAINT "Key1" PRIMARY KEY ("User_ID")
;

-- Table Dim_Date

CREATE TABLE "Dim_Date"(
 "Date_DT" Date NOT NULL,
 "Date_Day_of_Month_NBR" Integer NOT NULL,
 "Date_Month_of_Year_NBR" Integer NOT NULL,
 "Date_Year_NBR" Integer NOT NULL,
 "Date_Quarter_NBR" Integer NOT NULL,
 "Date_End_Active_Range_DT" Date NOT NULL,
 "Date_Begin_Churn_Range_DT" Date NOT NULL,
 "Date_End_Churn_Range_DT" Date NOT NULL,
 "Date_Day_of_Week_NBR" Integer NOT NULL
)
;
COMMENT ON COLUMN "Dim_Date"."Date_Month_of_Year_NBR" IS 'Month Number'
;

-- Add keys for table Dim_Date

ALTER TABLE "Dim_Date" ADD CONSTRAINT "Key3" PRIMARY KEY ("Date_DT")
;

-- Table Fact_Task_Counts

CREATE TABLE "Fact_Task_Counts"(
 "Task_ID_Created" Bigint NOT NULL,
 "Date_DT" Date NOT NULL,
 "User_ID" Bigint NOT NULL,
 "Account_ID" Bigint NOT NULL,
 "Tasks_Used_NBR" Integer NOT NULL,
 "Task_Counts_Created_DTS" Timestamp with time zone NOT NULL
)
;
COMMENT ON COLUMN "Fact_Task_Counts"."Task_ID_Created" IS 'This is a unique Key created for each row of on Fact_Tasks. '
;
COMMENT ON COLUMN "Fact_Task_Counts"."Tasks_Used_NBR" IS 'Number of tasks used by this user on this account on this date.'
;

-- Create indexes for table Fact_Task_Counts

CREATE INDEX "IX_Relationship2" ON "Fact_Task_Counts" ("Account_ID")
;

CREATE INDEX "IX_Relationship16" ON "Fact_Task_Counts" ("User_ID")
;

CREATE INDEX "IX_Relationship2" ON "Fact_Task_Counts" ("Date_DT")
;

-- Add keys for table Fact_Task_Counts

ALTER TABLE "Fact_Task_Counts" ADD CONSTRAINT "Key4" PRIMARY KEY ("Task_ID_Created")
;

ALTER TABLE "Fact_Task_Counts" ADD CONSTRAINT "Task_ID_Created" UNIQUE ("Task_ID_Created")
;

-- Table Dim_Account

CREATE TABLE "Dim_Account"(
 "Account_ID" Bigint NOT NULL,
 "Type_ID" Integer NOT NULL,
 "Account_Name_TXT" Varchar NOT NULL,
 "Account_Address1_TXT" Varchar NOT NULL,
 "Account_Address2_TXT" Varchar,
 "Account_State_District_TXT" Varchar NOT NULL,
 "Account_Postal_Code_TXT" Varchar NOT NULL,
 "Account_Main_Contact_User_ID" Integer NOT NULL,
 "Account_CreatedDTS" Timestamp with time zone NOT NULL
)
;

-- Create indexes for table Dim_Account

CREATE INDEX "IX_Relationship18" ON "Dim_Account" ("Type_ID")
;

-- Add keys for table Dim_Account

ALTER TABLE "Dim_Account" ADD CONSTRAINT "Key5" PRIMARY KEY ("Account_ID")
;

ALTER TABLE "Dim_Account" ADD CONSTRAINT "Account_ID" UNIQUE ("Account_ID")
;

-- Table Dim_Type

CREATE TABLE "Dim_Type"(
 "Type_ID" Integer NOT NULL,
 "Type_Name_TXT" Varchar NOT NULL,
 "Type_Description_TXT" Text NOT NULL,
 "Type_Created_DTS" Timestamp with time zone NOT NULL,
 "Type_Group_TXT" Varchar NOT NULL
)
;

-- Add keys for table Dim_Type

ALTER TABLE "Dim_Type" ADD CONSTRAINT "Key6" PRIMARY KEY ("Type_ID")
;

ALTER TABLE "Dim_Type" ADD CONSTRAINT "Type_ID" UNIQUE ("Type_ID")
;

-- Table Fact_User_History

CREATE TABLE "Fact_User_History"(
 "User_ID" Bigint NOT NULL,
 "Date_DT" Date NOT NULL,
 "Type_ID" Integer,
 "EndTypeDate" Date,
 "User_ID" Bigint
)
;
COMMENT ON COLUMN "Fact_User_History"."Type_ID" IS 'Date the user became one of these: 
Active User, Churn User, Inactive User '
;
COMMENT ON COLUMN "Fact_User_History"."EndTypeDate" IS 'When the user moves from one type to the next, this field is populated and a row is created with their new type.'
;

-- Create indexes for table Fact_User_History

CREATE INDEX "IX_Relationship2" ON "Fact_User_History" ("Type_ID")
;

CREATE INDEX "IX_Relationship3" ON "Fact_User_History" ("User_ID")
;

-- Add keys for table Fact_User_History

ALTER TABLE "Fact_User_History" ADD CONSTRAINT "Key7" PRIMARY KEY ("User_ID","Date_DT")
;
-- Create relationships section ------------------------------------------------- 

ALTER TABLE "Fact_Task_Counts" ADD CONSTRAINT "Account_ID" FOREIGN KEY ("Account_ID") REFERENCES "Dim_Account" ("Account_ID") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "Fact_Task_Counts" ADD CONSTRAINT "User_ID" FOREIGN KEY ("User_ID") REFERENCES "Dim_User" ("User_ID") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "Dim_Account" ADD CONSTRAINT "Type_ID_Account" FOREIGN KEY ("Type_ID") REFERENCES "Dim_Type" ("Type_ID") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "Fact_Task_Counts" ADD CONSTRAINT "Date_Fact_Task_Instance" FOREIGN KEY ("Date_DT") REFERENCES "Dim_Date" ("Date_DT") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "Fact_User_History" ADD CONSTRAINT "UserHistoryType" FOREIGN KEY ("Type_ID") REFERENCES "Dim_Type" ("Type_ID") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "Fact_User_History" ADD CONSTRAINT "User_History" FOREIGN KEY ("User_ID") REFERENCES "Dim_User" ("User_ID") ON DELETE NO ACTION ON UPDATE NO ACTION
;




