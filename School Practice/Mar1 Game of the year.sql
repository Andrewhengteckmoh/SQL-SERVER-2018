Use Data9401_CLASS;

--practice create table, alter table, insert, update, delete, truncate, drop--
CREATE TABLE Game_of_the_Year (
    Game_ID int,
    Name varchar(100),
	Region varchar(100),
    Scores int,
	Total_Hours_Gameplay int
);

ALTER TABLE Game_of_the_Year
	ADD 
	Do_I_Own varchar(25),
	Got_Platimum varchar(25
);

DROP TABLE Game_of_the_Year

CREATE TABLE Game_of_the_Year (
	Game_ID int,
	Name varchar(50),
	Region varchar(50),
	Scores DECIMAL(4,2),
	Total_Hours_Gameplay int
);

ALTER TABLE Game_of_the_Year
	ADD My_Scores FLOAT;

ALTER TABLE Game_of_the_Year
	DROP COLUMN Region;

INSERT INTO Game_of_the_Year (Game_ID, Name, Scores, Total_Hours_Gameplay,My_Scores)
	VALUES (100001,'God_of_War',9.5,60,10);

INSERT INTO Game_of_the_Year (Game_ID, Name, Scores, Total_Hours_Gameplay,My_Scores)
	VALUES (100002,'Last of Us',8.5,60,9.5);

INSERT INTO Game_of_the_Year (Game_ID, Name, Scores, Total_Hours_Gameplay,My_Scores)
	VALUES (100001,'God of War',9.5,60,10);	

DELETE FROM Game_of_the_Year 
	WHERE Name='God_of_War';

INSERT INTO Game_of_the_Year (Game_ID, Name, Scores, Total_Hours_Gameplay,My_Scores)
	VALUES (100003,'Red Dead Redemption 2',10,120,10), 
	(100004,'Super Fighter V - Champion Edition',10,120,10);

UPDATE Game_of_the_Year
	SET NAME='Super Fighter V - Deluxe Edition', Scores=8, Total_Hours_Gameplay=30, My_Scores=7.5
	WHERE Game_ID=100004;

SELECT * FROM Game_of_the_Year
ORDER BY Game_ID;


--practicing with NOT NULL & NULL values--
CREATE TABLE Game_of_the_Year2 (
	Game_ID int NOT NULL PRIMARY KEY,
	Name varchar(50),
	Region varchar(50),
	Scores DECIMAL(4,2),
	Total_Hours_Gameplay int,
	My_Scores FLOAT
);

INSERT INTO Game_of_the_Year2 (Game_ID, Name, Scores, Total_Hours_Gameplay)
	VALUES (100001,'', 8.9,35),(100002,'', 8.9,35),(100003,'BobYourUncle',NULL,50);

UPDATE Game_of_the_Year2 
	SET My_Scores= 0
	WHERE My_Scores is NULL;

SELECT * FROM Game_of_the_Year2
ORDER BY Game_ID;
DROP TABLE Game_of_the_Year2;

--creating new table called Novel of the year and inserting info from game of the year table-- 
CREATE TABLE Novel_of_the_Year (
	Book_ID int NOT NULL,
	Name varchar (100),
	Scores decimal(4,2)
);

ALTER TABLE Novel_of_the_Year
	ADD PRIMARY KEY (BOOK_ID);

INSERT INTO Novel_of_the_Year (Book_ID, Name, Scores)
	SELECT Game_ID, Name, Scores
	FROM Game_of_the_Year 

INSERT INTO Novel_of_the_Year (BOOK_ID)
	VALUES (100009);

SELECT * FROM Novel_of_the_Year
	ORDER BY Name;

TRUNCATE TABLE Novel_of_the_Year;

DROP TABLE Novel_of_the_Year;


--merge 2 tables (Game of the year and game of the year region)--
CREATE TABLE Game_of_the_Year_Update (
	Game_ID int,
	Name varchar(100),
	Scores decimal(4,2),
	Total_Hours_Gameplay int,
	My_Scores Float);

