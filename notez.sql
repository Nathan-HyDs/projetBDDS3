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

create or replace function formalisePrenom(nom varchar) returns text as
	$$
	begin
		return Upper(SUBSTRING(nom from 1 for 1))||LOWER(SUBSTRING(nom from 2));
	end;
	$$ language plpgsql;


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
		RAISE WARNING 'invalid insert';
		RETURN NULL;
	END IF;

END;
$STATION$ language plpgsql;

CREATE TRIGGER STATION BEFORE INSERT ON STATION
FOR EACH ROW
EXECUTE PROCEDURE check_insert_station();

/*
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