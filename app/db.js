'use strict';

const user = 'siderss';
const password = '7107';

// Get an instance of mysql we can use in the app
const mysql = require('mysql');
const fs = require('fs');

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
                    console.log(championData[0]);
                    if (err) return reject(err);
                    return resolve(championData[0]);
                }
            );
        }
    );
}

function updateChampion(champion) {
    return new Promise(
        (resolve, reject) => {
            pool.query(`UPDATE champions SET
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
                `SELECT teams.total_gold_earned,
                champion_1.name, champion_2.name, champion_3.name, champion_4.name, champion_5.name,
                summoner_1.name, summoner_2.name, summoner_3.name, summoner_4.name, summoner_5.name
                FROM teams
                -- 1
                LEFT JOIN played_champions AS p1 ON p1.id_played_champion = teams.id_played_champion_1
                INNER JOIN champions AS champion_1 ON champion_1.id_champion = p1.id_champion
                INNER JOIN summoners AS summoner_1 ON summoner_1.id_summoner = p1.id_summoner
                -- 2
                LEFT JOIN played_champions AS p2 ON p2.id_played_champion = teams.id_played_champion_2
                INNER JOIN champions AS champion_2 ON champion_2.id_champion = p2.id_champion
                INNER JOIN summoners AS summoner_2 ON summoner_2.id_summoner = p2.id_summoner
                -- 3
                LEFT JOIN played_champions AS p3 ON p3.id_played_champion = teams.id_played_champion_3
                INNER JOIN champions AS champion_3 ON champion_3.id_champion = p3.id_champion
                INNER JOIN summoners AS summoner_3 ON summoner_3.id_summoner = p3.id_summoner
                -- 4
                LEFT JOIN played_champions AS p4 ON p4.id_played_champion = teams.id_played_champion_4
                INNER JOIN champions AS champion_4 ON champion_4.id_champion = p4.id_champion
                INNER JOIN summoners AS summoner_4 ON summoner_4.id_summoner = p4.id_summoner
                -- 5
                LEFT JOIN played_champions AS p5 ON p5.id_played_champion = teams.id_played_champion_5
                INNER JOIN champions AS champion_5 ON champion_5.id_champion = p5.id_champion
                INNER JOIN summoners AS summoner_5 ON summoner_5.id_summoner = p5.id_summoner
                --
                WHERE teams.id_team = '${id_team}'`,
                (err, team) => {
                    if (err) return reject(err);
                    console.log(team[0]);
                    return resolve(team[0]);
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
module.exports.getMatches = getMatches;
module.exports.getTeam = getTeam;
module.exports.resetDatabase = resetDatabase;