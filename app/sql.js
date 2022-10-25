// import user from '.config';
import express from "express";
// const express = require('express');
var app = express();
import mysql from "mysql";

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password!',
  database: 'database'
});

connection.connect((err) => {
    if (err) throw err;
  console.log('Connected!');
});

app.get("/createdb", (req, res) => {

    let sql = "CREATE DATABASE nodemysql";
    db.query(sql, (err) => {
      if (err) {
        throw err;
      }
      res.send("Database created");
  
    });
  
  });