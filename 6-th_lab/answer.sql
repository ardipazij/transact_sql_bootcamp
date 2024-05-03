DROP TRIGGER IF EXISTS trg_player_count_update;

CREATE TRIGGER trg_player_count_update
ON dbo.player
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @team_id INT;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SELECT @team_id = team_id FROM inserted;
        
        UPDATE dbo.team
        SET players_count = players_count + 1
        WHERE dbo.team.id_team = @team_id;
    END
    ELSE
    
    BEGIN
        SELECT @team_id = team_id FROM deleted;
        UPDATE dbo.team
        SET players_count = players_count - 1
        WHERE dbo.team.id_team = @team_id;
    END;
END;


SELECT * FROM team;

INSERT INTO dbo.player (name_player, player_birthdate, phone_player, password, player_position, username, team_name, team_id)
VALUES 
       ('Игрок 2', '1996-02-02', '2345678901', 'pass234', 2, 'player2', 'Team Beta', 2);
       
SELECT * FROM team;

DELETE FROM dbo.player WHERE username IN ('player2');

SELECT * FROM team;

DROP TRIGGER IF EXISTS trg_player_insert;

CREATE TRIGGER trg_player_insert
ON dbo.player
AFTER INSERT
AS
BEGIN

    IF EXISTS (SELECT * FROM inserted)
    BEGIN

        INSERT INTO dbo.team_player (id_team, id_player, player_position)
        SELECT t.id_team, p.id_player, p.player_position
        FROM inserted i
        INNER JOIN dbo.team t ON i.team_name = t.name_team
        INNER JOIN dbo.player p ON i.id_player = p.id_player;
    END
END;

DROP TRIGGER IF EXISTS trg_player_delete;

CREATE TRIGGER trg_player_delete
ON dbo.player
INSTEAD OF DELETE
AS
BEGIN
	 BEGIN
        DELETE FROM dbo.team_player WHERE id_player IN (SELECT id_player FROM deleted);
    END
END;


SELECT * FROM dbo.team_player;

INSERT INTO dbo.player (name_player, player_birthdate, phone_player, password, player_position, username, team_name, team_id)
VALUES 
       ('Игрок 2', '1996-02-02', '2345678901', 'pass234', 2, 'player2', 'Team Beta', 2);
       
SELECT * FROM dbo.team_player;

DELETE FROM dbo.player WHERE username IN ('player2');

SELECT * FROM dbo.team_player;