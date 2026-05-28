/*
================================================================================
SCRIPT: Bulk Insert/Update Crews PT. UDAYANA PUTRA 2026
PURPOSE: Insert 10 AMT crew members with complete FK mapping
         - UPDATE existing records by NAME (fill empty columns only)
         - INSERT new records if not found by name
AUTHOR: nurihsanhusein
DATE: 2026-05-28
================================================================================
*/

BEGIN TRANSACTION;

BEGIN TRY

-- ============================================================================
-- 1. DECLARE VARIABLES & LOOKUP TABLES
-- ============================================================================

DECLARE @OriginWorkingUnitId INT;
DECLARE @OriginSupplyPointId INT;
DECLARE @PlacementWorkingUnitId INT;
DECLARE @PlacementSupplyPointId INT;
DECLARE @CurrentVendorId INT;
DECLARE @GenderId INT;
DECLARE @EducationId INT;
DECLARE @NationalityId INT;
DECLARE @BloodTypeId INT;
DECLARE @ReligionId INT;
DECLARE @MaritalStatusId INT;
DECLARE @ResidencyStatusId INT;
DECLARE @JobTitleId INT;
DECLARE @OriginBusinessTypeId INT;
DECLARE @OriginTariffSchemeId INT;
DECLARE @OriginBusinessSchemeId INT;
DECLARE @PlacementTariffSchemeId INT;
DECLARE @OperationalStatusId INT;
DECLARE @HealthInsuranceStatusId INT;
DECLARE @ShipmentStatusId INT;
DECLARE @McuResultId INT;
DECLARE @TankCapacityId INT;

-- ============================================================================
-- 2. LOOKUP MASTER DATA FROM EXISTING TABLES
-- ============================================================================

-- Locations Lookup
SELECT @OriginWorkingUnitId = ID FROM [dbo].[Locations] WHERE Code = 'MOR05'; -- JATIMBALINUS
SELECT @OriginSupplyPointId = ID FROM [dbo].[Locations] WHERE Code = '1310'; -- IT AMPENAN
SELECT @PlacementWorkingUnitId = ID FROM [dbo].[Locations] WHERE Code = 'MOR05'; -- JATIMBALINUS
SELECT @PlacementSupplyPointId = ID FROM [dbo].[Locations] WHERE Code = '1310'; -- IT AMPENAN

-- Accounts Lookup
SELECT @CurrentVendorId = ID FROM [dbo].[Accounts] WHERE Name = 'PT. UDAYANA PUTRA';

-- Categories Lookup
SELECT @GenderId = ID FROM [dbo].[Categories] WHERE Code = 'male'; -- MALE
SELECT @EducationId = ID FROM [dbo].[Categories] WHERE Code = 'sma'; -- SMA/Sederajat
SELECT @NationalityId = ID FROM [dbo].[Categories] WHERE Code = 'WNI'; -- WNI
SELECT @ResidencyStatusId = ID FROM [dbo].[Categories] WHERE Code = 'residenStat04'; -- KONTRAK
SELECT @JobTitleId = ID FROM [dbo].[Categories] WHERE Code = 'AMT01'; -- AMT 1
SELECT @OriginBusinessTypeId = ID FROM [dbo].[Categories] WHERE Code = 'BT001'; -- TRANSPORTIR
SELECT @OriginTariffSchemeId = ID FROM [dbo].[Categories] WHERE Code = 'TF003'; -- MT TRANSPORTIR BUNKER INDUSTRI (Pola Tarif)
SELECT @OriginBusinessSchemeId = ID FROM [dbo].[Categories] WHERE Code = 'BS004'; -- MT TRANSPORTIR POLA TARIF
SELECT @PlacementTariffSchemeId = ID FROM [dbo].[Categories] WHERE Code = 'TF003'; -- Pola Tarif
SELECT @OperationalStatusId = ID FROM [dbo].[Categories] WHERE Code = 'PS001'; -- OPERASIONAL
SELECT @HealthInsuranceStatusId = ID FROM [dbo].[Categories] WHERE Code = 'INS01'; -- AKTIF
SELECT @ShipmentStatusId = ID FROM [dbo].[Categories] WHERE Code = 'SH001'; -- TERSEDIA
SELECT @McuResultId = ID FROM [dbo].[Categories] WHERE Code = 'active-amt-justifikasi03'; -- SUDAH LOLOS MCU
SELECT @TankCapacityId = ID FROM [dbo].[Categories] WHERE Code = 'TNC10'; -- 10 KL

