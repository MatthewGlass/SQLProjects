------------------------------------------------------------
-- COVID Data Exploration Project
-- Author: [Your Name]
-- Description: Analyzing COVID-19 cases, deaths, and vaccinations
------------------------------------------------------------

------------------------------------------------------------
-- 1. Total Cases vs Total Deaths
--    Shows likelihood of dying if you contract COVID in a country
------------------------------------------------------------
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS DECIMAL(10,3)) / total_cases) * 100 AS DeathPercentage
FROM Covid_Data..CovidDeaths
WHERE location LIKE '%Canada%'
ORDER BY location, date;


------------------------------------------------------------
-- 2. Total Cases vs Population
--    Shows what percentage of the population got COVID
------------------------------------------------------------
SELECT 
    location,
    date,
    total_cases,
    population,
    (CAST(total_cases AS DECIMAL(10,3)) / population) * 100 AS PercentPopulationInfected
FROM Covid_Data..CovidDeaths
WHERE location LIKE '%Canada%'
ORDER BY location, date;


------------------------------------------------------------
-- 3. Countries with Highest Infection Rate Compared to Population
------------------------------------------------------------
SELECT 
    location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    (CAST(MAX(total_cases) AS DECIMAL(18,3)) / population) * 100 AS PercentPopulationInfected
FROM Covid_Data..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;


------------------------------------------------------------
-- 4. Countries with Highest Death Count
------------------------------------------------------------
SELECT 
    location,
    MAX(total_deaths) AS TotalDeathCount
FROM Covid_Data..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;


------------------------------------------------------------
-- 5. Continents with Highest Death Count
------------------------------------------------------------
SELECT 
    continent,
    MAX(total_deaths) AS TotalDeathCount
FROM Covid_Data..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;


------------------------------------------------------------
-- 6. Global Numbers (Daily Summary)
------------------------------------------------------------
SELECT 
    date,
    SUM(new_cases) AS NewCases,
    SUM(new_deaths) AS NewDeaths,
    (CAST(SUM(new_deaths) AS DECIMAL(11,3)) / SUM(new_cases)) * 100 AS DeathPercentage
FROM Covid_Data..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;


------------------------------------------------------------
-- 7. Total Population vs Vaccinations
------------------------------------------------------------
SELECT 
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    cv.new_vaccinations,
    SUM(cv.new_vaccinations) OVER (
        PARTITION BY cd.location 
        ORDER BY cd.location, cd.date
    ) AS RollingPeopleVaccinated
FROM Covid_Data..CovidDeaths cd
JOIN Covid_Data..CovidVaccinations cv 
    ON cv.date = cd.date 
   AND cv.location = cd.location
WHERE cd.continent IS NOT NULL
ORDER BY cd.location, cd.date;


------------------------------------------------------------
-- 8. Using CTE to Display Rolling Total of People Vaccinated
------------------------------------------------------------
WITH PopsVsVac AS (
    SELECT 
        cd.continent,
        cd.location,
        cd.date,
        cd.population,
        cv.new_vaccinations,
        SUM(cv.new_vaccinations) OVER (
            PARTITION BY cd.location 
            ORDER BY cd.location, cd.date
        ) AS RollingPeopleVaccinated
    FROM Covid_Data..CovidDeaths cd
    JOIN Covid_Data..CovidVaccinations cv 
        ON cv.date = cd.date 
       AND cv.location = cd.location
    WHERE cd.continent IS NOT NULL
)
SELECT 
    *,
    (CAST(RollingPeopleVaccinated AS DECIMAL(12,3)) / population) * 100 AS PercentOfPeopleVaccinated
FROM PopsVsVac;


------------------------------------------------------------
-- 9. Using Temp Table to Store Rolling Vaccination Data
------------------------------------------------------------
DROP TABLE IF EXISTS #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated (
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new_vaccinations NUMERIC,
    rolling_people_vaccinated NUMERIC
);

INSERT INTO #PercentPopulationVaccinated
SELECT 
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    cv.new_vaccinations,
    SUM(cv.new_vaccinations) OVER (
        PARTITION BY cd.location 
        ORDER BY cd.location, cd.date
    ) AS RollingPeopleVaccinated
FROM Covid_Data..CovidDeaths cd
JOIN Covid_Data..CovidVaccinations cv 
    ON cv.date = cd.date 
   AND cv.location = cd.location
WHERE cd.continent IS NOT NULL;

SELECT 
    *,
    (CAST(rolling_people_vaccinated AS DECIMAL(12,3)) / population) * 100 AS PercentOfPeopleVaccinated
FROM #PercentPopulationVaccinated;


------------------------------------------------------------
-- 10. Creating a View for Later Visualizations
------------------------------------------------------------
CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    cv.new_vaccinations,
    SUM(cv.new_vaccinations) OVER (
        PARTITION BY cd.location 
        ORDER BY cd.location, cd.date
    ) AS RollingPeopleVaccinated
FROM Covid_Data..CovidDeaths cd
JOIN Covid_Data..CovidVaccinations cv 
    ON cv.date = cd.date 
   AND cv.location = cd.location
WHERE cd.continent IS NOT NULL;


