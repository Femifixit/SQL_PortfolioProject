--All three gave the same result

select * from PortfolioProject..COVIDDeaths
order by 3, 4

select * from [PortfolioProject].[dbo].[COVIDDeaths]
order by 3, 4

select * from COVIDDeaths
order by 3, 4


--select * from COVIDVaccinations
--order by 3, 4


--select data that we are going to use
select location, date, total_cases, New_cases, total_deaths, population
from PortfolioProject..COVIDDeaths
order by 1,2

-- Calculate the DeathRate in percentage
select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathRate
from PortfolioProject..COVIDDeaths
--where total_cases is not null 
--AND total_deaths is not null
order by 1,2
-- the cast function in "(cast(total_deaths as float)" converts the nvarchar to float to make division possible

--- Round the DeathRate to 2 decimal places
SELECT location, date, total_cases, total_deaths, 
    ROUND((CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100, 2) AS DeathRate
FROM PortfolioProject..COVIDDeaths
WHERE 
    total_cases IS NOT NULL 
    AND total_deaths IS NOT NULL
ORDER BY 
    location, date

	
--Population of people that got covid in Africa daily
select location, date, population, total_cases, (total_cases/population) *100 as PctPopulationInfected
from PortfolioProject..COVIDDeaths where location like '%Africa%'
order by 1,2
-- '%Africa%' means any sentence that contains Africa

---countries with HIGHEST infection rate
select location, population, MAX(total_cases) From PortfolioProject..COVIDDeaths
Group by location, population


--Countries with HIGHEST infection rate by population
select location, population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 AS 
PercentagePopulationInfected
From PortfolioProject..COVIDDeaths
Group by location, population
Order by PercentagePopulationInfected desc

--Countries with HIGHEST infection rate by population (ROUND percentage to 2 dp)
select location, population, MAX(total_cases) as HighestInfectionCount, ROUND(Max(total_cases/population)*100, 2) as 
PercentagePopulationInfected
From PortfolioProject..COVIDDeaths
Group by location, population
Order by PercentagePopulationInfected desc --- desc means descending


--Countries with the LOWEST infection rate per population
select location, population, Min(total_cases) as HighestInfectionCount, Min((total_cases/population)*100) as 
PercentagePopulationInfected
From PortfolioProject..COVIDDeaths
Group by location, population
Order by PercentagePopulationInfected Asc  ---Asc = ascending order


--Countries with the HIGHEST Death count per population
select location, population, MAX(total_deaths) as TotalDeathCount
-- note that the datatype for the total_deaths is nvarchar, we need to turn it to an integer for the correct result
From PortfolioProject..COVIDDeaths
Group by Location, Population
Order by TotalDeathCount Desc


select location, MAX(cast(total_deaths as int)) as TotalDeathCount
-- note that the datatype for the total_deaths is nvarchar, we need to turn it to an integer using 'cast'
From PortfolioProject..COVIDDeaths
--where location like '%states%'
where continent is not null
Group by Location
Order by TotalDeathCount desc


-- LETS BREAK THINGS DOWN BY CONTINENT

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
-- note that the datatype for the total_deaths is nvarchar, we need to turn it to an integer using 'cast'
From PortfolioProject..COVIDDeaths
where continent is not null
Group by continent
Order by TotalDeathCount desc
-- this may not be accurate because we have filtered out the NULL continent


select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..COVIDDeaths
where continent is null
Group by location
Order by TotalDeathCount desc
--this might reflect a more accurate result in the data is complete


---  Highest Death per continent
--
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
-- note that the datatype for the total_deaths is nvarchar, we need to turn it to an integer using 'cast'
From PortfolioProject..COVIDDeaths
where continent is not null
Group by continent
Order by TotalDeathCount desc

select continent, population, MAX(cast(total_deaths as int)) as TotalDeathCount, 
	MAX(cast(total_deaths as int))/population *100 as PctDeathByPopulation
-- note that the datatype for the total_deaths is nvarchar, we need to turn it to an integer using 'cast'
From PortfolioProject..COVIDDeaths
where continent is not null
Group by continent, population
Order by PctDeathByPopulation desc


--GLOBAL NUMBERS

--(cast(total_deaths as float)/cast(total_cases as float))*100
select date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
-- note that the datatype for the total_deaths is nvarchar, we need to turn it to an integer
From PortfolioProject..COVIDDeaths
where continent is not null
Group by date, total_cases, total_deaths
order by 1, 2

-- DAILY SUM OF NEW CASES --

select date,
		SUM(new_cases) as total_cases,
		SUM(cast(new_deaths as int)) as total_deaths
		--(SUM(cast(new_deaths as int))/SUM(cast(new_cases as float)))*100 as DeathPerctage
From PortfolioProject..COVIDDeaths
where continent is not null
Group by date
--order by DeathPerctage


-- TOTAL CASES of Death --

select
		SUM(new_cases) as total_cases,
		SUM(cast(new_deaths as int)) as total_deaths, 
		(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPerctage
From PortfolioProject..COVIDDeaths
where continent is not null
--Group by date
order by 1, 2


--select date,
--		SUM(new_cases) as total_cases,
--		SUM(cast(new_deaths as int)) as total_deaths, 
--		SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPerctage
--From PortfolioProject..COVIDDeaths
--where continent is not null
--Group by date
--order by 1, 2


---LOOKING AT THE COVID VACCINATION TABLE
select *
--From [dbo].[COVIDVaccinations]
From PortfolioProject..COVIDVaccinations

-- JOIN
-- on 'location' and 'date'
select *
From PortfolioProject..COVIDDeaths as dea   --From PortfolioProject..COVIDDeaths dea
Join PortfolioProject..COVIDVaccinations as vac  -- JOIN PortfolioProject..COVIDVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

-- Looking at Total population and Vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..COVIDDeaths dea
Join PortfolioProject..COVIDVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3  -- sort columns 2 then 3 in ascending order


-- Rolling Counts of the new-vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location)
--SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location)
From PortfolioProject..COVIDDeaths dea
Join PortfolioProject..COVIDVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

--Now the Rolling SUM (order by dea.location, dea.date)
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
From PortfolioProject..COVIDDeaths dea
Join PortfolioProject..COVIDVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

--To know the number of people vaccinated in a location (Total Vac poeple/Total populaion)
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population) * 100
From PortfolioProject..COVIDDeaths dea
Join PortfolioProject..COVIDVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- Its Not Working. Lets use CTE instead
-- USE CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as

(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population) * 100
From PortfolioProject..COVIDDeaths dea
Join PortfolioProject..COVIDVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
--select *
--From PopvsVac

select *, (RollingPeopleVaccinated/population) * 100
From PopvsVac

--You Can Cal using MAX for only the Total SUMs--



--  TEMP TABLE 



DROP Table if exists #PercentagePopulationVaccinated 
--This is good at the beginning of the table incase you are running the table multiple times to make alteration
create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date Datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population) * 100
From PortfolioProject..COVIDDeaths dea
Join PortfolioProject..COVIDVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

Select * , (RollingPeopleVaccinated/population) * 100
From #PercentagePopulationVaccinated


--select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
---- note that the datatype for the total_deaths is nvarchar, we need to turn it to an integer using 'cast'
--From PortfolioProject..COVIDDeaths
--where continent is not null
--Group by continent
--Order by TotalDeathCount desc


--CREATE VIEW TO STORE DATA for later visualization

Create view PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population) * 100
From PortfolioProject..COVIDDeaths dea
Join PortfolioProject..COVIDVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3


-- Assignment: Create View for ALL the Tables created
-- WE can Now access this table from View
select * 
From PercentagePopulationVaccinated