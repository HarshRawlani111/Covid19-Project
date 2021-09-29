--Data Cleaning

select *
from [Data Cleaning Project ].dbo.[Nashville Housing]

--------------------------------------------
-- Standardize saledate

select saledate, CAST(saledate as date)
from [Data Cleaning Project ].dbo.[Nashville Housing]


select saledate, CONVERT(date,saledate)
from [Data Cleaning Project ].dbo.[Nashville Housing]



Alter table [Nashville Housing]
Add saledateconverted date;

Update [Nashville Housing]
set saledateconverted = CONVERT(date,saledate)

select saledateconverted
from [Data Cleaning Project ].dbo.[Nashville Housing]

--------------------------------------------------------------------------
-- Populate Property Address Data

select propertyaddress
from [Data Cleaning Project ].dbo.[Nashville Housing]

select *
from [Data Cleaning Project ].dbo.[Nashville Housing]
where PropertyAddress is NULL

select *
from [Data Cleaning Project ].dbo.[Nashville Housing]
--where PropertyAddress is NULL
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from [Data Cleaning Project ].dbo.[Nashville Housing] a
 join [Data Cleaning Project ].dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.uniqueID <> b.[UniqueID ]
where a.PropertyAddress is NULL

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Data Cleaning Project ].dbo.[Nashville Housing] a
 join [Data Cleaning Project ].dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.uniqueID <> b.[UniqueID ]
where a.PropertyAddress is NULL

update a
set PropertyAddress =ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Data Cleaning Project ].dbo.[Nashville Housing] a
join [Data Cleaning Project ].dbo.[Nashville Housing] b
		on a.ParcelID = b.ParcelID
	and a.uniqueID <> b.[UniqueID ]
where a.PropertyAddress is NULL


----------------------------------------------------------------------------
--3.	Breaking out Address into individual column (Address, City, State)

select PropertyAddress
from [Data Cleaning Project ]..[Nashville Housing]

select
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress))
From [Data Cleaning Project ]..[Nashville Housing]

select
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)) as Address,
	charindex(',',PropertyAddress)
From [Data Cleaning Project ]..[Nashville Housing]

select
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress) -1) as Address
From [Data Cleaning Project ]..[Nashville Housing]

select
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)) as Address,
SUBSTRING(PropertyAddress,charindex(',',PropertyAddress) +1,LEN(PropertyAddress)) 
From [Data Cleaning Project ]..[Nashville Housing]

Alter table [Nashville Housing]
Add PropertySplitAddress varchar(255);

Update [Nashville Housing]
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress))

Alter table [Nashville Housing]
Add PropertySplitCity varchar(255);

Update [Nashville Housing]
set PropertySplitCity = SUBSTRING(PropertyAddress,charindex(',',PropertyAddress) +1,LEN(PropertyAddress)) 

Select * 
From [Data Cleaning Project ]..[Nashville Housing]

-- OWner Address


Select OwnerAddress
From [Data Cleaning Project ]..[Nashville Housing]


select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From [Data Cleaning Project ]..[Nashville Housing]


Alter table [Nashville Housing]
Add OnwerSplitAddress varchar(255);

Update [Nashville Housing]
set OnwerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

Alter table [Nashville Housing]
Add OwnerSplitCity varchar(255);

Update [Nashville Housing]
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

Alter table [Nashville Housing]
Add OnwersplitState varchar(255);

Update [Nashville Housing]
set OnwersplitState  = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

Select *
From [Data Cleaning Project ]..[Nashville Housing]


--------------------------------------------------------------------------------------
--4.	Change Y & N into Yes & No in “sold as vacant” field

Select Distinct (SoldAsVacant)
From [Data Cleaning Project ]..[Nashville Housing]

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From [Data Cleaning Project ]..[Nashville Housing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End
From [Data Cleaning Project ]..[Nashville Housing]

Update [Nashville Housing]
SET SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End
From [Data Cleaning Project ]..[Nashville Housing]


---------------------------------------------------------------
--Remove Dublicates

Select *
From [Data Cleaning Project ]..[Nashville Housing]

Select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 Order by 
					UniqueID
					) row_num
From [Data Cleaning Project ]..[Nashville Housing]
Order by ParcelID

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 Order by 
					UniqueID
					) row_num
From [Data Cleaning Project ]..[Nashville Housing]
)

Select *
From RowNumCTE
where row_num > 1
order by ParcelID

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 Order by 
					UniqueID
					) row_num
From [Data Cleaning Project ]..[Nashville Housing]
)
Delete
From RowNumCTE
where row_num > 1
--order by ParcelID

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 Order by 
					UniqueID
					) row_num
From [Data Cleaning Project ]..[Nashville Housing]
)

Select *
From RowNumCTE
where row_num > 1
order by ParcelID


---------------------------------------------------------------------------------
--Remove Unused Columns

Select *
From [Data Cleaning Project ].dbo.[Nashville Housing]

Alter Table [Data Cleaning Project ].dbo.[Nashville Housing]
Drop column PropertyAddress, OwnerAddress, TaxDistrict, PropertySplitAddressdate

Select *
From [Data Cleaning Project ].dbo.[Nashville Housing]


Alter Table [Data Cleaning Project ].dbo.[Nashville Housing]
Drop column SaleDate

Select *
From [Data Cleaning Project ].dbo.[Nashville Housing]