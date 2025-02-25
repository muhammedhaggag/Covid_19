select * from CovidDeaths
order by 3,4;
-------------------------------------------

select location, date,total_cases,new_cases,total_deaths,population
from CovidDeaths
-- Looking at Total Cases vs Total Deatths
select location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
-- Looking at Total Cases vs Population 
select location, date,total_cases,population,(total_cases/population)*100 as PopPercentage
from CovidDeaths;

--Looking at countries highest infection rate compared to population
Select location,population,MAX(total_cases)as total_cases,MAX(total_cases/population)*100 as highestper from CovidDeaths
group by location,population
order by total_cases Desc;
-- Showing countries with highest death count per Population
Select location,MAX(cast(total_deaths as int))as higestTotalDeath from CovidDeaths
where continent is not null
group by location
order by higestTotalDeath desc;

--- showing down by Continent
Select continent,MAX(cast(total_deaths as int))as higestTotalDeath from CovidDeaths
where continent is not null
group by continent
order by higestTotalDeath desc;

--Global Numbers 

Select date,Sum(cast(total_cases as int)),Sum(cast(total_deaths as int))
,sum(cast(total_deaths as int)) /sum(cast(total_cases as int))*100 as DEathPercentage
from CovidDeaths
where continent is not null
group by date
order by 4 desc;

---------------------------
--- Percentage Deaths
Select date,Sum(new_cases),Sum(cast(new_deaths as int))
,sum(cast(new_deaths as int)) /sum(new_cases )*100 as DEathPercentage
from CovidDeaths
where continent is not null
group by date
order by 4 desc;

--Number of New_Cases,New_Deaths
Select Sum(new_cases)as SumNewCases,Sum(cast(new_deaths as int))as SumNewDeaths
,sum(cast(new_deaths as int)) /sum(new_cases )*100 as DEathPercentage
from CovidDeaths
where continent is not null;

--Looking at Total Population VS Vaccination

Select D.continent,D.location,D.date,D.population, V.new_vaccinations
,sum(convert(int,V.new_vaccinations)) over (partition by D.location order by D.location,
D.date) as RollingPeopleVaccinated from CovidDeaths D
inner join CovidVaccinations V 
on D.location=V.location
and D.date=V.date
where D.continent is not null


select *from CovidVaccinations


-- Use CTE
with PopvsVac (Continent,Location,Date,population,new_vaccination,RollingPeopleVaccinated)
as
(
Select D.continent,D.location,D.date,D.population, V.new_vaccinations
,sum(convert(int,V.new_vaccinations)) over (partition by D.location order by D.location,
D.date) as RollingPeopleVaccinated from CovidDeaths D
inner join CovidVaccinations V 
on D.location=V.location
and D.date=V.date
where D.continent is not null
)
select *,(RollingPeopleVaccinated/population)
from PopvsVac

---TEMP TABLE
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select D.continent,D.location,D.date,D.population, V.new_vaccinations
,sum(convert(int,V.new_vaccinations)) over (partition by D.location order by D.location,
D.date) as RollingPeopleVaccinated from CovidDeaths D
inner join CovidVaccinations V 
on D.location=V.location
and D.date=V.date
where D.continent is not null
select *,(RollingPeopleVaccinated/population)
from #PercentPopulationVaccinated

------------------------------------------
                  --Create View 
Create View  PercentPopulationVaccinated as

Select D.continent,D.location,D.date,D.population, V.new_vaccinations
,sum(convert(int,V.new_vaccinations)) over (partition by D.location order by D.location,
D.date) as RollingPeopleVaccinated from CovidDeaths D
inner join CovidVaccinations V 
on D.location=V.location
and D.date=V.date
where D.continent is not null;

Select * from PercentPopulationVaccinated