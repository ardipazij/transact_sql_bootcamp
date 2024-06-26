------------------------- хранимые процедуры ------------------------------

-- Хранимая процедура - именованная коллекция операторов Transact-SQL, которая хранится на
-- сервере непосредственно в базе данных. Хранимые процедуры – это метод инкапсулирования
-- повторяющихся задач; они поддерживают пользовательские переменные, условные
-- операторы и другие возможности программирования.

-- Хранимые процедуры предлагают многочисленные преимущества перед выполнением запросов Transact-SQL. Они могут:
----- 1. Инкапсулировать прикладные функциональные возможности и создавать прикладную логику многократного использования.
----- 2. Оградить пользователей от деталей организации таблиц в базе данных. 
----- 3. Обеспечить механизмы безопасности. 
----- 4. Улучшить производительность. 
----- 5. Уменьшить сетевой трафик.


-- непараметризованные хранимые процедуры

CREATE PROCEDURE dbo.SelectAllPlayers
AS
BEGIN
    SELECT * FROM dbo.player;
END;

EXEC dbo.SelectAllPlayers;

ALTER PROCEDURE dbo.SelectAllPlayers
AS
BEGIN
    SELECT * FROM dbo.games;
END;

EXEC dbo.SelectAllPlayers;

DROP PROCEDURE dbo.SelectAllPlayers;

-- параметризированные хранимые процедуры

CREATE PROCEDURE dbo.GetPlayerById
    @id_player BIGINT
AS
BEGIN
    SELECT * FROM dbo.player
    WHERE id_player = @id_player;
END;

EXEC dbo.GetPlayerById 1;

ALTER PROCEDURE dbo.GetPlayerById
    @id_game BIGINT
AS
BEGIN
    SELECT * FROM dbo.games
    WHERE id_game = @id_game;
END;

EXEC dbo.GetPlayerById @id_game = 1;
-- или
EXEC dbo.GetPlayerById 1;

DROP PROCEDURE dbo.GetPlayerById;


-- параметры вывода

CREATE PROCEDURE dbo.GetPlayerNameById
    @id_player BIGINT,
    @name_player VARCHAR(MAX) OUTPUT
AS
BEGIN
    SELECT @name_player = name_player
    FROM dbo.player
    WHERE id_player = @id_player;
END;

DECLARE @playerName VARCHAR(MAX);

EXEC dbo.GetPlayerNameById
    @id_player = 1,
    @name_player = @playerName OUTPUT;

SELECT @playerName;

CREATE PROCEDURE dbo.GetPlayerCount
AS
BEGIN
    DECLARE @count INT;

    SELECT @count = COUNT(*)
    FROM dbo.player;

    RETURN @count;
END;


DECLARE @playerCount INT;

EXEC @playerCount = dbo.GetPlayerCount;

SELECT @playerCount;

DROP PROCEDURE dbo.GetPlayerNameById;
DROP PROCEDURE dbo.GetPlayerCount;

------------------------------функции ----------------------------------------

--скалярная функция
CREATE FUNCTION dbo.GetPlayerNameById
(
    @id_player BIGINT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @name_player VARCHAR(MAX);

    SELECT @name_player = name_player
    FROM dbo.player
    WHERE id_player = @id_player;

    RETURN @name_player;
END;

DECLARE @playerName VARCHAR(MAX);

SELECT @playerName = dbo.GetPlayerNameById(1);

SELECT @playerName;

DROP FUNCTION dbo.GetPlayerNameById;

-- подставляемая функция

CREATE FUNCTION dbo.GetPlayersByTeam
(
    @team_name VARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN (
    SELECT *
    FROM dbo.player
    WHERE team_name = @team_name
);

SELECT * FROM dbo.GetPlayersByTeam('Team Alpha');

DROP FUNCTION dbo.GetPlayersByTeam;


--многооператорная табличная функция

CREATE FUNCTION dbo.GetPlayersWithStats()
RETURNS @PlayersWithStats TABLE
(
    id_player BIGINT,
    name_player VARCHAR(MAX),
    goals_current VARCHAR(MAX),
    pass_current VARCHAR(MAX)
)
AS
BEGIN
    INSERT INTO @PlayersWithStats (id_player, name_player, goals_current, pass_current)
    SELECT p.id_player, p.name_player, s.goals_current, s.pass_current
    FROM dbo.player p
    INNER JOIN dbo.statistic s ON p.id_player = s.id_person;

    RETURN;
END;

SELECT * FROM dbo.GetPlayersWithStats();

DROP FUNCTION dbo.GetPlayersWithStats;
