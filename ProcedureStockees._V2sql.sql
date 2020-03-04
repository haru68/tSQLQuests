USE SectTracking
GO

-- Nombre d'adhérents par secte

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



-- Associe chaque adhérent à chaque secte
DROP PROCEDURE IF EXISTS sp_AssociateEachMemberToEachSect
GO

CREATE PROCEDURE sp_AssociateEachMemberToEachSect
	AS
	TRUNCATE TABLE SectAdherent
	
	DECLARE @SectID INT
	DECLARE @MemberID INT
	DECLARE Sect_Cursor CURSOR SCROLL FOR
		SELECT Sect.sect_id FROM Sect
	DECLARE Member_Cursor CURSOR SCROLL FOR
		SELECT Adherent.adherent_id FROM Adherent
	OPEN Sect_Cursor
	OPEN Member_Cursor
	FETCH FIRST FROM Sect_Cursor INTO @SectID
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		FETCH FIRST FROM Member_Cursor INTO @MemberID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO SectAdherent (FK_adherent_id, FK_sect_id)
			VALUES	(@MemberID, @SectID)
			FETCH NEXT FROM Member_Cursor INTO @MemberID
		END

		FETCH NEXT FROM Sect_Cursor INTO @SectID
	END
	
	CLOSE Sect_Cursor
	CLOSE Member_Cursor
	DEALLOCATE Sect_Cursor
	DEALLOCATE Member_Cursor
GO


DECLARE @MemberAssociation INT
EXECUTE sp_AssociateEachMemberToEachSect
GO

SELECT * FROM SectAdherent

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

			