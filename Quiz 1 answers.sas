
libname quiz1 'C:\Users\i037805\Google Drive\Summers 2016\SAS Advanced\Chapter 1'; 
run;

** Answer 1- No Code Required;
**Answer 2 -Logictic Regression;
proc logistic data=chap1.glow500 descending;
model fracture = PRIORFRAC AGE WEIGHT HEIGHT BMI PREMENO 
MOMFRAC ARMASSIST SMOKE RATERISK FRACSCORE;

quit;


**  Answer 3-use of formats , order by etc ;
data glow; 
  set quiz1.glow500; 
run;
proc format;
value risk 
           1 = 'Less'
           2 = 'Equal'
           3 = 'More';
run;

 proc sql outobs=10;
 select * ,  RATERISK as risk 'Self defined risk' format = risk.
  from glow
  where AGE>=70
  order by  AGE
;
quit;
run;

**  Answer 4- Matching lbw with ICU ;
data lbw; 
set quiz1.lbw; 
run; 
proc print data=lbw (obs=5);
run;
data ICU; 
set quiz1.icu; 
run;
 proc print data=ICU (obs=5);
 run;
 proc sql;
  create table match as
  select * 
  from lbw, ICU
  where lbw.ID=ICU.id
  order by lbw.id;
quit;
proc print data=match(obs=10);
run;


** Answer 5- Dividing data by race;
** Ans 5.1;
title'Mean Blood Pressure and Heart Rate by Race ';
PROC SQL;
select Race, avg(SYS) label "Mean_BP" ,avg(HRA) label "Mean_HR" 
from icu
group by RACE;
quit;
**Ans 5.2-Find how many had fracture;
title'Count of Patients having fracture, by race';
Proc sql;
select race,count(FRA)label "Count of fracture" 
from icu
where FRA=1
group by race;
quit;
**Ans 5.2 -Find how many had PRE;
proc sql;
select 
count(PRE) as Previous_Admission_To_ICU,
case
when RACE = 1 then 'White'
when RACE = 2 then 'Black'
else 'Other'
end as RACE
from chap1.icu
where PRE = 1
group by 2;
quit;



**Answer 5.3 -Provide the numbers for various values of Level of Consciousness.;
title'Distint levels of LOC and their count';
proc sql;
select 
case
when RACE = 1 then 'White'
when RACE = 2 then 'Black'
else 'Other'
end as RACE,
LOC as Level,
count(LOC)as Count_Level_of_Consciousness
from chap1.icu
group by RACE, LOC;
quit;
