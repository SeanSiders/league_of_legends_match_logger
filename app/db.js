'use strict';

const user = 'siderss';
const password = '7107';

// Get an instance of mysql we can use in the app
const mysql = require('mysql');

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    connectionLimit : 10,
    host            : 'classmysql.engr.oregonstate.edu',
    user            : 'cs340_' + user,
    password        :  password,
    database        : 'cs340_' + user
});

module.exports.pool = pool;