INSERT INTO Game_of_the_Year_Update (Game_ID, Name, Scores, Total_Hours_Gameplay,My_Scores)
	VALUES (100001,'God of War',9.5,60,10),
	(100002,'Last of Us',8.5,60,9.5),
	(100004, 'Super Fighter V - Deluxe Edition',8.75,60,8),
	(100005, 'Super Mario Infinity',9,200,9),
	(100006, 'Gran Turismo 10',10,2000,10);

MERGE Game_of_the_Year t USING Game_of_the_Year_Update s ON (s.Game_ID=t.Game_ID)
	WHEN matched 
		THEN UPDATE set t.name=s.name, t.Scores=s.Scores, t.Total_Hours_Gameplay=s.Total_Hours_Gameplay, t.My_Scores=s.My_Scores
	WHEN not matched by Target
		THEN INSERT (Game_ID,Name,Scores,Total_Hours_Gameplay,My_Scores) 
		VALUES (s.Game_ID,s.Name,s.Scores,s.Total_Hours_Gameplay,s.My_Scores)
	WHEN not matched by Source
		THEN DELETE;

SELECT * FROM Game_of_the_Year_Update
ORDER BY Game_ID;

SELECT * FROM Game_of_the_Year


--import cvs file----

SELECT * FROM DigiDB_digimonlist

--------------------

CREATE TABLE planet (
	planetName varchar(50),
	diameter varchar(50),
);

INSERT INTO planets (planetName, diameter)
	Values ('earth', 10000);

SELECT * FROM planets;

DROP TABLE planets;

--------create view----------

CREATE VIEW vwPlanets AS
	SELECT PlanetName,PlanetType,Radius
	FROM planet;

SELECT * FROM vwPlanets;


--Stored Procedure 1 without parameter--
CREATE PROCEDURE sp_DigimonAttackOver200 AS
	SELECT Digimon,Stage,Lv50_Atk
	FROM DigiDB_digimonlist
	WHERE Lv50_Atk > 200
	ORDER BY Digimon DESC;

EXEC sp_DigimonAttackOver200;

--Stored Procedure 2 with one parameter--
CREATE PROCEDURE sp_DigiHPOver(@LV_50_HP int)
	AS
	SELECT Digimon, Stage, Attribute, Lv_50_HP
		FROM DigiDB_digimonlist
		WHERE Lv_50_HP > @Lv_50_HP;

EXEC sp_DigiHPOver @Lv_50_HP = 1000;

--Stored Procedure 2 with three parameters--
CREATE PROCEDURE sp_DigiHPAndSPOver(@LV_50_HP int,@Lv50_SP int,@Type nvarchar(10))
	AS
	SELECT Digimon, Stage, Type, Attribute, Lv_50_HP, Lv50_SP
		FROM DigiDB_digimonlist
		WHERE Type = @Type AND Lv_50_HP > @Lv_50_HP AND Lv50_SP > @Lv50_SP;

EXEC sp_DigiHPAndSPOver @Type = Free, @Lv_50_HP = 1000, @Lv50_SP = 70; --For type choose between Free, Data, Virus--

--Stored Procedure 3 with multiple parameters on insert--
SELECT * INTO NewTable
	FROM DigiDB_digimonlist;

ALTER TABLE NewTable
	ADD PRIMARY KEY (Number);

CREATE PROCEDURE sp_GetUpdate(
	@Number int, 
	@Digimon Varchar(20), 
	@Stage Varchar(20), 
	@Type Varchar(20), 
	@Attribute Varchar(20), 
	@Memory int, 
	@Equip_Slots int, 
	@Lv_50_HP int, 
	@Lv50_SP int, 
	@Lv50_Atk int, 
	@Lv50_Def int, 
	@Lv50_int int, 
	@Lv50_Spd int
) 
	AS 
	BEGIN
	INSERT INTO NewTable
	Values (
	@Number, 
	@Digimon, 
	@Stage, 
	@Type, 
	@Attribute, 
	@Memory, 
	@Equip_Slots, 
	@Lv_50_HP, 
	@Lv50_SP, 
	@Lv50_Atk, 
	@Lv50_Def, 
	@Lv50_int, 
	@Lv50_Spd
);
	END;
	
