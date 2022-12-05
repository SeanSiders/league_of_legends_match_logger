'use strict';

const user = '';
const password = '';

// Get an instance of mysql we can use in the app
const mysql = require('mysql');
const fs = require('fs');
const { match } = require('assert');
const { create } = require('domain');

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    multipleStatements: true,
    connectionLimit : 10,
    host            : 'classmysql.engr.oregonstate.edu',
    user            : 'cs340_' + user,
    password        :  password,
    database        : 'cs340_' + user
});

// ---------------------------------------------------------------------------
// GENERICS 
// ---------------------------------------------------------------------------

function getLastInsertedRowID_AutoIncrement(tableName, idColumn) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT ${idColumn} FROM ${tableName} ORDER BY ${idColumn} DESC LIMIT 1`,
                (err, id) => {
                    if (err) return reject(err);
                    return resolve(id[0][idColumn]);
                }
            );
        }
    );
}

// ---------------------------------------------------------------------------
// CHAMPIONS
// ---------------------------------------------------------------------------

function getChampions() {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT champions.id_champion, champions.name, champions.difficulty_level, champions.ban_rate, champions.pick_rate, champions.win_rate,
                skill_P.name AS P, skill_Q.name AS Q, skill_W.name AS W, skill_E.name AS E, skill_R.name AS R
                FROM champions 
                INNER JOIN skills AS skill_P ON skill_P.id_skill = champions.id_skill_P
                INNER JOIN skills AS skill_Q ON skill_Q.id_skill = champions.id_skill_Q
                INNER JOIN skills AS skill_W ON skill_W.id_skill = champions.id_skill_W
                INNER JOIN skills AS skill_E ON skill_E.id_skill = champions.id_skill_E
                INNER JOIN skills AS skill_R ON skill_R.id_skill = champions.id_skill_R`,
                (err, champions) => {
                    if (err) return reject(err);
                    return resolve(champions);
                }
            );
        }
    );
}

function getChampionKeyValuePairs() {
    return new Promise(
        (resolve, reject) => {
            pool.query(`SELECT champions.id_champion, champions.name FROM champions`,
                (err, champions) => {
                    if (err) return reject(err);
                    return resolve(champions);
                }
            );
        }
    );
}

function getChampion(id_champion) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT champions.id_champion, champions.name, champions.difficulty_level, champions.ban_rate, champions.pick_rate, champions.win_rate,
                skill_P.name AS P, skill_Q.name AS Q, skill_W.name AS W, skill_E.name AS E, skill_R.name AS R,
                skill_P.description AS P_desc, skill_Q.description AS Q_desc, skill_W.description AS W_desc, skill_E.description AS E_desc, skill_R.description AS R_desc
                FROM champions 
                INNER JOIN skills AS skill_P ON skill_P.id_skill = champions.id_skill_P
                INNER JOIN skills AS skill_Q ON skill_Q.id_skill = champions.id_skill_Q
                INNER JOIN skills AS skill_W ON skill_W.id_skill = champions.id_skill_W
                INNER JOIN skills AS skill_E ON skill_E.id_skill = champions.id_skill_E
                INNER JOIN skills AS skill_R ON skill_R.id_skill = champions.id_skill_R
                WHERE champions.id_champion = '${id_champion}'
                LIMIT 1`,
                (err, championData) => {
                    if (err) return reject(err);
                    return resolve(championData[0]);
                }
            );
        }
    );
}

async function createChampion(champion) {
    champion.id_skill_P = await createSkill({
        'id_skill': champion.p,
        'name': champion.p,
        'description': champion.p_desc,
    });
    champion.id_skill_Q = await createSkill({
        'id_skill': champion.q,
        'name': champion.q,
        'description': champion.q_desc,
    });
    champion.id_skill_W = await createSkill({
        'id_skill': champion.w,
        'name': champion.w,
        'description': champion.w_desc,
    });
    champion.id_skill_E = await createSkill({
        'id_skill': champion.e,
        'name': champion.e,
        'description': champion.e_desc,
    });
    champion.id_skill_R = await createSkill({
        'id_skill': champion.r,
        'name': champion.r,
        'description': champion.r_desc,
    });

    return new Promise(
        (resolve, reject) => {
            pool.query(
                `INSERT INTO champions 
                (id_champion, name, difficulty_level, ban_rate, pick_rate, win_rate, id_skill_P, id_skill_Q, id_skill_W, id_skill_E, id_skill_R)
                VALUES (
                    '${champion.name}',
                    '${champion.name}',
                    '${champion.difficulty_level}',
                    ${champion.ban_rate},
                    ${champion.pick_rate},
                    ${champion.win_rate},
                    ${champion.id_skill_P},
                    ${champion.id_skill_Q},
                    ${champion.id_skill_W},
                    ${champion.id_skill_E},
                    ${champion.id_skill_R}
                );`,
            (err, result) => {
                if (err) return reject(err);
                return resolve(result);
            }
            );
        }
    );
};

function updateChampion(champion) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `UPDATE champions SET
                difficulty_level = '${champion.difficulty_level}',
                ban_rate = ${champion.ban_rate},
                pick_rate = ${champion.pick_rate},
                win_rate = ${champion.win_rate}
                WHERE champions.id_champion = '${champion.id_champion}'`,
                (err, result) => {
                    if (err) return reject(err);
                    return resolve(result);
                }
            );
        }
    );
}

function deleteChampion(id_champion) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `DELETE FROM champions WHERE id_champion = '${id_champion}'`,
                (err, result) => {
                    if (err) return reject(err);
                    return resolve(result);
                }
            );
        }
    );
}

// ---------------------------------------------------------------------------
// SKILLS 
// ---------------------------------------------------------------------------

async function createSkill(skill) {
    await new Promise(
        (resolve, reject) => {
            pool.query(
                `INSERT INTO skills (id_skill, name, description)
                VALUES ('${skill.name}', '${skill.name}', '${skill.description}')`,
                (err, result) => {
                    if (err) return reject(err);
                    return resolve(result);
                }
            );
        }
    );

    return getLastInsertedRowID_AutoIncrement('skills', 'id_skill');
}

// ---------------------------------------------------------------------------
// SUMMONERS 
// ---------------------------------------------------------------------------

function summonerExists(riotID) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT id_summoner FROM summoners WHERE id_summoner = '${riotID}'`,
                (err, results) => {
                    if (err) return reject(err);
                    return resolve(results.length > 0);
                }
            );
        }
    );
}

