/* 
Details I have about the crime 
1. Crime was a murder 
2. It occurred sometime on Jan.15, 2018 and that 
3. It took place in SQL City 
*/


SELECT *
from crime_scene_report
where date = 20180115 and type = 'murder' and city = 'SQL City' ;

/* Only one field matches all clue partaining to the crime and here is the report from that crime scene 

"Security footage shows that there were 2 witnesses. The first witness lives at the 
last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave"." */

-- Now I'm going to go hear from these two witnesses from the 'person' table crime_scene_report


-- To query out the first witness 


SELECT *
from person
WHERE address_street_name = 'Northwestern Dr' 
order by address_number desc
LIMIT 1 ;

-- The name of this witness is Morty Schapiro


--  Second Witness

SELECT *
from person
WHERE name like  'Annabel%' AND address_street_name = 'Franklin Ave';

-- The name of this witness is Annabel Miller

SELECT id
from person
WHERE name like  'Annabel%' AND address_street_name = 'Franklin Ave';



/*  Next I'm going to have an interiew with these witnesses by going to the 'interview' table
Given that person id of both witness are 14887 and 16371*/

SELECT *
from interview i
join person p
on i.person_id = p.id
WHERE p.id IN (16371, 14887);

/* Transcript from Witness A, Morty Schapiro

"I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the 
bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that 
included "H42W"."

Transcript from Witness B Annabel Miller

"I saw the murder happen, 
and I recognized the killer from my gym when I was working out last week on January the 9th." */

/* Now with these two statements, here are my objectives:
- to investigate into the get_fit_now_member table to check for members with id starting with "48Z" and have gold membership status

- to investigate into the check the get_fit_now_check_in to check for members that were in the gym 9th of January 2015 and also fit the
  description above from the first witness (Gold membership and id starting with "48Z")
  
- and also check the drivers_license table for persons with a car plate consisting of "H42W" */

-- First, to query out persons with gold membership and have id starting with "48Z"

SELECT * 
from get_fit_now_member
where id like "48Z%" and membership_status = 'gold';

/* Details of members that fit this description

- Joe Germuska| person_id 28819| Gym id 48Z7A| SSN 871539279
- Jeremy Bowers| person_id 67318| Gym id 48Z55| SSN 871539279

Next, I'll query out which of this persons where in the gym on 20180109 */

SELECT m.name, c.membership_id, m.person_id, m.membership_status
from get_fit_now_check_in as c
join get_fit_now_member as m
on c.membership_id = m.id
where c.check_in_date = 20180109 and c.membership_id in ('48Z55', '48Z7A');

/* Both Joe and Jeremy where in gym on the our second witness said she saw the killer on the 9th and they remain the only two suspects

Next I'm going to check across person, getget_fit_now_member, and drivers_license table for that one person that fit the three descriptions provided by both witnesses collectively 
- Has a gold gym membership
-Drives a car with a plate that includes H42W
 and that should give us out killer*/

SELECT p.id, p.name, d.age, d.height, d.car_make, d.plate_number, p.ssn
from person p
join get_fit_now_member g
on p.id = g.person_id
join drivers_license d
on p.license_id = d.id
WHERE plate_number like "%H42W%" and membership_status = 'gold';

-- Our killer turns out to be Jeremy Bowers. Now I'm going to verify by inserting that value into the solutions table 

INSERT INTO solution values (1, 'Jeremy Bowers');
SELECT value from solution;

/* Transcript
Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge,try querying the 
interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in 
your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with 
your new suspect to check your answer.

TASKS
- Query out the mastermind who hired Jeremy Bowers to carry out the assasination. And to do that I must first retrieve Jeremy's transcript from the interview
- And I'm to complete this final step with no more than 2 queries
*/

-- Jeremy's inteview transcript

SELECT * 
from interview
WHERE person_id  = 67318;

-- Transcript

/* I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" 
(67").She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 
times in December 2017."

Now I'm going to query out the woman who hired the killer based on the description of her provided from the drivers_
license table

*/

SELECT *
FROM drivers_license d
join person p
on d.id = p.license_id
where car_model like '%Model S%'
	and gender = 'female'
    and hair_color = 'red';
    
/* This query returns infomation of 3 people that fits Jeremy's description. Referencing their person_id, I'm going
to ascertain which of these women attended the SQL Symphony thrice in December 2017 as Jeremy stated */

SELECT p.id, p.name, f.event_id, f.date, f.event_name, p.ssn
FROM facebook_event_checkin f
join person p
on f.person_id = p.id
WHERE event_name = 'SQL Symphony Concert' 
	and date like '201712%'
    and person_id in (78881, 90700, 99716);

/*This query reveals that one Miranda Priestly is the mastermind behind the murder. I'm going to insert her name 
into the solutions table to confirm that's correct */

INSERT INTO solution values (1, 'Miranda Priestly');
SELECT value from solution;
 
 /* Transcript 

Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of 
all time. Time to break out the champagne!

It's a success!







