USE mydatabase;

-- 1. Prepared statement --
PREPARE select_from_dept 
FROM 'SELECT * FROM student WHERE TRIM(系所) = ?';

SET @dept1 = "電機所";
EXECUTE select_from_dept USING @dept1;

SET @dept2 = "資工所";
EXECUTE select_from_dept USING @dept2;


-- 2. Stored-function --
-- DROP FUNCTION get_chinese_name;
DELIMITER $$
CREATE FUNCTION get_chinese_name(`full_name` VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE idx INT DEFAULT 0;
    DECLARE chinese_name VARCHAR(100);
    SET idx = LOCATE(' (', full_name);
	
    IF idx = 0 THEN
		-- if cannot find ' (', meaning there's no eng name
		RETURN `full_name`;
	ELSE
		SET chinese_name = SUBSTRING(`full_name`, 1, idx-1);
		RETURN chinese_name;
	END IF;
    
END$$
DELIMITER ;

-- DROP FUNCTION get_english_name;
DELIMITER $$
CREATE FUNCTION get_english_name(`full_name` VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE idx INT DEFAULT 0;
    DECLARE end_idx INT DEFAULT 0;
    DECLARE english_name VARCHAR(100);
    SET idx = LOCATE(' (', full_name);
	
    IF idx = 0 THEN
		-- if cannot find ' (', meaning there's no eng name
		RETURN "";
	ELSE
		-- return the name inside ()
		SET end_idx = LOCATE(')', full_name, idx);
		SET english_name = SUBSTRING(`full_name`, idx+2, end_idx-idx-2);
		RETURN english_name;
	END IF;
    
END$$
DELIMITER ;

SELECT get_chinese_name(姓名) AS `Chinese Name`, get_english_name(姓名) AS `English Name`
FROM student
WHERE `group` = 7;

-- 3. Stored procedure --
-- DROP PROCEDURE count_dept_student;
SET @STCOUNT = 0;

DELIMITER $$
CREATE PROCEDURE count_dept_student(IN dept_name VARCHAR(100))
BEGIN
    SELECT COUNT(*) INTO @STCOUNT FROM student WHERE TRIM(`系所`) = dept_name;
END$$
DELIMITER ;

CALL count_dept_student('電機所');
SELECT @STCOUNT AS 'Student Count in 電機所';

CALL count_dept_student('資工所');
SELECT @STCOUNT AS 'Student Count in 資工所';


-- 4. View --
-- DROP VIEW IF EXISTS new_student;
CREATE VIEW new_student AS
SELECT `身份`, `系所`, `年級`, `學號`, get_chinese_name(`姓名`) AS `中文名`, get_english_name(`姓名`) AS `英文名`, `信箱`, `班別`
FROM student 
WHERE TRIM(`系所`) = "電機所";

SELECT `系所`, `學號`, `年級`, `中文名`, `英文名`
FROM new_student;



-- 5. Trigger --
-- DROP TRIGGER IF EXISTS after_student_delete;
-- DROP TRIGGER IF EXISTS after_student_insert;
-- DROP TABLE IF EXISTS record_table;
-- SHOW FULL PROCESSLIST;
CREATE TABLE record_table (
	`timestamp` DATETIME,
    `user_name` VARCHAR(100),
    `action_type` VARCHAR(100),
    `student_id` VARCHAR(100)
);

SET @NUMDEL = 0;
SET @NUMINS = 0;

DELIMITER $$
CREATE TRIGGER after_student_delete 
AFTER DELETE ON student 
FOR EACH ROW 
BEGIN 
     INSERT INTO record_table (`timestamp`, `user_name`, `action_type`, `student_id`)
     VALUES (NOW(), USER(), 'Delete', OLD.`學號`);

     SET @NUMDEL = @NUMDEL + 1;
    
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER after_student_insert 
AFTER INSERT ON student 
FOR EACH ROW 
BEGIN 
    INSERT INTO record_table(`timestamp`, `user_name`, `action_type`, `student_id`)
    VALUES (NOW(), USER(), 'Insert', NEW.`學號`);
    
    SET @NUMINS = @NUMINS + 1;
    
END $$
DELIMITER ;

SELECT * FROM record_table;
SELECT @NUMDEL, @NUMINS;

-- Example insert and delete
INSERT INTO student (身份, 系所, 年級, 學號, 姓名, 信箱, 班別) 
VALUES ('學生', '電機所', 1, 'R00000001', 'aaa', 'aaa@example.com', '課課'),
	   ('學生', '電機所', 2, 'R00000002', 'bbb', 'bbb@example.com', '課課'),
	   ('學生', '電機所', 3, 'R00000003', 'ccc', 'ccc@example.com', '課課');
ALTER TABLE student ADD INDEX idx_student_id (學號);
DELETE FROM student WHERE 學號 IN ('R00000001','R00000002');

SELECT * FROM record_table;
SELECT @NUMDEL, @NUMINS;




