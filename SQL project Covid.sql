-- EXPLoring data (project)
SELECT *
FROM ProfolioProject..CovidDeaths$
ORDER BY 3,4
--selecting distinct code of each location.
SELECT DISTINCT(iso_code)
FROM  ProfolioProject..CovidDeaths$

--lets explore the data how many cases and how many pple died .
 SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) as deathperecntage
FROM ProfolioProject..CovidDeaths$
ORDER BY 1,2
-- in my conclusion  death percentage starts low and high and low it rises uo and goesdown.
--i wanted view chinas data  because thats the covid statred.
sELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) as deathperecntage
FROM ProfolioProject..CovidDeaths$
WHERE location ='China'
ORDER BY 1,2
-- in china in less pless pple died than lived the chance of dying form covid was less than 1%


-- lets see the data for my home country Kenya.
sELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) as deathperecntage
FROM ProfolioProject..CovidDeaths$
WHERE location ='Kenya'
ORDER BY 1,2
--Kenya less pless pple died than lived the chance of dying form covid was less than 1%

--looking at coutries with the highest infection rate compared to population 

SELECT location,  population, MAX(total_cases) AS highestinfectioncount, MAX(total_cases/population) as percentageofpopulation
FROM ProfolioProject..CovidDeaths$
--WHERE location LIKE '%Kenya%'
GROUP BY location, population
ORDER BY 1,2 DESC

-- looking at coutries with the death rate compared to population 

SELECT location,MAX(total_deaths) as totaldeathcount
FROM ProfolioProject..CovidDeaths$
--WHERE location LIKE '%Kenya%'
GROUP BY location
ORDER BY totaldeathcount DESC

-- lets change the data type from a foat data type to int
SELECT location, MAX(CAST(total_deaths AS INT)) as totaldeathcount
FROM ProfolioProject..CovidDeaths$
--WHERE location LIKE '%Kenya%'
GROUP BY location
ORDER BY totaldeathcount DESC

-- To get accurate data  im going to use there not null with WHERE Clause.
SELECT location,MAX(total_deaths) as totaldeathcount
FROM ProfolioProject..CovidDeaths$
--WHERE location LIKE '%Kenya%'
WHERE continent is not null
GROUP BY location
ORDER BY totaldeathcount DESC
-- AUSTRIA With the highest

----Male smokers VS Female smoker
SELECT  CovidDeaths$.location, CovidDeaths$.male_smokers, COUNT(CovidDeaths$.male_smokers) as numberofmalessmokers
FROM ProfolioProject..CovidDeaths$ 
INNER JOIN ProfolioProject..CovidVaccinations$
   ON CovidDeaths$.location = CovidVaccinations$.location
GROUP BY CovidDeaths$.location, CovidDeaths$.male_smokers
HAVING count(CovidDeaths$.male_smokers) > 1
ORDER BY numberofmalessmokers DESC
--Mexico highest male numberofmalessmokers infected while nauru lowest.

SELECT CovidDeaths$.location, CovidDeaths$.female_smokers, COUNT(CovidDeaths$.female_smokers) as totalfemale_smokers
FROM ProfolioProject..CovidDeaths$
inner join ProfolioProject..CovidVaccinations$
    on CovidDeaths$.location = CovidVaccinations$.location
GROUP BY CovidDeaths$.location, CovidDeaths$.female_smokers
HAVING COUNT(CovidDeaths$.female_smokers) > 1
order by totalfemale_smokers DESC

-- malesmokers were more  than female smokers

-- Lets see what age commonly got covid.

SELECT  location, AVG(CAST(median_age AS INT)) AS averagemedianage
FROM ProfolioProject..CovidDeaths$  
WHERE location = 'World'
GROUP BY location, median_age
--  globally median AVG AROUage 30.
--

--OLDER THAN 65 VS 75 years.( lets see how many contraccted covid  19)
--Which country has the most pple that older than 65 and 75?( during covid had news pple say that old peoplewere more vunrable )
lets loo


