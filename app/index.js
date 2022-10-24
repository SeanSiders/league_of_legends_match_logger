'use strict';
import express from 'express';

const PORT = 3000;

const app = express();

//Automatically decode the URL in POST methods
app.use(express.urlencoded({
    extended: true
}));

app.use(express.static('public'));

app.get('/', (req, res) => {
    res.sendFile('/index.html');
});

app.get('/home', (req, res) => {
    res.sendFile('/home.html');
});

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}...`);
});
