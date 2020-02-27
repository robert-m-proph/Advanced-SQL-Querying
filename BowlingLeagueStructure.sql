

-- DROP TABLES FIRST 
DROP TABLE teams CASCADE CONSTRAINTS;
DROP TABLE bowlers CASCADE CONSTRAINTS;
DROP TABLE bowler_scores CASCADE CONSTRAINTS;
DROP TABLE bowler_scores_archive CASCADE CONSTRAINTS;
DROP TABLE match_games CASCADE CONSTRAINTS;
DROP TABLE match_games_archive CASCADE CONSTRAINTS;
DROP TABLE tournaments CASCADE CONSTRAINTS;
DROP TABLE tournaments_archive CASCADE CONSTRAINTS;
DROP TABLE tourney_matches CASCADE CONSTRAINTS;
DROP TABLE tourney_matches_archive CASCADE CONSTRAINTS;


-- CREATE BOWLING DATABASE

CREATE TABLE Bowler_Scores
(
	MatchID number(3,0) NOT NULL,
	GameNumber number(3,0) NOT NULL,
	BowlerID number(3,0) NOT NULL,
	RawScore number(3,0),
	HandiCapScore number(3,0),
	WonGame char(1) check (wongame in ('Y', 'N')) 
);

CREATE TABLE Bowler_Scores_Archive
(
	MatchID number(3,0) NOT NULL,
	GameNumber number(3,0) NOT NULL,
	BowlerID number(3,0) NOT NULL,
	RawScore number(3,0),
	HandiCapScore number(3,0),
	WonGame char(1) check (wongame in ('Y', 'N')) 
);

CREATE TABLE Bowlers (
	BowlerID number(3,0) NOT NULL PRIMARY KEY ,
	BowlerLastName varchar2 (50) NOT NULL ,
	BowlerFirstName varchar2 (50) NOT NULL ,
	BowlerMiddleInit varchar2 (1),
	BowlerAddress varchar2 (50),
	BowlerCity varchar2 (50),
	BowlerState varchar2 (2),
	BowlerZip varchar2 (10),
	BowlerPhoneNumber varchar2 (14),
	TeamID number(3,0),
	BowlerTotalPins number(5,0) DEFAULT 0,
	BowlerGamesBowled number(5,0) DEFAULT 0 ,
	BowlerCurrentAverage number(3,0) DEFAULT 0 ,
	BowlerCurrentHcp number(3,0) DEFAULT 0 
);


CREATE TABLE Match_Games (
	MatchID number(3,0) NOT NULL,
	GameNumber number(3,0) NOT NULL,
	WinningTeamID number(3,0) 
);

CREATE TABLE Match_Games_Archive (
	MatchID number(3,0) NOT NULL,
	GameNumber number(3,0) NOT NULL,
	WinningTeamID number(3,0) 
);

CREATE TABLE Teams (
	TeamID number(3,0) PRIMARY KEY ,
	TeamName varchar2(50) NOT NULL ,
	CaptainID number(3,0) 
);

CREATE TABLE Tournaments (
	TourneyID number(3,0) PRIMARY KEY ,
	TourneyDate date,
	TourneyLocation varchar2(50) 
);

CREATE TABLE Tournaments_Archive (
	TourneyID number(3,0) PRIMARY KEY ,
	TourneyDate date,
	TourneyLocation varchar2(50)
);

CREATE TABLE Tourney_Matches (
	MatchID number(3,0) PRIMARY KEY ,
	TourneyID number(3,0),
	Lanes varchar2(5),
	OddLaneTeamID number(3,0),
	EvenLaneTeamID number(3,0) 
);

CREATE TABLE Tourney_Matches_Archive (
	MatchID number(3,0) PRIMARY KEY ,
	TourneyID number(3,0),
	Lanes varchar2(5),
	OddLaneTeamID number(3,0),
	EvenLaneTeamID number(3,0) 
);

----------------------------------------------------
ALTER TABLE Bowler_Scores ADD 
	CONSTRAINT Bowler_Scores_PK PRIMARY KEY   
	(
		MatchID,
		GameNumber,
		BowlerID
	)   ;

CREATE  INDEX BowlerID ON Bowler_Scores(BowlerID) ;