function createOrUpdateSummoner(riotID, summonerName) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `INSERT INTO summoners (id_summoner, name) VALUES ('${riotID}', '${summonerName}')
                ON DUPLICATE KEY UPDATE name = '${summonerName}'`,
                (err, results) => {
                    if (err) return reject(err);
                    return resolve(results);
                }
            );
        }
    );
}

function getSummoners() {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT id_summoner, name FROM summoners`,
            (err, results) => {
                if (err) return reject(err);
                return resolve(results);
            }
            );
        }
    )
}

function getSummonerName(id_summ) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT name FROM summoners WHERE id_summoner = '${id_summ}'`,
                (err, results) => {
                    if (err) return reject(err);
                    return resolve(results);
                }
            );
        }
    )
}


function getSummonerChampion(id_summ) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT champions.name FROM champions 
                INNER JOIN played_champions on played_champions.id_champion = champions.id_champion
                INNER JOIN summoners on summoners.id_summoner = played_champions.id_summoner
                WHERE summoners.id_summoner = '${id_summ}'`,
                (err, results) => {
                    if (err) return reject(err);
                    return resolve(results);
                }
            );
        }
    )
}


async function createOrUpdateSummoners(match) {
    await createOrUpdateSummoner(match.red_rid_1, match.red_summoner_1);
    await createOrUpdateSummoner(match.red_rid_2, match.red_summoner_2);
    await createOrUpdateSummoner(match.red_rid_3, match.red_summoner_3);
    await createOrUpdateSummoner(match.red_rid_4, match.red_summoner_4);
    await createOrUpdateSummoner(match.red_rid_5, match.red_summoner_5);

    await createOrUpdateSummoner(match.blue_rid_1, match.blue_summoner_1);
    await createOrUpdateSummoner(match.blue_rid_2, match.blue_summoner_2);
    await createOrUpdateSummoner(match.blue_rid_3, match.blue_summoner_3);
    await createOrUpdateSummoner(match.blue_rid_4, match.blue_summoner_4);
    await createOrUpdateSummoner(match.blue_rid_5, match.blue_summoner_5);
}

// ---------------------------------------------------------------------------
// PLAYED CHAMPIONS 
// ---------------------------------------------------------------------------

function getPlayedChampion(id_played_champion) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT 
                played_champions.id_played_champion,
                champions.id_champion,
                champions.name AS champion_name,
                summoners.id_summoner,
                summoners.name AS summoner_name
                FROM played_champions
                INNER JOIN champions ON champions.id_champion = played_champions.id_champion
                INNER JOIN summoners ON summoners.id_summoner = played_champions.id_summoner
                WHERE id_played_champion = ${id_played_champion}`,
                (err, result) => {
                    if (err) return reject(err);
                    if (result.length == 0) return resolve({});

                    let playedChampion = {
                        id_played_champion: result[0].id_played_champion,
                        id_champion: result[0].id_champion,
                        champion_name: result[0].champion_name,
                        id_summoner: result[0].id_summoner,
                        summoner_name: result[0].summoner_name
                    };

                    if (playedChampion.id_champion == null) playedChampion.id_champion = '';
                    if (playedChampion.champion_name == null) playedChampion.champion_name = '';

                    if (playedChampion.id_summoner == null) playedChampion.id_summoner = '';
                    if (playedChampion.summoner_name == null) playedChampion.summoner_name = '';

                    return resolve(playedChampion);
                }
            );
        }
    );
}

