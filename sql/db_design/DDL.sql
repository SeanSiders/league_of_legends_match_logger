SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE TABLE IF NOT EXISTS skills (
  id_skill INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  description VARCHAR(500) NOT NULL,
  PRIMARY KEY (id_skill),
  UNIQUE INDEX name_UNIQUE (name ASC) VISIBLE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS champions (
  id_champion VARCHAR(45) NOT NULL,
  name VARCHAR(45) NOT NULL,
  difficulty_level VARCHAR(10) NOT NULL,
  ban_rate DECIMAL(5,2) NOT NULL,
  pick_rate DECIMAL(5,2) NOT NULL,
  win_rate DECIMAL(5,2) NOT NULL,
  id_skill_P INT NULL,
  id_skill_Q INT NULL,
  id_skill_W INT NULL,
  id_skill_E INT NULL,
  id_skill_R INT NULL,
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
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_champions_skills2
    FOREIGN KEY (id_skill_Q)
    REFERENCES skills (id_skill)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_champions_skills3
    FOREIGN KEY (id_skill_W)
    REFERENCES skills (id_skill)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_champions_skills4
    FOREIGN KEY (id_skill_E)
    REFERENCES skills (id_skill)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_champions_skills5
    FOREIGN KEY (id_skill_R)
    REFERENCES skills (id_skill)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS summoners (
  id_summoner VARCHAR(45) NOT NULL,
  name VARCHAR(100) NULL,
  PRIMARY KEY (id_summoner))
ENGINE = InnoDB
DEFAULT CHARACTER SET = DEFAULT;


CREATE TABLE IF NOT EXISTS played_champions (
  id_played_champion INT NOT NULL AUTO_INCREMENT,
  id_champion VARCHAR(45) NULL,
  id_summoner VARCHAR(45) NULL,
  PRIMARY KEY (id_played_champion),
  INDEX fk_champion (id_champion ASC) VISIBLE,
  INDEX fk_summoner (id_summoner ASC) VISIBLE,
  CONSTRAINT fk_id_champion
    FOREIGN KEY (id_champion)
    REFERENCES champions (id_champion)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_played_champions_summoners1
    FOREIGN KEY (id_summoner)
    REFERENCES summoners (id_summoner)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


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
  INDEX fk_played_champion_4 (id_played_champion_4 ASC, id_played_champion_5 ASC, id_played_champion_2 ASC, id_played_champion_3 ASC, id_played_champion_1 ASC) VISIBLE,
  INDEX fk_played_champion_5 (id_played_champion_5 ASC) VISIBLE,
  CONSTRAINT fk_teams_played_champions1
    FOREIGN KEY (id_played_champion_1)
    REFERENCES played_champions (id_played_champion)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_teams_played_champions2
    FOREIGN KEY (id_played_champion_2)
    REFERENCES played_champions (id_played_champion)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_teams_played_champions3
    FOREIGN KEY (id_played_champion_3)
    REFERENCES played_champions (id_played_champion)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_teams_played_champions4
    FOREIGN KEY (id_played_champion_4)
    REFERENCES played_champions (id_played_champion)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_teams_played_champions5
    FOREIGN KEY (id_played_champion_5)
    REFERENCES played_champions (id_played_champion)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


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
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_real_match_info_teams2
    FOREIGN KEY (id_team_blue)
    REFERENCES teams (id_team)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- LEAGUE OF LEGENDS STATIC GAME DATA

INSERT INTO skills (id_skill, name, description) VALUES
(1, 'Orb of Deception', 'Ahri sends out and pulls back her orb, dealing magic damage on the way out and true damage on the way back.'),
(2, 'Fox-Fire', 'Ahri releases three fox-fires, that lock onto and attack nearby enemies.'),
(3, 'Charm', 'Ahri blows a kiss that damages and charms an enemy it encounters, causing them to walk harmlessly towards her.'),
(4, 'Spirit Rush', 'Ahri dashes forward and fires essence bolts, damaging 3 nearby champions. Spirit Rush can be cast up to three times before going on cooldown.'),
(5, 'Essence Theft', 'Gains a charge of Essence Theft whenever a spell hits an enemy (max: 3 charges per spell). Upon reaching 9 charges, the next spell has 35% Spell Vamp.'),
(6, 'Mark of the Assassin', 'Akali spins her kama at a target enemy to deal magic damage and mark the target for 6 seconds. Akali''s melee attacks against a marked target will trigger and consume the mark to cause additional damage and restore Energy.'),
(7, 'Twilight Shroud', 'Akali throws down a cover of smoke. While inside the area, Akali gains Armor and Magic Resist and becomes invisible. Attacking or using abilities will briefly reveal her. Enemies inside the smoke have their Movement Speed reduced.'),
(8, 'Crescent Slash', 'Akali flourishes her kamas, dealing damage based on her Attack Damage and Ability Power.'),
(9, 'Shadow Dance', 'Akali moves through shadows to quickly strike her target, dealing damage and consuming an Essence of Shadow charge. Akali recharges Essence of Shadow charges both periodically and upon kills and assists, max 3 stacks.'),
(10, 'Twin Disciplines', 'Upon obtaining 20 Ability Power, Akali''s basic attacks deal 8% bonus magic damage, increasing by 1% for every 6 Ability Power gained thereafter.Upon obtaining 10 Bonus Attack Damage, Akali gains 8% Spell Vamp, increasing by an additional 1% for every 6 Bonus Attack Damage gained thereafter.'),
(11, 'Pulverize', 'Alistar smashes the ground, dealing damage to all nearby enemies and tossing them into the air.  On landing, enemies are stunned.'),
(12, 'Headbutt', 'Alistar rams a target with his head, dealing damage and knocking the target back.'),
(13, 'Triumphant Roar', 'Alistar lets out a commanding war cry, restoring health to himself and nearby friendly units for half the amount.  Can be cast more often if nearby enemies are dying.'),
(14, 'Unbreakable Will', 'Alistar lets out a wild roar, gaining bonus damage, removing all crowd-control effects on himself, and reducing incoming physical and magical damage for the duration.'),
(15, 'Trample', 'Each time Alistar casts a spell, he Tramples nearby units and turrets for a few seconds, dealing damage to units he walks over.'),
(16, 'Bandage Toss', 'Amumu tosses a sticky bandage at a target, stunning and damaging the target while he pulls himself to them.'),
(17, 'Despair', 'Overcome by anguish, nearby enemies lose a percentage of their maximum health each second.'),
(18, 'Tantrum', 'Permanently reduces the physical damage Amumu would take.  Amumu can unleash his rage, dealing damage to surrounding enemies. Each time Amumu is hit, the cooldown on tantrum is reduced by 0.5 seconds.'),
(19, 'Curse of the Sad Mummy', 'Amumu entangles surrounding enemy units in bandages, damaging them and rendering them unable to attack or move.'),
(20, 'Cursed Touch', 'Amumu''s attacks reduce the target''s Magic Resistance for a short duration.'),
(21, 'Flash Frost', 'Anivia brings her wings together and summons a sphere of ice that flies towards her opponents, chilling and damaging anyone in its path. When the lance explodes it does moderate damage in a radius, stunning anyone in the area.'),
(22, 'Crystallize', 'Anivia condenses the moisture in the air into an impassable wall of ice to block all movement. The wall only lasts a short duration before it melts.'),
(23, 'Frostbite', 'With a flap of her wings, Anivia blasts a freezing gust of wind at her target, dealing a medium amount of damage. If the target has been slowed by an ice effect, the damage they take is doubled.'),
(24, 'Glacial Storm', 'Anivia summons a driving rain of ice and hail to damage her enemies and slow their advance.'),
(25, 'Rebirth', 'Upon dying, Anivia will revert into an egg. If the egg can survive for six seconds, she is gloriously reborn.'),
(26, 'Disintegrate', 'Annie hurls a mana-infused fireball, dealing damage and refunding the mana cost if it destroys the target.'),
(27, 'Incinerate', 'Annie casts a blazing cone of fire, dealing damage to all enemies in the area.'),
(28, 'Molten Shield', 'Increases Annie''s Armor and Magic Resist and damages enemies who hit Annie with basic attacks.'),
(29, 'Summon: Tibbers', 'Annie wills her bear Tibbers to life, dealing damage to units in the area. Tibbers can attack and also burns enemies that stand near him.'),
(30, 'Pyromania', 'After casting 4 spells, Annie''s next offensive spell will stun the target for 1.75 seconds.'),
(31, 'Frost Shot', 'While active, each of Ashe''s basic attacks slow her targets. This drains Mana with each attack.'),
(32, 'Volley', 'Ashe fires 7 arrows in a cone for increased damage.  Volley also applies Ashe''s current level of Frost Shot.'),
(33, 'Hawkshot', 'Each time Ashe kills a unit, she gains some extra gold. Ashe can activate to send her Hawk Spirit on a scouting mission.'),
(34, 'Enchanted Crystal Arrow', 'Ashe fires a missile of ice in a straight line.  If the arrow collides with an enemy Champion, it deals damage and stuns the Champion for up to 3.5 seconds, based on how far the arrow has traveled.  In addition, surrounding enemy units take damage and are slowed.'),
(35, 'Focus', 'While out of combat, Ashe''s Critical Strike chance increases every 3 seconds for her next attack.'),
(36, 'Rocket Grab', 'Blitzcrank fires his right hand to grab an opponent on its path, dealing damage and dragging it back to him.'),
(37, 'Overdrive', 'Blitzcrank super charges himself to get dramatically increased movement and attack speed.'),
(38, 'Power Fist', 'Blitzcrank charges up his fist to make his next attack deal double damage and pop his target up in the air.'),
(39, 'Static Field', 'Passively causes lightning bolts to damage a nearby enemy. Additionally, Blitzcrank can activate this ability to damage nearby enemies and silence them for 0.5 seconds, but doing so removes the passive lightning until Static Field becomes available again.'),
(40, 'Mana Barrier', 'When Blitzcrank life is brought below 20% health he activates Mana Barrier. This creates a mana shield equal to 50% of his mana for 10 seconds. Mana Barrier can only occur once every 90 seconds.'),
(41, 'Sear', 'Brand launches a ball of fire forward that deals magic damage. If the target is ablaze, Sear will stun the target for 2 seconds.'),
(42, 'Pillar of Flame', 'After a short delay, Brand creates a pillar of flame at a target area, dealing magic damage to enemy units with the area. Units that are ablaze take an additional 25% damage.'),
(43, 'Conflagration', 'Brand conjures a powerful blast at his target, dealing magic damage to them. If the target is ablaze, Conflagration spreads to nearby enemies.'),
(44, 'Pyroclasm', 'Brand unleashes a devastating torrent of fire, dealing magic damage each time it bounces. If a target is ablaze, Pyroclasm will priotize champions for the next bounce.'),
(45, 'Blaze', 'Brand''s spells light his targets ablaze, dealing 2% of their maximum Health in magic damage per second for 4 seconds.'),
(46, 'Piltover Peacemaker', 'Caitlyn revs up her rifle for 1 second to unleash a penetrating shot that deals physical damage (deals less damage to subsequent targets).'),
(47, 'Yordle Snap Trap', 'Caitlyn sets a trap to find sneaky yordles. When sprung, the trap immobilizes the champion, reveals them for a short duration, and deals magic damage over 1.5 seconds.'),
(48, '90 Caliber Net', 'Caitlyn fires a heavy net to slow her target. The recoil knocks Caitlyn back.'),
(49, 'Ace in the Hole', 'Caitlyn takes time to line up the perfect shot, dealing massive damage to a single target at a huge range. Enemy champions can intercept the bullet for their ally.'),
(50, 'Headshot', 'Every few basic attacks, Caitlyn will fire a headshot dealing 150% damage to a champion or 250% damage to a minion.'),
(51, 'Noxious Blast', 'Cassiopeia blasts an area with a delayed high damage poison, granting her increased Movement Speed if she hits a champion.'),
(52, 'Miasma', 'Cassiopeia releases a cloud of poison, lightly damaging and slowing any enemy that happens to pass through it.'),
(53, 'Twin Fang', 'Cassiopeia lets loose a damaging attack at her target.  If the target is poisoned the cooldown of this spell is refreshed. '),
(54, 'Petrifying Gaze', 'Cassiopeia releases a swirl of magical energy from her eyes, stunning any enemies in front of her that are facing her and slowing any others with their back turned.'),
(55, 'Deadly Cadence', 'After casting a spell, any subsequent spellcasts will cost 10% less Mana for 5 seconds (effect stacks up to 5 times).'),
(56, 'Rupture', 'Ruptures the ground at target location, popping enemy units into the air, dealing damage and slowing them.'),
(57, 'Feral Scream', 'Cho''Gath unleashes a terrible scream at enemies in a cone, dealing magic damage and Silencing enemies for a few seconds.'),
(58, 'Vorpal Spikes', 'Cho''Gath''s attacks passively release deadly spikes, dealing damage to all enemy units in front of him.'),
(59, 'Feast', 'Devours an enemy unit, dealing a high amount of true damage. If the target is killed, Cho''Gath grows, gaining maximum health (maximum 6 stacks). Cho''Gath loses half of his stacks upon death.'),
(60, 'Carnivore', 'Whenever Cho''Gath kills a unit, he recovers health and mana. The values restored increase with Cho''Gath''s level.'),
(61, 'Phosphorus Bomb', 'Corki fires a flash bomb at a target location. This attack reveals non-stealthed units around the blast and champions for 6 seconds.'),
(62, 'Valkyrie', 'Corki surges to target location, dropping bombs that create a trail of destruction for opponents who remain in the fire.'),
(63, 'Gatling Gun', 'Corki''s gatling gun rapidly fires in a cone in front of him, dealing damage and reducing enemy armor.'),
(64, 'Missile Barrage', 'Corki fires a missile toward his target location that explodes on impact, dealing damage to enemies in an area. Corki stores one missile every 12 seconds up to 7 missiles total. Every 4th missile will be a Big One, dealing extra damage.'),
(65, 'Hextech Shrapnel Shells', 'Corki''s basic attacks deal bonus true damage to minions, monsters, and champions.'),
(66, 'Decimate', 'Darius swings his axe in a wide circle. Enemies struck by the blade take more damage than those struck by the handle.'),
(67, 'Crippling Strike', 'Darius''s next attack strikes a crucial artery.  As they bleed out, their movement and attack speed is slowed.  Crippling Strike''s cooldown is lower the more bloodied its target.'),
(68, 'Apprehend', 'Darius hones his axe, passively causing his physical damage to ignore a percentage of his target''s Armor.  When activated, Darius sweeps up his enemies with his axe''s hook and pulls them to him.'),
(69, 'Noxian Guillotine', 'Darius leaps to an enemy champion and strikes a lethal blow, dealing true damage.  This damage is increased for each stack of Hemorrhage on the target. If Noxian Guillotine is a killing blow, its cooldown is refreshed for a brief duration.'),
(70, 'Hemorrhage', 'Darius aims his attacks strategically, causing his target to bleed. This effect stacks up to five times.'),
(71, 'Crescent Strike', 'Diana swings her blade to unleash a bolt of lunar energy that deals damage in an arc before exploding. Afflicts enemies struck with the Moonlight debuff, revealing them. '),
(72, 'Pale Cascade', 'Diana creates three orbiting spheres that detonate on contact with enemies to deal damage in an area. She also gains a temporary shield that absorbs damage. This shield is refreshed if her third sphere detonates.'),
(73, 'Moonfall', 'Diana draws in and slows all nearby enemies.'),
(74, 'Lunar Rush', 'Diana teleports to an enemy and deals magic damage. Lunar Rush has no cooldown when used to teleport to a target afflicted with Moonlight.'),
(75, 'Moonsilver Blade', 'Gains Attack Speed. Every third strike cleaves nearby enemies for additional magic damage.'),
(76, 'Infected Cleaver', 'Dr. Mundo hurls his cleaver, dealing damage equal to a portion of his target''s current Health and slowing them for a short time. Dr. Mundo delights in the suffering of others, so he is returned half of the health cost when he successfully lands a cleaver.'),
(77, 'Burning Agony', 'Dr. Mundo drains his health to reduce the duration of disables and deal continual damage to nearby enemies.'),
(78, 'Masochism', 'Masochism increases Dr. Mundo''s Attack Damage by a flat amount for 5 second. In addition, Dr. Mundo also gains an additional amount of Attack Damage for each percentage of Health he is missing.'),
(79, 'Sadism', 'Dr. Mundo sacrifices a portion of his Health for increased Movement Speed and drastically increased Health Regeneration.'),
(80, 'Adrenaline Rush', 'Dr. Mundo regenerates 0.3% of his maximum Health each second.'),
(81, 'Spinning Axe', 'Draven''s next attack will deal bonus physical damage. This axe will ricochet off the target high up into the air. If Draven catches it, he automatically readies another Spinning Axe. Draven can have two Spinning Axes at once.'),
(82, 'Blood Rush', 'Draven gains increased Movement Speed and Attack Speed. The Movement Speed bonus decreases rapidly over its duration. Catching a Spinning Axe will refresh the cooldown of Blood Rush.'),
(83, 'Stand Aside', 'Draven throws his axes, dealing physical damage to targets hit and knocking them aside. Targets hit are slowed.'),
(84, 'Whirling Death', 'Draven hurls two massive axes to deal physical damage to each unit struck. Whirling Death slowly reverses direction and returns to Draven after striking an enemy champion. Draven may also activate this ability while the axes are in flight to cause it to return early. Deals less damage for each unit hit and resets when the axes reverse direction.'),
(85, 'Wicked Blades', 'Draven''s Critical Strikes deal bonus physical damage over time. Spinning Axe also causes this effect even if it does not Critically Strike.'),
(86, 'Neurotoxin / Venomous Bite', 'Human Form: Deals damage based upon how high the target''s Health is.Spider Form: Lunges at an enemy and deals damage based upon how low their Health is.'),
(87, 'Volatile Spiderling / Skittering Frenzy', 'Human Form: Releases a venom-gorged Spiderling that explodes when it nears a target.Spider Form: Elise and her Spiderlings gain attack speed and heal Elise on each attack.'),
(88, 'Cocoon / Rappel', 'Human Form: Stuns and reveals the first enemy unit hit.Spider Form: Elise and her Spiderlings ascend into the air and then descend upon target enemy.'),
(89, 'Spider Form', 'Transforms into a menacing spider with new abilities. While in Spider Form, Elise deals bonus magic damage on attack and has increased movement speed, armor, and magic resistance.'),
(90, 'Spider Swarm', 'Human Form: When Elise''s spells hit an enemy she readies a spiderling.Spider Form: Elise summons her Spiderlings to attack nearby foes.'),
(91, 'Hate Spike', 'Evelynn fires a line of spikes through an enemy, dealing damage to all enemies in its path.'),
(92, 'Dark Frenzy', 'Evelynn passively increases her Movement Speed when hitting enemy champions with her spells. Upon activation, Evelynn breaks free from slows affecting her and gains a massive Movement Speed boost for a short duration.'),
(93, 'Ravage', 'Evelynn slashes her target twice, dealing damage with each hit. She then gains increased Attack Speed for a short duration.'),
(94, 'Agony''s Embrace', 'Evelynn summons spikes from the ground to deal damage and slow enemies in the area. She then gains a shield based on how many enemy champions were hit.'),
(95, 'Shadow Walk', 'When out of combat, Evelynn enters stealth only being able to be seen by nearby enemy champions or true sight. While stealthed, she rapidly regenerates Mana.'),
(96, 'Mystic Shot', 'Ezreal fires a damaging bolt of energy which reduces all of his cooldowns by 1 second if it strikes an enemy unit.'),
(97, 'Essence Flux', 'Ezreal fires a fluctuating wave of energy, dealing magic damage to enemy champions, while increasing the Attack Speed of allied champions.'),
(98, 'Arcane Shift', 'Ezreal teleports to a target nearby location and fires a homing bolt which strikes the nearest enemy unit.'),
(99, 'Trueshot Barrage', 'Ezreal channels for 1 second to fire a powerful barrage of energy missiles which do massive damage to each unit they pass through (deals 10% less damage to each unit it passes through).'),
(100, 'Rising Spell Force', 'Hitting a target with any of Ezreal''s abilities increases his Attack Speed by 10% for 5 seconds (effect stacks up to 5 times).'),
(101, 'Terrify', 'Strikes a target unit with fear, causing it to flee in terror for a duration.'),
(102, 'Drain', 'Fiddlesticks saps the life force of an enemy, dealing damage to a target over time and healing himself.'),
(103, 'Dark Wind', 'A wisp of wind strikes an enemy unit and then bounces to nearby enemy units, dealing damage and silencing the victims.'),
(104, 'Crowstorm', 'A murder of crows flock wildly around Fiddlesticks, dealing damage each second to all enemy units in the area.'),
(105, 'Dread', 'Nearby enemies have their Magic Resist reduced by 10.'),
(106, 'Lunge', 'Fiora dashes forward to strike her target, dealing physical damage. Fiora can perform the dash a second time within a couple seconds at no mana cost.'),
(107, 'Riposte', 'Fiora''s Attack Damage is increased. When activated, Fiora parries the next basic attack and reflects magic damage back to the attacker. Works against champions, monsters, and large minions.'),
(108, 'Burst of Speed', 'Fiora temporarily gains additional Attack Speed. Each basic attack or Lunge she lands during this time increases her Movement Speed. Killing a champion refreshes the cooldown on Burst of Speed.'),
(109, 'Blade Waltz', 'Fiora dashes around the battlefield to deal physical damage to enemy champions. Successive strikes against the same target deal less damage.'),
(110, 'Duelist', 'Fiora regenerates health over 6 seconds each time she deals damage. Striking champions will cause this effect to stack up to 4 times.'),
(111, 'Urchin Strike', 'Fizz strikes his target and runs them through, dealing magic damage and applying on hit effects.'),
(112, 'Seastone Trident', 'Fizz''s Trident causes rending wounds in his opponents, dealing magic damage to the target based on their missing health.'),
(113, 'Playful / Trickster', 'Fizz hops into the air, landing gracefully upon his spear becoming untargetable. From this position, Fizz can either slam the ground or choose to jump again before smashing back down.'),
(114, 'Chum the Waters', 'Fizz unleashes a magical fish that latches onto enemies or hovers over terrain, slowing champions if it is latched on to them. After a brief delay, a shark erupts from beneath the earth, dealing damage to enemies around the fish and knocking them aside.'),
(115, 'Nimble Fighter', 'Fizz''s dexterity allows him to move through units and take less physical damage from basic attacks.'),
(116, 'Resolute Smite', 'Galio fires a concussive blast from his eyes, slowing and dealing damage to enemies caught near the impact point.'),
(117, 'Bulwark', 'Galio shields an ally Champion, increasing their Armor and Magic Resistance, and restoring Galio''s health each time that Champion suffers damage.'),
(118, 'Righteous Gust', 'Galio claps his wings, unleashing a gust of concussive wind that damages enemies and leaves a directional draft in its wake that increases ally movement speed.'),
(119, 'Idol of Durand', 'Galio assumes the form of a statue, taunting nearby enemies and storing concussive energy as they attack him.  Galio then bursts from his statue shell, releasing the stored energy to damage surrounding foes.'),
(120, 'Runic Skin', 'Galio converts 50% of his total Magic Resistance into Ability Power.'),
(121, 'Parrrley', 'Gangplank takes aim and shoots an enemy unit with his pistol. If Parrrley deals a killing blow, he gains extra gold and half the mana cost is refunded.'),
(122, 'Remove Scurvy', 'Consumes a large quantity of citrus fruit which clears any crowd control effects on him and heals him.'),
(123, 'Raise Morale', 'Gangplank fires a shot into the air, increasing nearby allied champions'' attack damage and movement speed.'),
(124, 'Cannon Barrage', 'Gangplank signals his ship to fire upon an area for 6 seconds, slowing enemies and dealing damage in random locations within the area.'),
(125, 'Grog-Soaked Blade', 'Gangplank''s basic attacks and Parrrley apply a poison that deals magic damage each second and slows movement speed.  Lasts 3 seconds and stacks up to 3 times.'),
(126, 'Decisive Strike', 'Garen gains a burst of Movement Speed, breaking free of all slows affecting him and his next attack strikes a vital area of his foe, dealing bonus damage and silencing them.'),
(127, 'Courage', 'Garen passively increases his Armor and Magic Resist. He may also activate this ability to grant himself a shield that reduces incoming damage and crowd control effects for a short duration.'),
(128, 'Judgment', 'Garen performs a dance of death with his sword, dealing damage around him for the duration.'),
(129, 'Demacian Justice', 'Garen calls upon the might of Demacia to deal a finishing blow to an enemy champion that deals damage based upon how much Health his target has missing.'),
(130, 'Perseverance', 'If Garen has not been struck by damage or enemy abilities for the last 10 seconds, Garen regenerates 0.4% of his maximum Health each second. Minion damage does not stop Perserverance. '),
(131, 'Barrel Roll', 'Gragas rolls his cask to a location, which can be activated to explode or will explode on its own after 5 seconds.  Enemies struck by the blast have their attack speed lowered.'),
(132, 'Drunken Rage', 'Gragas guzzles down brew from his cask for 1 second, restoring his mana.  After finishing, he becomes drunkenly empowered, increasing his damage dealt and reducing damage received.'),
(133, 'Body Slam', 'Gragas charges to a location and collides with the first enemy unit he comes across, dealing damage to all nearby enemy units and slowing their movement.  Damage is split among units hit.'),
(134, 'Explosive Cask', 'Gragas hurls his cask to a location, which explodes on impact, dealing damage and knocking back enemies caught in the blast radius.  '),
(135, 'Happy Hour', 'On ability use, Gragas takes a drink restoring 2% of his max health over 4 seconds.'),
(136, 'Buckshot', 'Graves fires three bullets in a cone, damaging all enemies in their paths.'),
(137, 'Smoke Screen', 'Graves fires a smoke canister at the target area creating a cloud of smoke. Enemies inside the smoke cloud have reduced sight range and Movement Speed. '),
(138, 'Quickdraw', 'Graves dashes forward gaining an Attack Speed boost for several seconds. Hitting enemies with basic attacks lowers the cooldown of this skill. '),
(139, 'Collateral Damage', 'Graves fires an explosive shell dealing heavy damage to the first champion it hits. After hitting a champion or reaching the end of its range, the shell explodes dealing damage in a cone. '),
(140, 'True Grit', 'Graves gains increasing armor and magic resistance the longer he remains in combat. '),
(141, 'Rampage', 'Hecarim cleaves nearby enemies dealing physical damage. '),
(142, 'Spirit of Dread', 'Hecarim deals magic damage to nearby enemies for a short duration. Hecarim gains health equal to a percentage of any damage those enemies suffer.'),
(143, 'Devastating Charge', 'Hecarim gains increasing movement speed for a short duration. His next attack knocks the target back and deals additional physical damage based on the distance he has traveled since activating the ability. '),
(144, 'Onslaught of Shadows', 'Hecarim summons spectral riders and charges forward, dealing magic damage in a line. Hecarim creates a shockwave when he finishes his charge dealing additional magic damage to nearby enemies causing them to flee in terror.'),
(145, 'Warpath', 'Hecarim can move through units and gains attack damage equal to a percentage of his bonus movement speed.'),
(146, 'H-28G Evolution Turret', 'Heimerdinger lays down a machine gun turret.  Turrets gain abilities as this skill is increased.  (Turrets deal half damage to towers).'),
(147, 'Hextech Micro-Rockets', 'Heimerdinger fires long-range rockets that hit the enemies closest to Heimerdinger.'),
(148, 'CH-1 Concussion Grenade', 'Heimerdinger lobs a grenade at a location, dealing damage to enemy units as well as stunning anyone directly hit and blinding surrounding units.'),
(149, 'UPGRADE!!!', 'Passive / Active: Passively increases Cooldown Reduction.  Activate to heal all active Evolution Turrets and cause them to fire frost shots, which reduce Movement Speed, for a short time.'),
(150, 'Techmaturgical Repair Bots', 'Heimerdinger gives nearby allied Turrets and Champions increased Health Regeneration. '),
(151, 'Bladesurge', 'Irelia dashes forward to strike her target. If it kills the target, Bladesurge''s cooldown refreshes and refunds 35 Mana.'),
(152, 'Hiten Style', 'Irelia is skilled in the art of Hiten, passively giving her physical attacks health restoration.  Activating Hiten Style gives her basic attacks true damage for a short period.'),
(153, 'Equilibrium Strike', 'Irelia''s attack balances the scales, dealing damage and slowing the target.  However, if the target has a higher Health % than Irelia, then the blow stuns the target instead.'),
(154, 'Transcendent Blades', 'Irelia summons 4 spirit blades that she can fling to deal physical damage and siphon life from enemies they pass through.'),
(155, 'Ionian Fervor', 'Reduces the duration of stuns, slows, taunts, fears, snares, and roots for each nearby enemy champion.1 Champion: 10%2 Champions: 25%3 Champions: 40%'),
(156, 'Howling Gale', 'By creating a localized change in pressure and temperature, Janna is able to create a small storm that grows in size with time. She can active the spell again to release the storm. On release this storm will fly towards the direction it was cast in, dealing damage and knocking away any enemies in its path.'),
(157, 'Zephyr', 'Janna summons an air elemental that passively increases her Movement Speed and enables her to pass through units. She may also activate this ability to deal damage and slow an enemy''s Movement Speed. The passive is lost while this ability is on cooldown.'),
(158, 'Eye Of The Storm', 'Janna conjures a defensive gale that shields an ally champion or turret from incoming damage and increases their Attack Damage.'),
(159, 'Monsoon', 'Janna surrounds herself in a magical storm, throwing enemies back. After the storm has settled, soothing winds heal nearby allies while the ability is active.'),
(160, 'Tailwind', 'Increases the Movement Speed of all allied champions by 3%.'),
(161, 'Dragon Strike', 'Jarvan IV extends his lance, dealing physical damage and lowering the Armor of all enemies in its path. Additionally, this will pull Jarvan to his Demacian Standard, knocking up enemies in his path.'),
(162, 'Golden Aegis', 'Jarvan IV calls upon the ancient kings of Demacia to shield him from harm and slow surrounding enemies.'),
(163, 'Demacian Standard', 'Jarvan IV carries the pride of Demacia, passively granting him bonus attack speed and armor. Activating Demacian Standard allows Jarvan IV to place a Demacian flag that deals magic damage on impact and grants Attack Speed to nearby allied champions.'),
(164, 'Cataclysm', 'Jarvan IV heroically leaps into battle at a target with such force that he terraforms the surrounding area to create an arena around them.'),
(165, 'Martial Cadence', 'Jarvan IV''s initial basic attack on a target deals bonus physical damage. This effect cannot occur again on the same target for a short duration.'),
(166, 'Leap Strike', 'Jax leaps toward a unit. If they are an enemy, he strikes them with his weapon.'),
(167, 'Empower', 'Jax''s charges his weapon with energy, causing his next attack to deal additional damage.'),
(168, 'Counter Strike', 'Jax''s combat prowess allows him to dodge all incoming attacks for a short duration and then quickly counterattack stunning all surrounding enemies.'),
(169, 'Grandmaster''s Might', 'Every third consecutive attack deals additional magic damage. Additionally, Jax can activate this ability to strengthen his resolve, increasing his Armor and Magic Resist for a short duration.'),
(170, 'Relentless Assault', 'Jax''s consecutive basic attacks continuously increase his Attack Speed.'),
(171, 'To the Skies! / Shock Blast', 'Hammer Stance: Leaps to an enemy dealing physical damage and slowing enemies.Cannon Stance: Fires an orb of electricity that detonates upon hitting an enemy (or reaching the end of its path) dealing physical damage to all enemies in the area of the explosion.'),
(172, 'Shock Blast', 'Fires an orb of electricity that detonates upon hitting an enemy (or reaching the end of its path) dealing physical damage to all enemies in the area of the explosion.'),
(173, 'Lightning Field / Hyper Charge', 'Hammer Stance: Passive: Restores mana per strike. Active: Creates a field of lightning damaging nearby enemies for several seconds.Cannon Stance: Gains a burst of energy, increasing attack speed to maximum for several attacks.'),
(174, 'Hyper Charge', 'Gains a burst of energy increasing attack speed to maximum for several attacks.'),
(175, 'Thundering Blow / Acceleration Gate', 'Hammer Stance: Deals magic damage to an enemy and knocks them back a short distance.Cannon Stance: Deploys an Acceleration Gate increasing the movement speed of all allies who pass through it. If Shock Blast is fired through the gate the missile speed, range, and damage will increase.'),
(176, 'Acceleration Gate', 'Deploys an Acceleration Gate increasing the movement speed of all allies who pass through it.If Shock Blast is fired through the gate the missile speed, range, and damage will increase.'),
(177, 'Mercury Cannon / Mercury Hammer', 'Hammer Stance: Transforms the Mercury Hammer into the Mercury Cannon gaining new abilities and increased range. The first attack in this form reduces the target''s Armor and Magic Resist.Cannon Stance: Transforms the Mercury Cannon into the Mercury Hammer gaining new abilities and increasing Armor and Magic Resist. The first attack in this form deals additional magic damage.'),
(178, 'Mercury Hammer', 'Transforms the Mercury Cannon into the Mercury Hammer gaining new abilities and increasing Armor and Magic Resist. The first attack in this form deals additional magic damage.'),
(179, 'Hextech Capacitor', 'Gains 40 Movement Speed for 1.25 seconds and can move through units each time Transform is cast.'),
(180, 'Inner Flame', 'Karma sends forth a ball of spirit energy that explodes and deals damage upon hitting an enemy unit.Mantra Bonus: In addition to the explosion, Mantra increases the destructive power of her Inner Flame, creating a cataclysm which deals damage after a short delay.'),
(181, 'Focused Resolve', 'Karma creates a tether between herself and a targeted enemy, dealing damage over time and revealing them. If the tether is not broken, the enemy will be rooted.Mantra Bonus: Karma strengthens the link, dealing bonus damage and healing.'),
(182, 'Inspire', 'Karma summons a protective shield that absorbs incoming damage and increases the movement speed of the protected ally.Mantra Bonus: In addition to casting the shield, energy radiates out from the shield, dealing damage to enemies and applying Inspire to allied champions.'),
(183, 'Mantra', 'Karma empowers her next ability to do an additional effect. Mantra is available at level 1 and does not require a skill point.'),
(184, 'Gathering Fire', 'Reduces Mantra''s cooldown each time Karma damages an enemy champion with one of her abilities (Half-effect for Karma''s basic attacks)'),
(185, 'Lay Waste', 'Karthus unleashes a delayed blast at a location, dealing damage to nearby enemies.'),
(186, 'Wall of Pain', 'Karthus creates a passable screen of leeching energy.  Any enemy units that walk through the screen have their Movement Speed and Magic Resist reduced for a period.'),
(187, 'Defile', 'Karthus passively steals energy from his victims, gaining Mana on each kill.  Alternatively, Karthus can surround himself in the souls of his prey, dealing damage to nearby enemies, but quickly draining his own mana.  '),
(188, 'Requiem', 'After channeling for 3 seconds, Karthus deals damage to all enemy champions.'),
(189, 'Death Defied', 'Upon dying, Karthus enters a spirit form allowing him to continue casting spells while dead for 7 seconds.'),
(190, 'Null Sphere', 'Kassadin fires an ethereal bolt of void energy, dealing damage and silencing the target for a duration.'),
(191, 'Nether Blade', 'Passive: Kassadin''s basic attacks restore Mana. The Mana restored is tripled against enemy champions. Active: Kassadin''s basic attacks deal additional magic damage.'),
(192, 'Force Pulse', 'Kassadin draws energy from spells cast in his vicinity. Upon charging up, Kassadin can use Force Pulse to damage and slow enemies in a cone in front of him.'),
(193, 'Riftwalk', 'Kassadin teleports to a nearby location dealing damage to nearby enemy units. Additionally, multiple Riftwalks in a short period of time cause them to cost additional Mana and deal additional damage.'),
(194, 'Void Stone', 'Kassadin takes 15% reduced magic damage and transforms this damage into bonus attack speed.'),
(195, 'Bouncing Blades', 'Katarina throws a dagger that bounces from enemy to enemy, dealing magic damage and marking them. Her next spell or basic attack against a marked target will consume the mark and deal additional magic damage.'),
(196, 'Sinister Steel', 'Katarina whirls her daggers around her, dealing magic damage to all enemies in the area. If she hits an enemy Champion, Katarina gains a burst of speed for a short duration.'),
(197, 'Shunpo', 'Katarina instantly moves to her target''s location and takes reduced damage from enemies for a few seconds. If the target is an enemy, she deals damage.'),
(198, 'Death Lotus', 'Katarina becomes a flurry of blades, throwing daggers with unrivaled speed at up to three nearby Champions. Daggers deal magic damage and reduce incoming healing on targets hit.'),
(199, 'Voracity', 'Champion kills or assists reduce Katarina''s cooldowns by 15 seconds.'),
(200, 'Reckoning', 'Blasts an enemy unit with angelic force, dealing damage, slowing Movement Speed, and applying Holy Fervor.'),
(201, 'Divine Blessing', 'Blesses a target friendly champion, granting them increased movement speed and healing them.'),
(202, 'Righteous Fury', 'Ignites Kayle''s sword with a holy flame, granting Kayle a ranged splash attack and bonus magic damage.'),
(203, 'Intervention', 'Shields Kayle or an ally for a short time, causing them to be immune to damage.'),
(204, 'Holy Fervor', 'When Kayle attacks a champion, the target loses 3% Armor and Magic Resistance for 5 seconds. This effect stacks up to 5 times.'),
(205, 'Thundering Shuriken', 'Kennen throws a fast moving shuriken towards a location, causing damage and adding a Mark of the Storm to any opponent that it hits.'),
(206, 'Electrical Surge', 'Kennen passively deals extra damage and adds a Mark of the Storm to his target every few attacks, and he can activate this ability to damage and add another Mark of the Storm to targets who are already marked.'),
(207, 'Lightning Rush', 'Kennen morphs into a lightning form, enabling him to pass through units.  Any enemy unit he runs through takes damage and gets a Mark of the Storm.'),
(208, 'Slicing Maelstrom', 'Kennen summons a storm that strikes at random nearby enemy champions for magical damage.'),
(209, 'Mark of the Storm', 'Kennen''s abilities add Marks of the Storm to opponents.  Upon receiving 3 Marks of Storm, an opponent is stunned and Kennen receives 25 Energy.  Has a diminished effect if done twice within 7 seconds.'),
(210, 'Taste Their Fear', 'Kha''Zix passively marks enemies that are isolated from nearby allies. Taste Their Fear deals physical damage to a single target. Damage increased on isolated targets. If he chooses to Evolve Enlarged Claws, damage to isolated targets increases dramatically. Kha''Zix also gains increased range on his basic attacks and Taste Their Fear.'),
(211, 'Void Spike', 'Kha''Zix fires exploding spikes that deal physical damage to all nearby enemies. Kha''Zix is healed if he is also within the explosion radius. If he chooses to Evolve Spike Racks, Void Spike fires three spikes in a cone. This effect consumes Unseen Threat to slow and damage all enemies struck.'),
(212, 'Leap', 'Kha''Zix leaps to an area, dealing physical damage upon landing. If he chooses to Evolve Wings, Leap''s range increases dramatically. Also, on champion kill or assist, Leap''s cooldown resets.'),
(213, 'Void Assault', 'Each rank allows Kha''Zix to evolve one of his abilities, giving it a unique additional effect. When activated, Void Assault stealths Kha''Zix, triggers Unseen Threat, and increases Movement Speed. If he chooses to Evolve Active Camouflage, Void Assault can be cast three times and Kha''Zix takes reduced damage while in stealth.'),
(214, 'Unseen Threat', 'When Kha''Zix is not visible to the enemy team, he gains Unseen Threat, causing his next basic attack against an enemy Champion to deal bonus magic damage and slow.'),
(215, 'Caustic Spittle', 'Passive: Increases Kog''Maw''s Attack Speed. Active: Kog''Maw launches a corrosive projectile which deals magic damage and corrodes the target''s Armor and Magic Resist for 4 seconds.'),
(216, 'Bio-Arcane Barrage', 'Kog''Maw''s attacks gain range and deal a percent of the target''s maximum health as magic damage. '),
(217, 'Void Ooze', 'Kog''Maw launches a peculiar ooze which damages all enemies it passes through and leaves a trail which slows enemies who stand on it.'),
(218, 'Living Artillery', 'Kog''Maw fires a living artillery shell at a great distance dealing damage and revealing targets.  Additionally, multiple Living Artilleries in a short period of time cause them to cost additional mana.'),
(219, 'Icathian Surprise', 'Upon dying, Kog''Maw starts a chain reaction in his body which causes him to move faster and detonate after 4 seconds; dealing 100 + (25 x lvl) true damage to surrounding enemies.'),
(220, 'Sigil of Silence', 'LeBlanc projects an orb towards her target, dealing magic damage and marking the target for 3.5 seconds. If the target takes damage from one of LeBlanc''s abilities, the sigil will trigger, dealing damage and silencing the target.'),
(221, 'Distortion', 'LeBlanc rapidly moves to a target location, dealing magic damage to nearby units. In the following 3 seconds, she can activate Distortion again to return to her starting location.'),
(222, 'Ethereal Chains', 'LeBlanc flings illusionary chains towards a target location. If it hits an enemy unit, it will deal initial magic damage and slow their movement speed by 25%. If the target remains shackled for 2 seconds, the target takes additional magic damage and is unable to move.'),
(223, 'Mimic', 'LeBlanc can cast a more potent version of the previous spell she cast.'),
(224, 'Mirror Image', 'When LeBlanc drops below 40% Health, she becomes invisible for 0.5 seconds. When the invisibility fades, she creates a Mirror Image that deals no damage and lasts for up to 8 seconds.Mirror Image has a 1 minute cooldown.Mirror Image can be controlled by holding the Alt key and using the right mouse button.'),
(225, 'Sonic Wave / Resonating Strike', 'Sonic Wave: Lee Sin projects a discordant wave of sound to locate his enemies, dealing physical damage to the first enemy it encounters. If Sonic Wave hits, Lee Sin can cast Resonating Strike for the next 3 seconds.Resonating Strike: Lee Sin dashes to the enemy hit by Sonic Wave, dealing physical damage plus 8% of their missing health.'),
(226, 'Safeguard / Iron Will', 'Safeguard: Lee Sin rushes towards a target ally, shielding them both from damage. After using Safeguard, Lee Sin can cast Iron Will for the next 3 seconds.Iron Will: Lee Sin''s intense training allows him to thrive in battle. For 5 seconds, Lee Sin gains Life Steal and Spell Vamp.'),
(227, 'Tempest / Cripple', 'Tempest: Lee Sin smashes the ground sending out a shockwave that deals magic damage and reveals enemy units hit. If Tempest hits an enemy, Lee Sin can cast cripple for the next 3 seconds.Cripple: Lee Sin cripples nearby enemies revealed by Tempest, reducing their Movement and Attack Speed for 4 seconds. Movement and Attack Speed recover gradually over the duration.'),
(228, 'Dragon''s Rage', 'Lee Sin performs a powerful roundhouse kick launching his target back, dealing physical damage to the target and any enemies they collide with. Enemies the target collides with are knocked into the air for a short duration. This technique was taught to him by Jesse Perring, although Lee Sin does not kick players off the map.'),
(229, 'Flurry', 'After Lee Sin uses an ability, his next 2 basic attacks gain 40% Attack Speed and return 15 Energy each.'),
(230, 'Shield of Daybreak', 'Leona uses her shield to perform her next basic attack, dealing bonus magic damage and stunning the target.'),
(231, 'Eclipse', 'Leona raises her shield to gain Armor and Magic Resistance.  When the duration first ends, if there are nearby enemies she will deal magic damage to them and prolong the duration of the effect.'),
(232, 'Zenith Blade', 'Leona projects a solar image of her sword, dealing magic damage to all enemies in a line. When the image fades, the last enemy champion struck will be briefly immobilized and Leona will dash to them.'),
(233, 'Solar Flare', 'Leona calls down a beam of solar energy, dealing damage to enemies in an area.  Enemies in the center of the area are stunned, while enemies on the outside are slowed.'),
(234, 'Sunlight', 'Damaging spells afflict enemies with Sunlight for 3.5 seconds. When allied Champions deal damage to those targets, they consume the Sunlight debuff to deal additional magic damage.'),
(235, 'Glitterlance', 'Pix and Lulu each fire a bolt of magical energy that heavily slows all enemies it hits. An enemy can only be damaged by one bolt.'),
(236, 'Whimsy', 'If cast on an ally, grants them movement speed and ability power for a short time. If cast on an enemy, turns them into an adorable critter that can''t attack or cast spells.'),
(237, 'Help, Pix!', 'If cast on an ally, commands Pix to jump to an ally and shield them. He then follows them and aids their attacks. If cast on an enemy, commands Pix to jump to an enemy and damage them. He then follows them and grants you vision of that enemy.'),
(238, 'Wild Growth', 'Lulu enlarges an ally, knocking nearby enemies into the air and granting the ally a large amount of bonus health. For the next few seconds, that ally gains an aura that slows nearby enemies.'),
(239, 'Pix, Faerie Companion', 'Pix is a wild Faerie that accompanies Lulu. Pix will fire a barrage of magical energy at targets that Lulu attacks.'),
(240, 'Light Binding', 'Lux releases a sphere of light that binds and deals damage to up to two enemy units.'),
(241, 'Prismatic Barrier', 'Lux throws her wand and bends the light around any friendly target it touches, protecting them from enemy damage.'),
(242, 'Lucent Singularity', 'Fires an anomaly of twisted light to an area, which slows nearby enemies. Lux can detonate it to damage enemies in the area of effect.'),
(243, 'Final Spark', 'After gathering energy, Lux fires a beam of light that deals damage to all targets in the area.  In addition, triggers Lux''s passive ability and refreshes the Illumination debuff duration.'),
(244, 'Illumination', 'Lux''s damaging spells charge the target with energy for 6 seconds.  Lux''s next attack ignites the energy, dealing bonus magic damage (depending on Lux''s level) to the target.'),
(245, 'Seismic Shard', 'Using his primal elemental magic, Malphite sends a shard of the earth through the ground at his foe, dealing damage upon impact and stealing movement speed for 4 seconds.'),
(246, 'Brutal Strikes', 'Malphite starts to hit with such force that his attacks deal damage to all units in front of him. Activating Brutal Strikes greatly increases his Armor and Attack Damage for a short amount of time.'),
(247, 'Ground Slam', 'Malphite slams the ground sending out a shockwave that deals magic damage based on his Armor as damage and reduces the Attack speed of enemies for a short duration.'),
(248, 'Unstoppable Force', 'Malphite ferociously charges to a location, damaging enemies and knocking them into the air.'),
(249, 'Granite Shield', 'Malphite is shielded by a layer of rock which absorbs damage up to 10% of his maximum Health. If Malphite has not been hit for 10 seconds, this effect recharges.'),
(250, 'Call of the Void', 'Malzahar opens up two portals to the void.  After a short delay, they fire projectiles that deal magic damage and silence enemy champions.'),
(251, 'Null Zone', 'Malzahar creates a zone of negative energy which damages enemies that stand in it.'),
(252, 'Malefic Visions', 'Malzahar infects his target''s mind with cruel visions of their demise, dealing damage each second. If the target dies while afflicted by the visions, they pass on to a nearby enemy unit and Malzahar gains mana.  Malzahar''s Voidlings are attracted to affected units.'),
(253, 'Nether Grasp', 'Malzahar channels the essence of the Void to suppress his target and deal damage each second.'),
(254, 'Summon Voidling', 'After casting 4 spells, Malzahar summons an uncontrollable Voidling to engage enemy units for 21 seconds. Voidlings have 200 + 50 x lvl Health and 20 + 5 x lvl Damage.Voidlings Grow after 7 seconds (+50% Damage/Armor), and Frenzy after 14 seconds (+100% Attack Speed).'),
(255, 'Arcane Smash', 'Maokai knocks back nearby enemies with a shockwave, dealing magic damage and slowing them.'),
(256, 'Twisted Advance', 'Maokai dissolves into a cloud of arcane energies.  He regrows near a target enemy, dealing damage and rooting it in place.'),
(257, 'Sapling Toss', 'Maokai flings a sapling that deals area damage on impact.  The sapling then wards the nearby area.  When enemies approach, the sapling attacks enemies with an arcane blast.'),
(258, 'Vengeful Maelstrom', 'Maokai shields his allies by drawing power from hostile spells and attacks, reducing non-tower damage done to allied champions in the area. When Maokai ends the effect, he unleashes the absorbed energy to deal damage to enemies within the vortex.'),
(259, 'Sap Magic', 'Each time a spell is cast near Maokai he draws energy from it, gaining a charge of Magical Sap.  When Maokai has 5 charges his next basic attack heals him for 7% of his max HP.'),
(260, 'Alpha Strike', 'Master Yi leaps across the battlefield with blinding speed, dealing magic damage to multiple units in his path with a chance to deal bonus magic damage to minions and monsters.'),
(261, 'Meditate', 'Master Yi rejuvinates his body by focus of mind, restoring Health and increasing his Armor and Magic Resist for a short time.'),
(262, 'Wuju Style', 'Master Yi becomes skilled in the art of Wuju, passively increasing his Attack Damage.  Activating Wuju Style doubles the bonus for a short time, but the passive bonus is then lost while on cooldown.'),
(263, 'Highlander', 'Master Yi moves with unparalleled agility, temporarily increasing his Movement and Attack speeds as well as making him immune to all slowing effects. While active, killing a Champion refreshes all of Master Yi''s cooldowns.'),
(264, 'Double Strike', 'Master Yi strikes twice every 7th attack.'),
(265, 'Double Up', 'Miss Fortune fires a bullet at an enemy, damaging them and a target behind them.'),
(266, 'Impure Shots', 'Miss Fortune passively increases damage dealt to a target with each strike.  This ability can be activated to increase Miss Fortune''s attack speed and cause her attacks to lower healing received by the target.'),
(267, 'Make It Rain', 'Miss Fortune unleashes a flurry of bullets at a location, dealing waves of damage to opponents and slowing them.'),
(268, 'Bullet Time', 'Miss Fortune channels a flurry of bullets into a cone in front of her, dealing large amounts of damage to enemies.'),
(269, 'Strut', 'After 5 seconds of not being attacked, Miss Fortune gains an additional 25 Movement Speed. This bonus increases by 9 each second up to a maximum bonus of 70.'),
(270, 'Mace of Spades', 'On next hit, Mordekaiser swings his mace with such force that it echoes out, striking up to 3 additional nearby targets, dealing damage plus bonus damage. If the target is alone, the attack deals extra damage.'),
(271, 'Creeping Death', 'Unleashes a protective cloud of metal shards to surround an ally, increasing their armor and magic resistance and dealing damage per second to enemies in the cloud.'),
(272, 'Siphon of Destruction', 'Mordekaiser deals damage to enemies in a cone in front of him. For each unit hit, Mordekaiser''s shield absorbs energy.'),
(273, 'Children of the Grave', 'Mordekaiser curses an enemy, stealing a percent of their life initially and each second. If the target dies while the spell is active, their soul is enslaved and will follow Mordekaiser as a ghost for 30 seconds.'),
(274, 'Iron Man', 'A percent of the damage dealt from abilities is converted into a temporary shield, absorbing incoming damage.'),
(275, 'Dark Binding', 'Morgana releases a sphere of dark magic.  Upon contact with an enemy unit, the sphere will deal magic damage and force the unit to the ground for a period of time.'),
(276, 'Tormented Soil', 'Infects an area with desecrated soil, causing enemy units who stand on the location to take continual damage.'),
(277, 'Black Shield', 'Places a protective barrier around an allied champion, absorbing magical damage and disables until penetrated or the shield dissipates.');

INSERT INTO skills (id_skill, name, description) VALUES
(278, 'Soul Shackles', 'Latches chains of energy onto nearby enemy champions, dealing initial damage to them and slowing their Movement Speed, and then echoing the pain a few seconds later and stunning them if they remain close to Morgana.'),
(279, 'Soul Siphon', 'Morgana has Spell Vamp, healing herself whenever she deals damage with her spells.'),
(280, 'Aqua Prison', 'Sends a bubble towards a targeted area, dealing damage and stunning all enemies on impact.'),
(281, 'Ebb and Flow', 'Unleashes a stream of water that bounces back and forth between allies and enemies, healing allies and damaging enemies.'),
(282, 'Tidecaller''s Blessing', 'Empowers an allied champion for a short duration. The ally''s basic attacks deal bonus magic damage and slow the target.'),
(283, 'Tidal Wave', 'Summons a massive Tidal Wave that knocks up, slows, and damages enemies.'),
(284, 'Surging Tides', 'When Nami''s abilities hit allied champions they gain movement speed for a short duration.'),
(285, 'Siphoning Strike', 'Nasus strikes his foe, dealing damage and increasing the power of his future Siphoning Strikes if he slays his target.'),
(286, 'Wither', 'Nasus ages his target, decelerating their Movement and Attack Speeds over time.'),
(287, 'Spirit Fire', 'Nasus unleashes a spirit flame at a location, dealing damage and reducing the Armor of enemies who stand on it.'),
(288, 'Fury of the Sands', 'Nasus unleashes a mighty sandstorm that batters nearby enemies. While the storm rages, he gains increased Health, Attack Range, cast ranges, and drains nearby enemies'' max Health converting into bonus damage for the duration.'),
(289, 'Soul Eater', 'Nasus drains his foe''s spiritual energy, giving him bonus Lifesteal.'),
(290, 'Dredge Line', 'Nautilus hurls his anchor forward. If it hits a champion, he drags both himself and the opponent close together. If it hits terrain, Nautilus instead pulls himself to the anchor and the cooldown of Dredge Line is reduced by half.'),
(291, 'Titan''s Wrath', 'Nautilus surrounds himself with dark energies, gaining a shield that blocks incoming damage. While the shield persists, his attacks apply a damage over time effect to enemies around his target.'),
(292, 'Riptide', 'Nautilus slams the ground, causing the earth to explode around him in a set of three explosions. Each explosion damages and slows enemies.'),
(293, 'Depth Charge', 'Nautilus fires a shockwave into the earth that chases an opponent. This shockwave rips up the earth above it, knocking enemies into the air. When it reaches the opponent, the shockwave erupts, knocking his target into the air and stunning them.'),
(294, 'Staggering Blow', 'Nautilus'' basic attacks deal bonus physical damage and immoblize his targets. This effect cannot happen more than once every few seconds on the same target.'),
(295, 'Javelin Toss / Takedown', 'In human form, Nidalee throws a spiked javelin at her target that gains damage as it flies.  As a cougar, her next attack will attempt to fatally wound her target, dealing more damage the less life they have.'),
(296, 'Bushwhack / Pounce', 'In human form, Nidalee lays a damaging trap for unwary opponents that, when sprung, reveals the target and reduces their Armor and Magic Resist for 12 seconds.  As a cougar, she pounces forward, dealing a small amount of damage when she lands.  Pounce is not affected by cooldown reduction.'),
(297, 'Primal Surge / Swipe', 'In human form, Nidalee channels the spirit of the cougar to heal her allies and imbue them with attack speed for a short duration.  As a cougar, she rapidly claws enemies in front of her.'),
(298, 'Aspect Of The Cougar', 'Nidalee transforms into a cougar, gaining new abilities and increased Movement Speed.'),
(299, 'Prowl', 'Moving through brush increases Nidalee''s Movement Speed by 15% for 2 seconds.'),
(300, 'Duskbringer', 'Nocturne throws a shadow blade that deals damage, leaves a Dusk Trail, and causes champions to leave a Dusk Trail. While on the trail, Nocturne can move through units and has increased Movement Speed and Attack Damage.'),
(301, 'Shroud of Darkness', 'Nocturne empowers his blades, passively gaining attack speed. Activating Shroud of Darkness allows Nocturne to fade into the shadows, creating a magical barrier which blocks a single enemy ability and doubles his passive attack speed if successful.'),
(302, 'Unspeakable Horror', 'Nocturne plants a nightmare into his target''s mind, dealing damage each second and fearing the target if they do not get out of range by the end of the duration.'),
(303, 'Paranoia', 'Nocturne reduces the sight radius of all enemy champions and removes their ally vision in the process. He can then launch himself at a nearby enemy champion.'),
(304, 'Umbra Blades', 'Every 10 seconds, Nocturne''s next attack strikes surrounding enemies for 120% physical damage and heals himself. Nocturne''s basic attacks reduce this cooldown by 1 second.'),
(305, 'Consume', 'Nunu commands the yeti to take a bite out of a target minion or monster, dealing heavy damage to it and healing himself.'),
(306, 'Blood Boil', 'Nunu invigorates himself and an allied unit by heating their blood, increasing their Movement and Attack Speeds.'),
(307, 'Ice Blast', 'Nunu launches a ball of ice at an enemy unit, dealing damage and temporarily slowing their Movement and Attack Speeds.'),
(308, 'Absolute Zero', 'Nunu begins to sap the area of heat, slowing all nearby enemies. When the spell ends, he deals massive damage to all enemies caught in the area.'),
(309, 'Visionary', 'Nunu can cast a spell for free after 5 attacks.'),
(310, 'Undertow', 'Olaf throws an axe into the ground at a target location, dealing damage to units it passes through and slowing their movement speed. If Olaf picks up the axe, the ability''s cooldown is reduced by 4.5 seconds.'),
(311, 'Vicious Strikes', 'Olaf''s attack damage is increased, based on his health, and he gains massive lifesteal and spell vamp.'),
(312, 'Reckless Swing', 'Olaf attacks with such force that it deals true damage to his target and himself.'),
(313, 'Ragnarok', 'Olaf temporarily becomes immune to disables and gains bonus Armor, Magic Resist, and Armor Penetration.'),
(314, 'Berserker Rage', 'For each 1% of health missing, Olaf''s attack speed is increased by 1%.'),
(315, 'Command: Attack', 'Orianna commands her ball to fire toward a target location, dealing magic damage to targets along the way (deals less damage to subsequent targets). Her ball remains at the target location after.'),
(316, 'Command: Dissonance', 'Orianna commands the ball to release a pulse of energy, dealing magic damage around it. This leaves a field behind that speeds up allies and slows enemies.'),
(317, 'Command: Protect', 'Orianna commands her ball to attach to an allied champion, shielding them and dealing magic damage to any enemies it passes through on the way. Additionally, the ball grants additional Armor and Magic Resist to the champion it is attached to.'),
(318, 'Command: Shockwave', 'Orianna commands her ball to unleash a shockwave, dealing magic damage and launching nearby enemies towards the ball after a short delay.'),
(319, 'Clockwork Windup', 'Orianna''s autoattack deals additional magic damage. This damage increases the more Orianna attacks the same target.'),
(320, 'Spear Shot', 'Pantheon hurls his spear at an opponent, dealing damage.'),
(321, 'Aegis of Zeonia', 'Pantheon leaps at an enemy and bashes the enemy with his shield, stunning them.  After finishing the attack, Pantheon readies himself to block the next attack.'),
(322, 'Heartseeker Strike', 'Pantheon focuses and unleashes 3 swift strikes to the area in front of him, dealing double damage to champions.  Pantheon also becomes more aware of his enemy''s vital spots, allowing him to always crit enemies below 15% health.'),
(323, 'Grand Skyfall', 'Pantheon composes himself then leaps into the air to a target, striking all enemy units in an area.   Enemies closer to the impact point take more damage.'),
(324, 'Aegis Protection', 'After attacking or casting spells 4 times, Pantheon will block the next incoming basic attack or turret attack.'),
(325, 'Devastating Blow', 'Poppy crushes her opponent, dealing attack damage plus a flat amount and 8% of her target''s max health as bonus damage. The bonus damage cannot exceed a threshold based on rank.'),
(326, 'Paragon of Demacia', 'Passive: Upon receiving damage from or dealing damage with a basic attack, Poppy''s armor and damage are increased for 5 seconds. This effect can stack 10 times. Active: Poppy gains max stacks of Paragon of Demacia and her movement speed is increased for 5 seconds.'),
(327, 'Heroic Charge', 'Poppy charges at an enemy and carries them further. The initial impact deals a small amount of damage, and if they collide with terrain, her target will take a high amount of damage and be stunned.'),
(328, 'Diplomatic Immunity', 'Poppy focuses intently on a single enemy champion, dealing increased damage to them. Poppy is immune to any damage and abilities from enemies other than her target.'),
(329, 'Valiant Fighter', 'All physical and magic damage dealt to Poppy that exceeds 10% of her current health is reduced by 50%. This does not reduce damage from structures.'),
(330, 'Blinding Assault', 'Quinn calls Valor to blind and damage targets in an area.'),
(331, 'Heightened Senses', 'Passively grants Quinn Attack Speed after she attacks a Vulnerable target. Valor''s Attack Speed is permanently increased. Activate to have Valor reveal a large area nearby.'),
(332, 'Vault', 'Quinn dashes to an enemy, dealing physical damage and slowing the target''s Movement Speed. Upon reaching the target, she leaps off and lands near her maximum attack range from it. Valor will immediately mark this enemy as Vulnerable.'),
(333, 'Tag Team', 'Valor replaces Quinn on the battlefield as a mobile melee attacker. When ready, Quinn returns in a hail of arrows, dealing physical damage to all nearby enemies.'),
(334, 'Harrier', 'Valor periodically marks enemies as Vulnerable. Quinn''s first basic attack against Vulnerable targets will deal bonus physical damage.'),
(335, 'Powerball', 'Rammus accelerates in a ball towards his enemies, dealing damage and slowing targets affected by the impact.'),
(336, 'Defensive Ball Curl', 'Rammus goes into a defensive formation, vastly increasing his Armor and Magic Resist, while returning damage to attacks.'),
(337, 'Puncturing Taunt', 'Rammus taunts an enemy unit into a reckless assault against Rammus'' hard shell, reducing Armor temporarily.'),
(338, 'Tremors', 'Rammus creates waves of destruction pulsing through the ground, causing damage to units and structures near him.'),
(339, 'Spiked Shell', 'Rammus gains additional damage as his shell becomes reinforced, converting 25% of his armor into Attack Damage.'),
(340, 'Cull the Meek', 'Renekton swings his blade, dealing moderate physical damage to all targets around him and heals for a small portion of the damage dealt. If he has more than 50 Fury, his damage and heal are increased.'),
(341, 'Ruthless Predator', 'Renekton slashes his target twice, dealing moderate physical damage and stuns them for 0.75 seconds. If Renekton has more than 50 Fury, he slashes his target three times, dealing high physical damage and stuns them for 1.5 seconds.'),
(342, 'Slice and Dice', 'Renekton dashes, dealing damage to units along the way. Empowered, Renekton deals bonus damage and reduces the armor of units hit.'),
(343, 'Dominus', 'Renekton transforms into the Tyrant form, gaining bonus Health and dealing damage to enemies around him. While in this form, Renekton gains Fury periodically.'),
(344, 'Reign of Anger', 'Renekton gains Fury for every autoattack he makes. This Fury can empower his abilities with bonus effects. Additionally, Renekton gains bonus Fury when he is low on life.'),
(345, 'Savagery', 'Rengar''s next basic attack deals bonus damage and grants him increased Attack Speed.Ferocity Bonus: Rengar deals enhanced damage and doubles his Attack Speed bonus.'),
(346, 'Battle Roar', 'Rengar lets out a battle roar, damaging enemies and gaining bonus Armor and Magic Resist for a short duration.Ferocity Bonus: Rengar heals for a large amount.'),
(347, 'Bola Strike', 'Rengar throws a bola at his target, slowing them for a short duration.Ferocity Bonus: Roots the target for 1 second.'),
(348, 'Thrill of the Hunt', 'Rengar activates his predatory instincts, stealthing and revealing all enemy Champions in a large radius around him. He gains Movement Speed and rapidly generates Ferocity while stealthed. '),
(349, 'Unseen Predator', 'While in brush or stealth Rengar will leap at the target when using his basic attack.Rengar builds 1 point of Ferocity with each ability he uses on enemies. When reaching 5 points of Ferocity, Rengar''s next ability becomes empowered, granting it a bonus effect.'),
(350, 'Broken Wings', 'Riven lashes out in a series of strikes. This ability can be reactivated three times in a short time frame with the third hit knocking back nearby enemies.'),
(351, 'Ki Burst', 'Riven emits a Ki burst, damaging and stunning nearby enemies.'),
(352, 'Valor', 'Riven steps forward a short distance and blocks incoming damage.'),
(353, 'Blade of the Exile', 'Riven empowers her keepsake weapon with energy and gains attack damage and range. Additionally, during this time, she gains the ability to use Wind Slash once, a powerful ranged attack.'),
(354, 'Runic Blade', 'Riven''s abilities charge her blade, causing her basic attacks to deal bonus physical damage. Riven''s blade may be charged up to three times and expends one charge per attack.'),
(355, 'Flamespitter', 'Rumble torches opponents in front of him, dealing magic damage in a cone for 3 seconds. While in Danger Zone this damage is increased. '),
(356, 'Scrap Shield', 'Rumble pulls up a shield, protecting him from damage and granting him a quick burst of speed. While in Danger Zone, the shield strength and speed bonus is increased. '),
(357, 'Electro Harpoon', 'Rumble launches a taser, electrocuting his target with magic damage and slowing their Movement Speed. A second shot can be fired within 3 seconds. While in Danger Zone the damage and slow percentage is increased.  '),
(358, 'The Equalizer', 'Rumble fires off a group of rockets, creating a wall of flames that damages and slows enemies. '),
(359, 'Junkyard Titan', 'Every spell Rumble casts gives him Heat. When he reaches 50% Heat he reaches Danger Zone, granting all his basic abilities bonus effects. When he reaches 100% heat, he starts Overheating, granting his basic attacks bonus damage, but making him unable to cast spells for a few seconds. '),
(360, 'Overload', 'Ryze throws a charge of pure energy at an enemy for heavy damage and additional damage based upon Ryze''s maximum mana.  Ryze also gains passive cooldown reduction.'),
(361, 'Rune Prison', 'Ryze traps target enemy unit in a cage of runes, damaging them and preventing them from moving.  Also gains bonus damage based on Ryze''s maximum mana.'),
(362, 'Spell Flux', 'Ryze releases an orb of pure magical power that deals damage and bounces from the initial target up to 6 times.  Also gains bonus damage based on Ryze''s maximum mana.  Targets hit have their magic resistance reduced.'),
(363, 'Desperate Power', 'Ryze channels immense arcane power, he gains spell vamp and all of his spells deal area of effect damage.'),
(364, 'Arcane Mastery', 'When Ryze casts a spell, all other spells have their cooldown reduced by 1 second.'),
(365, 'Arctic Assault', 'Sejuani charges forward to deal magic damage and apply Frost to enemies. Sejuani stops upon colliding with an enemy champion.'),
(366, 'Northern Winds', 'Sejuani summons an arctic storm around her which deals magic damage to nearby enemies every second. Damage is increased against enemies affected by Frost or Permafrost.'),
(367, 'Permafrost', 'Sejuani converts Frost on nearby enemies to Permafrost, dealing magic damage and increasing the Movement Speed reduction dramatically.'),
(368, 'Glacial Prison', 'Sejuani throws her weapon, stunning the first enemy champion hit. Nearby enemies are stunned for a shorter duration.  All targets take magic damage and are affected by Frost.'),
(369, 'Frost', 'Sejuani''s basic attacks apply Frost, reducing enemy Movement Speed by 10% for 3 seconds.'),
(370, 'Deceive', 'Shaco becomes invisible and teleports to target location. His next attack is guaranteed to critically strike.'),
(371, 'Jack In The Box', 'Shaco creates an animated Jack-in-the-Box at target location, which will wait, invisible, to Fear nearby units and attack them when some come nearby. '),
(372, 'Two-Shiv Poison', 'Shaco''s Shivs passively poison targets on hit, slowing them and applying a miss chance to minions. He can throw his Shivs to deal damage and poison the target.'),
(373, 'Hallucinate', 'Shaco creates an illusion of himself near him, which can attack nearby enemies. (Deals half damage to turrets.)  Upon death, it explodes, dealing damage to nearby enemies. '),
(374, 'Backstab', 'Shaco deals 20% bonus damage when striking a unit from behind.'),
(375, 'Vorpal Blade', 'Damages target unit and life taps him, healing allies that attack the target.'),
(376, 'Feint', 'Shen shields himself, absorbing incoming damage for a few seconds.'),
(377, 'Shadow Dash', 'Shen dashes rapidly toward a target location, taunting enemy champions he encounters and dealing minor damage.'),
(378, 'Stand United', 'Shen shields target allied champion from incoming damage, and soon after teleports to their location.'),
(379, 'Ki Strike', 'Every 8 seconds, Shen''s next attack deals bonus damage. Each time Shen attacks, Ki Strike''s cooldown is reduced.'),
(380, 'Twin Bite', 'Shyvana strikes twice on her next attack.Dragon Form: Twin Bite cleaves all units in front Shyvana.'),
(381, 'Burnout', 'Shyvana surrounds herself in fire, dealing magic damage per second to nearby enemies and moving faster for 3 seconds. The movement speed reduces over the duration of the spell.Dragon Form: Burnout scorches the ground beneath it, enemies on the scorched earth continue to take damage.'),
(382, 'Flame Breath', 'Shyvana unleashes a fireball that deals damage to the first enemy it encounters and leaves cinders on the target that reduces their Armor for 4 seconds.Dragon Form: Flame Breath engulfs all units in a cone in front of her.'),
(383, 'Dragon''s Descent', 'Shyvana transforms into a dragon and takes flight to a target location. Enemies along her path take damage and are knocked toward her target location.Shyvana passively gains Armor and Magic Resistance. Defensive bonuses are doubled in Dragon Form.'),
(384, 'Fury of the Dragonborn', 'Shyvana''s melee attacks enhance her abilities.Twin Bite - Reduces the cooldown by 0.5 seconds.Burnout - Extends the duration by 1 second to a maximum of 6 seconds.Flame Breath - Deals 15% of the ability''s damage to debuffed targets.Dragon''s Descent - Attacks generate 2 Fury and Shyvana passively gains Fury over time while in human form.'),
(385, 'Poison Trail', 'Leaves a trail of poison behind Singed, dealing damage to enemies caught in the path.'),
(386, 'Mega Adhesive', 'Throws a vial of mega adhesive on the ground, slowing enemies who walk on it.'),
(387, 'Fling', 'Damages target enemy unit and flings them into the air behind Singed.'),
(388, 'Insanity Potion', 'Singed drinks a potent brew of chemicals, granting him increased combat stats.'),
(389, 'Empowered Bulwark', 'Increases Singed''s Health by 25 for every 100 Mana he has.'),
(390, 'Cryptic Gaze', 'Sion''s stare terrifies a single enemy, dealing damage and stunning them.'),
(391, 'Death''s Caress', 'Sion surrounds himself with a damage-absorbing shield.  If the shield is not destroyed in 10 seconds then it will explode, dealing damage to surrounding enemies. Cast again after 4 seconds to manually detonate.'),
(392, 'Enrage', 'While active Sion gains Attack Damage at the cost of Health on each basic attack. Additonally, he permanently increases his maximum Health whenever he kills a unit.'),
(393, 'Cannibalism', 'Sion consumes some of his enemies'' life force on each attack, leeching health to himself and nearby allies. The smell of flesh also renews Sion''s fervor, increasing his Attack Speed.  '),
(394, 'Feel No Pain', 'Sion has a 40% chance to ignore up to 30/40/50 damage each time he is attacked.'),
(395, 'Boomerang Blade', 'Sivir hurls her crossblade like a boomerang, dealing damage each way.'),
(396, 'Ricochet', 'Sivir''s next basic attack will bounce between targets, dealing reduced damage with each successive hit.'),
(397, 'Spell Shield', 'Creates a magical barrier that blocks a single enemy ability cast on Sivir. She receives Mana  back if a spell is blocked.'),
(398, 'On The Hunt', 'Sivir leads her allies into battle granting them increased Movement and Attack Speeds for a period of time.'),
(399, 'Fleet of Foot', 'Sivir gains a short burst of Movement Speed when she attacks an enemy champion.'),
(400, 'Crystal Slash', 'Skarner lashes out with his claws, dealing physical damage to all nearby enemies and charging himself with Crystal Energy for several seconds if a unit is struck.  If he casts Crystal Slash again while powered by Crystal Energy, he deals bonus magic damage and slows all targets hit.'),
(401, 'Crystalline Exoskeleton', 'Skarner gains a shield, and while the shield persists his movement speed and attack speed are both increased.'),
(402, 'Fracture', 'Skarner summons a blast of crystalline energy which deals damage to enemies struck and marks them. Striking enemies will consume the mark to heal Skarner. Killing targets outright will also activate the heal.'),
(403, 'Impale', 'Skarner suppresses an enemy champion and deals magic damage to it.  During this time, Skarner can move freely and will drag his helpless victim around with him.  When the effect ends, Skarner''s target will be dealt additional damage.'),
(404, 'Energize', 'Basic attacks lower all ability cooldowns by 0.5 seconds. Double effect when attacking champions.'),
(405, 'Hymn of Valor', 'Sona plays the Hymn of Valor, granting nearby allied champions bonus Damage and Ability Power. Additionally, casting this ability sends out bolts of sound, dealing magic damage to the nearest two enemy champions or monsters.'),
(406, 'Aria of Perseverance', 'Sona plays the Aria of Perseverance, granting nearby allied champions bonus Armor and Magic Resist. Additionally, casting this ability sends out healing melodies, healing Sona and a nearby wounded ally.'),
(407, 'Song of Celerity', 'Sona plays the Song of Celerity, granting nearby allied champions bonus Movement Speed. Additionally, casting this ability energizes nearby allies with a burst of speed.'),
(408, 'Crescendo', 'Sona plays her ultimate chord, forcing enemy champions to dance and dealing magic damage to them.'),
(409, 'Power Chord', 'After casting 3 spells, Sona''s next attack deals bonus magic damage in addition to a bonus effect depending on what song Sona is currently playing.'),
(410, 'Starcall', 'A shower of stars falls from the sky, striking all nearby enemies for magic damage and reducing their Magic Resist for a short duration.'),
(411, 'Astral Blessing', 'Soraka blesses a friendly unit, restoring health and increasing Armor for a short time.'),
(412, 'Infuse', 'Restores Mana to an ally, or deals damage to an enemy and silences them for a short duration.'),
(413, 'Wish', 'Soraka fills her allies with hope, instantly restoring health to herself and all friendly champions.'),
(414, 'Consecration', 'Increases surrounding allies'' Magic Resist by 16'),
(415, 'Decrepify', 'Swain sets his raven to cripple an enemy. Over the next three seconds, the target takes damage over time and is slowed.'),
(416, 'Nevermove', 'Swain marks a target area. After a short delay, mighty talons grab hold of enemy units, dealing damage and rooting them.'),
(417, 'Torment', 'Swain afflicts his target, dealing damage to them over time and causing them to take increased damage from Swain''s attacks.'),
(418, 'Ravenous Flock', 'Swain inspires dread in his enemies by temporarily taking the form of a raven. During this time ravens strike out at up to 3 nearby enemies. Each raven deals damage and heals Swain for half of the damage dealt.'),
(419, 'Carrion Renewal', 'Swain regenerates mana each time he kills a unit. This amount increases each level.'),
(420, 'Dark Sphere', 'Syndra conjures a Dark Sphere dealing magic damage. The sphere remains and can be manipulated by her other powers.'),
(421, 'Force of Will', 'Syndra picks up and throws a Dark Sphere or enemy minion dealing magic damage and slowing the movement speed of enemies. '),
(422, 'Scatter the Weak', 'Syndra knocks enemies and Dark Spheres back dealing magic damage. Enemies hit by Dark Spheres become stunned.'),
(423, 'Unleashed Power', 'Syndra bombards an enemy Champion with all of her Dark Spheres.'),
(424, 'Transcendent', 'Spells gain extra effects at max rank.Dark Sphere: Deals 15% bonus damage to champions.Force of Will: Increases the slowing duration by 33%.Scatter the Weak: Spell width increased by 50%.Unleashed Power: Range increased by 75.'),
(425, 'Noxian Diplomacy', 'Talon''s next basic attack deals bonus physical damage. If the target is a champion, they will bleed, taking additional physical damage over a period of time and revealing their location for the duration.'),
(426, 'Rake', 'Talon sends out a volley of daggers that then return back to him, dealing physical damage every time it passes through an enemy. Additionally the enemy is slowed for a short duration.'),
(427, 'Cutthroat', 'Talon instantly appears behind his target, silencing them and amplifying his damage against that target.'),
(428, 'Shadow Assault', 'Talon disperses a ring of blades and becomes invisible while gaining additional Movement Speed. When Talon emerges from invisibility, the blades converge on his location. Every time a blade passes through an enemy, they receive physical damage.'),
(429, 'Mercy', 'Talon deals 10% more damage with his basic attacks to any target that is slowed, stunned, immobilized, or suppressed.'),
(430, 'Imbue', 'Taric brings forth earthen energy to heal an ally and himself. This heal is more potent when Taric heals only himself. Additionally,Taric''s basic attacks reduce Imbue''s cooldown.'),
(431, 'Shatter', 'Taric is protected by a hardening aura, increasing the Armor of himself and nearby allied champions. He may choose to splinter the enchanted rocks surrounding him to deal damage and decrease the Armor of nearby enemies at the cost of some Armor for a short time.'),
(432, 'Dazzle', 'Taric emits a brilliant ball of prismatic light from his gemmed shield, stunning his target and damaging them based on how close he is to them.'),
(433, 'Radiance', 'Taric slams his hammer into the ground to deal damage to nearby enemies. For a time after, Taric''s gems radiate energy empowering Taric and his allies with bonus Attack Damage and Ability Power.'),
(434, 'Gemcraft', 'Taric loves to socket magical gems into all of his weapons, resulting in his basic attacks dealing bonus magic damage based on his maximum Mana.'),
(435, 'Blinding Dart', 'Obscures an enemy''s vision with a powerful venom, dealing damage to the target unit and blinding it for the duration.'),
(436, 'Move Quick', 'Teemo scampers around, passively increasing his movement speed until he is struck by an enemy champion or turret.  Teemo can sprint to gain bonus movement speed that isn''t stopped by being struck for a short time.'),
(437, 'Toxic Shot', 'Each of Teemo''s attacks will poison the target, dealing damage on impact and each second after for 4 seconds.'),
(438, 'Noxious Trap', 'Teemo places an explosive poisonous trap using one of the mushrooms stored in his pack.  If an enemy steps on the trap it will release a poisonous cloud, slowing enemies and damaging them over time.'),
(439, 'Camouflage', 'If Teemo stands still and takes no actions for a short duration, he becomes stealthed indefinitely.  After leaving stealth, Teemo gains the Element of Surprise, increasing his attack speed by 40% for 3 seconds.'),
(440, 'Death Sentence', 'Thresh''s attacks wind up, dealing more damage the longer he waits between attacks. When activated, Thresh binds an enemy in chains and pulls them toward him.  Activating this ability a second time pulls Thresh to the enemy.'),
(441, 'Dark Passage', 'Thresh throws out a lantern that shields nearby allied Champions from damage.  Allies can click the lantern to dash to Thresh.'),
(442, 'Flay', 'Sweeps his chain, knocking all enemies hit in the direction of the blow.'),
(443, 'The Box', 'A prison of walls that slow and deal damage if broken.'),
(444, 'Damnation', 'Thresh can harvest the souls of enemies that die near him, permanently granting him armor and ability power.'),
(445, 'Rapid Fire', 'Tristana fires her weapon rapidly, increasing her attack speed for a short time.'),
(446, 'Rocket Jump', 'Tristana fires at the ground to propel herself to a distant location, dealing damage and slowing surrounding units for 3 seconds where she lands.'),
(447, 'Explosive Shot', 'When Tristana kills a unit, her cannonballs burst into shrapnel, dealing damage to surrounding enemies.  Can be activated to deal damage to target unit over time, and reduce healing received.'),
(448, 'Buster Shot', 'Tristana loads a massive cannonball into her weapon and fires it at an enemy unit. This deals magic damage and knocks the target back.'),
(449, 'Draw a Bead', 'Increases Tristana''s attack range as she levels.'),
(450, 'Rabid Bite', 'Trundle bites his opponent, dealing damage and sapping some of their attack damage.'),
(451, 'Contaminate', 'Trundle infects a target location with his curse, gaining attack speed, movement speed, and crowd control reduction while on it.'),
(452, 'Pillar of Filth', 'Trundle creates a plagued beacon at target location, becoming impassable terrain and slowing all nearby enemy units.'),
(453, 'Agony', 'Trundle immediately steals his target''s health and a percent of their armor and magic resistance. Over the next 6 seconds the amount of health, armor, and magic resistance stolen is doubled.'),
(454, 'Decompose', 'Whenever an enemy unit near Trundle dies, he heals for a percent of their maximum health.'),
(455, 'Bloodlust', 'Tryndamere thrives on the thrills of combat, increasing his Attack Damage as he is more and more wounded. He can cast Bloodlust to consume his Fury and heal himself.'),
(456, 'Mocking Shout', 'Tryndamere lets out an insulting cry, decreasing surrounding champions'' Attack Damage.  Enemies with their backs turned to Tryndamere also have their Movement Speed reduced.'),
(457, 'Spinning Slash', 'Tryndamere slices toward a target unit, dealing damage to enemies in his path.'),
(458, 'Undying Rage', 'Tryndamere''s lust for battle becomes so strong that he is unable to die, no matter how wounded he becomes.'),
(459, 'Battle Fury', 'Tryndamere gains Fury for each attack, critical strike, and killing blow he makes. Fury passively increases his critical strike chance and can be consumed with his Bloodlust spell.'),
(460, 'Wild Cards', 'Twisted Fate throws three cards, dealing damage to each enemy unit they pass through.'),
(461, 'Pick A Card', 'Twisted Fate chooses a magic card from his deck, and uses that for his next attack, causing bonus effects.'),
(462, 'Stacked Deck', 'Every 4 attacks, Twisted Fate deals bonus damage. In addition, his attack speed is increased and his cooldowns are decreased.'),
(463, 'Destiny', 'Twisted Fate predicts the fortunes of his foes, revealing all enemy champions and enabling the use of Gate, which teleports Twisted Fate to any target location.'),
(464, 'Loaded Dice', 'Twisted Fate and his allies receive an additional 2 gold per kill.'),
(465, 'Ambush', 'Twitch becomes invisible for a short duration, while invisible Twitch gains movement speed. When leaving invisibility twitch gains Attack Speed for a short duration.'),
(466, 'Venom Cask', 'Twitch hurls a cask of venom that explodes in an area, slowing targets and applying deadly venom to the target.'),
(467, 'Expunge', 'All nearby enemies secrete Twitch''s toxic venoms from their bodies, dealing damage for each stack.'),
(468, 'Spray and Pray', 'Twitch closes his eyes and fires his crossbow, rapidly spraying powerful piercing bolts ahead of him.'),
(469, 'Deadly Venom', 'Twitch''s basic attacks infect the target, dealing true damage each second.'),
(470, 'Tiger Stance', 'Tiger Stance: Activation - Udyr''s next basic attack will deal a high amount of damage over 2 seconds, and Udyr''s Attack Speed is increased for a few seconds. Persistent Effect - Udyr''s Attack Speed is passively increased.'),
(471, 'Turtle Stance', 'Turtle Stance: Activation - Udyr gains a temporary shield that absorbs damage. Persistent Effect - Udyr restores an amount of his Health equivalent to a percentage of his damage dealt.'),
(472, 'Bear Stance', 'Bear Stance: Activation - Udyr increases Movement Speed for a short duration. Persistent Effect - Udyr''s basic attacks stun his target for 1 second. This effect cannot occur on the same target for several seconds.'),
(473, 'Phoenix Stance', 'Phoenix Stance: Activation - Udyr unleashes pulsing waves of fire, dealing damage to nearby enemies for 5 seconds. Persistent Effect - With the first basic attack and every third attack after, Udyr engulfs enemies in front of him with flames.'),
(474, 'Monkey''s Agility', 'Entering a stance grants Udyr 10% Attack Speed and 5 Movement Speed for a short duration. This effect can stack up to 3 times.'),
(475, 'Acid Hunter', 'Urgot fires an Acid Hunter missile that collides with the first enemy it hits, slowing the target if he has his Terror Capacitor up. Acid Hunter missile-locks on enemies affected by Noxian Corrosive Charge.'),
(476, 'Terror Capacitor', 'Urgot charges up his capacitor to gain a shield. While the shield is active, Urgot gains slowing attacks.'),
(477, 'Noxian Corrosive Charge', 'Urgot launches a corrosive charge that damages enemies in an area and reduces their armor.'),
(478, 'Hyper-Kinetic Position Reverser', 'Urgot charges up his Hyper-Kinetic Position Reverser, swapping positions with the target.  His target is suppressed for the duration of the channel. He gains increased armor and magic resistance after the swap.'),
(479, 'Zaun-Touched Bolt Augmenter', 'Urgot''s basic attacks reduce his targets'' damage by 15% for 2.5 seconds.'),
(480, 'Piercing Arrow', 'Varus readies and then fires a powerful shot that gains extra range and damage the longer he spends preparing to fire.'),
(481, 'Blighted Quiver', 'Varus'' basic attacks deal bonus magic damage and apply Blight. Varus'' other abilities detonate Blight, dealing magic damage based on the target''s maximum health.'),
(482, 'Hail of Arrows', 'Varus fires a hail of arrows that deal physical damage and desecrate the ground. Desecrated ground slows enemies'' Movement Speed and reduces their healing and regeneration. '),
(483, 'Chain of Corruption', 'Varus flings out a damaging tendril of corruption that immobilizes the first enemy champion hit and then spreads towards nearby uninfected champions, immobilizing them too on contact. '),
(484, 'Living Vengeance', 'On kill or assist, Varus temporarily gains Attack Speed. This bonus is larger if the enemy is a champion.'),
(485, 'Tumble', 'Vayne tumbles, maneuvering to carefully place her next shot.  Her next attack deals bonus damage.'),
(486, 'Silver Bolts', 'Vayne tips her bolts with a rare metal, toxic to evil things.  The third consecutive attack or ability against the same target deals a percentage of the target''s maximum Health as bonus true damage. (Max: 200 damage vs. Monsters)'),
(487, 'Condemn', 'Vayne draws a heavy crossbow from her back, and fires a huge bolt at her target, dealing damage and knocking them back.  If they collide with terrain, they are impaled, dealing bonus damage and stunning them.'),
(488, 'Final Hour', 'Readying herself for an epic confrontation, Vayne gains increased Attack Damage, invisibility during Tumble, and triple the bonus Movement Speed from Night Hunter.'),
(489, 'Night Hunter', 'Vayne ruthlessly hunts evil-doers.  She gains 30 Movement Speed when moving toward nearby enemy champions.'),
(490, 'Baleful Strike', 'Unleashes dark energy at target enemy, dealing magic damage. If a unit is killed, Veigar gains some Ability Power permanently.'),
(491, 'Dark Matter', 'Veigar calls a great mass of dark matter to fall from the sky to the target location, dealing magic damage when it lands.'),
(492, 'Event Horizon', 'Veigar twists the edges of space around the target location for 3 seconds, stunning enemies who pass through the perimeter for a short duration.'),
(493, 'Primordial Burst', 'Blasts target enemy champion, dealing a large base amount of magic damage plus 80% of his target''s AP.'),
(494, 'Equilibrium', 'Veigar''s mana regen is increased by 1% for each 1% of mana missing.'),
(495, 'Vault Breaker', 'Vi charges her gauntlets and unleashes a vault shattering punch, carrying her forward.  Enemies she hits are knocked back and receive a stack of denting blows.'),
(496, 'Denting Blows', 'Vi''s punches break her opponent''s armor, dealing bonus damage and granting her attack speed.'),
(497, 'Excessive Force', 'Vi''s next attack blasts through her target, dealing damage to enemies behind it.'),
(498, 'Assault and Battery', 'Vi runs down an enemy, knocking aside anyone in the way.  When she reaches her target she knocks it into the air, jumps after it, and slams it back into the ground.'),
(499, 'Blast Shield', 'Vi charges a shield over time.  The shield can be activated by hitting an enemy with an ability.'),
(500, 'Power Transfer', 'Viktor blasts an enemy unit dealing magic damage, returning a portion of the damage dealt as a shield.'),
(501, 'Gravity Field', 'Viktor conjures a heavy gravitational field that slows any target in its radius. If enemies stay too long within the radius of the device, it gets stunned.'),
(502, 'Death Ray', 'Viktor uses his robotic arm to fire a chaos beam that cuts across the field in a line, dealing damage to any opponents struck in its path.'),
(503, 'Chaos Storm', 'Viktor conjures a singularity on the field which deals magic damage and briefly silences enemies. The singularity then does magic damage to all nearby enemies every second. Viktor can redirect the singularity.'),
(504, 'Evolving Technology', 'Viktor starts with a Hex Core that provides him with stats and can be upgraded in the store to augment one of his abilities. The Hex Core can only be upgraded once, and cannot be sold back to the store.'),
(505, 'Transfusion', 'Vladimir drains life from his target.'),
(506, 'Sanguine Pool', 'Vladimir sinks into a pool of blood becoming untargetable for 2 seconds. Additionally, enemies on the pool are slowed and Vladimir siphons life from them.'),
(507, 'Tides of Blood', 'Vladimir unleashes a torrent of blood, damaging surrounding enemies. Additionally, multiple Tides of Blood in a short period of time cause them to cost additional health and deal additional damage, and increases his healing and regeneration by 8%.'),
(508, 'Hemoplague', 'Vladimir infects an area with a virulent plague. Affected enemies take increased damage for the duration.  Hemoplague deals additional magic damage after a few seconds to infected enemies.'),
(509, 'Crimson Pact', 'Every 40 points of bonus health gives Vladimir 1 ability power and every 1 point of ability power gives Vladimir 1.4 bonus health (does not stack with itself).'),
(510, 'Rolling Thunder', 'Volibear drops to all fours and runs faster. This bonus speed increases when chasing enemy champions. The first enemy he attacks is thrown backwards over Volibear.'),
(511, 'Frenzy', 'Volibear''s repeated attacks grant him additional Attack Speed.  Once Volibear has repeatedly attacked three times, he can perform a vicious bite on his target which deals increased damage based on the target''s missing health.'),
(512, 'Majestic Roar', 'Volibear lets out a powerful roar that damages and slows enemies. Minions and monsters are feared as well.'),
(513, 'Thunder Claws', 'Volibear channels the power of the storm causing his attacks to blast his targets with lightning that bounces to other nearby enemies.'),
(514, 'Chosen of the Storm', 'Volibear heals rapidly for a few seconds when his health drops to a critical level.'),
(515, 'Hungering Strike', 'Takes a bite out of an enemy unit and heals Warwick.'),
(516, 'Hunters Call', 'Warwick lets out a howl, increasing all nearby friendly champions'' Attack Speed for a short time.'),
(517, 'Blood Scent', 'Warwick passively senses weakened enemy champions around him.  The scent of blood sends him into a fury, causing him to move at incredible speeds.'),
(518, 'Infinite Duress', 'Warwick lunges at an enemy champion, suppressing his target and dealing magic damage for a few seconds.'),
(519, 'Eternal Thirst', 'Each of Warwick''s attacks will heal him. Each successive attack against the same target will steal more and more Health.'),
(520, 'Crushing Blow', 'Wukong''s next attack deals additional physical damage, gains range, and reduces the enemy''s Armor for a short duration.'),
(521, 'Decoy', 'Wukong becomes invisible for 1.5 seconds. An uncontrollable decoy is left behind that will deal magic damage to enemies near it after 1.5 seconds.'),
(522, 'Nimbus Strike', 'Wukong dashes toward a target enemy and sends out images to attack up to 2 additional enemies near his target, dealing physical damage to each enemy struck.'),
(523, 'Cyclone', 'Wukong''s staff grows outward and he spins it around, dealing damage and knocking up enemies. Wukong gains movement speed over the duration of the spell.'),
(524, 'Stone Skin', 'Increases Wukong''s armor and magic resistance for each nearby enemy champion.'),
(525, 'Arcanopulse', 'Fires a long-range beam of energy, dealing magic damage to all targets hit.'),
(526, 'Locus of Power', 'Xerath immobilizes himself near a source of magical power, increasing the range of all spells and causing his magic damage to ignore a percentage of his target''s Magic Resist. When the effect ends, Xerath''s Movement Speed is increased for 2 seconds.'),
(527, 'Mage Chains', 'Deals magic damage to an enemy and marks them with Unstable Magic.  The next spell Xerath strikes this enemy with stuns them.'),
(528, 'Arcane Barrage', 'Calls down a blast of arcane energy, dealing magic damage to all enemies in an area. May be cast up to three times before going on cooldown.'),
(529, 'Ascended Form', 'Xerath feeds on arcane power, making him increasingly resilient to physical harm. He converts 15% of his Ability Power into Armor.'),
(530, 'Three Talon Strike', 'Xin Zhao''s next 3 standard attacks deal increased damage that reduce his other ability cooldowns, with the third attack knocking an opponent into the air.'),
(531, 'Battle Cry', 'Xin Zhao passively heals every 3 attacks and can activate this ability to attack faster.'),
(532, 'Audacious Charge', 'Xin Zhao charges an enemy, dealing damage and slowing all enemies in the area.'),
(533, 'Crescent Sweep', 'Xin Zhao fiercely sweeps his spear around him, dealing damage to nearby enemies based on their current health and knocking them back.'),
(534, 'Challenge', 'Xin Zhao challenges his target with his basic attacks and Audacious Charge, reducing its armor by 15% for 3 seconds.'),
(535, 'Omen of War', 'Yorick''s next attack will deal bonus physical damage and summon a Spectral Ghoul that deals additional damage and moves faster than Yorick''s other ghouls. While the Spectral Ghoul is alive, Yorick moves faster as well.'),
(536, 'Omen of Pestilence', 'Yorick summons a Decaying Ghoul that arrives with a violent explosion, dealing damage and slowing nearby enemies. While the Decaying Ghoul remains alive, nearby enemies continue to be slowed.'),
(537, 'Omen of Famine', 'Yorick steals life from his target and summons a Ravenous Ghoul that heals Yorick for the damage it deals.'),
(538, 'Omen of Death', 'Yorick conjures a revenant in the image of one of his allies. If his ally dies while its revenant is alive, the revenant sacrifices itself to reanimate them and give them time to enact vengeance.'),
(539, 'Unholy Covenant', 'Yorick''s takes 5% reduced damage and his basic attacks deal 5% more damage for each summon that is active. Meanwhile, Yorick''s ghouls have 35% of Yorick''s Attack Damage and Health.'),
(540, 'Stretching Strike', 'Zac extends his arms, dealing damage to nearby enemies.'),
(541, 'Unstable Matter', 'Zac''s body erupts, damaging nearby enemies.'),
(542, 'Elastic Slingshot', 'Zac attaches his arms to the ground and stretches back, launching himself forward.'),
(543, 'Let''s Bounce!', 'Zac launches into the air, gaining movement speed, and slams down three times, each time damaging, slowing and knocking up nearby enemies.'),
(544, 'Cell Division', 'Each time Zac hits an enemy with an ability, he sheds a chunk of himself that can be reabsorbed to restore Health. Upon taking fatal damage, Zac splits into 4 bloblets that attempt to recombine. If any bloblets remain after 8 seconds, he will revive with an amount of Health depending on the Health of the surviving bloblets. Each bloblet has a percentage of Zac''s maximum Health, Armor and Magic Resistance. This ability has a 5 minute cooldown.'),
(545, 'Razor Shuriken', 'Zed and his shadow both throw their spinning blades forward, dealing damage to any targets they pass through.'),
(546, 'Living Shadow', 'Zed''s shadow dashes forward, remaining in place for 4 seconds, and mimicking his spell casts.  Zed can reactivate to swap places with the shadow.'),
(547, 'Shadow Slash', 'Zed and his shadow spins their blades, creating a burst of shadow energy.  The shadow''s spin slows.'),
(548, 'Death Mark', 'Zed dashes to target Champion, projecting a shadow behind them, and marking the champion for death. After 3 seconds, the mark will trigger, dealing a percentage of the damage Zed has dealt while the mark was active. '),
(549, 'Contempt for the Weak', 'Zed''s basic attacks against targets below 50% health deal 8% of the target''s maximum health as bonus magic damage. This effect can only occur once every 10 seconds on the same target.'),
(550, 'Bouncing Bomb', 'Ziggs throws a bouncing bomb that deals magic damage.'),
(551, 'Satchel Charge', 'Ziggs flings an explosive charge that detonates after 4 seconds, or when this ability is activated again. The explosion deals magic damage to enemies, knocking them away. Ziggs is also knocked away, but takes no damage.'),
(552, 'Hexplosive Minefield', 'Ziggs scatters proximity mines that detonate on enemy contact, dealing magic damage and slowing.'),
(553, 'Mega Inferno Bomb', 'Ziggs deploys his ultimate creation, the Mega Inferno Bomb, hurling it an enormous distance. Enemies in the primary blast zone take more damage than those further away. '),
(554, 'Short Fuse', 'Every 12 seconds, Ziggs'' next basic attack deals bonus magic damage. This cooldown is reduced whenever Ziggs uses an ability.'),
(555, 'Time Bomb', 'Places a bomb on any unit, allied or enemy, which detonates after 4 seconds, dealing area of effect damage.'),
(556, 'Rewind', 'Zilean can prepare himself for future confrontations, reducing the cooldowns of all of his other abilities. '),
(557, 'Time Warp', 'Zilean bends time around any unit, decreasing an enemy''s Movement Speed or increasing an ally''s Movement Speed for a short time.'),
(558, 'Chronoshift', 'Zilean places a protective time rune on an allied champion, teleporting the champion back in time if they take lethal damage.'),
(559, 'Heightened Learning', 'Increases experience gain of all allied champions by 8%.'),
(560, 'Deadly Bloom', 'Zyra grows a bud at target location.  After a brief delay, it explodes, launching damaging thorns at all nearby enemies. If cast upon a seed, Deadly Bloom grows a Thorn Spitter plant, which fires at enemies from afar.'),
(561, 'Rampant Growth', 'Zyra plants a seed, granting vision of an area for up to 30 seconds. Other spells cast on seeds will turn them into plants, who fight for Zyra. Additionally passively grants her Cooldown Reduction.'),
(562, 'Grasping Roots', 'Zyra sends forth vines through the ground to ensnare her target, dealing damage and rooting enemies they come across. If cast upon a seed, Grasping Roots grows a Vine Lasher, whose short range attacks reduce enemy movement speed.'),
(563, 'Stranglethorns', 'Zyra summons a twisted thicket at her target location, dealing damage to enemies as it expands and knocking them airborne as it contracts.'),
(564, 'Rise of the Thorns', 'When Zyra dies, she briefly returns to her plant form. After 2 seconds, she can press any ability to fire a thorn toward her cursor, dealing true damage to each enemy it strikes.');

INSERT INTO champions (id_champion, name, difficulty_level, ban_rate, pick_rate, win_rate, id_skill_P, id_skill_Q, id_skill_W, id_skill_E, id_skill_R) VALUES
('ahri', 'Ahri', 'easy', 2.0, 10.0, 49.0, 1, 2, 3, 4, 5),
('akali', 'Akali', 'hard', 1.0, 3.0, 50.0, 6, 7, 8, 9, 10),
('alistar', 'Alistar', 'medium', 4.0, 4.0, 52.0, 11, 12, 13, 14, 15),
('amumu', 'Amumu', 'easy', 6.0, 88.0, 76.0, 16, 17, 18, 19, 20),
('anivia', 'Anivia', 'easy', 8.0, 56.0, 46.0, 21, 22, 23, 24, 25),
('annie', 'Annie', 'medium', 3.0, 22.0, 52.0, 26, 27, 28, 29, 30),
('ashe', 'Ashe', 'easy', 2.0, 0.0, 51.0, 31, 32, 33, 34, 35),
('blitzcrank', 'Blitzcrank', 'easy', 1.0, 2.0, 50.0, 36, 37, 38, 39, 40),
('brand', 'Brand', 'hard', 5.0, 3.0, 45.0, 41, 42, 43, 44, 45),
('caitlyn', 'Caitlyn', 'very hard', 2.0, 10.0, 53.0, 46, 47, 48, 49, 50),
('cassiopeia', 'Cassiopeia', 'easy', 2.0, 3.0, 50.0, 51, 52, 53, 54, 55),
('chogath', 'Cho''Gath', 'hard', 2.0, 4.0, 51.0, 56, 57, 58, 59, 60),
('corki', 'Corki', 'easy', 3.0, 6.0, 53.0, 61, 62, 63, 64, 65),
('darius', 'Darius', 'hard', 3.0, 4.0, 56.0, 66, 67, 68, 69, 70),
('diana', 'Diana', 'easy', 5.0, 5.0, 56.0, 71, 72, 73, 74, 75),
('draven', 'Draven', 'medium', 1.0, 3.0, 59.0, 81, 82, 83, 84, 85),
('dr_mundo', 'Dr. Mundo', 'hard', 4.0, 5.0, 49.0, 76, 77, 78, 79, 80),
('elise', 'Elise', 'easy', 3.0, 45.0, 57.0, 86, 87, 88, 89, 90),
('evelynn', 'Evelynn', 'hard', 5.0, 5.0, 47.0, 91, 92, 93, 94, 95),
('ezreal', 'Ezreal', 'easy', 5.0, 0.0, 45.0, 96, 97, 98, 99, 100),
('fiddlesticks', 'Fiddlesticks', 'easy', 2.0, 3.0, 52.0, 101, 102, 103, 104, 105),
('fiora', 'Fiora', 'medium', 5.0, 4.0, 56.0, 106, 107, 108, 109, 110),
('fizz', 'Fizz', 'easy', 6.0, 8.0, 48.0, 111, 112, 113, 114, 115),
('galio', 'Galio', 'easy', 0.0, 0.0, 47.0, 116, 117, 118, 119, 120),
('gangplank', 'Gangplank', 'easy', 5.0, 10.0, 46.0, 121, 122, 123, 124, 125),
('garen', 'Garen', 'easy', 2.0, 7.0, 53.0, 126, 127, 128, 129, 130),
('gragas', 'Gragas', 'easy', 3.0, 5.0, 54.0, 131, 132, 133, 134, 135),
('graves', 'Graves', 'easy', 7.0, 6.0, 53.0, 136, 137, 138, 139, 140),
('hecarim', 'Hecarim', 'easy', 3.0, 4.0, 56.0, 141, 142, 143, 144, 145),
('heimerdinger', 'Heimerdinger', 'easy', 4.0, 8.0, 51.0, 146, 147, 148, 149, 150),
('irelia', 'Irelia', 'easy', 2.0, 3.0, 54.0, 151, 152, 153, 154, 155),
('janna', 'Janna', 'easy', 4.0, 5.0, 54.0, 156, 157, 158, 159, 160),
('jarvan_iv', 'Jarvan IV', 'easy', 1.0, 4.0, 43.0, 161, 162, 163, 164, 165),
('jax', 'Jax', 'easy', 7.0, 3.0, 46.0, 166, 167, 168, 169, 170),
('jayce', 'Jayce', 'extreme', 8.0, 4.0, 53.0, 171, 172, 173, 174, 175),
('karma', 'Karma', 'easy', 2.0, 20.0, 57.0, 180, 181, 182, 183, 184),
('karthus', 'Karthus', 'easy', 4.0, 3.0, 51.0, 185, 186, 187, 188, 189),
('kassadin', 'Kassadin', 'easy', 4.0, 8.0, 49.0, 190, 191, 192, 193, 194),
('katarina', 'Katarina', 'easy', 25.0, 10.0, 59.0, 195, 196, 197, 198, 199),
('kayle', 'Kayle', 'easy', 5.0, 6.0, 51.0, 200, 201, 202, 203, 204),
('kennen', 'Kennen', 'suicidal', 4.0, 3.0, 52.0, 205, 206, 207, 208, 209),
('khazix', 'Kha''Zix', 'hard', 0.0, 0.0, 53.0, 210, 211, 212, 213, 214),
('kogmaw', 'Kog''Maw', 'medium', 0.0, 0.0, 54.0, 215, 216, 217, 218, 219),
('leblanc', 'LeBlanc', 'moderate', 1.0, 2.0, 47.0, 220, 221, 222, 223, 224),
('lee_sin', 'Lee Sin', 'easy', 3.0, 0.0, 48.0, 225, 226, 227, 228, 229),
('leona', 'Leona', 'easy', 3.0, 6.0, 49.0, 230, 231, 232, 233, 234),
('lulu', 'Lulu', 'easy', 5.0, 2.0, 48.0, 235, 236, 237, 238, 239),
('lux', 'Lux', 'unsure', 1.0, 2.0, 47.0, 240, 241, 242, 243, 244),
('malphite', 'Malphite', 'easy', 10.0, 30.0, 50.0, 245, 246, 247, 248, 249),
('malzahar', 'Malzahar', 'possible', 4.0, 2.0, 50.0, 250, 251, 252, 253, 254),
('maokai', 'Maokai', 'easy', 2.0, 4.0, 5.0, 255, 256, 257, 258, 259),
('master_yi', 'Master Yi', 'easy', 0.0, 0.0, 0.0, 260, 261, 262, 263, 264),
('miss_fortune', 'Miss Fortune', 'easy', 0.0, 0.0, 0.0, 265, 266, 267, 268, 269),
('mordekaiser', 'Mordekaiser', 'impossible', 0.0, 0.0, 0.0, 270, 271, 272, 273, 274),
('morgana', 'Morgana', 'easy', 0.0, 0.0, 0.0, 275, 276, 277, 278, 279),
('nami', 'Nami', 'easy', 0.0, 0.0, 0.0, 280, 281, 282, 283, 284),
('nasus', 'Nasus', 'easy', 0.0, 0.0, 0.0, 285, 286, 287, 288, 289),
('nautilus', 'Nautilus', 'hard', 0.0, 0.0, 0.0, 290, 291, 292, 293, 294),
('nidalee', 'Nidalee', 'easy', 0.0, 0.0, 0.0, 295, 296, 297, 298, 299),
('nocturne', 'Nocturne', 'theory', 0.0, 0.0, 0.0, 300, 301, 302, 303, 304),
('nunu', 'Nunu', 'super easy', 0.0, 0.0, 0.0, 305, 306, 307, 308, 309),
('olaf', 'Olaf', 'hard', 0.0, 0.0, 0.0, 310, 311, 312, 313, 314),
('orianna', 'Orianna', 'medium', 0.0, 0.0, 0.0, 315, 316, 317, 318, 319),
('pantheon', 'Pantheon', 'easy', 0.0, 0.0, 0.0, 320, 321, 322, 323, 324),
('poppy', 'Poppy', 'easy', 0.0, 0.0, 0.0, 325, 326, 327, 328, 329),
('quinn', 'Quinn', 'easy', 0.0, 0.0, 0.0, 330, 331, 332, 333, 334),
('rammus', 'Rammus', 'hard', 0.0, 0.0, 0.0, 335, 336, 337, 338, 339),
('renekton', 'Renekton', 'easy', 0.0, 0.0, 0.0, 340, 341, 342, 343, 344),
('rengar', 'Rengar', 'easy', 0.0, 0.0, 0.0, 345, 346, 347, 348, 349),
('riven', 'Riven', 'easy', 0.0, 0.0, 0.0, 350, 351, 352, 353, 354),
('rumble', 'Rumble', 'possible', 0.0, 0.0, 0.0, 355, 356, 357, 358, 359),
('ryze', 'Ryze', 'easy', 0.0, 0.0, 0.0, 360, 361, 362, 363, 364),
('sejuani', 'Sejuani', 'impossible', 0.0, 0.0, 0.0, 365, 366, 367, 368, 369),
('shaco', 'Shaco', 'easy', 0.0, 0.0, 0.0, 370, 371, 372, 373, 374),
('shen', 'Shen', 'easy', 0.0, 0.0, 0.0, 375, 376, 377, 378, 379),
('shyvana', 'Shyvana', 'die now', 0.0, 0.0, 0.0, 380, 381, 382, 383, 384),
('singed', 'Singed', 'easy', 0.0, 0.0, 0.0, 385, 386, 387, 388, 389),
('sion', 'Sion', 'easy', 0.0, 0.0, 0.0, 390, 391, 392, 393, 394),
('sivir', 'Sivir', 'easy', 0.0, 0.0, 0.0, 395, 396, 397, 398, 399),
('skarner', 'Skarner', 'easy', 0.0, 0.0, 0.0, 400, 401, 402, 403, 404),
('sona', 'Sona', 'easy', 0.0, 0.0, 0.0, 405, 406, 407, 408, 409),
('soraka', 'Soraka', 'hard', 0.0, 0.0, 0.0, 410, 411, 412, 413, 414),
('swain', 'Swain', 'easy', 0.0, 0.0, 0.0, 415, 416, 417, 418, 419),
('syndra', 'Syndra', 'medium', 0.0, 0.0, 0.0, 420, 421, 422, 423, 424),
('talon', 'Talon', 'easy', 0.0, 0.0, 0.0, 425, 426, 427, 428, 429),
('taric', 'Taric', 'hard', 0.0, 0.0, 0.0, 430, 431, 432, 433, 434),
('teemo', 'Teemo', 'easy', 0.0, 0.0, 0.0, 435, 436, 437, 438, 439),
('thresh', 'Thresh', 'hard', 0.0, 0.0, 0.0, 440, 441, 442, 443, 444),
('tristana', 'Tristana', 'easy', 0.0, 0.0, 0.0, 445, 446, 447, 448, 449),
('trundle', 'Trundle', 'easy', 0.0, 0.0, 0.0, 450, 451, 452, 453, 454),
('tryndamere', 'Tryndamere', 'impossible', 0.0, 0.0, 0.0, 455, 456, 457, 458, 459),
('twisted_fate', 'Twisted Fate', 'crazy', 0.0, 0.0, 0.0, 460, 461, 462, 463, 464),
('twitch', 'Twitch', 'easy', 0.0, 0.0, 0.0, 465, 466, 467, 468, 469),
('udyr', 'Udyr', 'easy', 0.0, 0.0, 0.0, 470, 471, 472, 473, 474),
('urgot', 'Urgot', 'medium', 0.0, 0.0, 0.0, 475, 476, 477, 478, 479),
('varus', 'Varus', 'okay', 0.0, 0.0, 0.0, 480, 481, 482, 483, 484),
('vayne', 'Vayne', 'easy', 0.0, 0.0, 0.0, 485, 486, 487, 488, 489),
('veigar', 'Veigar', 'super easy', 0.0, 0.0, 0.0, 490, 491, 492, 493, 494),
('vi', 'Vi', 'easy', 0.0, 0.0, 0.0, 495, 496, 497, 498, 499),
('viktor', 'Viktor', 'easy', 0.0, 0.0, 0.0, 500, 501, 502, 503, 504),
('vladimir', 'Vladimir', 'tough', 0.0, 0.0, 0.0, 505, 506, 507, 508, 509),
('volibear', 'Volibear', 'easy', 0.0, 0.0, 0.0, 510, 511, 512, 513, 514),
('warwick', 'Warwick', 'easy', 0.0, 0.0, 0.0, 515, 516, 517, 518, 519),
('wukong', 'Wukong', 'easy', 0.0, 0.0, 0.0, 520, 521, 522, 523, 524),
('xerath', 'Xerath', 'easy', 0.0, 0.0, 0.0, 525, 526, 527, 528, 529),
('xin_zhao', 'Xin Zhao', 'easy', 0.0, 0.0, 0.0, 530, 531, 532, 533, 534),
('yorick', 'Yorick', 'crazy', 0.0, 0.0, 0.0, 535, 536, 537, 538, 539),
('zac', 'Zac', 'easy', 0.0, 0.0, 0.0, 540, 541, 542, 543, 544),
('zed', 'Zed', 'maybe', 0.0, 0.0, 0.0, 545, 546, 547, 548, 549),
('ziggs', 'Ziggs', 'easy', 0.0, 0.0, 0.0, 550, 551, 552, 553, 554),
('zilean', 'Zilean', 'easy', 0.0, 0.0, 0.0, 555, 556, 557, 558, 559),
('zyra', 'Zyra', 'easy', 0.0, 0.0, 0.0, 560, 561, 562, 563, 564);

-- SAMPLE DATA

-- SUMMONERS
INSERT INTO summoners (id_summoner, name)
VALUES
('Faker', 'Sanghyeok Lee'),
('Gumayusi', 'Minhyung Lee'),
('Oner', 'Hyunjun Mun'),
('Keria', 'Minseok Ryu'),
('Asper', 'Taeki Kim'),
('Jeremy', 'Jay Steele'),
('Sean', 'Sean Side'),
('Snoop', 'Snoop Dogg'),
('2pac', 'Tupac Shakur'),
('Biggie', 'Christopher Wallace');

-- BLUE TEAM
INSERT INTO teams (total_gold_earned) VALUES (52387);
SET @id_team_blue = (SELECT id_team FROM teams ORDER BY id_team DESC LIMIT 1);

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('fizz', 'Faker');
UPDATE teams SET id_played_champion_1 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('twitch', 'Gumayusi');
UPDATE teams SET id_played_champion_2 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('teemo', 'Oner');
UPDATE teams SET id_played_champion_3 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('nunu', 'Keria');
UPDATE teams SET id_played_champion_4 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('akali', 'Asper');
UPDATE teams SET id_played_champion_5 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

-- RED TEAM
INSERT INTO teams (total_gold_earned) VALUES (29927);
SET @id_team_red = (SELECT id_team FROM teams ORDER BY id_team DESC LIMIT 1);

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('fiddlesticks', 'Jeremy');
UPDATE teams SET id_played_champion_1 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('viktor', 'Sean');
UPDATE teams SET id_played_champion_2 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('thresh', '2pac');
UPDATE teams SET id_played_champion_3 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('twitch', 'Biggie');
UPDATE teams SET id_played_champion_4 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('darius', 'Snoop');
UPDATE teams SET id_played_champion_5 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

-- MATCH 1 
INSERT INTO matches (id_team_red, id_team_blue, winning_team, match_duration_seconds)
VALUES (@id_team_red, @id_team_blue, 'blue', 1721);

-- BLUE TEAM
INSERT INTO teams (total_gold_earned) VALUES (71433);
SET @id_team_blue = (SELECT id_team FROM teams ORDER BY id_team DESC LIMIT 1);

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('fizz', 'Biggie');
UPDATE teams SET id_played_champion_1 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('brand', 'Sean');
UPDATE teams SET id_played_champion_2 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('skarner', 'Jeremy');
UPDATE teams SET id_played_champion_3 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('swain', '2pac');
UPDATE teams SET id_played_champion_4 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('trundle', 'Snoop');
UPDATE teams SET id_played_champion_5 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

-- RED TEAM
INSERT INTO teams (total_gold_earned) VALUES (86985);
SET @id_team_red = (SELECT id_team FROM teams ORDER BY id_team DESC LIMIT 1);

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('akali', 'Asper');
UPDATE teams SET id_played_champion_1 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('ahri', 'Keria');
UPDATE teams SET id_played_champion_2 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('teemo', 'Oner');
UPDATE teams SET id_played_champion_3 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('twitch', 'Gumayusi');
UPDATE teams SET id_played_champion_4 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('cassiopeia', 'Faker');
UPDATE teams SET id_played_champion_5 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

-- MATCH 2 
INSERT INTO matches (id_team_red, id_team_blue, winning_team, match_duration_seconds)
VALUES (@id_team_red, @id_team_blue, 'red', 1699);

-- RED TEAM

INSERT INTO teams (total_gold_earned) VALUES (45567);
SET @id_team_red = (SELECT id_team FROM teams ORDER BY id_team DESC LIMIT 1);

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('zed', 'Snoop');
UPDATE teams SET id_played_champion_1 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('draven', 'Sean');
UPDATE teams SET id_played_champion_2 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('lulu', 'Jeremy');
UPDATE teams SET id_played_champion_3 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('ezreal', 'Gumayusi');
UPDATE teams SET id_played_champion_4 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('ziggs', '2pac');
UPDATE teams SET id_played_champion_5 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_red;

-- Blue TEAM

INSERT INTO teams (total_gold_earned) VALUES (71433);
SET @id_team_blue = (SELECT id_team FROM teams ORDER BY id_team DESC LIMIT 1);

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('corki', 'Gumayusi');
UPDATE teams SET id_played_champion_1 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('twitch', 'Faker');
UPDATE teams SET id_played_champion_2 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('nidalee', 'Oner');
UPDATE teams SET id_played_champion_3 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('quinn', 'Asper');
UPDATE teams SET id_played_champion_4 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

INSERT INTO played_champions (id_champion, id_summoner) VALUES ('pantheon', 'Keria');
UPDATE teams SET id_played_champion_5 = (SELECT id_played_champion from played_champions ORDER BY id_played_champion DESC LIMIT 1)
WHERE id_team = @id_team_blue;

-- MATCH 3
INSERT INTO matches (id_team_red, id_team_blue, winning_team, match_duration_seconds)
VALUES (@id_team_red, @id_team_blue, 'blue', 1901);



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;