SELECT location, MAX(aged_65_older ) AS totalaged65, population, (aged_65_older/population)
FROM ProfolioProject..CovidDeaths$ 
WHERE location = 'World'
GROUP BY location, aged_65_older, population
ORDER BY aged_65_older DESC
-- number of pple aged older 65 that got covid is less than those whose got covid .
-- GOLBAL NUMBERS 8.896 of old pplle got covid. japan has had the highest pple aged 12555with covid
-- and United Arab Emirates had the lowest 458. 
-- the median age for doesnt aroud midde
--continent 



--
--OLDER THAN 65 VS 75 years.
--Which country has the most pple that older than 65 and 75?( during covid had news pple say that old peoplewere more vunrable )


SELECT location, MAX(aged_65_older ) AS totalaged65, population, (aged_65_older/population)
FROM ProfolioProject..CovidDeaths$ 
WHERE location = 'World'
GROUP BY location, aged_65_older, population
ORDER BY aged_65_older DESC
-- number of pple aged older 65 that got covid is less than those whose got covid .
-- GOLBAL NUMBERS 8.896 of old pplle got covid. japan has had the highest pple aged 12555with cpvid
-- and United Arab Emirates had the lowest 458. 

--continent 

SELECT location, MAX(CAST(total_deaths as int )) as totaldeathcount
FROM CovidDeaths$
WHERE continent is  null
Group by location 
ORDER BY totaldeathcount  DESC

--The country where the most pple died from covid is Usa(578234)  GRENADA with the lowest 1.
--LETS SEE WHICH CONTINENT HAD HIGHEST TOTADEAHTCOUNT BTEWEEN AFRICA, ASIA, NORTHAMERICA, SOUTHAMERICA, EUROPE AUSTRLIA&NEWZELAND.

SELECT continent, MAX(CAST(total_deaths as int )) as totaldeathcount
FROM ProfolioProject..CovidDeaths$
WHERE continent is  null
GROUP BY continent, total_deaths
ORDER BY totaldeathcount DESC

--

SELECT  date, new_cases-- total_deaths, (total_cases/total_deaths)*100 as percentageofdeath
FROM ProfolioProject..CovidDeaths$ 
where continent is not null
 GROUP BY date
ORDER BY 1, 2 
ORDER BY totaldeathcount DESC
-- in first place we have Europe then Last place we Oceania.
-- my continet Africa is second Last.(121,784)
 -- lets look  death in each continet per population.

--- converting data type for accurate data
 SELECT continent, MAX(CAST(total_deaths as int )) as totaldeathcount
FROM ProfolioProject..CovidDeaths$ 
WHERE continent is  null
Group by continent
ORDER BY totaldeathcount DESC