EXEC sp_GetUpdate 250,'Andrew','Celestial','Virus','Holy',15,10,'','','','','','';
EXEC sp_GetUpdate 251,'Andrew','Celestial','Virus','Holy',15,10,'','','','','','';
EXEC sp_GetUpdate 252,'OMG','Celestial','DATA','Holy',15,10,999,999,999,999,999,999;

SELECT * FROM NewTable;

--Practicing Aggregate function--

SELECT AVG(Lv_50_HP)
	FROM 
	DigiDB_digimonlist;

SELECT COUNT(Number)
	FROM 
	DigiDB_digimonlist;

SELECT 
	Digimon,
	Stage,
	Lv50_Atk,
	FIRST_VALUE (Digimon) OVER (
	PARTITION BY Stage
	ORDER BY Lv50_Atk
	)WeakestLink
FROM 
	DigiDB_digimonlist;

SELECT 
	Digimon,
	Stage,
	Lv50_Atk,
	LAST_VALUE (Digimon) OVER (
	PARTITION BY Stage
	ORDER BY Lv50_Atk
	RANGE BETWEEN
	UNBOUNDED PRECEDING AND 
    UNBOUNDED FOLLOWING
	)Strongest
FROM 
	DigiDB_digimonlist;

SELECT MAX(Lv50_Int)
	FROM 
	DigiDB_digimonlist;

SELECT MIN(Lv50_Spd)
	FROM 
	DigiDB_digimonlist;

SELECT SUM(Memory)
	FROM 
	DigiDB_digimonlist;

--Practice Scalar Functions--

SELECT UPPER(Digimon)
	FROM 
	DigiDB_digimonlist;

SELECT LOWER(Digimon)
	FROM 
	DigiDB_digimonlist;

SELECT SUBSTRING(Stage,1,2)
	FROM 
	DigiDB_digimonlist;

SELECT LEN(Digimon)
	FROM 
	DigiDB_digimonlist;

-- Practice User Defined Function 1 with 1 Paramater--

CREATE FUNCTION udfDigimonList(
	@Lv50_Atk int
)
	RETURNS TABLE 
	AS
	RETURN
		SELECT Digimon, Stage, Attribute, Lv50_Atk
		FROM DigiDB_digimonlist
		WHERE Lv50_Atk > @Lv50_Atk;

SELECT * 
	FROM udfDigimonList (150);

DROP FUNCTION udfDigimonList;

-- Practice User Defined Function 2 with two parameters--

CREATE FUNCTION udfDigimonlist2(
	@Lv50_Atk int,
	@Equip_Slots int, 
	@Lv_50_HP int
)
	RETURNS int 
	AS
	BEGIN
	RETURN (@Lv50_Atk * (1- @Equip_Slots))* @Lv_50_HP;
	END;

SELECT  
	dbo.udfDigimonlist2(100,2,2) NetNumber;

SELECT
	Number,
	SUM(dbo.udfDigimonlist2(Lv50_Atk, Equip_Slots, Lv_50_HP)) NetSum
FROM 
	DigiDB_digimonlist
GROUP BY
	Number
ORDER BY
	NetSum DESC;

DROP FUNCTION udfDigimonList2;

-- Practice SELECT Query--
SELECT Digimon, Stage
	FROM dbo.DigiDB_digimonlist
	WHERE Attribute = 'Fire' AND Memory >= 8;

SELECT Game_ID,Name
	FROM Game_of_the_Year
	WHERE Scores >= 8.75;

--Practice SELECT DISTINCT--

SELECT DISTINCT Digimon
	FROM dbo.DigiDB_digimonlist;

SELECT DISTINCT Attribute
	FROM dbo.DigiDB_digimonlist;

SELECT DISTINCT Lv50_Def
	FROM dbo.DigiDB_digimonlist;

SELECT DISTINCT Lv50_Def,Lv50_Atk
	FROM dbo.DigiDB_digimonlist

--Practice SELECT ORDER BY--

