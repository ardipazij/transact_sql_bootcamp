-- Извлекаем данные из XML-колонки PlayerXMLColumn, возвращая элементы Player.
-- Используем метод query() для получения XML-фрагмента.
SELECT PlayerXMLColumn.query('/Players/Player') AS PlayerData
FROM player;

-- Извлекаем значения из XML-колонки PlayerXMLColumn и преобразуем их в табличные данные.
-- Используем метод value() для извлечения значений отдельных элементов XML.
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

-- Проверяем, существует ли элемент team_id внутри XML-колонки PlayerXMLColumn.
-- Используем метод exist() для проверки существования элемента в XML.
SELECT 
    id_player, 
    username, 
    PlayerXMLColumn.exist('/Players/Player[team_id[text()]]') AS team_id_exists -- Проверяем, существует ли элемент team_id
FROM player;

-- Выбираем все данные из таблицы player для проверки текущего состояния данных.
SELECT * FROM player;

-- Объявляем переменную для хранения идентификатора игрока.
DECLARE @playerId BIGINT = 5;

-- Обновляем XML-колонку PlayerXMLColumn, добавляя элемент team_id с значением 6 для игрока с id_player равным @playerId.
-- Используем метод modify() для модификации XML-структуры.
UPDATE player
SET PlayerXMLColumn.modify('
    insert <team_id>6</team_id> as last into (/Players/Player[id_player/text()=sql:variable("@playerId")])[1]'
) 
-- Обновляем только те строки, где id_player равен значению переменной @playerId.
WHERE id_player = @playerId;

-- Объявляем переменную для хранения идентификатора игрока.
DECLARE @playerId BIGINT = 5;

-- Обновляем XML-колонку PlayerXMLColumn, удаляя первый элемент team_id для игрока с id_player равным @playerId.
-- Используем метод modify() для удаления элемента из XML.
UPDATE player
SET PlayerXMLColumn.modify('
    delete /Players/Player[id_player/text()=sql:variable("@playerId")]/team_id[1]')
-- Обновляем только те строки, где id_player равен значению переменной @playerId.
WHERE id_player = @playerId;

-- Извлекаем значения id_player и name_player из XML-колонки для игроков, имя которых равно "John Doe".
-- Используем CROSS APPLY для развертывания узлов XML в строках.
SELECT
    PlayerData.value('(id_player)[1]', 'BIGINT') AS id_player, -- Извлекаем id_player как BIGINT
    PlayerData.value('(name_player)[1]', 'VARCHAR(MAX)') AS name_player -- Извлекаем name_player как VARCHAR(MAX)
FROM player
CROSS APPLY PlayerXMLColumn.nodes('/Players/Player[name_player/text()="John Doe"]') AS PlayerNode(PlayerData); 
-- Используем метод nodes() для создания таблицы PlayerNode, содержащей отдельные XML-узлы, удовлетворяющие заданному XPath выражению.
