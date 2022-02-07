SELECT * FROM covid19.coviddeaths;

-- Asia (China, Japan, South Korea), Europe (France, Germany, UK), North America (Canada, USA), 
-- South America (Argentina, Brazil), Australia
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid19.coviddeaths;

-- Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM covid19.coviddeaths;

-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM covid19.coviddeaths
WHERE location LIKE '%states%';

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
SELECT location, date, population, total_cases, (total_cases/population) * 100 AS PercentPopulationInfected
FROM covid19.coviddeaths
WHERE location LIKE '%states%';

-- Schemaed Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM covid19.coviddeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

-- Countries with Highest Death Count per Population
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM covid19.coviddeaths
GROUP BY Location
ORDER BY TotalDeathCount DESC;

SELECT *
FROM covid19.coviddeaths dea
JOIN covid19.covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date;
    
-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
FROM covid19.coviddeaths dea
JOIN covid19.covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY location, date;

Create View PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM covid19.coviddeaths dea
JOIN covid19.covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

