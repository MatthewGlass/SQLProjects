/*==============================================================
  1️ Least 20 Sale Prices
==============================================================*/
SELECT TOP 20 
    SalePrice, 
    LandUse
FROM Nashville_Data..NashvilleHousing
WHERE SalePrice IS NOT NULL
ORDER BY SalePrice ASC;  -- ASC to get the lowest prices first


/*==============================================================
  2️ Top 10 Streets with the Most Properties Sold
==============================================================*/

-- Step 1: Extract street names from PropertySplitAddress
WITH StreetNames AS (
    SELECT 
        UniqueId, 
        -- Extract everything after the first space to get the street name
        SUBSTRING(PropertySplitAddress, CHARINDEX(' ', PropertySplitAddress), LEN(PropertySplitAddress)) AS StreetName
    FROM Nashville_Data..NashvilleHousing
)

-- Step 2: Count properties per street and get the top 10
SELECT TOP 10 
    StreetName, 
    COUNT(*) AS NumberOfProperties
FROM StreetNames
GROUP BY StreetName
ORDER BY NumberOfProperties DESC;  -- DESC to show streets with most properties first


/*==============================================================
  3 Owners That Sold Multiple Properties
==============================================================*/

-- Count the number of properties sold per owner
-- Only include owners who have sold more than one property
-- Exclude rows where OwnerName is NULL
SELECT 
    OwnerName, 
    COUNT(*) AS TotalHousesSold
FROM Nashville_Data..NashvilleHousing
WHERE OwnerName IS NOT NULL
GROUP BY OwnerName
HAVING COUNT(*) > 1  -- Filter to owners with more than 1 property sold
ORDER BY TotalHousesSold DESC;  -- Show the most active owners first


/*==============================================================
  4 Average Sale Price for Single Family Homes
==============================================================*/

-- Calculate the average sale price for properties with LandUse = 'Single Family'
-- Round the result to 2 decimal places using CAST
SELECT 
    LandUse, 
    CAST(
        AVG(CAST(SalePrice AS DECIMAL(12,3))) AS DECIMAL(12,2)
    ) AS AveragePrice
FROM Nashville_Data..NashvilleHousing
WHERE LandUse = 'Single Family'
GROUP BY LandUse;
