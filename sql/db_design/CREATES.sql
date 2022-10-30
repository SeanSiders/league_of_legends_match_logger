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


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;