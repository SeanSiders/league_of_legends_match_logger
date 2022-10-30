'use strict';
const express = require('express');
const db = require('./db');
const path = require('path');

const PORT = 3090;
var app = express();

//Automatically decode the URL in POST methods
app.use(express.urlencoded({
    extended: false
}));

app.use(express.static(path.join(__dirname, '/public')));

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}...`);
});

app.get('/champions', (req, res) => {
    res.sendFile(path.join(__dirname, '/public/champions.html'));
});

app.get('/matches', (req, res) => {
    res.sendFile(path.join(__dirname, '/public/matches.html'));
});

app.get('/summoners', (req, res) => {
    res.sendFile(path.join(__dirname, '/public/summoners.html'));
});

app.get('/db_overview', (req, res) => {
    res.sendFile(path.join(__dirname, '/public/db_overview.html'));
});

app.get('/sqltime', (req, res) => {
    db.pool.query('SELECT * FROM teams', function(err, results, fields){
    res.send(results);
  });
});