-------------------------------------------------------------------------------------------------------------------------------------------------
-- champions
-------------------------------------------------------------------------------------------------------------------------------------------------

-- insert
INSERT INTO champions (id_champion, name, difficulty_level, ban_rate, pick_rate, win_rate, id_skill_P, id_skill_Q, id_skill_W, id_skill_E, id_skill_R)
VALUES (@id_champion, @name, @difficulty_level, @ban_rate, @pick_rate, @win_rate, @id_skill_P, @id_skill_Q, @id_skill_W, @id_skill_E, @id_skill_R);

-- update
UPDATE champions SET ban_rate = @ban_rate, pick_rate = @pick_rate, win_rate = @win_rate
WHERE champions.id_champion = @id_champion;

-- by id 
SELECT * FROM champions WHERE champions.id_champion = @id_champion;
DELETE FROM champions WHERE champions.id_champion = @id_champion;

-- id-name pairing 
SELECT id_champion, name FROM champions WHERE champions.id_champion = @id_champion;

-- non-foreign key attributes
SELECT champions.id_champion, champions.name, champions.difficulty_level, champions.ban_rate, champions.pick_rate, champions.win_rate
FROM champions
WHERE champions.id_champion = @id_champion;

-- non-foreign key attributes and skill names
SELECT champions.id_champion, champions.name, champions.difficulty_level, champions.ban_rate, champions.pick_rate, champions.win_rate,
skill_P.name, skill_Q.name, skill_W.name, skill_E.name, skill_R.name
FROM champions 
INNER JOIN skills AS skill_P ON skill_P.id_skill = champions.id_skill_P
INNER JOIN skills AS skill_Q ON skill_Q.id_skill = champions.id_skill_Q
INNER JOIN skills AS skill_W ON skill_W.id_skill = champions.id_skill_W
INNER JOIN skills AS skill_E ON skill_E.id_skill = champions.id_skill_E
INNER JOIN skills AS skill_R ON skill_R.id_skill = champions.id_skill_R
WHERE champions.id_champion = @id_champion;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- skills 
-------------------------------------------------------------------------------------------------------------------------------------------------

-- insert
INSERT INTO skills (name, description) VALUES (@name, @description);

-- by id
SELECT * FROM skills WHERE skills.id_skill = @id_skill;
DELETE FROM skills WHERE sklls.id_skill = @id_skill;

-- by name
SELECT * FROM skills WHERE skills.name = @skill_name;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- matches 
-------------------------------------------------------------------------------------------------------------------------------------------------

-- insert
INSERT INTO matches (id_team_red, id_team_blue, winning_team, match_duration_seconds)
VALUES (@id_team_red, @id_team_blue, @winning_team, @match_duration_seconds)

-- update
UPDATE matches SET id_team_red = @id_team_red, id_team_blue = @id_team_blue, winning_team = @winning_team, match_duration_seconds = @match_duration_seconds
WHERE matches.id_match = @id_match;

-- by id
SELECT * FROM matches WHERE matches.id_match = @id_match;
DELETE FROM matches WHERE matches.id_match = @id_match;

-- non-foreign key attributes
SELECT matches.id_match, matches.winning_team, matches.match_duration_seconds FROM matches WHERE matches.id_match = @id_match;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- teams 
-------------------------------------------------------------------------------------------------------------------------------------------------

-- insert
INSERT INTO teams (total_gold_earned, id_played_champion_1, id_played_champion_2, id_played_champion_3, id_played_champion_4, id_played_champion_5)
VALUES (@total_gold_earned, @id_played_champion_1, @id_played_champion_2, @id_played_champion_3, @id_played_champion_4, @id_played_champion_5)

-- update
UPDATE teams SET total_gold_earned = @total_gold_earned,
id_played_champion_1 = @id_played_champion_1, 
id_played_champion_2 = @id_played_champion_2, 
id_played_champion_3 = @id_played_champion_3, 
id_played_champion_4 = @id_played_champion_4, 
id_played_champion_5 = @id_played_champion_5
WHERE teams.id_team = @id_team;

-- by id
SELECT * FROM teams WHERE teams.id_team = @id_team;
DELETE FROM teams WHERE teams.id_team = @id_team;

--------------------------------------------------------------------------------------
-- non-foreign key attributes, champion names, and summoner names
SELECT teams.total_gold_earned, played_champions.id_played_champion, champions.name AS champion_name, summoners.name AS summoner_name FROM teams 
LEFT JOIN played_champions ON
    id_played_champion = id_played_champion_1 OR
    id_played_champion = id_played_champion_2 OR
    id_played_champion = id_played_champion_3 OR
    id_played_champion = id_played_champion_4 OR
    id_played_champion = id_played_champion_5
INNER JOIN champions ON champions.id_champion = played_champions.id_champion
INNER JOIN summoners ON summoners.id_summoner = played_champions.id_summoner
WHERE teams.id_team = @id_team;
--------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------
-- summoners 
-------------------------------------------------------------------------------------------------------------------------------------------------

-- insert
INSERT INTO summoners (id_summoner, name) VALUES (@id_summoner, @name);

-- update
UPDATE summoners SET name = @name WHERE summoners.id_summoner = @id_summoner;

-- by id
SELECT * FROM summoners WHERE summoners.id_summoner = @id_summoner;
DELETE FROM summoners WHERE summoners.id_summoner = @id_summoner;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- played_champions 
-------------------------------------------------------------------------------------------------------------------------------------------------

-- insert
INSERT INTO played_champions (id_champion, id_summoner) VALUES (@id_champion, @id_summoner);

-- update 
UPDATE played_champions SET id_champion = @id_champion, id_summoner = id_summoner WHERE played_champions.id_played_champion = @id_played_champion;

-- by id
SELECT * FROM played_champions WHERE played_champions.id_played_champion = @id_played_champion;
DELETE FROM played_champions WHERE played_champions.id_played_champion = @id_played_champion;