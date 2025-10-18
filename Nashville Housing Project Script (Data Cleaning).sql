/*=====================================================================
 Nashville Housing Data Cleaning Project
    Purpose: Standardize, enrich, and clean housing dataset
 =====================================================================*/

/*==============================================================
  1️ Populate missing PropertyAddress values
==============================================================*/
SELECT 
    NH1.ParcelID, 
    NH1.PropertyAddress, 
    NH2.ParcelID, 
    NH2.PropertyAddress,
    ISNULL(NH1.PropertyAddress, NH2.PropertyAddress) AS FilledAddress
FROM Nashville_Data..NashvilleHousing NH1
JOIN Nashville_Data..NashvilleHousing NH2 
    ON NH1.ParcelID = NH2.ParcelID
    AND NH1.UniqueID <> NH2.UniqueID
WHERE NH1.PropertyAddress IS NULL;

-- Update null PropertyAddress values using matching ParcelIDs
UPDATE NH1
SET NH1.PropertyAddress = ISNULL(NH1.PropertyAddress, NH2.PropertyAddress)
FROM Nashville_Data..NashvilleHousing NH1
JOIN Nashville_Data..NashvilleHousing NH2 
    ON NH1.ParcelID = NH2.ParcelID
    AND NH1.UniqueID <> NH2.UniqueID
WHERE NH1.PropertyAddress IS NULL;


/*==============================================================
  2️ Split PropertyAddress into individual columns (Address, City)
==============================================================*/
SELECT 
    PropertyAddress
FROM Nashville_Data..NashvilleHousing;

-- Preview split results
SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS PropertySplitAddress,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS PropertySplitCity
FROM Nashville_Data..NashvilleHousing;

-- Add new columns
ALTER TABLE Nashville_Data..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255),
    PropertySplitCity NVARCHAR(255);

-- Update columns with split values
UPDATE Nashville_Data..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

UPDATE Nashville_Data..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));


/*==============================================================
  3️ Split OwnerAddress into Address, City, and State
==============================================================*/
-- Preview split using PARSENAME (requires commas replaced with periods)
SELECT 
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerSplitAddress,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerSplitCity,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerSplitState
FROM Nashville_Data..NashvilleHousing;

-- Add new columns
ALTER TABLE Nashville_Data..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255),
    OwnerSplitCity NVARCHAR(255),
    OwnerSplitState NVARCHAR(255);

-- Populate columns
UPDATE Nashville_Data..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

UPDATE Nashville_Data..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

UPDATE Nashville_Data..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


/*==============================================================
  4️ Standardize 'SoldAsVacant' field (Y/N → Yes/No)
==============================================================*/
-- Review distinct values and counts
SELECT 
    DISTINCT(SoldAsVacant), 
    COUNT(SoldAsVacant) AS CountPerValue
FROM Nashville_Data..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant;

-- Preview transformation
SELECT 
    SoldAsVacant,
    CASE 
        WHEN SoldAsVacant = 'Y' THEN 'Yes' 
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END AS Standardized
FROM Nashville_Data..NashvilleHousing;

-- Apply transformation
UPDATE Nashville_Data..NashvilleHousing
SET SoldAsVacant = CASE 
        WHEN SoldAsVacant = 'Y' THEN 'Yes' 
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END;


/*==============================================================
  5️ Remove duplicate rows
==============================================================*/
WITH RowNumCTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                ParcelID, 
                PropertyAddress, 
                SalePrice, 
                SaleDate, 
                LegalReference
            ORDER BY UniqueID
        ) AS RowNum
    FROM Nashville_Data..NashvilleHousing
)
DELETE 
FROM RowNumCTE
WHERE RowNum > 1;


/*==============================================================
  6️ Drop unnecessary columns
==============================================================*/
SELECT * 
FROM Nashville_Data..NashvilleHousing;

ALTER TABLE Nashville_Data..NashvilleHousing
DROP COLUMN 
    OwnerAddress, 
    TaxDistrict, 
    PropertyAddress, 
    SaleDate;

/*==============================================================
  7️⃣ Update SalePrice to Remove '$' and ',' Characters
==============================================================*/

UPDATE Nashville_Data..NashvilleHousing
SET SalePrice = CASE
    -- Remove dollar sign and commas if SalePrice contains '$'
    WHEN SalePrice LIKE '%$%' THEN 
        REPLACE(
            SUBSTRING(SalePrice, CHARINDEX('$', SalePrice) + 1, LEN(SalePrice)),
            ',', 
            ''
        )
    -- Remove commas if SalePrice contains ',' but no '$'
    WHEN SalePrice LIKE '%,%' THEN 
        REPLACE(SalePrice, ',', '')
    -- Leave values that are already clean
    ELSE SalePrice
END;


