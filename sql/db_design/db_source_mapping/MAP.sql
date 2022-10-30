UPDATE champions_source SET id_champion = REPLACE(REPLACE(LOWER(REPLACE(name, ' ', '_')), '''', ''), '.', '');

INSERT INTO skills (name, description) (SELECT name, description FROM skills_source);

INSERT INTO champions (id_champion, name, difficulty_level, ban_rate, pick_rate, win_rate, id_skill_P, id_skill_Q, id_skill_W, id_skill_E, id_skill_R)
(
    SELECT
        id_champion,
        name, 
        'easy', 
        0.0, 
        0.0, 
        0.0,
        (SELECT id_skill AS id1 FROM skills WHERE name = (SELECT name FROM skills_source WHERE id = 1 AND champion = champions_source.id)),
        (SELECT id_skill AS id2 FROM skills WHERE name = (SELECT name FROM skills_source WHERE id = 2 AND champion = champions_source.id)),
        (SELECT id_skill AS id3 FROM skills WHERE name = (SELECT name FROM skills_source WHERE id = 3 AND champion = champions_source.id)),
        (SELECT id_skill AS id4 FROM skills WHERE name = (SELECT name FROM skills_source WHERE id = 4 AND champion = champions_source.id)),
        (SELECT id_skill AS id5 FROM skills WHERE name = (SELECT name FROM skills_source WHERE id = 5 AND champion = champions_source.id))
    FROM champions_source
);