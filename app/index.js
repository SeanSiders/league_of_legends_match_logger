'use strict';
const express = require('express');
const db = require('./db');
const path = require('path');
const { match } = require('assert');

const app = express();
const PORT = 3079;

app.set('view engine', 'ejs');

//Automatically decode the URL in POST methods
app.use(express.urlencoded({
    extended: false
}));

app.use(express.json());

app.use(express.static(path.join(__dirname, 'app')));
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
        champions: await db.getChampionKeyValuePairs(),
        summoners: await db.getSummoners(),
    });
});

app.get('/reset_db', async (req, res) => {
    await db.resetDatabase();
    res.redirect('/');
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

app.post('/create_champion_sql', async (req, res) => {
    try {
        await db.createChampion(req.body);
        
        res.redirect('/champions');

    } catch (err) {
        res.send(`${err}`);
    }
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

app.get('/matches', async (req, res) => {
    res.render('pages/matches', {
        matches: await db.getMatches()
    });
});

app.get('/create_match', async (req, res) => {
    res.render('pages/edit_match', {
        match: null,
        champions: await db.getChampionKeyValuePairs(),
    });
});

app.post('/create_match', async (req, res) => {
    await db.createMatch(req.body);

    res.redirect('/matches');
});

app.get('/edit_match', async (req, res) => {
    res.render('pages/edit_match', {
        match: await db.getMatch(req.query.id_match),
        champions: await db.getChampionKeyValuePairs()
    });
});

app.post('/update_match', async (req, res) => {
    let match = req.body;
    match.id_match = req.query.id_match;
    await db.updateMatch(match);
    res.redirect('/matches');
});

app.get('/matches/delete', async (req, res) => {
    await db.deleteMatch(req.query.id_match);
    res.redirect('/matches');
});


// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------

app.get('/summoners', async (req, res) => {
    res.render('pages/summoners', {
        nameTime: await db.getSummonerName(req.query.id_summoner),
        champion: await db.getSummonerChampion(req.query.id_summoner),
        summ: req.query
    });
});

app.get('/db_overview', (req, res) => {
    res.render('pages/db_overview');
});
