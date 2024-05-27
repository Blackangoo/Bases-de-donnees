-- select artists that have collaborated the most on the songs concat nom prenom

SELECT 
    CONCAT(p1.nom, ' ', p1.prenom) AS artist_1,
    CONCAT(p2.nom, ' ', p2.prenom) AS artist_2,
    COUNT(*) AS collaboration_count, --plus précis ptt
    GROUP_CONCAT(DISTINCT ca.titre SEPARATOR ', ') AS collaborated_songs,
    GROUP_CONCAT(DISTINCT l.langue SEPARATOR ', ') AS languages
FROM 
    credits cr1
JOIN 
    credits cr2 ON cr1.id_contenu = cr2.id_contenu AND cr1.id_artiste < cr2.id_artiste
JOIN 
    artiste a1 ON cr1.id_artiste = a1.id_artiste
JOIN 
    artiste a2 ON cr2.id_artiste = a2.id_artiste
JOIN 
    personne p1 ON a1.id_artiste = p1.id_personne
JOIN 
    personne p2 ON a2.id_artiste = p2.id_personne
JOIN 
    contenu_audio ca ON cr1.id_contenu = ca.id_contenu
JOIN 
    parle p ON ca.id_contenu = p.id_contenu
JOIN 
    langage l ON p.id_langage = l.id_langage
GROUP BY 
    artist_1, artist_2
ORDER BY 
    collaboration_count DESC
LIMIT 1;

-- top 5 artists who have participated in the most events plus une visualisation
SELECT 
    a.id_artiste,
    p.nom,
    p.prenom,
    COUNT(pa.id_evenement) AS event_count
FROM 
    artiste a
JOIN 
    personne p ON a.id_artiste = p.id_personne
JOIN 
    participation pa ON a.id_artiste = pa.id_artiste
GROUP BY 
    a.id_artiste, p.nom
ORDER BY 
    event_count DESC
LIMIT 5;

-- top 5 artists that are liked the most by users with a premium plan celle là est mieux
SELECT 
    a.id_artiste,
    p.nom,
    p.prenom,
    COUNT(e.id_contenu) AS likes_count
FROM 
    artiste a
JOIN 
    personne p ON a.id_artiste = p.id_personne
JOIN 
    credits c ON a.id_artiste = c.id_artiste
JOIN 
    ecoute e ON c.id_contenu = e.id_contenu
JOIN 
    utilisateur u ON e.id_utilisateur = u.id_utilisateur
JOIN 
    abonnement ab ON u.id_abonnement = ab.id_abonnement
WHERE 
    ab.nom = 'Premiums'
GROUP BY 
    a.id_artiste, p.nom
ORDER BY 
    likes_count DESC
LIMIT 5;

-- Listeners who have listened to all songs by a specific artist (with id 10) procédure ??
DELIMITER $$
CREATE PROCEDURE SuperFans (IN id_artist INT)
BEGIN
    SELECT 
        u.id_utilisateur,
        p.nom_utilisateur,
        CONCAT (p.nom, ' ', p.prenom) 'Name of the user'
    FROM 
        utilisateur u
    JOIN 
        personne p ON u.id_utilisateur = p.id_personne
    WHERE 
        NOT EXISTS (
            SELECT *
            FROM contenu_audio ca
            JOIN credits cr ON ca.id_contenu = cr.id_contenu
            WHERE cr.id_artiste = id_artist
            AND NOT EXISTS (
                SELECT *
                FROM ecoute e
                WHERE e.id_utilisateur = u.id_utilisateur
                AND e.id_contenu = ca.id_contenu
            )
        );
END $$
DELIMITER ;

-- same shit but with the name of the artist (Adam Schmidt)

SELECT 
    u.id_utilisateur,
    p.nom_utilisateur,
    CONCAT (p.nom, ' ', p.prenom) 'Name of the user'
FROM 
    utilisateur u
JOIN 
    personne p ON u.id_utilisateur = p.id_personne
WHERE 
    NOT EXISTS (
        SELECT *
        FROM contenu_audio ca
        JOIN credits cr ON ca.id_contenu = cr.id_contenu
        JOIN artiste a ON cr.id_artiste = a.id_artiste
        JOIN personne pa ON a.id_artiste = pa.id_personne
        WHERE pa.nom = 'Schmidt'  
        AND pa.prenom = 'Adam'
        AND NOT EXISTS (
            SELECT *
            FROM ecoute e
            WHERE e.id_utilisateur = u.id_utilisateur
            AND e.id_contenu = ca.id_contenu
        )
    );

-- Find the most active listeners this month and their most listened genre

