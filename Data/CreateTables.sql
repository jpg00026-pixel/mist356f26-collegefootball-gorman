
/*
CREATE LOGIN NandaSurendra
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER NandaSurendra
FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;
*/
if object_id('dbo.QBStats', 'U') is not null
    drop table dbo.QBStats;
if object_id('dbo.RBStats', 'U') is not null
    drop table dbo.RBStats;
if object_id('dbo.DefenderStats', 'U') is not null
    drop table dbo.DefenderStats;
if object_id('dbo.ReturnerStats', 'U') is not null
    drop table dbo.ReturnerStats;
if object_id('dbo.KickerStats', 'U') is not null
    drop table dbo.KickerStats;
if object_id('dbo.PunterStats', 'U') is not null
    drop table dbo.PunterStats;
if object_id('dbo.PlayerStats', 'U') is not null
    drop table dbo.PlayerStats;
if object_id('dbo.Player', 'U') is not null
    drop table dbo.Player;
if object_id('dbo.Roster', 'U') is not null
    drop table dbo.Roster;
if object_id('dbo.Game', 'U') is not null
    drop table dbo.Game;
if object_id('dbo.Stadium', 'U') is not null
    drop table dbo.Stadium;
if object_id('dbo.Team', 'U') is not null
    drop table dbo.Team;

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

Create Table Roster (
    RosterID INT NOT NULL IDENTITY(1,1),
    Year INT NOT NULL,
    TeamID INT NOT NULL,
    constraint PK_Roster PRIMARY KEY (RosterID),
    constraint UQ_Roster_Team_Year UNIQUE (TeamID, Year),
    constraint FK_Roster_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

Create Table Player(
    PlayerID INT NOT NULL IDENTITY(1,1),
    PlayerFirstName VARCHAR(50) NOT NULL,
    PlayerLastName VARCHAR(50) NOT NULL,
    PlayerDOB DATE NOT NULL,
    constraint PK_Player PRIMARY KEY (PlayerID)
);

Create Table PlayerStats (
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    constraint PK_PlayerStats PRIMARY KEY (PlayerID, RosterID),
    constraint FK_PlayerStats_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    constraint FK_PlayerStats_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID)
);

Create Table QBStats (
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    PassingCompletions INT NULL,
    PassingAttempts INT NULL,
    PassingYards INT NULL,
    PassingTouchdowns INT NULL,
    Interceptions INT NULL,
    SacksTaken INT NULL,
    constraint PK_QBStats PRIMARY KEY (PlayerID, RosterID),
    constraint FK_QBStats_PlayerStats FOREIGN KEY (PlayerID, RosterID)
        REFERENCES PlayerStats(PlayerID, RosterID)
);

Create Table RBStats (
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    RushingAttempts INT NULL,
    RushingYards INT NULL,
    RushingTouchdowns INT NULL,
    Receptions INT NULL,
    ReceivingYards INT NULL,
    ReceivingTouchdowns INT NULL,
    Fumbles INT NULL,
    constraint PK_RBStats PRIMARY KEY (PlayerID, RosterID),
    constraint FK_RBStats_PlayerStats FOREIGN KEY (PlayerID, RosterID)
    REFERENCES PlayerStats(PlayerID, RosterID)
);

Create Table DefenderStats (
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    TotalTackles DECIMAL(5,1) NULL,
    Sacks DECIMAL(4,1) NULL,
    Interceptions INT NULL,
    ForcedFumbles INT NULL,
    FumbleRecoveries INT NULL,
    PassesDefended INT NULL,
    DefensiveTouchdowns INT NULL,
    constraint PK_DefenderStats PRIMARY KEY (PlayerID, RosterID),
    constraint FK_DefenderStats_PlayerStats FOREIGN KEY (PlayerID, RosterID)
    REFERENCES PlayerStats(PlayerID, RosterID)
);

Create Table ReturnerStats (
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    KickReturns INT NULL,
    KickReturnYards INT NULL,
    KickReturnTouchdowns INT NULL,
    PuntReturns INT NULL,
    PuntReturnYards INT NULL,
    PuntReturnTouchdowns INT NULL,
    constraint PK_ReturnerStats PRIMARY KEY (PlayerID, RosterID),
    constraint FK_ReturnerStats_PlayerStats FOREIGN KEY (PlayerID, RosterID)
    REFERENCES PlayerStats(PlayerID, RosterID)
);

Create Table KickerStats (
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    FieldGoalsMade INT NULL,
    FieldGoalsAttempted INT NULL,
    ExtraPointsMade INT NULL,
    ExtraPointsAttempted INT NULL,
    constraint PK_KickerStats PRIMARY KEY (PlayerID, RosterID),
    constraint FK_KickerStats_PlayerStats FOREIGN KEY (PlayerID, RosterID)
    REFERENCES PlayerStats(PlayerID, RosterID)
);

Create Table PunterStats (
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    Punts INT NULL,
    PuntYards INT NULL,
    LongestPunt INT NULL,
    PuntsInside20 INT NULL,
    constraint PK_PunterStats PRIMARY KEY (PlayerID, RosterID),
    constraint FK_PunterStats_PlayerStats FOREIGN KEY (PlayerID, RosterID)
    REFERENCES PlayerStats(PlayerID, RosterID)
);