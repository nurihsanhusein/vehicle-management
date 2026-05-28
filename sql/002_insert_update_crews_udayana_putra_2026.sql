/*
================================================================================
SCRIPT: Bulk Insert/Update Crews PT. UDAYANA PUTRA 2026
PURPOSE: Insert new crews or update existing crews with FK mapping to master data
AUTHOR: nurihsanhusein
DATE: 2026-05-28
================================================================================
NOTE: Modify the source data in section 4 with actual crew information
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
DECLARE @PreviousVendorId INT;
DECLARE @TypeId INT; -- CrewType (AMT 1 or AMT 2)
DECLARE @GenderId INT;
DECLARE @MaritalStatusId INT;
DECLARE @NationalityId INT;
DECLARE @BloodTypeId INT;
DECLARE @EducationId INT;
DECLARE @ReligionId INT;
DECLARE @OriginBusinessTypeId INT;
DECLARE @OriginBusinessSchemeId INT;
DECLARE @OriginTariffSchemeId INT;
DECLARE @PlacementTariffSchemeId INT;
DECLARE @OperationalStatusId INT;
DECLARE @ResidencyStatusId INT;
DECLARE @JobTitleId INT;
DECLARE @HealthInsuranceStatusId INT;
DECLARE @LaborInsuranceStatusId INT;
DECLARE @ShipmentStatusId INT;
DECLARE @BankId INT;
DECLARE @TankCapacityId INT;
DECLARE @BpjsHealthInsuranceStatusId INT;
DECLARE @FamilyRelationshipId INT;

-- ============================================================================
-- 2. LOOKUP MASTER DATA FROM EXISTING TABLES
-- ============================================================================

-- Locations Lookup
SELECT @OriginWorkingUnitId = ID FROM [dbo].[Locations] WHERE Code = 'MOR05'; -- JATIMBALINUS
SELECT @OriginSupplyPointId = ID FROM [dbo].[Locations] WHERE Code = '1310'; -- IT AMPENAN
SELECT @PlacementWorkingUnitId = ID FROM [dbo].[Locations] WHERE Code = 'MOR05'; -- JATIMBALINUS
SELECT @PlacementSupplyPointId = ID FROM [dbo].[Locations] WHERE Code = '1310'; -- IT AMPENAN

-- Accounts Lookup
SELECT @CurrentVendorId = ID FROM [dbo].[Accounts] WHERE Name LIKE '%REMAJA%PRIMA%';
SELECT @PreviousVendorId = ID FROM [dbo].[Accounts] WHERE Name LIKE '%REMAJA%PRIMA%';

-- Categories Lookup - CrewTypes
SELECT @TypeId = ID FROM [dbo].[CrewTypes] WHERE Code = 'AMT01'; -- AMT 1

-- Categories Lookup - Demographics
SELECT @GenderId = ID FROM [dbo].[Categories] WHERE Code = 'male'; -- Male (113)
SELECT @MaritalStatusId = ID FROM [dbo].[Categories] WHERE Code = 'Menikah'; -- Menikah
SELECT @NationalityId = ID FROM [dbo].[Categories] WHERE Code = 'WNI'; -- WNI
SELECT @BloodTypeId = ID FROM [dbo].[Categories] WHERE Code = 'O+'; -- O+ Blood Type
SELECT @EducationId = ID FROM [dbo].[Categories] WHERE Code = 'sma'; -- SMA
SELECT @ReligionId = ID FROM [dbo].[Categories] WHERE Code = 'Islam'; -- Islam

-- Categories Lookup - Business & Operational
SELECT @OriginBusinessTypeId = ID FROM [dbo].[Categories] WHERE Code = 'BT001'; -- Fleet BBM SPBU
SELECT @OriginBusinessSchemeId = ID FROM [dbo].[Categories] WHERE Code = 'BS004'; -- MT Transportir Pola Tarif
SELECT @OriginTariffSchemeId = ID FROM [dbo].[Categories] WHERE Code = 'TF003'; -- Pola Tarif
SELECT @PlacementTariffSchemeId = ID FROM [dbo].[Categories] WHERE Code = 'TF003'; -- Pola Tarif
SELECT @OperationalStatusId = ID FROM [dbo].[Categories] WHERE Code = 'PS005'; -- MT Reguler

-- Categories Lookup - Other
SELECT @ResidencyStatusId = ID FROM [dbo].[Categories] WHERE Code = 'residenStat01'; -- Milik Sendiri
SELECT @JobTitleId = ID FROM [dbo].[Categories] WHERE Code = 'AMT01'; -- AMT 1
SELECT @HealthInsuranceStatusId = ID FROM [dbo].[Categories] WHERE Code = 'INS01'; -- Aktif
SELECT @LaborInsuranceStatusId = ID FROM [dbo].[Categories] WHERE Code = 'INS01'; -- Aktif
SELECT @ShipmentStatusId = ID FROM [dbo].[Categories] WHERE Code = 'SH001'; -- Tersedia
SELECT @BankId = ID FROM [dbo].[Categories] WHERE Code = 'BNK03'; -- BRI
SELECT @TankCapacityId = ID FROM [dbo].[Categories] WHERE Code = 'TNC10'; -- 10 KL
SELECT @BpjsHealthInsuranceStatusId = ID FROM [dbo].[Categories] WHERE Code = 'INS01'; -- Aktif
SELECT @FamilyRelationshipId = ID FROM [dbo].[Categories] WHERE Code = 'FR001'; -- Orang Tua

-- ============================================================================
-- 3. VALIDATION - Display lookup results
-- ============================================================================
PRINT '========== CREW LOOKUP RESULTS ==========';
PRINT 'OriginSupplyPointId: ' + ISNULL(CAST(@OriginSupplyPointId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'PlacementSupplyPointId: ' + ISNULL(CAST(@PlacementSupplyPointId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'CurrentVendorId: ' + ISNULL(CAST(@CurrentVendorId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'TypeId (CrewType): ' + ISNULL(CAST(@TypeId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'GenderId: ' + ISNULL(CAST(@GenderId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'JobTitleId: ' + ISNULL(CAST(@JobTitleId AS NVARCHAR(10)), 'NOT FOUND');
PRINT '========================================';

-- ============================================================================
-- 4. MERGE STATEMENT - UPSERT CREWS
-- ============================================================================

MERGE INTO [dbo].[Crews] AS TARGET
USING (
	SELECT 
		'AMT-UDAYANA-001' AS Code,
		'Nama Crew 1' AS Name,
		CAST('1990-01-15' AS DATETIME) AS BirthDate,
		'Surabaya' AS BirthPlace,
		175 AS Height,
		75 AS Weight,
		'Istri Crew 1' AS SpouseName,
		NULL AS MedicalHistory,
		'FP001' AS FingerprintCode,
		NULL AS Picture,
		'CREW001' AS IdCardNumber,
		CAST('2024-01-01' AS DATETIME) AS IdCardValidSince,
		'12-345-678-901-001' AS TaxIdNumber,
		'TK.12345678901' AS HealthInsuranceNumber,
		'JKN.TK.12345678' AS LaborInsuranceNumber,
		'Bank Rakyat Indonesia' AS BankName,
		'Cabang Surabaya' AS BankBranchName,
		'Nama Crew 1' AS BankAccountName,
		'1234567890123456' AS BankAccountNumber,
		'M' AS PpePantsSize,
		'L' AS PpeShirtSize,
		'42' AS PpeShoeSize,
		CAST(1 AS BIT) AS DriverLicenseB,
		CAST('2026-12-31' AS DATETIME) AS DriverLicenseBExpiryDate,
		'1234 BJ 5678' AS DriverLicenseBNumber,
		'0812345678' AS PhoneMobile,
		'Jl. Raya Surabaya No. 100' AS ResidencyAddress,
		'2024-04-05' AS JobStartDate,
		5 AS ServicePeriodYear,
		6 AS ServicePeriodMonth,
		15 AS ServicePeriodDay,
		'BPJS.0001' AS BpjsHealthInsuranceNumber
	-- Add more crew records as needed
) AS SOURCE (
	Code, Name, BirthDate, BirthPlace, Height, Weight, SpouseName, 
	MedicalHistory, FingerprintCode, Picture, IdCardNumber, IdCardValidSince,
	TaxIdNumber, HealthInsuranceNumber, LaborInsuranceNumber, BankName,
	BankBranchName, BankAccountName, BankAccountNumber, PpePantsSize,
	PpeShirtSize, PpeShoeSize, DriverLicenseB, DriverLicenseBExpiryDate,
	DriverLicenseBNumber, PhoneMobile, ResidencyAddress, JobStartDate,
	ServicePeriodYear, ServicePeriodMonth, ServicePeriodDay, BpjsHealthInsuranceNumber
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
		TARGET.[IdCardNumber] = ISNULL(TARGET.[IdCardNumber], SOURCE.[IdCardNumber]),
		TARGET.[IdCardValidSince] = ISNULL(TARGET.[IdCardValidSince], SOURCE.[IdCardValidSince]),
		TARGET.[TaxIdNumber] = ISNULL(TARGET.[TaxIdNumber], SOURCE.[TaxIdNumber]),
		TARGET.[HealthInsuranceNumber] = ISNULL(TARGET.[HealthInsuranceNumber], SOURCE.[HealthInsuranceNumber]),
		TARGET.[LaborInsuranceNumber] = ISNULL(TARGET.[LaborInsuranceNumber], SOURCE.[LaborInsuranceNumber]),
		TARGET.[BankName] = ISNULL(TARGET.[BankName], SOURCE.[BankName]),
		TARGET.[BankBranchName] = ISNULL(TARGET.[BankBranchName], SOURCE.[BankBranchName]),
		TARGET.[BankAccountName] = ISNULL(TARGET.[BankAccountName], SOURCE.[BankAccountName]),
		TARGET.[BankAccountNumber] = ISNULL(TARGET.[BankAccountNumber], SOURCE.[BankAccountNumber]),
		TARGET.[PpePantsSize] = ISNULL(TARGET.[PpePantsSize], SOURCE.[PpePantsSize]),
		TARGET.[PpeShirtSize] = ISNULL(TARGET.[PpeShirtSize], SOURCE.[PpeShirtSize]),
		TARGET.[PpeShoeSize] = ISNULL(TARGET.[PpeShoeSize], SOURCE.[PpeShoeSize]),
		TARGET.[DriverLicenseB] = ISNULL(TARGET.[DriverLicenseB], SOURCE.[DriverLicenseB]),
		TARGET.[DriverLicenseBExpiryDate] = ISNULL(TARGET.[DriverLicenseBExpiryDate], SOURCE.[DriverLicenseBExpiryDate]),
		TARGET.[DriverLicenseBNumber] = ISNULL(TARGET.[DriverLicenseBNumber], SOURCE.[DriverLicenseBNumber]),
		TARGET.[PhoneMobile] = ISNULL(TARGET.[PhoneMobile], SOURCE.[PhoneMobile]),
		TARGET.[ResidencyAddress] = ISNULL(TARGET.[ResidencyAddress], SOURCE.[ResidencyAddress]),
		TARGET.[JobStartDate] = ISNULL(TARGET.[JobStartDate], SOURCE.[JobStartDate]),
		TARGET.[ServicePeriodYear] = ISNULL(TARGET.[ServicePeriodYear], SOURCE.[ServicePeriodYear]),
		TARGET.[ServicePeriodMonth] = ISNULL(TARGET.[ServicePeriodMonth], SOURCE.[ServicePeriodMonth]),
		TARGET.[ServicePeriodDay] = ISNULL(TARGET.[ServicePeriodDay], SOURCE.[ServicePeriodDay]),
		TARGET.[BpjsHealthInsuranceNumber] = ISNULL(TARGET.[BpjsHealthInsuranceNumber], SOURCE.[BpjsHealthInsuranceNumber]),
		TARGET.[Status] = 'APPROVED',
		TARGET.[ModifiedAt] = GETDATE(),
		TARGET.[ModifiedBy] = 'nurihsanhusein'

WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		[Code],
		[Name],
		[TypeId],
		[GenderId],
		[MaritalStatusId],
		[NationalityId],
		[BloodTypeId],
		[EducationId],
		[ReligionId],
		[BirthDate],
		[BirthPlace],
		[Height],
		[Weight],
		[SpouseName],
		[MedicalHistory],
		[FingerprintCode],
		[Picture],
		[OriginBusinessTypeId],
		[OriginBusinessSchemeId],
		[OriginIsActive],
		[OriginWorkingUnitId],
		[OriginSupplyPointId],
		[OriginTariffSchemeId],
		[PlacementIsActive],
		[PlacementWorkingUnitId],
		[PlacementSupplyPointId],
		[PlacementTariffSchemeId],
		[OperationalStatusId],
		[OperationalIsActive],
		[PhoneMobile],
		[ResidencyAddress],
		[ResidencyStatusId],
		[JobTitleId],
		[JobStartDate],
		[CurrentVendorId],
		[PreviousVendorId],
		[ServicePeriodYear],
		[ServicePeriodMonth],
		[ServicePeriodDay],
		[IdCardNumber],
		[IdCardValidSince],
		[TaxIdNumber],
		[HealthInsuranceNumber],
		[HealthInsuranceStatusId],
		[LaborInsuranceNumber],
		[LaborInsuranceStatusId],
		[BankName],
		[BankBranchName],
		[BankAccountName],
		[BankAccountNumber],
		[PpePantsSize],
		[PpeShirtSize],
		[PpeShoeSize],
		[DriverLicenseB],
		[DriverLicenseBExpiryDate],
		[DriverLicenseBNumber],
		[BpjsHealthInsuranceNumber],
		[BpjsHealthInsuranceStatusId],
		[Status],
		[IsActive],
		[IsDeleted],
		[CreatedAt],
		[CreatedBy],
		[ModifiedAt],
		[ModifiedBy]
	)
	VALUES (
		SOURCE.[Code],
		SOURCE.[Name],
		@TypeId,
		@GenderId,
		@MaritalStatusId,
		@NationalityId,
		@BloodTypeId,
		@EducationId,
		@ReligionId,
		SOURCE.[BirthDate],
		SOURCE.[BirthPlace],
		SOURCE.[Height],
		SOURCE.[Weight],
		SOURCE.[SpouseName],
		SOURCE.[MedicalHistory],
		SOURCE.[FingerprintCode],
		SOURCE.[Picture],
		@OriginBusinessTypeId,
		@OriginBusinessSchemeId,
		1,
		@OriginWorkingUnitId,
		@OriginSupplyPointId,
		@OriginTariffSchemeId,
		1,
		@PlacementWorkingUnitId,
		@PlacementSupplyPointId,
		@PlacementTariffSchemeId,
		@OperationalStatusId,
		1,
		SOURCE.[PhoneMobile],
		SOURCE.[ResidencyAddress],
		@ResidencyStatusId,
		@JobTitleId,
		SOURCE.[JobStartDate],
		@CurrentVendorId,
		@PreviousVendorId,
		SOURCE.[ServicePeriodYear],
		SOURCE.[ServicePeriodMonth],
		SOURCE.[ServicePeriodDay],
		SOURCE.[IdCardNumber],
		SOURCE.[IdCardValidSince],
		SOURCE.[TaxIdNumber],
		SOURCE.[HealthInsuranceNumber],
		@HealthInsuranceStatusId,
		SOURCE.[LaborInsuranceNumber],
		@LaborInsuranceStatusId,
		SOURCE.[BankName],
		SOURCE.[BankBranchName],
		SOURCE.[BankAccountName],
		SOURCE.[BankAccountNumber],
		SOURCE.[PpePantsSize],
		SOURCE.[PpeShirtSize],
		SOURCE.[PpeShoeSize],
		SOURCE.[DriverLicenseB],
		SOURCE.[DriverLicenseBExpiryDate],
		SOURCE.[DriverLicenseBNumber],
		SOURCE.[BpjsHealthInsuranceNumber],
		@BpjsHealthInsuranceStatusId,
		'APPROVED',
		1,
		0,
		GETDATE(),
		'nurihsanhusein',
		GETDATE(),
		'nurihsanhusein'
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
	[BankAccountNumber],
	[JobStartDate],
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
	LOC_Origin.[Name] AS OriginLocation,
	LOC_Placement.[Name] AS PlacementLocation,
	CAT_JobTitle.[Name] AS JobTitle
FROM [dbo].[Crews] C
LEFT JOIN [dbo].[CrewTypes] CT ON C.[TypeId] = CT.[Id]
LEFT JOIN [dbo].[Accounts] A_Vendor ON C.[CurrentVendorId] = A_Vendor.[Id]
LEFT JOIN [dbo].[Categories] CAT_Gender ON C.[GenderId] = CAT_Gender.[Id]
LEFT JOIN [dbo].[Categories] CAT_Education ON C.[EducationId] = CAT_Education.[Id]
LEFT JOIN [dbo].[Locations] LOC_Origin ON C.[OriginSupplyPointId] = LOC_Origin.[Id]
LEFT JOIN [dbo].[Locations] LOC_Placement ON C.[PlacementSupplyPointId] = LOC_Placement.[Id]
LEFT JOIN [dbo].[Categories] CAT_JobTitle ON C.[JobTitleId] = CAT_JobTitle.[Id]
WHERE C.[CreatedBy] = 'nurihsanhusein'
ORDER BY C.[CreatedAt] DESC;
*/
