#show the Database
select *from dataset1;
select *from dataset2;

#Number of rows in dataset
select count(*) from dataset1;
select count(*) from dataset2;

#dataset for State Jharkhand and Bihar
select *from dataset1 where State in ('Jharkhand','Bihar');

#Check the missing values
select *from dataset1 where State IS NULL;

#Population of India
select SUM(population) AS Total_Population from dataset2;

#Average growth ratio of India
select state, avg(growth)*100 as Avg_Growth from dataset1 group by state;

#Average sex ratio of India
select state, avg(sex_ratio)*100 as Avg_Sex from dataset1 group by state;
select state, round(avg(sex_ratio),0) as Avg_Sex_Ratio from dataset1 group by state 
order by Avg_Sex_Ratio desc ;

#Average Literacy rate state having more than 85 percent
select state, round(avg(Literacy),0) as Avg_Literacy_Rate from dataset1 group by state
having round(avg(Literacy),0)>85 order by Avg_Literacy_Rate desc; 

#Top 3 state showing highest growth ratio
select state, avg(Growth)*100 Avg_Growth from dataset1 group by state order by Avg_Growth 
desc Limit 3;

#Bottom 3 state showing lowest sex ration
select state,round(avg(Sex_Ratio),0) AS Avg_Sex_Ratio from dataset1 group by state 
order by Avg_Sex_Ratio ASC Limit 3;

#Top and Bottom 3 States in literacy ratio
drop table if exists topstates;
create table topstates (state varchar(255), topstates float);
insert into topstates select state,round(avg(literacy),0) avg_literacy_ratio from dataset1 
group by state order by avg_literacy_ratio desc;
select *from topstates order by topstates desc limit 3;

drop table if exists bottomstates;
create table bottomstates (state varchar(255), bottomstate float);
insert into bottomstates select state, round(avg(literacy),0) AS Avg_Literacy_Ratio 
from dataset1 group by state order by Avg_Literacy_Ratio desc;
select *from bottomstates order by bottomstate asc Limit 3;

#Union Opertor
select *from (select *from topstates order by topstates desc) a
union
select *from (select *from bottomstates order by bottomstates asc) b;

#States starting form letter a and b
select distinct state from dataset1 where lower(state) like 'a%' or lower(state) like 'b%';

#Joining both tables males and females
select d.state, sum(d.males) Total_Males,sum(d.females) Total_Females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, 
round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from dataset1 a inner join dataset2 b 
on a.district=b.district ) c) d
group by d.state;

#Total Literacy Rate
select c.state,sum(literate_people) Total_Literate_Population, sum(illiterate_people) Total_Iliterate_Population from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from dataset1 a 
inner join dataset2 b on a.district=b.district) d) c
group by c.state;

#Show Top 3 Districts from each state with highest literacy rate
select a.* from
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from dataset1) a
where a.rnk in (1,2,3) order by state;







