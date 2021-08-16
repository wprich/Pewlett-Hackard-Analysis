# Pewlett-Hackard-Analysis

## Overview

  This project was based around finding the number of employees eligible for retirement from a particular company.  This client gave us numerous csv files to pull data from.  It was then decided that we would use the SQL database management system to put this data together into easy to understand and review formats.  By doing this, we were able to narrow down, combine, and also see all the data that was relevant to any/all inquries the employer had.  They were concerned that a "silver tsunami" was about to happen at the company and they were going to have an excessive amount of employees retire at once.  To prepare for this loss in manpower as well as senior leadership, they asked to us to narrow down the retiring population of their workforce to see if any of those retiring would be eligible to participate in a mentorship program.  This program would allow retired employees to come back to work on a part time basis and mentor the new employees to help develop their skills and also pass down wisdom.  
  
## Results

   * The first thing that was done was pulling data from multiple sources into one table.  This involved the employee csv as well as the titles table.  When these two sets of data were joined, a filter was put on to also only give us the information on employees that were born between 1952 to 1955.  This is because those employees were the ones eligible for retirement.  
 
 ![alt text](https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/titles_before_cleanup.png)
   
   As you can see, this list was not ideal for our reporting as there were duplicates in the table.  This meant that some employees were almost definitely promoted or moved departments while they worked for the company.  This could be remedied and was in the next step.
    
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
This was then sorted to the specifications set forth by the client.  

![alt text](https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/titles_after_cleanup.png)

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
  
  As you can see, the criteria for being a mentor is more stringent than just being able to retire.  The client asked that only people eligible for retirement and only born in the year of 1965 be considered and added to the list.  The total number of mentors is 1549, total number of rows minus the header.
  
  ![alt text](https://github.com/wprich/Pewlett-Hackard-Analysis/blob/main/Resources%20-%20Pictures/possible_mentors.png)
  
