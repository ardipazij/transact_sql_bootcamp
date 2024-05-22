-- Удаляем триггер trg_player_count_update, если он существует.
DROP TRIGGER IF EXISTS trg_player_count_update;

-- Создаем триггер trg_player_count_update на таблицу dbo.player, который срабатывает после вставки или удаления записей.
CREATE TRIGGER trg_player_count_update
ON dbo.player
AFTER INSERT, DELETE
AS
BEGIN
    -- Объявляем переменную @team_id для хранения идентификатора команды.
    DECLARE @team_id INT;
    
    -- Проверяем, были ли вставлены новые записи.
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Если были вставлены новые записи, выбираем идентификатор команды из вставленных записей.
        SELECT @team_id = team_id FROM inserted;
        
        -- Обновляем количество игроков в команде, увеличивая его на 1.
        UPDATE dbo.team
        SET players_count = players_count + 1
        WHERE dbo.team.id_team = @team_id;
    END
    ELSE
    BEGIN
        -- Если были удалены записи, выбираем идентификатор команды из удаленных записей.
        SELECT @team_id = team_id FROM deleted;
        
        -- Обновляем количество игроков в команде, уменьшая его на 1.
        UPDATE dbo.team
        SET players_count = players_count - 1
        WHERE dbo.team.id_team = @team_id;
    END;
END;

-- Выводим данные из таблицы dbo.team.
SELECT * FROM team;

-- Вставляем новую запись в таблицу dbo.player.
INSERT INTO dbo.player (name_player, player_birthdate, phone_player, password, player_position, username, team_name, team_id)
VALUES ('Игрок 2', '1996-02-02', '2345678901', 'pass234', 2, 'player2', 'Team Beta', 2);

-- Выводим данные из таблицы dbo.team после вставки новой записи.
SELECT * FROM team;

-- Удаляем запись из таблицы dbo.player.
DELETE FROM dbo.player WHERE username IN ('player2');

-- Выводим данные из таблицы dbo.team после удаления записи.
SELECT * FROM team;

-- Удаляем триггер trg_player_insert, если он существует.
DROP TRIGGER IF EXISTS trg_player_insert;

-- Создаем триггер trg_player_insert на таблицу dbo.player, который срабатывает после вставки записей.
CREATE TRIGGER trg_player_insert
ON dbo.player
AFTER INSERT
AS
BEGIN
    -- Проверяем, были ли вставлены новые записи.
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Вставляем записи о связи между командой и игроком в таблицу dbo.team_player.
        INSERT INTO dbo.team_player (id_team, id_player, player_position)
        SELECT t.id_team, p.id_player, p.player_position
        FROM inserted i
        INNER JOIN dbo.team t ON i.team_name = t.name_team
        INNER JOIN dbo.player p ON i.id_player = p.id_player;
    END
END;

-- Удаляем триггер trg_player_delete, если он существует.
DROP TRIGGER IF EXISTS trg_player_delete;

-- Создаем триггер trg_player_delete на таблицу dbo.player, который срабатывает вместо удаления записей.
CREATE TRIGGER trg_player_delete
ON dbo.player
INSTEAD OF DELETE
AS
BEGIN
    -- Удаляем записи о связи между командой и игроком из таблицы dbo.team_player.
    BEGIN
        DELETE FROM dbo.team_player WHERE id_player IN (SELECT id_player FROM deleted);
    END
END;

-- Выводим данные из таблицы dbo.team_player.
SELECT * FROM dbo.team_player;

-- Вставляем новую запись в таблицу dbo.player.
INSERT INTO dbo.player (name_player, player_birthdate, phone_player, password, player_position, username, team_name, team_id)
VALUES ('Игрок 2', '1996-02-02', '2345678901', 'pass234', 2, 'player2', 'Team Beta', 2);

-- Выводим данные из таблицы dbo.team_player после вставки новой записи.
SELECT * FROM dbo.team_player;

-- Удаляем запись из таблицы dbo.player.
DELETE FROM dbo.player WHERE username IN ('player2');

-- Выводим данные из таблицы dbo.team_player после удаления записи.
SELECT * FROM dbo.team_player;
