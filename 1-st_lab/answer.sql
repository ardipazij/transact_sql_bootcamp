SELECT 
    id_person AS "PersonID",
    goals_current AS "Goals",
    pass_current AS "Pass",
    power_current AS "Power",
    catching_current AS "Catching",
    team_points_current AS "TeamPoints"
FROM statistic
FOR XML RAW ('Person'), ROOT ('statistic')

SELECT 
    id_person,
    goals_current,
    pass_current,
    power_current ,
    catching_current,
    team_points_current
FROM statistic
FOR XML AUTO,ELEMENTS

SELECT 
    id_player AS "@PlayerID", 
    name_player AS "Player/Name", 
    player_birthdate AS "Player/Birthdate", 
    phone_player AS "Player/PhoneNo", 
    player_position AS "Player/Position", 
    team_name AS "Player/TeamName" 
FROM dbo.player 
FOR XML PATH('Player');

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

SELECT 
    1 AS Tag,
    NULL AS Parent,
    p.id_player AS [Player!1!PlayerID],
    p.name_player AS [Player!1!Name!Element]
FROM dbo.player p
FOR XML EXPLICIT;