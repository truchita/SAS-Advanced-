*Answer 2.3;
*Inner join of Icu and Lbw data.;
*Start with using Create Table; 

proc sql;
create table inner_join as 
select a.Age as Icu_Age ,a.*, b.*
      from Chap1.Icu   a , Chap2.Lbw   b
      where a.ID = b.ID;
	  quit;

	  proc contents data=inner_join ;
	  run;

*Answer3;
*3. Merge the ICU and LBW together and get the count by STA and percent of total of the joined data set. (Data when you’ve matched them together. See step 6b). 
;
proc format;
 value sta
 0 = 'Lived'
 1 = 'Died'
 ;
run;
proc sql ;
create table summary_statistics as
 select a.STA format=sta. as status,
 count(inner_join.id) as count_sta,
 count(inner_join.id)/count(inner_join.id) format=4.2 as per_sta
from chap3.icu  a,
     chap2.lbw  b,
	 
where a.id = b.id
group by a.sta
;
quit;
proc print data=summary_statistics;
run;

*ans 4.1, inner join of burns and glow500;
proc sql ;
create table inner_join_two as
 select a.*,
        b.*
from chap3.burns  a,
     chap1.Glow500 b
where a.age = b.age
order by a.id
;
quit;

proc print data=inner_join_two (obs=5);
 title 'inner_join of Burns and Glow data';
run;
* ans 4.2, outer join of burns and glow500;
 proc sql feedback;
create table full_join as
 select a.* ,
        b.*
from chap3.burns  a
     full join
     chap1.Glow500 b
     on a.age = b.age
	 order by a.id
;
quit;

run;

proc print data=full_join(obs=5);
 title 'Full Outer Join of Burns and Glow data';

run;

*Answer 4.3;
*Left outer join of Burns and Glow data;

proc sql ;
create table left_outer_join as
 select a.* ,
        b.*
from chap3.burns  a
     left join
     chap1.Glow500 b
     on a.age = b.age
;
quit;

run;

proc print data=left_outer_join(obs=5);
 title 'Left Outer Join of Burns and Glow data';
 run;

 *Answer 4.4 Right outer join of Burns and Glow data;
 proc sql ;
create table right_outer_join as
 select a.* ,
        b.*
from chap3.burns  a
     right join
     chap1.Glow500 b
     on a.age =  b.age
;
quit;

run;
proc print data=right_outer_join(obs=5);
 title 'Right Outer Join of Burns and Glow data';
 run;

 *ans 5 , use of coalesce in full outer join;
proc sql feedback;
create table coalesce_full_join as
 select coalesce(a.id ,
        b.sub_id)as C_id ,
  a.FACILITY, a.DEATH, a.AGE, a.GENDER, a.RACEC, a.TBSA, a.INH_INJ, a.FLAME,
 b.SITE_ID, b.PHY_ID, b.PRIORFRAC, b.WEIGHT, b.HEIGHT, b.BMI, b.PREMENO, b.MOMFRAC, b.ARMASSIST, b.SMOKE, b.RATERISK, 
b.FRACSCORE, b.FRACTURE 
from chap3.burns  a
     full join
     chap1.Glow500 b
     on a.age = b.age
	 order by a.id
;
quit;

run;

proc print data=coalesce_full_join(obs=5);
 title 'coalesce + Full Outer Join of Burns and Glow data';

run;

*ans 6, inner view;
proc format;
value risk 
           1 = 'Less'
           2 = 'Equal'
           3 = 'More';
run;


proc sql outobs=10;
 select  avg(m.WEIGHT) ,sum(m.WEIGHT) 
from (select  RATERISK  format = risk., WEIGHT
  from Chap1.Glow500 b  
  where AGE>=70)m

;
quit;
run;
proc format;
value risk 
           1 = 'Less'
           2 = 'Equal'
           3 = 'More';
run;

 proc sql feedback;
select m.raterisk format risk. as risk,
       m.sub_total,
       q.total,
       m.sub_total/q.total as per_total

from (select raterisk format=risk. as risk,
 count (sub_id) as sub_total
from chap1.glow500
group by raterisk) as m ,
(select count(z.sub_id )as total
 from chap1.glow500  z) as q
                 
;
quit;

**Ans 3: 3. Merge the ICU and LBW together and get the count by STA and percent of total of the joined data set.
(Data when you’ve matched them together. See step 6b). 
;


proc sql feedback;
 select a.STA format=sta. as status,
 count(a.id) as sub_total,
 total,
calculated sub_total /total format=4.2 as per_tot
from chap3.icu  a,
(select count(b.id) as total
 from chap1.lbw b)
where a.id = b.id
group by a.sta
;
quit;



run;

 proc sql feedback (obs=10);
 select a.STA format=sta. as status,
 count(a.id) as sub_total,
 total_lbw,
calculated sub_total /total_lbw format=4.2 as per_tot_lbw,
  total_icu,
calculated sub_total /total_icu format=4.2 as per_tot_icu
from chap3.icu  a,
(select count(b.id) as total_lbw
 from chap1.lbw b),
(select count(c.id) as total_icu
 from chap3.icu c)
where a.id = b.id
group by a.sta
;
quit;
