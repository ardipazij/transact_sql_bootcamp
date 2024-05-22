-- Добавляем новый столбец PlayerXMLColumn типа XML в таблицу player.
ALTER TABLE dbo.player
ADD PlayerXMLColumn XML;

-- Обновляем столбец PlayerXMLColumn для каждой записи в таблице player, создавая XML-документ для каждого игрока и заносим их в ячейку PlsyerXMLColumn.
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

-- Выбираем все данные из таблицы player для проверки.
SELECT * FROM player;

-- Объявляем переменные для работы с XML-документом и временной таблицей для хранения данных.
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

-- Извлекаем XML-данные из столбца PlayerXMLColumn.
SELECT @XML = PlayerXMLColumn FROM dbo.player;

-- Подготавливаем документ XML для обработки, создаем дескриптор @hDoc.
EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML;

-- Вставляем данные из XML-документа в временную таблицу @PlayerTable.
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
-- Используем OPENXML для парсинга XML-документа.
-- Второй параметр указывает XPath для элементов Player в XML-документе.
WITH (
    id_player BIGINT 'id_player',                  -- Маппинг из XML на столбец таблицы
    name_player VARCHAR(MAX) 'name_player',        
    player_birthdate VARCHAR(MAX) 'player_birthdate', -
    phone_player VARCHAR(MAX) 'phone_player',     
    [password] VARCHAR(MAX) 'password',            
    player_position INT 'player_position',         
    username VARCHAR(30) 'username',              
    team_name VARCHAR(MAX) 'team_name',            
    team_id BIGINT 'team_id'                      
);

-- Выбираем все данные из временной таблицы @PlayerTable для проверки.
SELECT * FROM @PlayerTable;

-- Освобождаем ресурсы, удаляя подготовленный документ XML.
EXEC sp_xml_removedocument @hDoc;
