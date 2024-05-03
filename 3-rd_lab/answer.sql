DECLARE @XML AS XML
SELECT @XML = PlayerXMLColumn FROM player

SELECT @XML.query('/Players/Player') AS PlayerData

SELECT 
    PlayerXMLColumn.value('(Players/Player/id_player)[1]', 'BIGINT') AS id_player,
    PlayerXMLColumn.value('(Players/Player/name_player)[1]', 'VARCHAR(MAX)') AS name_player,
    PlayerXMLColumn.value('(Players/Player/player_birthdate)[1]', 'VARCHAR(MAX)') AS player_birthdate,
    PlayerXMLColumn.value('(Players/Player/phone_player)[1]', 'VARCHAR(MAX)') AS phone_player,
    PlayerXMLColumn.value('(Players/Player/password)[1]', 'VARCHAR(MAX)') AS password,
    PlayerXMLColumn.value('(Players/Player/player_position)[1]', 'INT') AS player_position,
    PlayerXMLColumn.value('(Players/Player/username)[1]', 'VARCHAR(30)') AS username,
    PlayerXMLColumn.value('(Players/Player/team_name)[1]', 'VARCHAR(MAX)') AS team_name,
    PlayerXMLColumn.value('(Players/Player/team_id)[1]', 'BIGINT') AS team_id
FROM player;

SELECT 
    id_player,
    username,
    PlayerXMLColumn.exist('/Players/Player[team_id[text()]]') AS team_id_exists
FROM player;

DECLARE @playerId BIGINT = 1;
UPDATE player
SET PlayerXMLColumn.modify('
    insert <team_id>6</team_id> as last into (/Players/Player[id_player/text()=sql:variable("@playerId")])[1]'
)
WHERE id_player = @playerId;


SELECT
    PlayerData.value('(id_player)[1]', 'BIGINT') AS id_player,
    PlayerData.value('(name_player)[1]', 'VARCHAR(MAX)') AS name_player
FROM dbo.player
CROSS APPLY PlayerXMLColumn.nodes('/Players/Player[name_player/text()="John Doe"]') AS PlayerNode(PlayerData);