SELECT * 
	FROM dbo.DigiDB_digimonlist
	ORDER BY Lv50_Atk DESC;

SELECT * 
	FROM dbo.DigiDB_digimonlist
	ORDER BY Stage, Type, Attribute DESC;

--Practice Combine Query--

SELECT Digimon, Stage
	FROM dbo.DigiDB_digimonlist
	WHERE Type = 'Data' AND Lv_50_HP >=950
	ORDER BY Digimon;


--Practice BETWEEN Query--
SELECT Digimon, Stage
	FROM dbo.DigiDB_digimonlist
	WHERE Lv_50_HP >=950 AND Lv_50_HP <=2000
	ORDER BY Digimon;

--Practice NOT Query--
SELECT Digimon, Stage
	FROM dbo.DigiDB_digimonlist
	WHERE NOT Type = 'Data' 
	ORDER BY Digimon;

SELECT Digimon, Stage, Type
	FROM dbo.DigiDB_digimonlist
	WHERE NOT (Type = 'Data' OR Type = 'Virus')
	ORDER BY Digimon;

--Practice UNION Clause--
SELECT Number, Digimon, Stage, Equip_Slots, Type
	FROM dbo.DigiDB_digimonlist
	WHERE Type = 'Data' OR Type = 'Virus'
	UNION
	SELECT Number, Digimon, Stage, Equip_Slots, Type
	FROM dbo.DigiDB_digimonlist
	WHERE Equip_Slots BETWEEN 3 AND 5;

--Practice INTERSECT Clause--
SELECT *
	FROM dbo.DigiDB_digimonlist
	WHERE Memory BETWEEN 10 AND 20
	INTERSECT
		SELECT *
			FROM NewTable
			WHERE Memory BETWEEN 16 AND 24
			ORDER BY Memory;

--Practice Insert data--
INSERT INTO Game_of_the_Year
	VALUES (100009, 'Last of Us 2',9.5,60,9.5),
		   (100010, 'Last of Us 3',9.5,60,9.5),
		   (100011, 'Last of Us 4',9.5,60,9.5);

--Practice UPDATE & DELETE statement--
UPDATE Game_of_the_Year
	SET Scores = 10,
		Total_Hours_Gameplay = 80,
		My_Scores = 10
	WHERE Game_ID = 100010;

DELETE Game_of_the_Year
	WHERE Game_ID BETWEEN 100009 AND 100011;
SELECT * FROM Game_of_the_Year


-- Practice MODULE #3 error--
--1. Import dataset then do row count--

SELECT COUNT(*)
	FROM dbo.GME_stock; --returned 4773 rows as a result

SELECT * FROM dbo.GME_stock; --do my visual check on the newly imported table--

--2.CREATE TABLES--

SELECT * INTO Table1-- First 2387
	FROM 
	(SELECT ROW_NUMBER() OVER(ORDER BY date DESC) AS RowID, 
    *
	FROM dbo.GME_stock)d
	WHERE d.RowID BETWEEN 1 and 2387;


SELECT * INTO Table2-- Last 2386
	FROM
	(SELECT ROW_NUMBER() OVER(ORDER BY date DESC) AS RowID, 
	*
	FROM dbo.GME_stock)d
	WHERE d.RowID BETWEEN 2388 and 4773;

--3. Practice inner and outer joins--

SELECT * FROM dbo.GME_stock;
SELECT * FROM Table1;
SELECT * FROM Table2;

Drop Table table1;
Drop Table table2;


-- Practice MODULE #3 (good)--
BEGIN TRANSACTION
SELECT * INTO MainModule3Table
	FROM DigiDB_digimonlist;
ROLLBACK;

SELECT *
	FROM MainModule3Table;

--Code to create two sub-tables--
BEGIN TRANSACTION
CREATE TABLE Module3Table1 (
	Number INT NOT NULL PRIMARY KEY,
	Digimon VARCHAR(20) NULL,
	Stage VARCHAR(20) NULL,
	Type VARCHAR(10) NULL,
	Attribute VARCHAR(10) NULL,
	Memory INT NULL,
	Equip_Slots INT NULL
);--easier to just use SELECT INTO statement to create and copy data--

