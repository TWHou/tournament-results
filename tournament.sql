-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament


CREATE TABLE players (
  id serial primary key,
  name text
);

CREATE TABLE matches (
  id serial primary key,
  winner integer references players (id),
  loser integer references players (id)
);

CREATE VIEW wins AS (
  SELECT players.id AS id, count(matches.winner) AS num
  FROM players 
  LEFT JOIN matches ON players.id = matches.winner
  GROUP BY players.id
);

CREATE VIEW losses AS (
  SELECT players.id AS id, count(matches.loser) AS num
  FROM players 
  LEFT JOIN matches ON players.id = matches.loser
  GROUP BY players.id
);

CREATE VIEW standing AS (
  SELECT wins.id as id, wins.num as wins, wins.num + losses.num as matches 
  FROM wins, losses 
  WHERE wins.id = losses.id 
  ORDER BY wins DESC
);