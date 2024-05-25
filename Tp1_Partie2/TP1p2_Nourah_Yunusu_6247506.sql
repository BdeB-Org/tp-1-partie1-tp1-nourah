-- 1.   R�digez la requ�te qui affiche la description pour les trois tables. Le nom des champs et leur type. 
DESC OUTILS_OUTIL;
DESC outils_emprunt;
DESC outils_usager;
-- 2.   R�digez la requ�te qui affiche la liste de tous les usagers, sous le format pr�nom � espace � nom de famille (indice : concat�nation).
SELECT CONCAT(prenom,'', nom_famille) AS "prenom et nom de famille"
from outils_usager;
-- 3.  R�digez la requ�te qui affiche le nom des villes o� habitent les usagers, en ordre alphab�tique, le nom des villes va appara�tre seulement une seule fois.
SELECT distinct ville AS ville 
from outils_usager
order by ville;
-- 4.   R�digez la requ�te qui affiche toutes les informations sur tous les outils en ordre alphab�tique sur le nom de l�outil puis sur le code. 
SELECT code_outil,
       nom,
       fabricant,
       caracteristiques,
       annee,
       NVL(prix, '0') AS prix
FROM outils_outil
ORDER BY nom, code_outil;

  
-- 5.   R�digez la requ�te qui affiche le num�ro des emprunts qui n�ont pas �t� retourn�s. 
SELECT num_emprunt AS "numero emprunte"
FROM outils_emprunt
WHERE date_retour IS NULL;


-- 6.   R�digez la requ�te qui affiche le num�ro des emprunts faits avant 2014.

SELECT num_emprunt AS "numero emprunte"
FROM outils_emprunt
WHERE date_emprunt < to_date('2014-01-01','YYYY-MM-DD');
-- 7.   R�digez la requ�te qui affiche le nom et le code des outils dont la couleur d�but par la lettre � j � (indice : utiliser UPPER() et LIKE)
SELECT nom,
       code_outil AS "code outil",
       caracteristiques
       FROM outils_outil
       WHERE UPPER(caracteristiques) like '%J%' ;

-- 8.   R�digez la requ�te qui affiche le nom et le code des outils fabriqu�s par Stanley.

SELECT nom,
    code_outil AS "code outil"
   
FROM outils_outil
WHERE fabricant like 'Stanley';
   
-- 9.   R�digez la requ�te qui affiche le nom et le fabricant des outils fabriqu�s de 2006 � 2008 (ANNEE). 
SELECT nom,
        fabricant
FROM outils_outil
WHERE annee BETWEEN 2006 AND 2008;
        
-- 10.  R�digez la requ�te qui affiche le code et le nom des outils qui ne sont pas de � 20 volts �. 
SELECT code_outil,
       nom,
       caracteristiques
 FROM outils_outil
WHERE caracteristiques not like '%20 volt%';

