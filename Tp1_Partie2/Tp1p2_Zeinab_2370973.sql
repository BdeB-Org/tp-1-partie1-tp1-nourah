-- Tp1 Partie 2
-- Zeinab Abdulkarim 2370973

-- question 1
-- descriptions et types
DESCRIBE outils_emprunt;
DESCRIBE outils_outil;
DESCRIBE outils_usager;

-- question 2
-- affichage pr�nom et nom
SELECT CONCAT(prenom, ' ', nom_famille) AS "Nom de l'usager"
FROM outils_usager;

--question 3
-- ville par ordre alphab�tique 
SELECT DISTINCT ville 
FROM outils_usager
ORDER BY ville;

-- question 4
-- infos outils en ordre aplhab�tique
SELECT *
FROM outils_outil
ORDER BY nom, code_outil;

-- question 5
-- affichage num�ro des emprunts qui n'ont pas �t� retourn�s
SELECT num_emprunt AS "Num�ro d'emprunt"
FROM outils_emprunt
WHERE date_retour IS NULL;

-- question 6
-- affichage num�ro d'emprunts fait avant 2014
SELECT num_emprunt AS "Num�ro de l'emprunt"
FROM outils_emprunt
WHERE date_emprunt < '2014-01-01';

-- question 7
-- affichage outils dont la couleur commence par la lettre J
SELECT code_outil AS "Code de l'outil",
       nom AS "Nom de l'outil"
FROM outils_outil
WHERE UPPER(caracteristiques) LIKE '%J%';

-- question 8
-- des outils fabriqu�s par Stanley
SELECT nom AS "Nom de l'outil", 
       code_outil AS "Code de l'outil"
FROM outils_outil
WHERE fabricant = 'Stanley';

-- question 9
-- affichage nom et fabricant des outils fabriqu�s de 2006 � 2008 
SELECT nom AS "Nom de l'outil", 
       fabricant AS "Fabricant"
FROM outils_outil
WHERE annee BETWEEN 2006 AND 2008;

-- question 10
-- afficha outils dont le nom n'est pas 20 volt
SELECT code_outil AS "Code de l'outil", 
       nom AS "Nom de l'outil"
FROM outils_outil
WHERE NOT nom = '20 volt';

-- question 11
-- affichage nombre d�outils qui n�ont pas �t� fabriqu�s par Makita
SELECT COUNT(*) AS "Nombre d'outils"
FROM outils_outil
WHERE fabricant != 'Makita';

-- question 12
-- afficage emprunts des clients de Vancouver et Regina 
-- date formater en JOUR MOIS ANN�E
SELECT CONCAT(u.prenom, ' ', u.nom_famille) AS "Nom de l'usager",
       e.num_emprunt AS "Num�ro de l'emprunt",
       TO_CHAR(e.date_emprunt, 'DD MM YYYY') AS "Date de l'emprunt",
       CASE WHEN e.date_retour IS NOT NULL THEN TO_CHAR(e.date_retour, 'DD MM YYYY') ELSE 'n a pas �t� retourn�' END AS "Date de retour",
       o.nom AS "Nom de l'outil",
       CASE WHEN o.prix IS NOT NULL THEN TO_CHAR(o.prix) ELSE 'information introuvable' END AS "Prix"
FROM outils_usager u
INNER JOIN outils_emprunt e
ON u.num_usager = e.num_usager
INNER JOIN outils_outil o 
ON e.code_outil = o.code_outil
WHERE u.ville IN ('Vancouver', 'Regina');

-- question 13
-- affichage nom et code des outils emprunt�s qui n�ont pas encore �t� retourn�s
SELECT o.nom AS "Nom de l'outil", 
       o.code_outil AS "Code de l'outil"
FROM outils_outil o
INNER JOIN outils_emprunt e 
ON o.code_outil = e.code_outil
WHERE e.date_retour IS NULL;

-- question 14
-- affichage nom et courriel des usagers qui n�ont jamais fait d�emprunts
SELECT CONCAT(prenom, ' ', nom_famille) AS "Nom de l'usager", 
              courriel AS "Courriel de l'usager"
FROM outils_usager
WHERE num_usager NOT IN (SELECT num_usager FROM outils_emprunt);

