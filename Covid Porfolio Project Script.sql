-- Looking at Total Cases vs Total Deaths 
-- Shows likelihood of dying if you contract covid in your country 
Select Location, date, total_cases,  total_deaths, (CAST(total_deaths as Decimal(10,3))/total_cases)*100 as DeathPercentage
from Covid_Data..CovidDeaths
Where location like '%canada%' 
Order By 1,2;

-- Looking at Total Cases vs Population 
-- Shows what percentage of population got Covid
Select Location, date, total_cases,  population, (CAST(total_cases as Decimal(10,3))/population)*100 as PercentPopulaitonInfected
from Covid_Data..CovidDeaths
Where location like '%canada%'
Order By 1,2;

-- Looking at Countries with Highest Infection Rate compared to Population 
Select Location, population, MAX(total_cases) as HighestInfectionCount, (CAST(Max(total_cases) as Decimal(18,3))/population)*100 as PercentPopulaitonInfected
From Covid_Data..CovidDeaths
Where continent is not null
Group By Location, Population
Order By PercentPopulaitonInfected DESC;

-- Showing Countries with Highest Death Count
Select Location, MAX(total_deaths) as TotalDeathCount
From Covid_Data..CovidDeaths
Where continent is not null
Group By Location
Order By TotalDeathCount DESC

-- Showing Continents with Highest Death Count
Select continent, Max(total_deaths) as TotalDeathCount
From Covid_Data..CovidDeaths
Where continent is not null
Group By continent
Order By TotalDeathCount DESC;

-- Global Numbers
Select date, sum(new_cases) as NewCases , sum(new_deaths) as NewDeaths, (CAST (sum(new_deaths)as Decimal(11,3))/ sum(new_cases))*100 as DeathPercentage 
From Covid_Data..CovidDeaths
Where continent is not null
Group By date
Order By date;

-- Looking at Total Population vs Vaccinations 

Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(cv.new_vaccinations) OVER (Partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
From Covid_Data..CovidDeaths cd
Join Covid_Data..CovidVaccinations cv on cv.date = cd.date 
and cv.location = cd.location
Where cd.continent is not null
Order by 2,3;


-- Creating a CTE to display a rolling total of people vaccinated over populaiton

With PopsvsVac(continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated) 
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(cv.new_vaccinations) OVER (Partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
From Covid_Data..CovidDeaths cd
Join Covid_Data..CovidVaccinations cv on cv.date = cd.date 
and cv.location = cd.location
Where cd.continent is not null
)

Select *, (CAST (RollingPeopleVaccinated as decimal(12,3))/population)*100 as PercentofPeopleVaccinated from PopsvsVac

-- Creating a temp table to display a rolling total of people vaccinated over populaiton
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)


Insert Into #PercentPopulationVaccinated
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(cv.new_vaccinations) OVER (Partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
From Covid_Data..CovidDeaths cd
Join Covid_Data..CovidVaccinations cv on cv.date = cd.date 
and cv.location = cd.location
Where cd.continent is not null

Select *, (CAST (rolling_people_vaccinated as decimal(12,3))/population)*100 as PercentofPeopleVaccinated 
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations 

Create View PercentPopulationVaccinated as
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(cv.new_vaccinations) OVER (Partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
From Covid_Data..CovidDeaths cd
Join Covid_Data..CovidVaccinations cv on cv.date = cd.date 
and cv.location = cd.location
Where cd.continent is not null;
