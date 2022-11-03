import pandas as pd
import mysql.connector

mydb = mysql.connector.connect(
  
  host="classmysql.engr.oregonstate.edu",
  user="cs340_steeljer",
  password='5817')

# mydb.cursor('INSERT INTO champions (ban_rate, pick_rate, win_rate) VALUES


df = pd.read_csv("./champ_stats.csv", sep=';')

data = pd.DataFrame(df)

print(data['Win %'])