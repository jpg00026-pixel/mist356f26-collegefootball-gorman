
/*
CREATE LOGIN NandaSurendra
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER NandaSurendra
FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;
*/
if object_id('CoachRoster', 'U') is not null drop table CoachRoster;
if object_id('WeeklyPredictionResults', 'U') is not null drop table WeeklyPredictionResults;
if object_id('GamePrediction', 'U') is not null drop table GamePrediction;
if object_id('Coach', 'U') is not null drop table Coach;
if object_id('ReturnerStats', 'U') is not null drop table ReturnerStats;
if object_id('PunterStats', 'U') is not null drop table PunterStats;
if object_id('KickerStats', 'U') is not null drop table KickerStats;
if object_id('DefenderStats', 'U') is not null drop table DefenderStats;
if object_id('RBStats', 'U') is not null drop table RBStats;
if object_id('QBStats', 'U') is not null drop table QBStats;
if object_id('PlayerStats', 'U') is not null drop table PlayerStats;
if object_id('Player', 'U') is not null drop table Player;
if object_id('Roster', 'U') is not null drop table Roster;
if object_id('AppUser', 'U') is not null drop table AppUser;
if object_id('Game', 'U') is not null drop table Game;
if object_id('Stadium', 'U') is not null drop table Stadium;
if object_id('Team', 'U') is not null drop table Team;
go

Create Table Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName VARCHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    constraint PK_Team PRIMARY KEY (TeamID),
    constraint UQ_Team UNIQUE (TeamName)
);
go

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
go

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
go

Create Table Roster(
    RosterID INT NOT NULL IDENTITY(1,1),
    RosterYear INT NOT NULL,
    TeamID INT NOT NULL,
    constraint PK_Roster PRIMARY KEY (RosterID),
    constraint UQ_Roster_Team_Year UNIQUE (TeamID, Year),
    constraint FK_Roster_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);
go

Create Table Player(
    PlayerID INT IDENTITY(1,1) NOT NULL,
    PlayerName VARCHAR(50) NOT NULL,
    PlayerDOB DATE NOT NULL,
    constraint PK_Player PRIMARY KEY (PlayerID),
    constraint UQ_PlayerName UNIQUE (PlayerName, PlayerDOB)
);
go

Create table Position (
    PositionID INT NOT NULL IDENTITY(1,1),
    PositionName CHAR(50) NOT NULL,
    constraint PK_Position PRIMARY KEY (PositionID),
    constraint UQ_Position UNIQUE (PositionName),
    constraint CK_PositionName CHECK (PositionName IN ('QB', 'RB', 'WR', 'TE', 'OL', 'DL', 'LB', 'CB', 'S', 'K', 'P', 'KR', 'PR'));


)

Create Table PlayerStats (
    PlayerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    foreign key (PlayerID) references Player(PlayerID),
    foreign key (RosterID) references Roster(RosterID),
    constraint PK_PlayerStats PRIMARY KEY (PlayerStatsID),
    constraint PK_PlayerStats UNIQUE (PlayerID, RosterID),
);
go

