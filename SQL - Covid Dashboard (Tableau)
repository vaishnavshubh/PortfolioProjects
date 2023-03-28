SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--Total cases vs total deaths
--shows the likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_perc
FROM CovidDeaths
WHERE location = 'India' AND continent IS NOT NULL
ORDER BY 1,2


--looking at the total cases vs the population
--shows what percentage of population got covid
SELECT location, date, population, total_cases, ROUND((total_cases/population)*100,2) AS case_perc
FROM CovidDeaths
--WHERE location = 'India'
WHERE continent IS NOT NULL
ORDER BY 1,2

--looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) maxinfectioncount, ROUND(MAX(total_cases/population)*100,2) AS case_perc
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
--WHERE location = 'India'
ORDER BY caseperc DESC


--showing countries with the highest death count per population
SELECT location, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
--WHERE location = 'India'
ORDER BY totaldeathcount DESC


--LET'S BREAK THINGS DOWN BY CONTINENT

--showing the continents with the highest death count per pop

SELECT continent, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
--WHERE location = 'India'
ORDER BY totaldeathcount DESC


--global numbers

SELECT  SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS death_perc
FROM CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2


--looking at total population vs vaccinations

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
		SUM(CONVERT(INT,v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM CovidDeaths AS d
	JOIN CovidVaccinations AS v
	ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 2,3

--use cte

WITH popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
		SUM(CONVERT(BIGINT,v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM CovidDeaths AS d
	JOIN CovidVaccinations AS v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM popvsvac

--TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255), 
location nvarchar(255), 
date datetime, 
population numeric, 
new_vaccinations numeric, 
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
		SUM(CONVERT(BIGINT,v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM CovidDeaths AS d
	JOIN CovidVaccinations AS v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


--CREATING VIEW TO STORE DATA FOR LATER VISUALISATIONS

CREATE VIEW PercentPopulationVaccinated AS 
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
		SUM(CONVERT(BIGINT,v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM CovidDeaths AS d
	JOIN CovidVaccinations AS v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL

SELECT *
FROM PercentPopulationVaccinated