CREATE TABLE Module3Table2 (
	Number INT NOT NULL FOREIGN KEY REFERENCES Module3Table1 (Number),
	Lv_50_HP INT NULL,
	Lv50_SP INT NULL,
	Lv50_Atk INT NULL, 
	Lv50_Def INT NULL, 
	Lv50_int INT NULL, 
	Lv50_Spd INT NULL
);--easier to just use SELECT INTO statement to create table and copy data--
ROLLBACK;

--Contiune testing Code to create two sub-tables--
BEGIN TRANSACTION
CREATE TABLE Module3Table3 (
	Number INT NOT NULL PRIMARY KEY,
	Digimon VARCHAR(20) NULL,
	Stage VARCHAR(20) NULL,
	Type VARCHAR(10) NULL,
	Attribute VARCHAR(10) NULL,
	Memory INT NULL,
	Equip_Slots INT NULL
);

CREATE TABLE Module3Table4 (
	Number INT NOT NULL FOREIGN KEY REFERENCES Module3Table1 (Number),
	Lv_50_HP INT NULL,
	Lv50_SP INT NULL,
	Lv50_Atk INT NULL, 
	Lv50_Def INT NULL, 
	Lv50_int INT NULL, 
	Lv50_Spd INT NULL
);
COMMIT;

INSERT INTO Module3Table3
	SELECT Number, Digimon,Stage, Type, Attribute, Memory, Equip_Slots FROM DigiDB_digimonlist;

INSERT INTO Module3Table4
	SELECT Number,Lv_50_HP,Lv50_SP,Lv50_Atk,Lv50_Def,Lv50_int,Lv50_Spd FROM DigiDB_digimonlist;

ALTER TABLE Module3Table3 --cannot add primary key. great, the above method save me steps from ALTER table columns--
	ADD PRIMARY KEY (Number);

SELECT * FROM dbo.Module3Table3;

SELECT * FROM dbo.Module3Table4;




--CREATE & INSERT data into the two tables--
BEGIN TRANSACTION
SELECT Number,Digimon,Stage,Type,Attribute,Memory,Equip_Slots INTO dbo.Module3Table1
	FROM DigiDB_digimonlist;

SELECT Number,Lv_50_HP,Lv50_SP,Lv50_Atk,Lv50_Def,Lv50_int,Lv50_Spd INTO dbo.Module3Table2
	FROM DigiDB_digimonlist;
COMMIT;


--Displays result of split tables--

SELECT * FROM dbo.Module3Table1;

SELECT * FROM dbo.Module3Table2;


--ALTER COLUMN Attribute for both tables--

ALTER TABLE dbo.Module3Table1 
	ADD PRIMARY KEY (Number);

ALTER TABLE dbo.Module3Table1
	ALTER COLUMN Digimon VARCHAR(20) NULL;

ALTER TABLE dbo.Module3Table1
	ALTER COLUMN Stage VARCHAR(20) NULL;

ALTER TABLE dbo.Module3Table1
	ALTER COLUMN Type VARCHAR(10) NULL;

ALTER TABLE dbo.Module3Table1
	ALTER COLUMN Attribute VARCHAR(10) NULL;

ALTER TABLE dbo.Module3Table1
	ALTER COLUMN Memory INT NULL;

ALTER TABLE dbo.Module3Table1
	ALTER COLUMN Equip_Slots INT NULL;

ALTER TABLE dbo.Module3Table2 
	ADD PRIMARY KEY (Number);

ALTER TABLE dbo.Module3Table2
	ALTER COLUMN Lv_50_HP INT NULL;

ALTER TABLE dbo.Module3Table2
	ALTER COLUMN Lv50_SP INT NULL;

ALTER TABLE dbo.Module3Table2
	ALTER COLUMN Lv50_Atk INT NULL;

ALTER TABLE dbo.Module3Table2
	ALTER COLUMN Lv50_Def INT NULL;

ALTER TABLE dbo.Module3Table2
	ALTER COLUMN Lv50_int INT NULL;

