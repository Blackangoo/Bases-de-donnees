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
    id_label INT NOT NULL, 
    PRIMARY KEY (id_artiste)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE artiste
    ADD CONSTRAINT fk_artiste_personne
    FOREIGN KEY (id_artiste)
    REFERENCES personne (id_personne);

--
-- Structure pour la table 'utilisateur'
--

DROP TABLE IF EXISTS utilisateur;
CREATE TABLE utilisateur (
    id_utilisateur INT NOT NULL,  
    PRIMARY KEY (id_utilisateur)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE utilisateur
    ADD CONSTRAINT fk_utilisateur_personne
    FOREIGN KEY (id_utilisateur)
    REFERENCES personne (id_personne);

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
    REFERENCES label (id_label);

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
    REFERENCES evenement (id_evenement);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE participation
    ADD CONSTRAINT fk_participation_artiste
    FOREIGN KEY (id_artiste)
    REFERENCES artiste (id_artiste);

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
    link VARCHAR(512) NOT NULL,
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
    REFERENCES artiste (id_artiste);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE vente
    ADD CONSTRAINT fk_vente_produits_derives
    FOREIGN KEY (id_produits_derives)
    REFERENCES produits_derives (id_produits_derives);

-- ########################################################

--
-- Structure pour la table 'artiste_favori'
--      relation classe-association entre 'utilisateur' et 'artiste' en trois tables et deux contraintes de clé étrangère
--

DROP TABLE IF EXISTS artiste_favori;
CREATE TABLE artiste_favori (
    id_utilisateur INT NOT NULL,
    id_artiste INT NOT NULL, 
    rating INT NOT NULL,
    PRIMARY KEY (id_utilisateur, id_artiste)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE artiste_favori
    ADD CONSTRAINT fk_artiste_favori_artiste
    FOREIGN KEY (id_artiste)
    REFERENCES artiste (id_artiste);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE artiste_favori
    ADD CONSTRAINT fk_artiste_favori_utilisateur
    FOREIGN KEY (id_utilisateur)
    REFERENCES utilisateur (id_utilisateur);

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
    duree TIME NOT NULL, 
    PRIMARY KEY (id_video_clip)
);

-- ########################################################

--
-- Structure pour la table 'contenu_audio'
--      'chanson' et 'podcast' en héritent avec une transformation par distinction
--      relation un-à-plusieurs entre 'clip_video' et 'contenu_audio' en deux tables et une contrainte de clé étrangère
--      relation plusieurs-à-plusieurs entre 'contenu_audio' et 'utilisateur' en trois tables et deux contraintes de clé étrangère
--

DROP TABLE IF EXISTS contenu_audio;
CREATE TABLE contenu_audio (
    id_contenu VARCHAR(2000) NOT NULL, 
    duree TIME NOT NULL, 
    date_de_sortie DATE NOT NULL, 
    paroles DATE NOT NULL,
    id_video_clip INT NOT NULL,
    PRIMARY KEY (id_contenu)
);

--
-- Structure pour la table 'podcast'
--

DROP TABLE IF EXISTS podcast;
CREATE TABLE podcast (
    id_contenu INT NOT NULL, 
    description_podcast VARCHAR(2000) NOT NULL, 
    PRIMARY KEY (id_contenu)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE podcast
    ADD CONSTRAINT fk_podcast_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu);

--
-- Structure pour la table 'chanson'
-- relation d’agrégation entre 'chanson' et 'album' en deux tables et une contrainte de clé étrangère
-- relation d’agrégation entre 'chanson' et 'playlist' en deux tables et une contrainte de clé étrangère
--

DROP TABLE IF EXISTS chanson;
CREATE TABLE chanson (
    id_contenu INT NOT NULL, 
    id_album INT NOT NULL, 
    id_playlist INT NOT NULL,
    PRIMARY KEY (id_contenu)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE chanson
    ADD CONSTRAINT fk_chanson_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu);

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

ALTER TABLE chanson
    ADD CONSTRAINT fk_chanson_album
    FOREIGN KEY (id_album)
    REFERENCES album (id_album);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE chanson
    ADD CONSTRAINT fk_chanson_playlist
    FOREIGN KEY (id_playlist)
    REFERENCES playlist (id_playlist);

--
-- Structure pour la table 'favori'
--

DROP TABLE IF EXISTS favori;
CREATE TABLE favori (
    id_contenu INT NOT NULL, 
    id_utilisateur INT NOT NULL,
    favori INT NOT NULL,
    PRIMARY KEY (id_contenu, id_utilisateur)
);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE favori
    ADD CONSTRAINT fk_favori_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu_audio);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE favori
    ADD CONSTRAINT fk_favori_utilisateur
    FOREIGN KEY (id_utilisateur)
    REFERENCES utilisateur (id_utilisateur);

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
    REFERENCES utilisateur (id_utilisateur);

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
    REFERENCES contenu_audio (id_contenu);

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
    REFERENCES contenu_audio (id_contenu);

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
    REFERENCES artiste (id_artiste);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE credits
    ADD CONSTRAINT fk_credits_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu);

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
    REFERENCES credits (id_credits);

--
-- Création de la contrainte de clé étrangère
--

ALTER TABLE mentionne
    ADD CONSTRAINT fk_mentionne_type_artiste
    FOREIGN KEY (id_type_artiste)
    REFERENCES type_artiste (id_type_artiste);
