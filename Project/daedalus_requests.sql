-- select artists that have collaborated the most on the songs

SELECT 
    p1.nom AS artist_1_last_name,
    p1.prenom AS artist_1_first_name,
    p2.nom AS artist_2_last_name,
    p2.prenom AS artist_2_first_name,
    COUNT(*) AS collaboration_count,
    GROUP_CONCAT(ca.titre SEPARATOR ', ') AS collaborated_songs,
    GROUP_CONCAT(l.langue SEPARATOR ', ') AS languages
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
    p1.nom, p1.prenom, p2.nom, p2.prenom
ORDER BY 
    collaboration_count DESC
LIMIT 1;

-- top 5 artists who have participated in the most events
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

-- top 5 artists that are liked the most by users with a premium plan
SELECT 
    a.id_artiste,
    p.nom,
    p.prenom,
    COUNT(f.id_contenu) AS likes_count
FROM 
    artiste a
JOIN 
    personne p ON a.id_artiste = p.id_personne
JOIN 
    credits c ON a.id_artiste = c.id_artiste
JOIN 
    favori f ON c.id_contenu = f.id_contenu
JOIN 
    utilisateur u ON f.id_utilisateur = u.id_utilisateur
JOIN 
    abonnement ab ON u.id_abonnement = ab.id_abonnement
WHERE 
    ab.nom = 'Premiums'
GROUP BY 
    a.id_artiste, p.nom
ORDER BY 
    likes_count DESC
LIMIT 5;

-- Listeners who have listened to all songs by a specific artist (with id 10)

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
        WHERE cr.id_artiste = 10
        AND NOT EXISTS (
            SELECT *
            FROM favori f
            WHERE f.id_utilisateur = u.id_utilisateur
            AND f.id_contenu = ca.id_contenu
        )
    );

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
            FROM favori f
            WHERE f.id_utilisateur = u.id_utilisateur
            AND f.id_contenu = ca.id_contenu
        )
    );