ALTER TABLE dbo.Module3Table2
	ALTER COLUMN Lv50_Spd INT NULL;
	

-- Insert values Module3Table1 & Module3Table2--
BEGIN TRANSACTION
INSERT INTO dbo.Module3Table1 (Number)
	VALUES (250);

INSERT INTO dbo.Module3Table1 (Number)
	VALUES (251);

INSERT INTO dbo.Module3Table1 (Number)
	VALUES (252);

INSERT INTO dbo.Module3Table2 (Number)
	VALUES (250);

INSERT INTO dbo.Module3Table2 (Number,Lv_50_HP, Lv50_Atk)
	VALUES (251,5555, 888);

INSERT INTO dbo.Module3Table2 (Number, Lv_50_HP, Lv50_SP)
	VALUES (253,4444, 444);
COMMIT;
	

--Inner Join Two Alias Tables--

SELECT a.Digimon,a.Stage,b.Lv_50_HP,b.Lv50_Atk
	FROM dbo.Module3Table1 a
	INNER JOIN dbo.Module3Table2 b 
	ON a.Number = b.Number;

--Left Outer Join Two Alias Tables--

SELECT a.Digimon,a.Stage,b.Lv_50_HP,b.Lv50_Atk
	FROM dbo.Module3Table1 a
	LEFT OUTER JOIN dbo.Module3Table2 b 
	ON a.Number = b.Number;

--Right Outer Join Two Alias Tables--

SELECT a.Digimon,a.Stage,b.Lv_50_HP,b.Lv50_Atk
	FROM dbo.Module3Table1 a
	RIGHT OUTER JOIN dbo.Module3Table2 b 
	ON a.Number = b.Number;

--FULL Outer Join Two Alias Tables--

SELECT a.Digimon,a.Stage,b.Lv_50_HP,b.Lv50_Atk
	FROM dbo.Module3Table1 a
	FULL OUTER JOIN dbo.Module3Table2 b 
	ON a.Number = b.Number;

--Practice UNION on two different tables--

SELECT Digimon, Stage     --Conversion failed when converting the varchar value 'Kuramon' to data type int--
	FROM dbo.Module3Table1
	UNION
	SELECT Lv_50_HP, Lv50_SP
	FROM dbo.Module3Table2;

SELECT a.Memory, a.Equip_Slots    
	FROM dbo.Module3Table1 a
	UNION
	SELECT b.Lv_50_HP, b.Lv50_SP
	FROM dbo.Module3Table2 b;

SELECT a.Memory, a.Equip_Slots  
	FROM dbo.Module3Table1 a
	UNION ALL
	SELECT b.Lv_50_HP, b.Lv50_SP
	FROM dbo.Module3Table2 b;

--Practice Intersect on two different tables--

SELECT a.Number, a.Memory, a.Equip_Slots     
	FROM dbo.Module3Table1 a
	WHERE Number BETWEEN 1 AND 255
	INTERSECT
	SELECT b.Number, b.Lv_50_HP, b.Lv50_SP
	FROM dbo.Module3Table2 b
	WHERE Number BETWEEN 2 AND 260;

--Practice EXCEPT on two different tables--

SELECT a.Number, a.Memory, a.Equip_Slots     
	FROM dbo.Module3Table1 a
	WHERE Number BETWEEN 1 AND 255
	EXCEPT
	SELECT b.Number, b.Lv_50_HP, b.Lv50_SP
	FROM dbo.Module3Table2 b
	WHERE Number BETWEEN 2 AND 260;

--Trying Cross Join--
BEGIN TRANSACTION
SELECT * FROM dbo.Module3Table1
	CROSS JOIN dbo.Module3Table2;
ROLLBACK;


--MODULE4 Normalize table--
--IMPORT shootingSC csv file. Verified same data_types during import--

SELECT * FROM ScoringSC;-- view table, 284 rows intotal, no multivalued attribute but there are a few multivalued fields--


--1NF check for duplicate records--


