-- CREATE DATABASE SoccerDB;

-- USE SoccerDB;

CREATE TABLE dbo.games (
    id_game BIGINT IDENTITY(1,1),
    game_place VARCHAR(MAX) NOT NULL,
    game_date DATETIME NOT NULL,
    CONSTRAINT games_pkey PRIMARY KEY (id_game)
);

CREATE TABLE dbo.player (
    id_player BIGINT IDENTITY(1,1),
    name_player VARCHAR(MAX) NOT NULL,
    player_birthdate VARCHAR(MAX) NULL,
    phone_player VARCHAR(MAX) NULL,
    password VARCHAR(MAX) NOT NULL,
    player_position INT NOT NULL,
    username VARCHAR(30) NOT NULL,
    team_name VARCHAR(MAX) NOT NULL,
    team_id BIGINT NULL,
    CONSTRAINT player_pkey PRIMARY KEY (id_player),
    CONSTRAINT player_username_key UNIQUE (username)
);

CREATE TABLE dbo.autorisation (
    id_player BIGINT IDENTITY(1,1),
    username VARCHAR(30) NOT NULL,
    password VARCHAR(MAX) NOT NULL,
    CONSTRAINT autorisation_pkey PRIMARY KEY (id_player),
    CONSTRAINT autorisation_id_player_fkey FOREIGN KEY (id_player) REFERENCES dbo.player (id_player) ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT autorisation_username_fkey FOREIGN KEY (username) REFERENCES dbo.player (username) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE dbo.statistic (
    id_person BIGINT IDENTITY(1,1),
    goals_aim VARCHAR(MAX) NOT NULL DEFAULT '0',
    goals_current VARCHAR(MAX) NOT NULL DEFAULT '0',
    pass_aim VARCHAR(MAX) NOT NULL DEFAULT '0',
    pass_current VARCHAR(MAX) NOT NULL DEFAULT '0',
    power_aim VARCHAR(MAX) NOT NULL DEFAULT '0',
    power_current VARCHAR(MAX) NOT NULL DEFAULT '0',
    catching_aim VARCHAR(MAX) NOT NULL DEFAULT '0',
    catching_current VARCHAR(MAX) NOT NULL DEFAULT '0',
    team_points_aim VARCHAR(MAX) NOT NULL DEFAULT '0',
    team_points_current VARCHAR(MAX) NOT NULL DEFAULT '0',
    CONSTRAINT statistic_pkey PRIMARY KEY (id_person),
    CONSTRAINT statistic_id_person_fkey FOREIGN KEY (id_person) REFERENCES dbo.player (id_player) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE dbo.team (
    id_team BIGINT IDENTITY(1,1),
    name_team VARCHAR(50) NOT NULL,
    players_count INT NOT NULL DEFAULT 0,
    games_count INT NOT NULL DEFAULT 0,
    wins_count INT NOT NULL DEFAULT 0,
    CONSTRAINT team_pkey PRIMARY KEY (id_team),
    CONSTRAINT team_name_team_key UNIQUE (name_team)
);

CREATE TABLE dbo.team_games (
    id_game BIGINT IDENTITY(1,1),
    id_team_1 BIGINT NOT NULL,
    id_team_2 BIGINT NOT NULL,
    winner_team BIGINT NOT NULL,
    CONSTRAINT team_games_pkey PRIMARY KEY (id_game),
    CONSTRAINT team_games_id_game_fkey FOREIGN KEY (id_game) REFERENCES dbo.games (id_game) ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT team_games_id_team_1_fkey FOREIGN KEY (id_team_1) REFERENCES dbo.team (id_team),
    CONSTRAINT team_games_id_team_2_fkey FOREIGN KEY (id_team_2) REFERENCES dbo.team (id_team),
    CONSTRAINT team_games_winner_team_fkey FOREIGN KEY (winner_team) REFERENCES dbo.team (id_team)
);

CREATE TABLE dbo.team_player (
    id_team BIGINT NOT NULL,
    id_player BIGINT NOT NULL,
    player_position INT NOT NULL,
    id BIGINT IDENTITY(1,1),
    CONSTRAINT team_player_pkey PRIMARY KEY (id),
    CONSTRAINT team_player_id_player_fkey FOREIGN KEY (id_player) REFERENCES dbo.player (id_player) ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO dbo.games (game_place, game_date)
VALUES 
    ('Stadium A', '2024-04-10T14:00:00'),
    ('Field B', '2024-04-11T15:30:00'),
    ('Indoor Arena', '2024-04-12T19:00:00'),
    ('Stadium C', '2024-04-14T16:45:00'),
    ('Field D', '2024-04-16T13:15:00');

INSERT INTO dbo.team (name_team)
VALUES 
    ('Team Alpha'),
    ('Team Beta'),
    ('Team Gamma'),
    ('Team Delta'),
    ('Team Epsilon');

INSERT INTO dbo.player (name_player, player_birthdate, phone_player, password, player_position, username, team_name)
VALUES 
    ('John Doe', '1990-01-01', '1234567890', 'pass123', 1, 'johndoe', 'Team Alpha'),
    ('Jane Smith', '1991-02-02', '2345678901', 'pass234', 2, 'janesmith', 'Team Beta'),
    ('Mike Ross', '1992-03-03', '3456789012', 'pass345', 3, 'mikeross', 'Team Gamma'),
    ('Emma Watson', '1993-04-04', '4567890123', 'pass456', 4, 'emmawatson', 'Team Delta'),
    ('Chris Evans', '1994-05-05', '5678901234', 'pass567', 5, 'chrisevans', 'Team Epsilon');

INSERT INTO dbo.autorisation (username, password)
SELECT username, password FROM dbo.player;

INSERT INTO dbo.team_player (id_team, id_player, player_position)
VALUES 
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3),
    (4, 4, 4),
    (5, 5, 5);

INSERT INTO dbo.statistic ( goals_aim, goals_current, pass_aim, pass_current, power_aim, power_current, catching_aim, catching_current, team_points_aim, team_points_current)
VALUES
('5', '2', '10', '5', '200', '150', '15', '10', '30', '20'),
('8', '3', '12', '6', '180', '130', '18', '11', '32', '22'),
('7', '4', '11', '7', '190', '140', '16', '12', '33', '23'),
('6', '5', '13', '8', '200', '145', '17', '13', '34', '24'),
('9', '6', '14', '9', '210', '155', '19', '14', '35', '25');

INSERT INTO dbo.team_games ( id_team_1, id_team_2, winner_team)
VALUES
(1, 2, 1),
(1, 3, 3),
(2, 3, 2),
(1, 4, 4),
(2, 4, 2);
