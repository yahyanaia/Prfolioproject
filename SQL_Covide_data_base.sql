SELECT* 
from portfolio_project..covid_death
WHERE continent is not null
order by 3,4

--SELECT* 
--from portfolio_project..covid_vacesenation
--order by 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
from portfolio_project..covid_death
order by 1,2

--looking at total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/ total_cases)*100 as deathPercentage
from portfolio_project..covid_death
where location like 'morocco'
order by 2  desc

--looking at total cases vs polpulation 
select location, date, total_cases, population, ( total_cases/ population)*100 as PopulationPercentage
from portfolio_project..covid_death
where location like 'morocco'
order by 1,2  desc


--looking at a contries with hight infection rate compared to population 
select location ,max( total_cases) as highst_infection , population, max ( total_cases/ population)*100 as highst_percentage
from portfolio_project..covid_death
group by location, population
order by  highst_infection desc


--Showing countries with highst death count per population 
select location ,max(total_deaths) as totaldeathcount
from portfolio_project..covid_death
WHERE continent is not null
group by location
order by  totaldeathcount desc

--let's breaking out by contionent 
select continent ,max(cast (total_deaths as int )) as totaldeathcount
from portfolio_project..covid_death
WHERE continent is not null
group by continent
order by totaldeathcount desc 


-- showing continents with highst death count per population 
select continent ,max(cast (total_deaths as int )) as totaldeathcount
from portfolio_project..covid_death
WHERE continent is not null
group by continent
order by totaldeathcount desc 
 
 --global number 
 select  date,sum(total_cases) as total_cases, sum(cast (total_deaths as int )) as totaldeaths,(sum(cast (total_deaths as int ))/sum(total_cases))*100 as daths_percentage
from portfolio_project..covid_death
group by date
order by date  desc

--looking for total vaccination vs population 

SELECT  dea.continent ,dea.location,dea.date, dea.population,vac.new_vaccinations,
sum(cast (vac.new_vaccinations as float )) over (partition by dea.location order by dea.location , dea.date rows UNBOUNDED PRECEDING ) as peaple_vaccineted
from portfolio_project..covid_death dea 
join  portfolio_project..covid_vacesenation vac
on dea.location= vac.location and 
dea.date= vac.date
where dea.continent is not null
order by 1,2



--USE CTE 
with popvsvac (continent, location,date,population,new_vaccinations,peaple_vaccineted)
as
(
SELECT  dea.continent ,dea.location,dea.date, dea.population,vac.new_vaccinations,
sum(cast (vac.new_vaccinations as float )) over (partition by dea.location order by dea.location , dea.date rows UNBOUNDED PRECEDING ) as peaple_vaccineted
from portfolio_project..covid_death dea 
join  portfolio_project..covid_vacesenation vac
on dea.location= vac.location and 
dea.date= vac.date
where dea.location like 'morocco'
--order by 1,2
)
select*, (peaple_vaccineted/population)*100
from popvsvac


--temp table
drop table if exists #peaple_vaccineted 
create table #peaple_vaccineted
(content varchar(255),
location varchar(255),
date datetime,  
population numeric ,
new_vaccinations numeric ,
peaple_vaccineted numeric 
)
insert into #peaple_vaccineted
SELECT  dea.continent ,dea.location,dea.date, dea.population,vac.new_vaccinations,
sum(cast (vac.new_vaccinations as numeric )) over (partition by dea.location order by dea.location , dea.date rows UNBOUNDED PRECEDING ) as peaple_vaccineted
from portfolio_project..covid_death dea 
join  portfolio_project..covid_vacesenation vac
on dea.location= vac.location and 
dea.date= vac.date
where dea.continent is not null
--order by 1,2

select* ,(peaple_vaccineted/population)*100
from #peaple_vaccineted


-- CRATING VIWE TO STORE DATA FOR A VISUALISATION 
create view peaple_vaccineted as 
SELECT  dea.continent ,dea.location,dea.date, dea.population,vac.new_vaccinations,
sum(cast (vac.new_vaccinations as numeric )) over (partition by dea.location order by dea.location , dea.date rows UNBOUNDED PRECEDING ) as peaple_vaccineted
from portfolio_project..covid_death dea 
join  portfolio_project..covid_vacesenation vac
on dea.location= vac.location and 
dea.date= vac.date
where dea.continent is not null
--order by 1,2

select* 
from peaple_vaccineted