-- ============================================================================
-- 3. MERGE STATEMENT - UPSERT WITH SELECTIVE UPDATE
-- ============================================================================

MERGE INTO [dbo].[Crews] AS TARGET
USING (
	SELECT 
		'ABDUL GAPUR' AS Name,
		'e8g9zh8p7d' AS Code,
		113 AS GenderId,
		NULL AS TypeId,
		NULL AS BloodTypeId,
		NULL AS MaritalStatusId,
		NULL AS NationalityId,
		NULL AS EducationId,
		NULL AS ReligionId,
		CAST('1984-11-05' AS DATETIME) AS BirthDate,
		'LEONG' AS BirthPlace,
		156.5 AS Height,
		72.5 AS Weight,
		'MULYANI' AS SpouseName,
		'TIDAK ADA' AS MedicalHistory,
		'0' AS FingerprintCode,
		NULL AS Picture,
		'L' AS PpeShirtSize,
		'L' AS PpePantsSize,
		40 AS PpeShoeSize,
		1 AS ServicePeriodYear,
		0 AS ServicePeriodMonth,
		0 AS ServicePeriodDay,
		'5201120107890190' AS IdCardNumber,
		NULL AS IdCardValidSince,
		NULL AS TaxIdNumber,
		NULL AS HealthInsuranceNumber,
		NULL AS LaborInsuranceNumber,
		NULL AS BankAccountNumber,
		'087863668101' AS PhoneMobile,
		NULL AS PhoneHome,
		'DUSUN LEONG RT.000 RW.000 GIRI MADIA, KEC. LINGSAR KABUPATEN LOMBOK BARAT' AS ResidencyAddress,
		CAST('2026-05-28' AS DATETIME) AS JobStartDate,
		'0501/RSM/MCU/XII/2024' AS McuDocumentNum,
		CAST('2024-12-12' AS DATETIME) AS McuDocumentDate,
		'RSI SITI HAJAR MATARAM' AS McuLocation,
		'545581' AS McuMedicalRecordNum,
		'P5' AS McuHealthDegree,
		'SUDAH MELAKUKAN MCU' AS McuRemarks,
		'APPROVED' AS Status
	UNION ALL
	SELECT 'ANDI ANDREAS WUA', 'k57eoy2fbi', 113, NULL, NULL, NULL, NULL, NULL, NULL, CAST('1988-05-16' AS DATETIME), 'MANGGARAI', 161, 77.5, 'DOMICA BENI', 'TIDAK ADA', '0', NULL, 'XL', 'XL', 42, 1, 0, 0, '5310011605880004', NULL, NULL, NULL, NULL, NULL, '085942879368', NULL, 'JL. GOTONG ROYONG TEMPIT RT. 001 RW. 012 AMPENAN TENGAH, AMPENAN, KOTA MATARAM', CAST('2026-05-28' AS DATETIME), '0500/RSM/MCU/XII/2024', CAST('2024-12-12' AS DATETIME), 'RSI SITI HAJAR MATARAM', '545584', 'P5', 'SUDAH MELAKUKAN MCU', 'APPROVED'
	UNION ALL
	SELECT 'BIN BASRI', '8srujzuxtn', 113, NULL, NULL, NULL, NULL, NULL, NULL, CAST('1999-06-05' AS DATETIME), 'PALIS', 167.5, 60.3, NULL, 'TIDAK ADA', '0', NULL, 'L', 'L', 42, 1, 0, 0, '531503050699003', NULL, NULL, NULL, NULL, NULL, '081339815977', NULL, 'PALIS RT. 009 RW. 000 NANGA LILI LEMBOR SELATAN KABUPATEN MANGGARAI BARAT', CAST('2026-05-28' AS DATETIME), '0499/RSM/MCU/XII/2024', CAST('2024-12-12' AS DATETIME), 'RSI SITI HAJAR MATARAM', '545580', 'P5', 'SUDAH MELAKUKAN MCU', 'APPROVED'
	UNION ALL
	SELECT 'DARMAWAN EDI KAPUTRADI', 'acbtdenhwy', 113, NULL, NULL, NULL, NULL, NULL, NULL, CAST('1993-01-27' AS DATETIME), 'PEMEPEK', 175, 81.4, 'NANDA', 'TIDAK ADA', '0', NULL, 'XL', 'XL', 42, 1, 0, 0, '5202082701930002', NULL, NULL, NULL, NULL, NULL, '085967970998', NULL, 'PEMEPEK II RT.000 RW.000 PEMEPEK, KEC. PRINGGARATA, KABUPATEN LOMBOK TENGAH', CAST('2026-05-28' AS DATETIME), '0479/RSM/MCU/XII/2024', CAST('2024-12-12' AS DATETIME), 'RSI SITI HAJAR MATARAM', '545585', 'P5', 'SUDAH MELAKUKAN MCU', 'APPROVED'
	UNION ALL
	SELECT 'IFAN RISKIAWAN', 'yqn0krj435', 113, NULL, NULL, NULL, NULL, NULL, NULL, CAST('2000-10-25' AS DATETIME), 'PEJERUK', 161, 53.3, 'DINDA YULIA PUTRI', 'TIDAK ADA', '0', NULL, 'L', 'L', 40, 1, 0, 0, '5271012510000001', NULL, NULL, NULL, NULL, NULL, '081918098979', NULL, 'JL. GOTONG ROYONG GG. JERUK 9 KEBON JERUK RT.001 RW.018 PEJERUK, KEC. AMPENAN KOTA MATARAM', CAST('2026-05-28' AS DATETIME), '0179/RSN/MCU/XII/2024', CAST('2024-12-12' AS DATETIME), 'RSI SITI HAJAR MATARAM', '339179', 'P5', 'SUDAH MELAKUKAN MCU', 'APPROVED'
	UNION ALL
	SELECT 'MUZAKIR', '7vz26un05h', 113, NULL, NULL, NULL, NULL, NULL, NULL, CAST('1985-09-23' AS DATETIME), 'POHDANA', 168, 85.6, 'LILI NURHAYATI', 'TIDAK ADA', '0', NULL, 'XL', 'XL', 42, 1, 0, 0, '5201012309850003', NULL, NULL, NULL, NULL, NULL, '087866882865', NULL, 'LINGKUNGAN POHDANA RT.000 RW.000 GERUNG UTARA GERUNG LOMBOK BARAT', CAST('2026-05-28' AS DATETIME), NULL, NULL, NULL, NULL, NULL, NULL, 'APPROVED'
) AS SOURCE (Name, Code, GenderId, TypeId, BloodTypeId, MaritalStatusId, NationalityId, EducationId, ReligionId, BirthDate, BirthPlace, Height, Weight, SpouseName, MedicalHistory, FingerprintCode, Picture, PpeShirtSize, PpePantsSize, PpeShoeSize, ServicePeriodYear, ServicePeriodMonth, ServicePeriodDay, IdCardNumber, IdCardValidSince, TaxIdNumber, HealthInsuranceNumber, LaborInsuranceNumber, BankAccountNumber, PhoneMobile, PhoneHome, ResidencyAddress, JobStartDate, McuDocumentNum, McuDocumentDate, McuLocation, McuMedicalRecordNum, McuHealthDegree, McuRemarks, Status)
ON TARGET.Name = SOURCE.Name

