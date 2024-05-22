-- Создаем представление dbo.games_view, которое отображает все строки из таблицы dbo.games, где game_place равно 'Stadium A'.
CREATE VIEW dbo.games_view
AS
SELECT *
FROM dbo.games
WHERE game_place = 'Stadium A';

-- Выводим все данные из представления dbo.games_view.
SELECT * FROM games_view;

-- Пытаемся выбрать только столбец game_date из представления dbo.games_view.
-- Это вызовет ошибку, поскольку представление отфильтровано только по столбцу game_place.
SELECT game_date FROM games_view;

-- Вставляем строку в представление dbo.games_view.
-- Строка не будет отображаться, потому что условие добавления не соответствует условию фильтрации при создании представления.
INSERT INTO dbo.games_view (game_place, game_date)
VALUES ('Field X', '2024-05-01T16:00:00');

-- Вставляем строку в представление dbo.games_view.
-- Вставка проходит успешно, так как добавленная строка соответствует условию фильтрации при создании представления.
INSERT INTO dbo.games_view (game_place, game_date)
VALUES ('Stadium A', '2024-05-01T16:00:00');

-- Обновляем строку в представлении dbo.games_view.
-- Строка исчезает из представления, так как не соответствует условию фильтрации при создании представления.
UPDATE dbo.games_view
SET game_place = 'Stadium B'
WHERE game_date = '2024-04-10T14:00:00';

-- Удаляем строку из представления dbo.games_view.
-- Операция удаления выполняется, так как строка соответствует условию фильтрации при создании представления.
DELETE FROM dbo.games_view
WHERE game_place = 'Field B';

-- Удаляем существующее представление dbo.games_view, если оно существует.
DROP VIEW IF EXISTS dbo.games_view;

-- Создаем представление dbo.games_view с опцией WITH CHECK OPTION, чтобы гарантировать, что новые строки соответствуют условиям фильтрации при создании представления.
CREATE VIEW dbo.games_view
AS
SELECT *
FROM dbo.games
WHERE game_place = 'Stadium A'
WITH CHECK OPTION;

-- Создаем представление dbo.players_view на основе одной таблицы dbo.player.
CREATE VIEW dbo.players_view
AS
SELECT id_player, name_player, player_position, team_name
FROM dbo.player;

-- Выводим все данные из представления dbo.players_view.
SELECT * FROM dbo.players_view;

-- Создаем представление dbo.team_players_view на основе нескольких таблиц dbo.team_player, dbo.team и dbo.player.
CREATE VIEW dbo.team_players_view
AS
SELECT tp.id, tp.id_team, t.name_team, tp.id_player, p.name_player
FROM dbo.team_player tp
JOIN dbo.team t ON tp.id_team = t.id_team
JOIN dbo.player p ON tp.id_player = p.id_player;

-- Выводим все данные из представления dbo.team_players_view.
SELECT * FROM dbo.team_players_view;

-- Создаем представление dbo.players_on_stadium_view на основе существующего представления dbo.players_view.
-- Выводим только те строки, где team_name равен 'Team Alpha', с опцией WITH CHECK OPTION.
CREATE VIEW dbo.players_on_stadium_view
AS
SELECT *
FROM dbo.players_view
WHERE team_name = 'Team Alpha'
WITH CHECK OPTION;

-- Выводим все данные из представления dbo.players_on_stadium_view.
SELECT * FROM dbo.players_on_stadium_view;

-- Создаем представление dbo.recent_games_view, которое отображает игры, прошедшие за последнюю неделю.
CREATE VIEW dbo.recent_games_view
AS
SELECT *
FROM dbo.games
WHERE game_date >= DATEADD(day, -7, GETDATE());

-- Выводим все данные из представления dbo.recent_games_view.
SELECT * FROM dbo.recent_games_view;

-- Получаем список всех представлений в базе данных.
SELECT *
FROM sys.views;

-- Просматриваем код одного из представлений, в данном случае, dbo.players_view.
EXEC sp_helptext 'dbo.players_view';

-- Получаем список зависимостей между объектами в базе данных для конкретной таблицы, в данном случае, для таблицы games.
SELECT DISTINCT OBJECT_NAME(object_id) AS dependent_object,
                OBJECT_NAME(referenced_major_id) AS referenced_object
FROM sys.sql_dependencies
WHERE OBJECT_NAME(referenced_major_id) = 'games';

-- Создаем индексированное представление dbo.indexed_recent_games_view, чтобы улучшить производительность запросов к таблице games.
CREATE VIEW dbo.indexed_recent_games_view
WITH SCHEMABINDING
AS
SELECT game_date, game_place
FROM dbo.games
WHERE game_date >=  CONVERT(DATETIME, '2024-04-26 14:30:00', 120);

-- Создаем кластеризованный уникальный индекс для представления dbo.indexed_recent_games_view, чтобы ускорить запросы по столбцу game_date.
CREATE UNIQUE CLUSTERED INDEX IX_indexed_recent_games_view_game_date ON dbo.indexed_recent_games_view (game_date);

-- Выполняем запрос и измеряем время выполнения без использования индексированного представления.
DECLARE @StartTime1 DATETIME;
DECLARE @EndTime1 DATETIME;

SET @StartTime1 = GETDATE();
SELECT *
FROM dbo.recent_games_view
WHERE game_date >= DATEADD(day, -7, GETDATE());
SET @EndTime1 = GETDATE();

SELECT DATEDIFF(ms, @StartTime1, @EndTime1) AS TimeInMilliseconds;

-- Выполняем запрос и измеряем время выполнения с использованием индексированного представления.
DECLARE @StartTime DATETIME;
DECLARE @EndTime DATETIME;

SET @StartTime = GETDATE();
SELECT *
FROM dbo.indexed_recent_games_view
WHERE game_date >= DATEADD(day, -7, GETDATE());
SET @EndTime = GETDATE();

-- Сравниваем время выполнения запросов с и без использования индексированного представления.
SELECT DATEDIFF(ms, @StartTime, @EndTime) AS TimeInMilliseconds;
