
CREATE DATABASE IndianCensus;

USE IndianCensus;

-- Display the Records
select *from IndianCenses_DB1;
select *from IndianCenses_DB2;

-- Number of records in a dataset
select count(*) from IndianCenses_DB1;
select count(*) from IndianCenses_DB2;

-- Display the numbers of records for State Jharkhand and Bihar
select *from IndianCenses_DB1 where State in ('Jharkhand','Bihar');

-- Check the missing values in a Table
select *from IndianCenses_DB1 where State IS NULL;

-- Check Population of India
select SUM(population) AS Total_Population from IndianCenses_DB2;

-- Average growth ratio of India
select state, avg(growth)*100 as Avg_Growth from IndianCenses_DB1 group by state;

-- Average sex ratio of India
select state, avg(sex_ratio)*100 as Avg_Sex from IndianCenses_DB1 group by state;

select state, round(avg(sex_ratio),0) as Avg_Sex_Ratio from IndianCenses_DB1 group by state 
order by Avg_Sex_Ratio desc ;

-- Average Literacy rate state having more than 85 percent
select state, round(avg(Literacy),0) as Avg_Literacy_Rate from IndianCenses_DB1 group by state
having round(avg(Literacy),0)>85 order by Avg_Literacy_Rate desc; 

-- Top 3 state showing highest growth ratio
SELECT TOP 3 state, AVG(Growth) * 100 AS Avg_Growth
FROM IndianCenses_DB1
GROUP BY state
ORDER BY Avg_Growth DESC;

-- Bottom 3 state showing lowest sex ration
SELECT TOP 3 state, AVG(Growth) * 100 AS Avg_Growth
FROM IndianCenses_DB1
GROUP BY state
ORDER BY Avg_Growth ASC;

--
-- Top and Bottom 3 States in literacy ratio
-- Drop the table if it exists
DROP TABLE IF EXISTS topstates;

-- Create the topstates table
CREATE TABLE topstates (
    state VARCHAR(255),
    avg_literacy_ratio FLOAT
);

-- Insert data into topstates
INSERT INTO topstates (state, avg_literacy_ratio)
SELECT state, ROUND(AVG(literacy), 0) AS avg_literacy_ratio
FROM IndianCenses_DB1
GROUP BY state;

-- Select top 3 states with the highest literacy ratio
SELECT TOP 3 * 
FROM topstates 
ORDER BY avg_literacy_ratio DESC;

-- Drop the table if it exists
DROP TABLE IF EXISTS bottomstates;

-- Create the bottomstates table
CREATE TABLE bottomstates (
    state VARCHAR(255),
    avg_literacy_ratio FLOAT
);

-- Insert data into bottomstates
INSERT INTO bottomstates (state, avg_literacy_ratio)
SELECT state, ROUND(AVG(literacy), 0) AS avg_literacy_ratio
FROM IndianCenses_DB1
GROUP BY state;

-- Select bottom 3 states with the lowest literacy ratio
SELECT TOP 3 *
FROM bottomstates
ORDER BY avg_literacy_ratio ASC;

-- Union All Opertor
-- Combine topstates and bottomstates using UNION ALL, then apply a final ORDER BY to the whole result
SELECT state, avg_literacy_ratio
FROM topstates

UNION ALL

SELECT state, avg_literacy_ratio
FROM bottomstates

ORDER BY avg_literacy_ratio DESC;

--States starting form letter a and b
select distinct state from IndianCenses_DB1 where lower(state) like 'a%' or lower(state) like 'b%';

-- Joining both tables males and females
select d.state, sum(d.males) Total_Males,sum(d.females) Total_Females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, 
round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from IndianCenses_DB1 a inner join IndianCenses_DB2 b 
on a.district=b.district ) c) d
group by d.state;

--Total Literacy Rate
select c.state,sum(literate_people) Total_Literate_Population, sum(illiterate_people) Total_Iliterate_Population from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from IndianCenses_DB1 a 
inner join IndianCenses_DB2 b on a.district=b.district) d) c
group by c.state;

--Show Top 3 Districts from each state with highest literacy rate
select a.* from
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from IndianCenses_DB1) a
where a.rnk in (1,2,3) order by state;