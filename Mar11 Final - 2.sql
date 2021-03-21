USE Data9401_Final;

-- raw data table--

SELECT * FROM FPMV --perform visual check on 0NF table--
ORDER BY StudentID; --notice column titles are not using the same format (ie,Pascal or camel), student average, grade & total point can be removed as these can be calculated instead on putting in a table.--
--majority of column values for assignment and test are in decimal data type with some odd cases of whole number. Better to change data_type to decimal/numeric.--


--check for duplicate records--

SELECT *, COUNT(*) Occurrence --NO Record OCCURRENCE more than 1, Need to create Primary Key column for the TABLE to meet 1NF compliance and remove any multivalued fields--
	FROM FPMV
	GROUP BY studentID,First_name,Lastname,Midtermexam,Finalexam,assignment1,assignment2,Totalpoints,Studentaverage,Grade
	HAVING COUNT(*) >1; 


SELECT studentID, COUNT(*) Occurrence -- 3 student ID occured more than once. These duplicated student ID are 35932, 47058 & 64698--
	FROM FPMV
	GROUP BY studentID
	HAVING COUNT (*) >1;

SELECT *
	FROM FPMV
	WHERE studentID = 35932 OR studentID = 47058 OR studentID = 64698 --Confirmed StudentID is duplicated in error, and student names are different.
	ORDER BY studentID, First_name;

SELECT First_name, Lastname, COUNT(*) Occurrence -- Let's do another duplicate check based on first and last name. Result - Noone is duplicated based on first name and last name basis.--
	FROM FPMV
	GROUP BY First_name, Lastname
	HAVING COUNT (*) >1;

SELECT t.First_name, t.Lastname   --check from any criscross first and last name. NO names are cris cross--
	FROM FPMV t
	WHERE EXISTS (
	SELECT *
	FROM FPMV
	WHERE [First_name] = t.[Lastname]
	AND [Lastname] = t.[First_name]
);

--update 0NF to 1NF table. Create new 1NF table from raw data table, add a new primary key "CodeID" (i could combine StudentID with First&LastName to make a primary key)--
BEGIN TRANSACTION
CREATE TABLE RawGrade1(
	StudentID INT NOT NULL,
	FirstName NVARCHAR(25) NOT NULL,
	LastName NVARCHAR(25) NOT NULL,
	Assignment1 NUMERIC (3,2),
	MidTermExam NUMERIC (3,2),
	Assignment2 NUMERIC (3,2),
	FinalExam NUMERIC (3,2),
	StudentAverage NUMERIC (3,2),
	Grade NVARCHAR (5)
);
COMMIT;

BEGIN TRANSACTION
INSERT INTO RawGrade1 (StudentID,FirstName,LastName,Assignment1,MidTermExam,Assignment2,FinalExam,StudentAverage,Grade)
	SELECT studentID,First_name,Lastname,assignment1,Midtermexam,assignment2,Finalexam,Studentaverage,Grade
	FROM FPMV
COMMIT;


--Search out the duplicated studentID numbers and update--

SELECT *
	FROM RawGrade1
	WHERE StudentID = 35932 OR StudentID = 47058 OR StudentID = 64698; -- 35932 (Tallulah Lynes), 47058 (Jaye Margett), 64698 (Claudian Burree)--

--Plan to Update the duplicated studentID with new StudentID. Numbering will the consecutive number from the last entry studentID 99865. i.e. 99866,99867,99868.--

UPDATE RawGrade1
	SET StudentID = 99866
	WHERE FirstName = 'Tallulah' AND StudentID = '35932';
	
UPDATE RawGrade1
	SET StudentID = 99867
	WHERE FirstName = 'Jaye' OR LastName = 'Margett';

UPDATE RawGrade1
	SET StudentID = 99868
	WHERE FirstName = 'Claudian' OR LastName = 'Burree';


SELECT * FROM RawGrade1
ORDER BY StudentID;


--1.create a new table called StudentTable1 with studentID, First name and last name--
--2.create a new table for CourseWorks2 with WorkID, Assignment1,Assignment2,Midtermexam,Finalexam--


