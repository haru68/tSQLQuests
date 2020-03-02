TRUNCATE TABLE Person;

DECLARE @PeopleCount INT = 0;

WHILE @PeopleCount < 1000
	BEGIN
		INSERT INTO Person ("name", is_infected, FK_city_id)
		VALUES
		(CONCAT('Person', @PeopleCount), (SELECT FLOOR(RAND()*(1-0+1))+0), (SELECT FLOOR(RAND()*(12-1+1))+1))
		SET @PeopleCount = (@PeopleCount + 1)
	END

SELECT * FROM Person;
SELECT * FROM City;

UPDATE Person SET is_infected = 0 WHERE person_id <= ((SELECT MAX (person_id) FROM Person)/2);
UPDATE Person SET is_infected = 1 WHERE person_id > ((SELECT MAX (person_id) FROM Person)/2);

SELECT * FROM Person ORDER BY FK_city_id;


-- Si le nombre de cas d'un pays est égal au total de tous les cas par pays divisé par le nombre de pays, 
-- alors le nombre de cas par ville du pays en question est affiché


 DECLARE @CountryCount INT = 0;
 DECLARE @NumberOfInfectedPeoplePerCountry INT = 0;
 DECLARE @TotalNumberOfInfectedPeople INT = (SELECT COUNT (is_infected) FROM Person WHERE is_infected = 1);
 DECLARE @NumberOfCountries INT = (SELECT COUNT (country_id) FROM Country);

 WHILE @CountryCount <  ((SELECT MAX (country_id) FROM country) +1)
	BEGIN
		SET @NumberOfInfectedPeoplePerCountry = (SELECT COUNT (is_infected) FROM Person
		INNER JOIN City ON City.city_id = Person.FK_city_id
		INNER JOIN Country ON Country.country_id = City.FK_country_id
		WHERE Country.country_id = @CountryCount AND Person.is_infected = 1);
		
		IF (@NumberOfInfectedPeoplePerCountry >= (@TotalNumberOfInfectedPeople/@NumberOfCountries))
			BEGIN
				(SELECT COUNT (is_infected), City.name FROM Person
				INNER JOIN City ON City.city_id = Person.FK_city_id
				INNER JOIN Country ON Country.country_id = City.FK_country_id
				WHERE Country.country_id = @CountryCount AND Person.is_infected = 1
				GROUP BY City.name);
			END
			SET @NumberOfInfectedPeoplePerCountry = 0;
		SET @CountryCount = @CountryCount + 1;
	END