-- ============================================================================
-- WHEN MATCHED: UPDATE only empty/NULL columns
-- ============================================================================
WHEN MATCHED THEN
	UPDATE SET
		Code = ISNULL(TARGET.Code, SOURCE.Code),
		GenderId = ISNULL(TARGET.GenderId, SOURCE.GenderId),
		BirthDate = ISNULL(TARGET.BirthDate, SOURCE.BirthDate),
		BirthPlace = ISNULL(TARGET.BirthPlace, SOURCE.BirthPlace),
		Height = ISNULL(TARGET.Height, SOURCE.Height),
		Weight = ISNULL(TARGET.Weight, SOURCE.Weight),
		SpouseName = ISNULL(TARGET.SpouseName, SOURCE.SpouseName),
		MedicalHistory = ISNULL(TARGET.MedicalHistory, SOURCE.MedicalHistory),
		FingerprintCode = ISNULL(TARGET.FingerprintCode, SOURCE.FingerprintCode),
		PpeShirtSize = ISNULL(TARGET.PpeShirtSize, SOURCE.PpeShirtSize),
		PpePantsSize = ISNULL(TARGET.PpePantsSize, SOURCE.PpePantsSize),
		PpeShoeSize = ISNULL(TARGET.PpeShoeSize, SOURCE.PpeShoeSize),
		ServicePeriodYear = ISNULL(TARGET.ServicePeriodYear, SOURCE.ServicePeriodYear),
		ServicePeriodMonth = ISNULL(TARGET.ServicePeriodMonth, SOURCE.ServicePeriodMonth),
		ServicePeriodDay = ISNULL(TARGET.ServicePeriodDay, SOURCE.ServicePeriodDay),
		IdCardNumber = ISNULL(TARGET.IdCardNumber, SOURCE.IdCardNumber),
		IdCardValidSince = ISNULL(TARGET.IdCardValidSince, SOURCE.IdCardValidSince),
		TaxIdNumber = ISNULL(TARGET.TaxIdNumber, SOURCE.TaxIdNumber),
		HealthInsuranceNumber = ISNULL(TARGET.HealthInsuranceNumber, SOURCE.HealthInsuranceNumber),
		LaborInsuranceNumber = ISNULL(TARGET.LaborInsuranceNumber, SOURCE.LaborInsuranceNumber),
		BankAccountNumber = ISNULL(TARGET.BankAccountNumber, SOURCE.BankAccountNumber),
		PhoneMobile = ISNULL(TARGET.PhoneMobile, SOURCE.PhoneMobile),
		PhoneHome = ISNULL(TARGET.PhoneHome, SOURCE.PhoneHome),
		ResidencyAddress = ISNULL(TARGET.ResidencyAddress, SOURCE.ResidencyAddress),
		JobStartDate = ISNULL(TARGET.JobStartDate, SOURCE.JobStartDate),
		McuDocumentNum = ISNULL(TARGET.McuDocumentNum, SOURCE.McuDocumentNum),
		McuDocumentDate = ISNULL(TARGET.McuDocumentDate, SOURCE.McuDocumentDate),
		McuLocation = ISNULL(TARGET.McuLocation, SOURCE.McuLocation),
		McuMedicalRecordNum = ISNULL(TARGET.McuMedicalRecordNum, SOURCE.McuMedicalRecordNum),
		McuHealthDegree = ISNULL(TARGET.McuHealthDegree, SOURCE.McuHealthDegree),
		McuRemarks = ISNULL(TARGET.McuRemarks, SOURCE.McuRemarks),
		Status = ISNULL(TARGET.Status, SOURCE.Status),
		ModifiedAt = GETDATE(),
		ModifiedBy = SYSTEM_USER

