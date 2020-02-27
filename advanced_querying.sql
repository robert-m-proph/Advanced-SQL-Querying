/* Robert Propheter | Conditional Querying */

/*
This SELECT statement will display only four columns: all winning teams, team captains, 
match id, and game numbers that they won. It will not display teams if they did not win. 
The SELECT statement will sort the results by the winning team, match id, and game number 
in ascending order.
*/
SELECT RPAD(mg.winningteamid ||' '|| t.teamname,20) "Winning Team", 
        RPAD(t.captainid ||' '|| b.bowlerlastname,20) "Team Captain", 
        LPAD(mg.matchid,8) "Match ID", 
        mg.gamenumber "Game #"
    FROM match_games mg JOIN teams t ON mg.winningteamid = t.teamid
        JOIN bowlers b ON t.captainid = b.bowlerid
    WHERE mg.winningteamid = t.teamid
    ORDER BY "Winning Team", mg.matchid, mg.gamenumber;

/*
	This SELECT statement will display only five columns: the match ID, the team name, 
	bowler’s first and last name, game number they played in and the bowler’s game raw score. 
	The list will only include bowlers with the games they played but did not win and the 
	raw score higher than 190.
*/

SELECT LPAD(bs.matchid,5) "Match", RPAD(t.teamname,10) "Team Name", 
        RPAD(b.bowlerfirstname ||' '|| b.bowlerlastname,15) "Bowler Name", 
        bs.gamenumber "Game Number", 
		bs.rawscore "Raw Score"
    FROM bowler_scores bs JOIN bowlers b USING (bowlerid)
        JOIN teams t USING (teamid)
    WHERE wongame = 'N' AND rawscore > 190
    ORDER BY bs.matchid;

/*
	This SELECT statement will display two columns: bowler id, first name, last name, and raw 
	score. The SELECT statement will include the bowlers who had a raw score of 175 or better 
	at Imperial Lanes. The results will be sorted by raw score in descending order.
*/

SELECT RPAD(b.bowlerid ||' '|| bowlerfirstname ||' '|| bowlerlastname,20) "Bowler",
        rawscore "Raw Score"
    FROM bowlers b JOIN bowler_scores bs ON b.bowlerid = bs.bowlerid
        JOIN tourney_matches tm ON bs.matchid = tm.matchid
        JOIN tournaments t ON tm.tourneyid = t.tourneyid
    WHERE t.tourneylocation = 'Imperial Lanes' AND (rawscore >= 175)
    ORDER BY rawscore DESC;

/*
	This SELECT statement will display tournaments that have not been played yet. 
*/

SELECT t.tourneyid "Tourney ID", 
        RPAD(tourneydate,12) "Tourney Date", 
        RPAD(tourneylocation,20) "Location"
    FROM tournaments t LEFT OUTER JOIN tourney_matches tm
        ON tm.tourneyid = t.tourneyid
    WHERE tm.tourneyID IS NULL;

/*
	This SELECT statement displays two columns: bowlers and highest raw score for each bowler. 
	The query will sort the results by bowler in ascending order.
*/

SELECT RPAD(bowlerid ||' '|| bowlerfirstname ||' '|| bowlerlastname,25) "Bowler",
        MAX(rawscore) "Highest Raw Score"
    FROM bowler_scores JOIN bowlers USING (bowlerid)
    GROUP BY bowlerid, bowlerfirstname, bowlerlastname
    ORDER BY bowlerid;

/*
	This SELECT statement will display the handicap held by bowlers. Assume that the basis 
	score is 200 and the percentage factor is 90%. The handicap will be calculated by subtracting
	the average raw score from the basis score. The results will then be multiplied by the percentage 
	factor. The average raw score will be rounded in the calculation. The results will be displayed without any 
	decimal points. The results will be sorted by handicap in descending order.
*/

SELECT bowlerid "Bowler ID",  
        RPAD(bowlerfirstname ||' '|| bowlerlastname,20) "Bowler name", 
        RPAD(TO_CHAR((200-ROUND(AVG(rawscore),0))*0.9, '99'),8) "Handicap"
    FROM bowlers JOIN bowler_scores USING (bowlerid)
    GROUP BY bowlerid, RPAD(bowlerfirstname ||' '|| bowlerlastname,20)
    ORDER BY "Handicap" DESC;

/*
	This SELECT statement will display the bowlers whose highest raw scores are more than 20 
	points higher than their current average raw scores. The results will be sorted the by the 
	bowler name. 
*/

SELECT RPAD(bowlerfirstname ||' '|| bowlerlastname,25) "Bowler Name", 
        ROUND(AVG(rawscore),0) "Current Average", 
        MAX(rawscore) "High Score"
    FROM bowlers JOIN bowler_scores USING (bowlerid)
    GROUP BY bowlerid, RPAD(bowlerfirstname ||' '|| bowlerlastname,25)
        HAVING MAX(rawscore) > (AVG(rawscore)+20)
    ORDER BY RPAD(bowlerfirstname ||' '|| bowlerlastname,25);

/*
	This SELECT statement displays the bowler name and the average of the bowler’s raw scores for 
	bowlers whose average is greater than 155. The average raw scores are rounded. The results 
	will be sorted by the average scores in descending order and the bowler last and first names.
*/

SELECT RPAD(bowlerfirstname ||' '|| bowlerlastname,20) "Bowler Name", 
        ROUND(AVG(rawscore),0) "Avg. Raw Score"
    FROM bowlers JOIN bowler_scores USING (bowlerid)
    GROUP BY bowlerid, bowlerfirstname, bowlerlastname
    HAVING ROUND(AVG(rawscore),0) > 155
    ORDER BY "Avg. Raw Score" DESC, bowlerlastname, bowlerfirstname;

/*
	This SELECT statement will display each tournament id and name, the tournament location, match ID, 
	the name of each team, and the total of the handicap score for each team. The results will be sorted
	by tournament ID in ascending order and the total handicap score in descending order.
*/

SELECT RPAD(tourneyid ||' '|| tourneylocation,20) "Tournaments",
        matchid "Match ID", 
        RPAD(teamname,15) "Team Name", 
        TO_CHAR(SUM(handicapscore), '9,999') "Total Handicap Score"
    FROM tournaments JOIN tourney_matches USING (tourneyid)
        JOIN bowler_scores USING (matchid)
        JOIN bowlers USING (bowlerid)
        JOIN teams USING (teamid)
    GROUP BY tourneyid, matchid, teamname, tourneylocation
    ORDER BY tourneyid, "Total Handicap Score" DESC;

/*
	This SELECT statement will return all bowlers whose address contains “Harvard” or “Drive”. The results 
	will be sorted in descending order by the last name and first name. 
*/

SELECT RPAD(bowlerfirstname,10) "First Name",
        RPAD(bowlerlastname,15) "Last Name", 
        RPAD(bowleraddress,25) "Address", 
        RPAD(bowlercity,15) "City", 
        RPAD(bowlerzip,7) "Zipcode",
        bowlerphonenumber "Phone Number"
    FROM bowlers
    WHERE bowleraddress LIKE '%Harvard%' 
        OR bowleraddress LIKE '%Drive%'
    ORDER BY bowlerlastname DESC, bowlerfirstname DESC;