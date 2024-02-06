# SQL-Murder-Mystery-Project

In this project, I embarked on solving the SQL City Murder Mystery using SQL queries, step by step, gathering clues and examining the database meticulously. My investigation began with the following details:

1.	The crime was a murder.
2.	It occurred on January 15, 2018, in SQL City.
But first, here’s a quick summary of the steps I took to solve the mystery

### Step 1: Crime Details
•	To investigate the crime, I started by examining the crime_scene_report table to query out more relevant information about the murder
```
SELECT *
FROM crime_scene_report 
WHERE date = 20180115 AND type = 'murder' AND city = 'SQL City';
```
•	This query returned details about the crime that matched the given date, crime type, and location and a report taken at the scene of the crime
"Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave"."


### Step 2: Identifying Witnesses and Getting their testimonials from the interview table.
•	Following the description from the murder report. I used the information about the witnesses' locations to query the person table 
First Witness
```
SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;
```
This query identified Morty Schapiro as the first witness living on Northwestern Dr.
Second Witness
```
SELECT *
FROM person
WHERE name LIKE 'Annabel%' AND address_street_name = 'Franklin Ave';
```
This query helped locate Annabel Miller as the second witness residing on Franklin Ave.


•	By referencing their IDs, I retrieved the interview transcripts for Morty Schapiro and Annabel Miller from the interview table.

### Clue 1: Witness Testimonies
I then moved on to I retrieved the interview transcripts for Morty Schapiro and Annabel Miller from the interview table (Also Joining the person table to see their names assigned to the transcripts to verify the transcripts are from the right correspondents)
```
SELECT *
FROM interview
JOIN person ON interview.person_id = person.id
WHERE person.id IN (16371, 14887);
```
Transcript from Witness A, Morty Schapiro

"***I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the 
bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that 
included "H42W".***"

Transcript from Witness B Annabel Miller

"***I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.***”

The interviews provided crucial insights into the events witnessed by Morty Schapiro and Annabel Miller.

Now with these two statements, I divided my search into these steps:
* Investigating into the get_fit_now_member table to check for members with id starting with "48Z" and have gold membership status

* Investigating into the get_fit_now_check_in to check for members that were in the gym 9th of January 2015 and also fit the description above from the first witness (Gold membership and id starting with "48Z")

* And also looking into the drivers_license table for persons with a car plate consisting of "H42W" 


### Step 4: Investigating Gym Clues

The clues from the interviews directed my investigation to the get_fit_now_member and get_fit_now_check_in tables:
Gold Membership Holders with IDs Starting with "48Z"
```
SELECT *
FROM get_fit_now_member
WHERE id LIKE '48Z%' AND membership_status = 'gold';
```
This query identified 
•	Joe Germuska and 
•	Jeremy Bowers
 as gold members with '48Z' IDs.
 
Gym Attendance on January 9th, 2018
```
SELECT m.name, c.membership_id, m.person_id, m.membership_status
FROM get_fit_now_check_in AS c
JOIN get_fit_now_member AS m ON c.membership_id = m.id
WHERE c.check_in_date = 20180109 AND c.membership_id IN ('48Z55', '48Z7A');
```
This query confirmed the presence of both Joe and Jeremy at the gym on the date mentioned by the second witness. Both there can only be one killer here
And there’s only one means left to identify the killer, which is to check for which of these two have a car with a plate number that includes "H42W" as described by the First Witness Mr. Morty




### Step 5: Driver's License Clues
To query who the killer was between our two suspects, I needed to filter my SQL query to show me the person who had both a gold gym membership and a car with a plate number that includes "H42W". 
This required me to join different tables namely the 
1.	person table 
2.	get_fit_now_member table
3.	drivers_license table
```
SELECT p.id, p.name, d.age, d.height, d.car_make, d.plate_number, p.ssn 
FROM person p 
JOIN get_fit_now_member g 
ON p.id = g.person_id 
JOIN drivers_license d 
ON p.license_id = d.id 
WHERE plate_number LIKE '%H42W%' AND membership_status = 'gold';
```

And this query returned Jeremy Bowers’ details 

### Step 6: Confirming Jeremy Bowers as the killer
```
INSERT INTO solution VALUES (1, 'Jeremy Bowers'); 
SELECT value FROM solution;
```
And this query returned Jeremy Bowers’ details and that confirms Jeremy Bowers to be the killer

But it doesn’t end there

### Step 7: (BONUS CHALLENGE) Uncovering the Mastermind
•	Upon checking to verify Mr. Jeremys’ has the true killer, I retrieved this transcript

Transcript
“***Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect to check your answer.’
Step 8: Finding the Real Culprit***
•	First, I went on to retrieve Mr. Jeremys’ confession from the interviews’ table
"I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67") She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017."

•	Now I'm going to query out the woman who hired the killer based on the description he has provided from the drivers_license table
[NOTE: I’m to reveal the Mastermind writing ONLY two SQL queries]
```
SELECT *
FROM drivers_license d
JOIN person p
ON d.id = p.license_id
WHERE car_model LIKE '%Model S%'
	AND gender = 'female'
      AND hair_color = 'red';
```

This searches for females with red hairs and that drives a Tesla Model S has described by MR. Jeremy

•	Next, I went on to investigate the facebook_event_checkin for that one person amongst the three who fit the description above that attended the SQL Symphony Concert thrice in December 2017 as stated by Jeremy using their person_id
```
SELECT p.id, p.name, f.event_id, f.date, f.event_name, p.ssn
FROM facebook_event_checkin f
join person p
ON f.person_id = p.id
WHERE event_name = 'SQL Symphony Concert' 
	AND date like '201712%'
    AND person_id IN (78881, 90700, 99716);
```
Verifying the Findings
```
INSERT INTO solution VALUES (1, 'Miranda Priestly');
SELECT value FROM solution;
```
The investigation concluded with the identification of Miranda Priestly as the mastermind behind the crime after cross-referencing event attendance and gathered clues.


## Conclusion
This investigative process involved querying various tables, filtering data, and piecing together clues to identify the murderer and the mastermind. Through careful examination of witness statements and cross-referencing information from different tables was this a successful murder mystery solved.

