/*
================================================================================
SCRIPT: Bulk Insert/Update Crews PT. UDAYANA PUTRA 2026
PURPOSE: Insert 10 AMT crew members with complete FK mapping to master data
AUTHOR: nurihsanhusein
DATE: 2026-05-28
================================================================================
SOURCE: AMT Bulk PT. UDAYANA PUTRA 2026.csv
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
DECLARE @TypeId INT; -- CrewType (AMT 1)
DECLARE @GenderId INT;
DECLARE @MaritalStatusIdKawin INT;
DECLARE @MaritalStatusIdBelumKawin INT;
DECLARE @NationalityId INT;
DECLARE @BloodTypeIdO INT;
DECLARE @BloodTypeIdA INT;
DECLARE @BloodTypeIdB INT;
DECLARE @EducationId INT;
DECLARE @ReligionIdIslam INT;
DECLARE @ReligionIdKatolik INT;
DECLARE @OriginBusinessTypeId INT;
DECLARE @OriginBusinessSchemeId INT;
DECLARE @OriginTariffSchemeId INT;
DECLARE @PlacementTariffSchemeId INT;
DECLARE @OperationalStatusId INT;
DECLARE @ResidencyStatusId INT;
DECLARE @JobTitleId INT;
DECLARE @HealthInsuranceStatusId INT;
DECLARE @ShipmentStatusId INT;
DECLARE @BankId INT;
DECLARE @BpjsHealthInsuranceStatusId INT;

-- ============================================================================
-- 2. LOOKUP MASTER DATA FROM EXISTING TABLES
-- ============================================================================

-- Locations Lookup
SELECT @OriginWorkingUnitId = ID FROM [dbo].[Locations] WHERE Code = 'MOR05'; -- JATIMBALINUS
SELECT @OriginSupplyPointId = ID FROM [dbo].[Locations] WHERE Code = '1310'; -- FUEL TERMINAL AMPENAN
SELECT @PlacementWorkingUnitId = ID FROM [dbo].[Locations] WHERE Code = 'MOR05'; -- JATIMBALINUS
SELECT @PlacementSupplyPointId = ID FROM [dbo].[Locations] WHERE Code = '1310'; -- FUEL TERMINAL AMPENAN

-- Accounts Lookup
SELECT @CurrentVendorId = ID FROM [dbo].[Accounts] WHERE Name LIKE '%UDAYANA%PUTRA%';

-- CrewTypes Lookup
SELECT @TypeId = ID FROM [dbo].[CrewTypes] WHERE Code = 'AMT01'; -- AMT 1

-- Categories Lookup - Demographics (Gender, Marital Status)
SELECT @GenderId = ID FROM [dbo].[Categories] WHERE Code = 'male'; -- Male
SELECT @MaritalStatusIdKawin = ID FROM [dbo].[Categories] WHERE Code = 'Menikah'; -- Menikah
SELECT @MaritalStatusIdBelumKawin = ID FROM [dbo].[Categories] WHERE Code = 'Belum Menikah'; -- Belum Menikah

-- Categories Lookup - Blood Types
SELECT @BloodTypeIdO = ID FROM [dbo].[Categories] WHERE Code = 'O+'; -- O+ Blood Type
SELECT @BloodTypeIdA = ID FROM [dbo].[Categories] WHERE Code = 'A+'; -- A+ Blood Type
SELECT @BloodTypeIdB = ID FROM [dbo].[Categories] WHERE Code = 'B+'; -- B+ Blood Type

-- Categories Lookup - Other Demographics
SELECT @NationalityId = ID FROM [dbo].[Categories] WHERE Code = 'WNI'; -- WNI
SELECT @EducationId = ID FROM [dbo].[Categories] WHERE Code = 'sma'; -- SMA

-- Categories Lookup - Religion
SELECT @ReligionIdIslam = ID FROM [dbo].[Categories] WHERE Code = 'Islam'; -- Islam
SELECT @ReligionIdKatolik = ID FROM [dbo].[Categories] WHERE Code = 'Kristen Katolik'; -- Kristen Katolik

-- Categories Lookup - Business & Operational
SELECT @OriginBusinessTypeId = ID FROM [dbo].[Categories] WHERE Code = 'BT001'; -- Fleet BBM SPBU
SELECT @OriginBusinessSchemeId = ID FROM [dbo].[Categories] WHERE Code = 'BS004'; -- MT Transportir Pola Tarif
SELECT @OriginTariffSchemeId = ID FROM [dbo].[Categories] WHERE Code = 'TF003'; -- Pola Tarif
SELECT @PlacementTariffSchemeId = ID FROM [dbo].[Categories] WHERE Code = 'TF003'; -- Pola Tarif
SELECT @OperationalStatusId = ID FROM [dbo].[Categories] WHERE Code = 'PS005'; -- Operasional

-- Categories Lookup - Other
SELECT @ResidencyStatusId = ID FROM [dbo].[Categories] WHERE Code = 'residenStat04'; -- Kontrak
SELECT @JobTitleId = ID FROM [dbo].[Categories] WHERE Code = 'AMT01'; -- AMT 1
SELECT @HealthInsuranceStatusId = ID FROM [dbo].[Categories] WHERE Code = 'INS01'; -- Aktif
SELECT @ShipmentStatusId = ID FROM [dbo].[Categories] WHERE Code = 'SH001'; -- Tersedia
SELECT @BankId = ID FROM [dbo].[Categories] WHERE Code = 'BNK03'; -- BRI
SELECT @BpjsHealthInsuranceStatusId = ID FROM [dbo].[Categories] WHERE Code = 'INS01'; -- Aktif

-- ============================================================================
-- 3. VALIDATION - Display lookup results
-- ============================================================================
PRINT '========== CREW LOOKUP RESULTS ==========';
PRINT 'OriginSupplyPointId: ' + ISNULL(CAST(@OriginSupplyPointId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'PlacementSupplyPointId: ' + ISNULL(CAST(@PlacementSupplyPointId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'CurrentVendorId: ' + ISNULL(CAST(@CurrentVendorId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'TypeId (CrewType): ' + ISNULL(CAST(@TypeId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'GenderId: ' + ISNULL(CAST(@GenderId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'BloodTypeIdO: ' + ISNULL(CAST(@BloodTypeIdO AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'ReligionIdIslam: ' + ISNULL(CAST(@ReligionIdIslam AS NVARCHAR(10)), 'NOT FOUND');
PRINT '========================================';

-- ============================================================================
-- 4. MERGE STATEMENT - UPSERT CREWS
-- ============================================================================

MERGE INTO [dbo].[Crews] AS TARGET
USING (
	-- Record 1: ABDUL GAPUR
	SELECT 
		'e8g9zh8p7d' AS Code,
		'ABDUL GAPUR' AS Name,
		CAST('1984-11-05' AS DATETIME) AS BirthDate,
		'LEONG' AS BirthPlace,
		156.5 AS Height,
		72.5 AS Weight,
		'MULYANI' AS SpouseName,
		'TIDAK ADA' AS MedicalHistory,
		'0' AS FingerprintCode,
		'087863668101' AS PhoneMobile,
		'DUSUN LEONG RT.000 RW.000 GIRI MADIA, KEC. LINGSAR KABUPATEN LOMBOK BARAT' AS ResidencyAddress,
		'L' AS PpeShirtSize,
		'L' AS PpePantsSize,
		'40' AS PpeShoeSize,
		CAST('2029-04-11' AS DATETIME) AS DriverLicenseBExpiryDate,
		'5201120107890190' AS DriverLicenseBNumber,
		180 AS ServicePeriodYear,
		15 AS ServicePeriodMonth,
		1 AS ServicePeriodDay,
		'5201120107890190' AS IdCardNumber,
		CAST('1984-11-05' AS DATETIME) AS IdCardValidSince,
		NULL AS TaxIdNumber,
		NULL AS HealthInsuranceNumber,
		NULL AS LaborInsuranceNumber,
		NULL AS BankName,
		NULL AS BankBranchName,
		NULL AS BankAccountName,
		NULL AS BankAccountNumber,
		1 AS MaritalStatusId,
		@ReligionIdIslam AS ReligionId,
		@BloodTypeIdO AS BloodTypeId
	UNION ALL
	-- Record 2: ANDI ANDREAS WUA
	SELECT 'k57eoy2fbi', 'ANDI ANDREAS WUA', CAST('1988-05-16' AS DATETIME), 'MANGGARAI', 161, 77.5, 'DOMICA BENI', 'TIDAK ADA', '0', '085942879368', 
		'JL. GOTONG ROYONG TEMPIT RT. 001 RW. 012 AMPENAN TENGAH, AMPENAN, KOTA MATARAM', 'XL', 'XL', '42', CAST('2029-05-14' AS DATETIME), '16268805000465', 180, 15, 1, 
		'5310011605880004', CAST('1988-05-16' AS DATETIME), NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, @ReligionIdKatolik, @BloodTypeIdA
	UNION ALL
	-- Record 3: BIN BASRI
	SELECT 'k57eoy2fbi', 'BIN BASRI', CAST('1999-06-05' AS DATETIME), 'PALIS', 167.5, 60.3, NULL, 'TIDAK ADA', '0', '081339815977',
		'PALIS RT. 009 RW. 000 NANGA LILI LEMBOR SELATAN KABUPATEN MANGGARAI BARAT', 'L', 'L', '42', CAST('2028-09-07' AS DATETIME), '16319906000087', 180, 15, 1,
		'531503050699003', CAST('1999-06-05' AS DATETIME), NULL, NULL, NULL, NULL, NULL, NULL, NULL, @MaritalStatusIdBelumKawin, @ReligionIdIslam, @BloodTypeIdB
	UNION ALL
	-- Record 4: DARMAWAN EDI KAPUTRADI
	SELECT 'acbtdenhwy', 'DARMAWAN EDI KAPUTRADI', CAST('1993-01-27' AS DATETIME), 'PEMEPEK', 175, 81.4, 'NANDA', 'TIDAK ADA', '0', '085967970998',
		'PEMEPEK II RT.000 RW.000 PEMEPEK, KEC. PRINGGARATA, KABUPATEN LOMBOK TENGAH', 'XL', 'XL', '42', NULL, NULL, 180, 15, 1,
		'5202082701930002', CAST('1993-01-27' AS DATETIME), '1847209887', NULL, NULL, NULL, NULL, NULL, NULL, 1, @ReligionIdIslam, @BloodTypeIdO
	UNION ALL
	-- Record 5: IFAN RISKIAWAN
	SELECT 'yqn0krj435', 'IFAN RISKIAWAN', CAST('2000-10-25' AS DATETIME), 'PEJERUK', 161, 53.3, 'DINDA YULIA PUTRI', 'TIDAK ADA', '0', '081918098979',
		'JL. GOTONG ROYONG GG. JERUK 9 KEBON JERUK RT.001 RW.018 PEJERUK, KEC. AMPENAN KOTA MATARAM', 'L', 'L', '40', CAST('2030-10-27' AS DATETIME), '5201012309850000', 180, 15, 1,
		'5271012510000001', CAST('2000-10-25' AS DATETIME), NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, @ReligionIdIslam, @BloodTypeIdA
	UNION ALL
	-- Record 6: MUZAKIR
	SELECT '7vz26un05h', 'MUZAKIR', CAST('1985-09-23' AS DATETIME), 'POHDANA', 168, 85.6, 'LILI NURHAYATI', 'TIDAK ADA', '0', '087866882865',
		'LINGKUNGAN POHDANA RT.000 RW.000 GERUNG UTARA GERUNG LOMBOK BARAT', 'XL', 'XL', '42.5', CAST('2030-10-27' AS DATETIME), '5201012309850003', 180, 15, 1,
		'5201012309850003', CAST('1985-09-23' AS DATETIME), NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, @ReligionIdIslam, @BloodTypeIdO
	UNION ALL
	-- Record 7: OPI IRAWAN
	SELECT 'sfexftquf8', 'OPI IRAWAN', CAST('1997-07-08' AS DATETIME), 'DASAN GERIA', 163, 58.5, NULL, 'TIDAK ADA', '0', '081936317975',
		'DUSUN DASAN GERIA SELATAN RT.000 RW.000 DASAN GERIA KECAMATAN LINGSAR KABUPATEN LOMBOK BARAT', 'L', 'L', '41', CAST('2029-10-11' AS DATETIME), '5201120107970124', 180, 15, 1,
		'5201120107970124', CAST('1997-07-08' AS DATETIME), NULL, NULL, NULL, NULL, NULL, NULL, NULL, @MaritalStatusIdBelumKawin, @ReligionIdIslam, @BloodTypeIdA
	UNION ALL
	-- Record 8: PASKALIS WIDIONO LEPO
	SELECT 'yq3norj435', 'PASKALIS WIDIONO LEPO', CAST('1984-04-23' AS DATETIME), 'MATARAM', 174.5, 62.3, 'HERLIN TRISNAWATI', 'TIDAK ADA', '0', '085338810538',
		'JL. PELITA NO. 9 KARANG TARUNA RT.001 RW. 202 MATARAM BARAT, SELAPARANG, KOTA MATARAM', 'L', 'L', '41', CAST('2028-04-08' AS DATETIME), '29328404000090', 180, 15, 1,
		'5271052304840000', CAST('1984-04-23' AS DATETIME), '735001005633535', NULL, NULL, NULL, NULL, NULL, NULL, 1, @ReligionIdKatolik, @BloodTypeIdO
	UNION ALL
	-- Record 9: PIUS YOHANES DANGGUT
	SELECT 'byujmgu2e0', 'PIUS YOHANES DANGGUT', CAST('1988-01-04' AS DATETIME), 'NDEHES', 168, 84.5, 'NENGAH SRI WIYANI', 'TIDAK ADA', '0', '081237944064',
		'JL. MALOMBA GG RAJAWALI NO.16 TANGSI RT.025 RW.001 AMPENAN SELATAN, AMPENAN, KOTA MATARAM', 'XL', 'XL', '43', CAST('2028-05-09' AS DATETIME), '16268801000348', 180, 15, 1,
		'5201140401780003', CAST('1988-01-04' AS DATETIME), NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, @ReligionIdKatolik, @BloodTypeIdA
	UNION ALL
	-- Record 10: STEFANUS RAJA
	SELECT 'mx0vh565qa', 'STEFANUS RAJA', CAST('1987-12-30' AS DATETIME), 'ENDE FLORES', 162.5, 59.2, NULL, 'TIDAK ADA', '0', '085238155046',
		'JL. PELITA NO. 9 KARANG TARUNA RT. 001 RW. 202 MATARAM BARAT, SELAPARANG, KOTA MATARAM', 'L', 'L', '40', NULL, NULL, 180, 15, 1,
		'5271053012870000', CAST('1987-12-30' AS DATETIME), NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, @ReligionIdKatolik, @BloodTypeIdO

) AS SOURCE (
	Code, Name, BirthDate, BirthPlace, Height, Weight, SpouseName, MedicalHistory, FingerprintCode,
	PhoneMobile, ResidencyAddress, PpeShirtSize, PpePantsSize, PpeShoeSize, DriverLicenseBExpiryDate,
	DriverLicenseBNumber, ServicePeriodYear, ServicePeriodMonth, ServicePeriodDay, IdCardNumber,
	IdCardValidSince, TaxIdNumber, HealthInsuranceNumber, LaborInsuranceNumber, BankName,
	BankBranchName, BankAccountName, BankAccountNumber, MaritalStatusId, ReligionId, BloodTypeId
)
ON TARGET.[Code] = SOURCE.[Code]

WHEN MATCHED THEN
	UPDATE SET
		TARGET.[Name] = ISNULL(TARGET.[Name], SOURCE.[Name]),
		TARGET.[BirthDate] = ISNULL(TARGET.[BirthDate], SOURCE.[BirthDate]),
		TARGET.[BirthPlace] = ISNULL(TARGET.[BirthPlace], SOURCE.[BirthPlace]),
		TARGET.[Height] = ISNULL(TARGET.[Height], SOURCE.[Height]),
		TARGET.[Weight] = ISNULL(TARGET.[Weight], SOURCE.[Weight]),
		TARGET.[SpouseName] = ISNULL(TARGET.[SpouseName], SOURCE.[SpouseName]),
		TARGET.[MedicalHistory] = ISNULL(TARGET.[MedicalHistory], SOURCE.[MedicalHistory]),
		TARGET.[FingerprintCode] = ISNULL(TARGET.[FingerprintCode], SOURCE.[FingerprintCode]),
		TARGET.[PhoneMobile] = ISNULL(TARGET.[PhoneMobile], SOURCE.[PhoneMobile]),
		TARGET.[ResidencyAddress] = ISNULL(TARGET.[ResidencyAddress], SOURCE.[ResidencyAddress]),
		TARGET.[PpeShirtSize] = ISNULL(TARGET.[PpeShirtSize], SOURCE.[PpeShirtSize]),
		TARGET.[PpePantsSize] = ISNULL(TARGET.[PpePantsSize], SOURCE.[PpePantsSize]),
		TARGET.[PpeShoeSize] = ISNULL(TARGET.[PpeShoeSize], SOURCE.[PpeShoeSize]),
		TARGET.[DriverLicenseB] = CAST(1 AS BIT),
		TARGET.[DriverLicenseBExpiryDate] = ISNULL(TARGET.[DriverLicenseBExpiryDate], SOURCE.[DriverLicenseBExpiryDate]),
		TARGET.[DriverLicenseBNumber] = ISNULL(TARGET.[DriverLicenseBNumber], SOURCE.[DriverLicenseBNumber]),
		TARGET.[ServicePeriodYear] = ISNULL(TARGET.[ServicePeriodYear], SOURCE.[ServicePeriodYear]),
		TARGET.[ServicePeriodMonth] = ISNULL(TARGET.[ServicePeriodMonth], SOURCE.[ServicePeriodMonth]),
		TARGET.[ServicePeriodDay] = ISNULL(TARGET.[ServicePeriodDay], SOURCE.[ServicePeriodDay]),
		TARGET.[IdCardNumber] = ISNULL(TARGET.[IdCardNumber], SOURCE.[IdCardNumber]),
		TARGET.[IdCardValidSince] = ISNULL(TARGET.[IdCardValidSince], SOURCE.[IdCardValidSince]),
		TARGET.[TaxIdNumber] = ISNULL(TARGET.[TaxIdNumber], SOURCE.[TaxIdNumber]),
		TARGET.[HealthInsuranceNumber] = ISNULL(TARGET.[HealthInsuranceNumber], SOURCE.[HealthInsuranceNumber]),
		TARGET.[LaborInsuranceNumber] = ISNULL(TARGET.[LaborInsuranceNumber], SOURCE.[LaborInsuranceNumber]),
		TARGET.[BankName] = ISNULL(TARGET.[BankName], SOURCE.[BankName]),
		TARGET.[BankBranchName] = ISNULL(TARGET.[BankBranchName], SOURCE.[BankBranchName]),
		TARGET.[BankAccountName] = ISNULL(TARGET.[BankAccountName], SOURCE.[BankAccountName]),
		TARGET.[BankAccountNumber] = ISNULL(TARGET.[BankAccountNumber], SOURCE.[BankAccountNumber]),
		TARGET.[Status] = 'APPROVED',
		TARGET.[ModifiedAt] = GETDATE(),
		TARGET.[ModifiedBy] = 'nurihsanhusein'

WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		[Code], [Name], [TypeId], [GenderId], [MaritalStatusId], [NationalityId], [BloodTypeId],
		[EducationId], [ReligionId], [BirthDate], [BirthPlace], [Height], [Weight], [SpouseName],
		[MedicalHistory], [FingerprintCode], [OriginBusinessTypeId], [OriginBusinessSchemeId],
		[OriginIsActive], [OriginWorkingUnitId], [OriginSupplyPointId], [OriginTariffSchemeId],
		[PlacementIsActive], [PlacementWorkingUnitId], [PlacementSupplyPointId], [PlacementTariffSchemeId],
		[OperationalStatusId], [OperationalIsActive], [PhoneMobile], [ResidencyAddress], [ResidencyStatusId],
		[JobTitleId], [CurrentVendorId], [HealthInsuranceStatusId], [ShipmentStatusId],
		[DriverLicenseB], [DriverLicenseBExpiryDate], [DriverLicenseBNumber],
		[PpePantsSize], [PpeShirtSize], [PpeShoeSize],
		[IdCardNumber], [IdCardValidSince], [TaxIdNumber], [HealthInsuranceNumber], [LaborInsuranceNumber],
		[BankName], [BankBranchName], [BankAccountName], [BankAccountNumber],
		[BpjsHealthInsuranceStatusId], [Status], [IsActive], [IsDeleted],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy]
	)
	VALUES (
		SOURCE.[Code], SOURCE.[Name], @TypeId, @GenderId, SOURCE.[MaritalStatusId], @NationalityId, SOURCE.[BloodTypeId],
		@EducationId, SOURCE.[ReligionId], SOURCE.[BirthDate], SOURCE.[BirthPlace], SOURCE.[Height], SOURCE.[Weight], SOURCE.[SpouseName],
		SOURCE.[MedicalHistory], SOURCE.[FingerprintCode], @OriginBusinessTypeId, @OriginBusinessSchemeId,
		1, @OriginWorkingUnitId, @OriginSupplyPointId, @OriginTariffSchemeId,
		1, @PlacementWorkingUnitId, @PlacementSupplyPointId, @PlacementTariffSchemeId,
		@OperationalStatusId, 1, SOURCE.[PhoneMobile], SOURCE.[ResidencyAddress], @ResidencyStatusId,
		@JobTitleId, @CurrentVendorId, @HealthInsuranceStatusId, @ShipmentStatusId,
		1, SOURCE.[DriverLicenseBExpiryDate], SOURCE.[DriverLicenseBNumber],
		SOURCE.[PpePantsSize], SOURCE.[PpeShirtSize], SOURCE.[PpeShoeSize],
		SOURCE.[IdCardNumber], SOURCE.[IdCardValidSince], SOURCE.[TaxIdNumber], SOURCE.[HealthInsuranceNumber], SOURCE.[LaborInsuranceNumber],
		SOURCE.[BankName], SOURCE.[BankBranchName], SOURCE.[BankAccountName], SOURCE.[BankAccountNumber],
		@BpjsHealthInsuranceStatusId, 'APPROVED', 1, 0,
		GETDATE(), 'nurihsanhusein', GETDATE(), 'nurihsanhusein'
	);

PRINT 'Crew data merge completed successfully!';
PRINT 'Total records processed: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));

COMMIT TRANSACTION;

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	
	DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
	DECLARE @ErrorNumber INT = ERROR_NUMBER();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
	
	PRINT 'ERROR OCCURRED:';
	PRINT 'Error Number: ' + CAST(@ErrorNumber AS NVARCHAR(10));
	PRINT 'Error Message: ' + @ErrorMessage;
	
	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;

-- ============================================================================
-- 5. VALIDATION QUERIES (Run after merge to verify data)
-- ============================================================================

/*
-- Verify inserted/updated crews
SELECT 
	[Code],
	[Name],
	[IdCardNumber],
	[BirthDate],
	[Height],
	[Weight],
	[Status],
	[OriginIsActive],
	[PlacementIsActive],
	[OperationalIsActive],
	[CreatedBy],
	[CreatedAt]
FROM [dbo].[Crews]
WHERE [CreatedBy] = 'nurihsanhusein' 
	AND [Status] = 'APPROVED'
ORDER BY [CreatedAt] DESC;

-- Verify FK relationships
SELECT 
	C.[Code],
	C.[Name],
	CT.[Name] AS CrewType,
	A_Vendor.[Name] AS VendorName,
	CAT_Gender.[Name] AS Gender,
	CAT_Education.[Name] AS Education,
	CAT_Religion.[Name] AS Religion,
	CAT_BloodType.[Name] AS BloodType,
	CAT_MaritalStatus.[Name] AS MaritalStatus,
	LOC_Origin.[Name] AS OriginLocation,
	LOC_Placement.[Name] AS PlacementLocation,
	CAT_JobTitle.[Name] AS JobTitle
FROM [dbo].[Crews] C
LEFT JOIN [dbo].[CrewTypes] CT ON C.[TypeId] = CT.[Id]
LEFT JOIN [dbo].[Accounts] A_Vendor ON C.[CurrentVendorId] = A_Vendor.[Id]
LEFT JOIN [dbo].[Categories] CAT_Gender ON C.[GenderId] = CAT_Gender.[Id]
LEFT JOIN [dbo].[Categories] CAT_Education ON C.[EducationId] = CAT_Education.[Id]
LEFT JOIN [dbo].[Categories] CAT_Religion ON C.[ReligionId] = CAT_Religion.[Id]
LEFT JOIN [dbo].[Categories] CAT_BloodType ON C.[BloodTypeId] = CAT_BloodType.[Id]
LEFT JOIN [dbo].[Categories] CAT_MaritalStatus ON C.[MaritalStatusId] = CAT_MaritalStatus.[Id]
LEFT JOIN [dbo].[Locations] LOC_Origin ON C.[OriginSupplyPointId] = LOC_Origin.[Id]
LEFT JOIN [dbo].[Locations] LOC_Placement ON C.[PlacementSupplyPointId] = LOC_Placement.[Id]
LEFT JOIN [dbo].[Categories] CAT_JobTitle ON C.[JobTitleId] = CAT_JobTitle.[Id]
WHERE C.[CreatedBy] = 'nurihsanhusein'
ORDER BY C.[CreatedAt] DESC;
*/
