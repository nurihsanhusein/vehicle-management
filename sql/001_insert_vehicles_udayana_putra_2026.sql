/*
================================================================================
SCRIPT: Bulk Insert Vehicles PT. UDAYANA PUTRA 2026
PURPOSE: Insert 10 HINO vehicles with complete FK mapping to master data
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
DECLARE @OperationalWorkingUnitId INT;
DECLARE @OperationalSupplyPointId INT;
DECLARE @OwnerId INT;
DECLARE @VendorId INT;
DECLARE @PrincipalId INT;
DECLARE @GradeId INT;
DECLARE @CategoryId INT;
DECLARE @BusinessTypeId INT;
DECLARE @BusinessSchemeId INT;
DECLARE @BrakeSystemId INT;
DECLARE @AxleConfigurationId INT;
DECLARE @OperationalTypeId INT;
DECLARE @TariffSchemeId INT;
DECLARE @TireClassId INT;
DECLARE @BodyWorkId INT;
DECLARE @TankCapacityId INT;
DECLARE @MainTankMeasureId INT;
DECLARE @TypeIdEngkel INT;
DECLARE @TypeIdTronton INT;

-- ============================================================================
-- 2. LOOKUP MASTER DATA FROM EXISTING TABLES
-- ============================================================================

-- Locations Lookup
SELECT @OriginWorkingUnitId = ID FROM [dbo].[Locations] WHERE Code = 'MOR05'; -- JATIMBALINUS
SELECT @OriginSupplyPointId = ID FROM [dbo].[Locations] WHERE Code = '1310'; -- IT AMPENAN
SELECT @OperationalWorkingUnitId = ID FROM [dbo].[Locations] WHERE Code = 'MOR05'; -- JATIMBALINUS
SELECT @OperationalSupplyPointId = ID FROM [dbo].[Locations] WHERE Code = '1310'; -- IT AMPENAN

-- Accounts Lookup with LIKE for flexible matching
SELECT @OwnerId = ID FROM [dbo].[Accounts] WHERE Name LIKE '%UDAYANA%PUTRA%';
SELECT @VendorId = ID FROM [dbo].[Accounts] WHERE Name LIKE '%REMAJA%PRIMA%';
SELECT @PrincipalId = ID FROM [dbo].[Accounts] WHERE Name LIKE '%UDAYANA%PUTRA%';

-- Categories Lookup
SELECT @GradeId = ID FROM [dbo].[Categories] WHERE Code = 'VG001'; -- GRADE ATAS
SELECT @CategoryId = ID FROM [dbo].[Categories] WHERE Code = 'VCT03'; -- CATEGORY 3 (BBM)
SELECT @BusinessTypeId = ID FROM [dbo].[Categories] WHERE Code = 'BT001'; -- Fleet BBM/BBK
SELECT @BusinessSchemeId = ID FROM [dbo].[Categories] WHERE Code = 'BS004'; -- MT Transportir Pola Tarif
SELECT @BrakeSystemId = ID FROM [dbo].[Categories] WHERE Code = 'BRS01'; -- FAB
SELECT @AxleConfigurationId = ID FROM [dbo].[Categories] WHERE Code = 'AXC01'; -- SINGLE GARDAN
SELECT @OperationalTypeId = ID FROM [dbo].[Categories] WHERE Code = 'PT001'; -- MT Reguler
SELECT @TariffSchemeId = ID FROM [dbo].[Categories] WHERE Code = 'TF003'; -- Pola Tarif
SELECT @TireClassId = ID FROM [dbo].[Categories] WHERE Code = 'TC003'; -- Heavy Truck Tyres
SELECT @BodyWorkId = ID FROM [dbo].[Categories] WHERE Name LIKE '%REMAJA%PRIMA%';
SELECT @TankCapacityId = ID FROM [dbo].[Categories] WHERE Code = 'TNC10'; -- 10 KL
SELECT @MainTankMeasureId = ID FROM [dbo].[Categories] WHERE Code = 'KL'; -- KL (KILOMETER)

-- VehicleTypes Lookup - Use exact Code/Name matching
SELECT @TypeIdEngkel = ID FROM [dbo].[VehicleTypes] WHERE Code = 'VT006'; -- Engkel (ID = 6)
SELECT @TypeIdTronton = ID FROM [dbo].[VehicleTypes] WHERE Code = 'VT005'; -- Tronton (ID = 5)

-- ============================================================================
-- 3. VALIDATION - Display lookup results
-- ============================================================================
PRINT '========== LOOKUP RESULTS ==========';
PRINT 'OriginWorkingUnitId: ' + ISNULL(CAST(@OriginWorkingUnitId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'OriginSupplyPointId: ' + ISNULL(CAST(@OriginSupplyPointId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'OwnerId: ' + ISNULL(CAST(@OwnerId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'VendorId: ' + ISNULL(CAST(@VendorId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'GradeId: ' + ISNULL(CAST(@GradeId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'CategoryId: ' + ISNULL(CAST(@CategoryId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'BusinessTypeId: ' + ISNULL(CAST(@BusinessTypeId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'BodyWorkId: ' + ISNULL(CAST(@BodyWorkId AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'TypeIdEngkel (VT006): ' + ISNULL(CAST(@TypeIdEngkel AS NVARCHAR(10)), 'NOT FOUND');
PRINT 'TypeIdTronton (VT005): ' + ISNULL(CAST(@TypeIdTronton AS NVARCHAR(10)), 'NOT FOUND');
PRINT '====================================';

-- ============================================================================
-- 4. MERGE STATEMENT - UPSERT VEHICLES
-- ============================================================================

MERGE INTO [dbo].[Vehicles] AS TARGET
USING (
	SELECT 
		'DR 8593 AF' AS Code,
		'DR 8593 AF' AS LicensePlate,
		'HINO' AS BrandName,
		'W04DTRR-33274' AS EngineSerialNumber,
		'MJECIJG43G5139582' AS ChassisSerialNumber,
		CAST('2016-04-05' AS DATETIME) AS ManufactureDate,
		'9 tahun, 9 bulan, 11 hari' AS VehicleAge,
		0.25 AS OwnUseRatio,
		100 AS FuelTankCapacity,
		8 AS OilTankCapacity,
		5 AS MainTankCapacity,
		1 AS MainTankCompartmentCount,
		5 AS SealCapCount,
		1 AS SpareTireCount,
		1 AS HeadTruckChange,
		1 AS CompensatorFifthWheel,
		'ENGKEL' AS VehicleTypeCategory
	UNION ALL
	SELECT 'DR 8352 AR', 'DR 8352 AR', 'HINO', 'J08EUGJ75722', 'MJEFG8JJ1KJ813650', CAST('2019-01-17' AS DATETIME), '7 tahun, 23 hari', 0.35, 200, 13, 10, 2, 13, 1, 1, 1, 'ENGKEL'
	UNION ALL
	SELECT 'L 8170 UUD', 'L 8170 UUD', 'HINO', 'J08EWEJ11081', 'MJEFL8JN2NJP10109', CAST('2017-07-19' AS DATETIME), '8 tahun, 4 bulan, 26 hari', 0.4, 200, 13, 16, 2, 13, 1, 1, 1, 'TRONTON'
	UNION ALL
	SELECT 'L 8184 UT', 'L 8184 UT', 'HINO', 'N04CWYJ24251', 'MJECCB2F8P5014179', CAST('2023-09-30' AS DATETIME), '2 tahun, 6 bulan, 11 hari', 0.4, 200, 13, 5, 1, 13, 1, 1, 1, 'ENGKEL'
	UNION ALL
	SELECT 'L 8169 UUD', 'L 8169 UUD', 'HINO', 'N04CWYJ13228', 'MJECCB2F6N5003632', CAST('2022-12-29' AS DATETIME), '4 tahun, 1 bulan, 12 hari', 0.25, 100, 8, 5, 1, 8, 1, 1, 1, 'ENGKEL'
	UNION ALL
	SELECT 'L 8188 UT', 'L 8188 UT', 'HINO', 'J08EWEJ16751', 'MJEFL8JN2PJP10601', CAST('2023-09-30' AS DATETIME), '2 tahun, 6 bulan, 11 hari', 0.4, 200, 13, 16, 2, 13, 1, 1, 1, 'TRONTON'
	UNION ALL
	SELECT 'DR 8656 AH', 'DR 8656 AH', 'HINO', 'JD8EWMJ10590', 'MJEFG8JK1LJJ11217', CAST('2020-03-12' AS DATETIME), '5 Tahun, 2 bulan, 11 hari', 0.35, 200, 13, 10, 2, 13, 1, 1, 1, 'ENGKEL'
	UNION ALL
	SELECT 'L 8171 UUD', 'L 8171 UUD', 'HINO', 'N04CWYJ13377', 'MJECCB2F2N5003806', CAST('2022-12-29' AS DATETIME), '4 Tahun, 1 bulan 11 hari', 0.25, 100, 8, 5, 1, 8, 1, 1, 1, 'ENGKEL'
	UNION ALL
	SELECT 'DR 8592 AF', 'DR 8592 AF', 'HINO', 'W04DTRR-33275', 'MJEC1JG43G5-139581', CAST('2016-04-05' AS DATETIME), '9 tahun, 9 bulan, 11 hari', 0.25, 100, 8, 5, 1, 8, 1, 1, 1, 'ENGKEL'
	UNION ALL
	SELECT 'DR 8591 AF', 'DR 8591 AF', 'HINO', 'W04DTRR-33273', 'MJEC1JG43G5-139583', CAST('2016-04-05' AS DATETIME), '9 tahun, 9 bulan, 11 hari', 0.25, 100, 8, 5, 1, 8, 1, 1, 1, 'ENGKEL'
) AS SOURCE
ON TARGET.[LicensePlate] = SOURCE.[LicensePlate]

WHEN MATCHED THEN
	UPDATE SET
		[Name] = ISNULL([Name], SOURCE.[Code]),
		[BrandName] = ISNULL([BrandName], SOURCE.[BrandName]),
		[EngineSerialNumber] = ISNULL([EngineSerialNumber], SOURCE.[EngineSerialNumber]),
		[ChassisSerialNumber] = ISNULL([ChassisSerialNumber], SOURCE.[ChassisSerialNumber]),
		[ManufactureDate] = ISNULL([ManufactureDate], SOURCE.[ManufactureDate]),
		[VehicleAge] = ISNULL([VehicleAge], SOURCE.[VehicleAge]),
		[OwnUseRatio] = ISNULL([OwnUseRatio], CAST(SOURCE.[OwnUseRatio] AS NVARCHAR(100))),
		[FuelTankCapacity] = ISNULL([FuelTankCapacity], SOURCE.[FuelTankCapacity]),
		[OilTankCapacity] = ISNULL([OilTankCapacity], SOURCE.[OilTankCapacity]),
		[MainTankCapacity] = ISNULL([MainTankCapacity], SOURCE.[MainTankCapacity]),
		[MainTankCompartmentCount] = ISNULL([MainTankCompartmentCount], SOURCE.[MainTankCompartmentCount]),
		[SealCapCount] = ISNULL([SealCapCount], SOURCE.[SealCapCount]),
		[SpareTireCount] = ISNULL([SpareTireCount], SOURCE.[SpareTireCount]),
		[HeadTruckChange] = ISNULL([HeadTruckChange], SOURCE.[HeadTruckChange]),
		[CompensatorFifthWheel] = ISNULL([CompensatorFifthWheel], SOURCE.[CompensatorFifthWheel]),
		[Status] = 'APPROVED',
		[ModifiedAt] = GETDATE(),
		[ModifiedBy] = 'nurihsanhusein'

WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		[Code],
		[Name],
		[LicensePlate],
		[BrandName],
		[BrandType],
		[EngineSerialNumber],
		[ChassisSerialNumber],
		[ManufactureDate],
		[VehicleAge],
		[OwnUseRatio],
		[FuelTankCapacity],
		[OilTankCapacity],
		[MainTankCapacity],
		[MainTankCompartmentCount],
		[SealCapCount],
		[SpareTireCount],
		[HeadTruckChange],
		[CompensatorFifthWheel],
		[TypeId],
		[OperationalStatusId],
		[OperationalTypeId],
		[OriginWorkingUnitId],
		[OriginSupplyPointId],
		[OriginIsActive],
		[OperationalWorkingUnitId],
		[OperationalSupplyPointId],
		[OperationalIsActive],
		[AssignedWorkingUnitId],
		[AssignedSupplyPointId],
		[OwnerId],
		[VendorId],
		[PrincipalId],
		[GradeId],
		[CategoryId],
		[BusinessTypeId],
		[BusinessSchemeId],
		[BrakeSystemId],
		[AxleConfigurationId],
		[TariffSchemeId],
		[TireClassId],
		[BodyWorkId],
		[MainTankMeasureId],
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
		SOURCE.[Code],
		SOURCE.[LicensePlate],
		SOURCE.[BrandName],
		SOURCE.[BrandName],
		SOURCE.[EngineSerialNumber],
		SOURCE.[ChassisSerialNumber],
		SOURCE.[ManufactureDate],
		SOURCE.[VehicleAge],
		CAST(SOURCE.[OwnUseRatio] AS NVARCHAR(100)),
		SOURCE.[FuelTankCapacity],
		SOURCE.[OilTankCapacity],
		SOURCE.[MainTankCapacity],
		SOURCE.[MainTankCompartmentCount],
		SOURCE.[SealCapCount],
		SOURCE.[SpareTireCount],
		SOURCE.[HeadTruckChange],
		SOURCE.[CompensatorFifthWheel],
		CASE WHEN SOURCE.[VehicleTypeCategory] = 'ENGKEL' THEN @TypeIdEngkel ELSE @TypeIdTronton END,
		(SELECT ID FROM [dbo].[Categories] WHERE Code = 'PS005'), -- MT Reguler
		@OperationalTypeId,
		@OriginWorkingUnitId,
		@OriginSupplyPointId,
		1,
		@OperationalWorkingUnitId,
		@OperationalSupplyPointId,
		1,
		@OperationalWorkingUnitId,
		@OperationalSupplyPointId,
		@OwnerId,
		@VendorId,
		@PrincipalId,
		@GradeId,
		@CategoryId,
		@BusinessTypeId,
		@BusinessSchemeId,
		@BrakeSystemId,
		@AxleConfigurationId,
		@TariffSchemeId,
		@TireClassId,
		@BodyWorkId,
		@MainTankMeasureId,
		'APPROVED',
		1,
		0,
		GETDATE(),
		'nurihsanhusein',
		GETDATE(),
		'nurihsanhusein'
	);

PRINT 'Vehicle data merge completed successfully!';
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
-- Verify inserted vehicles
SELECT 
	[Code],
	[LicensePlate],
	[BrandName],
	[VehicleAge],
	[FuelTankCapacity],
	[MainTankCapacity],
	[Status],
	[CreatedBy],
	[CreatedAt]
FROM [dbo].[Vehicles]
WHERE [CreatedBy] = 'nurihsanhusein' 
	AND [Status] = 'APPROVED'
	AND [LicensePlate] IN (
		'DR 8593 AF', 'DR 8352 AR', 'L 8170 UUD', 'L 8184 UT', 'L 8169 UUD',
		'L 8188 UT', 'DR 8656 AH', 'L 8171 UUD', 'DR 8592 AF', 'DR 8591 AF'
	)
ORDER BY [CreatedAt] DESC;

-- Verify FK relationships
SELECT 
	V.[Code],
	V.[LicensePlate],
	A_Owner.[Name] AS OwnerName,
	A_Vendor.[Name] AS VendorName,
	L_Origin.[Name] AS OriginLocation,
	L_Operational.[Name] AS OperationalLocation,
	C_Grade.[Name] AS Grade,
	C_Category.[Name] AS Category,
	VT.[Name] AS VehicleType
FROM [dbo].[Vehicles] V
LEFT JOIN [dbo].[Accounts] A_Owner ON V.[OwnerId] = A_Owner.[Id]
LEFT JOIN [dbo].[Accounts] A_Vendor ON V.[VendorId] = A_Vendor.[Id]
LEFT JOIN [dbo].[Locations] L_Origin ON V.[OriginSupplyPointId] = L_Origin.[Id]
LEFT JOIN [dbo].[Locations] L_Operational ON V.[OperationalSupplyPointId] = L_Operational.[Id]
LEFT JOIN [dbo].[Categories] C_Grade ON V.[GradeId] = C_Grade.[Id]
LEFT JOIN [dbo].[Categories] C_Category ON V.[CategoryId] = C_Category.[Id]
LEFT JOIN [dbo].[VehicleTypes] VT ON V.[TypeId] = VT.[Id]
WHERE V.[CreatedBy] = 'nurihsanhusein'
ORDER BY V.[CreatedAt] DESC;
*/
