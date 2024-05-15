Select *
from portfolio..CovidDeaths
order by 3,4

--select *
--from portfolio..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
from portfolio..CovidDeaths
order by 1,2

-- Looking at the Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract in india
select Location, date, total_cases, total_deaths, ((total_deaths/total_cases) *100) as DeathPercentage
from portfolio..CovidDeaths
where location like '%ndia%'
order by 1,2


-- looking at Total cases vs Population
-- shows what percentage of people got covid

select location, date, population,total_cases, ((total_cases/population) * 100) as PercentagesPopulation
from portfolio..CovidDeaths
where location like '%ndia%'
order by 1,2

-- looking at countries with Highest Infection Rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)*100) as Percentpopulationinfected
from portfolio..CovidDeaths
group by Location, population
order by percentpopulationinfected desc

-- showing countries with highest death count per population

select location, MAX((total_deaths/population) *100) as Death_per_population
from portfolio..CovidDeaths
group by location, population
order by Death_per_population desc

select location, max(total_deaths) as Total_Death_Count
from portfolio..CovidDeaths
where continent is not null
group by location
order by Total_Death_Count desc


-- lets break things down by continent

select continent,sum(total_deaths) as total_death_count
from portfolio..CovidDeaths
where continent is not null
group by continent
order by total_death_count desc

Alter table dbo.CovidDeaths
Alter column continent nvarchar(50) null


-- showing the continents with highest death counts

select continent, max(total_deaths) as highest_death_counts
from portfolio..CovidDeaths
group by continent
order by highest_death_counts desc

-- golbal numbers

select date, SUM(new_cases/10000000) as cases_per_day_in_cr, sum(new_deaths) as total_new_deaths, (sum(new_deaths)/ NULLIF (sum(new_cases),0 )*100) as Death_percentage
from portfolio..CovidDeaths
where continent is not null
group by date
order by cases_per_day_in_cr desc

-- using another table named CovidVaccinations

-- Looking at Total Population vs Vaccinations

select *
from portfolio..CovidDeaths dea
Join portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

-- looking at total population vs vaccinations
select dea.location, max(dea.population)/10000000 as total_population_in_cr, max(vac.total_vaccinations)/10000000 as total_vaccinations_in_cr
from portfolio..CovidDeaths dea
join portfolio..CovidVaccinations vac
	on dea.location=vac.location and 
	dea.date=vac.date
group by dea.location
order by total_population_in_cr desc

-- looking at the total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, sum(vac.new_vaccinations) over (partition by dea.location)
from portfolio..CovidDeaths dea
join portfolio..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

-- looking for deaths cumilatively on each date in particular location 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,sum(vac.new_vaccinations) over 
(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from portfolio..CovidDeaths dea
join portfolio..CovidVaccinations vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent like '%asia%'

select *
from portfolio..CovidVaccinations

-- using common table expression or temp table

select dea.continent, dea.location, dea.date, dea.population, sum(dea.new_deaths) 
	over (partition by dea.location order by dea.location, dea.date) as rolling_people_death
from portfolio..CovidDeaths dea  
join portfolio..CovidVaccinations vac
on dea.location=vac.location and 
		dea.date=vac.date

-- use cte

with PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as
(
select dea.continent, dea.location, dea.date, vac.new_vaccinations, dea.population, sum(vac.new_vaccinations) 
	over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
from portfolio..CovidDeaths dea  
join portfolio..CovidVaccinations vac
on dea.location=vac.location and 
dea.date=vac.date
where dea.continent is not null)

select *, ((rolling_people_vaccinated/nullif(population,0))*100) 
from PopvsVac

-- temp table

Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date date,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolio..CovidDeaths dea
Join portfolio..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

select *, RollingPeopleVaccinated/population *100
from #PercentPopulationVaccinated

alter table dbo.CovidDeaths
alter column date date

alter table dbo.CovidVaccinations
alter column date date

drop table if exists #PercentPopulationVaccinated
-- create view # percentage population vaccinated
create view percentagepopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location
 order by dea.location, dea.date) as RollingPopulationVaccinated
 from portfolio..CovidDeaths dea
 join portfolio..CovidVaccinations vac
 on dea.location=vac.location
 and dea.date=vac.date


 select *
 from percentagepopulationvaccinated


