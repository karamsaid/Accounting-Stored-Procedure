USE H_Accounting;
-- A stored procedure, or a stored routine, is like a function in other programming languages
-- We write the code once, and the code can de reused over and over again
-- We can pass on arguments into the stored procedure. i.e. we can give a specific 
-- input to a store procedure
-- For example we could determine the specific for which we want to produce the 
-- profit and loss statement

############

# When running this procedure, a prompt will come up and the user needs to input 
# a specific year where he wants to see the financial statements. Atfer choosing the year,
# a Balance sheet and a Profit and Loss statement will show up for that exact year, and aslo 
# the percentage variation compared to the previous year.

###############
DROP PROCEDURE IF EXISTS H_Accounting.mechazarracasado2020_sp;
-- The tpycal delimiter for Stored procedures is a double dollar sign
DELIMITER $$

CREATE PROCEDURE H_Accounting.mechazarracasado2020_sp(varCalendarYear SMALLINT)
BEGIN
  
	-- We receive as an argument the year for which we will calculate the revenues
    -- This value is stored as an 'YEAR' type in the variable `varCalendarYear`
    -- To avoid confusion among which are fields from a table vs. which are the variables
    -- A good practice is to adopt a naming convention for all variables
    -- In these lines of code we are naming prefixing every variable as "var"
  
	-- We can define variables inside of our procedure
	DECLARE varTotalRevenues DOUBLE DEFAULT 0;
    DECLARE varTotalRevenuesM1 DOUBLE DEFAULT 0;
    DECLARE varTotalCOGS DOUBLE DEFAULT 0;
    DECLARE varTotalCOGSM1 DOUBLE DEFAULT 0;
    DECLARE varTotalSEXP DOUBLE DEFAULT 0;
    DECLARE varTotalOEXPM1 DOUBLE DEFAULT 0;
    DECLARE varTotalSEXPM1 DOUBLE DEFAULT 0;
        DECLARE varTotalOEXP DOUBLE DEFAULT 0;
    DECLARE varTotalINCTAX DOUBLE DEFAULT 0;
	DECLARE varTotalOI DOUBLE DEFAULT 0;
    DECLARE varTotalOTHTAX DOUBLE DEFAULT 0;
     DECLARE varTotalINCTAXM1 DOUBLE DEFAULT 0;
	DECLARE varTotalOIM1 DOUBLE DEFAULT 0;
    DECLARE varTotalOTHTAXM1 DOUBLE DEFAULT 0;
	DECLARE varCurrentAssets DOUBLE DEFAULT 0;
    DECLARE varFixedAssets DOUBLE DEFAULT 0;
	DECLARE varDeferredAssets DOUBLE DEFAULT 0;
    DECLARE varCurrentLiabilities DOUBLE DEFAULT 0;
    DECLARE varLong_TermLiabilities DOUBLE DEFAULT 0;
	DECLARE varDeferredLiabilities DOUBLE DEFAULT 0;
    DECLARE varEquity DOUBLE DEFAULT 0;
    DECLARE varCurrentAssetsM1 DOUBLE DEFAULT 0;
    DECLARE varFixedAssetsM1 DOUBLE DEFAULT 0;
	DECLARE varDeferredAssetsM1 DOUBLE DEFAULT 0;
    DECLARE varCurrentLiabilitiesM1 DOUBLE DEFAULT 0;
    DECLARE varLong_TermLiabilitiesM1 DOUBLE DEFAULT 0;
	DECLARE varDeferredLiabilitiesM1 DOUBLE DEFAULT 0;
    DECLARE varEquityM1 DOUBLE DEFAULT 0;
	--  We calculate the value of the sales for the given year and we store it into the variable we just declared
	SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalRevenues
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "REV"
        AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear
	;
    
    
	
    
    SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalCOGS
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "COGS"
		AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear
        
 
	;
    SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalSEXP
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "SEXP"
         AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = (varCalendarYear)
	;
    
    SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalSEXP
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "OEXP"
         AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear
	;
    
     SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalINCTAX
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "INCTAX"
         AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear
	;
    
     SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalOI
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "OI"
         AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear
	;
    
    SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalOTHTAX
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "OTHTAX"
         AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear
	;
 
