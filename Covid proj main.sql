-- An SQL Data Exploration project

use Covid19;

select * 
from covid19;

/* Picking out relevant columns needing for my analysis */


select iso_code, continent, location, date, total_cases, new_cases, total_deaths,new_deaths, total_vaccinations, new_vaccinations, population, median_age
from Covid19..covid19;


select date, location, total_cases, new_cases
from covid19;


/*continent null */ 
-- change the data type of total_cases,total _deaths , total_vaccinations, as well as check other datatypes of relevant columns

ALTER TABLE Covid19
ALTER COLUMN total_cases float;

ALTER TABLE Covid19
ALTER COLUMN total_deaths float;

ALTER TABLE Covid19
ALTER COLUMN total_vaccinations float;

ALTER TABLE Covid19
ALTER COLUMN new_vaccinations float;

ALTER TABLE Covid19
ALTER COLUMN people_vaccinated float;

-- Finding the totals for each sections

-- 1. How many continents does the analysis cover? 

select count(distinct(continent)) Total_Continents  
From covid19;


-- 2. How many countries does the analysis cover? 

select count(distinct(location)) Total_countries  -- There are 243 reported countries , 6 continents
From covid19
where continent is not NULL; 


-- 3. What was the most recent day of this data collection? 4th April 2023

select top 1 date, new_cases
from covid19
order by date desc;


-- 4. What is the global statistics report overview ?

select max(total_deaths) Total_deaths , max( total_cases) Total_cases , max(total_vaccinations) Total_vaccinations, 
       sum(new_deaths)/ sum(new_cases)*100 GlobalDeath_to_case_ratio
From covid19;


-- 5. Which single day had the highest death record globally ?

select top 1 date, max(new_deaths) Highest_death_by_day
from covid19
group by date
order by Highest_death_by_day desc;


-- 6. Which single day had the highest case record globally ?

select top 1 date, max(new_cases) Highest_case_count
from covid19
group by date
order by Highest_case_count desc;


-- 6b. Which month had the highest case record globally ?

SELECT top 1 MONTH(date) Month, max(new_cases) total_spent
FROM covid19
GROUP BY date
ORDER BY total_spent DESC;


-- 7. What are the top 10 countries with highest cases?

select top 10 continent, location, sum(new_cases) Total_cases
from covid19
where continent is not NULL
group by location, continent
order by Total_cases desc;


-- 8. What are the top 10 countries with highest death counts?

select top 10 continent, location, max(total_deaths) Total_deaths
from covid19
where continent is not NULL
group by location, continent
order by Total_deaths desc;


-- 9. What are the total cases per continent ? I doubt my output is accurate

select continent, max(total_cases) as Total_cases
from covid19 
where continent is not null
group by continent
order by Total_cases desc;


-- 9a What are the total cases per continent ? -- 

select continent, sum(new_cases) as Total_cases
from covid19 
where continent is not null
group by continent
order by Total_cases desc;


-- 10 What are the total deaths by continent

select continent, sum(new_deaths) as Total_deaths
from covid19 
where continent is not NULL
group by continent
order by Total_deaths desc;


/* Exploratory Analysis. Defining the metrics ; 

Death_to_case ratio = total_deaths/ new_cases . Shows %age of actually dying from covid after contracting it  
Death_rate = total_deaths / population . Shows likelihood of dying from covid per pop
Infection_rate = total_cases / population . Shows likelihood of getting infected per pop */


-- 11 Which countries had the highest infection rate ? 

select top 10 location,population, sum(new_deaths) TotalDeaths, sum(new_cases) Total_cases , round((sum(new_cases)/ population)*100,2) Infection_rate 
from covid19
where continent is not NULL
group by location,population
order by Infection_rate desc;


-- 11a. Which countries have the highest infection rate ? They both give out same output (reason being sum(new_cases) = max(total_cases))

select location, max(total_cases) Total_cases ,population,  round((max(total_cases)/ population)*100,2) Infection_rate 
from covid19
where continent is not NULL
group by location,population
order by Infection_rate desc;


