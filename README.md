# Pewlett-Hackard-Analysis

## Overview

  This project was based around finding the number of employees eligible for retirement from a particular company.  This client gave us numerous csv files to pull data from.  It was then decided that we would use the SQL database management system to put this data together into easy to understand and review formats.  By doing this, we were able to narrow down, combine, and also see all the data that was relevant to any/all inquries the employer had.  They were concerned that a "silver tsunami" was about to happen at the company and they were going to have an excessive amount of employees retire at once.  To prepare for this loss in manpower as well as senior leadership, they asked to us to narrow down the retiring population of their workforce to see if any of those retiring would be eligible to participate in a mentorship program.  This program would allow retired employees to come back to work on a part time basis and mentor the new employees to help develop their skills and also pass down wisdom.  
  
## Results

   * The first thing that was done was pulling data from multiple sources into one table.  This involved the employee csv as well as the titles table.  When these two sets of data were joined, a filter was put on to also only give us the information on employees that were born between 1952 to 1955.  This is because those employees hold the most senior positions but some aren't able to retire.  The current employees that can retire were found with this query:
   ~~~
-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT ri.emp_no,
       ri.first_name,
       ri.last_name,
       de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
   ~~~
 This tells us that the criteria for being eligible to retire is not only being born between 1952 to 1955, but also being hired between 1985 and 1988.  
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

This was then sorted to the specifications set forth by the client.  By doing this, we can clearly get a sense of the actual number of employees available to retire and what positions they held.  The total being 33118 which we obtained from another table called current_emp which can be found here:

https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Data/current_emp.csv

This gives the client a good idea of how many and what type of positions to fill.

  * The last chart needed for this part of the project involved getting all the titles together into one concise file.  
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
	
   Doing some simple calculations, we can see that 63.8% of the senior staff are either "Senior Engineer" or "Senior Staff", the biggest being engineer by about 1200.  This will be a big loss in terms of experience and leadership for the client when these employees retire. However, this list does not show the actual employees who are retiring, just the job titles held by the employees who were born between 1952 and 1955.  There would need to be a more specific query to get the job titles of only the employees who will be retiring.  The client then came to us with another query on their data, find certain employees who might be interested in a mentorship program.  This means the retired employee would come back to work, part time, and guide/train the new hires and pass on their wisdom and experience.  This would also ease the client to phasing from a more seasoned work pool to a more fresh one.  

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
on ti.emp_no = e.emp_no
where de.to_date = ('9999-01-01')
and (e.birth_date between '1965-01-01' AND '1965-12-31')
order by e.emp_no asc
  ~~~
  
   ![alt text](https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/possible_mentors.png)
    
  As you can see, the criteria for being a mentor is more stringent than just being able to retire.  The client asked that only people eligible for retirement and only born in the year of 1965 be considered and added to the list.  The total number of mentors is 1549, total number of rows minus the header.  This is a big difference from the total number of retiring employees.  1549 mentors over 33118 retirees.  More analysis will have to be done to see if only 1549 mentors would be feasible for the rest of the work force to get mentored by them.  Also, this list of mentors doesn't actually have any of the retirees on it, only employees who were born in 1965.  Since our retirees query was done on employees born in 1952 to 1955 and were employeed between 1985 to 1988, they cannot be considered to be mentors based on this information.
  
  
## Summary

  This project was a very good experience with SQL and all its functionalities.  Whether it be querying the data, joining tables, or import/exporting the data to make it more managable and easy to use.  The biggest question the client had was what was the total number of positions that would need to be filled when the "silver tsunami" starts to take effect.  This was answered above.  The total number of employees that would need to be replaced is 33,118.  Upon getting the total number of employees currently employed:
  
  ![alt text](https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/total_current_employees.png)
  
  https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/total_current_employees.png
  
  We can see that the "silver tsunami" will impact a 13.8% chunk of the workforce for the client.  With over a tenth of their workforce about to possibly enter retirement, it would be recommended that their human resources department start conducting interviews to either see if those employees plan to retire sooner or later and also think about finding qualified replacements.  
  
  Another question the client had was there enough qualified, retirement ready mentors for the next generation of workers for them.  If we subtract the number of retirees from the number of current employees, we are at 207,006 employees remaining.  If we take this figure and divide them among the mentors we found in results, we have a ratio of 1 mentor for every 134 employees.  This does not seem feasible given that each mentor would have over 100 employees to mentor.  One suggestion  would be to actually have the retirees be in the pool to be considered mentors.  Another suggestion may be that the senior staff be on call during certain hours of the day for the new/current employees to send questions to.  This can be done entirely electronically or in office during certain days/times.  Another possible solution would be loosening the constraints on being a mentor.  If you could have some employees be nearly retirement ready but still available to guide and lead the new/current employees, it would increase their availability.  Just by expanding the mentor criteria by 2 years, to include retirees whose birthday is in 1963 and 1964, not just 1965, we get get a considerable amount of more retirees available to mentor.
  
  ![alt text](https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/new_mentor_list.png)
  
  https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/new_mentor_list.png
