-- Q1
select nomstation, altitude from STATION;
select averagealti();

-- Q2
select formaliseprenom('luCa');

-- Q3 + Q6
select nomskieur,noskieur from skieur;
SELECT * FROM ANCIENNOM;
select formaliseprenombase();
SELECT * FROM ANCIENNOM;
select nomskieur,noskieur from skieur;

-- Q4
select s.nomskieur, d.idcompet from declassement d inner join skieur s on s.noskieur=d.noskieur;
select s.nomskieur, c.idcompet, c.classement from classement c inner join skieur s on s.noskieur=c.noskieur where c.idcompet=1 or c.idcompet=4;
SELECT declassement();
select s.nomskieur, c.idcompet, c.classement from classement c inner join skieur s on s.noskieur=c.noskieur where c.idcompet=1 or c.idcompet=4;

-- Guillaume
/*
exercie 5
 */
SELECT * FROM STATION;
INSERT INTO STATION VALUES (default,'NEW1',-1,'FRANCE');
INSERT INTO STATION VALUES (default,'NEW2',100, NULL);
INSERT INTO STATION VALUES (default,'NEW3',1025,'FRANCE');
SELECT * FROM STATION;


/*
exercice 6
 */
SELECT * FROM ANCIENNOM;
SELECT * FROM SKIEUR;
/* cet insert doit deja etre realisé
insert into SKIEUR values(default,'Guillaume',2,2);
 */
UPDATE SKIEUR SET nomSkieur='Guillaume2' WHERE nomSkieur LIKE 'Guillaume';
SELECT * FROM ANCIENNOM;
SELECT * FROM SKIEUR;
UPDATE SKIEUR SET nomSkieur='Guillaume3' WHERE nomSkieur LIKE 'Guillaume2';
SELECT * FROM ANCIENNOM;
SELECT * FROM SKIEUR;