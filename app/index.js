'use strict';
const express = require('express');
const db = require('./db');
const path = require('path');

const app = express();
const PORT = 3090;

app.set('view engine', 'ejs');

//Automatically decode the URL in POST methods
app.use(express.urlencoded({
    extended: false
}));

app.use(express.json());

app.use('/css', express.static(path.join(__dirname, 'css')));
//app.use('/views', express.static(path.join(__dirname, 'views')));

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}...`);
});

app.get('/', (req, res) => {
    res.render('pages/index');
});

app.get('/champions', (req, res) => {
    db.pool.query(
        `SELECT champions.id_champion, champions.name, champions.difficulty_level, champions.ban_rate, champions.pick_rate, champions.win_rate,
        skill_P.name AS P, skill_Q.name AS Q, skill_W.name AS W, skill_E.name AS E, skill_R.name AS R
        FROM champions 
        INNER JOIN skills AS skill_P ON skill_P.id_skill = champions.id_skill_P
        INNER JOIN skills AS skill_Q ON skill_Q.id_skill = champions.id_skill_Q
        INNER JOIN skills AS skill_W ON skill_W.id_skill = champions.id_skill_W
        INNER JOIN skills AS skill_E ON skill_E.id_skill = champions.id_skill_E
        INNER JOIN skills AS skill_R ON skill_R.id_skill = champions.id_skill_R`,
        (err, data, fields) => {
            if (err == null) {
                res.render('pages/champions', {
                    champions: data
                });
            } else {
                res.send(`Something went wrong :( ${err}`);
            }
        }
    );
});

app.get('/summoners', (req, res) => {
    res.render('pages/summoners');
});

app.get('/skills', (req, res) => {
    res.render('pages/skills');
});

app.get('/create_match', (req, res) => {
    res.render('pages/create_match');
});

app.get('/create_champion', (req, res) => {
    res.render('pages/create_champion');
});

app.get('/db_overview', (req, res) => {
    res.render('pages/db_overview');
});

app.get('/matches', (req, res) => {
    res.render('pages/matches');
});

app.get('/champions/edit', (req, res) => {
    db.pool.query(
        `SELECT champions.id_champion, champions.name, champions.difficulty_level, champions.ban_rate, champions.pick_rate, champions.win_rate,
        skill_P.name AS P, skill_Q.name AS Q, skill_W.name AS W, skill_E.name AS E, skill_R.name AS R,
        skill_P.description AS P_desc, skill_Q.description AS Q_desc, skill_W.description AS W_desc, skill_E.description AS E_desc, skill_R.description AS R_desc
        FROM champions 
        INNER JOIN skills AS skill_P ON skill_P.id_skill = champions.id_skill_P
        INNER JOIN skills AS skill_Q ON skill_Q.id_skill = champions.id_skill_Q
        INNER JOIN skills AS skill_W ON skill_W.id_skill = champions.id_skill_W
        INNER JOIN skills AS skill_E ON skill_E.id_skill = champions.id_skill_E
        INNER JOIN skills AS skill_R ON skill_R.id_skill = champions.id_skill_R
        WHERE champions.id_champion = '${req.query.id_champion}'
        LIMIT 1`,
        (err, data, fields) => {
            if (err == null && data.length == 1) {
                res.render('pages/edit_champion', {
                    champion: data[0]
                });
            } else {
                res.send(`Something went wrong :( ${err}`);
            }
        }
    );
});

app.post('/champions/edit', (req, res) => {
    /* TODO: implement update
    db.pool.query(
        `UPDATE champions SET ban_rate = ${req.body.ban_rate}, pick_rate = ${req.body.pick_rate}, win_rate = ${req.body.win_rate}
        WHERE champions.id_champion = ${req.query.id_champion};`
    );
    */
    db.pool.query(
        `SELECT champions.id_champion, champions.name, champions.difficulty_level, champions.ban_rate, champions.pick_rate, champions.win_rate,
        skill_P.name AS P, skill_Q.name AS Q, skill_W.name AS W, skill_E.name AS E, skill_R.name AS R,
        skill_P.description AS P_desc, skill_Q.description AS Q_desc, skill_W.description AS W_desc, skill_E.description AS E_desc, skill_R.description AS R_desc
        FROM champions 
        INNER JOIN skills AS skill_P ON skill_P.id_skill = champions.id_skill_P
        INNER JOIN skills AS skill_Q ON skill_Q.id_skill = champions.id_skill_Q
        INNER JOIN skills AS skill_W ON skill_W.id_skill = champions.id_skill_W
        INNER JOIN skills AS skill_E ON skill_E.id_skill = champions.id_skill_E
        INNER JOIN skills AS skill_R ON skill_R.id_skill = champions.id_skill_R
        WHERE champions.id_champion = '${req.query.id_champion}'
        LIMIT 1`,
        (err, data, fields) => {
            if (err == null && data.length == 1) {
                res.render('pages/edit_champion', {
                    champion: data[0]
                });
            } else {
                res.send(`Something went wrong :( ${err}`);
            }
        }
    );
});

app.get('/champions/delete', (req, res) => {
    res.send(req.query.id_champion);
});