# Pewlett-Hackard-Analysis

## Overview

  This project was based around finding the number of employees eligible for retirement from a particular company.  This client gave us numerous csv files to pull data from.  It was then decided that we would use the SQL database management system to put this data together into easy to understand and review formats.  By doing this, we were able to narrow down, combine, and also see all the data that was relevant to any/all inquries the employer had.  They were concerned that a "silver tsunami" was about to happen at the company and they were going to have an excessive amount of employees retire at once.  To prepare for this loss in manpower as well as senior leadership, they asked to us to narrow down the retiring population of their workforce to see if any of those retiring would be eligible to participate in a mentorship program.  This program would allow retired employees to come back to work on a part time basis and mentor the new employees to help develop their skills and also pass down wisdom.  
  
## Results

   * The first thing that was done was pulling data from multiple sources into one table.  This involved the employee csv as well as the titles table.  When these two sets of data were joined, a filter was put on to also only give us the information on employees that were born between 1952 to 1955.  This is because those employees were the ones eligible for retirement.  
 
 ![alt text](https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/titles_before_cleanup.png)
 
 https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Data/retirement_titles.csv
   
   This list shows us that there were some promotions in the departments across an employees tenure with the client.  However, there were not as many as one would expect.  This could be due to employees leaving through the years and some people had to stay in their current/old positions to keep the work flowing.  Another reason could be there wasn't much need or employees didn't seek a promotion.  This may be for the client to ultimately decide.
    
   * The next step involved getting rid of those duplicates.  This was achieved by using a "distinct on" method in sql.  More specifically, the method was used on the primary key for the data, in this case being the employee number.  The title assigned to each employee in this data view would the title they most recently attained.
   ~~~
   -- Use Dictinct with Orderby to remove duplicate rows and create unique titles table
select distinct on (emp_no) emp_no,
  first_name,
  last_name,
  title
into unique_titles
from retirement_titles
order by emp_no asc, to_date desc;
   ~~~
   ![alt text](https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/titles_after_cleanup.png)
   
   https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Data/unique_titles.csv

This was then sorted to the specifications set forth by the client.  By doing this, we can clearly get a sense of the actual number of employees available to retire and what positions they held.  The total being 90938.  This gives the client a good idea of how many and what type of positions to fill.  But we can do a better job and give them even more concise numbers.

  * The last chart needed for this part of the project involved getting all the titles together into one concise file and a number of many were retiring with that job title.  
  ~~~
  --Retirement count by job title
select count(emp_no), title
into retiring_titles
from unique_titles
group by title
order by count desc
  ~~~
![alt text](https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/job_titles.png)

https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Data/retiring_titles.csv
	
   Doing some simple calculations, we can see that 63.8% of the retiring staff are either "Senior Engineer" or "Senior Staff", the biggest being engineer by about 1200.  This will be a big loss in terms of experience and leadership for the client.  Therefore the client came to us with another query on their data, find certain employees who might be interested in a mentorship program.  This means the retired employee would come back to work, part time, and guide/train the new hires and pass on their wisdom and experience.  This would also ease the client to phasing from a more seasoned work pool to a more fresh one.  

  * The next step was to get the number of employees eligible for the mentorship program.  This was done using the "distinct on" method as well as numerous joins in the same query.
  ~~~
  --Creating mentorship eligibilty table
select distinct on(e.emp_no) e.emp_no,
    e.first_name,
    e.last_name,
	  e.birth_date,
	  de.from_date,
	  de.to_date,
	  ti.title
into mentorship_eligibilty
from employees as e
left join dept_emp as de
on e.emp_no = de.emp_no
left join titles as ti
on ti.emp_no = ce.emp_no
where de.to_date = ('9999-01-01')
and (e.birth_date between '1965-01-01' AND '1965-12-31')
order by e.emp_no asc
  ~~~
  
   ![alt text](https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/possible_mentors.png)
    
  As you can see, the criteria for being a mentor is more stringent than just being able to retire.  The client asked that only people eligible for retirement and only born in the year of 1965 be considered and added to the list.  The total number of mentors is 1549, total number of rows minus the header.  This is a big difference from the total number of retiring employees.  1549 mentors over 33118 retirees.  More analysis will have to be done to see if only 1549 mentors would be feasible for the rest of the work force to get mentored by them.  This'll also be done in the summary as well.
  

  
