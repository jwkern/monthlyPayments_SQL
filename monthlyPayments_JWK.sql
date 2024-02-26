/*______________________________________________________________________________
CODE DESCRIPTION: 

This SQL code (monthlyPaymentAPR_JWK.sql) calculates the monthly payments for people 
who have debt. The data for these people are stored in a separate database from the 
list of data on debt. The code uses joins to combine the data, and then calculates
the appropriate metrics. 

NEEDS UPDATED: Script is hard coded for loan length of 5 years. This is not practical. 

Written by: Joshua W. Kern
Date: 02/23/24                                                                  
________________________________________________________________________________*/

/*______________________________________________________________________________
Step 0: Initialize the database
________________________________________________________________________________*/
DROP DATABASE IF EXISTS Misc;
CREATE DATABASE Misc;
USE Misc;



/*______________________________________________________________________________
Step 1: Initialize the data tables
________________________________________________________________________________*/
CREATE TABLE peopleInfo (
	gender TEXT,
	title TEXT,
	first_name TEXT,
	last_name TEXT,
	birth_date DATE,
	social_security_number VARCHAR(11),
	street_address TEXT,
	secondary_address TEXT,	
	post_code TEXT,
	city TEXT,
	state TEXT,
	latitude TEXT,	
	longitude TEXT,	
	phone_number TEXT,	
	email TEXT,	
	credit_card_type TEXT,
	credit_card_number TEXT,
	credit_card_expiration_date TEXT,
	iban TEXT,
	bank_account_number TEXT,
	swift_bic_number TEXT,
	company TEXT,
	job_title TEXT,
	PRIMARY KEY (social_security_number)
);


CREATE TABLE debtInfo (
        social_security_number VARCHAR(11),
        bank_account_number TEXT,
        debt FLOAT,
        apr_rate FLOAT,
        loanLength FLOAT,
        PRIMARY KEY (social_security_number)
);

/*______________________________________________________________________________
Step 2: Load the data into the tables
________________________________________________________________________________*/
LOAD DATA LOCAL INFILE '/home/jwkern/Downloads/Misc/people_data.csv' REPLACE INTO TABLE peopleInfo FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 rows;
LOAD DATA LOCAL INFILE '/home/jwkern/Downloads/Misc/debt_data.csv' REPLACE INTO TABLE debtInfo FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 rows;




/*______________________________________________________________________________
Step 3: Select subset of data and calculate properties
_______________________________________________________________________________*/
CREATE TABLE personalDebtTable AS SELECT peopleInfo.first_name, 
					peopleInfo.last_name, 
					peopleInfo.birth_date, 
					peopleInfo.phone_number, 
					peopleInfo.email, 
					peopleInfo.street_address, 
					peopleInfo.city, 
					peopleInfo.state, 
					peopleInfo.credit_card_type, 
					peopleInfo.credit_card_number, 
					peopleInfo.credit_card_expiration_date, 
					debtInfo.social_security_number, 
					debtInfo.bank_account_number, 
					debtInfo.debt, 
					debtInfo.apr_rate, 
					debtInfo.loanLength/*,
					debtInfo.apr_rate*debtInfo.debt/100.0 AS yearlyInterest_01,
                                        debtInfo.debt/debtInfo.loanLength AS yearlyPrincipalPayment,
                                        debtInfo.debt*(1 - 1/debtInfo.loanLength) AS debtYear02,
                                        debtInfo.apr_rate*debtInfo.debt*(1 - 1/debtInfo.loanLength)/100.0 AS yearlyInterest_02,
                                        debtInfo.debt*(1 - 2/debtInfo.loanLength) AS debtYear03,
                                        debtInfo.apr_rate*debtInfo.debt*(1 - 2/debtInfo.loanLength)/100.0 AS yearlyInterest_03,
                                        debtInfo.debt*(1 - 3/debtInfo.loanLength) AS debtYear04,
                                        debtInfo.apr_rate*debtInfo.debt*(1 - 3/debtInfo.loanLength)/100.0 AS yearlyInterest_04,
                                        debtInfo.debt*(1 - 4/debtInfo.loanLength) AS debtYear05,
                                        debtInfo.apr_rate*debtInfo.debt*(1 - 4/debtInfo.loanLength)/100.0 AS yearlyInterest_05,
                                        debtInfo.debt*(1 + debtInfo.apr_rate(4 - 10/debtInfo.loanLength)/100.0)/(5*12) AS monthlyPayments*/
FROM peopleInfo
RIGHT JOIN debtInfo
ON peopleInfo.social_security_number = debtInfo.social_security_number;

CREATE TABLE monthlyPaymentsTable AS SELECT apr_rate*debt AS yearlyInterest_01,
					debt/loanLength AS yearlyPrincipalPayment,
					debt*(1-1/loanLength) as debtYear_02,
					apr_rate*debt*(1-1/loanLength) AS yearlyInterest_02,
					debt*(1 - 2/loanLength) AS debtYear03,
                                        apr_rate*debt*(1 - 2/loanLength)/100.0 AS yearlyInterest_03,
                                        debt*(1 - 3/loanLength) AS debtYear04,
                                        apr_rate*debt*(1 - 3/loanLength)/100.0 AS yearlyInterest_04,
                                        debt*(1 - 4/loanLength) AS debtYear05,
                                        apr_rate*debt*(1 - 4/loanLength)/100.0 AS yearlyInterest_05,
                                        debt*(1 + apr_rate*(4 - 10/loanLength)/100.0)/(5*12) AS monthlyPayments
FROM personalDebtTable;

SELECT ROUND(monthlyPayments,2) FROM monthlyPaymentsTable;


/*______________________________________________________________________________
________________________________________________________________________________

--------------------------------------------------------------------------------
-----------------------------------THE END--------------------------------------
--------------------------------------------------------------------------------
________________________________________________________________________________
________________________________________________________________________________*/