-- question 15
-- affichage code et valeur des outils qui n�ont pas �t� emprunt�s
SELECT o.code_outil AS "Code de l'outil", 
COALESCE(o.prix, 0) AS "Prix de l'outil"
FROM outils_outil o
LEFT OUTER JOIN outils_emprunt e 
ON o.code_outil = e.code_outil
WHERE e.code_outil IS NULL;

-- question 16 
-- affichage liste des outils qui sont de marque Makita et dont le prix est sup�rieur � la moyenne des prix de tous les outils
SELECT nom AS "Nom de l'outil", 
       ROUND(COALESCE(prix, avg_prix), 2) AS "Prix de l'outil"
FROM outils_outil
JOIN (SELECT AVG(prix) AS avg_prix 
FROM outils_outil) avg_table 
ON 1=1
WHERE fabricant = 'Makita' AND (prix > (SELECT AVG(prix) FROM outils_outil) OR prix IS NULL);

-- question 17 
-- affichage informations des usagers qui ont emprunt� apr�s 2014, tri� en ordre alphab�tique de nom de famille
SELECT u.nom_famille AS "Nom de famille",
       u.prenom AS "Pr�nom", 
       u.adresse AS "Adresse", 
       o.nom AS "Nom de l'outil", 
       o.code_outil AS "Code l'outil"
FROM outils_usager u
JOIN outils_emprunt e 
ON u.num_usager = e.num_usager
INNER JOIN outils_outil o 
ON e.code_outil = o.code_outil
WHERE e.date_emprunt > '2014-01-01'
ORDER BY u.nom_famille;

-- question 18
-- affichage prix et nom d'outil qui ont �t� emprunt� plus qu'une fois
SELECT o.nom AS "Nom de l'outil", 
       o.prix AS "Prix de l'outil"
FROM outils_outil o
INNER JOIN outils_emprunt e 
ON o.code_outil = e.code_outil
GROUP BY o.nom, o.prix
HAVING COUNT(e.code_outil) > 1;

-- question 19
-- affichage nom, adresse et ville de tous les usagers qui ont fait des emprunts selon m�thode : jointure , IN et EXISTS

-- jointure
SELECT u.nom_famille AS "Nom de famille",
       u.adresse AS "Adresse",
       u.ville AS "Ville"
FROM outils_usager u
INNER JOIN outils_emprunt e 
ON u.num_usager = e.num_usager;

-- IN
SELECT nom_famille AS "Nom de famille",
       adresse AS "Adresse",
       ville AS "Ville"
FROM outils_usager
WHERE num_usager IN (SELECT num_usager FROM outils_emprunt);

-- exists
SELECT nom_famille AS "Nom de famille",
       adresse AS "Adresse",
       ville AS "Ville"
FROM outils_usager u
WHERE EXISTS (SELECT 1 FROM outils_emprunt e WHERE e.num_usager = u.num_usager);


-- question 20
-- affichage moyenne du prix des outils par marque
SELECT fabricant AS "Marque",
       AVG(prix) AS "Moyenne des prix"
FROM outils_outil
GROUP BY fabricant;


-- question 21 
-- affichage somme des prix des outils emprunt�s par ville, en ordre d�croissant 
SELECT u.ville AS "Ville", 
       SUM(o.prix) AS "Somme des prix"
FROM outils_usager u
INNER JOIN outils_emprunt e 
ON u.num_usager = e.num_usager
INNER JOIN outils_outil o 
ON e.code_outil = o.code_outil
GROUP BY u.ville
ORDER BY SUM(o.prix) DESC;


-- question 22 
-- ins�ration d'un nouvel outil 
INSERT INTO outils_outil (code_outil, nom, fabricant, caracteristiques, annee, prix)
VALUES ('Code2', 'Nom2', 'Fabricant2', 'Caracteristique2', 2023, 96);


-- question 23
-- ins�ration d'un nouvel outil avec seulement code, nom et ann�e
INSERT INTO outils_outil (code_outil, nom, annee)
VALUES ('Code3', 'Nom3', 2014);

-- question 24
-- effacer les deux outils que l'on vient de cr�er
DELETE FROM outils_outil
WHERE code_outil IN ('Code2', 'Code3');

-- question 25
-- modification nom de famille des usagers en majuscules
UPDATE outils_usager
SET nom_famille = UPPER(nom_famille);



