async function createPlayedChampions(match) {
    await createPlayedChampion({
        id_summoner: match.red_rid_1,
        id_champion: match.red_champion_1,
    });
    match.red_played_champion_1 = await getLastInsertedRowID_AutoIncrement('played_champions', 'id_played_champion');

    await createPlayedChampion({
        id_summoner: match.red_rid_2,
        id_champion: match.red_champion_2
    });
    match.red_played_champion_2 = await getLastInsertedRowID_AutoIncrement('played_champions', 'id_played_champion');

    await createPlayedChampion({
        id_summoner: match.red_rid_3,
        id_champion: match.red_champion_3
    });
    match.red_played_champion_3 = await getLastInsertedRowID_AutoIncrement('played_champions', 'id_played_champion');

    await createPlayedChampion({
        id_summoner: match.red_rid_4,
        id_champion: match.red_champion_4
    });
    match.red_played_champion_4 = await getLastInsertedRowID_AutoIncrement('played_champions', 'id_played_champion');

    await createPlayedChampion({
        id_summoner: match.red_rid_5,
        id_champion: match.red_champion_5
    });
    match.red_played_champion_5 = await getLastInsertedRowID_AutoIncrement('played_champions', 'id_played_champion');

    await createPlayedChampion({
        id_summoner: match.blue_rid_1,
        id_champion: match.blue_champion_1,
    });
    match.blue_played_champion_1 = await getLastInsertedRowID_AutoIncrement('played_champions', 'id_played_champion');

    await createPlayedChampion({
        id_summoner: match.blue_rid_2,
        id_champion: match.blue_champion_2
    });
    match.blue_played_champion_2 = await getLastInsertedRowID_AutoIncrement('played_champions', 'id_played_champion');

    await createPlayedChampion({
        id_summoner: match.blue_rid_3,
        id_champion: match.blue_champion_3
    });
    match.blue_played_champion_3 = await getLastInsertedRowID_AutoIncrement('played_champions', 'id_played_champion');

    await createPlayedChampion({
        id_summoner: match.blue_rid_4,
        id_champion: match.blue_champion_4
    });
    match.blue_played_champion_4 = await getLastInsertedRowID_AutoIncrement('played_champions', 'id_played_champion');

    await createPlayedChampion({
        id_summoner: match.blue_rid_5,
        id_champion: match.blue_champion_5
    });
    match.blue_played_champion_5 = await getLastInsertedRowID_AutoIncrement('played_champions', 'id_played_champion');

    return match;
}

function createPlayedChampion(playedChampon) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `INSERT INTO played_champions (id_champion, id_summoner) VALUES ('${playedChampon.id_champion}', '${playedChampon.id_summoner}')`,
                (err, results) => {
                    if (err) return reject(err);
                    return resolve(results);
                }
            );
        }
    );
}

