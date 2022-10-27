-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Table skills
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS skills (
  id_skill INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  description VARCHAR(500) NOT NULL,
  PRIMARY KEY (id_skill),
  UNIQUE INDEX name_UNIQUE (name ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table champions
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS champions (
  id_champion VARCHAR(45) NOT NULL,
  name VARCHAR(45) NOT NULL,
  difficulty_level VARCHAR(10) NOT NULL,
  ban_rate DECIMAL(5,2) NOT NULL,
  pick_rate DECIMAL(5,2) NOT NULL,
  win_rate DECIMAL(5,2) NOT NULL,
  id_skill_P INT NOT NULL,
  id_skill_Q INT NOT NULL,
  id_skill_W INT NOT NULL,
  id_skill_E INT NOT NULL,
  id_skill_R INT NOT NULL,
  PRIMARY KEY (id_champion),
  INDEX fk_skill_P (id_skill_P ASC) VISIBLE,
  INDEX fk_skill_Q (id_skill_Q ASC) VISIBLE,
  INDEX fk_skill_W (id_skill_W ASC) VISIBLE,
  INDEX fk_skill_E (id_skill_E ASC) VISIBLE,
  INDEX fk_skill_R (id_skill_R ASC) VISIBLE,
  UNIQUE INDEX name_UNIQUE (name ASC) VISIBLE,
  CONSTRAINT fk_champions_skills1
    FOREIGN KEY (id_skill_P)
    REFERENCES skills (id_skill)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT fk_champions_skills2
    FOREIGN KEY (id_skill_Q)
    REFERENCES skills (id_skill)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT fk_champions_skills3
    FOREIGN KEY (id_skill_W)
    REFERENCES skills (id_skill)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT fk_champions_skills4
    FOREIGN KEY (id_skill_E)
    REFERENCES skills (id_skill)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT fk_champions_skills5
    FOREIGN KEY (id_skill_R)
    REFERENCES skills (id_skill)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table summoners
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS summoners (
  id_summoner VARCHAR(45) NOT NULL,
  name VARCHAR(100) NULL,
  PRIMARY KEY (id_summoner))
ENGINE = InnoDB
DEFAULT CHARACTER SET = DEFAULT;


-- -----------------------------------------------------
-- Table played_champions
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS played_champions (
  id_played_champion INT NOT NULL AUTO_INCREMENT,
  id_champion VARCHAR(45) NOT NULL,
  id_summoner VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_played_champion),
  INDEX fk_champion (id_champion ASC) VISIBLE,
  INDEX fk_summoner (id_summoner ASC) VISIBLE,
  CONSTRAINT fk_id_champion
    FOREIGN KEY (id_champion)
    REFERENCES champions (id_champion)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT fk_played_champions_summoners1
    FOREIGN KEY (id_summoner)
    REFERENCES summoners (id_summoner)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table teams
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS teams (
  id_team INT NOT NULL AUTO_INCREMENT,
  total_gold_earned INT NULL,
  id_played_champion_1 INT NULL,
  id_played_champion_2 INT NULL,
  id_played_champion_3 INT NULL,
  id_played_champion_4 INT NULL,
  id_played_champion_5 INT NULL,
  PRIMARY KEY (id_team),
  INDEX fk_played_champion_1 (id_played_champion_1 ASC) VISIBLE,
  INDEX fk_played_champion_2 (id_played_champion_2 ASC) VISIBLE,
  INDEX fk_played_champion_3 (id_played_champion_3 ASC) VISIBLE,
  INDEX fk_played_champion_4 (id_played_champion_4 ASC) VISIBLE,
  INDEX fk_played_champion_5 (id_played_champion_5 ASC) VISIBLE,
  CONSTRAINT fk_teams_played_champions1
    FOREIGN KEY (id_played_champion_1)
    REFERENCES played_champions (id_played_champion)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT fk_teams_played_champions2
    FOREIGN KEY (id_played_champion_2)
    REFERENCES played_champions (id_played_champion)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT fk_teams_played_champions3
    FOREIGN KEY (id_played_champion_3)
    REFERENCES played_champions (id_played_champion)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT fk_teams_played_champions4
    FOREIGN KEY (id_played_champion_4)
    REFERENCES played_champions (id_played_champion)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT fk_teams_played_champions5
    FOREIGN KEY (id_played_champion_5)
    REFERENCES played_champions (id_played_champion)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table matches
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS matches (
  id_match INT NOT NULL AUTO_INCREMENT,
  id_team_red INT NOT NULL,
  id_team_blue INT NOT NULL,
  winning_team VARCHAR(4) NOT NULL,
  match_duration_seconds INT NOT NULL,
  PRIMARY KEY (id_match),
  INDEX fk_team_red (id_team_red ASC) VISIBLE,
  INDEX fk_team_blue (id_team_blue ASC) VISIBLE,
  CONSTRAINT fk_real_match_info_teams1
    FOREIGN KEY (id_team_red)
    REFERENCES teams (id_team)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT fk_real_match_info_teams2
    FOREIGN KEY (id_team_blue)
    REFERENCES teams (id_team)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-------------------------------------------------------------------------------------------------------------------------------------------------
-- LEAGUE OF LEGENDS STATIC GAME DATA
-------------------------------------------------------------------------------------------------------------------------------------------------

-- CHAMPIONS 
-- https://www.leagueoflegends.com/en-us/champions/

-- AATROX
INSERT INTO skills (name, description)
VALUES
('Deathbringer Stance', 'Periodically, Aatrox''s next basic attack deals bonus physical damage and heals him, based on the target''s max health.'),
('The Darkin Blade', 'Aatrox slams his greatsword down, dealing physical damage. He can swing three times, each with a different area of effect.'),
('Infernal Chains', 'Aatrox smashes the ground, dealing damage to the first enemy hit. Champions and large monsters have to leave the impact area quickly or they will be dragged to the center and take the damage again.'),
('Umbral Dash', 'Passively, Aatrox heals when damaging enemy champions. On activation, he dashes in a direction.'),
('World Ender', 'Aatrox unleashes his demonic form, fearing nearby enemy minions and gaining attack damage, increased healing, and Move Speed. If he gets a takedown, this effect is extended.');

INSERT INTO champions (id_champion, name, difficulty_level, ban_rate, pick_rate, win_rate, id_skill_P, id_skill_Q, id_skill_W, id_skill_E, id_skill_R)
VALUES (
    'aatrox',
    'Aatrox', 
    'moderate', 
    0.00, 
    0.00, 
    0.00,
    (SELECT id_skill FROM skills WHERE name = 'Deathbringer Stance'),
    (SELECT id_skill FROM skills WHERE name = 'The Darkin Blade'),
    (SELECT id_skill FROM skills WHERE name = 'Infernal Chains'),
    (SELECT id_skill FROM skills WHERE name = 'Umbral Dash'),
    (SELECT id_skill FROM skills WHERE name = 'World Ender')
);

-- AHRI
INSERT INTO skills (name, description)
VALUES
('Essence Theft', 'After killing 9 minions or monsters, Ahri heals. After taking down an enemy champion, Ahri heals for a greater amount.'),
('Orb of Deception', 'Ahri sends out and pulls back her orb, dealing magic damage on the way out and true damage on the way back.'),
('Fox-Fire', 'Ahri gains a brief burst of Move Speed and releases three fox-fires, that lock onto and attack nearby enemies.'),
('Charm', 'Ahri blows a kiss that damages and charms an enemy it encounters, instantly stopping movement abilities and causing them to walk harmlessly towards her.'),
('Spirit Rush', 'Ahri dashes forward and fires essence bolts, damaging nearby enemies. Spirit Rush can be cast up to three times before going on cooldown, and gains additional recasts when taking down enemy champions.');

INSERT INTO champions (id_champion, name, difficulty_level, ban_rate, pick_rate, win_rate, id_skill_P, id_skill_Q, id_skill_W, id_skill_E, id_skill_R)
VALUES (
    'ahri',
    'Ahri', 
    'moderate', 
    0.00, 
    0.00, 
    0.00,
    (SELECT id_skill FROM skills WHERE name = 'Essence Theft'),
    (SELECT id_skill FROM skills WHERE name = 'Orb of Deception'),
    (SELECT id_skill FROM skills WHERE name = 'Fox-Fire'),
    (SELECT id_skill FROM skills WHERE name = 'Charm'),
    (SELECT id_skill FROM skills WHERE name = 'Spirit Rush')
);

-- AKALI
INSERT INTO skills (name, description)
VALUES
('Assassin''s Mark', 'Dealing spell damage to a champion creates a ring of energy around them. Exiting that ring empowers Akali''s next Attack with bonus range and damage.'),
('Five Point Strike', 'Akali throws out five kunai, dealing damage based on her bonus Attack Damage and Ability Power and slowing.'),
('Twilight Shroud', 'Akali drops a cover of smoke and briefly gains Move Speed. While inside the shroud, Akali becomes invisible and unable to be selected by enemy spells and attacks. Attacking or using abilities will briefly reveal her.'),
('Shuriken Flip', 'Flip backward and fire a shuriken forward, dealing magic damage. The first enemy or smoke cloud hit is marked. Re-cast to dash to the marked target, dealing additional damage.'),
('Perfect Execution', 'Akali leaps in a direction, damaging enemies she strikes. Re-cast: Akali dashes in a direction, executing all enemies she strikes.');

INSERT INTO champions (id_champion, name, difficulty_level, ban_rate, pick_rate, win_rate, id_skill_P, id_skill_Q, id_skill_W, id_skill_E, id_skill_R)
VALUES (
    'akali',
    'Akali', 
    'moderate', 
    0.00, 
    0.00, 
    0.00,
    (SELECT id_skill FROM skills WHERE name = 'Assassin''s Mark'),
    (SELECT id_skill FROM skills WHERE name = 'Five Point Strike'),
    (SELECT id_skill FROM skills WHERE name = 'Twilight Shroud'),
    (SELECT id_skill FROM skills WHERE name = 'Shuriken Flip'),
    (SELECT id_skill FROM skills WHERE name = 'Perfect Execution')
);

-- AKSHAN 
INSERT INTO skills (name, description)
VALUES
('Dirty Fighting', 'Every three hits from Akshan''s Attacks and Abilities deals bonus damage and grants him a Shield if the target was a champion. When Akshan Attacks, he fires an additional Attack for reduced damage. If he cancels the additional Attack, he instead gains Move Speed.'),
('Avengerang', 'Akshan throws a boomerang that deals damage going out and coming back, extending its range each time it hits an enemy.'),
('Going Rogue', 'Akshan passively marks enemy champions as Scoundrels when they kill his ally champions. If Akshan kills a Scoundrel, he resurrects the allies they killed, gains bonus gold, and clears all marks. When activated, Akshan enters camouflage and gains Move Speed and Mana Regen while moving towards Scoundrels. Akshan loses the camouflage quickly while he is not in brush or near terrain.'),
('Heroic Swing', 'Akshan fires a grappling hook into terrain then swings around it, repeatedly firing at the nearest enemy while swinging. He can jump off early or gets knocked off when colliding with champions or terrain.'),
('Comeuppance', 'Akshan locks onto an enemy champion and starts storing bullets. When released, he fires all stored bullets, dealing damage based on missing health to the first champion, minion, or structure hit.');

INSERT INTO champions (id_champion, name, difficulty_level, ban_rate, pick_rate, win_rate, id_skill_P, id_skill_Q, id_skill_W, id_skill_E, id_skill_R)
VALUES (
    '',
    '', 
    '', 
    0.00, 
    0.00, 
    0.00,
    (SELECT id_skill FROM skills WHERE name = 'Dirty Fighting'),
    (SELECT id_skill FROM skills WHERE name = 'Avengerang'),
    (SELECT id_skill FROM skills WHERE name = 'Going Rogue'),
    (SELECT id_skill FROM skills WHERE name = 'Heroic Swing'),
    (SELECT id_skill FROM skills WHERE name = 'Comeuppance')
);

-- TWITCH
INSERT INTO skills (name, description)
VALUES
('Deadly Venom', 'Twitch''s basic attacks infect the target, dealing true damage each second.'),
('Ambush', 'Twitch becomes Camouflaged for a short duration and gains Move Speed. When leaving Camouflage, Twitch gains Attack Speed for a short duration. When an enemy champion with Deadly Venom dies, Ambush''s cooldown is reset.'),
('Venom Cask', 'Twitch hurls a cask of venom that explodes in an area, slowing targets and applying deadly venom to the target.'),
('Contaminate', 'Twitch wreaks further havoc on poisoned enemies with a blast of his vile diseases.'),
('Spray and Pray', 'Twitch unleashes the full power of his crossbow, shooting bolts over a great distance that pierce all enemies caught in their path.');

INSERT INTO champions (id_champion, name, difficulty_level, ban_rate, pick_rate, win_rate, id_skill_P, id_skill_Q, id_skill_W, id_skill_E, id_skill_R)
VALUES (
    'twitch',
    'Twitch', 
    'moderate', 
    0.00, 
    0.00, 
    0.00,
    (SELECT id_skill FROM skills WHERE name = 'Deadly Venom'),
    (SELECT id_skill FROM skills WHERE name = 'Ambush'),
    (SELECT id_skill FROM skills WHERE name = 'Venom Cask'),
    (SELECT id_skill FROM skills WHERE name = 'Contaminate'),
    (SELECT id_skill FROM skills WHERE name = 'Spray and Pray')
);

-- FIZZ 
INSERT INTO skills (name, description)
VALUES
('Nimble Fighter', 'Fizz can move through units and takes a flat amount of reduced damage from all sources.'),
('Urchin Strike', 'Fizz dashes through his target, dealing magic damage and applying on hit effects.'),
('Seastone Trident', 'Fizz''s attacks bleed his enemies, dealing magic damage over several seconds. Fizz can empower his next attack to deal bonus damage and empower his further attacks for a short time.'),
('Playful / Trickster', 'Fizz hops into the air, landing gracefully upon his spear and becoming untargetable. From this position, Fizz can either slam the ground or choose to jump again before smashing back down.'),
('Chum the Waters', 'Fizz tosses a fish in a direction that attaches to any champion that touches it, slowing the target. After a short delay, a shark erupts from the ground, knocking up the target and knocking any nearby enemies aside. All enemies hit are dealt magic damage and slowed.');

INSERT INTO champions (id_champion, name, difficulty_level, ban_rate, pick_rate, win_rate, id_skill_P, id_skill_Q, id_skill_W, id_skill_E, id_skill_R)
VALUES (
    'fizz',
    'Fizz', 
    'moderate', 
    0.00, 
    0.00, 
    0.00,
    (SELECT id_skill FROM skills WHERE name = 'Nimble Fighter'),
    (SELECT id_skill FROM skills WHERE name = 'Urchin Strike'),
    (SELECT id_skill FROM skills WHERE name = 'Seastone Trident'),
    (SELECT id_skill FROM skills WHERE name = 'Playful / Trickster'),
    (SELECT id_skill FROM skills WHERE name = 'Chum the Waters')
);

-------------------------------------------------------------------------------------------------------------------------------------------------
-- SAMPLE DATA
-------------------------------------------------------------------------------------------------------------------------------------------------

-- SUMMONERS
INSERT INTO summoners (id_summoner, name)
VALUES
('Faker', 'Sanghyeok Lee'),
('Gumayusi', 'Minhyung Lee'),
('Oner', 'Hyunjun Mun'),
('Keria', 'Minseok Ryu'),
('Asper', 'Taeki Kim');

-- BLUE TEAM
INSERT INTO teams (total_gold_earned) VALUES (52387);
SET @id_team_blue = (SELECT id_team FROM teams ORDER BY id_team DESC LIMIT 1);

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('fizz', 'Faker');
UPDATE teams SET id_played_champion_1 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('twitch', 'Gumayusi');
UPDATE teams SET id_played_champion_2 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('aatrox', 'Oner');
UPDATE teams SET id_played_champion_3 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('ahri', 'Keria');
UPDATE teams SET id_played_champion_4 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('akali', 'Asper');
UPDATE teams SET id_played_champion_5 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

-- RED TEAM
INSERT INTO teams (total_gold_earned) VALUES (29927);
SET @id_team_red = (SELECT id_team FROM teams ORDER BY id_team DESC LIMIT 1);

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('akali', 'Asper');
UPDATE teams SET id_played_champion_1 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('ahri', 'Keria');
UPDATE teams SET id_played_champion_2 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('aatrox', 'Oner');
UPDATE teams SET id_played_champion_3 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('twitch', 'Gumayusi');
UPDATE teams SET id_played_champion_4 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('fizz', 'Faker');
UPDATE teams SET id_played_champion_5 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

-- MATCH 1 
INSERT INTO matches (id_team_red, id_team_blue, winning_team, match_duration_seconds)
VALUES (@id_team_red, @id_team_blue, 'blue', 1721);

-- BLUE TEAM
INSERT INTO teams (total_gold_earned) VALUES (71433);
SET @id_team_blue = (SELECT id_team FROM teams ORDER BY id_team DESC LIMIT 1);

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('fizz', 'Gumayusi');
UPDATE teams SET id_played_champion_1 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('twitch', 'Faker');
UPDATE teams SET id_played_champion_2 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('aatrox', 'Oner');
UPDATE teams SET id_played_champion_3 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('ahri', 'Asper');
UPDATE teams SET id_played_champion_4 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('akali', 'Keria');
UPDATE teams SET id_played_champion_5 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

-- RED TEAM
INSERT INTO teams (total_gold_earned) VALUES (90000);
SET @id_team_red = (SELECT id_team FROM teams ORDER BY id_team DESC LIMIT 1);

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('akali', 'Asper');
UPDATE teams SET id_played_champion_1 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('ahri', 'Keria');
UPDATE teams SET id_played_champion_2 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('aatrox', 'Oner');
UPDATE teams SET id_played_champion_3 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('twitch', 'Gumayusi');
UPDATE teams SET id_played_champion_4 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('fizz', 'Faker');
UPDATE teams SET id_played_champion_5 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

-- MATCH 2 
INSERT INTO matches (id_team_red, id_team_blue, winning_team, match_duration_seconds)
VALUES (@id_team_red, @id_team_blue, 'red', 1699);

-- MATCH 3
INSERT INTO matches (id_team_red, id_team_blue, winning_team, match_duration_seconds)
VALUES (@id_team_red, @id_team_blue, 'blue', 1901);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
