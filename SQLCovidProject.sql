select *
from [Covid Project].dbo.CovidDeaths
where continent is not null
order by 3,4


--Select *
--from [Covid Project].dbo.CovidVaccines


Select location, date, total_cases, new_cases,total_deaths, population
from [Covid Project].dbo.CovidDeaths
order by 1,2

--in the following query we will be Looking at Total cases vs total deaths
-- it shows the likelihood of dying by covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Covid Project].dbo.CovidDeaths
where location like 'india'
order by 1,2

-- in the following, we will be looking at total cases vs population
Select location, date,population, total_cases, (total_cases/population)*100 as CovidPercentage
from [Covid Project].dbo.CovidDeaths
where location like 'india'
order by 1,2
-- Countries with highest covid infection rates
select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as CovidPercentage
from [Covid Project].dbo.CovidDeaths
Group by Population, location
order by CovidPercentage desc

-- Countries with Highest Death rates
select location,  Max(cast(total_deaths as int)) as TotalDeathCount
from [Covid Project]..CovidDeaths
where continent is not null
Group by location
order by TotalDeathCount desc

-- Break down by continent
select location, Max(cast(total_deaths as int)) as TotalDeathCount
from [Covid Project]..CovidDeaths
where continent is null
Group by location
order by TotalDeathCount desc

--GLOBAL NUMBERS
select  SUM(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases)) *100 as DeathPercentages
From[Covid Project]..CovidDeaths
where continent is not null
--group by date
order by 1,2


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Covid Project].dbo.CovidDeaths dea
join [Covid Project]..CovidVaccines vac
 on dea.location = vac.location and dea.date = vac.date
 where dea.continent is not null
order by 2,3

-- USING CTE
with PopvsVac (continent, location, date,population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Covid Project].dbo.CovidDeaths dea
join [Covid Project]..CovidVaccines vac
 on dea.location = vac.location and dea.date = vac.date
 where dea.continent is not null
)
 select *, (RollingPeopleVaccinated/population)*100 as 
 from PopvsVac

 --Max Vaccinated
 with PopvsVac (continent, location, date,population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location) as RollingPeopleVaccinated
from [Covid Project].dbo.CovidDeaths dea
join [Covid Project]..CovidVaccines vac
 on dea.location = vac.location and dea.date = vac.date
 where dea.continent is not null
)
 select *, (RollingPeopleVaccinated/population)*100 as MaxPeopleVaccinated
 from PopvsVac
 
 --Temp Table
 Drop Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 continent varchar(255),
 location varchar(255),
 Date datetime,
 RollingPeopleVaccinated  numeric,
 population  numeric,
 new_vaccination numeric,
 )
 insert into #PercentPopulationVaccinated
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location) as RollingPeopleVaccinated
from [Covid Project].dbo.CovidDeaths dea
join [Covid Project]..CovidVaccines vac
 on dea.location = vac.location and dea.date = vac.date
 where dea.continent is not null

 select *, (RollingPeopleVaccinated/population)*100 as MaxPeopleVaccinated
 from #PercentPopulationVaccinated

 -- Creating View
 Create view PopulationVaccinated
 as
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location) as RollingPeopleVaccinated
from [Covid Project].dbo.CovidDeaths dea
join [Covid Project]..CovidVaccines vac
 on dea.location = vac.location and dea.date = vac.date
 where dea.continent is not null