-- ============================================================================
-- WHEN NOT MATCHED: INSERT new crew members with all FK lookups
-- ============================================================================
WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		Code, Name, GenderId, OriginWorkingUnitId, OriginSupplyPointId,
		PlacementWorkingUnitId, PlacementSupplyPointId,
		CurrentVendorId, JobTitleId, OriginBusinessTypeId,
		OriginTariffSchemeId, OriginBusinessSchemeId,
		PlacementTariffSchemeId, OperationalStatusId,
		HealthInsuranceStatusId, ShipmentStatusId, McuResultId,
		TankCapacityId, ResidencyStatusId,
		BirthDate, BirthPlace, Height, Weight, SpouseName, MedicalHistory,
		FingerprintCode, PpeShirtSize, PpePantsSize, PpeShoeSize,
		ServicePeriodYear, ServicePeriodMonth, ServicePeriodDay,
		IdCardNumber, IdCardValidSince, TaxIdNumber, HealthInsuranceNumber,
		LaborInsuranceNumber, BankAccountNumber, PhoneMobile, PhoneHome,
		ResidencyAddress, JobStartDate, McuDocumentNum, McuDocumentDate,
		McuLocation, McuMedicalRecordNum, McuHealthDegree, McuRemarks,
		Status, PlacementIsActive, OriginIsActive, OperationalIsActive,
		CreatedAt, CreatedBy, IsActive
	)
	VALUES (
		SOURCE.Code, SOURCE.Name, SOURCE.GenderId, @OriginWorkingUnitId, @OriginSupplyPointId,
		@PlacementWorkingUnitId, @PlacementSupplyPointId,
		@CurrentVendorId, @JobTitleId, @OriginBusinessTypeId,
		@OriginTariffSchemeId, @OriginBusinessSchemeId,
		@PlacementTariffSchemeId, @OperationalStatusId,
		@HealthInsuranceStatusId, @ShipmentStatusId, @McuResultId,
		@TankCapacityId, @ResidencyStatusId,
		SOURCE.BirthDate, SOURCE.BirthPlace, SOURCE.Height, SOURCE.Weight,
		SOURCE.SpouseName, SOURCE.MedicalHistory,
		SOURCE.FingerprintCode, SOURCE.PpeShirtSize, SOURCE.PpePantsSize,
		SOURCE.PpeShoeSize, SOURCE.ServicePeriodYear, SOURCE.ServicePeriodMonth,
		SOURCE.ServicePeriodDay, SOURCE.IdCardNumber, SOURCE.IdCardValidSince,
		SOURCE.TaxIdNumber, SOURCE.HealthInsuranceNumber, SOURCE.LaborInsuranceNumber,
		SOURCE.BankAccountNumber, SOURCE.PhoneMobile, SOURCE.PhoneHome,
		SOURCE.ResidencyAddress, SOURCE.JobStartDate, SOURCE.McuDocumentNum,
		SOURCE.McuDocumentDate, SOURCE.McuLocation, SOURCE.McuMedicalRecordNum,
		SOURCE.McuHealthDegree, SOURCE.McuRemarks, SOURCE.Status,
		1, 1, 1, GETDATE(), SYSTEM_USER, 1
	);

