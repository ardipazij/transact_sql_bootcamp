CREATE VIEW dbo.games_view
AS
SELECT *
FROM dbo.games
WHERE game_place = 'Stadium A';

SELECT * FROM games_view

SELECT game_date from games_view

-- ввыполнится, но строка не отобразится, потому что условие доабвления не соответствует условию агрегирование при создании представления
INSERT INTO dbo.games_view (game_place, game_date)
VALUES ('Field X', '2024-05-01T16:00:00');

-- вставка прошла успешно, потому что добавленная строка соответствует условию агрегирования
INSERT INTO dbo.games_view (game_place, game_date)
VALUES ('Stadium A', '2024-05-01T16:00:00');

-- апдейт произошел и строка исчезла из представления, так как перестала соответствовать условию агрегирования
UPDATE dbo.games_view
SET game_place = 'Stadium B'
WHERE game_date = '2024-04-10T14:00:00';

-- операция удаления выполнилась
DELETE FROM dbo.games_view
WHERE game_place = 'Field B';

DROP VIEW IF EXISTS dbo.games_view;

CREATE VIEW dbo.games_view
AS
SELECT *
FROM dbo.games
WHERE game_place = 'Stadium A'
WITH CHECK OPTION;

--представление на основе одной таблицы
CREATE VIEW dbo.players_view
AS
SELECT id_player, name_player, player_position, team_name
FROM dbo.player;

SELECT * FROM dbo.players_view;

-- представление на основе нескольких табоиц

CREATE VIEW dbo.team_players_view
AS
SELECT tp.id, tp.id_team, t.name_team, tp.id_player, p.name_player
FROM dbo.team_player tp
JOIN dbo.team t ON tp.id_team = t.id_team
JOIN dbo.player p ON tp.id_player = p.id_player;

SELECT * FROM dbo.team_players_view;

--представление на основе существующего представления
CREATE VIEW dbo.players_on_stadium_view
AS
SELECT *
FROM dbo.players_view
WHERE team_name = 'Team Alpha'
WITH CHECK OPTION;

SELECT * FROM dbo.players_on_stadium_view;

-- рандомное представление

CREATE VIEW dbo.recent_games_view
AS
SELECT *
FROM dbo.games
WHERE game_date >= DATEADD(day, -7, GETDATE());

SELECT * FROM dbo.recent_games_view

--Вывод всех представлений 
SELECT *
FROM sys.views;

-- Посмотреть код одного из представлений 
EXEC sp_helptext 'dbo.players_view';

-- че то там с зависимостями 

SELECT DISTINCT OBJECT_NAME(object_id) AS dependent_object,
                OBJECT_NAME(referenced_major_id) AS referenced_object
FROM sys.sql_dependencies
WHERE OBJECT_NAME(referenced_major_id) = 'games';

-- индексяшки 
DECLARE @StartTime1 DATETIME;
DECLARE @EndTime1 DATETIME;

SET @StartTime1 = GETDATE();
SELECT *
FROM dbo.recent_games_view
WHERE game_date >= DATEADD(day, -7, GETDATE());
SET @EndTime1 = GETDATE();

SELECT DATEDIFF(ms, @StartTime1, @EndTime1) AS TimeInMilliseconds;

-- тя же ло
DROP VIEW IF EXISTS indexed_recent_games_view;

CREATE VIEW dbo.indexed_recent_games_view
WITH SCHEMABINDING
AS
SELECT game_date, game_place
FROM dbo.games
WHERE game_date >=  CONVERT(DATETIME, '2024-04-26 14:30:00', 120);

CREATE UNIQUE CLUSTERED INDEX IX_indexed_recent_games_view_game_date ON dbo.indexed_recent_games_view (game_date);


DECLARE @StartTime1 DATETIME;
DECLARE @EndTime1 DATETIME;

SET @StartTime1 = GETDATE();
SELECT *
FROM dbo.indexed_recent_games_view
WHERE game_date >= DATEADD(day, -7, GETDATE());
SET @EndTime1 = GETDATE();

SELECT DATEDIFF(ms, @StartTime1, @EndTime1) AS TimeInMilliseconds;