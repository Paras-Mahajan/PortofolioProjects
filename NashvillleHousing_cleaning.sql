/* 
Cleaning date in Sql queries
*/

select *
from portfolio..NashvilleHousing

-- Standardize date format
select saledate, convert(date,SaleDate)
from portfolio..NashvilleHousing

update Nashvillehousing
set Saledate= convert(date,Saledate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

update NashvilleHousing
set SaleDateConverted = convert(date,SaleDate)

-- Populate Property Address data

select propertyaddress
from portfolio..NashvilleHousing
where propertyaddress is null

select *
from portfolio..nashvillehousing
-- where propertyaddress is null
order by parcelid

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress,b.propertyaddress)
from portfolio..NashvilleHousing a
join portfolio..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.propertyaddress is null

update a
set propertyaddress = isnull(a.propertyaddress, b.propertyaddress)
from portfolio..nashvillehousing a
join portfolio..nashvillehousing b
	on a.parcelid = b.parcelid
	and a.[uniqueid] <> b.[uniqueid]
where a.propertyaddress is null


select *
from portfolio..nashvillehousing a
join portfolio..nashvillehousing b
on a.parcelid=b.parcelid
and a.[UniqueID] <> b.[UniqueID]
where a.propertyaddress is null


-- Breaking out address into individual columns (Address, City, State)

select propertyaddress
from portfolio..nashvillehousing

alter table nashvillehousing
add PropertySplitAddress nvarchar(255)

alter table nashvillehousing
add propertySplitCity nvarchar(255)

update nashvillehousing
set PropertySplitAddress = substring(propertyaddress, 1, charindex(',', propertyaddress)-1)
from portfolio..nashvillehousing

update nashvillehousing
set PropertySplitCity = substring(propertyaddress, charindex(',', propertyaddress)+1, len(propertyaddress))

-- split owner address into address, city and state

select owneraddress
from portfolio..nashvillehousing

select
parsename(replace(owneraddress,',','.'),3) AS ownersplitaddress,
parsename(replace(owneraddress,',','.'),2) AS ownersplitcity,
parsename(replace(owneraddress,',','.'),1) AS ownersplitstate
from portfolio..NashvilleHousing

alter table nashvillehousing
add OwnerSplitAddress nvarchar(255)

alter table nashvillehousing
add OwnerSplitCity nvarchar(255)

alter table nashvillehousing
add OwnerSplitState nvarchar(255)

update portfolio..nashvillehousing
set OwnerSplitAddress = parsename(replace(owneraddress,',','.'),3)
from portfolio..nashvillehousing

update portfolio..nashvillehousing
set OwnerSplitCity = parsename(replace(owneraddress,',','.'),2)
from portfolio..nashvillehousing

update portfolio..nashvillehousing
set OwnerSplitState = parsename(replace(owneraddress,',','.'),1)
from portfolio..NashvilleHousing

-- change 0 and 1 to Yes and No in 'Sold as Vacant' field


select distinct(soldasvacant), count(soldasvacant)
from portfolio..nashvillehousing
group by soldasvacant

alter table nashvillehousing
add SoldAsVacant_YN nvarchar(10)

update portfolio..nashvillehousing
set SoldAsVacant_YN = case
						when SoldAsVacant = 0 then 'No'
						else 'Yes'
						end
from portfolio..nashvillehousing

-- Remove Duplicates

with row_num as(
select *, 
	row_number () over(
	partition by parcelid, propertyaddress, saleprice, saledate,legalreference
	order by UniqueId) as row_num
	from portfolio..nashvillehousing
)
delete
from row_num
where row_num>1



-- Delete unused columns

alter table dbo.NashvilleHousing 
Drop column owneraddress, taxdistrict, propertyaddress, soldasvacant

alter table dbo.NashvilleHousing
drop column saledateconverted

select *
from portfolio..nashvillehousing