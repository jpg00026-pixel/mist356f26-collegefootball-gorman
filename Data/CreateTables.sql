
/*
CREATE LOGIN NandaSurendra
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER NandaSurendra
FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;
*/
if object_id('Stadium') is not null
    drop table Stadium;
if object_id('Team') is not null
    drop table Team;
if object_id('Game') is not null
    drop table Game;

Create Table Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName VARCHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    constraint PK_Team PRIMARY KEY (TeamID),
    constraint UQ_Team UNIQUE (TeamName)
);

Create Table Stadium (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName VARCHAR(50) NOT NULL,
    StadiumStreetAddress VARCHAR(50) NOT NULL,
    StadiumCity VARCHAR(50) NOT NULL,
    StadiumState CHAR(2) NOT NULL,
    StadiumCapacity INT NOT NULL,
    TypeOfField VARCHAR(50) NOT NULL,
    TeamID INT NOT NULL,
    constraint PK_Stadium PRIMARY KEY (StadiumID),
    constraint UQ_Stadium UNIQUE (StadiumName, StadiumCity, StadiumState),
    constraint CK_TypeOfField CHECK (TypeOfField IN ('Grass', 'Artificial Turf'))
);

CREATE table Game (
    GameID INT NOT NULL IDENTITY(1,1),
    name VARCHAR(100),
    GameDate Date NOT NULL,
    GameTime Time NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    HomeTeamID INT NULL,
    AwayTeamID INT NULL,
    WinnerTeamID INT NULL,
    StadiumID INT NOT NULL,
    constraint PK_Game PRIMARY KEY (GameID),
    constraint UQ_Game UNIQUE (HomeTeamID, GameDate, GameTime),
    constraint FK_Game_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID)
);