async function updatePlayedChampions(matchData) {
    let match = await getMatch(matchData.id_match);
    // Red
    match.red_team.played_champions[0].id_summoner = matchData.red_rid_1;
    match.red_team.played_champions[0].id_champion = matchData.red_champion_1;
    await updatePlayedChampion(match.red_team.played_champions[0]);

    match.red_team.played_champions[1].id_summoner = matchData.red_rid_2;
    match.red_team.played_champions[1].id_champion = matchData.red_champion_2;
    await updatePlayedChampion(match.red_team.played_champions[1]);

    match.red_team.played_champions[2].id_summoner = matchData.red_rid_3;
    match.red_team.played_champions[2].id_champion = matchData.red_champion_3;
    await updatePlayedChampion(match.red_team.played_champions[2]);

    match.red_team.played_champions[3].id_summoner = matchData.red_rid_4;
    match.red_team.played_champions[3].id_champion = matchData.red_champion_4;
    await updatePlayedChampion(match.red_team.played_champions[3]);

    match.red_team.played_champions[4].id_summoner = matchData.red_rid_5;
    match.red_team.played_champions[4].id_champion = matchData.red_champion_5;
    await updatePlayedChampion(match.red_team.played_champions[4]);

    // Blue 
    match.blue_team.played_champions[0].id_summoner = matchData.blue_rid_1;
    match.blue_team.played_champions[0].id_champion = matchData.blue_champion_1;
    await updatePlayedChampion(match.blue_team.played_champions[0]);

    match.blue_team.played_champions[1].id_summoner = matchData.blue_rid_2;
    match.blue_team.played_champions[1].id_champion = matchData.blue_champion_2;
    await updatePlayedChampion(match.blue_team.played_champions[1]);

    match.blue_team.played_champions[2].id_summoner = matchData.blue_rid_3;
    match.blue_team.played_champions[2].id_champion = matchData.blue_champion_3;
    await updatePlayedChampion(match.blue_team.played_champions[2]);

    match.blue_team.played_champions[3].id_summoner = matchData.blue_rid_4;
    match.blue_team.played_champions[3].id_champion = matchData.blue_champion_4;
    await updatePlayedChampion(match.blue_team.played_champions[3]);

    match.blue_team.played_champions[4].id_summoner = matchData.blue_rid_5;
    match.blue_team.played_champions[4].id_champion = matchData.blue_champion_5;
    await updatePlayedChampion(match.blue_team.played_champions[4]);
}

function updatePlayedChampion(playedChampion) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `UPDATE played_champions SET 
                id_champion = '${playedChampion.id_champion}',
                id_summoner = '${playedChampion.id_summoner}'
                WHERE id_played_champion = ${playedChampion.id_played_champion}`,
                (err, results) => {
                    if (err) return reject(err);
                    return resolve(results);
                }
            );
        }
    );
}

// ---------------------------------------------------------------------------
// MATCHES 
// ---------------------------------------------------------------------------

function getMatches() {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT * FROM matches`,
                async (err, matches) => {
                    if (err) return reject(err);
                    try {
                        for (let match of matches) {
                            match.red_team = await getTeam(match.id_team_red);
                            match.blue_team = await getTeam(match.id_team_blue);
                        }
                        return resolve(matches);
                    } catch (err) {
                        return reject(err);
                    }
                }
            );
        }
    );
}

function getLastSummonerMatch(id_summoner) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT * FROM matches
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
                        summoners.id_summoner = '${id_summoner}'
                ORDER BY id_match DESC LIMIT 1`,
                async (err, matches) => {
                    if (err) return reject(err);
                    try {
                        for (let match of matches) {
                            match.red_team = await getTeam(match.id_team_red);
                            match.blue_team = await getTeam(match.id_team_blue);
                        }
                        return resolve(matches);
                    } catch (err) {
                        return reject(err);
                    }
                }
            );
        }
    );
}

function getMatch(id_match) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT * FROM matches WHERE id_match = '${id_match}'`,
                async (err, matchData) => {
                    if (err) return reject(err);
                    let match = matchData[0];

                    try {
                        match.red_team = await getTeam(match.id_team_red);
                        match.blue_team = await getTeam(match.id_team_blue);

                        return resolve(match);
                    } catch (err) {
                        return reject(err);
                    }
                }
            );
        }
    );
}

async function createMatch(match) {
    await createOrUpdateSummoners(match);
    match = await createPlayedChampions(match);
    match = await createRedBlueMatchTeams(match);
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `INSERT INTO matches (id_team_red, id_team_blue, winning_team, match_duration_seconds)
                VALUES (${match.id_team_red}, ${match.id_team_blue}, '${match.winning_team}', ${match.match_duration_seconds})`,
                (err, results) => {
                    if (err) return reject(err);
                    return resolve(results);
                }
            );
        }
    );
}

async function updateMatch(match) {
    await createOrUpdateSummoners(match);
    await updatePlayedChampions(match);

    return new Promise(
        (resolve, reject) => {
            pool.query(
                `UPDATE matches SET
                winning_team = '${match.winning_team}',
                match_duration_seconds = ${match.match_duration_seconds}
                WHERE id_match = ${match.id_match}`,
                (err, results) => {
                    if (err) return reject(err);
                    return resolve(results);
                }
            );
        }
    );
}

function deleteMatch(id_match) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `DELETE FROM matches WHERE id_match = '${id_match}'`,
                (err, result) => {
                    if (err) return reject(err);
                    return resolve(result);
                }
            );
        }
    );
}

// ---------------------------------------------------------------------------
// TEAMS
// ---------------------------------------------------------------------------

function getTeam(id_team) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT * FROM teams WHERE teams.id_team = ${id_team}`,
                async (err, team) => {
                    if (err) return reject(err);
                    team = team[0]

                    // Populate up to 5 played champions for this team
                    team.played_champions = [5];
                    if (team.id_played_champion_1 != null) {
                        team.played_champions[0] = await getPlayedChampion(team.id_played_champion_1);
                    } 
                    if (team.id_played_champion_2 != null) {
                        team.played_champions[1] = await getPlayedChampion(team.id_played_champion_2);
                    } 
                    if (team.id_played_champion_3 != null) {
                        team.played_champions[2] = await getPlayedChampion(team.id_played_champion_3);
                    } 
                    if (team.id_played_champion_4 != null) {
                        team.played_champions[3] = await getPlayedChampion(team.id_played_champion_4);
                    } 
                    if (team.id_played_champion_5 != null) {
                        team.played_champions[4] = await getPlayedChampion(team.id_played_champion_5);
                    } 

                    return resolve(team);
                }
            );
        }
    );
}

