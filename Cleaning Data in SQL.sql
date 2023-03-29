SELECT *
FROM nhdata

----------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

SELECT *
FROM nhdata
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM nhdata a
JOIN nhdata b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM nhdata a
JOIN nhdata b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

----------------------------------------------------------------------------------------------------------------


---- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM nhdata
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM nhdata

ALTER TABLE nhdata
ADD PropertySplitAddress NVARCHAR(255);

UPDATE nhdata
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE nhdata
ADD PropertySplitCity NVARCHAR(255);

UPDATE nhdata
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


SELECT *
FROM nhdata




--Same with Owner Address

SELECT OwnerAddress
FROM nhdata


SELECT PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3), PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2), PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
FROM nhdata

ALTER TABLE nhdata
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE nhdata
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)

ALTER TABLE nhdata
ADD OwnerSplitCity NVARCHAR(255)

UPDATE nhdata
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)

ALTER TABLE nhdata
ADD OwnerSplitState NVARCHAR(255)

UPDATE nhdata
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)


SELECT *
FROM nhdata


----------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM nhdata
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant


SELECT SoldAsVacant, CASE 
			WHEN SoldAsVacant = 1 THEN 'Yes'
			WHEN SoldAsVacant = 0 THEN 'No'
	   END 
FROM nhdata

ALTER TABLE nhdata
ALTER COLUMN SoldAsVacant NVARCHAR(50)

UPDATE nhdata
SET SoldAsVacant = CASE WHEN SoldAsVacant = 1 THEN 'Yes'
						WHEN SoldAsVacant = 0 THEN 'No'
						ELSE SoldAsVacant
				   END

SELECT DISTINCT SoldAsVacant
FROM nhdata


----------------------------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) row_num
FROM nhdata
--ORDER BY ParcelID
) 
SELECT * 
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

----------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

SELECT *
FROM nhdata

ALTER TABLE nhdata
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
