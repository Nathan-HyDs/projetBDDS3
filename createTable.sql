DROP TABLE IF EXISTS DECLASSEMENT;
DROP TABLE IF EXISTS COMPORTE;
DROP TABLE IF EXISTS CLASSEMENT;
DROP TABLE IF EXISTS ANCIENNOM;
DROP TABLE IF EXISTS SKIEUR;
DROP TABLE IF EXISTS COMPETITION;
DROP TABLE IF EXISTS STATION;
DROP TABLE IF EXISTS SPECIALITE;



CREATE TABLE SPECIALITE(
	idSpecialite SERIAL,
	libelleSpecialite varchar(200),
	CONSTRAINT pk_Specialite
		PRIMARY KEY(idSpecialite)
);

CREATE TABLE STATION(
	idStation SERIAL,
	nomStation varchar(100),
	altitude INT,
	pays varchar(50),
	CONSTRAINT pk_Station
		PRIMARY KEY(idStation)
);

CREATE TABLE COMPETITION(
	idCompet SERIAL,
	libelleCompet varchar(100),
	dateComp date,
	idStation INT,
	CONSTRAINT pk_idStation
		PRIMARY KEY(idCompet),
	CONSTRAINT fk_compet_station
		 FOREIGN KEY (idStation)
		 REFERENCES STATION(idStation)
		 ON DELETE CASCADE
);

CREATE TABLE SKIEUR(
	noSkieur SERIAL,
	nomSkieur varchar(50),
	idSpecialite INT,
	idStation INT,
	 CONSTRAINT pk_Skieur
	 	PRIMARY KEY(noSkieur),
	CONSTRAINT fk_skieur_specialite
	 FOREIGN KEY (idSpecialite)
	 REFERENCES SPECIALITE(idSpecialite)
	 ON DELETE CASCADE,
	CONSTRAINT fk_skieur_station
	 FOREIGN KEY (idStation)
	 REFERENCES STATION(idStation)
	 ON DELETE CASCADE

);

CREATE TABLE CLASSEMENT(
	noSkieur INT,
	idCompet INT,
	classement INT,
	CONSTRAINT pk_Classement
		PRIMARY KEY(noSkieur,idCompet),
	CONSTRAINT fk_classement_skieur
		FOREIGN KEY (noSkieur)
		REFERENCES SKIEUR(noSkieur)
		ON DELETE CASCADE,
	CONSTRAINT fk_classement_compet
		FOREIGN KEY (idCompet)
		REFERENCES COMPETITION(idCompet)
);

CREATE TABLE COMPORTE(
	idCompet INT,
	idSpecialite INT,
	CONSTRAINT pk_Comporte
		PRIMARY KEY(idCompet,idSpecialite),
	CONSTRAINT fk_comporte_compet
		FOREIGN KEY (idCompet)
		REFERENCES COMPETITION(idCompet),
	CONSTRAINT fk_comporte_specialite
		FOREIGN KEY (idSpecialite)
		REFERENCES SPECIALITE(idSpecialite)
);

CREATE TABLE ANCIENNOM(
	noSkieur INT,
	ancienNom varchar(50),
	dateChangement date,

	CONSTRAINT pk_Anciennom
	 	PRIMARY KEY(noSkieur),
	CONSTRAINT fk_noSkieur_noSkieur
		FOREIGN KEY (noSkieur)
		REFERENCES SKIEUR(noSkieur)
);

CREATE TABLE DECLASSEMENT(
	noSkieur INT,
	idCompet INT,
	
	CONSTRAINT pk_Declassement
	 	PRIMARY KEY(noSkieur,idCompet),
	CONSTRAINT fk_declassement_skieur
		FOREIGN KEY (noSkieur)
		REFERENCES SKIEUR(noSkieur),
CONSTRAINT fk_declassement_compet
		FOREIGN KEY (idCompet)
		REFERENCES COMPETITION(idCompet)
);



insert into SPECIALITE values (default,'freestyle');
insert into SPECIALITE values (default,'descente');
insert into SPECIALITE values (default,'fond');

insert into STATION values (default,'Station A',1200,'FRANCE');
insert into STATION values (default,'Tignes',1500,'FRANCE');
insert into STATION values (default,'Station C',1700,'FRANCE');
insert into STATION values (default,'Station D',2000,'FRANCE');

insert into COMPETITION values (default,'A','2015-04-16',2);
insert into COMPETITION values (default,'B','2012-12-10',1);
insert into COMPETITION values (default,'C','2011-07-24',3);
insert into COMPETITION values (default,'D','2016-09-06',2);

insert into SKIEUR values(default,'Bob',1,1);
insert into SKIEUR values(default,'Jeremy',2,2);
insert into SKIEUR values(default,'Tom',3,3);
insert into SKIEUR values(default,'Luc',3,4);
insert into SKIEUR values(default,'Guillaume',2,2);	

insert into CLASSEMENT values(1,1,1);
insert into CLASSEMENT values(4,1,2);
insert into CLASSEMENT values(5,1,3);
insert into CLASSEMENT values(3,1,4);
insert into CLASSEMENT values(2,1,5);

insert into CLASSEMENT values(2,2,1);
insert into CLASSEMENT values(5,2,2);
insert into CLASSEMENT values(3,2,3);

insert into CLASSEMENT values(3,3,1);
insert into CLASSEMENT values(4,3,2);

insert into CLASSEMENT values(5,4,1);
insert into CLASSEMENT values(3,4,2);
insert into CLASSEMENT values(4,4,3);
insert into CLASSEMENT values(1,4,4);
insert into CLASSEMENT values(2,4,5);

insert into COMPORTE values(1,2);
insert into COMPORTE values(2,2);
insert into COMPORTE values(3,1);
insert into COMPORTE values(4,1);


insert into DECLASSEMENT values(1,1);
insert into DECLASSEMENT values(4,4);


/*
--  Nombre de skieurs ayant participé à au moins une compétition.
select count(distinct noSkieur)
from CLASSEMENT;

--  Nom de la station de chaque skieur (affichage : nom skieur + nom station)
select sk.noSkieur, st.nomStation
from skieur sk INNER JOIN station st
					ON sk.idStation=st.idStation;

--  Classement de la compétition de libellé ‘compet’ (affichage : nom skieur + classement)
select sk.nomSkieur, cl.classement
from classement cl	INNER JOIN skieur sk				
						ON cl.noSkieur=sk.noSkieur;

select co.idCompet ,sk.nomSkieur as Vainqueur
from competition co INNER JOIN Station st
						ON st.idStation=co.idStation
					INNER JOIN skieur sk
						ON sk.idStation=st.idStation
where st.nomStation like 'Tignes' and ;*/