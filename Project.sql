CREATE TABLE UserRoles (
userType VARCHAR(10) NOT NULL,
userDesc VARCHAR(10) NOT NULL,
TotalCount INT

CONSTRAINT pk_UserRoles PRIMARY KEY(userType)
);


CREATE TABLE UsersProject (
UserID INT IDENTITY(1,1) NOT NULL,
FirstName VARCHAR(10) NOT NULL,
LastName VARCHAR(10) NOT NULL,
contactNum CHAR(10),
Gender VARCHAR(6) NOT NULL CHECK (Gender IN ('Male', 'Female')),
emailID VARCHAR(20) NOT NULL,
passwrd VARCHAR(20) NOT NULL,
UserType VARCHAR(10) NOT NULL

CONSTRAINT pk_Users  PRIMARY KEY(UserID),
CONSTRAINT fk_Users FOREIGN KEY(UserType) REFERENCES UserRoles(UserType)
);


CREATE TABLE locationProject (

LocationID INT IDENTITY(1001,1) ,
City VARCHAR(20) NOT NULL,
StateName VARCHAR(20) NOT NULL,
zip INT ,
WinterTemp INT NOT NULL,
SpringTemp INT NOT NULL,
SummerTemp INT NOT NULL,
FallTemp INT NOT NULL,

CONSTRAINT pk_location PRIMARY KEY(LocationID)

)

CREATE TABLE Suggestion (

SuggestionID INT IDENTITY(101,1),
SuggestionDate DATE NOT NULL DEFAULT getdate(),
Season VARCHAR(10) NOT NULL

CONSTRAINT pk_Suggestion PRIMARY KEY (SuggestionID)

)


CREATE TABLE ProductTable (

ProductID INT IDENTITY(200,1),
ProductDesc VARCHAR(30) NOT NULL,
ProductType VARCHAR(10) NOT NULL CHECK (ProductType IN ('Business', 'Casual')),
SuitableTemp INT NOT NULL,

CONSTRAINT pk_Product PRIMARY KEY (ProductID)
)

CREATE TABLE productSuggestion (

ProductSuggestionID INT IDENTITY(300,1) NOT NULL,
SuggestionID INT NOT NULL,
ProductID INT NOT NULL,

CONSTRAINT pk_ProductSuggestion PRIMARY KEY(ProductSuggestionID),
CONSTRAINT fk_ProductSuggestion FOREIGN KEY (SuggestionID) REFERENCES Suggestion(SuggestionID),
CONSTRAINT fk_ProductSuggestion2 FOREIGN KEY ( ProductID) REFERENCES ProductTable(ProductID)
)

CREATE TABLE Itinerary (

ItineraryNum INT IDENTITY(5000,1) NOT NULL,
UserID INT NOT NULL,
LocationID INT NOT NULL,
SuggestionID INT NOT NULL,
Season VARCHAR(10)

CONSTRAINT pk_Itinerary PRIMARY KEY(ItineraryNum),
CONSTRAINT fk_Itinerary FOREIGN KEY (UserID) REFERENCES UsersProject(UserID),
CONSTRAINT fk_Itinerary2 FOREIGN KEY (LocationID) REFERENCES locationProject(LocationID),
CONSTRAINT fk_Itinerary3 FOREIGN KEY (SuggestionID) REFERENCES Suggestion(SuggestionID)
)

DROP TABLE Itinerary;
DROP TABLE UsersProject;
DROP TABLE UserRoles;
DROP TABLE locationProject;
DROP TABLE productSuggestion;
DROP TABLE ProductTable;
DROP TABLE Suggestion;


---INSERTING INTO UserRoles

INSERT INTO UserRoles VALUES ('R1', 'Admin');
INSERT INTO UserRoles VALUES ('R2', 'Traveler');

SELECT * FROM UserRoles;

---INSERTING VALUES INTO UsersProject Table

INSERT INTO UsersProject VALUES ('Aditya','Chauhan',3157514953,'Male','adi1909@live.com','Welcome123','R1')
INSERT INTO UsersProject VALUES ('Aditya','Chauhan',8130681577,'Male','achauh01@xyz.com','Hello123','R2')


--- Location Table

INSERT INTO locationProject VALUES ('Albany','New York',12201,22,46,71,49)
INSERT INTO locationProject VALUES ('Atlanta','Georgia',30301,42,61,80,62)

SELECT * FROM locationProject;


--- Product table
INSERT INTO ProductTable VALUES('Shorts','Casual',70)
INSERT INTO ProductTable VALUES('Short-Sleeve Jersey','Casual',70)
--- Checking all the tables
SELECT * FROM UserRoles;
SELECT * FROM UsersProject;
SELECT * FROM locationProject;
SELECT * FROM ProductTable;
SELECT * FROM Suggestion;
SELECT * FROM ProductSuggestion;
SELECT * FROM itinerary;