-- 11.  R�digez la requ�te qui affiche le nombre d�outils qui n�ont pas �t� fabriqu�s par Makita. 
Select Count(fabricant) AS "nombre d'outils par fabriquer par Makita"
FROM outils_outil
WHERE fabricant not like 'Makita';
-- 12.  R�digez la requ�te qui affiche les emprunts des clients de Vancouver et Regina.--
--Il faut afficher le nom complet de l�usager, le num�ro d�emprunt, la dur�e de l�emprunt--
--et le prix de l�outil (indice : n�oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
SELECT CONCAT(u.prenom, ' ', u.nom_famille) AS "nom complet de l�usager",
       e.num_emprunt AS "num�ro d'emprunt",
       NVL(e.date_retour - e.date_emprunt, '0') AS "dur�e de l�emprunt",
       NVL(o.prix, 0) AS "prix de l�outil"
FROM outils_usager u
JOIN outils_emprunt e ON u.num_usager = e.num_usager
JOIN outils_outil o ON o.code_outil = e.code_outil
WHERE u.ville IN ('Vancouver', 'Regina');

-- 13.  R�digez la requ�te qui affiche le nom et le code des outils emprunt�s qui n�ont pas encore �t� retourn�s.
SELECT o.nom AS "nom de l'outil", 
       o.code_outil
FROM outils_outil o
JOIN outils_emprunt e ON o.code_outil = e.code_outil
WHERE e.date_retour IS NULL;

-- 14.  R�digez la requ�te qui affiche le nom et le courriel des usagers qui n�ont jamais fait d�emprunts. (indice : IN avec sous-requ�te) 

SELECT nom_famille AS "nom famille", 
       courriel
       
FROM outils_usager
WHERE num_usager NOT IN (
    SELECT  num_usager
    FROM outils_emprunt);



-- 15.  R�digez la requ�te qui affiche le code et la valeur des outils qui n�ont pas �t� emprunt�s. --
--(indice : utiliser une jointure externe � LEFT OUTER, aucun NULL dans les nombres)

SELECT o.code_outil AS "code outil",
       nvl(o.prix, 0) AS "prix de l�outil"
FROM outils_outil o
LEFT JOIN outils_emprunt e 
ON o.code_outil = e.code_outil
WHERE e.code_outil IS NULL;

        

-- 16.  R�digez la requ�te qui affiche la liste des outils (nom et prix) --
-- qui sont de marque Makita et dont le prix est sup�rieur � la moyenne des prix de tous les outils.--
--Remplacer les valeurs absentes par la moyenne de tous les autres outils.

SELECT nom, 
       NVL(prix, (SELECT AVG(prix) FROM outils_outil)) AS "prix"
FROM outils_outil
WHERE fabricant LIKE 'Makita'
AND prix > (SELECT AVG(prix) FROM outils_outil);

-- 17.  R�digez la requ�te qui affiche le nom, le pr�nom et l�adresse des usagers et le nom --
-- et le code des outils qu�ils ont emprunt�s apr�s 2014. Tri�s par nom de famille. 
SELECT u.nom_famille,
       u.prenom,
       u.adresse,
       e.code_outil,
       o.nom
       
FROM outils_usager u
JOIN outils_emprunt e ON e.num_usager = u.num_usager
JOIN outils_outil o ON e.code_outil = o.code_outil 
WHERE o.annee < 2014
GROUP BY u.nom_famille, u.prenom, u.adresse, e.code_outil, o.nom;


-- 18.  R�digez la requ�te qui affiche le nom et le prix des outils qui ont �t� emprunt�s plus qu�une fois. /4
SELECT o.nom, 
       o.prix
FROM outils_outil o
JOIN outils_emprunt e ON o.code_outil = e.code_outil
GROUP BY o.code_outil, o.nom, o.prix
HAVING COUNT(*) > 1;



-- 19.  R�digez la requ�te qui affiche le nom, l�adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : 
--  Une jointure
--  IN
--  EXISTS
      
       

-- 20.  R�digez la requ�te qui affiche la moyenne du prix des outils par marque. 
SELECT fabricant,
       AVG(prix)AS "prix moyen des outils par marque"   
FROM outils_outil
GROUP BY fabricant;

-- 21.  R�digez la requ�te qui affiche la somme des prix des outils emprunt�s par ville, en ordre d�croissant de valeur. 
SELECT u.ville,
       SUM(o.prix) AS "somme des prix des outils empruntes"
FROM outils_usager u
JOIN outils_emprunt e 
ON u.num_usager = e.num_usager
JOIN outils_outil o
ON e.code_outil = o.code_outil
GROUP BY u.ville
ORDER BY  SUM(o.prix) DESC;

-- 22.  R�digez la requ�te pour ins�rer un nouvel outil en donnant une valeur pour chacun des attributs. 

INSERT INTO outils_outil (code_outil, nom, fabricant, caracteristiques, annee, prix) VALUES ('NY0507','marteau','3M','grand','2010','100');

-- 23.  R�digez la requ�te pour ins�rer un nouvel outil en indiquant seulement son nom, son code et son ann�e. 

INSERT INTO outils_outil (code_outil, nom, annee) VALUES ('NY0508', 'scie', '2012');

-- 24.  R�digez la requ�te pour effacer les deux outils que vous venez d�ins�rer dans la table. 

DELETE FROM outils_outil WHERE code_outil IN ('NY0507', 'NY0508');

-- 25.  R�digez la requ�te pour modifier le nom de famille des usagers afin qu�ils soient tous en majuscules. 
UPDATE outils_usager
SET nom_famille = UPPER(nom_famille);











