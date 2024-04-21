-- Suppression de la base de données si elle existe
DROP DATABASE IF EXISTS swiss_vibes;
-- Création de la base de données
CREATE DATABASE swiss_vibes;

-- Utiliser la base de données 'swiss_vibes' pour les requêtes suivantes
USE swiss_vibes;

-- Suppression et création des tables ainsi que leurs colonnes

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

DROP TABLE IF EXISTS artiste;
CREATE TABLE artiste (
    id_personne INT NOT NULL, 
    biographie VARCHAR(2000) NOT NULL, 
    PRIMARY KEY (id_personne)
);

ALTER TABLE artiste
    ADD CONSTRAINT fk_artiste_personne
    FOREIGN KEY (id_personne)
    REFERENCES personne (id_personne);

DROP TABLE IF EXISTS utilisateur;
CREATE TABLE utilisateur (
    id_personne INT NOT NULL,  
    PRIMARY KEY (id_personne)
);

ALTER TABLE utilisateur
    ADD CONSTRAINT fk_utilisateur_personne
    FOREIGN KEY (id_personne)
    REFERENCES personne (id_personne);

DROP TABLE IF EXISTS label;
CREATE TABLE label (
    id_label INT NOT NULL, 
    nom VARCHAR(64) NOT NULL, 
    PRIMARY KEY (id_label)
);

DROP TABLE IF EXISTS representation;
CREATE TABLE representation (
    id_personne INT NOT NULL, 
    id_label INT NOT NULL, 
    PRIMARY KEY (id_personne, id_label)
);

ALTER TABLE representation
    ADD CONSTRAINT fk_representation_artiste
    FOREIGN KEY (id_personne)
    REFERENCES artiste(id_personne);

ALTER TABLE representation
    ADD CONSTRAINT fk_representation_label
    FOREIGN KEY (id_label)
    REFERENCES label(id_label);

DROP TABLE IF EXISTS evenement;
CREATE TABLE evenement (
    id_evenement INT NOT NULL, 
    lieu VARCHAR(100) NOT NULL, 
    date DATE NOT NULL,
    PRIMARY KEY (id_evenement)
);

DROP TABLE IF EXISTS participation;
CREATE TABLE participation (
    id_personne INT NOT NULL, 
    id_evenement INT NOT NULL, 
    PRIMARY KEY (id_personne, id_evenement)
);

ALTER TABLE participation
    ADD CONSTRAINT fk_participation_evenement
    FOREIGN KEY (id_evenement)
    REFERENCES evenement(id_evenement);

ALTER TABLE participation
    ADD CONSTRAINT fk_participation_artiste
    FOREIGN KEY (id_personne)
    REFERENCES artiste(id_personne);

DROP TABLE IF EXISTS produits_derives;
CREATE TABLE produits_derives (
    id_produits_derives INT NOT NULL, 
    description_produits VARCHAR(2000) NOT NULL, 
    PRIMARY KEY (id_produits_derives)
);

DROP TABLE IF EXISTS vente;
CREATE TABLE vente (
    id_personne INT NOT NULL, 
    id_produits_derives INT NOT NULL, 
    PRIMARY KEY (id_personne, id_produits_derives)
);

ALTER TABLE vente
    ADD CONSTRAINT fk_vente_artiste
    FOREIGN KEY (id_personne)
    REFERENCES artiste(id_personne);

ALTER TABLE vente
    ADD CONSTRAINT fk_vente_produits_derives
    FOREIGN KEY (id_produits_derives)
    REFERENCES produits_derives(id_produits_derives);

DROP TABLE IF EXISTS artiste_favori;
CREATE TABLE artiste_favori (
    id_personne INT NOT NULL, -- why is there 2 id_personne? sure bc there's the same ids for the two classes but should we put them both?
    id_personne INT NOT NULL, 
    PRIMARY KEY (id_personne, id_personne)
);

ALTER TABLE artiste_favori
    ADD CONSTRAINT fk_artiste_favori_artiste
    FOREIGN KEY (id_personne)
    REFERENCES artiste (id_personne);

ALTER TABLE artiste_favori
    ADD CONSTRAINT fk_artiste_favori_utilisateur
    FOREIGN KEY (id_personne)
    REFERENCES utilisateur (id_personne);

DROP TABLE IF EXISTS abonnement;
CREATE TABLE abonnement (
    id_abonnement INT NOT NULL, 
    prix INT NOT NULL, 
    nom VARCHAR(64) NOT NULL,
    description_abonnement VARCHAR(2000) NOT NULL, 
    id_personne INT NOT NULL,
    PRIMARY KEY (id_abonnement)
);

ALTER TABLE abonnement
    ADD CONSTRAINT fk_abonnement_utilisateur
    FOREIGN KEY (id_personne)
    REFERENCES utilisateur (id_personne);

DROP TABLE IF EXISTS remuneration;
CREATE TABLE remuneration (
    id_personne INT NOT NULL, 
    id_abonnement INT NOT NULL, 
    PRIMARY KEY (id_personne, id_abonnement)
);

ALTER TABLE remuneration
    ADD CONSTRAINT fk_remuneration_artiste
    FOREIGN KEY (id_personne)
    REFERENCES artiste (id_personne);

ALTER TABLE remuneration
    ADD CONSTRAINT fk_remuneration_abonnement
    FOREIGN KEY (id_abonnement)
    REFERENCES abonnement (id_abonnement);

