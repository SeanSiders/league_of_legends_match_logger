'use strict';
const express = require('express');
const db = require('./db');
const path = require('path');

const app = express();
const PORT = 3099;

app.set('view engine', 'ejs');

//Automatically decode the URL in POST methods
app.use(express.urlencoded({
    extended: false
}));

app.use(express.json());

app.use('/css', express.static(path.join(__dirname, 'css')));
app.use('/sql', express.static(path.join(__dirname, 'sql')));

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}...`);
});

// ---------------------------------------------------------------------------
// INDEX 
// ---------------------------------------------------------------------------

app.get('/', async (req, res) => {
    res.render('pages/index', {
        champions: await db.getChampionKeyValuePairs()
    });
});

app.get('/reset_db', async (req, res) => {
    await db.resetDatabase();
    res.render('pages/index', {
        champions: await db.getChampionKeyValuePairs()
    });
});

// ---------------------------------------------------------------------------
// CHAMPIONS
// ---------------------------------------------------------------------------

app.get('/champions', async (req, res) => {
    res.render('pages/champions', {
        champions: await db.getChampions()
    });
});

app.get('/create_champion', (req, res) => {
    res.render('pages/create_champion');
});

app.get('/champions/edit', async (req, res) => {
    try {
        res.render('pages/edit_champion', {
            champion: await db.getChampion(req.query.id_champion)
        });
    } catch (err) {
        res.send(`Something went wrong :( ${err}`);
    }
});

app.post('/champions/edit', async (req, res) => {
    let id_champion = req.query.id_champion;
    if (!id_champion) id_champion = req.body.id_champion;

    try {
        await db.updateChampion({
            id_champion: req.query.id_champion,
            difficulty_level: req.body.difficulty_level,
            ban_rate: req.body.ban_rate,
            pick_rate: req.body.pick_rate,
            win_rate: req.body.win_rate
        });

        res.render('pages/edit_champion', {
            champion: await db.getChampion(req.query.id_champion)
        });
    }
    catch (err) {
        res.send(`Something went wrong :( ${err}`);
    }
});

app.get('/champions/delete', async (req, res) => {
    await db.deleteChampion(req.query.id_champion);
    res.redirect('/champions');
});

// ---------------------------------------------------------------------------
// MATCHES 
// ---------------------------------------------------------------------------

app.get('/create_match', async (req, res) => {
    res.render('pages/create_match', {
        champions: await db.getChampionKeyValuePairs()
    });
});

app.get('/matches', async (req, res) => {
    res.render('pages/matches', {
        matches: await db.getMatches()
    });
});

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------

app.get('/summoners', (req, res) => {
    res.render('pages/summoners');
});

app.get('/skills', (req, res) => {
    res.render('pages/skills');
});

app.get('/db_overview', (req, res) => {
    res.render('pages/db_overview');
});
