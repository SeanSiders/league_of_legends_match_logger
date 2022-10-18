-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema cs340_siderss
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema cs340_siderss
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cs340_siderss` DEFAULT CHARACTER SET utf8 ;
USE `cs340_siderss` ;

-- -----------------------------------------------------
-- Table `cs340_siderss`.`summoners`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cs340_siderss`.`summoners` (
  `id_summoner` VARCHAR(45) NOT NULL,
  `name` VARCHAR(100) NULL,
  PRIMARY KEY (`id_summoner`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = DEFAULT;


-- -----------------------------------------------------
-- Table `cs340_siderss`.`skills`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cs340_siderss`.`skills` (
  `id_skill` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`id_skill`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_siderss`.`champions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cs340_siderss`.`champions` (
  `id_champion` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `difficulty_level` VARCHAR(10) NOT NULL,
  `ban_rate` DECIMAL(5,2) NOT NULL,
  `pick_rate` DECIMAL(5,2) NOT NULL,
  `win_rate` DECIMAL(5,2) NOT NULL,
  `id_skill_P` INT NOT NULL,
  `id_skill_Q` INT NOT NULL,
  `id_skill_W` INT NOT NULL,
  `id_skill_E` INT NOT NULL,
  `id_skill_R` INT NOT NULL,
  PRIMARY KEY (`id_champion`),
  INDEX `fk_skill_P` (`id_skill_P` ASC) VISIBLE,
  INDEX `fk_skill_Q` (`id_skill_Q` ASC) VISIBLE,
  INDEX `fk_skill_W` (`id_skill_W` ASC) VISIBLE,
  INDEX `fk_skill_E` (`id_skill_E` ASC) VISIBLE,
  INDEX `fk_skill_R` (`id_skill_R` ASC) VISIBLE,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  CONSTRAINT `fk_champions_skills1`
    FOREIGN KEY (`id_skill_P`)
    REFERENCES `cs340_siderss`.`skills` (`id_skill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_champions_skills2`
    FOREIGN KEY (`id_skill_Q`)
    REFERENCES `cs340_siderss`.`skills` (`id_skill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_champions_skills3`
    FOREIGN KEY (`id_skill_W`)
    REFERENCES `cs340_siderss`.`skills` (`id_skill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_champions_skills4`
    FOREIGN KEY (`id_skill_E`)
    REFERENCES `cs340_siderss`.`skills` (`id_skill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_champions_skills5`
    FOREIGN KEY (`id_skill_R`)
    REFERENCES `cs340_siderss`.`skills` (`id_skill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_siderss`.`items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cs340_siderss`.`items` (
  `id_item` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `cost_gold` INT NOT NULL,
  PRIMARY KEY (`id_item`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_siderss`.`played_champions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cs340_siderss`.`played_champions` (
  `id_played_champion` INT NOT NULL AUTO_INCREMENT,
  `id_champion` VARCHAR(45) NOT NULL,
  `id_summoner` VARCHAR(45) NOT NULL,
  `id_item_1` INT NULL,
  `id_item_2` INT NULL,
  `id_item_3` INT NULL,
  `id_item_4` INT NULL,
  `id_item_5` INT NULL,
  `id_item_6` INT NULL,
  PRIMARY KEY (`id_played_champion`),
  INDEX `fk_champion` (`id_champion` ASC) VISIBLE,
  INDEX `fk_item_1` (`id_item_1` ASC) VISIBLE,
  INDEX `fk_item_2` (`id_item_2` ASC) VISIBLE,
  INDEX `fk_item_3` (`id_item_3` ASC) VISIBLE,
  INDEX `fk_item_4` (`id_item_4` ASC) VISIBLE,
  INDEX `fk_item_5` (`id_item_5` ASC) VISIBLE,
  INDEX `fk_item_6` (`id_item_6` ASC) VISIBLE,
  INDEX `fk_summoner` (`id_summoner` ASC) VISIBLE,
  CONSTRAINT `fk_id_champion`
    FOREIGN KEY (`id_champion`)
    REFERENCES `cs340_siderss`.`champions` (`id_champion`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_played_champion_items1`
    FOREIGN KEY (`id_item_1`)
    REFERENCES `cs340_siderss`.`items` (`id_item`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_played_champion_items2`
    FOREIGN KEY (`id_item_2`)
    REFERENCES `cs340_siderss`.`items` (`id_item`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_played_champion_items3`
    FOREIGN KEY (`id_item_3`)
    REFERENCES `cs340_siderss`.`items` (`id_item`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_played_champion_items4`
    FOREIGN KEY (`id_item_4`)
    REFERENCES `cs340_siderss`.`items` (`id_item`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_played_champion_items5`
    FOREIGN KEY (`id_item_5`)
    REFERENCES `cs340_siderss`.`items` (`id_item`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_played_champion_items6`
    FOREIGN KEY (`id_item_6`)
    REFERENCES `cs340_siderss`.`items` (`id_item`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_played_champions_summoners1`
    FOREIGN KEY (`id_summoner`)
    REFERENCES `cs340_siderss`.`summoners` (`id_summoner`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_siderss`.`teams`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cs340_siderss`.`teams` (
  `id_team` INT NOT NULL AUTO_INCREMENT,
  `total_gold_earned` INT NULL,
  `id_played_champion_1` INT NULL,
  `id_played_champion_2` INT NULL,
  `id_played_champion_3` INT NULL,
  `id_played_champion_4` INT NULL,
  `id_played_champion_5` INT NULL,
  PRIMARY KEY (`id_team`),
  INDEX `fk_played_champion_1` (`id_played_champion_1` ASC) VISIBLE,
  INDEX `fk_played_champion_2` (`id_played_champion_2` ASC) VISIBLE,
  INDEX `fk_played_champion_3` (`id_played_champion_3` ASC) VISIBLE,
  INDEX `fk_played_champion_4` (`id_played_champion_4` ASC) VISIBLE,
  INDEX `fk_played_champion_5` (`id_played_champion_5` ASC) VISIBLE,
  CONSTRAINT `fk_teams_played_champions1`
    FOREIGN KEY (`id_played_champion_1`)
    REFERENCES `cs340_siderss`.`played_champions` (`id_played_champion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_teams_played_champions2`
    FOREIGN KEY (`id_played_champion_2`)
    REFERENCES `cs340_siderss`.`played_champions` (`id_played_champion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_teams_played_champions3`
    FOREIGN KEY (`id_played_champion_3`)
    REFERENCES `cs340_siderss`.`played_champions` (`id_played_champion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_teams_played_champions4`
    FOREIGN KEY (`id_played_champion_4`)
    REFERENCES `cs340_siderss`.`played_champions` (`id_played_champion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_teams_played_champions5`
    FOREIGN KEY (`id_played_champion_5`)
    REFERENCES `cs340_siderss`.`played_champions` (`id_played_champion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_siderss`.`matches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cs340_siderss`.`matches` (
  `id_match` INT NOT NULL AUTO_INCREMENT,
  `id_reporting_summoner` VARCHAR(45) NOT NULL,
  `id_team_red` INT NOT NULL,
  `id_team_blue` INT NOT NULL,
  `winning_team` VARCHAR(4) NOT NULL,
  `match_duration_seconds` INT NOT NULL,
  PRIMARY KEY (`id_match`),
  INDEX `fk_summoner` (`id_reporting_summoner` ASC) VISIBLE,
  INDEX `fk_team_red` (`id_team_red` ASC) VISIBLE,
  INDEX `fk_team_blue` (`id_team_blue` ASC) VISIBLE,
  CONSTRAINT `fk_real_match_info_summoners1`
    FOREIGN KEY (`id_reporting_summoner`)
    REFERENCES `cs340_siderss`.`summoners` (`id_summoner`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_real_match_info_teams1`
    FOREIGN KEY (`id_team_red`)
    REFERENCES `cs340_siderss`.`teams` (`id_team`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_real_match_info_teams2`
    FOREIGN KEY (`id_team_blue`)
    REFERENCES `cs340_siderss`.`teams` (`id_team`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_siderss`.`league_monsters`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cs340_siderss`.`league_monsters` (
  `id_league_monster` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `buff` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`id_league_monster`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_siderss`.`slain_league_monsters`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cs340_siderss`.`slain_league_monsters` (
  `id_slain_league_monster` INT NOT NULL AUTO_INCREMENT,
  `id_league_monster` INT NOT NULL,
  `id_team` INT NOT NULL,
  INDEX `fk_team` (`id_team` ASC) VISIBLE,
  INDEX `fk_league_monsters` (`id_league_monster` ASC) VISIBLE,
  PRIMARY KEY (`id_slain_league_monster`),
  CONSTRAINT `fk_league_monsters_has_teams_league_monsters1`
    FOREIGN KEY (`id_league_monster`)
    REFERENCES `cs340_siderss`.`league_monsters` (`id_league_monster`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_league_monsters_has_teams_teams1`
    FOREIGN KEY (`id_team`)
    REFERENCES `cs340_siderss`.`teams` (`id_team`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
