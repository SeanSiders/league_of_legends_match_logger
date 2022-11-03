'use strict';

const user = 'siderss';
const password = '7107';

// Get an instance of mysql we can use in the app
const mysql = require('mysql');
const fs = require('fs');
const { match } = require('assert');

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

function getPlayedChampion(id_played_champion) {
    return new Promise(
        (resolve, reject) => {
            pool.query(
                `SELECT champions.name AS champion_name, summoners.name AS summoner_name FROM played_champions
                INNER JOIN champions ON champions.id_champion = played_champions.id_champion
                INNER JOIN summoners ON summoners.id_summoner = played_champions.id_summoner
                WHERE id_played_champion = ${id_played_champion}`,
                (err, playedChampion) => {
                    if (err) return reject(err);
                    console.log(playedChampion);
                    if (playedChampion.length == 0) return resolve(null);
                    return resolve({
                        champion_name: playedChampion[0].champion_name,
                        summoner_name: playedChampion[0].summoner_name
                    });
                }
            );
        }
    );
}

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
                    if (team.id_played_champion_1) {
                        team.played_champions[0] = await getPlayedChampion(team.id_played_champion_1);
                    }
                    if (team.id_played_champion_2) {
                        team.played_champions[1] = await getPlayedChampion(team.id_played_champion_2);
                    }
                    if (team.id_played_champion_3) {
                        team.played_champions[2] = await getPlayedChampion(team.id_played_champion_3);
                        console.log(team.id_played_champion_3);
                    }
                    if (team.id_played_champion_4) {
                        team.played_champions[3] = await getPlayedChampion(team.id_played_champion_4);
                    }
                    if (team.id_played_champion_5) {
                        team.played_champions[4] = await getPlayedChampion(team.id_played_champion_5);
                    }
                    console.log(team);

                    return resolve(team);
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
                    if (err) return reject(err);
                    console.log(results);

                    pool.query(
                        fs.readFileSync('./sql/init.sql').toString(),
                        (err, results) => {
                            if (err) return reject(err);
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
module.exports.deleteChampion = deleteChampion;
module.exports.getMatches = getMatches;
module.exports.getTeam = getTeam;
module.exports.resetDatabase = resetDatabase;