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