BEGIN TRANSACTION
CREATE TABLE StudentTable1(
	StudentID INT NOT NULL,
	FirstName NVARCHAR(25) NOT NULL,
	LastName NVARCHAR(25) NOT NULL,
	);
COMMIT;

BEGIN TRANSACTION
CREATE TABLE CourseWorks2(
	StudentID INT NOT NULL,
	Assignment1 Numeric(3,2),
	Assignment2 Numeric(3,2),
	Midtermexam Numeric(3,2),
	Finalexam Numeric(3,2),
);
COMMIT;

SELECT * FROM StudentTable1;

SELECT * FROM CourseWorks2;

--inside data into newly created tables--
BEGIN TRANSACTION 
INSERT INTO CourseWorks2(studentID,Assignment1,Assignment2,MidTermExam,FinalExam)
	SELECT studentID,Assignment1,Assignment2,MidTermExam,FinalExam
	FROM RawGrade1 
COMMIT;

BEGIN TRANSACTION 
INSERT INTO StudentTable1 (StudentID,FirstName,LastName)
	SELECT StudentID,FirstName,LastName
	FROM RawGrade1 
COMMIT;



-------------------------------------------------------------------------------------------
-- Define Primary and Foreign Keys --
ALTER TABLE StudentTable1
ADD PRIMARY KEY(StudentID);

ALTER TABLE CourseWorks2
ADD FOREIGN KEY (StudentID) REFERENCES StudentTable1(StudentID); 

-------------------------------



-- Consolidated table --
BEGIN TRANSACTION
SELECT StudentTable1.StudentID, StudentTable1.FirstName, StudentTable1.LastName, CourseWorks2.Assignment1,CourseWorks2.Assignment2,CourseWorks2.MidTermExam,CourseWorks2.FinalExam
INTO BigReport2
FROM StudentTable1 INNER JOIN CourseWorks2
ON StudentTable1.StudentID = CourseWorks2.StudentID
COMMIT;

--view tables--
SELECT * FROM StudentTable1;

SELECT * FROM CourseWorks2
ORDER BY StudentID;

SELECT * FROM BigReport2;

SELECT * FROM RawGrade1
ORDER BY Grade;

CREATE VIEW StudentAverageView AS
SELECT BigReport2.StudentID, ROUND(AVG(Assignment1+Assignment2+MidTermExam+FinalExam)/4,2) AS StudentAverage
FROM BigReport2
GROUP BY StudentID;

SELECT * FROM StudentAverageView


CREATE VIEW GradeView AS
SELECT StudentID,StudentAverage,
CASE 
	WHEN StudentAverage >= 0.97 AND StudentAverage <= 1 THEN 'A+'
	WHEN StudentAverage >= 0.94 AND StudentAverage <= 0.96 THEN 'A'
	WHEN StudentAverage >= 0.90 AND StudentAverage <= 0.93 THEN 'A-'
	WHEN StudentAverage >= 0.86 AND StudentAverage <= 0.89 THEN 'B+'
	WHEN StudentAverage >= 0.83 AND StudentAverage <= 0.85 THEN 'B'
	WHEN StudentAverage >= 0.80 AND StudentAverage <= 0.82 THEN 'B-'
	WHEN StudentAverage >= 0.76 AND StudentAverage <= 0.79 THEN 'C+'
	WHEN StudentAverage >= 0.73 AND StudentAverage <= 0.75 THEN 'C'
	WHEN StudentAverage >= 0.70 AND StudentAverage <= 0.72 THEN 'C-'
	WHEN StudentAverage >= 0.67 AND StudentAverage <= 0.69 THEN 'D+'
	WHEN StudentAverage >= 0.63 AND StudentAverage <= 0.66 THEN 'D'
	WHEN StudentAverage >= 0.60 AND StudentAverage <= 0.62 THEN 'D-'
	ELSE 'F'
END AS Grade
FROM StudentAverageView;

SELECT * FROM GradeView

 
SELECT a.StudentID,a.FirstName,a.LastName,a.Assignment1,a.Assignment2,a.MidTermExam,a.FinalExam,b.StudentAverage,b.Grade
FROM BigReport2 a
INNER JOIN GradeView b ON b.StudentID = a.StudentID


SELECT * FROM RawGrade1
ORDER BY StudentID;