CREATE  INDEX MatchGamesBowlerScores ON Bowler_Scores(MatchID, GameNumber) ;

ALTER TABLE Bowler_Scores_Archive ADD 
	CONSTRAINT Bowler_Scores_Archive_PK PRIMARY KEY 
	(
		MatchID,
		GameNumber,
		BowlerID
	)  ;

CREATE  INDEX BowlerID_Arch ON Bowler_Scores_Archive(BowlerID);

CREATE  INDEX MatchGamesBowlerScores_Arch ON Bowler_Scores_Archive(MatchID, GameNumber);

CREATE  INDEX BowlerLastName ON Bowlers(BowlerLastName) ;

CREATE  INDEX BowlersTeamID ON Bowlers(TeamID) ;

ALTER TABLE Match_Games ADD 
	CONSTRAINT Match_Games_PK PRIMARY KEY   
	(
		MatchID,
		GameNumber
	)   ;

CREATE  INDEX Team_ID ON Match_Games(WinningTeamID) ;

CREATE  INDEX TourneyMatchesMatchGames ON Match_Games(MatchID) ;

ALTER TABLE Match_Games_Archive ADD 
	CONSTRAINT Match_Games_Archive_PK PRIMARY KEY  
	(
		MatchID,
		GameNumber
	)  ;

CREATE  INDEX Team_ID_Arch ON Match_Games_Archive(WinningTeamID);

CREATE  INDEX TourneyMatchesMatchGames_Arch ON Match_Games_Archive(MatchID);

CREATE  INDEX TeamsTourney_Matches_Even ON Tourney_Matches(EvenLaneTeamID) ;

CREATE  INDEX TeamsTourneyMatches_Odd ON Tourney_Matches(OddLaneTeamID) ;

CREATE  INDEX TourneyMatchesTourneyID ON Tourney_Matches(TourneyID) ;

CREATE  INDEX TeamsTourneyMatches_Odd_Arch ON Tourney_Matches_Archive(OddLaneTeamID);

CREATE  INDEX TeamsTourney_Matches_Even_Arch ON Tourney_Matches_Archive(EvenLaneTeamID);

CREATE  INDEX TourneyID ON Tourney_Matches_Archive(TourneyID);


ALTER TABLE Bowler_Scores
	ADD CONSTRAINT Bowler_Scores_FK00 FOREIGN KEY (BowlerID) REFERENCES Bowlers (BowlerID);

ALTER TABLE Bowler_Scores
	ADD CONSTRAINT Bowler_Scores_FK01 FOREIGN KEY (MatchID,	GameNumber) REFERENCES Match_Games (MatchID,GameNumber);

ALTER TABLE Bowler_Scores_Archive
  	ADD CONSTRAINT Bowler_Scores_Archive_FK00 FOREIGN KEY (MatchID, GameNumber) REFERENCES Match_Games_Archive (MatchID, GameNumber);

ALTER TABLE Bowlers
  	ADD CONSTRAINT Bowlers_FK00 FOREIGN KEY (TeamID) REFERENCES Teams (TeamID);

ALTER TABLE Match_Games
	ADD CONSTRAINT Match_Games_FK00 FOREIGN KEY (MatchID) REFERENCES Tourney_Matches (MatchID);

ALTER TABLE Match_Games_Archive
	ADD CONSTRAINT Match_Games_Archive_FK00 FOREIGN KEY (MatchID) REFERENCES Tourney_Matches_Archive (MatchID);

ALTER TABLE Tourney_Matches
	ADD CONSTRAINT Tourney_Matches_FK00 FOREIGN KEY	(EvenLaneTeamID) REFERENCES Teams (TeamID);

ALTER TABLE Tourney_Matches
	ADD CONSTRAINT Tourney_Matches_FK01 FOREIGN KEY (OddLaneTeamID) REFERENCES Teams (TeamID);

ALTER TABLE Tourney_Matches
	ADD CONSTRAINT Tourney_Matches_FK02 FOREIGN KEY (TourneyID) REFERENCES Tournaments (TourneyID);

ALTER TABLE Tourney_Matches_Archive
	ADD CONSTRAINT Tourney_Matches_Archive_FK00 FOREIGN KEY (TourneyID) REFERENCES Tournaments_Archive (TourneyID);


