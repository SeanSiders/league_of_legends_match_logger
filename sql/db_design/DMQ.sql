---------------------------------------------------------------------------
-- CHAMPIONS
---------------------------------------------------------------------------

-- Get all champions by id and the names of their skills
SELECT champions.id_champion, champions.name, champions.difficulty_level, champions.ban_rate, champions.pick_rate, champions.win_rate,
skill_P.name AS P, skill_Q.name AS Q, skill_W.name AS W, skill_E.name AS E, skill_R.name AS R
FROM champions 
INNER JOIN skills AS skill_P ON skill_P.id_skill = champions.id_skill_P
INNER JOIN skills AS skill_Q ON skill_Q.id_skill = champions.id_skill_Q
INNER JOIN skills AS skill_W ON skill_W.id_skill = champions.id_skill_W
INNER JOIN skills AS skill_E ON skill_E.id_skill = champions.id_skill_E
INNER JOIN skills AS skill_R ON skill_R.id_skill = champions.id_skill_R;

-- Get the id and name of all champions
SELECT champions.id_champion, champions.name FROM champions;

-- Get a champion and the names of its skills by id
SELECT champions.id_champion, champions.name, champions.difficulty_level, champions.ban_rate, champions.pick_rate, champions.win_rate,
skill_P.name AS P, skill_Q.name AS Q, skill_W.name AS W, skill_E.name AS E, skill_R.name AS R,
skill_P.description AS P_desc, skill_Q.description AS Q_desc, skill_W.description AS W_desc, skill_E.description AS E_desc, skill_R.description AS R_desc
FROM champions 
INNER JOIN skills AS skill_P ON skill_P.id_skill = champions.id_skill_P
INNER JOIN skills AS skill_Q ON skill_Q.id_skill = champions.id_skill_Q
INNER JOIN skills AS skill_W ON skill_W.id_skill = champions.id_skill_W
INNER JOIN skills AS skill_E ON skill_E.id_skill = champions.id_skill_E
INNER JOIN skills AS skill_R ON skill_R.id_skill = champions.id_skill_R
WHERE champions.id_champion = :id_champion
LIMIT 1;

-- Create a new champion
INSERT INTO champions 
(id_champion, name, difficulty_level, ban_rate, pick_rate, win_rate, id_skill_P, id_skill_Q, id_skill_W, id_skill_E, id_skill_R)
VALUES (
    :champion.name,
    :champion.name,
    :champion.difficulty_level,
    :champion.ban_rate,
    :champion.pick_rate,
    :champion.win_rate,
    :champion.id_skill_P,
    :champion.id_skill_Q,
    :champion.id_skill_W,
    :champion.id_skill_E,
    :champion.id_skill_R
);

-- Update a champion
UPDATE champions SET
difficulty_level = :champion.difficulty_level,
ban_rate = :champion.ban_rate,
pick_rate = :champion.pick_rate,
win_rate = :champion.win_rate
WHERE champions.id_champion = :champion.id_champion;

-- Delete a champion
DELETE FROM champions WHERE id_champion = :id_champion;

---------------------------------------------------------------------------
-- SKILLS 
---------------------------------------------------------------------------

-- Create a skill
INSERT INTO skills (id_skill, name, description)
VALUES (:skill.name, :skill.name, :skill.description);

---------------------------------------------------------------------------
-- SUMMONERS 
---------------------------------------------------------------------------

-- True if the summoner already exists
SELECT id_summoner FROM summoners WHERE id_summoner = :riotID;

-- Create or update a summoner
INSERT INTO summoners (id_summoner, name) VALUES (:riotID, :summonerName)
ON DUPLICATE KEY UPDATE name = :summonerName;

-- Get all summoners
SELECT id_summoner, name FROM summoners;

-- Get a summoners name
SELECT name FROM summoners WHERE id_summoner = :id_summ;

-- Get a summoners champion
SELECT champions.name FROM champions 
INNER JOIN played_champions on played_champions.id_champion = champions.id_champion
INNER JOIN summoners on summoners.id_summoner = played_champions.id_summoner
WHERE summoners.id_summoner = :id_summ;


---------------------------------------------------------------------------
-- PLAYED CHAMPIONS 
---------------------------------------------------------------------------

-- Get a played champion
-- This consists of the champion and summoners id and name
SELECT 
played_champions.id_played_champion,
champions.id_champion,
champions.name AS champion_name,
summoners.id_summoner,
summoners.name AS summoner_name
FROM played_champions
INNER JOIN champions ON champions.id_champion = played_champions.id_champion
INNER JOIN summoners ON summoners.id_summoner = played_champions.id_summoner
WHERE id_played_champion = :id_played_champion;

-- Create a played champion
INSERT INTO played_champions (id_champion, id_summoner) VALUES (:playedChampon.id_champion, :playedChampon.id_summoner);

---------------------------------------------------------------------------
-- MATCHES 
---------------------------------------------------------------------------

-- Get all matches
SELECT * FROM matches;

-- Get a summoners last played match
SELECT * FROM matches
INNER JOIN teams ON 
(teams.id_team = matches.id_team_red OR teams.id_team = matches.id_team_blue)
    INNER JOIN played_champions ON (
        played_champions.id_played_champion = teams.id_played_champion_1 OR
        played_champions.id_played_champion = teams.id_played_champion_2 OR
        played_champions.id_played_champion = teams.id_played_champion_3 OR
        played_champions.id_played_champion = teams.id_played_champion_4 OR
        played_champions.id_played_champion = teams.id_played_champion_5
    ) 
        INNER JOIN summoners ON 
        summoners.id_summoner = played_champions.id_summoner AND
        summoners.id_summoner = :id_summoner
ORDER BY id_match DESC LIMIT 1;

-- Get a match
SELECT * FROM matches WHERE id_match = :id_match;

-- Create a match
INSERT INTO matches (id_team_red, id_team_blue, winning_team, match_duration_seconds)
VALUES (:match.id_team_red, :match.id_team_blue, :match.winning_team, :match.match_duration_seconds);

-- Update a match
UPDATE matches SET
winning_team = :match.winning_team,
match_duration_seconds = :match.match_duration_seconds
WHERE id_match = :match.id_match;

-- Delete a match
DELETE FROM matches WHERE id_match = :id_match;

---------------------------------------------------------------------------
-- TEAMS
---------------------------------------------------------------------------

-- Get a team
SELECT * FROM teams WHERE teams.id_team = :id_team;

-- Create a team
INSERT INTO teams (total_gold_earned, id_played_champion_1, id_played_champion_2, id_played_champion_3, id_played_champion_4, id_played_champion_5)
VALUES (:team.total_gold_earned, :team.id_played_champion_1, :team.id_played_champion_2, :team.id_played_champion_3, :team.id_played_champion_4, :team.id_played_champion_5),