async function createRedBlueMatchTeams(match) {
    await createTeam({
        total_gold_earned: match.red_gold,
        id_played_champion_1: match.red_played_champion_1,
        id_played_champion_2: match.red_played_champion_2,
        id_played_champion_3: match.red_played_champion_3,
        id_played_champion_4: match.red_played_champion_4,
        id_played_champion_5: match.red_played_champion_5,
    });
    match.id_team_red = await getLastInsertedRowID_AutoIncrement('teams', 'id_team');

    await createTeam({
        total_gold_earned: match.blue_gold,
        id_played_champion_1: match.blue_played_champion_1,
        id_played_champion_2: match.blue_played_champion_2,
        id_played_champion_3: match.blue_played_champion_3,
        id_played_champion_4: match.blue_played_champion_4,
        id_played_champion_5: match.blue_played_champion_5,
    });
    match.id_team_blue = await getLastInsertedRowID_AutoIncrement('teams', 'id_team');

    return match;
}

async function createTeam(team) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `INSERT INTO teams (total_gold_earned, id_played_champion_1, id_played_champion_2, id_played_champion_3, id_played_champion_4, id_played_champion_5)
                VALUES (${team.total_gold_earned}, '${team.id_played_champion_1}', '${team.id_played_champion_2}', '${team.id_played_champion_3}', '${team.id_played_champion_4}', '${team.id_played_champion_5}')`,
                (err, results) => {
                    if (err) return reject(err);
                    return resolve(results);
                }
            );
        }
    );
}

// ---------------------------------------------------------------------------
// DB OPERATIONS
// ---------------------------------------------------------------------------

function resetDatabase() {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                fs.readFileSync('./sql/clear.sql').toString(),
                (err, results) => {
                    if (err) {
                        console.log(`ERROR OCCURED\n${err.message}`);
                        return reject(err);
                    }

                    console.log('TABLES DROPPED')
                    console.log(results);

                    pool.query(
                        fs.readFileSync('./sql/init.sql').toString(),
                        (err, results) => {
                            if (err) {
                                console.log(`ERROR OCCURED\n${err.message}`);
                                return reject(err);
                            }

                            console.log('TABLES CREATED - DATA INITIALIZED');
                            console.log(results);

                            return resolve(results);
                        }
                    );
                }
            );
        }
    )
}

// ---------------------------------------------------------------------------

module.exports.pool = pool;
module.exports.getChampions = getChampions;
module.exports.getChampionKeyValuePairs = getChampionKeyValuePairs;
module.exports.getChampion = getChampion;
module.exports.updateChampion = updateChampion;
module.exports.createChampion = createChampion;
module.exports.deleteChampion = deleteChampion;
module.exports.getMatches = getMatches;
module.exports.getMatch = getMatch;
module.exports.getTeam = getTeam;
module.exports.createMatch = createMatch;
module.exports.updateMatch = updateMatch;
module.exports.deleteMatch = deleteMatch;
module.exports.resetDatabase = resetDatabase;
module.exports.getSummoners = getSummoners;
module.exports.getSummonerName = getSummonerName;
module.exports.getSummonerChampion = getSummonerChampion;
module.exports.getSummonerMatches = getLastSummonerMatch;
