-- Suppression de la base de données si elle existe
DROP DATABASE IF EXISTS swiss_vibes;
-- Création de la base de données
CREATE DATABASE swiss_vibes;

-- Utiliser la base de données 'swiss_vibes' pour les requêtes suivantes
USE swiss_vibes;

-- Suppression et création des tables ainsi que leurs colonnes

-- ########################################################

--
-- Structure pour la table 'personne'
--      'artiste' et 'utilisateur' en héritent avec une transformation par distinction
--

DROP TABLE IF EXISTS personne;
CREATE TABLE personne (
    id_personne INT NOT NULL, 
    nom_utilisateur VARCHAR(64) NOT NULL, 
    nom VARCHAR(64) NOT NULL,
    prenom VARCHAR(64) NOT NULL, 
    mot_de_passe VARCHAR(64) NOT NULL,
    adresse_email VARCHAR(320) NOT NULL,
    PRIMARY KEY (id_personne)
);

--
-- Structure pour la table 'artiste'
--

DROP TABLE IF EXISTS artiste;
CREATE TABLE artiste (
    id_artiste INT NOT NULL, 
    biographie VARCHAR(2000) NOT NULL, 
    id_label INT, 
    PRIMARY KEY (id_artiste)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE artiste
    ADD CONSTRAINT fk_artiste_personne
    FOREIGN KEY (id_artiste)
    REFERENCES personne (id_personne)
    ON DELETE CASCADE;

--
-- Structure pour la table 'utilisateur'
--

DROP TABLE IF EXISTS utilisateur;
CREATE TABLE utilisateur (
    id_utilisateur INT NOT NULL,  
    annee_naissance YEAR NOT NULL,
    canton_residence CHAR(2) NOT NULL,
    id_abonnement INT,
    PRIMARY KEY (id_utilisateur)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE utilisateur
    ADD CONSTRAINT fk_utilisateur_personne
    FOREIGN KEY (id_utilisateur)
    REFERENCES personne (id_personne)
    ON DELETE CASCADE;

-- ########################################################

--
-- Structure pour la table 'label'
--

DROP TABLE IF EXISTS label;
CREATE TABLE label (
    id_label INT NOT NULL, 
    nom VARCHAR(64) NOT NULL, 
    PRIMARY KEY (id_label)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE artiste
    ADD CONSTRAINT fk_label_artiste
    FOREIGN KEY (id_label)
    REFERENCES label (id_label)
    ON DELETE CASCADE;

-- ########################################################

--
-- Structure pour la table 'evenement'
--      relation plusieurs-à-plusieurs entre 'evenement' et 'artiste' en trois tables et deux contraintes de clé étrangère
--

DROP TABLE IF EXISTS evenement;
CREATE TABLE evenement (
    id_evenement INT NOT NULL, 
    lieu VARCHAR(100) NOT NULL, 
    date DATE NOT NULL,
    lien VARCHAR(512) NOT NULL,
    PRIMARY KEY (id_evenement)
);

--
-- Structure pour la table 'participation'
--

DROP TABLE IF EXISTS participation;
CREATE TABLE participation (
    id_artiste INT NOT NULL, 
    id_evenement INT NOT NULL, 
    PRIMARY KEY (id_artiste, id_evenement)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE participation
    ADD CONSTRAINT fk_participation_evenement
    FOREIGN KEY (id_evenement)
    REFERENCES evenement (id_evenement)
    ON DELETE CASCADE;

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE participation
    ADD CONSTRAINT fk_participation_artiste
    FOREIGN KEY (id_artiste)
    REFERENCES artiste (id_artiste)
    ON DELETE CASCADE;

-- ########################################################

--
-- Structure pour la table 'produits_derives'
--      relation plusieurs-à-plusieurs entre 'produits_derives' et 'artiste' en trois tables et deux contraintes de clé étrangère
--

DROP TABLE IF EXISTS produits_derives;
CREATE TABLE produits_derives (
    id_produits_derives INT NOT NULL, 
    description_produits VARCHAR(2000) NOT NULL, 
    prix FLOAT NOT NULL,
    lien VARCHAR(512) NOT NULL,
    PRIMARY KEY (id_produits_derives)
);

--
-- Structure pour la table 'vente'
--

DROP TABLE IF EXISTS vente;
CREATE TABLE vente (
    id_artiste INT NOT NULL, 
    id_produits_derives INT NOT NULL, 
    PRIMARY KEY (id_artiste, id_produits_derives)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE vente
    ADD CONSTRAINT fk_vente_artiste
    FOREIGN KEY (id_artiste)
    REFERENCES artiste (id_artiste)
    ON DELETE CASCADE;

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE vente
    ADD CONSTRAINT fk_vente_produits_derives
    FOREIGN KEY (id_produits_derives)
    REFERENCES produits_derives (id_produits_derives)
    ON DELETE CASCADE;

-- ########################################################

--
-- Structure pour la table 'artiste_favori'
--      relation classe-association entre 'utilisateur' et 'artiste' en trois tables et deux contraintes de clé étrangère
--      note prend ses valeurs entre 1 et 5
--

DROP TABLE IF EXISTS artiste_favori;
CREATE TABLE artiste_favori (
    id_utilisateur INT NOT NULL,
    id_artiste INT NOT NULL, 
    note INT NOT NULL,
    PRIMARY KEY (id_utilisateur, id_artiste)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE artiste_favori
    ADD CONSTRAINT fk_artiste_favori_artiste
    FOREIGN KEY (id_artiste)
    REFERENCES artiste (id_artiste)
    ON DELETE CASCADE;

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE artiste_favori
    ADD CONSTRAINT fk_artiste_favori_utilisateur
    FOREIGN KEY (id_utilisateur)
    REFERENCES utilisateur (id_utilisateur)
    ON DELETE CASCADE;

-- ########################################################

--
-- Structure pour la table 'abonnement'
--      relation un-à-plusieurs entre 'abonnement' et 'utilisateur' en deux tables et une contrainte de clé étrangère
--

DROP TABLE IF EXISTS abonnement;
CREATE TABLE abonnement (
    id_abonnement INT NOT NULL, 
    prix INT NOT NULL, 
    nom VARCHAR(64) NOT NULL,
    description_abonnement VARCHAR(2000) NOT NULL, 
    PRIMARY KEY (id_abonnement)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE utilisateur
    ADD CONSTRAINT fk_abonnement_utilisateur
    FOREIGN KEY (id_abonnement)
    REFERENCES abonnement (id_abonnement);

--
-- Structure pour la table 'clip_video'
--

DROP TABLE IF EXISTS clip_video;
CREATE TABLE clip_video (
    id_video_clip INT NOT NULL,
    animation BOOLEAN NOT NULL, 
    duree INT NOT NULL, 
    PRIMARY KEY (id_video_clip)
);

-- ########################################################

--
-- Structure pour la table 'contenu_audio'
--      relation un-à-plusieurs entre 'clip_video' et 'contenu_audio' en deux tables et une contrainte de clé étrangère
--      relation d’agrégation entre 'album' et 'contenu_audio' en deux tables et une contrainte de clé étrangère
--      relation plusieurs-à-plusieurs entre 'contenu_audio' et 'utilisateur' en trois tables et deux contraintes de clé étrangère
--      relation plusieurs-à-plusieurs entre 'contenu_audio' et 'playlist' en trois tables et deux contraintes de clé étrangère
--

DROP TABLE IF EXISTS contenu_audio;
CREATE TABLE contenu_audio (
    id_contenu INT NOT NULL,
    titre VARCHAR(2000) NOT NULL, 
    duree INT NOT NULL, 
    date_de_sortie DATE NOT NULL, 
    paroles VARCHAR(2000) NOT NULL,
    id_video_clip INT NOT NULL,
    id_album INT,
    PRIMARY KEY (id_contenu)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE contenu_audio
    ADD CONSTRAINT fk_clip_video_contenu_audio
    FOREIGN KEY (id_video_clip)
    REFERENCES clip_video (id_video_clip);

--
-- Structure pour la table 'album'
--

DROP TABLE IF EXISTS album;
CREATE TABLE album (
    id_album INT NOT NULL,
    titre VARCHAR(64) NOT NULL, 
    date_de_sortie DATE NOT NULL, 
    PRIMARY KEY (id_album)
);

--
-- Structure pour la table 'playlist'
--

DROP TABLE IF EXISTS playlist;
CREATE TABLE playlist (
    id_playlist INT NOT NULL,
    nom VARCHAR(64) NOT NULL, 
    PRIMARY KEY (id_playlist)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE contenu_audio
    ADD CONSTRAINT fk_contenu_audio_album
    FOREIGN KEY (id_album)
    REFERENCES album (id_album);

--
-- Structure pour la table 'appartenance'
--

DROP TABLE IF EXISTS appartenance;
CREATE TABLE appartenance (
    id_contenu INT NOT NULL,
    id_playlist INT NOT NULL,
    PRIMARY KEY (id_contenu, id_playlist)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE appartenance
    ADD CONSTRAINT fk_appartenance_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu)
    ON DELETE CASCADE;

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE appartenance
    ADD CONSTRAINT fk_appartenance_playlist
    FOREIGN KEY (id_playlist)
    REFERENCES playlist (id_playlist)
    ON DELETE CASCADE;

--
-- Structure pour la table 'ecoute'
--

DROP TABLE IF EXISTS ecoute;
CREATE TABLE ecoute (
    id_contenu INT NOT NULL, 
    id_utilisateur INT NOT NULL,
    note INT NOT NULL,
    nombre_ecoute INT NOT NULL,
    date_derniere_ecoute DATE NOT NULL,
    temps_d_ecoute INT NOT NULL,
    PRIMARY KEY (id_contenu, id_utilisateur)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE ecoute
    ADD CONSTRAINT fk_ecoute_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu)
    ON DELETE CASCADE;

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE ecoute
    ADD CONSTRAINT fk_ecoute_utilisateur
    FOREIGN KEY (id_utilisateur)
    REFERENCES utilisateur (id_utilisateur)
    ON DELETE CASCADE;

-- ########################################################

--
-- Structure pour la table 'langage'
--      relation plusieurs-à-plusieurs entre 'langage' et 'utilisateur' en trois tables et deux contraintes de clé étrangère
--      relation plusieurs-à-plusieurs entre 'langage' et 'contenu_audio' en trois tables et deux contraintes de clé étrangère
--

DROP TABLE IF EXISTS langage;
CREATE TABLE langage (
    id_langage INT NOT NULL, 
    langue VARCHAR(64) NOT NULL, 
    PRIMARY KEY (id_langage)
);

--
-- Structure pour la table 'langue_utilisateur'
--

DROP TABLE IF EXISTS langue_utilisateur;
CREATE TABLE langue_utilisateur (
    id_utilisateur INT NOT NULL, 
    id_langage INT NOT NULL, 
    PRIMARY KEY (id_utilisateur, id_langage)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE langue_utilisateur
    ADD CONSTRAINT fk_langue_utilisateur_utilisateur
    FOREIGN KEY (id_utilisateur)
    REFERENCES utilisateur (id_utilisateur)
    ON DELETE CASCADE;

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE langue_utilisateur
    ADD CONSTRAINT fk_langue_utilisateur_langage
    FOREIGN KEY (id_langage)
    REFERENCES langage (id_langage);

--
-- Structure pour la table 'parle'
--

DROP TABLE IF EXISTS parle;
CREATE TABLE parle (
    id_contenu INT NOT NULL, 
    id_langage INT NOT NULL,
    PRIMARY KEY (id_contenu, id_langage)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE parle
    ADD CONSTRAINT fk_parle_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu)
    ON DELETE CASCADE;

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE parle
    ADD CONSTRAINT fk_parle_langage
    FOREIGN KEY (id_langage)
    REFERENCES langage (id_langage);

-- ########################################################

--
-- Structure pour la table 'genre'
--      relation plusieurs-à-plusieurs entre 'genre' et 'contenu_audio' en trois tables et deux contraintes de clé étrangère
--

DROP TABLE IF EXISTS genre;
CREATE TABLE genre (
    id_genre INT NOT NULL,
    genre VARCHAR(64) NOT NULL, 
    PRIMARY KEY (id_genre)
);

--
-- Structure pour la table 'decrit'
--

DROP TABLE IF EXISTS decrit;
CREATE TABLE decrit (
    id_contenu INT NOT NULL, 
    id_genre INT NOT NULL,
    PRIMARY KEY (id_contenu, id_genre)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE decrit
    ADD CONSTRAINT fk_decrit_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu)
    ON DELETE CASCADE;

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE decrit
    ADD CONSTRAINT fk_decrit_genre
    FOREIGN KEY (id_genre)
    REFERENCES genre (id_genre);

-- ########################################################

--
-- Structure pour la table 'credits'
--      relation plusieurs-à-plusieurs entre 'credits' et 'type_artiste' en trois tables et deux contraintes de clé étrangère
--      relation classe-association entre 'contenu_audio' et 'artiste' en trois tables et deux contraintes de clé étrangère
--

DROP TABLE IF EXISTS credits;
CREATE TABLE credits (
    id_credits INT NOT NULL, 
    id_artiste INT NOT NULL,
    id_contenu INT NOT NULL,  
    PRIMARY KEY (id_credits)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE credits
    ADD CONSTRAINT fk_credits_artiste
    FOREIGN KEY (id_artiste)
    REFERENCES artiste (id_artiste)
    ON DELETE CASCADE;

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE credits
    ADD CONSTRAINT fk_credits_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu)
    ON DELETE CASCADE;

--
-- Structure pour la table 'type_artiste'
--

DROP TABLE IF EXISTS type_artiste;
CREATE TABLE type_artiste (
    id_type_artiste INT NOT NULL,
    type_artiste VARCHAR(64) NOT NULL,
    PRIMARY KEY (id_type_artiste)
);

--
-- Structure pour la table 'mentionne'
--

DROP TABLE IF EXISTS mentionne;
CREATE TABLE mentionne (
    id_credits INT NOT NULL,
    id_type_artiste INT NOT NULL,
    PRIMARY KEY (id_credits, id_type_artiste)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE mentionne
    ADD CONSTRAINT fk_mentionne_credits
    FOREIGN KEY (id_credits)
    REFERENCES credits (id_credits)
    ON DELETE CASCADE;

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE mentionne
    ADD CONSTRAINT fk_mentionne_type_artiste
    FOREIGN KEY (id_type_artiste)
    REFERENCES type_artiste (id_type_artiste)
    ON DELETE CASCADE;

-- ########################################################

--
-- Trigger 'ecoute'
--

DROP TRIGGER IF EXISTS before_insert_ecoute;
DELIMITER $$
CREATE TRIGGER before_insert_ecoute BEFORE INSERT ON ecoute FOR EACH ROW 
BEGIN
    IF NEW.note < 1 THEN
        SET NEW.note = 1;
    ELSEIF NEW.note > 5 THEN
        SET NEW.note = 5;
    END IF;
END
$$
DELIMITER ;

--
-- Trigger 'artiste_favori'
--

DROP TRIGGER IF EXISTS before_insert_artiste_favori;
DELIMITER $$
CREATE TRIGGER before_insert_artiste_favori BEFORE INSERT ON artiste_favori FOR EACH ROW
BEGIN
    IF NEW.note < 1 THEN
        SET NEW.note = 1;
    ELSEIF NEW.note > 5 THEN
        SET NEW.note = 5;
    END IF;
END
$$
DELIMITER ;

--
-- Trigger 'artiste'
--

DROP TRIGGER IF EXISTS before_delete_artiste;
DELIMITER $$
CREATE TRIGGER before_delete_artiste BEFORE DELETE ON artiste FOR EACH ROW
BEGIN

    -- Delete events with only the current artist participating
    DELETE FROM evenement 
    WHERE id_evenement IN (
        SELECT id_evenement
        FROM participation
        GROUP BY id_evenement
        HAVING COUNT(id_artiste) = 1 AND SUM( id_artiste = OLD.id_artiste ) = 1
    );

    -- Delete products of the deleted artist
    DELETE FROM produits_derives 
    WHERE id_produits_derives IN (
        SELECT id_produits_derives 
        FROM vente 
        WHERE id_artiste = OLD.id_artiste
    );

    -- Delete contenu_audio with only the current artist participating
    DELETE FROM contenu_audio 
    WHERE id_contenu IN (
        SELECT id_contenu 
        FROM credits 
        GROUP BY id_contenu
        HAVING COUNT(id_artiste) = 1 AND SUM( id_artiste = OLD.id_artiste ) = 1
    );
END
$$
DELIMITER ;

--
-- Trigger 'contenu_audio'
--

DROP TRIGGER IF EXISTS after_delete_contenu_audio;
DELIMITER $$
CREATE TRIGGER after_delete_contenu_audio AFTER DELETE ON contenu_audio FOR EACH ROW
BEGIN
    -- Delete the album if it contains only the deleted contenu_audio
    IF (SELECT COUNT(*) FROM contenu_audio WHERE id_album = OLD.id_album) = 0 THEN
        DELETE FROM album WHERE id_album = OLD.id_album;
    END IF;

    -- Delete the associated clip_video if it is not referenced by any other contenu_audio
    IF (SELECT COUNT(*) FROM contenu_audio WHERE id_video_clip = OLD.id_video_clip) = 0 THEN
        DELETE FROM clip_video WHERE id_video_clip = OLD.id_video_clip;
    END IF;
END$$

DELIMITER ;

-- ########################################################

--
-- View 'bot_warning'
--

CREATE VIEW bot_warning_view AS
SELECT 
    u.id_utilisateur, 
    CONCAT(p.prenom, ' ', p.nom) AS nom_complet,
    GROUP_CONCAT(ca.titre SEPARATOR ', ') AS titres_contenus,
    GROUP_CONCAT(e.nombre_ecoute SEPARATOR ', ') AS ecoutes,
    GROUP_CONCAT(e.temps_d_ecoute / e.nombre_ecoute SEPARATOR ', ') AS fractions_ecoute,
    GROUP_CONCAT(ca.duree / 5 SEPARATOR ', ') AS pourcentages_contenu
FROM ecoute e
INNER JOIN utilisateur u ON e.id_utilisateur = u.id_utilisateur
INNER JOIN personne p ON e.id_utilisateur = p.id_personne
INNER JOIN contenu_audio ca ON e.id_contenu = ca.id_contenu
WHERE e.nombre_ecoute > 1000 AND e.temps_d_ecoute / e.nombre_ecoute < ca.duree / 10
GROUP BY u.id_utilisateur, nom_complet;

-- Listeners who have listened to all songs by a specific artist (with id 10) procédure ??
DELIMITER $$
CREATE PROCEDURE SuperFans (IN id_artist INT)
BEGIN
    SELECT 
        u.id_utilisateur,
        p.nom_utilisateur,
        CONCAT(p.nom, ' ', p.prenom) AS 'Name of the user'
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
