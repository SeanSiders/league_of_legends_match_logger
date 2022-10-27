'use strict';
const express = require('express');
var bodyParser = require("body-parser");

var PORT = 3000;
var app = express();

//Automatically decode the URL in POST methods
app.use(express.urlencoded({
    extended: false
}));

app.use(express.static('public'));

app.get('/', (req, res) => {
    res.sendFile('/index.html');
});

app.get('/overview', (req, res) => {
    res.sendFile('/overview.html');
});

app.get('/champions', (req, res) => {
    res.sendFile('/champions.html');
});

app.post('/champion', (req, res) => {
    console.log(req.body)
    res.sendFile('/champions.html', )
})

app.get('/summoner', (req, res) => {
    res.sendFile('/summoner.html');
});
app.get('/match', (req, res) => {
    res.sendFile('/match.html');
});

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}...`);
    console.log('hello');
});
