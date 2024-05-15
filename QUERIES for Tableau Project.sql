/*
Queries used for tableau project
*/



-- 1

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) *100 as DeathPercentage
from portfolio..CovidDeaths
where continent is not null
order by 1,2

-- 2

-- we take these out as they are not included in the above queries and want to stay consistent
-- 

select continent, sum(new_deaths) as TotalDeathCount
from portfolio..CovidDeaths
--where location not in ('World', 'European Union', 'International', 'Asia','Europe','Africa','South America', 
--'High income', 'Upper middle income', 'Lower middle income', 'North America')
where continent!='Missing'
group by continent
order by TotalDeathCount desc


-- 3

select location, population, max(total_cases) as HighestInfectedCount, max((total_cases/population))*100 as PercentPopulationInfected
from portfolio..CovidDeaths
group by location,population
order by PercentPopulationInfected desc


-- 4

select location, population, date, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from portfolio..CovidDeaths
group by location,population,date
order by PercentPopulationInfected desc










