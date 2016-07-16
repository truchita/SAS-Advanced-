
************************************
Quiz-2 Answer 8, Answer 9, Answer 10
***********************************

** Remerging data;
** Use of formats;
** Use of calculated;
title'Use of formats , calculated + remerging data';
     proc sql feedback (outobs=10);
 select     id,age,
            avg(age) as avg_agee label = 'Avg Age' format 12.2,
			hr label ='Heart Rate',
            avg(hr) as avg_heart_rate label = 'Avg Heart Rate' format 12.2

from Tmp1.Heart_500 having calculated avg_heart_rate < 90
;
quit;
****************
Answer 7
****************
**use of 'like';
data departures;
   input Country $ 1-9 CitiesInTour 11-12 USGate $ 14-26 
         ArrivalDepartureGates $ 28-48;
   datalines;
1          2 3               4 
Japan      5 San Francisco          Tokyo, Osaka
Italy      8 New York               Rome, Naples
Australia 12 Honolulu           Sydney, Brisbane
Venezuela  4 Miami            Caracas, Maracaibo
Brazil     4               Rio de Janeiro, Belem
;
title "Retrive 'Japan' using like";
proc sql;
select Country
from departures
where Country like '%%_apan';
quit;

*****************
Answer -6
*************
** Using the IS MISSING or IS NULL Operator to Select Missing Values;
title'use of IS NULL operator';
proc sql;
select *
from Departures
where USgate is null;
quit;
***************
Answer -5
***************
** subset of the heart attack data by age and race. 
 Use both where statements and between. ;
	
title'subset of the heart attack data by age and race';
proc sql(outobs=10);
select *
from Tmp1.Lbw
where LWT between 100 and 150 and  age in (select age from Tmp1.Lbw where race=3 and age <30);
quit;
libname chap2 'C:\Users\i037805\Google Drive\Summers 2016\SAS Advanced\Chapter 2';  

run;
**************
Answer 4
**************
** use of feedback to debug;
 %macro skipit;
data heart_500;
 set Chap2.Heart_500;
run;

  %mend skipit;
**Select all the Heart_500;
proc sql noprint;
 select a.*
from chap2.Heart_500  a
;
quit;

run;
**Use Feedback ;

proc sql feedback noprint;
 select a.*
from chap2.Heart_500  a
;
quit;

**********************
 Answer 11
***********************

*demo of use of subquerry;
*this querry is fetching the details of patients who have bemm admitted in year 2002 and age<50 ,its a non-correlated subquerry example;
title'Patients admitted in year 2002 and age less than 45';
proc sql;
select id, age, gender
from Tmp1.Heart_500
where id in
(select id
from Tmp1.Heart_500
where year(admitdate)=2001 and age < 45);
quit;



