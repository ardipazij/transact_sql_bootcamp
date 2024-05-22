SELECT 
    id_person AS "PersonID",
    goals_current AS "Goals",
    pass_current AS "Pass",
    power_current AS "Power",
    catching_current AS "Catching",
    team_points_current AS "TeamPoints"
FROM statistic
FOR XML RAW ('Person'), ROOT ('statistic')
-- Этот SQL-запрос формирует XML-документ из данных таблицы statistic, преобразуя строки таблицы в элементы XML
-- FOR XML RAW ('Person'), ROOT ('statistic'): формирует выходной XML-документ,
-- где каждая строка результата будет представлена как элемент <Person>,
-- а корневым элементом всего XML-документа будет <statistic>.

SELECT 
    id_person,
    goals_current,
    pass_current,
    power_current ,
    catching_current,
    team_points_current
FROM statistic
FOR XML AUTO,ELEMENTS
-- Этот SQL-запрос также формирует XML-документ из данных таблицы statistic, но используется другая форма представления данных.
-- формируется XML-документ, где каждая строка результата будет представлена как элемент, причем каждый столбец будет представлен как подэлемент внутри элемента строки.
SELECT 
    id_player AS "@PlayerID", 
    name_player AS "Player/Name", 
    player_birthdate AS "Player/Birthdate", 
    phone_player AS "Player/PhoneNo", 
    player_position AS "Player/Position", 
    team_name AS "Player/TeamName" 
FROM dbo.player 
FOR XML PATH('Player');
-- Этот SQL-запрос формирует XML-документ из данных таблицы player.
-- Каждый элемент Player будет содержать атрибут PlayerID и вложенные элементы Name, Birthdate, PhoneNo, Position, и TeamName.

SELECT
    p.id_player AS "@PlayerID",
    (
        SELECT
            g.id_game,
            g.game_date
        FROM dbo.games g
        JOIN dbo.team_games tg ON g.id_game = tg.id_game
        WHERE tg.id_team_1 = p.team_id OR tg.id_team_2 = p.team_id
        FOR XML PATH('Game'), TYPE
    ) AS "Games"
FROM dbo.player p
ORDER BY p.id_player
FOR XML PATH('Player'), ROOT('Players');
-- Этот SQL-запрос создает XML-документ из таблицы player с вложенными элементами.
-- Внутри каждого элемента Player будет вложенный элемент Games, содержащий элементы Game с id_game и game_date из таблицы games, связанных с командами игрока.

SELECT
    t.id_team AS "@TeamID",
    (
        SELECT
            tp.id_player AS "PlayerID",
            tp.player_position AS "Position"
        FROM dbo.team_player tp
        WHERE tp.id_team = t.id_team
        FOR XML AUTO, TYPE
    ) AS "Players"
FROM dbo.team t
ORDER BY t.id_team
FOR XML AUTO, ROOT('Teams');
-- Этот SQL-запрос создает XML-документ из таблицы team с вложенными элементами.
-- Внутри каждого элемента Team будет вложенный элемент Players, содержащий элементы Player с PlayerID и Position из таблицы team_player, связанных с командой.

SELECT 
    1 AS Tag,
    NULL AS Parent,
    p.id_player AS [Player!1!PlayerID],
    p.name_player AS [Player!1!Name!Element]
FROM dbo.player p
FOR XML EXPLICIT;
-- Этот SQL-запрос формирует XML-документ из данных таблицы player, используя директиву FOR XML EXPLICIT.
-- FOR XML EXPLICIT позволяет детально управлять структурой XML. В этом случае, создается элемент Player с атрибутом PlayerID и вложенным элементом Name.
