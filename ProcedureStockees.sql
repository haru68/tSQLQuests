
-- Nombre d'adhérents par secte manuel
DROP PROCEDURE IF EXISTS sp_MembersCountPerSect
GO

CREATE PROCEDURE sp_MembersCountPerSect
	@SectName VARCHAR(80),
	@NumberOfMembersPerSect INT OUTPUT
	AS
		SELECT COUNT (Adherent.adherent_id) FROM Adherent
		INNER JOIN SectAdherent ON SectAdherent.FK_adherent_id = Adherent.adherent_id
		INNER JOIN Sect ON Sect.sect_id = SectAdherent.FK_sect_id
		GROUP BY Sect.Name HAVING Sect.name = @SectName
	RETURN
GO

DECLARE @NumberOfPeoplePerSect INT;
EXECUTE sp_MembersCountPerSect
	@SectName = 'Le Concombre Sacré',
	@NumberOfMembersPerSect = @NumberOfPeoplePerSect OUTPUT
	PRINT CONCAT('Number of people in Le Concombre Sacré: ', @NumberOfPeoplePerSect)
GO

DECLARE @NumberOfPeoplePerSect INT;
EXECUTE sp_MembersCountPerSect
	@SectName = 'Tomatologie',
	@NumberOfMembersPerSect = @NumberOfPeoplePerSect OUTPUT
	PRINT CONCAT('Number of people in Tomatologie: ', @NumberOfPeoplePerSect)
GO

DECLARE @NumberOfPeoplePerSect INT;
EXECUTE sp_MembersCountPerSect
	@SectName = 'Les abricots volant',
	@NumberOfMembersPerSect = @NumberOfPeoplePerSect OUTPUT
	PRINT CONCAT('Number of people in les abricots volant: ', @NumberOfPeoplePerSect)
GO


-- Nombre d'adhérents par secte automatique

DROP PROCEDURE IF EXISTS sp_MembersCountPerSectAutomatically
GO

CREATE PROCEDURE sp_MembersCountPerSectAutomatically
	@NumberOfMembersPerSect INT OUTPUT
	AS
		DECLARE @SectId INT
		DECLARE Sect_Cursor CURSOR SCROLL FOR
			SELECT sect_id FROM Sect
		OPEN Sect_Cursor
		FETCH FIRST FROM Sect_Cursor INTO @SectId
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT COUNT (Adherent.adherent_id) FROM Adherent
				INNER JOIN SectAdherent ON SectAdherent.FK_adherent_id = Adherent.adherent_id
				INNER JOIN Sect ON Sect.sect_id = SectAdherent.FK_sect_id
				GROUP BY Sect.sect_id HAVING Sect.sect_id = @SectId
				FETCH NEXT FROM Sect_Cursor INTO @SectId
			END
		CLOSE Sect_Cursor
		DEALLOCATE Sect_Cursor
	RETURN
GO

DECLARE @NumberOfPeoplePerSect INT;
EXECUTE sp_MembersCountPerSectAutomatically
	@NumberOfMembersPerSect = @NumberOfPeoplePerSect OUTPUT
	PRINT @NumberOfPeoplePerSect
GO


-- Associe chacun des adhérents	à chacune des sectes automatic

DROP PROCEDURE IF EXISTS sp_AssociateMemberToSectAutomatic
GO

CREATE PROCEDURE sp_AssociateMemberToSectAutomatic
	--@MemberId INT,
	@SectName VARCHAR(80) OUTPUT
	AS
		DECLARE @Count INT = 0
		DECLARE @MemberId INT
		DECLARE Member_Cursor CURSOR SCROLL FOR
			SELECT adherent_id FROM Adherent
		OPEN Member_Cursor
		FETCH FIRST FROM Member_Cursor INTO @MemberId
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT Sect.name FROM Sect 
				INNER JOIN SectAdherent ON SectAdherent.FK_sect_id = Sect.sect_id
				INNER JOIN Adherent ON Adherent.adherent_id = SectAdherent.FK_adherent_id
				WHERE (Adherent.adherent_id = @Count)
				SET @Count = @Count + 1
				FETCH NEXT FROM Member_Cursor INTO @MemberId
			END
		CLOSE Member_Cursor
		DEALLOCATE Member_Cursor
	RETURN
GO


DECLARE @Member VARCHAR(80)
EXECUTE sp_AssociateMemberToSectAutomatic
	@SectName = @Member OUTPUT
	PRINT @Member
GO

-- Associe chacun des adhérents	à chacune des sectes manuel

DROP PROCEDURE IF EXISTS sp_AssociateMemberToSect
GO

CREATE PROCEDURE sp_AssociateMemberToSect
	@MemberId INT,
	@SectName VARCHAR(80) OUTPUT
	AS
		SELECT Sect.name FROM Sect 
		INNER JOIN SectAdherent ON SectAdherent.FK_sect_id = Sect.sect_id
		INNER JOIN Adherent ON Adherent.adherent_id = SectAdherent.FK_adherent_id
		WHERE (Adherent.adherent_id = @MemberId)
	RETURN
GO


DECLARE @MemberAssociation INT
EXECUTE sp_AssociateMemberToSect
	@MemberId = 5,
	@SectName = @MemberAssociation OUTPUT
	PRINT @MemberAssociation
GO


-- Procédure écrivant le nombre de sectes en argument de sortie

DROP PROCEDURE IF EXISTS sp_numberOfSects
GO

CREATE PROCEDURE sp_numberOfSects
	@NumberOfSects INT OUTPUT
	AS
		SELECT COUNT (Sect.sect_id) FROM Sect
	RETURN
GO

DECLARE @NumberSects INT
EXECUTE sp_numberOfSects
	@NumberOfSects = @NumberSects
	PRINT @NumberSects
GO

			