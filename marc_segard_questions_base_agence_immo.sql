-- 4.1: Affichez le nom des agences
select nom as "nom de l'agence" from agence;

-- 4.2: Affichez le numéro de l’agence « Orpi »
select idAgence as "numéro de l'agence" from agence where nom="orpi";

--  4.3: Affichez le premier enregistrement de la table logement
select * from logement where idLogement=1;

--  4.4: Affichez le nombre de logements (Alias : Nombre de logements)
select count(*) as "Nombre de logements" from logement;

--  4.5: Affichez les logements à vendre à moins de 150 000 € dans l’ordre croissant des prix.
select * from logement where prix < 150000 and categorie="vente" order by prix asc;

--  4.6: Affichez le nombre de logements à la location (alias : nombre)
select count(*) as "Nombre de logement à la location" from logement where categorie="location";

--  4.7: Affichez les villes différentes recherchées par les personnes demandeuses d'un logement
select distinct ville as "villes demandées" from demande;
-- ou
select ville as "villes demandées" from demande group by ville;

--  4.8: Affichez le nombre de biens à vendre par ville
select ville, count(*) as "nombre de logements à vendre" from logement where categorie="vente" group by ville;

-- 4.9: Quelles sont les id des logements destinés à la location ?
select idLogement as "id des logements à la location" from logement where categorie="location";

-- 4.10: Quels sont les id des logements entre 20 et 30m² ?
select idLogement as "id des logements entre 20 et 30 m2" from logement where superficie>= 20 and superficie<=30;

-- 4.11: Quel est le prix vendeur (hors frais) du logement le moins cher à vendre ? (Alias : prix minimum)
select min(prix) as "prix minimum" from logement where categorie="vente";

-- 4.12: Dans quelles villes se trouve les maisons à vendre ?
select distinct ville from logement where categorie="vente";
-- ou
select ville from logement where categorie="vente" group by ville;

--  4.13: L’agence Orpi souhaite diminuer les frais qu’elle applique sur le logement ayant l'id « 3 ». Passer les frais de ce logement de 800 à 730€
-- hydratation pour test
call addNewLogementAgence(5 ,3, 800);
-- réponse
update logement_agence set frais=730 where idAgence=(select idAgence from agence where nom="orpi") and idLogement=3;

-- 4.14: Quels sont les logements gérés par l’agence « seloger »
-- hydratation pour test
call addNewLogementAgence(8 ,3, 100);
call addNewLogementAgence(8 ,7, 50);
call addNewLogementAgence(8 ,6, 1000);
-- réponse
select type, ville, prix,superficie,categorie,frais from logement 
inner join logement_agence using(idLogement)
inner join agence using(idAgence)
where idAgence=(select idAgence from agence where nom="seloger");

-- 4.15: Affichez le nombre de propriétaires dans la ville de Paris (Alias : Nombre)
select count(idPersonne) as "Nombre" from logement_personne inner join logement using(idLogement) where categorie="vente" and ville="paris";

-- 4.16: Affichez les informations des trois premières personnes souhaitant acheter un logement
-- réponse
-- right join pour être certain que les trois premiers éléments seront ceux de la table demande
select nom,prenom,email from personne right join demande using(idPersonne) where categorie="vente" limit 3;

-- 4.17: Affichez les prénoms, email des personnes souhaitant accéder à un logement en location sur la ville de Paris
select email from personne inner join demande using(idPersonne) where categorie="location" and ville="paris";

-- 4.18: Si l’ensemble des logements étaient vendus ou loués demain, quel serait le bénéfice généré grâce aux frais d’agence 
-- et pour chaque agence (Alias : bénéfice, classement : par ordre croissant des gains)
select sum(frais) as "bénéfice ", nom as "pour l'agence" from logement_agence inner join agence using(idAgence) group by idAgence order by sum(frais) asc;

-- 4.19: Affichez le prénom et la ville où se trouve le logement de chaque propriétaire
select prenom as "prénom du propriétaire", ville as "habite à" from demande inner join personne using(idPersonne) where categorie="vente" ;

-- 4.20: Affichez le nombre de logements à la vente dans la ville de recherche de « hugo » (alias : nombre)
-- hydratation pour test
call addNewPersonne('Durand', 'Hugo', 'hugo0@usda.gov');
call addNewDemande(51,"appartement","paris", 220500, 100,"vente");
-- réponse
select count(*) from demande where ville=(select ville from demande inner join personne using (idPersonne) where prenom="hugo");

-- 5 ***************************** ******************  privilèges **********************************************************
-- 5.1 créer deux utilisateurs afpa et cda
create user 'afpa'@'localhost' identified by '';
create user 'cda'@'localhost' identified by '';

-- 5.2 donner les droits d’afficher et d’ajouter des personnes et logements pour l’utilisateur afpa
grant SELECT,INSERT on agence_immo.personne to 'afpa'@'localhost';
grant SELECT,INSERT on agence_immo.logement to 'afpa'@'localhost';
-- vérifications
show grants for 'afpa'@'localhost';

-- 5.3 Donner les droits de supprimer des demandes d’achat et logements pour l’utilisateur cda
grant DELETE on agence_immo.logement to 'cda'@'localhost';
grant DELETE on agence_immo.demande to 'cda'@'localhost';
-- vérifications 
show grants for 'cda'@'localhost';

