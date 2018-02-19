
-- ==============================================================
-- Author:			Jordi Rambla, Francisco Gonzalez, Javier Torrenteras
-- Creation date:	v2 019/08/2008
-- Description:		Script para generación tabla dias
-- Update 25/07/2011 - adicionado Portugues-BR
-- ==============================================================


Use tempdb	/* Change that for the desired DB */
GO 

--Variable declaration
DECLARE @StartingDate datetime
DECLARE @EndingDate datetime
DECLARE @CreateDimTable bit
DECLARE @DeleteCurrentContent bit
DECLARE @Verbose bit
DECLARE @FirstDayOfWeek tinyint

-- Initial values
SELECT @StartingDate  = '1990-01-01 00:00:00.000'
SELECT @EndingDate = '2100-12-31 00:00:00.000'
SELECT @CreateDimTable  =		1	-- Drop table and/or create it
SELECT @DeleteCurrentContent  = 1	-- Delete all records in table before inserting the new ones
SELECT @Verbose  =				1	-- No messages shown
SELECT @FirstDayOfWeek =		7	-- 1= Monday, 7=Sunday


BEGIN
	SET NOCOUNT ON;

	Declare @PrevDateFirst int; 
	SELECT @PrevDateFirst = @@DATEFIRST
	SET DATEFIRST @FirstDayOfWeek;

	-- Dump parameter values
	IF @Verbose = 1
		BEGIN
			 PRINT 'Generating content for DimDate. Start date: ' + CAST(@StartingDate as char(19));
			 PRINT 'Start date: ' +  CAST(@EndingDate as char(19));
			 PRINT 'Create DimDate table: ' + CAST(@CreateDimTable as char(1));
			 PRINT 'Delete current table content: ' +  CAST(@DeleteCurrentContent as char(1));
		END -- Dumping parameters

	-- Check that parameter values are correct
	-- .. EndingDate > StartingDate
	IF (@EndingDate <= @StartingDate)
			RAISERROR ('ERROR: EndingDate should be greather than  StartingDate!', 9, 1);

	-- PROCESSING 
	IF @Verbose = 1
		PRINT '** Starting content generation process **'

	-- Create Table 
	IF @CreateDimTable = 1
		BEGIN
			IF @Verbose = 1
				PRINT 'Dropping Table.'

			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Dim].[Date]') AND type in (N'U'))
			DROP TABLE [Dim].[Date];
			
			IF @Verbose = 1
				PRINT 'Creating Table.'

				CREATE TABLE Dim.[Date](
					[DateKey] [int] NOT NULL, /* Format: AAAAMMDD */
					[Date] [datetime] NOT NULL,		/* Actual date */
					[FullDate_Description] [nvarchar](100) NULL,	/* Actual date description*/
					[DayNumberOfWeek] [tinyint] NULL,	/* 1 to 7 */
					[DayNumberOfMonth] [tinyint] NULL,	/* 1 to 31 */
					[DayNumberOfYear] [smallint] NULL,	/* 1 to 366 */
					[WeekNumberOfYear] [tinyint] NULL,	/* 1 to 53 */
					[MonthNumberOfYear] [tinyint] NULL,	/* 1 to 12 */
					[CalendarQuarterOfYear] [tinyint] NULL,	/* 1 to 4 */
					[CalendarSemesterOfYear] [tinyint] NULL,	/* 1 to 2 */
					[CalendarYear] [char](4) NULL,	/* Just the number */
					[CalendarYearWeek] [nvarchar](25) NULL,/* Week Unique Identifier: Week + Year */
					[CalendarYearMonth] [nvarchar](25) NULL,/* Month Unique Identifier: Month + Year */
					[CalendarYearQuarter] [nvarchar](25) NULL,/* Quarter Unique Identifier: Quarter + Year */
					[CalendarYearSemester] [nvarchar](25) NULL,/* Semester Unique Identifier: Semester + Year */
					[CalendarYearWeek_Description] [nvarchar](25) NULL,/* Week Unique Descriptor: example - '2007-52'  */
					[CalendarYearMonth_Description] [nvarchar](25) NULL,/* Month Unique Descriptor: example - '2007-12'  */
					[CalendarYearQuarter_Description] [nvarchar](25) NULL,/* Quarter Unique Descriptor: example - 'Q2/2007'  */
					[CalendarYearSemester_Description] [nvarchar](25) NULL,/* Semester Unique Descriptor: example - 'H1.07'  */
					[CalendarYear_Description] [nvarchar](25) NULL,/* Calendar Year Descriptor: example - 'CY 2007'  */
					[EnglishDayNameOfWeek] [nvarchar](10) NULL,
					[SpanishDayNameOfWeek] [nvarchar](10) NULL,
					[CatalanDayNameOfWeek] [nvarchar](10) NULL,
					[PortugueseDayNameOfWeek] [nvarchar](15) NULL,
					[EnglishMonthName] [nvarchar](10) NULL, /* January to December */
					[SpanishMonthName] [nvarchar](10) NULL, /* Enero a Diciembre */
					[CatalanMonthName] [nvarchar](10) NULL, /* Gener a Desembre */
					[PortugueseMonthName] [nvarchar](10) NULL, /* Janeiro a Dezembro */

				 CONSTRAINT [PK_DimDate_DateKey] PRIMARY KEY CLUSTERED 
				(
					[DateKey] ASC
				)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
				 CONSTRAINT [AK_DimDate_Date] UNIQUE NONCLUSTERED 
				(
					[Date] ASC
				)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
				) ON [PRIMARY]
		END -- Create DimDate table

	-- Working variable declaration and initialization
	-- .. Current date being processed
	Declare @CurrentDate datetime; 
	SELECT @CurrentDate = @StartingDate;

	-- Date Key initial value. 
	-- .. Depending on: if creating from scratch or adding new dates
	Declare @CurrentDateKey int; 
	Declare @CurrentMaxDate datetime; 

	-- Check if starting date is already on table
	IF @DeleteCurrentContent = 0 AND @CreateDimTable = 0
		BEGIN
			SELECT @CurrentMaxDate = Max(Date) from DimDate
			If @CurrentMaxDate >= @CurrentDate 
				SELECT @CurrentDate = DATEADD("dd",1,@CurrentMaxDate);
		END -- check if it is already on table
		IF @Verbose = 1
			PRINT 'Starting at '+ CAST(@CurrentDate as char(19));

	-- Delete contents if so stated
	IF @DeleteCurrentContent = 1
		BEGIN
			IF @Verbose = 1
				PRINT 'Deleting Table Contents.';

			DELETE FROM Dim.Date
		END -- Deleting Contents

	-- Content creation LOOP
	WHILE @CurrentDate <= @EndingDate
	BEGIN
		IF @Verbose = 1
			PRINT 'Adding '+ CAST(@CurrentDate as char(19));

		INSERT INTO [dim].[Date]
				   (
				    [DateKey]
				   ,[Date]
				   ,[DayNumberOfWeek]
				   ,[EnglishDayNameOfWeek]
				   ,[DayNumberOfMonth]
				   ,[DayNumberOfYear]
				   ,[WeekNumberOfYear]
				   ,[EnglishMonthName]
				   ,[MonthNumberOfYear]
				   ,[CalendarQuarterOfYear]
				   ,[CalendarYear]
				   ,[CalendarSemesterOfYear]
				   ,[CalendarYearWeek]
				   ,[CalendarYearMonth]
				   ,[CalendarYearQuarter]
				   ,[CalendarYearSemester]
					)
			 VALUES
				   (
					  (DATEPART(year , @CurrentDate) * 10000) + (DATEPART(month , @CurrentDate)*100) + DATEPART(day , @CurrentDate)
					, @CurrentDate
					, DATEPART(dw , @CurrentDate)
					, DATENAME(dw, @CurrentDate)
					, DATEPART(day , @CurrentDate)
					, DATEPART(dayofyear , @CurrentDate)
					, DATEPART(wk , @CurrentDate)
					, DATENAME(month, @CurrentDate)
					, DATEPART(month , @CurrentDate)
					, DATEPART(quarter , @CurrentDate)
					, DATEPART(year , @CurrentDate)
					, CASE 
						WHEN DATEPART(quarter , @CurrentDate) < 3 THEN 1
						ELSE 2
					  END
					 ,CAST(DATEPART(year , @CurrentDate) as char(4))+'-'+ RIGHT('0'+CAST(DATEPART(wk , @CurrentDate) AS varchar(2)),2)
					 ,CAST(DATEPART(year , @CurrentDate) as char(4))+'-'+ RIGHT('0'+CAST(DATEPART(month , @CurrentDate) AS varchar(2)),2)
					 ,CAST(DATEPART(year , @CurrentDate) as char(4))+'-'+ CAST(DATEPART(quarter , @CurrentDate) AS varchar(1))
					 ,CAST(DATEPART(year , @CurrentDate) as char(4))+'-'+ CAST(CASE 
						WHEN DATEPART(quarter , @CurrentDate) < 3 THEN 1
						ELSE 2
					  END AS char(2))
					)	
			; 
			-- Increase the date counter/cursor
			SELECT @CurrentDate = DateAdd(day,1,@CurrentDate);
			SELECT @CurrentDateKey = @CurrentDateKey + 1;
	END -- WHILE LOOP

	-- Update non-english language names
	-- .. SPANISH / Spain / es-ES
		SET LANGUAGE Spanish

		IF @Verbose = 1
			PRINT 'Updating Spanish names';

		UPDATE Dim.Date
		SET SpanishDayNameOfWeek = DATENAME(dw, [Date])
		  , SpanishMonthName = DATENAME(month, [Date])
		WHERE Date >= @StartingDate AND Date<= @EndingDate

		-- Reset the language
		SET LANGUAGE us_english

	-- .. CATALAN
		IF @Verbose = 1
			PRINT 'Updating Catalan names';

		UPDATE Dim.Date
		SET CatalanDayNameOfWeek = 
			CASE DayNumberOfWeek
				WHEN 2 THEN 'Dilluns'
				WHEN 3 THEN 'Dimarts'
				WHEN 4 THEN 'Dimecres'
				WHEN 5 THEN 'Dijous'
				WHEN 6 THEN 'Divendres'
				WHEN 7 THEN 'Dissabte'
				WHEN 1 THEN 'Diumenge'
			END,
		    CatalanMonthName = 
			CASE MonthNumberOfYear
				WHEN 1 THEN 'Gener'
				WHEN 2 THEN 'Febrer'
				WHEN 3 THEN 'Març'
				WHEN 4 THEN 'Abril'
				WHEN 5 THEN 'Maig'
				WHEN 6 THEN 'Juny'
				WHEN 7 THEN 'Juliol'
				WHEN 8 THEN 'Agost'
				WHEN 9 THEN 'Setembre'
				WHEN 10 THEN 'Octubre'
				WHEN 11 THEN 'Novembre'
				WHEN 12 THEN 'Desembre'
			END
		WHERE Date >= @StartingDate AND Date<= @EndingDate
		--
		
		-- Portuguese Brazilian
		SET LANGUAGE brazilian

		IF @Verbose = 1
			PRINT 'Updating Portuguese names';

		UPDATE Dim.Date
		SET PortugueseDayNameOfWeek = DATENAME(dw, [Date])
		  , PortugueseMonthName = DATENAME(month, [Date])
		WHERE Date >= @StartingDate AND Date<= @EndingDate

		-- Reset the language
		SET LANGUAGE us_english


	-- Set descriptions
	---- FullDate description as 'January 1st, 2000'
	---- CalendarYearWeek_Description as 'week 52-2000'
	---- CalendarYearMonth_Description as 'week January 2000'
	---- CalendarYearQuarter_Description as 'week Q3/2000'
	---- CalendarYearSemester_Description as 'week H1-2000'
	---- CalendarYear_Description as 'CY01'
		UPDATE Dim.Date
		SET [FullDate_Description] = CONVERT(nvarchar(100), [Date], 103 ) -- dd/mm/yy
		  , [CalendarYearWeek_Description] = RIGHT('0'+CAST(DATEPART(ww , [Date]) as varchar(2)),2)+'-'+CAST(DATEPART(year , [Date]) as char(4))
		  , [CalendarYearMonth_Description] = SpanishMonthName+' '+CAST(DATEPART(year , [Date]) as char(4))
		  , [CalendarYearQuarter_Description] = CAST(DATEPART(quarter , [Date]) as char(1))+'T-'+CAST(DATEPART(yy , [Date]) as char(4))
		  , [CalendarYearSemester_Description] = 'H' + CAST([CalendarSemesterOfYear] as char(1))+'-'+CAST(DATEPART(yy , [Date]) as char(4))
		  , [CalendarYear_Description] = CAST([CalendarYear]as char(4))
		WHERE Date >= @StartingDate AND Date<= @EndingDate

	-- Reset settings
	SET LANGUAGE us_english;
	SET DATEFIRST @PrevDateFirst;

	-- Ending procedure
	IF @Verbose = 1
		PRINT '** End of content generation process **'

END
GO

SELECT * from Dim.Date ORDER BY DateKey Asc







