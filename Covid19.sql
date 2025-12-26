-- Just Checking the dataset
select *
from covid_deaths
order by location, date;

-- Deaths per cases
select location, date, population, total_cases, total_deaths, round(100 * (total_deaths / total_cases)::Numeric, 2) as Deaths_To_Cases_Percentage
from covid_deaths
order by location, date;

-- Cases per population
select location, date, population, total_cases, total_deaths, round(100 * (total_cases / population)::Numeric, 2) as Cases_To_Population_Percentage
from covid_deaths
order by location, date;


-- Noticed that few countries have null data for the deaths and total cases
-- Max Cases for a country
select location,  MAX(total_cases) as TotalCases
from covid_deaths
where continent is not null and total_cases is not null
group by location
order by 2 Desc;


-- Max deaths for a country
select location,  MAX(total_deaths) as TotalDeaths
from covid_deaths
where continent is not null and total_deaths is not null
group by location
order by 2 Desc;

-- Max cases for continents
-- select location,  MAX(total_cases) as TotalDeaths
-- from covid_deaths
-- where continent is null 
-- group by location
-- order by 2 Desc;

-- Max deaths for continents
-- select location,  MAX(total_deaths) as TotalDeaths
-- from covid_deaths
-- where continent is null 
-- group by location
-- order by 2 Desc;

-- Max Cases for continents
select continent,  MAX(total_cases) as TotalCases
from covid_deaths
where continent is not null
group by Continent
order by 2 Desc;


-- Max deaths for  continents
select continent,  MAX(total_deaths) as TotalDeaths
from covid_deaths
where continent is not null 
group by continent
order by 2 Desc;

-- For the Continents the above are more true as these only shows the max of countries of a continent

-- For Global Data

-- Deaths per cases
select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, Round(100 * (sum(new_deaths) / sum(new_cases))::Numeric, 2) as New_deaths_to_cases 
from covid_deaths
where continent is not null
group by date
order by date;


-- Now join the tables and explore
with VacByDate (Continent, Location, Date, Population, New_Vaccinations, TotalVac)
as
(select d.continent, d.location, d.date, d.population, v.new_vaccinations,
	sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as TotalVacToDate
from covid_deaths as d join
	covid_vaccinations as v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
)

Select *, round((totalvac * 100/ population)::Numeric, 2) as VacPercentage
from Vacbydate
;
	