INSERT INTO itinerary VALUES(2,1004,101,1)
INSERT INTO itinerary VALUES(9,1003,101,1)

INSERT INTO ProductSuggestion VALUES(103,200)
INSERT INTO ProductSuggestion VALUES(103,201)
INSERT INTO ProductSuggestion VALUES(101,205)

---CREATING TRIGGER TO CHECK THE NUMBER OF ADMINS and Travelers

ALTER TABLE UserRoles ADD TotalCount INT

CREATE TRIGGER UsersCheck
ON UsersProject
FOR INSERT , UPDATE , DELETE
AS
IF
@@ROWCOUNT >= 1
BEGIN
	UPDATE UserRoles
	SET TotalCount = TotalUsers.total
	FROM	
		(SELECT UserRoles.userDesc, COUNT( UsersProject.UserType) 'total'
		FROM UserRoles
		INNER JOIN UsersProject ON UserRoles.userType = UsersProject.UserType
		GROUP BY UserRoles.userDesc) AS TotalUsers
		WHERE UserRoles.userDesc=TotalUsers.userDesc
END;

DROP TRIGGER UsersCheck;

SELECT * FROM UserRoles;

INSERT INTO UsersProject VALUES('Sachin','Tendulkar',7271829378,'Male','stendulkar@gmail.com','Sachin123','R2')

SELECT * FROM itinerary;

--- Adding Values to Suggestion Table
INSERT INTO Suggestion VALUES('09/12/2017','Winter');
INSERT INTO Suggestion VALUES('08/23/2017','Spring');
INSERT INTO Suggestion VALUES('07/25/2017','Summer');
INSERT INTO Suggestion VALUES('09/18/2017','Fall');

--- Query for selecting Summer itinerary
SELECT ProductTable.ProductDesc
FROM ProductTable INNER JOIN 
ProductSuggestion ON ProductTable.ProductID=ProductSuggestion.ProductID
WHERE ProductSuggestion.SuggestionID = 103;

-- QUery for Top 3 Users
SELECT TOP 3 Count(UsersProject.UserID) AS CountOfUserID, UsersProject.FirstName , UsersProject.LastName
FROM itinerary INNER JOIN UsersProject ON itinerary.UserID = UsersProject.UserID
GROUP BY UsersProject.FirstName , UsersProject.LastName , UsersProject.UserID
ORDER BY UsersProject.UserID

SELECT * FROM UserRoles;

INSERT INTO UsersProject VALUES ('John','Barnfield','3174895009','Male','jbarnfield@gmail.com','John123','R2');

SELECT * FROM Suggestion;
SELECT * FROM itinerary;

SELECT * FROM UsersProject;

SELECT * FROM ProductSuggestion;



SELECT locationProject.City, locationProject.StateName AS 'State Name', locationProject.zip, locationProject.WinterTemp AS ' Winter Temp', locationProject.SpringTemp AS ' Spring Temp', locationProject.SummerTemp AS ' Summer Temp', locationProject.FallTemp AS ' Fall Temp'
FROM locationProject;


SELECT locationProject.City, Count(Itinerary.LocationID) AS 'Count Of LocationID'
FROM Itinerary INNER JOIN locationProject ON Itinerary.LocationID=locationProject.LocationID
GROUP BY locationProject.City;


SELECT Suggestion.Season, Count(Itinerary.SuggestionID) AS 'Count'
FROM Itinerary INNER JOIN Suggestion ON Suggestion.SuggestionID=Itinerary.SuggestionID
GROUP BY Suggestion.Season;

SELECT UsersProject.FirstName, UsersProject.LastName, Count(UsersProject.UserID) AS 'Count Of UserID'
FROM Itinerary INNER JOIN UsersProject ON Itinerary.UserID = UsersProject.UserID
GROUP BY UsersProject.FirstName, UsersProject.LastName, UsersProject.UserID
ORDER BY UsersProject.UserID;


SELECT UsersProject.FirstName, UsersProject.LastName, UsersProject.emailID
FROM UsersProject LEFT JOIN Itinerary ON UsersProject.UserID = Itinerary.UserID
WHERE Itinerary.UserID IS NULL AND UsersProject.UserType = 'R2';



SELECT ProductTable.ProductDesc
FROM ProductTable INNER JOIN ProductSuggestion ON ProductTable.ProductID=ProductSuggestion.ProductID
WHERE ProductSuggestion.SuggestionID = 104;

SELECT * FROM UserRoles;

INSERT INTO UsersProject VALUES('Steven','McDonald',7283749858,'Male','smcdonald@gmail.com','Steven123','R2')

SELECT * FROM UserRoles;