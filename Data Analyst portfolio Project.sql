SELECT *
From PortfolioProject..CovidDeaths

--SELECT *
--From PortfolioProject..[covid vaccination]

--SELECT THE DATA WE ARE GOING TO USE

SELECT Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases VS total death
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
order by 1,2

--Looking death percentage of a particular country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where Location like '%India%'
order by 1,2

--Looking at total cases VS Population
--What percentage of population got Covid
SELECT Location, date,population, total_cases, (total_cases/population)*100 as CasePercentage
From PortfolioProject..CovidDeaths
where Location like '%India%'
order by 1,2

--Looking at countries that got highest infection rate compared to population
SELECT Location,population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, population
order by PercentagePopulationInfected desc

--showing countries with Highest Death per popultaion
SELECT Location, MAX(cast(total_deaths as int)) as TotaldeathCount
From PortfolioProject..CovidDeaths
where continent is not NULL
Group by Location
order by TotaldeathCount desc

--LET'S BREAK THINGS BY CONTINENT
SELECT continent, MAX(cast(total_deaths as int)) as TotaldeathCount
From PortfolioProject..CovidDeaths
where continent is not NULL
Group by continent
order by TotaldeathCount desc

-- showing the continents with highest dead count per population
SELECT continent, MAX(cast(total_deaths as int)) as TotaldeathCount
From PortfolioProject..CovidDeaths
where continent is not NULL
Group by continent
order by TotaldeathCount desc

-- Global Numbers

SELECT SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as int)) as TotalDeath, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where Location like '%India%'
where continent is not NULL
--Group by date
order by 1,2

-- Looking at Total Population Vs  Total Vacccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) Over( Partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..[covid vaccination] vac
 on dea.Location= vac.location
 and dea.date = vac. date
 where dea.continent is not NULL
 order by 2,3

-- creating a temperory table
DROP table if exists PercentagePopulationVaccinated
Create table PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into PercentagePopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) Over( Partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..[covid vaccination] vac
 on dea.Location= vac.location
 and dea.date = vac. date
 --where dea.continent is not NULL
 order by 2,3

 select *,(RollingPeopleVaccinated/population)*100
 From PercentagePopulationVaccinated

-- creating view to store data for later visulaization
Create view PercentagePopulationVaccinatedView as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) Over( Partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..[covid vaccination] vac
 on dea.Location= vac.location
 and dea.date = vac. date
 where dea.continent is not NULL
 --order by 2,3

 select *
 from PercentagePopulationVaccinatedView