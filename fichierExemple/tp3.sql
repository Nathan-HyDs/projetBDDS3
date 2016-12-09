create or replace function nomprenom(nom varchar, prenom varchar) returns text as
		$$
		declare
			prenomAlter varchar;
			nomAlter varchar;
			nomPrenom text;
		begin
		nomAlter:=Upper(nom);
		prenomAlter:=Upper(SUBSTRING(prenom from 1 for 1))||LOWER(SUBSTRING(prenom from 2));
		nomPrenom:=nomAlter||' '||prenomAlter;
		return nomPrenom;

		end;
		$$ language plpgsql;

create or replace function fun2(valeur numeric,nbannees int) returns numeric as
	$$
	declare
		val numeric;
	begin
	val:=valeur;
	if nbannees>5 and nbannees<21 then
		val:=valeur/100*10+valeur;
		if nbannees>9 then
			val:=valeur/100*10+valeur;
		end if;
	end if;
	return val;
end
$$language plpgsql;


create or replace function fun3(sommeOrigine numeric,tauxAnnuel numeric, nbannees int)
	returns numeric as
	$$
	declare
		newSomme int;
		k int;
	begin
		newSomme=sommeOrigine;
		newSomme=sommeOrigine;
		FOR	k in 1..nbannees LOOP
			newSomme:=newSomme+newSomme*tauxAnnuel;
		END LOOP;
		return newSomme;
	end;
	$$ language plpgsql;