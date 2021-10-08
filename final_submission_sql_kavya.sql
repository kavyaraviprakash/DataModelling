----Name : Kavya Raviprakash

DROP TABLE TEACHER CASCADE CONSTRAINTS;
DROP TABLE STUDENT_STORY CASCADE CONSTRAINTS;
DROP TABLE STUDENT_PARENT CASCADE CONSTRAINTS;
DROP TABLE STUDENT_FEEDBACK CASCADE CONSTRAINTS;
DROP TABLE STUDENT_ENROLLMENT CASCADE CONSTRAINTS;
DROP TABLE STUDENT CASCADE CONSTRAINTS;
DROP TABLE STORY CASCADE CONSTRAINTS;
DROP TABLE STORY_COMMENT CASCADE CONSTRAINTS;
DROP TABLE SKILL CASCADE CONSTRAINTS;
DROP TABLE SHARED_TEACHING CASCADE CONSTRAINTS;
DROP TABLE PARENT_OF_STUDENT CASCADE CONSTRAINTS;
DROP TABLE DOJO_PARENT_LIKES CASCADE CONSTRAINTS;
DROP TABLE CLASS_STORY CASCADE CONSTRAINTS;
DROP TABLE CLASS_DOJO_CLASS CASCADE CONSTRAINTS;
DROP TABLE STUDENT_PARENT_LIKES CASCADE CONSTRAINTS;
DROP TABLE dojo_parent_likes CASCADE CONSTRAINTS;
COMMIT;



-- Student name: < Insert here >

-- Give feedback to student (slide 13)
-- Let's write several statements necessary to add a feedback to a student
-- We need several date points: teacher_id, class_id, student_id, skill_id, skill_weight, skill_negpos
-- We will get these information by writing several SELECT statements before we INSERT our feedback.

-- First, let's start with the teacher. Write a statement that selects all teacher we have in our table
-- (In the app, we wouldn't need this, because the teacher would log into the app with their credentials.)

-- < 1 Write your SELECT statement here >

SELECT teacher_id
FROM TEACHER;

-- Review the result and select one of the three teachers.

-- For this teacher (teacher_id), write a statement that shows all classes the teacher
-- is either resonsible for or is teaching as a co-teacher.
-- Display the class_ids only.
-- Hint: Since these are two different relationships, I would advise to use UNION

-- < 2 Write your SELECT statement here >

/*    SELECT teacher_id
    FROM shared_teaching
    WHERE teacher_id IN (
    SELECT teacher_id
    FROM class_dojo_class
    WHERE teacher_id = 13927);
    UNION
    SELECT teacher_id
    FROM teacher
    WHERE teacher_id IN (
        SELECT teacher_id
        FROM class_dojo_class
        WHERE teacher_id = 13927
    );*/--->please ignore created to compare results

SELECT class_id
FROM shared_teaching
WHERE teacher_id = 13927
UNION
SELECT class_id
FROM class_dojo_class
WHERE teacher_id = 13927

--class_id=15232

-- Review the result and select a class.

-- First, write a statement that selects all students (student_id, first name, last name, and username)
-- from the class (class_id) you choose.
-- Order by user name

-- < 3 Write your SELECT statement here >

SELECT student_id, student_first_name, student_last_name, student_username
FROM student
WHERE student_id IN(
   SELECT student_id
   FROM student_enrollment
   WHERE class_id = 15232)
ORDER BY student_username;

-- Look at the result and select one student. Remember the student_id.

-- Write a statement that select either all positive or all negative skills for the class (class_id) you choose.

-- < 4 Write your SELECT statement here >

---student_id = 218331 --for review

---class_id = 15232 ---to be chosen

--SELECT *
--FROM Skill;


/*SELECT skill_negpos
FROM SKILL sq
WHERE skill_negpos = (
   SELECT skill_negpos
   FROM  SKILl
   WHERE  );*/
                                          

SELECT sk.skill_negpos, sk.skill_id, sk.skill_weight
FROM skill sk
WHERE sk.skill_negpos = 0 OR sk.skill_negpos = 1
AND class_id = 15232;

-- Review the result and select one skill that you want to use in the subsequent query.
-- Remember the skill_id and the points (positive for positive behavior, negative for negative behavior)

-- We have all information that we need:
-- class_id, student_id, skill_id, skill_weight, skill_posneg, teacher_id

-- Write an INSERT statement to create a new feedback for the class, student, and 
-- You need one INSERT statement to create a new feedback.
-- Don't forget to update the points in the tables student enrollment and class. (Two UPDATE statements needed)
-- The feedback is for the individual student.
-- Use SYSDATE for the date.

-- < 5 Write your INSERT statement here >

-->Skill_id to remember is 1 ---> skill_negpos = 1, skill_weight = 3
  ---class_id = 15232
   --skill_id = 1
   --skill_negpos = 1
  -- skill_weight = 3
   --student_id = 218331
   --teacher_id = 13927
   --Parent_id = 833250

-- Feedback points are nothing but total value of skill_negpos can be two format:
-- total of skill_pos or skill_neg or combination of both

INSERT INTO student_feedback(feedback_id, feedback_datetime,feedback_given_to, feedback_note,feedback_points, student_id,class_id,skill_id,teacher_id)
VALUES(13124,TO_DATE(TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'MM-DD-YYYY HH24:MI:SS'), 'individual student','Nice work',3,218331,15232,1,13927);

COMMIT;

---> Refered to publish date and time using sysdate from below link: Adopted from:
-->https://stackoverflow.com/questions/45421907/oracle-insert-date-and-time-into-date-column-stored-procedure 



-- < 6 Write your first UPDATE statement (table student enrollment) here >
-- Hint:add or remove points from total points and add points to either positive or negative points
-- for the student you selected (student_id)
-- Don't forget that the student could have already earned points, so student_points_total = 3 will not work.

UPDATE student_enrollment 
SET student_points_total = student_points_total + student_points_negative + ((student_points_positive) + 2) +(SELECT feedback_points FROM student_feedback WHERE student_id= 218331)
WHERE student_id =218331;


UPDATE student_enrollment
SET student_points_negative = student_points_negative + 2,
WHERE student_id = 218331;
COMMIT;

UPDATE student_enrollment
SET STUDENT_POINTS_POSITIVE = STUDENT_POINTS_POSITIVE + 2,
WHERE student_id = 218331;

-- < 7 Write your second UPDATE statement (table class) here >
-- Hint: add or remove points from the class points (hard code number of points)
-- for the class you selected (class_id)

UPDATE CLASS_DOJO_CLASS 
SET class_points = class_points + 1
WHERE class_id = 15232;

-- Commit!
COMMIT;

--8
-- Let's create a class story and add a comment and a like
-- Use the same class_id and teacher_id as before
-- Depending on how you transformed the conceptual model, you will need one or two
-- INSERT statement.
-- If you kept the subtype in its own table, you will need two INSERT statements.
-- If you only kept the supertype, you will need one.
-- Use SYSDATE for the create and publish dates.

INSERT INTO STORY VALUES (52345,'self learning is best learning', TO_DATE(TO_CHAR (SYSDATE, 'YYYY-MON-DD HH24:MI:SS'),'yyyy/mm/dd hh24:mi:ss'), TO_DATE(TO_CHAR (SYSDATE, 'YYYY-MON-DD HH24:MI:SS'),'yyyy/mm/dd hh24:mi:ss'));
COMMIT;
--UPDATE STORY
--SET STORY_ID = 52345

---> Refered to publish date and time using sysdate from below link: Adopted from:
-->https://stackoverflow.com/questions/45421907/oracle-insert-date-and-time-into-date-column-stored-procedure 

-- < 9 Write INSERT statement here (not needed if sub type is not an own table) >
--class_id = 15232
--   skill_id = 1
--  skill_negpos = 1
--   skill_weight = 3
 --  student_id = 218331
 --  teacher_id = 13927
 --  Parent_id = 833250

INSERT INTO class_story(story_id, class_story_comments_allowed, class_id,teacher_id)
    VALUES(52345,'enabled',15232,13927);
    
COMMIT;    
	
--INSERT INTO student_story (story_id, student_story_approved, student_id,class_id,teacher_id)
--	VALUES(52345,'Approved',218331,15232,13927);

-- Let's have a parent view, like, and comment on the story.

-- First, find the parent_id of a parent from the student you used above. Write a statement to do so.
-- Hint: you only need one table to find the parent_id for a specific student (student_id)

-- < 10 Write your SELECT statement here >

SELECT PARENT_ID
FROM student_parent
WHERE student_id = 218331

--Parent_id = 833250

-- For the parent_id you receive, find all stories the parent can view since March 1st, 2021.
-- This query requires quite a few joins!
-- Display only stories from classes, not student stories.
-- Retrieve story id, story text, and story publish datetime

-- < 11 Write your SELECT statement here >

--please ignore below solution
/*SELECT st.student_id, sp.parent_id, cd.class_id ----> executed to compare results
FROM student_parent sp
LEFT JOIN student st ON sp.parent_id = st.student_id
LEFT JOIN student_enrollment se ON st.student_id = se.student_id
LEFT JOIN class_dojo_class cd ON se.class_id = cd.class_id
LEFT JOIN class_story cs ON cd.class_id = cs.class_id
LEFT JOIN story st ON cs.story_id = st.story_id
WHERE parent_id = 833250
AND st.story_publish_datetime > '01-MAR-21';*/

---Solution
SELECT so.story_id, so.story_text, so.story_create_datetime, so.story_publish_datetime
FROM parent_of_student ps
LEFT JOIN student_parent sp ON ps.parent_id = sp.parent_id
LEFT JOIN student st ON sp.student_id = st.student_id
LEFT JOIN student_enrollment se ON st.student_id = se.student_id
LEFT JOIN class_dojo_class cd ON se.class_id = cd.class_id
LEFT JOIN class_story c ON cd.class_id = c.class_id
LEFT JOIN story so ON c.story_id = so.story_id
WHERE ps.parent_id = 833250
AND so.story_publish_datetime > '01-MAR-21';
----

---->Executed to verify

/*SELECT *
FROM student_parent
WHERE parent_id = 833250*/

-- The parent likes the story. Insert a new like!

-- < 12 Write INSERT statement here >

INSERT INTO dojo_parent_likes(parent_id, story_id)
                         VALUES(833250,52345);
COMMIT;                         

-- The parent comments on the story. Insert a comment!

-- < 13 Write INSERT statement here >

--INSERT INTO story_comment(story_id,parent_id,comment_text,comment_datetime)
  INSERT INTO story_comment VALUES ('GOOD JOB', TO_DATE(TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'MM-DD-YYYY HH24:MI:SS'), 833250,52345);

COMMIT; 

---> Refered to publish date and time using sysdate from below link: Adopted from:
-->https://stackoverflow.com/questions/45421907/oracle-insert-date-and-time-into-date-column-stored-procedure 

-- Write a query that counts how many likes the story you created has.

-- < 14 Write your SELECT statement here >

SELECT COUNT(parent_id) likes
FROM dojo_parent_likes 
WHERE story_id = 52345;