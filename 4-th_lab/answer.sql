EXEC sp_helpindex [team]

SELECT p.name_player, p.team_name
FROM dbo.player p
INNER JOIN dbo.team t ON p.team_name = t.name_team
ORDER BY t.name_team;

SELECT t.name_team, COUNT(p.id_player) AS player_count
FROM dbo.team t
LEFT JOIN dbo.player p ON t.id_team = p.team_id
GROUP BY t.name_team;
 
SELECT t.name_team, AVG(CAST(s.goals_current AS FLOAT)) AS avg_goals_per_game
FROM dbo.team t
INNER JOIN dbo.team_player tp ON t.id_team = tp.id_team
INNER JOIN dbo.player p ON tp.id_player = p.id_player
INNER JOIN dbo.statistic s ON p.id_player = s.id_person
GROUP BY t.name_team;

SELECT id_game, game_date
FROM dbo.games
ORDER BY game_date;

SELECT p.name_player, s.goals_current
FROM dbo.player p
INNER JOIN dbo.statistic s ON p.id_player = s.id_person
ORDER BY s.goals_current DESC;


CREATE INDEX idx_name_team ON dbo.team (name_team);
CREATE INDEX idx_team_id_player ON dbo.player (team_id, id_player);
CREATE INDEX idx_game_date ON dbo.games (game_date);
CREATE INDEX idx_id_person_goals_current ON dbo.statistic (id_person, goals_current);
CREATE INDEX idx_id_player_goals_current ON dbo.player (id_player, goals_current);