--GLOBAL NUMBERS.
SELECT SUM(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths,   sum(cast(new_deaths as int))/SUM(new_cases)*100 As deathpercentage
FROM ProfolioProject..CovidDeaths$ 
GROUP BY date
ORDER BY 1,2

-- In conclusion total cases 150million , 30 million died meaning 50 million lived with a death percentage 2%
--around the world.
-- how many pple got vaccinated around the world
SELECT CovidDeaths$.continent, CovidDeaths$.location, CovidDeaths$.date,  CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
SUM(CAST(CovidVaccinations$.new_vaccinations AS INT)) OVER ( PARTITION BY CovidDeaths$.location Order by CovidDeaths$.location,CovidDeaths$.date)
as rollingpeoplevaccinated
FROM ProfolioProject..CovidDeaths$
INNER JOIN ProfolioProject..CovidVaccinations$
   ON CovidDeaths$.location = CovidVaccinations$.location
     AND CovidDeaths$.date = CovidVaccinations$.date
where CovidDeaths$.continent is not null
order by 2,3

--USE COMMON TABLE EXPRESSIONS
WITH popsvsvac ( continent, location, date, population, new_vaccinations,rollingpeoplevaccinated )
as
(
SELECT CovidDeaths$.continent, CovidDeaths$.location, CovidDeaths$.date,  CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
SUM(CAST(CovidVaccinations$.new_vaccinations AS INT)) OVER ( PARTITION BY CovidDeaths$.location Order by CovidDeaths$.location,CovidDeaths$.date)
as rollingpeoplevaccinated
--, (rollingpeoplevaccinated/population)*100
FROM ProfolioProject..CovidDeaths$
INNER JOIN ProfolioProject..CovidVaccinations$
   ON CovidDeaths$.location = CovidVaccinations$.location
     AND CovidDeaths$.date = CovidVaccinations$.date
where CovidDeaths$.continent is not null
--order by 2,3
)

SELECT * , (rollingpeoplevaccinated/population)
FROM popsvsvac
-- in summary around the first few days i would say more and more people got thier vaccinated.



-- STORED PROCEDURE
CREATE PROCEDURE VACC
AS
SELECT CovidDeaths$.continent, CovidDeaths$.location, CovidDeaths$.date,  CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
SUM(CAST(CovidVaccinations$.new_vaccinations AS INT)) OVER ( PARTITION BY CovidDeaths$.location Order by CovidDeaths$.location,CovidDeaths$.date)
as rollingpeoplevaccinated
FROM ProfolioProject..CovidDeaths$
INNER JOIN ProfolioProject..CovidVaccinations$
   ON CovidDeaths$.location = CovidVaccinations$.location
     AND CovidDeaths$.date = CovidVaccinations$.date
where CovidDeaths$.continent is not null
order by 2,3

EXEC VACC
-- I use stored procedures becacause of its  benefits such as its reussebable( its can be stored and used for latercan be accesd it by merely querying it)
--, secure it improves the security of database by rectsing of users from accessing the table
-- low networK traffic since its easily acessble sice its store in the db you can just query it instead the writing the whole query again which reduces networK traffic
--improves performance the mean its created and stored i can just easiy acces agian.
-- easy to modify i can update easily with the help of alter table.
-- 
--MODYFYING THE STORED  PROCDURE
USE [ProfolioProject]
GO
/****** Object:  StoredProcedure [dbo].[Kenya]    Script Date: 11/22/2024 10:52:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[VACC]
@location nvarchar(100)
AS 
SELECT CovidDeaths$.continent, CovidDeaths$.location, CovidDeaths$.date,  CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
SUM(CAST(CovidVaccinations$.new_vaccinations AS INT)) OVER ( PARTITION BY CovidDeaths$.location Order by CovidDeaths$.location,CovidDeaths$.date)
as rollingpeoplevaccinated
FROM ProfolioProject..CovidDeaths$
INNER JOIN ProfolioProject..CovidVaccinations$
   ON CovidDeaths$.location = CovidVaccinations$.location
     AND CovidDeaths$.date = CovidVaccinations$.date
where CovidDeaths$.location = @location
order by 2,3
EXEC VACC @location = 'Kenya'

-- temp Tables
Drop table if exists #popultaionvaccinatedglobal
create table #popultaionvaccinatedglobal
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
popluation numeric,
new_vaccinations numeric,
rollingpeople numeric,

)
 insert into #popultaionvaccinatedglobal 
 SELECT CovidDeaths$.continent, CovidDeaths$.location, CovidDeaths$.date,  CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
SUM(CAST(CovidVaccinations$.new_vaccinations AS INT)) OVER ( PARTITION BY CovidDeaths$.location Order by CovidDeaths$.location,CovidDeaths$.date)
as rollingpeoplevaccinated
--, (rollingpeoplevaccinated/population)*100
FROM ProfolioProject..CovidDeaths$
INNER JOIN ProfolioProject..CovidVaccinations$
   ON CovidDeaths$.location = CovidVaccinations$.location
     AND CovidDeaths$.date = CovidVaccinations$.date
--where CovidDeaths$.continent is not null
--ORDER BY 2,3


SELECT *
FROM #popultaionvaccinatedglobal

-- LETS SAY I WANT CHANGE SOMETHING IN TEMP TABLES HOW DO I GO AHEAD DO THAT
--i use the DROP TABLE IF IT EXIST.
-- CREATE DATE VIEWS FOR DATA VISUALIZATION
CREATE VIEW popultaionvaccinatedglobal
AS
SELECT  date, new_cases-- total_deaths, (total_cases/total_deaths)*100 as percentageofdeath
FROM ProfolioProject..CovidDeaths$ 
where continent is not null
GROUP BY date, new_cases
--ORDER BY 1, 2
SELECT *
FROM popultaionvaccinatedglobal