############################# 
 SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalRevenuesM1
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "REV"
        AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear-1
	;
    
    
	
    
    SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalCOGSM1
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "COGS"
		AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear-1
        
 
	;
    SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalSEXPM1
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "SEXP"
         AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = (varCalendarYear-1)
	;
    
    SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalSEXPM1
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "OEXP"
         AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear-1
	;
    
     SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalINCTAXM1
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "INCTAX"
         AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear-1
	;
    
     SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalOIM1
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "OI"
         AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear-1
	;
    
    SELECT IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varTotalOTHTAXM1
		FROM H_Accounting.journal_entry_line_item AS jeli
		INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = jeli.account_id
		INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = jeli.journal_entry_id
		INNER JOIN H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
      
		WHERE ss.statement_section_code = "OTHTAX"
         AND je.closing_type = 0
        AND ac.profit_loss_section_id <> 0
		AND YEAR(je.entry_date) = varCalendarYear-1
	;
 ###################
 
 
 SELECT  IFNULL(SUM(COALESCE(debit, 0)) - SUM(COALESCE(credit, 0)),1)   INTO varCurrentAssets
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 61 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear;
       
	
    SELECT  IFNULL(SUM(COALESCE(debit, 0)) - SUM(COALESCE(credit, 0)),1)INTO varFixedAssets
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 62 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear;
        
	SELECT  IFNULL(SUM(COALESCE(debit, 0)) - SUM(COALESCE(credit, 0)),1) INTO varDeferredAssets
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 63 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear;
        
        	SELECT  IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1)  INTO varCurrentLiabilities
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 64 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear;
        
	SELECT  IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varLong_TermLiabilities
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 65 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear;
        
		SELECT  IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO  varDeferredLiabilities
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 66 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear;
        
        		SELECT  IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varEquity
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 67 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear;
        
########################
SELECT  IFNULL(SUM(COALESCE(debit, 0)) - SUM(COALESCE(credit, 0)),1)   INTO varCurrentAssetsM1
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 61 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear-1;
       
	
    SELECT  IFNULL(SUM(COALESCE(debit, 0)) - SUM(COALESCE(credit, 0)),1)INTO varFixedAssetsM1
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 62 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear-1;
        
	SELECT  IFNULL(SUM(COALESCE(debit, 0)) - SUM(COALESCE(credit, 0)),1) INTO varDeferredAssetsM1
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 63 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear-1;
        
        	SELECT  IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1)  INTO varCurrentLiabilitiesM1
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 64 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear-1;
        
	SELECT  IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varLong_TermLiabilitiesM1
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 65 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear-1;
        
		SELECT  IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO  varDeferredLiabilitiesM1
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 66 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear-1;
        
        		SELECT  IFNULL(SUM(COALESCE(credit, 0)) - SUM(COALESCE(debit, 0)),1) INTO varEquityM1
FROM H_Accounting.journal_entry AS je
INNER JOIN H_Accounting.journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN H_Accounting.journal_type AS jt ON je.journal_type_id = jt.journal_type_id
INNER JOIN H_Accounting.account as a ON jeli.account_id = a.account_id
INNER JOIN H_Accounting.statement_section as ss ON a.balance_sheet_section_id = ss.statement_section_id
WHERE ss.statement_section_id = 67 AND cancelled = 0 AND audited = 0
		AND YEAR(je.entry_date) = varCalendarYear-1;
        



