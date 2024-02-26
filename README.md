___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
# monthlyPayments_SQL

___________________________________________________________________________________________________________________________________________________________________
GENERAL DESCRIPTION:
This SQL script has a master data base of contact information for customers which is joined with a data base of customers who have financial loans. The script then calculates the monthly payment of these loans for each customer. Currently, hard coded for loan length of 5 years. Needs updating. 

___________________________________________________________________________________________________________________________________________________________________
DATA DESCRIPTION:
In this example, the demographic data being used has been generated from the online source https://generate-random.org/person-identity-generator. 

An example schema of each persons information is given below: 

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



___________________________________________________________________________________________________________________________________________________________________
CODE DESCRIPTION:
This SQL code (monthlyPayments.sql) imports the data (people_data.csv, debt_data.csv), and uses a join statement to extract the contact info for the people listed to have debt. Once the tables are joined, the APR, total debt, and an assumed loan length of 5 years is used to calculate an updated monthly payment which could then be communicated to the customers.



___________________________________________________________________________________________________________________________________________________________________
RUNNING THE CODE:
1) Download the data (people_data.csv and debt_data.csv) and the SQL script (monthlyPayments_JWK.sql)

2) In a terminal, cd into the directory that now contains the data and the script

3) In monthlyPayments.sql, change the file path on lines 65 and 66 from "/home/jwkern/Downloads/" to point to your local directory containing people_data.csv and debt_data.csv

4) Run the script by typing the following into the command line:

            mysql --local-infile=1 -u username -p password < monthlyPayments_JWK.sql

(P.S. don't forget to change the username and password to your mySQL credentials)

4.1) If you wish to save the output in a .txt file, instead run the script as:
      
            mysql --local-infile=1 -u username -p password < monthlyPayments_JWK.sql > output.txt


___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
