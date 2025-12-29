CREATE TABLE Student (
    state_name VARCHAR(50),
    district_name VARCHAR(50),
    school_name VARCHAR(50),
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    student_mark INT
);

select * from student s ;


-- WAQ to get overall rank national wise.
select *,
dense_rank() over(order by student_mark desc ) as  national_rank 
from student s ;



-- WAQ to get rank state_wise
select *,
dense_rank() over( partition by state_name 
					order by student_mark desc ) as  state_rank 
from student s ;


-- WAQ to get rank state,district wise
select *,
dense_rank() over( partition by state_name,
								district_name 
				   order by student_mark desc ) as  state_district_rank 
from student s ;



-- WAQ to get rank state,district,school wise.
select *,
dense_rank() over( partition by state_name,
								district_name,
								school_name 
					order by student_mark desc ) as  state_district_school_rank 
from student s ;