##########################
    -- Let's drop the `tmp` table where we will input the revenue
	-- The IF EXISTS is important. Because if the table does not exist the DROP alone would fail
	-- A store procedure will stop running whenever it faces an error. 
	DROP TABLE IF EXISTS H_Accounting.mechazarracasado2020_tmp;
  
	-- Now we are certain that the table does not exist, we create with the columns that we need
	CREATE TABLE H_Accounting.mechazarracasado2020_tmp
		(line_number INT, 
		 label VARCHAR(50), 
	     amount VARCHAR(50),
         total VARCHAR(50),
         PerChenge VARCHAR(50)
		);
  
  -- Now we insert the a header for the report
  INSERT INTO H_Accounting.mechazarracasado2020_tmp 
		   (line_number, label, amount , total, PerChenge)
	VALUES (1, 'PROFIT AND LOSS STATEMENT', "In '000s of USD","In '000s of USD" ,'%');
  
	-- Next we insert an empty line to create some space between the header and the line items
	INSERT INTO H_Accounting.mechazarracasado2020_tmp
				(line_number, label, amount , total, PerChenge)
		VALUES 	(2, 'Year', varCalendarYear,varCalendarYear-1,'');
	
    
	-- Finally we insert the Total Revenues with its value
	INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(3, 'Total Revenues', format(varTotalRevenues / 1000, 2),format(varTotalRevenuesM1 / 1000, 2),format((((((varTotalRevenues)-(varTotalRevenuesM1))/(varTotalRevenuesM1+1) )*100)),2));
    
    INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(4, 'COGS', format(varTotalCOGS / 1000, 2),format(varTotalCOGSM1 / 1000, 2),format((((((varTotalCOGS)-(varTotalCOGSM1))/(varTotalCOGSM1+1) )*100)),2));
    
    INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(5, 'Gross Profit', format((varTotalCOGS + varTotalRevenues) / 1000, 2),format((varTotalCOGSM1 + varTotalRevenuesM1) / 1000, 2),Format(((((varTotalCOGS + varTotalRevenues)-(varTotalCOGSM1 + varTotalRevenuesM1) )/(varTotalCOGSM1 + varTotalRevenuesM1+1) )*100),2));
    	
	INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(6, '', '','','');
    
    INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(7, 'Selling Expenses', format(varTotalSEXP / 1000, 2),format(varTotalSEXPM1 / 1000, 2),format((((varTotalSEXP-varTotalSEXPM1)/(varTotalSEXPM1+1))*100),2));
    
       INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(8, 'Other Expenses', format(varTotalOEXP / 1000, 2),format(varTotalOEXPM1 / 1000, 2),format((((varTotalOEXP-varTotalOEXPM1)/(varTotalOEXPM1+1))*100),2));
    
    INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(9, '', '','','');
    
    INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(10, 'Other Income', format(varTotalOI / 1000, 2),format(varTotalOIM1 / 1000, 2),format((((varTotalOI-varTotalOIM1)/(varTotalOIM1+1))*100),2));
    
     INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(11, '', '','','');
    
	INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(12, 'Income Tax', format(varTotalINCTAX / 1000, 2),format(varTotalINCTAXM1 / 1000, 2),format((((varTotalINCTAX-varTotalINCTAXM1)/(varTotalINCTAXM1+1))*100),2));
    
    INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(13, 'Other Taxes', format(varTotalOTHTAX / 1000, 2),format(varTotalOTHTAXM1 / 1000, 2),format((((varTotalOTHTAX-varTotalOTHTAXM1 )/(varTotalOTHTAXM1+1) )*100),2));
    
     INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(14, '', '','','');
    
    INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(15, 'Net Income', format((varTotalCOGS + varTotalRevenues+varTotalSEXP+varTotalOEXP+varTotalOI+varTotalINCTAX+varTotalOTHTAX )/ 1000, 2),format((varTotalCOGSM1 + varTotalRevenuesM1+varTotalSEXPM1+varTotalOEXPM1+varTotalOIM1+varTotalINCTAXM1+varTotalOTHTAXM1)/ 1000, 2),format(((((varTotalCOGS + varTotalRevenues+varTotalSEXP+varTotalOEXP+varTotalOI+varTotalINCTAX+varTotalOTHTAX) -(varTotalCOGSM1 + varTotalRevenuesM1+varTotalSEXPM1+varTotalOEXPM1+varTotalOIM1+varTotalINCTAXM1+varTotalOTHTAXM1))/(varTotalCOGSM1 + varTotalRevenuesM1+varTotalSEXPM1+varTotalOEXPM1+varTotalOIM1+varTotalINCTAXM1+varTotalOTHTAXM1))*100),2));
    
    	INSERT INTO H_Accounting.mechazarracasado2020_tmp
				(line_number, label, amount , total, PerChenge)
		VALUES 	(2, '', '','','');
    
    INSERT INTO H_Accounting.mechazarracasado2020_tmp
		   (line_number, label, amount , total, PerChenge)
	VALUES (1, 'BALANCE SHEET', "In '000s of USD","In '000s of USD",'%');
  
	-- Next we insert an empty line to create some space between the header and the line items
	INSERT INTO H_Accounting.mechazarracasado2020_tmp
				(line_number, label, amount , total, PerChenge)
		VALUES 	(2, '', '','','');
        
        	INSERT INTO H_Accounting.mechazarracasado2020_tmp
				(line_number, label, amount , total, PerChenge)
		VALUES 	(2, 'Year', varCalendarYear,varCalendarYear-1,'');
    
	-- Finally we insert the Total Revenues with its value
	INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(3, 'Current Assets', format(varCurrentAssets / 1000, 2),format(varCurrentAssetsM1 / 1000, 2),format(((((varCurrentAssets)-(varCurrentAssetsM1))/(varCurrentAssetsM1+1))*100),2));
    
    	INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(3, 'Fixed Assets', format(varFixedAssets / 1000, 2),format(varFixedAssetsM1 / 1000, 2),format(((((varFixedAssets)-(varFixedAssetsM1))/(varFixedAssetsM1+1))*100),2));
    
    	INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(3, 'Deferred Assets', format(varDeferredAssets / 1000, 2),format(varDeferredAssetsM1 / 1000, 2),format(((((varDeferredAssets)-(varDeferredAssetsM1))/(varDeferredAssetsM1+1))*100),2));
    
    	INSERT INTO H_Accounting.mechazarracasado2020_tmp
				(line_number, label, amount , total, PerChenge)
		VALUES 	(2, '', '','','');
    
       	INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(3, 'Current Liabilities', format(varLong_TermLiabilities / 1000, 2),format(varLong_TermLiabilitiesM1 / 1000, 2),format(((((varLong_TermLiabilities)-(varLong_TermLiabilitiesM1))/(varLong_TermLiabilitiesM1+1))*100),2));
    
    	INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(3, 'Long-Term Liabilities', format(varCurrentLiabilities / 1000, 2),format(varCurrentLiabilitiesM1 / 1000, 2),format(((((varCurrentLiabilities)-(varCurrentLiabilitiesM1))/(varCurrentLiabilitiesM1+1))*100),2));
    
        	INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(3, 'Deferred Liabilities', format(varDeferredLiabilities / 1000, 2),format(varDeferredLiabilitiesM1 / 1000, 2),format(((((varDeferredLiabilities)-(varDeferredLiabilitiesM1))/(varDeferredLiabilitiesM1+1))*100),2));
    
    INSERT INTO H_Accounting.mechazarracasado2020_tmp
				(line_number, label, amount , total, PerChenge)
		VALUES 	(2, '', '','','');
        
        INSERT INTO H_Accounting.mechazarracasado2020_tmp
			(line_number, label, amount , total, PerChenge)
	VALUES 	(3, 'Equity', format(varEquity / 1000, 2),format(varEquityM1 / 1000, 2),format(((((varEquity)-(varEquityM1))/(varEquityM1+1))*100),2));
    
END $$
DELIMITER ;
# THE LINE ABOVES CHANGES BACK OUR DELIMETER TO OUR USUAL ;

CALL H_Accounting.mechazarracasado2020_sp(2018);

SELECT * FROM H_Accounting.mechazarracasado2020_tmp;