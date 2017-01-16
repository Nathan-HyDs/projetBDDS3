-- Q1
select nomstation, altitude from STATION;
select averagealti();

-- Q2
select formaliseprenom('luCa');

-- Q3 + Q6
select nomskieur,noskieur from skieur;
select formaliseprenombase();
select nomskieur,noskieur from skieur;

-- Q4
select s.nomskieur, d.idcompet from declassement d inner join skieur s on s.noskieur=d.noskieur;
select s.nomskieur, c.idcompet, c.classement from classement c inner join skieur s on s.noskieur=c.noskieur where c.idcompet=1 or c.idcompet=4;
SELECT declassement();
select s.nomskieur, c.idcompet, c.classement from classement c inner join skieur s on s.noskieur=c.noskieur where c.idcompet=1 or c.idcompet=4;
