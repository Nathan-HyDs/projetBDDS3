

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