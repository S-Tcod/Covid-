-- CLEANING DATA

-- Standardizing date 

SELECT SaleDatecovertede , CONVERT(Date,SaleDate) 
FROM ProfolioProject..nashvillehouse


UPDATE ProfolioProject..nashvillehouse
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE ProfolioProject..nashvillehouse
ADD SaleDateconvertede Date;
UPDATE ProfolioProject..nashvillehouse
SET SaleDatecovertede = CONVERT(Date,SaleDate)

-- populate the Property adress
SELECT *
FROM ProfolioProject..nashvillehouse
--WHERE PropertyAddress is null
ORDER BY ParcelID 

SELECT a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM ProfolioProject..nashvillehouse a
JOIN  ProfolioProject..nashvillehouse b
  ON a.ParcelID =b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM ProfolioProject..nashvillehouse a
JOIN  ProfolioProject..nashvillehouse b
  ON a.ParcelID =b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


-- Breaking out addresses into individual colums ( Addresses,city, state)

SELECT PropertyAddress
FROM ProfolioProject..nashvillehouse
--WHERE PropertyAddress is null
--ORDER BY ParcelID 

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS address
, SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS address

FROM ProfolioProject..nashvillehouse


ALTER TABLE ProfolioProject..nashvillehouse
ADD propertysplitaddress nvarchar(255);
UPDATE ProfolioProject..nashvillehouse
SET propertysplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE ProfolioProject..nashvillehouse
ADD propertysplitcity nvarchar(255);
UPDATE ProfolioProject..nashvillehouse
SET propertysplitcity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 

SELECT *
FROM ProfolioProject..nashvillehouse

SELECT OwnerAddress
FROM ProfolioProject..nashvillehouse
WHERE OwnerAddress is not null

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', ','),3)
, PARSENAME(REPLACE(OwnerAddress, ',', ','),2)
, PARSENAME(REPLACE(OwnerAddress, ',', ','),1)
FROM ProfolioProject..nashvillehouse
WHERE OwnerAddress is not null

ALTER TABLE ProfolioProject..nashvillehouse
ADD ownersplitaddress nvarchar(255);
UPDATE ProfolioProject..nashvillehouse
SET ownersplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE ProfolioProject..nashvillehouse
ADD ownersplitcity nvarchar(255);
UPDATE ProfolioProject..nashvillehouse
SET ownersplitcity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 

ALTER TABLE ProfolioProject..nashvillehouse
ADD statesplitaddress nvarchar(255);
UPDATE ProfolioProject..nashvillehouse
SET statesplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


SELECT *
FROM ProfolioProject..nashvillehouse

-- change Y and N into sold as yes and no

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM ProfolioProject..nashvillehouse
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
       ELSE SoldAsVacant
           END
fROM ProfolioProject..nashvillehouse

UPDATE ProfolioProject..nashvillehouse
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
       ELSE SoldAsVacant
           END


-- removing Duplicates
WITH rownumcte AS
(
SELECT *,
      ROW_NUMBER() OVER (PARTITION BY ParcelID,
                                      PropertyAddress,
									  SalePrice,
									  LegalReference
									  ORDER BY
									     UniqueID
										 ) row_num
FROM ProfolioProject..nashvillehouse
--ORDER BY ParcelID
)

DELETE 
FROM rownumcte
WHERE row_num > 1
--ORDER BY PropertyAddress


-- DELETE Columns
SELECT *
FROM ProfolioProject..nashvillehouse

ALTER TABLE ProfolioProject..nashvillehouse
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE ProfolioProject..nashvillehouse
DROP COLUMN SaleDate