
Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

--Select data that we will use

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths
--shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (Total_deaths/Total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Ireland%'
order by 1,2

--Looking at the total cases vs the population
--Shows what percentage of population got covid

Select Location, date, total_cases, Population, (Total_cases/Population)*100 as PercentPopulation
From PortfolioProject..CovidDeaths
Where location like '%Ireland%'
order by 1,2

--Looking at countries with highest infection Rate compared to Population

Select Location, MAX(total_cases) as HighestInfectionCount, Population, MAX(Total_cases/Population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%Ireland%'
Group by Location, Population
order by PercentPopulationInfected desc

--Showing the countries with the highest Death Count per population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Ireland%'
Group by Location
order by TotalDeathCount desc

--Breaking things down by continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Ireland%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Showing the continents with the highest death counts

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Ireland%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Ireland%'
where continent is not null
--Group by date
order by 1,2


Select *
From PortfolioProject..covidVaccinations

--joining the two (coviddeaths and covidvaccinations together)

Select *
From portfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date

--looking at people all over the world who got vaccinated(i.e., total population vs vaccinations)
Select dea.continent, dea.location, dea.population, dea.date, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int))OVER(Partition by dea.location Order by dea.location, dea.Date) as RollingpeopleVaccinated
From portfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Using CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.population, dea.date, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations))OVER(Partition by dea.location Order by dea.location, dea.Date) as RollingpeopleVaccinated
From portfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *
From PopvsVac

--TEMP TABLE
DROP Table if exists #PercentPeopleVaccinated
Create Table #PercentPeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPeopleVaccinated

Select dea.continent, dea.location, dea.population, dea.date, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations))OVER(Partition by dea.location Order by dea.location, dea.Date) as RollingpeopleVaccinated
From portfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeoplevaccinated/Population)*100
From #PercentPeopleVaccinated

 
 --Creating a view to store data for later visualizations

 Create View PercentPeopleVaccinated as
 Select dea.continent, dea.location, dea.population, dea.date, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations))OVER(Partition by dea.location Order by dea.location, dea.Date) as RollingpeopleVaccinated
From portfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPeopleVaccinated




