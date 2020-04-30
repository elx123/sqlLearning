https://zhuanlan.zhihu.com/p/53302593

01 查询“01”课程比“02”课程成绩高的所有学生的学号；
use employees;
select * from SC s join SC c on s.cid = 01 and c.cid = 02 and s.score > c.score and s.sid = c.sid

use employees;
select distinct t1.sid as sid
from 
    (select * from SC where cid='01')t1
left join 
    (select * from SC where cid='02')t2
on t1.sid=t2.sid
where t1.score>t2.score

02 查询平均成绩大于60分的同学的学号和平均成绩；
select avg(score),sid from SC group by sid having avg(score) > 60

select 
    sid
    ,avg(score)
from SC
group by sid
having avg(score)>60

03 查询所有同学的学号、姓名、选课数、总成绩
select c.sid,s.Sname,count(c.cid),sum(score) from SC c inner join Student s on c.sid = s.sid group by s.sid,s.Sname

04 查询姓“李”的老师的个数；
select count(distinct tid) as teacher_cnt from Teacher where tname like "李%"

05 查询没学过“张三”老师课的同学的学号、姓名；
select
    sid,sname
from Student
where sid not in (
select sid from 
		Course c inner join Teacher t 
							on c.TId = t.TId 
        inner join SC s
							on c.cid = s.cid
                            
                              where t.tname='张三'
                              )

06 查询学过编号“01”并且也学过编号“02”课程的同学的学号、姓名；
select sid,sname from Student where sid in(
select sid from Course c inner join SC s on c.cid = s.cid where c.cid = 01 or c.cid = 02 group by s.sid having count(s.sid) = 2 )

select t.sid,t.sname from SC s inner join SC c on s.sid = c.sid inner join Student t on s.sid = t.sid where s.cid = 01 and c.cid = 02 and s.score < c.score

7、查询学过“张三”老师所教的课的同学的学号、姓名；
select Sid from SC where cid not in 
(
select Cid from Course c inner join Teacher t on c.TId = t.TId and t.tname='张三')

08 查询课程编号“01”的成绩比课程编号“02”课程低的所有同学的学号、姓名；


09 查询所有课程成绩小于60分的同学的学号、姓名；
 select Student.sid,Student.sname from Student inner join (
select sid from SC group by sid having max(score) < 60) t
on Student.Sid = t.Sid

10 查询没有学全所有课的同学的学号、姓名
select sid,sname from Student where sid in(
select sid from SC group by sid having count(cid) < (
select count(distinct cid) from Course )
)

11 查询至少有一门课与学号为“01”的同学所学相同的同学的学号和姓名；（答案遗失了,零时用网站的答案）
select
    distinct sc.sid
from 
    (
        select
            cid
        from sc
        where sid='01'
    )t1
left join sc
    on t1.cid=sc.cid

12、查询和"01"号的同学学习的课程完全相同的其他同学的学号和姓名
#注意是和'01'号同学课程完全相同但非学习课程数相同的,这里我用左连接解决这个问题
select
    t1.sid,sname
from
    (
        select
            sc.sid
            ,count(distinct sc.cid)
        from 
            (
                select
                    cid
                from sc
                where sid='01'
            )t1 #选出01的同学所学的课程
        left join sc
            on t1.cid=sc.cid
        group by sc.sid
        having count(distinct sc.cid)= (select count(distinct cid) from sc where sid = '01')
    )t1
left join student
    on t1.sid=student.sid
where t1.sid!='01