-- ============================================================================
-- 4. VALIDATION QUERIES
-- ============================================================================

PRINT '========== CREWS INSERT/UPDATE RESULT ==========';
SELECT TOP 10 
	ID, Code, Name, GenderId, OriginWorkingUnitId, JobTitleId,
	CurrentVendorId, Status, CreatedAt, ModifiedAt
FROM [dbo].[Crews]
WHERE Name IN ('ABDUL GAPUR', 'ANDI ANDREAS WUA', 'BIN BASRI', 'DARMAWAN EDI KAPUTRADI', 'IFAN RISKIAWAN', 'MUZAKIR')
ORDER BY CreatedAt DESC;

PRINT '========== FK REFERENCE CHECK ==========';
SELECT 
	c.ID, c.Code, c.Name,
	g.Name AS GenderName,
	l1.Name AS OriginLocation,
	l2.Name AS PlacementLocation,
	a.Name AS VendorName,
	cat.Name AS JobTitle,
	c.Status
FROM [dbo].[Crews] c
LEFT JOIN [dbo].[Categories] g ON c.GenderId = g.ID
LEFT JOIN [dbo].[Locations] l1 ON c.OriginWorkingUnitId = l1.ID
LEFT JOIN [dbo].[Locations] l2 ON c.PlacementWorkingUnitId = l2.ID
LEFT JOIN [dbo].[Accounts] a ON c.CurrentVendorId = a.ID
LEFT JOIN [dbo].[Categories] cat ON c.JobTitleId = cat.ID
WHERE c.Name IN ('ABDUL GAPUR', 'ANDI ANDREAS WUA', 'BIN BASRI', 'DARMAWAN EDI KAPUTRADI', 'IFAN RISKIAWAN', 'MUZAKIR');

COMMIT TRANSACTION;
PRINT '✓ Transaction committed successfully!';

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	PRINT '✗ Error occurred: ' + ERROR_MESSAGE();
	THROW;
END CATCH;
