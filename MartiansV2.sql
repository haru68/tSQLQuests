CREATE DATABASE MartiansV2;

CREATE TABLE Continents (
ContinentName VARCHAR(80) PRIMARY KEY);

CREATE TABLE Earthling (
id INT PRIMARY KEY IDENTITY (1,1),
EarthlingName VARCHAR(80) NOT NULL,
livingContinent VARCHAR(80),
CONSTRAINT Fk_livingEarthling FOREIGN KEY (livingContinent) REFERENCES Continents(ContinentName) ON DELETE CASCADE
);

CREATE TABLE MartiansArea (
MartianBaseName VARCHAR(80) PRIMARY KEY);

CREATE TABLE Aliens (
id INT PRIMARY KEY IDENTITY (1,1),
AlienName VARCHAR(80) NOT NULL,
MartianBase VARCHAR(80),
CONSTRAINT Fk_livingAliens FOREIGN KEY (MartianBase) REFERENCES MartiansArea(MartianBaseName) ON DELETE CASCADE,
chief INT,
CONSTRAINT Fk_AlienChief FOREIGN KEY (chief) REFERENCES Aliens(id),
CommunicateTo INT,
CONSTRAINT Fk_Communication FOREIGN KEY (CommunicateTo) REFERENCES Earthling(id)
);

INSERT INTO Continents (ContinentName)
VALUES
('Europe'),
('America'),
('Asia'),
('Oceanie'),
('Africa'), 
('Antartica');

INSERT INTO Earthling (EarthlingName, livingContinent)
VALUES
('Robert', 'Europe'),
('Donald', 'America'),
('ChingChang', 'Asia'),
('Franck', 'Oceanie'),
('Mbongo', 'Africa'),
('Abequa', 'Antartica');

INSERT INTO MartiansArea (MartianBaseName)
VALUES
('Spooka'),
('Wooka'),
('Winka'),
('Orgia'),
('Lonka');

INSERT INTO Aliens (alienName, MartianBase, chief, CommunicateTo)
VALUES
('BigBoss', 'Orgia', 1, 5),
('Loola', 'Orgia', 1, 5),
('Boora', 'Spooka', 2, 6),
('Illnia', 'Wooka', 3, 1),
('Pouloul', 'Winka', 4, 2),
('Wincha', 'Lonka', 5, 3),
('Bougadou', 'Wooka', 5, 4),
('Ougada', 'Lonka', 5, 3);

SELECT Aliens.AlienName, Earthling.EarthlingName AS RelatedHuman, Earthling.livingContinent AS HumanLivingContinent, Aliens.MartianBase AS AlienLivingBase
FROM Earthling
INNER JOIN Aliens ON Aliens.CommunicateTo = Earthling.id;