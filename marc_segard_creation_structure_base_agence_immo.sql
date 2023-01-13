-- ************************ Note from cahier des charges ******************************************************

-- base de données de vente/location immobilier

-- table logement:  type,ville,prix,superficie,categorie(vente/location)
-- table agence: nom, adresse

-- table association logement_agence ( avec frais honoraire) : foreign key vers logement, foreign key vers agence, frais_honoraire

-- table personne:  nom, prenom, mail(doit être valide

-- table association logement_personne : foreign key vers personne, foreign key vers logement

-- table demande : voir exemple table

create or replace  database agence_immo;
use agence_immo;

--  1 **************************** Création structure de la base de données ****************************************

-- création table agence
create or replace table agence(idAgence int(6) zerofill auto_increment primary key, nom varchar(255), adresse varchar(255));
-- création de la table logement
create or replace  table logement(idLogement int(5) zerofill auto_increment primary key, type varchar(12), ville varchar(255), prix float, superficie int, categorie varchar(10));
-- création de la table personne
create or replace table personne(idPersonne int auto_increment primary key,nom varchar(255), prenom varchar(255), email varchar(255));
-- création de la table demande
create or replace table demande (idDemande int auto_increment primary key, idPersonne int not null, type varchar(12), ville varchar(255), budget float, superficie int, categorie varchar(10));
-- création de la table association logement_agence
create or replace table logement_agence (idLogementAgence int auto_increment primary key,idAgence int(6) zerofill not null , idLogement int(5) zerofill not null, frais float);
-- création de la table association logement_personne
create or replace  table logement_personne (idLogementPersonne int auto_increment primary key,idPersonne int not null , idLogement int(5) zerofill not null);

-- création de la clé étrangère entre la table demande et personne
alter table demande add constraint fk_demande_personne foreign key (idPersonne) references personne(idPersonne);
-- création de la clé étrangère entre la table logement_agence et la table agence
alter table logement_agence add constraint fk_logement_agence_agence foreign key (idAgence) references agence(idAgence);
-- création de la clé étrangère entre la table logement_agence et la table logement
alter table logement_agence add constraint fk_logement_agence_logement foreign key (idLogement) references logement(idLogement);
-- création de la clé étrangère entre la table logement_personne et la table personne
alter table logement_personne add constraint fk_logement_personne_personne foreign key (idPersonne) references personne(idPersonne);
-- création de la clé étrangère entre la table logement_personne et la table logement
alter table logement_personne add constraint fk_logement_personne_logement foreign key (idLogement) references logement(idLogement);

-- 2 *************************    creation du trigger ******************************************************
-- trigger vérifier si l'email est valide avant l'ajout dans la table personne
delimiter \\
create or replace trigger verifEmail 
before insert on personne 
for each row
	if new.email not rlike ('^[A-Za-z0-9][A-Za-z0-9.-_]+[A-Za-z0-9][@][A-Za-z0-9][A-Za-z0-9.-_]+[A-Za-z0-9]?[.][A-Za-z0-9]{2,3}$')
		then  
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Vérifier la synthaxe de l'email";
	end if
\\
delimiter ;

-- 3.1 ************************** creation des procédures stockées. ****************************************
-- procédure stockée pour hydrater la table agence
delimiter \\
create or replace procedure addNewAgence(IN nom varchar(255), adresse varchar(255))
begin
insert into agence (nom,adresse) values (nom,adresse);
end\\
delimiter ;
-- procédure stockée pour hydrater la table personne
delimiter \\
create or replace procedure addNewPersonne(IN nom varchar(255), prenom varchar(255), email varchar(255))
begin
insert into personne (nom,prenom,email) values (nom,prenom,email);
end\\
delimiter ;
-- procédure stockée pour hydrater la table logement
delimiter \\
create or replace procedure addNewLogement(IN type varchar(12), ville varchar(255), prix float, superficie int, categorie varchar(10))
begin
insert into logement (type,ville,prix,superficie,categorie) values (type,ville,prix,superficie,categorie);
end\\
delimiter ;
-- procédure stockée pour hydrater demande 
-- on peut remplacer idPersonne par le nom de la personne en ajoutant une instruction
-- pour aller récupérer l'idPersonne en fonction du nom
-- select id from personne where nom=in_nom
delimiter \\
create or replace procedure addNewDemande(IN idPersonne int, type varchar(12), ville varchar(255), budget float, superficie int, categorie varchar(10))
begin
insert into demande (idPersonne, type, ville, budget, superficie, categorie) values (idPersonne,type, ville, budget, superficie, categorie);
end\\
delimiter ;
-- procédure stockée pour hydrater la table logement_agence
delimiter \\
create or replace procedure addNewLogementAgence(IN idAgence int  , idLogement int, frais float)
begin
insert into logement_agence (idAgence, idLogement,frais) values (idAgence,idLogement, frais);
end\\
delimiter ;
-- procédure stockée pour hydrater la table logement_personne
delimiter \\
create or replace procedure addNewLogementPersonne(IN idPersonne int  , idLogement int)
begin
insert into logement_personne (idPersonne, idLogement) values (idPersonne,idLogement);
end\\
delimiter ;

-- 3.2 *****************. hydratation des tables avec les procédures stockées crées plus haut
-- hydratation table agence
call addNewAgence("logic-immo","www.logic-immo.com");
call addNewAgence("century21","rue century");
call addNewAgence("laforet","rue laforet");
call addNewAgence("fnaim","rue fnaim");
call addNewAgence("orpi","rue orpi");
call addNewAgence("foncia","rue foncia");
call addNewAgence("guy-hoquet","rue guy-hoquet");
call addNewAgence("seloger","www.seloger.com");
call addNewAgence("bouygues immobilier","www.bouygues-immobilier.net");
-- hydratation table logement
call addNewLogement("appartement","paris", 185000, 61,"vente");
call addNewLogement("appartement","paris", 115000, 15,"vente");
call addNewLogement("maison","paris", 510000, 130,"vente");
call addNewLogement("appartement","bordeaux", 550, 17,"location");
call addNewLogement("appartement","lyon", 420, 14,"location");
call addNewLogement("appartement","paris", 160000, 40,"vente");
call addNewLogement("appartement","paris", 670, 35,"location");
call addNewLogement("appartement","lyon", 110000, 16,"vente");
call addNewLogement("appartement","bordeaux", 161500, 33,"vente");
call addNewLogement("appartement","paris", 202000, 90,"vente");
-- hydratation table logement_agence
call addNewLogementAgence(1 , 2, 15000);
-- hydratatiob table personne
call addNewPersonne('Steffan', 'Linnie', 'lsteffan0@usda.gov');
call addNewPersonne('Delf', 'Cirstoforo', 'cdelf1@ycombinator.com');
call addNewPersonne('Braunton', 'Happy', 'hbraunton2@mozilla.org');
call addNewPersonne('Hutcheson', 'Cathlene', 'chutcheson3@netvibes.com');
call addNewPersonne('Ottam', 'Rachael', 'rottam4@taobao.com');
call addNewPersonne('Willshaw', 'Allison', 'awillshaw5@godaddy.com');
call addNewPersonne('Worner', 'Emelda', 'eworner6@blinklist.com');
call addNewPersonne('Douthwaite', 'Holt', 'hdouthwaite7@vinaora.com');
call addNewPersonne('Willder', 'Liesa', 'lwillder8@examiner.com');
call addNewPersonne('Casol', 'Glendon', 'gcasol9@time.com');
call addNewPersonne('Rowly', 'Clair', 'crowlya@gov.uk');
call addNewPersonne('Heindrick', 'Norrie', 'nheindrickb@theguardian.com');
call addNewPersonne('Lechelle', 'Martha', 'mlechellec@spiegel.de');
call addNewPersonne('Probets', 'Kane', 'kprobetsd@reference.com');
call addNewPersonne('Gorry', 'Kaitlin', 'kgorrye@un.org');
call addNewPersonne('Riatt', 'Marcella', 'mriattf@independent.co.uk');
call addNewPersonne('Paulin', 'Killian', 'kpauling@foxnews.com');
call addNewPersonne('Abad', 'Herbert', 'habadh@histats.com');
call addNewPersonne('Ilyasov', 'Lauralee', 'lilyasovi@telegraph.co.uk');
call addNewPersonne('Twitty', 'Hortensia', 'htwittyj@google.com');
call addNewPersonne('Davoren', 'Izak', 'idavorenk@cnet.com');
call addNewPersonne('Gillard', 'Wendall', 'wgillardl@friendfeed.com');
call addNewPersonne('Hustler', 'Beilul', 'bhustlerm@zimbio.com');
call addNewPersonne('Snelgrove', 'Nickey', 'nsnelgroven@jalbum.net');
call addNewPersonne('Dumbar', 'Webster', 'wdumbaro@amazon.co.jp');
call addNewPersonne('Brik', 'Gabi', 'gbrikp@timesonline.co.uk');
call addNewPersonne('Shambrook', 'Anette', 'ashambrookq@tripod.com');
call addNewPersonne('Aplin', 'Orlando', 'oaplinr@biglobe.ne.jp');
call addNewPersonne('Gaylard', 'Thedrick', 'tgaylards@alexa.com');
call addNewPersonne('Bonin', 'Zeke', 'zbonint@wikipedia.org');
call addNewPersonne('Burtt', 'Abba', 'aburttu@nature.com');
call addNewPersonne('Francescuccio', 'Zonda', 'zfrancescucciov@google.it');
call addNewPersonne('Rodear', 'Joletta', 'jrodearw@etsy.com');
call addNewPersonne('McCaughan', 'Artie', 'amccaughanx@blogger.com');
call addNewPersonne('O''Shesnan', 'Clayborn', 'coshesnany@jugem.jp');
call addNewPersonne('Mattheissen', 'Dana', 'dmattheissenz@imdb.com');
call addNewPersonne('Beades', 'Giffer', 'gbeades10@jalbum.net');
call addNewPersonne('Meneer', 'Billye', 'bmeneer11@berkeley.edu');
call addNewPersonne('Daniellot', 'Gasper', 'gdaniellot12@yolasite.com');
call addNewPersonne('Braisher', 'Pooh', 'pbraisher13@usa.gov');
call addNewPersonne('Aldwich', 'Emelita', 'ealdwich14@devhub.com');
call addNewPersonne('Horsey', 'Jonis', 'jhorsey15@foxnews.com');
call addNewPersonne('Spatari', 'Jaquelin', 'jspatari16@altervista.org');
call addNewPersonne('Devenport', 'Maurizio', 'mdevenport17@examiner.com');
call addNewPersonne('Hammer', 'Bernice', 'bhammer18@bloglines.com');
call addNewPersonne('Hammett', 'Shandra', 'shammett19@pen.io');
call addNewPersonne('Claringbold', 'Munmro', 'mclaringbold1a@utexas.edu');
call addNewPersonne('Boatman', 'Lindy', 'lboatman1b@businessweek.com');
call addNewPersonne('Smithers', 'Sheffie', 'ssmithers1c@instagram.com');
call addNewPersonne('Pavolillo', 'Marysa', 'mpavolillo1d@zimbio.com');
-- hydratation de la table demande
call addNewDemande(1,"appartement","paris", 530000, 120,"vente");
call addNewDemande(3,"appartement","bordeaux", 120000, 18,"vente");
call addNewDemande(4,"appartement","bordeaux", 145000, 21,"vente");
call addNewDemande(5,"appartement","bordeaux", 152000, 26,"vente");
call addNewDemande(6,"appartement","lyon", 200000, 55,"vente");
call addNewDemande(9,"appartement","paris", 171000, 40,"vente");
call addNewDemande(13,"appartement","paris", 163000, 25,"vente");
call addNewDemande(16,"appartement","paris", 132000, 15,"vente");
call addNewDemande(19,"appartement","paris", 350000, 80,"vente");
call addNewDemande(22,"appartement","lyon", 600, 20,"location");
call addNewDemande(25,"appartement","lyon", 188000, 65,"vente");
call addNewDemande(27,"appartement","paris", 400, 15,"location");
call addNewDemande(28,"appartement","paris", 330500, 100,"vente");
call addNewDemande(31,"appartement","paris", 90000, 15,"vente");
call addNewDemande(32,"appartement","lyon", 123800, 21,"vente");
call addNewDemande(35,"appartement","lyon", 1200, 70,"vente");
call addNewDemande(37,"appartement","lyon", 1500, 100,"vente");
call addNewDemande(43,"appartement","paris", 600, 20,"location");
call addNewDemande(44,"appartement","paris", 750, 30,"location");
call addNewDemande(45,"appartement","bordeaux", 680, 30,"location");
call addNewDemande(46,"appartement","bordeaux", 213000, 40,"vente");
-- hydratation de la table logment_personne
call addNewLogementPersonne(1,1);
call addNewLogementPersonne(3,2);
call addNewLogementPersonne(4,3);
call addNewLogementPersonne(5,4);
call addNewLogementPersonne(6,5);
call addNewLogementPersonne(9,6);
call addNewLogementPersonne(2,7);
call addNewLogementPersonne(7,8);
call addNewLogementPersonne(8,9);
call addNewLogementPersonne(10,10);