Create Table QBStats (
    QBStatsID INT NOT NULL,
    RosterID INT NOT NULL,
    PassingCompletions INT NULL,
    PassingAttempts INT NULL,
    PassingYards INT NULL,
    PassingTouchdowns INT NULL,
    Interceptions INT NULL,
    SacksTaken INT NULL,
    constraint PK_QBStats PRIMARY KEY (QBStatsID),
    constraint FK_QBStats_PlayerStats FOREIGN KEY (PlayerStatsID);
    --REFERENCES PlayerStats(PlayerStatsID)
go

Create Table RBStats (
    RBStatsID INT NOT NULL,
    RosterID INT NOT NULL,
    RushingAttempts INT NULL,
    RushingYards INT NULL,
    RushingTouchdowns INT NULL,
    Receptions INT NULL,
    ReceivingYards INT NULL,
    ReceivingTouchdowns INT NULL,
    Fumbles INT NULL,
    constraint PK_RBStats PRIMARY KEY (RBStatsID),
    constraint FK_RBStats_PlayerStats FOREIGN KEY (RBStatsID) 
    --REFERENCES PlayerStats(PlayerStatsID)
);
go

Create Table DefenderStats (
    DefenderStatsID INT NOT NULL,
    RosterID INT NOT NULL,
    TotalTackles DECIMAL(5,1) NULL,
    Sacks DECIMAL(4,1) NULL,
    Interceptions INT NULL,
    PassBreakups INT NULL,
    ForcedFumbles INT NULL,
    FumbleRecoveries INT NULL,
    PassesDefended INT NULL,
    DefensiveTouchdowns INT NULL,
    constraint PK_DefenderStats PRIMARY KEY (DefenderStatsID),
    constraint FK_DefenderStats_PlayerStats FOREIGN KEY (DefenderStatsID) 
    --REFERENCES PlayerStats(PlayerStatsID)
);
go

Create Table ReturnerStats (
    ReturnerStatsID INT NOT NULL,
    RosterID INT NOT NULL,
    KickReturns INT NULL,
    KickReturnYards INT NULL,
    KickReturnTouchdowns INT NULL,
    PuntReturns INT NULL,
    PuntReturnYards INT NULL,
    PuntReturnTouchdowns INT NULL,
    constraint PK_ReturnerStats PRIMARY KEY (ReturnerStatsID),
    constraint FK_ReturnerStats_PlayerStats FOREIGN KEY (ReturnerStatsID) 
    --REFERENCES PlayerStats(PlayerStatsID)
);
go

Create Table KickerStats (
    KickerStatsID INT NOT NULL,
    RosterID INT NOT NULL,
    FieldGoalsMade INT NULL,
    FieldGoalsAttempted INT NULL,
    ExtraPointsMade INT NULL,
    ExtraPointsAttempted INT NULL,
    constraint PK_KickerStats PRIMARY KEY (KickerStatsID),
    constraint FK_KickerStats_PlayerStats FOREIGN KEY (KickerStatsID) 
    --REFERENCES PlayerStats(PlayerStatsID)
);
go

Create Table PunterStats (
    PunterStatsID INT NOT NULL,
    RosterID INT NOT NULL,
    Punts INT NULL,
    PuntYards INT NULL,
    LongestPunt INT NULL,
    YardsPerPunt DECIMAL(3,1) NULL,
    constraint PK_PunterStats PRIMARY KEY (PunterStatsID),
    constraint FK_PunterStats_PlayerStats FOREIGN KEY (PunterStatsID) 
    --REFERENCES PlayerStats(PlayerStatsID)
);
go

Create Table AppUser (
    AppUserID INT NOT NULL IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    constraint PK_AppUser PRIMARY KEY (AppUserID),
    constraint UQ_AppUser_Email UNIQUE (Email)
);
go

Create Table Coach (
    CoachID INT NOT NULL IDENTITY(1,1),
    CoachName VARCHAR(100) NOT NULL,
    constraint PK_Coach PRIMARY KEY (CoachID)
);
go

Create Table GamePrediction (
    GamePredictionID INT NOT NULL IDENTITY(1,1),
    PredictionDateTime DATETIME2 NOT NULL,
    AppUserID INT NOT NULL,
    GameID INT NOT NULL,
    constraint PK_GamePrediction PRIMARY KEY (GamePredictionID),
    constraint FK_GamePrediction_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
    constraint FK_GamePrediction_Game FOREIGN KEY (GameID) REFERENCES Game(GameID)
);
go

Create Table WeeklyPredictionResults (
    WPRID INT NOT NULL IDENTITY(1,1),
    StartDate DATE NOT NULL,
    NumberOfCorrectPredictions INT NOT NULL,
    AppUserID INT NOT NULL,
    constraint PK_WeeklyPredictionResults PRIMARY KEY (WPRID),
    constraint FK_WeeklyPredictionResults_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
);
go

