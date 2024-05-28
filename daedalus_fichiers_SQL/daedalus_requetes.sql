-- select artists that have collaborated the most on the songs 

SELECT 
    CONCAT(p1.nom, ' ', p1.prenom) AS artist_1,
    CONCAT(p2.nom, ' ', p2.prenom) AS artist_2,
    COUNT(*) AS collaboration_count, 
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


-- top 5 artists that are liked the most by users with a premium plan 

SELECT 
    a.id_artiste, 
    CONCAT(p.prenom, ' ', p.nom) AS 'Full Name', 
    COUNT(e.id_contenu) AS likes_count 
FROM artiste a 
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

-- who are the most active listeners and what are their favorite genres

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
