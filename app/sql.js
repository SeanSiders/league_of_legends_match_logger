'use strict';

const config = require('./config');
// Get an instance of mysql we can use in the app
const mysql = require('mysql');

// Create a 'connection pool' using the provided credentials
var pool = mysql.createPool({
    connectionLimit : 10,
    host            : 'classmysql.engr.oregonstate.edu',
    user            : 'cs340_' + config.user ,
    password        :  config.password,
    database        : 'cs340_' + config.unid
})

// Export it for use in our application

exports.pool = pool;