SELECT *, COUNT(*) Occurrence --NO Record OCCURRENCE more than 1, Need to create Primary Key column for the TABLE to meet 1NF compliance and remove multivalued fields--
	FROM ScoringSC
	GROUP BY playerID,ActiveYear,tmID,lgID,pos, GP, G, A, Pts, PIM
	HAVING COUNT(*) >1; 

--1NF create a new table call MemberID using playerID and ActiveYear, includes primary key--
BEGIN TRANSACTION
CREATE TABLE MemberIDTable (
	MemberID  INT NOT NULL,
	playerID NVARCHAR(50) NOT NULL,
	ActiveYear INT NOT NULL
);
COMMIT;

BEGIN TRANSACTION
INSERT INTO MemberIDTable (MemberID, playerID, ActiveYear)
	SELECT ROW_NUMBER () OVER(ORDER BY playerID ASC) AS MemberID, playerID, ActiveYear
	FROM ScoringSC
	GROUP BY playerID, ActiveYear
COMMIT;

SELECT * FROM MemberIDTable

--1NF on the import table, split the multivalued field on the pos attribute, string separation by /--

BEGIN TRANSACTION
SELECT *  
	FROM ScoringSC  
    CROSS APPLY STRING_SPLIT(pos,'/');  
ROLLBACK;---i feel i dont need to do this, as data in GP,G,A,PTs, PIM is for the year at the pos (single or multi postion). IF i split the pos multivalue data and create a need row, i can split GP,G,A,PTs, PIM correct to each pos.--
--so 1NF complete--

--2NF check to remove redunant data--

SELECT playerID,year, COUNT(*) Occurrence --NO OCCURRENCE more than 1--
	FROM ScoringSC
	GROUP BY playerID,year
	HAVING COUNT(*) >1; 

SELECT playerID,tmID, COUNT(*) Occurrence --NO OCCURRENCE more than 1 --
	FROM ScoringSC
	GROUP BY playerID,tmID
	HAVING COUNT(*) >1; 

SELECT playerID,lgID, COUNT(*) Occurrence --NO OCCURRENCE more than 1 --
	FROM ScoringSC
	GROUP BY playerID,lgID
	HAVING COUNT(*) >1;

SELECT playerID,pos, COUNT(*) Occurrence --NO OCCURRENCE more than 1 --
	FROM ScoringSC
	GROUP BY playerID,pos
	HAVING COUNT(*) >1;






--Creat a new table called LeagueTable

BEGIN TRANSACTION
CREATE TABLE LeagueTable (
	LeagueID NVARCHAR(50) NOT NULL,
	lgID_tmID NVARCHAR(50) NOT NULL
);
COMMIT;

SELECT * FROM LeagueTable

BEGIN TRANSACTION
UPDATE ScoringSC
	SET lgID = CONCAT(lgID, '-',tmID);

SELECT lgID FROM ScoringSC
GROUP BY lgID
ROLLBACK;

BEGIN TRANSACTION
INSERT INTO LeagueTable (LeagueID,lgID_tmID)
	SELECT playerID, lgID
	FROM ScoringSC;
COMMIT;


BEGIN TRANSACTION
SELECT playerID, ActiveYear INTO 
	FROM ScoringSC
BEGIN TRANSACTION
ALTER TABLE ScoringSC
	DROP COLUMN activeYear;
COMMIT;




BEGIN TRANSACTION
ALTER TABLE ScoringSC
	DROP COLUMN tmID;
COMMIT;

BEGIN TRANSACTION
CREATE TABLE LeagueTable (
	playerID NVARCHAR(50) NOT NULL,
	lgID_tmID NVARCHAR(50) NOT NULL
);
COMMIT;

SELECT * FROM LeagueTable

BEGIN TRANSACTION
INSERT INTO LeagueTable (playerID, lgID_tmID)
	SELECT playerID, lgID
	FROM ScoringSC;
ROLLBACK;














BEGIN TRANSACTION
ALTER TABLE ScoringSC
	DROP COLUMN tmID;
COMMIT;



BEGIN TRANSACTION
EXEC sp_rename ScoringSC.lgID, lgID-tmID, COLUMN;