-- SELECT 
--     u.id_utilisateur,
--     p.nom_utilisateur,
--     CONCAT(p.nom, ' ', p.prenom) AS 'Full Name',
--     g.genre,
--     listens.`Total Listens`
-- FROM 
--     utilisateur u
-- JOIN 
--     personne p ON u.id_utilisateur = p.id_personne
-- JOIN 
--     (
--         SELECT 
--             e.id_utilisateur,
--             SUM(e.nombre_ecoute) AS 'Total Listens'
--         FROM 
--             ecoute e
--         WHERE 
--             MONTH(e.date_derniere_ecoute) = MONTH(CURRENT_DATE())
--             AND YEAR(e.date_derniere_ecoute) = YEAR(CURRENT_DATE())
--         GROUP BY 
--             e.id_utilisateur
--     ) AS listens ON u.id_utilisateur = listens.id_utilisateur
-- JOIN 
--     (
--         SELECT 
--             e.id_utilisateur,
--             d.id_genre
--         FROM 
--             ecoute e
--         JOIN 
--             contenu_audio ca ON e.id_contenu = ca.id_contenu
--         JOIN 
--             decrit d ON ca.id_contenu = d.id_contenu
--         WHERE 
--             MONTH(e.date_derniere_ecoute) = MONTH(CURRENT_DATE())
--             AND YEAR(e.date_derniere_ecoute) = YEAR(CURRENT_DATE())
--         GROUP BY 
--             e.id_utilisateur, d.id_genre
--         ORDER BY 
--             COUNT(*) DESC
--     ) AS top_genre ON listens.id_utilisateur = top_genre.id_utilisateur
-- JOIN 
--     genre g ON top_genre.id_genre = g.id_genre
-- ORDER BY 
--     listens.`Total Listens` DESC
-- LIMIT 5;

SELECT 
    u.id_utilisateur,
    p.nom_utilisateur,
    CONCAT(p.nom, ' ', p.prenom) AS 'Full Name',
    (SELECT 
            CONCAT(g.genre, ' (', MAX(e.nombre_ecoute), ')')
        FROM 
            ecoute e
        JOIN 
            contenu_audio ca ON e.id_contenu = ca.id_contenu
        JOIN 
            decrit d ON ca.id_contenu = d.id_contenu
        JOIN 
            genre g ON d.id_genre = g.id_genre
        WHERE 
            e.id_utilisateur = u.id_utilisateur
            AND MONTH(e.date_derniere_ecoute) = MONTH(CURRENT_DATE())
            AND YEAR(e.date_derniere_ecoute) = YEAR(CURRENT_DATE())
        GROUP BY 
            e.id_utilisateur, d.id_genre
        ORDER BY 
            MAX(e.nombre_ecoute) DESC
        LIMIT 1) AS top_genre,
    listens.`Total Listens`
FROM 
    utilisateur u
JOIN 
    personne p ON u.id_utilisateur = p.id_personne
JOIN 
    (
        SELECT 
            e.id_utilisateur,
            SUM(e.nombre_ecoute) AS 'Total Listens'
        FROM 
            ecoute e
        WHERE 
            MONTH(e.date_derniere_ecoute) = MONTH(CURRENT_DATE())
            AND YEAR(e.date_derniere_ecoute) = YEAR(CURRENT_DATE())
        GROUP BY 
            e.id_utilisateur
    ) AS listens ON u.id_utilisateur = listens.id_utilisateur
ORDER BY 
    listens.`Total Listens` DESC
LIMIT 10;


-- rank the most popular cantons VISUALISATION

SELECT 
    most_spoken_language_canton.canton_of_residence AS most_spoken_language_canton,
    COUNT(*) AS user_count
FROM 
    utilisateur u
JOIN 
    langue_utilisateur ON u.id_utilisateur = langue_utilisateur.id_utilisateur
JOIN 
    langage ON langue_utilisateur.id_langage = langage.id_langage
JOIN (
    SELECT 
        langage.langue AS spoken_language,
        utilisateur.canton_residence AS canton_of_residence
    FROM 
        langage
    JOIN 
        langue_utilisateur ON langage.id_langage = langue_utilisateur.id_langage
    JOIN 
        utilisateur ON langue_utilisateur.id_utilisateur = utilisateur.id_utilisateur
    GROUP BY 
        langage.langue, utilisateur.canton_residence
    ORDER BY 
        COUNT(*) DESC
) AS most_spoken_language_canton ON u.canton_residence = most_spoken_language_canton.canton_of_residence
WHERE 
    langage.langue = most_spoken_language_canton.spoken_language
GROUP BY 
    most_spoken_language_canton.canton_of_residence
ORDER BY 
    user_count DESC;


-- find users that were born in the years 1990-2000 and who's canton if residency is either Geneva or Vaud and what are their listens count
SELECT 
    u.id_utilisateur,
    p.nom_utilisateur,
    COUNT(e.id_contenu) AS total_songs_listened
FROM 
    utilisateur u
JOIN 
    personne p ON u.id_utilisateur = p.id_personne
JOIN 
    ecoute e ON u.id_utilisateur = e.id_utilisateur
WHERE 
    (u.annee_naissance BETWEEN 1990 AND 2000)  
    AND 
    (
        u.canton_residence = 'GE'  
        OR 
        u.canton_residence = 'VD'  
    )
GROUP BY 
    u.id_utilisateur, p.nom_utilisateur
ORDER BY 
    total_songs_listened DESC;