-- 12. Which countries have highest death rate? 

select top 10 location, max(total_deaths) Total_deaths,population,  round((max(total_deaths)/ population)*100,2) Mortality_rate 
from covid19
where continent is not NULL
group by location,population
order by Mortality_rate desc;


-- 13. Which countries have highest death to case ratio ?

select location, sum(new_deaths) Total_deaths, sum(new_cases) Total_cases, round((sum(new_deaths)/ max(total_cases))*100,2) Death_rate 
from covid19
where continent is not NULL
group by location,population
order by Death_rate desc;


-- 14. What percentage of global population was infected ,and died ? Recheck n modify 

select max(total_deaths) Total_deaths,max(total_cases) Total_cases, 
      /*round((max(total_deaths)/population)*100,2 ) Globaldeathrate,*/ 
	  round(MAX((total_cases/population))*100,2 ) Globalinfectionrate
from covid19 

--14b what was the infection rate at different points in time? 

SELECT date, population, MAX(total_cases) AS Highest_Infection_Count,  MAX((total_cases/population))*100 AS Percent_Population_Infected
FROM covid19
GROUP BY date, population 
ORDER BY Highest_Infection_Count DESC;

-- Drilling down to Africa

-- 16. What are the top 10 countries with highest infection counts? 

select top 10 location, sum(new_cases) Total_cases
from covid19
where continent is not NULL and continent = 'Africa'
group by location
order by Total_cases desc;


-- 17. What are the top 10 countries with highest death counts? 

select top 10 location, sum(new_deaths) Total_deaths
from covid19
where continent is not NULL and continent = 'Africa'
group by location
order by Total_deaths desc;


-- 18. Infection rates in Africa

select top 10 location, max(total_cases) Total_cases ,population,  round((max(total_cases)/ population)*100,2) Infection_rate 
from covid19
where continent is not NULL and continent = 'Africa'
group by location,population
order by Infection_rate desc;


-- 18. Death rates in Africa

select top 10 location, max(total_cases) Total_cases ,population,  round((max(total_deaths)/ population)*100,2) Death_rate 
from covid19
where continent is not NULL and continent = 'Africa'
group by location,population
order by Death_rate desc;

-- 19. Top 10 countries in Africa with high population-vaccination rates

select top 10 location, max(total_cases) Total_cases ,
			 round((max(total_cases)/ population)*100,2) Infection_rate,
             round((max(total_deaths)/ population)*100,2) Death_rate,
			 round((max(total_vaccinations)/ population)*100,2) Vaccination_rate
from covid19
where continent is not NULL and continent = 'Africa'
group by location,population
order by Vaccination_rate desc;

-- 20. Top 10 countries by vaccination rates 

select top 10 location, max(total_cases) Total_cases ,
			 round((max(total_cases)/ population)*100,2) Infection_rate,
             round((max(total_deaths)/ population)*100,2) Death_rate,
			 round((max(total_vaccinations)/ population)*100,2) Vaccination_rate
from covid19
where continent is not NULL 
group by location,population
order by Vaccination_rate desc;

-- 20a What are the top countries with highest vaccination count?

/*select location, max(total_vaccinations) Totalvaccinations, max(people_vaccinated) peoplevaccinated
from covid19
where continent is not NULL
group by location
order by peoplevaccinated desc;*/ 


-- 21 What were the top countries in the world with highest vaccinations per pop?
select top 10 location, max(total_cases) Total_cases ,
             max(people_vaccinated)as total_vaccination,
			 round((max(total_cases)/ population)*100,2) Infection_rate,
             round((max(total_deaths)/ population)*100,2) Death_rate,
			 ROUND(max(people_vaccinated)/population *100,2) /*round(max(people_vaccinated)/ population*100,2)*/ Vaccination_rate
from covid19
where continent is not NULL 
group by location, population
order by total_vaccination desc;