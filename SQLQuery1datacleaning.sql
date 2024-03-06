----Cleaning Data In SQL Queries.




-----Standardize Date Format

SELECT SaleDate, CONVERT(Date,SaleDate) 
FROM dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate) 

ALTER TABLE NashvilleHousing 
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


SELECT SaleDateConverted 
FROM dbo.NashvilleHousing


------POPULATE PROPERTY ADDRESS DATA
SELECT PropertyAddress 
FROM dbo.NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT * 
FROM dbo.NashvilleHousing
ORDER BY ParcelID


SELECT  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
 ON a.ParcelID  = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 WHERE a.PropertyAddress IS NULL

 UPDATE a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
 ON a.ParcelID  = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 WHERE a.PropertyAddress IS NULL

 SELECT ParcelID, PropertyAddress
 FROM dbo.NashvilleHousing


 -----BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS(ADDRESS,CITY,STATE)
SELECT PropertyAddress
 FROM dbo.NashvilleHousing


 SELECT
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address
 FROM dbo.NashvilleHousing

 SELECT
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address,
 CHARINDEX(',', PropertyAddress)
 FROM dbo.NashvilleHousing

 SELECT
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
 FROM dbo.NashvilleHousing


SELECT
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 ,LEN (PropertyAddress)) AS Address
 FROM dbo.NashvilleHousing

 

ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing 
ADD PropertySplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 ,LEN (PropertyAddress)) 


SELECT *
FROM dbo.NashvilleHousing


 SELECT OwnerAddress
FROM dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.') , 3),
PARSENAME(REPLACE(OwnerAddress,',','.') , 2),
PARSENAME(REPLACE(OwnerAddress,',','.') , 1)
FROM dbo.NashvilleHousing

ALTER TABLE NashvilleHousing 
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') , 3)

ALTER TABLE NashvilleHousing 
ADD OwnerSplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress,',','.') , 2)

ALTER TABLE NashvilleHousing 
ADD OwnerSplitState Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress,',','.') , 1)

SELECT *
FROM dbo.NashvilleHousing


----CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD


SELECT DISTINCT (SoldAsVacant)
FROM dbo.NashvilleHousing


SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM dbo.NashvilleHousing


SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


------REMOVE DUPLICATES

SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY
			     UniqueID
				 )row_num

FROM dbo.NashvilleHousing
ORDER BY ParcelID

WITH RowNumCTE AS(
SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY
			     UniqueID
				 )row_num

FROM dbo.NashvilleHousing
)
SELECT *
FROM RowNumCTE

WITH RowNumCTE AS(
SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY
			     UniqueID
				 )row_num

FROM dbo.NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num >1
ORDER BY PropertyAddress

WITH RowNumCTE AS(
SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY
			     UniqueID
				 )row_num

FROM dbo.NashvilleHousing
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1

WITH RowNumCTE AS(
SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY
			     UniqueID
				 )row_num

FROM dbo.NashvilleHousing
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


-----DELETE UNUSED COLUMNS


SELECT *
FROM dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN Owneraddress, TaxDistrict, PropertyAddress


SELECT *
FROM dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN SaleDate
