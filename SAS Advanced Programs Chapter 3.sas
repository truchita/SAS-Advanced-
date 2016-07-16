
*****************************************************;
* Step 1: Bring in the Low Birth Weight Data;
*         We used import wizard to created LBW then;
*         saved it into chap1;
*******************************************************;

run;

libname chap1  'H:\Data\My Documents\SFO Risk\quigleym\TIME\UC Berkley\Summer 2016\Chapter 1';
libname chap2  'H:\Data\My Documents\SFO Risk\quigleym\TIME\UC Berkley\Summer 2016\Chapter 2';
libname chap3  'H:\Data\My Documents\SFO Risk\quigleym\TIME\UC Berkley\Summer 2016\Chapter 3';

run; 

**Step 1: Define data; 

run;

  %macro skipit;


 data chap3.icu;
  set icu;

  data chap3.burns; 
   set burns; 

  run;

  %mend skipit;


**Step 2: Cartesian Product; 

  data small_icu; 
   set chap3.icu(obs=10); 
   keep id sta age; 

   data small_burns; 
    set chap3.burns(obs=10);
	keep id death tbsa; 

	run; 

proc sql;
create table cartesian as 
 select a.*, 
        b.*
from small_icu a, 
     small_burns b
;
quit;

run;

Proc sort data=cartesian; 
 by Id; 

 proc print data=cartesian(obs=25); 
 title 'cartesian'; 

 run; 

**Step 3: Inner Joins;
** Not that when ages differ it takes the age form the first data set; 

proc sql feedback;
create table inner_join as 
 select a.*, 
        b.*
from chap3.icu  a, 
     chap3.burns b
where a.id = b.id
order by a.id
;
quit;

proc contents data=inner_join; 
 title 'inner_join'; 
 
proc print data=inner_join; 
var id age gender sta death; 
where id=4; 
title 'inner join for id=4'; 

run; 

proc print data=chap3.icu; 
 var id age gender sta; 
 where id=4; 
  title 'icu for id = 4'; 

  run; 

  proc print data=chap3.burns; 
 var id age gender death; 
 where id=4; 
  title 'burns for id = 4'; 

  run; 



**Step 4: Handling Duplicate Columns;
**We name what we want to pull in ; 

proc sql feedback;
create table inner_join as 
 select a.ID,
a.STA,
a.AGE as age_icu,
a.GENDER as gender_icu,
a.RACE as race_icu,
a.SER,
a.CAN,
a.CRN,
a.INF,
a.CPR,
a.SYS,
a.HRA,
a.PRE,
a.TYP,
a.FRA,
a.PO2,
a.PH,
a.PCO,
a.BIC,
a.CRE,
a.LOC,
b.ID,	
b.FACILITY,	
b.DEATH,	
b.AGE as age_burn, 
b.GENDER as gender_burn, 
b.RACEC as race_burn,	
b.TBSA,	
b.INH_INJ,	
b.FLAME	
from chap3.icu  a, 
     chap3.burns b
where a.id = b.id
order by a.id
;
quit;




**Step 5:  Match up data sets and create new variables; 


proc sql feedback;
create table inner_join_extra as 
 select a.ID,
a.STA,
a.AGE as age_icu,
a.GENDER as gender_icu,
a.RACE as race_icu,
b.death,	
(sta-death) as sta_death_diff
from chap3.icu  a, 
     chap3.burns b
where a.id = b.id
order by a.id
;
quit;


proc print dta=inner_join_extra; 
title 'inner_join_extra'; 

run; 


**Step 6:  Do a group by to get summary statistics; 

proc format; 
 value sta
 0 = 'Lived'
 1 = 'Died'
 ; 
run; 
proc sql feedback;
 select a.STA format=sta. as status,
 count(a.id) as tot_num, 
 sum(a.sta)/count(a.id) format=4.2 as per_tot
from chap3.icu  a, 
     chap3.burns b
where a.id = b.id
group by a.sta
;
quit;

