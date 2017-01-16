/*
* Question 1
*/
create or replace function averageAlti() returns numeric as
	$$
	declare
		c1 CURSOR FOR
			select AVG(s.altitude) as a
			from STATION as s;
	begin
		for resultat in c1 LOOP
			return resultat.a;
		end LOOP;
	end;
	$$ language plpgsql;	

/*
* Question 2
*/
create or replace function formalisePrenom(nom varchar) returns text as
	$$
	begin
		return Upper(SUBSTRING(nom from 1 for 1))||LOWER(SUBSTRING(nom from 2));
	end;
	$$ language plpgsql;



/*
* Question 3
*/
create or replace function formalisePrenomBase() returns setof record as
$$
	declare
		c1 CURSOR FOR
			select s.nomSkieur as nom, s.noSkieur as no
			from SKIEUR as s;
	begin
	for resultat in c1 LOOP
		update SKIEUR
		set nomSkieur=formalisePrenom(resultat.nom)
		where noSkieur=resultat.no;
	end loop;
	return;
	end;	
$$ language plpgsql;

/*
* chercher la derniers place
*/
create or replace function findLastPlace(idCompetition int) returns int as
$$
	declare
		c1 CURSOR for
			select *
			from CLASSEMENT cl
			where cl.idCompet=idCompetition
			order by cl.classement desc;
		begin
		for resultat in c1 LOOP
			return resultat.classement;
		end LOOP;
	end;
$$ language plpgsql;


/*
* chercher la place d'un skieur
*/
create or replace function searchPlace(skieur int,compet int) returns int as
$$
	declare
		c2 CURSOR for
			select cl.classement 
			from classement as cl
			where idCompet=compet and noSkieur=skieur;
		begin
		for resultat in c2 LOOP
			return resultat.classement;
		end loop;	
		end;	
$$ language plpgsql;


/*
* Swap places of skieur
*/
create or replace function decaleSkieur(skieurid int,compet int, placeADeclasser int, lastPlace int) returns int as
$$
	declare
		compteur int;
	begin

		for compteur in (placeADeclasser+1) .. lastPlace LOOP
			update classement set classement=(compteur-1) where classement=compteur and idCompet=compet;
		END LOOP;
    update classement set classement=lastPlace where noskieur=skieurid and idcompet=compet;
		return compteur;
	end;
$$ language plpgsql;

/*
* Question 4
*/
create or replace function declassement() returns setof record as 
	$$
		declare
			c CURSOR FOR
				select *
				from declassement;
			skieurPlace int;
			lastPlace int;
			nbModif int;
		begin
		for resultat in c LOOP
			skieurPlace:= searchPlace(resultat.noSkieur,resultat.idCompet);
			lastPlace:=findLastPlace(resultat.idCompet);
      RAISE INFO 'decaleSkieur(%,%,%,%);',resultat.noSkieur,resultat.idCompet,skieurPlace,lastPlace;
			nbModif:=decaleSkieur(resultat.noSkieur,resultat.idCompet,skieurPlace,lastPlace);
		end loop;
		return;
		end;	
$$ language plpgsql;


select declassement();
/*
select decaleSkieur(3,1,4,5);
select searchPlace(4,1);
select findLastPlace(1);*/
















/* exercice 5
verification des inserts de station
 */

CREATE OR REPLACE FUNCTION check_insert_station() RETURNS TRIGGER AS $STATION$

DECLARE
	good BOOLEAN;
BEGIN
	IF NEW.altitude ISNULL OR NEW.idStation ISNULL OR NEW.nomStation ISNULL OR NEW.pays ISNULL THEN
		good = FALSE ;
	ELSE
		good = new.altitude >= 0;
	END IF;

	IF good THEN
		RETURN NEW;
	ELSE
		RAISE EXCEPTION 'invalid insert in table sation';
		RETURN NULL;
	END IF;

END;
$STATION$ language plpgsql;

CREATE TRIGGER STATION BEFORE INSERT ON STATION
FOR EACH ROW
EXECUTE PROCEDURE check_insert_station();



/* exercice 6
sauvegarde des anciens nom de SKIEUR dans ANCIENNOM
 */

CREATE OR REPLACE FUNCTION save_nom() RETURNS TRIGGER AS $ANCIENNOM$

DECLARE
	exist BOOLEAN;
	c1 CURSOR FOR SELECT EXISTS(SELECT a.noSkieur FROM ANCIENNOM as a WHERE a.noSkieur=OLD.noSkieur) AS answer;
	save BOOLEAN;
BEGIN

	save=not (OLD.nomSkieur = NEW.nomSkieur);
	IF not save THEN
		RETURN NULL;
	END IF;

	exist=FALSE;
	for resultat in c1 LOOP
		IF (resultat.answer) THEN
			exist=TRUE;
		END IF;
	end LOOP;

	IF (exist) THEN
		UPDATE ANCIENNOM SET ancienNom=OLD.nomSkieur, dateChangement=now() WHERE noSkieur=OLD.noSkieur;
		RETURN OLD;
	ELSE
		INSERT INTO ANCIENNOM SELECT OLD.noSkieur, OLD.nomSkieur, now();
    RETURN OLD;
	END IF;
  RETURN NULL;
END;
$ANCIENNOM$ language plpgsql;

CREATE TRIGGER ANCIENNOM AFTER UPDATE ON SKIEUR
FOR EACH ROW
EXECUTE PROCEDURE save_nom();