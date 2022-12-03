/*
Cleaning Data in SQL Queries
*/

--Standardize Date Format

select PropertyAddress 
from portfolio_project..nashville_housing 
alter table portfolio_project..nashville_housing 
alter column  SaleDate date ;

-- Breaking out Address into Individual Columns (Address, City, State)


select * 
from portfolio_project..nashville_housing 

select PropertyAddress,
substring(PropertyAddress,1,charindex (' ',PropertyAddress)) as number, 
substring (PropertyAddress, charindex(' ',PropertyAddress), len (PropertyAddress) )as Adress	,
substring(PropertyAddress,charindex(',',PropertyAddress)+1,LEN (PropertyAddress)) as city
from portfolio_project..nashville_housing 

alter table portfolio_project..nashville_housing 
add  PropertyNumber varchar(255) 
update portfolio_project..nashville_housing 
set PropertyNumber = substring(PropertyAddress,1,charindex (' ',PropertyAddress))

alter table portfolio_project..nashville_housing 
add  PropertyCleanAdress varchar(255)  
update portfolio_project..nashville_housing
set PropertyCleanAdress=substring (PropertyAddress, charindex(' ',PropertyAddress)+1,charindex(',',PropertyAddress))
alter table  portfolio_project..nashville_housing 
add PropertyCity  VARCHAR(255)
update portfolio_project..nashville_housing
set PropertyCity=substring(PropertyAddress,charindex(',',PropertyAddress)+1,LEN (PropertyAddress))


select * 
--parsename(replace(OwnerAddress,',','.'),3) AS addressclean,
--parsename(replace(OwnerAddress,',','.'),2) as City,
--parsename(replace(OwnerAddress,',','.'),1) as number

from portfolio_project..nashville_housing 
where OwnerAddress is not null

alter table portfolio_project..nashville_housing 
add  OwnerCleanAdress varchar(255)  
update portfolio_project..nashville_housing
set OwnerCleanAdress=parsename(replace(OwnerAddress,',','.'),3)
alter table  portfolio_project..nashville_housing 
add OwnerCity  VARCHAR(255)
update portfolio_project..nashville_housing
set OwnerCity=parsename(replace(OwnerAddress,',','.'),2)
alter table portfolio_project..nashville_housing 
add  OwnerCountry varchar(255) 
update portfolio_project..nashville_housing 
set OwnerCountry = parsename(replace(OwnerAddress,',','.'),1)

----Change Y and N to Yes and No in "Sold as Vacant" field

select distinct soldasvacant, count(soldasvacant)
from  portfolio_project..nashville_housing
group by SoldAsVacant
order by 1
 update portfolio_project..nashville_housing 
 set SoldAsVacant= 
 case when SoldAsVacant =  'y' then 'Yes'
     when SoldAsVacant = 'n' then 'No'
	 else SoldAsVacant 
 end
 from portfolio_project..nashville_housing 
 
 
 -- Remove Duplicates
 WITH rownumCTE as (
select * ,
row_number () over (
partition by parcelID,
             PropertyAddress,
			 SaleDate,
			 salePrice,
			 LegalReference
			 order by uniqueID
			 ) row_number 

from portfolio_project..nashville_housing 
--order by parcelID
)
select *  from rownumCTE
where row_number >1
ORDER BY PropertyAddress

--Delete Unused Columns


select * 
from portfolio_project..nashville_housing
 
 alter table  portfolio_project..nashville_housing
 drop column  ownerAddress,taxdistrict,propertyAddress

 
 