DROP TABLE IF EXISTS verification;
CREATE TABLE verification (
    id_personne INT NOT NULL, 
    id_abonnement INT NOT NULL, 
    PRIMARY KEY (id_personne, id_abonnement)
);

ALTER TABLE verification
    ADD CONSTRAINT fk_verification_abonnement
    FOREIGN KEY (id_abonnement)
    REFERENCES personne (id_abonnement);

ALTER TABLE verification
    ADD CONSTRAINT fk_verification_utilisateur
    FOREIGN KEY (id_personne)
    REFERENCES utilisateur (id_personne);

DROP TABLE IF EXISTS langage;
CREATE TABLE langage (
    id_langage INT NOT NULL, 
    langue VARCHAR(64) NOT NULL, 
    PRIMARY KEY (id_langage)
);

DROP TABLE IF EXISTS langue_utilisateur;
CREATE TABLE langue_utilisateur (
    id_personne INT NOT NULL, 
    id_langage INT NOT NULL, 
    PRIMARY KEY (id_personne, id_langage)
);

ALTER TABLE langue_utilisateur
    ADD CONSTRAINT fk_langue_utilisateur_utilisateur
    FOREIGN KEY (id_personne)
    REFERENCES utilisateur (id_personne);

ALTER TABLE langue_utilisateur
    ADD CONSTRAINT fk_langue_utilisateur_langage
    FOREIGN KEY (id_langage)
    REFERENCES langage (id_langage);

DROP TABLE IF EXISTS contenu_audio;
CREATE TABLE contenu_audio (
    id_contenu VARCHAR(2000) NOT NULL, 
    duree TIME NOT NULL, 
    date_de_sortie DATE NOT NULL, 
    paroles DATE NOT NULL,
    PRIMARY KEY (id_contenu)
);

DROP TABLE IF EXISTS credits;
CREATE TABLE credits (
    id_personne INT NOT NULL,
    id_contenu INT NOT NULL, 
    type_artiste VARCHAR(64) NOT NULL, 
    PRIMARY KEY (id_personne, id_contenu)
);

ALTER TABLE credits
    ADD CONSTRAINT fk_credits_artiste
    FOREIGN KEY (id_personne)
    REFERENCES artiste (id_personne);

ALTER TABLE credits
    ADD CONSTRAINT fk_credits_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu);

DROP TABLE IF EXISTS podcast;
CREATE TABLE podcast (
    id_contenu INT NOT NULL, 
    description_podcast VARCHAR(2000) NOT NULL, 
    PRIMARY KEY (id_contenu)
);

DROP TABLE IF EXISTS chanson;
CREATE TABLE chanson (
    id_contenu INT NOT NULL, 
    PRIMARY KEY (id_contenu)
);

ALTER TABLE podcast
    ADD CONSTRAINT fk_podcast_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu);

ALTER TABLE chanson
    ADD CONSTRAINT fk_chanson_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu);

DROP TABLE IF EXISTS album;
CREATE TABLE album (
    id_album INT NOT NULL,
    titre VARCHAR(64) NOT NULL, 
    date_de_sortie DATE NOT NULL, 
    PRIMARY KEY (id_personne, id_contenu)
);

DROP TABLE IF EXISTS playlist;
CREATE TABLE playlist (
    id_playlist INT NOT NULL,
    nom VARCHAR(64) NOT NULL, 
    PRIMARY KEY (id_playlist)
);

DROP TABLE IF EXISTS clip_video;
CREATE TABLE clip_video (
    id_video_clip INT NOT NULL,
    animation BOOLEAN NOT NULL, 
    duree TIME NOT NULL, 
    PRIMARY KEY (id_video_clip)
);

DROP TABLE IF EXISTS genre;
CREATE TABLE genre (
    id_genre INT NOT NULL,
    genre VARCHAR(64) NOT NULL, 
    PRIMARY KEY (id_genre)
);

DROP TABLE IF EXISTS decrit;
CREATE TABLE decrit (
    id_contenu INT NOT NULL, 
    id_genre INT NOT NULL,
    PRIMARY KEY (id_contenu, id_genre)
);

ALTER TABLE decrit
    ADD CONSTRAINT fk_decrit_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio(id_contenu);

ALTER TABLE decrit
    ADD CONSTRAINT fk_decrit_genre
    FOREIGN KEY (id_genre)
    REFERENCES genre(id_genre);

DROP TABLE IF EXISTS parle;
CREATE TABLE parle (
    id_contenu INT NOT NULL, 
    id_langage INT NOT NULL,
    PRIMARY KEY (id_contenu, id_langage)
);

ALTER TABLE parle
    ADD CONSTRAINT fk_parle_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio(id_contenu);

ALTER TABLE parle
    ADD CONSTRAINT fk_parle_langage
    FOREIGN KEY (id_langage)
    REFERENCES langage(id_langage);

DROP TABLE IF EXISTS favori;
CREATE TABLE favori (
    id_contenu INT NOT NULL, 
    id_personne INT NOT NULL,
    favori BOOLEAN NOT NULL,
    PRIMARY KEY (id_contenu, id_personne)
);

ALTER TABLE favori
    ADD CONSTRAINT fk_favori_contenu_audio
    FOREIGN KEY (id_contenu)
    REFERENCES contenu_audio (id_contenu_audio);

ALTER TABLE favori
    ADD CONSTRAINT fk_favori_utilisateur
    FOREIGN KEY (id_personne)
    REFERENCES utilisateur (id_personne);

-- TO DO? aggregations between video clip, album, playlist?