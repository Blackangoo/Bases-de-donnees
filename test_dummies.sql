INSERT INTO personne (id_personne, nom_utilisateur, nom, prenom, mot_de_passe, adresse_email)
VALUES (1, 'utilisateur1', 'Doe', 'John', 'motdepasse123', 'john.doe@example.com'),
(2, 'utilisateur2', 'Smith', 'Alice', 'password456', 'alice.smith@example.com'),
(3, 'artiste1', 'Johnson', 'Michael', 'pass123', 'michael.johnson@example.com'),
(4, 'artiste2', 'Brown', 'Emma', 'password321', 'emma.brown@example.com');

INSERT INTO label (id_label, nom)
VALUES (1, 'Label 1'),
(2, 'Label 2');

INSERT INTO artiste (id_artiste, biographie, id_label)
VALUES (3, 'Biographie de l''artiste 1', 1),
(4, 'Biographie de l''artiste 2', 2);

INSERT INTO evenement (id_evenement, lieu, date)
VALUES (1, 'Lieu de l''événement 1', '2024-05-20'),
(2, 'Lieu de l''événement 2', '2024-06-15');

INSERT INTO abonnement (id_abonnement, prix, nom, description_abonnement)
VALUES (1, 10, 'Abonnement 1', 'Description de l''abonnement 1'),
(2, 15, 'Abonnement 2', 'Description de l''abonnement 2');

INSERT INTO utilisateur (id_utilisateur, annee_naissance, canton_residence, id_abonnement)
VALUES (1, 1990, 'VD', 1),
(2, 1985, 'GE', 2);

INSERT INTO produits_derives (id_produits_derives, description_produits, prix, link)
VALUES (1, 'Description du produit dérivé 1', 20.99, 'lien_produit1'),
(2, 'Description du produit dérivé 2', 15.50, 'lien_produit2');

INSERT INTO vente (id_artiste, id_produits_derives)
VALUES (3, 1),
(4, 2);

INSERT INTO artiste_favori (id_utilisateur, id_artiste, rating)
VALUES (1, 3, 5),
(2, 4, 4);

INSERT INTO clip_video (id_video_clip, animation, duree)
VALUES (1, TRUE, '00:03:30'),
(2, FALSE, '00:04:15');

INSERT INTO album (id_album, titre, date_de_sortie)
VALUES (1, 'Album 1', '2024-05-20'),
(2, 'Album 2', '2024-06-10');

INSERT INTO playlist (id_playlist, nom)
VALUES (1, 'Playlist 1'),
(2, 'Playlist 2');

INSERT INTO contenu_audio (id_contenu, titre, duree, date_de_sortie, paroles, id_video_clip, id_album)
VALUES (1, 'Titre du contenu audio 1', '00:03:45', '2024-05-25', 'Paroles de la chanson 1', 1, 1),
(2, 'Titre du contenu audio 2', '00:04:20', '2024-06-01', 'Paroles de la chanson 2', 2, 2);

INSERT INTO appartenance (id_contenu, id_playlist)
VALUES (1, 1),
(2, 2);

-- Test if it detects the rating greater than 5
INSERT INTO favori (id_contenu, id_utilisateur, rating, count, date_derniere_ecoute)
VALUES (1, 1, 6, 10, '2024-05-18'),
(2, 2, 5, 15, '2024-05-19');

INSERT INTO langage (id_langage, langue)
VALUES (1, 'Français'),
(2, 'Anglais');

INSERT INTO langue_utilisateur (id_utilisateur, id_langage)
VALUES (1, 1),
(2, 2);

INSERT INTO parle (id_contenu, id_langage)
VALUES (1, 1),
(2, 2);

INSERT INTO genre (id_genre, genre)
VALUES (1, 'Rock'),
(2, 'Pop');

INSERT INTO decrit (id_contenu, id_genre)
VALUES (1, 1),
(2, 2);

INSERT INTO credits (id_credits, id_artiste, id_contenu)
VALUES (1, 3, 1),
(2, 4, 2);

INSERT INTO type_artiste (id_type_artiste, type_artiste)
VALUES (1, 'Chanteur'),
(2, 'Guitariste');

INSERT INTO mentionne (id_credits, id_type_artiste)
VALUES (1, 1),
(2, 2);

INSERT INTO participation (id_artiste, id_evenement)
VALUES (3, 1),
(4, 2);

DELETE FROM artiste
WHERE id_artiste = 3;