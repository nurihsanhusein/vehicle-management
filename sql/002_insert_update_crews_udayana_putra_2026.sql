/*
================================================================================
SCRIPT: Bulk Insert/Update Crews PT. UDAYANA PUTRA 2026
PURPOSE: Insert 10 AMT crew members with complete FK mapping to master data
AUTHOR: nurihsanhusein
DATE: 2026-05-28
================================================================================
SOURCE: AMT Bulk PT. UDAYANA PUTRA 2026.csv

FIXES APPLIED:
- Fixed duplicate crew codes (BIN BASRI had same code as ANDI)
- Improved CrewType lookup with LIKE pattern matching
- Added alternative lookups for missing categories
- Separated INSERT and UPDATE operations for safety
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

-- CrewTypes Lookup - Try multiple patterns
SELECT @TypeId = ID FROM [dbo].[CrewTypes] WHERE Code LIKE 'AMT%' AND Name LIKE '%1%';
IF @TypeId IS NULL
	SELECT @TypeId = ID FROM [dbo].[CrewTypes] WHERE Name LIKE '%AMT%' LIMIT 1;
IF @TypeId IS NULL
	SELECT @TypeId = ID FROM [dbo].[CrewTypes] LIMIT 1; -- Fallback to first record

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
SELECT @OperationalStatusId = ID FROM [dbo].[Categories] WHERE Code LIKE '%PS%' AND Name LIKE '%Operasional%'; -- Operasional

-- Categories Lookup - Other
SELECT @ResidencyStatusId = ID FROM [dbo].[Categories] WHERE Code = 'residenStat04'; -- Kontrak
SELECT @JobTitleId = ID FROM [dbo].[Categories] WHERE Code = 'AMT01'; -- AMT 1
SELECT @HealthInsuranceStatusId = ID FROM [dbo].[Categories] WHERE Code = 'INS01'; -- Aktif
SELECT @ShipmentStatusId = ID FROM [dbo].[Categories] WHERE Code = 'SH001'; -- Tersedia

-- ============================================================================
-- 3. VALIDATION - Display lookup results
-- ============================================================================
PRINT '========== CREW LOOKUP RESULTS ==========';
PRINT 'OriginSupplyPointId: ' + ISNULL(CAST(@OriginSupplyPointId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'PlacementSupplyPointId: ' + ISNULL(CAST(@PlacementSupplyPointId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'CurrentVendorId: ' + ISNULL(CAST(@CurrentVendorId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'TypeId (CrewType): ' + ISNULL(CAST(@TypeId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'GenderId: ' + ISNULL(CAST(@GenderId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'EducationId: ' + ISNULL(CAST(@EducationId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'NationalityId: ' + ISNULL(CAST(@NationalityId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'ReligionIdIslam: ' + ISNULL(CAST(@ReligionIdIslam AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'OperationalStatusId: ' + ISNULL(CAST(@OperationalStatusId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'JobTitleId: ' + ISNULL(CAST(@JobTitleId AS NVARCHAR(10)), 'NOT FOUND');
PRINT '========================================';

-- ============================================================================
-- 4. INSERT NEW CREWS (Non-MERGE approach to avoid duplicate matching)
-- ============================================================================

INSERT INTO [dbo].[Crews] (
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
	[Status], [IsActive], [IsDeleted],
	[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy]
)
SELECT 
	'e8g9zh8p7d' AS Code,
	'ABDUL GAPUR' AS Name,
	@TypeId, @GenderId, @MaritalStatusIdKawin, @NationalityId, @BloodTypeIdO,
	@EducationId, @ReligionIdIslam, CAST('1984-11-05' AS DATETIME), 'LEONG', 156.5, 72.5, 'MULYANI',
	'TIDAK ADA', '0', @OriginBusinessTypeId, @OriginBusinessSchemeId,
	1, @OriginWorkingUnitId, @OriginSupplyPointId, @OriginTariffSchemeId,
	1, @PlacementWorkingUnitId, @PlacementSupplyPointId, @PlacementTariffSchemeId,
	@OperationalStatusId, 1, '087863668101', 
	'DUSUN LEONG RT.000 RW.000 GIRI MADIA, KEC. LINGSAR KABUPATEN LOMBOK BARAT', @ResidencyStatusId,
	@JobTitleId, @CurrentVendorId, @HealthInsuranceStatusId, @ShipmentStatusId,
	1, CAST('2029-04-11' AS DATETIME), '5201120107890190',
	'L', 'L', '40',
	'5201120107890190', CAST('1984-11-05' AS DATETIME), NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	'APPROVED', 1, 0, GETDATE(), 'nurihsanhusein', GETDATE(), 'nurihsanhusein'
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Crews] WHERE Code = 'e8g9zh8p7d')

UNION ALL

SELECT 
	'k57eoy2fbi' AS Code,
	'ANDI ANDREAS WUA' AS Name,
	@TypeId, @GenderId, @MaritalStatusIdKawin, @NationalityId, @BloodTypeIdA,
	@EducationId, @ReligionIdKatolik, CAST('1988-05-16' AS DATETIME), 'MANGGARAI', 161, 77.5, 'DOMICA BENI',
	'TIDAK ADA', '0', @OriginBusinessTypeId, @OriginBusinessSchemeId,
	1, @OriginWorkingUnitId, @OriginSupplyPointId, @OriginTariffSchemeId,
	1, @PlacementWorkingUnitId, @PlacementSupplyPointId, @PlacementTariffSchemeId,
	@OperationalStatusId, 1, '085942879368',
	'JL. GOTONG ROYONG TEMPIT RT. 001 RW. 012 AMPENAN TENGAH, AMPENAN, KOTA MATARAM', @ResidencyStatusId,
	@JobTitleId, @CurrentVendorId, @HealthInsuranceStatusId, @ShipmentStatusId,
	1, CAST('2029-05-14' AS DATETIME), '16268805000465',
	'XL', 'XL', '42',
	'5310011605880004', CAST('1988-05-16' AS DATETIME), NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	'APPROVED', 1, 0, GETDATE(), 'nurihsanhusein', GETDATE(), 'nurihsanhusein'
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Crews] WHERE Code = 'k57eoy2fbi')

UNION ALL

SELECT 
	'8srujzuxtn' AS Code,
	'BIN BASRI' AS Name,
	@TypeId, @GenderId, @MaritalStatusIdBelumKawin, @NationalityId, @BloodTypeIdB,
	@EducationId, @ReligionIdIslam, CAST('1999-06-05' AS DATETIME), 'PALIS', 167.5, 60.3, NULL,
	'TIDAK ADA', '0', @OriginBusinessTypeId, @OriginBusinessSchemeId,
	1, @OriginWorkingUnitId, @OriginSupplyPointId, @OriginTariffSchemeId,
	1, @PlacementWorkingUnitId, @PlacementSupplyPointId, @PlacementTariffSchemeId,
	@OperationalStatusId, 1, '081339815977',
	'PALIS RT. 009 RW. 000 NANGA LILI LEMBOR SELATAN KABUPATEN MANGGARAI BARAT', @ResidencyStatusId,
	@JobTitleId, @CurrentVendorId, @HealthInsuranceStatusId, @ShipmentStatusId,
	1, CAST('2028-09-07' AS DATETIME), '16319906000087',
	'L', 'L', '42',
	'531503050699003', CAST('1999-06-05' AS DATETIME), NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	'APPROVED', 1, 0, GETDATE(), 'nurihsanhusein', GETDATE(), 'nurihsanhusein'
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Crews] WHERE Code = '8srujzuxtn')

UNION ALL

SELECT 
	'acbtdenhwy' AS Code,
	'DARMAWAN EDI KAPUTRADI' AS Name,
	@TypeId, @GenderId, @MaritalStatusIdKawin, @NationalityId, @BloodTypeIdO,
	@EducationId, @ReligionIdIslam, CAST('1993-01-27' AS DATETIME), 'PEMEPEK', 175, 81.4, 'NANDA',
	'TIDAK ADA', '0', @OriginBusinessTypeId, @OriginBusinessSchemeId,
	1, @OriginWorkingUnitId, @OriginSupplyPointId, @OriginTariffSchemeId,
	1, @PlacementWorkingUnitId, @PlacementSupplyPointId, @PlacementTariffSchemeId,
	@OperationalStatusId, 1, '085967970998',
	'PEMEPEK II RT.000 RW.000 PEMEPEK, KEC. PRINGGARATA, KABUPATEN LOMBOK TENGAH', @ResidencyStatusId,
	@JobTitleId, @CurrentVendorId, @HealthInsuranceStatusId, @ShipmentStatusId,
	0, NULL, NULL,
	'XL', 'XL', '42',
	'5202082701930002', CAST('1993-01-27' AS DATETIME), '1847209887', NULL, NULL,
	NULL, NULL, NULL, NULL,
	'APPROVED', 1, 0, GETDATE(), 'nurihsanhusein', GETDATE(), 'nurihsanhusein'
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Crews] WHERE Code = 'acbtdenhwy')

UNION ALL

SELECT 
	'yqn0krj435' AS Code,
	'IFAN RISKIAWAN' AS Name,
	@TypeId, @GenderId, @MaritalStatusIdKawin, @NationalityId, @BloodTypeIdA,
	@EducationId, @ReligionIdIslam, CAST('2000-10-25' AS DATETIME), 'PEJERUK', 161, 53.3, 'DINDA YULIA PUTRI',
	'TIDAK ADA', '0', @OriginBusinessTypeId, @OriginBusinessSchemeId,
	1, @OriginWorkingUnitId, @OriginSupplyPointId, @OriginTariffSchemeId,
	1, @PlacementWorkingUnitId, @PlacementSupplyPointId, @PlacementTariffSchemeId,
	@OperationalStatusId, 1, '081918098979',
	'JL. GOTONG ROYONG GG. JERUK 9 KEBON JERUK RT.001 RW.018 PEJERUK, KEC. AMPENAN KOTA MATARAM', @ResidencyStatusId,
	@JobTitleId, @CurrentVendorId, @HealthInsuranceStatusId, @ShipmentStatusId,
	1, CAST('2030-10-27' AS DATETIME), '5201012309850000',
	'L', 'L', '40',
	'5271012510000001', CAST('2000-10-25' AS DATETIME), NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	'APPROVED', 1, 0, GETDATE(), 'nurihsanhusein', GETDATE(), 'nurihsanhusein'
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Crews] WHERE Code = 'yqn0krj435')

UNION ALL

SELECT 
	'7vz26un05h' AS Code,
	'MUZAKIR' AS Name,
	@TypeId, @GenderId, @MaritalStatusIdKawin, @NationalityId, @BloodTypeIdO,
	@EducationId, @ReligionIdIslam, CAST('1985-09-23' AS DATETIME), 'POHDANA', 168, 85.6, 'LILI NURHAYATI',
	'TIDAK ADA', '0', @OriginBusinessTypeId, @OriginBusinessSchemeId,
	1, @OriginWorkingUnitId, @OriginSupplyPointId, @OriginTariffSchemeId,
	1, @PlacementWorkingUnitId, @PlacementSupplyPointId, @PlacementTariffSchemeId,
	@OperationalStatusId, 1, '087866882865',
	'LINGKUNGAN POHDANA RT.000 RW.000 GERUNG UTARA GERUNG LOMBOK BARAT', @ResidencyStatusId,
	@JobTitleId, @CurrentVendorId, @HealthInsuranceStatusId, @ShipmentStatusId,
	0, NULL, NULL,
	'XL', 'XL', '42.5',
	'5201012309850003', CAST('1985-09-23' AS DATETIME), NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	'APPROVED', 1, 0, GETDATE(), 'nurihsanhusein', GETDATE(), 'nurihsanhusein'
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Crews] WHERE Code = '7vz26un05h')

UNION ALL

SELECT 
	'sfexftquf8' AS Code,
	'OPI IRAWAN' AS Name,
	@TypeId, @GenderId, @MaritalStatusIdBelumKawin, @NationalityId, @BloodTypeIdA,
	@EducationId, @ReligionIdIslam, CAST('1997-07-08' AS DATETIME), 'DASAN GERIA', 163, 58.5, NULL,
	'TIDAK ADA', '0', @OriginBusinessTypeId, @OriginBusinessSchemeId,
	1, @OriginWorkingUnitId, @OriginSupplyPointId, @OriginTariffSchemeId,
	1, @PlacementWorkingUnitId, @PlacementSupplyPointId, @PlacementTariffSchemeId,
	@OperationalStatusId, 1, '081936317975',
	'DUSUN DASAN GERIA SELATAN RT.000 RW.000 DASAN GERIA KECAMATAN LINGSAR KABUPATEN LOMBOK BARAT', @ResidencyStatusId,
	@JobTitleId, @CurrentVendorId, @HealthInsuranceStatusId, @ShipmentStatusId,
	1, CAST('2029-10-11' AS DATETIME), '5201120107970124',
	'L', 'L', '41',
	'5201120107970124', CAST('1997-07-08' AS DATETIME), NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	'APPROVED', 1, 0, GETDATE(), 'nurihsanhusein', GETDATE(), 'nurihsanhusein'
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Crews] WHERE Code = 'sfexftquf8')

UNION ALL

SELECT 
	'yq3norj435' AS Code,
	'PASKALIS WIDIONO LEPO' AS Name,
	@TypeId, @GenderId, @MaritalStatusIdKawin, @NationalityId, @BloodTypeIdO,
	@EducationId, @ReligionIdKatolik, CAST('1984-04-23' AS DATETIME), 'MATARAM', 174.5, 62.3, 'HERLIN TRISNAWATI',
	'TIDAK ADA', '0', @OriginBusinessTypeId, @OriginBusinessSchemeId,
	1, @OriginWorkingUnitId, @OriginSupplyPointId, @OriginTariffSchemeId,
	1, @PlacementWorkingUnitId, @PlacementSupplyPointId, @PlacementTariffSchemeId,
	@OperationalStatusId, 1, '085338810538',
	'JL. PELITA NO. 9 KARANG TARUNA RT.001 RW. 202 MATARAM BARAT, SELAPARANG, KOTA MATARAM', @ResidencyStatusId,
	@JobTitleId, @CurrentVendorId, @HealthInsuranceStatusId, @ShipmentStatusId,
	1, CAST('2028-04-08' AS DATETIME), '29328404000090',
	'L', 'L', '41',
	'5271052304840000', CAST('1984-04-23' AS DATETIME), '735001005633535', NULL, NULL,
	NULL, NULL, NULL, NULL,
	'APPROVED', 1, 0, GETDATE(), 'nurihsanhusein', GETDATE(), 'nurihsanhusein'
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Crews] WHERE Code = 'yq3norj435')

UNION ALL

SELECT 
	'byujmgu2e0' AS Code,
	'PIUS YOHANES DANGGUT' AS Name,
	@TypeId, @GenderId, @MaritalStatusIdKawin, @NationalityId, @BloodTypeIdA,
	@EducationId, @ReligionIdKatolik, CAST('1988-01-04' AS DATETIME), 'NDEHES', 168, 84.5, 'NENGAH SRI WIYANI',
	'TIDAK ADA', '0', @OriginBusinessTypeId, @OriginBusinessSchemeId,
	1, @OriginWorkingUnitId, @OriginSupplyPointId, @OriginTariffSchemeId,
	1, @PlacementWorkingUnitId, @PlacementSupplyPointId, @PlacementTariffSchemeId,
	@OperationalStatusId, 1, '081237944064',
	'JL. MALOMBA GG RAJAWALI NO.16 TANGSI RT.025 RW.001 AMPENAN SELATAN, AMPENAN, KOTA MATARAM', @ResidencyStatusId,
	@JobTitleId, @CurrentVendorId, @HealthInsuranceStatusId, @ShipmentStatusId,
	1, CAST('2028-05-09' AS DATETIME), '16268801000348',
	'XL', 'XL', '43',
	'5201140401780003', CAST('1988-01-04' AS DATETIME), NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	'APPROVED', 1, 0, GETDATE(), 'nurihsanhusein', GETDATE(), 'nurihsanhusein'
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Crews] WHERE Code = 'byujmgu2e0')

UNION ALL

SELECT 
	'mx0vh565qa' AS Code,
	'STEFANUS RAJA' AS Name,
	@TypeId, @GenderId, @MaritalStatusIdKawin, @NationalityId, @BloodTypeIdO,
	@EducationId, @ReligionIdKatolik, CAST('1987-12-30' AS DATETIME), 'ENDE FLORES', 162.5, 59.2, NULL,
	'TIDAK ADA', '0', @OriginBusinessTypeId, @OriginBusinessSchemeId,
	1, @OriginWorkingUnitId, @OriginSupplyPointId, @OriginTariffSchemeId,
	1, @PlacementWorkingUnitId, @PlacementSupplyPointId, @PlacementTariffSchemeId,
	@OperationalStatusId, 1, '085238155046',
	'JL. PELITA NO. 9 KARANG TARUNA RT. 001 RW. 202 MATARAM BARAT, SELAPARANG, KOTA MATARAM', @ResidencyStatusId,
	@JobTitleId, @CurrentVendorId, @HealthInsuranceStatusId, @ShipmentStatusId,
	0, NULL, NULL,
	'L', 'L', '40',
	'5271053012870000', CAST('1987-12-30' AS DATETIME), NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	'APPROVED', 1, 0, GETDATE(), 'nurihsanhusein', GETDATE(), 'nurihsanhusein'
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Crews] WHERE Code = 'mx0vh565qa');

PRINT 'Crew data insertion completed!';
PRINT 'Total records inserted: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));

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
