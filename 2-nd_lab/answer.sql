ALTER TABLE dbo.player
ADD PlayerXMLColumn XML;

UPDATE dbo.player
SET PlayerXMLColumn = (
    SELECT 
        id_player AS id_player,
        name_player AS name_player,
        player_birthdate AS player_birthdate,
        phone_player AS phone_player,
        password AS password,
        player_position AS player_position,
        username AS username,
        team_name AS team_name,
        team_id AS team_id
    FROM dbo.player AS p
    WHERE p.id_player = dbo.player.id_player
    FOR XML PATH('Player'), ROOT('Players'), TYPE
);

SELECt * FROM player;

DECLARE @hDoc INT;
DECLARE @XML XML;
DECLARE @PlayerTable TABLE (
    id_player BIGINT,
    name_player VARCHAR(MAX),
    player_birthdate VARCHAR(MAX),
    phone_player VARCHAR(MAX),
    [password] VARCHAR(MAX),
    player_position INT,
    username VARCHAR(MAX),
    team_name VARCHAR(MAX),
    team_id BIGINT
);

SELECT @XML = PlayerXMLColumn FROM dbo.player;

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML;

INSERT INTO @PlayerTable (id_player, name_player, player_birthdate, phone_player, [password], player_position, username, team_name, team_id)
SELECT 
    id_player, 
    name_player, 
    player_birthdate, 
    phone_player, 
    [password], 
    player_position, 
    username, 
    team_name, 
    team_id
FROM 
    OPENXML(@hDoc, '/Players/Player', 2)
WITH (
    id_player BIGINT 'id_player',
    name_player VARCHAR(MAX) 'name_player',
    player_birthdate VARCHAR(MAX) 'player_birthdate',
    phone_player VARCHAR(MAX) 'phone_player',
    [password] VARCHAR(MAX) 'password',
    player_position INT 'player_position',
    username VARCHAR(30) 'username',
    team_name VARCHAR(MAX) 'team_name',
    team_id BIGINT 'team_id'
);

SELECT * FROM @PlayerTable;

EXEC sp_xml_removedocument @hDoc;