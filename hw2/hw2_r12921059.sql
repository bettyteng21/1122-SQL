/* create and use database */
CREATE DATABASE `palworld`;
USE `palworld`;


/* info */
CREATE TABLE self (
    StuID varchar(10) NOT NULL,
    Department varchar(10) NOT NULL,
    SchoolYear int DEFAULT 1,
    Name varchar(10) NOT NULL,
    PRIMARY KEY (StuID)
);

INSERT INTO self VALUES ('r12921059', '電機所', 1, '鄧雅文');
SELECT DATABASE();
SELECT * FROM self;

/* create table */
CREATE TABLE `ELEMENT`
(
    `elementID` INT CHECK(elementID>0),
    `elementName` VARCHAR(50) NOT NULL,
    `info` VARCHAR(200) DEFAULT "No decription.",
    `supperessID` INT DEFAULT 0,
    CHECK(elementName IN ('fire', 'water', 'electric', 'ground', 'grass', 'ice', 'dark', 'dragon','neutral')),
    CHECK (elementID != supperessID),
    PRIMARY KEY(elementName),
    UNIQUE(elementID),
    FOREIGN KEY(supperessID) REFERENCES ELEMENT(elementID)
);

CREATE TABLE `PAL`
(
	`id` INT NOT NULL CHECK(id>0),
	`name` VARCHAR(50) NOT NULL,
	`gender` ENUM('women','men','other') DEFAULT 'women',
    PRIMARY KEY(id)
);

CREATE TABLE `PAL_BELONG_ELEMENT`
(
	`palID` INT NOT NULL CHECK(palID>0),
	`elementName` VARCHAR(50) NOT NULL, 
    `info` VARCHAR(100) DEFAULT "No decription.",
    CHECK(elementName IN ('fire', 'water', 'electric', 'ground', 'grass', 'ice', 'dark', 'dragon','neutral')),
    PRIMARY KEY(palID,elementName),
    FOREIGN KEY(palID) REFERENCES PAL(id),
    FOREIGN KEY(elementName) REFERENCES ELEMENT(elementName)
);

CREATE TABLE `SKILL`
(	
	`skillID` INT AUTO_INCREMENT PRIMARY KEY,
	`skillName` VARCHAR(50) NOT NULL,
    `skillStatus` VARCHAR(100) DEFAULT '0,0,0', -- CT, power, range
    UNIQUE(skillName),
    FOREIGN KEY(skillID) REFERENCES ELEMENT(elementID)
);

CREATE TABLE `OBTAIN_SKILL`
(
	`obtainID` INT AUTO_INCREMENT PRIMARY KEY,
	`palID` INT NOT NULL CHECK(palId>0),
	`skillName` VARCHAR(50) DEFAULT 'No skill',
    FOREIGN KEY(palID) REFERENCES PAL(id),
    FOREIGN KEY(skillName) REFERENCES SKILL(skillName)
);

CREATE TABLE `SKILL_BELONG_ELEMENT`
(
	`skillName` VARCHAR(50) NOT NULL,
	`elementName` VARCHAR(50) NOT NULL, 
    `info` VARCHAR(100) DEFAULT "No decription.",
    CHECK(elementName IN ('fire', 'water', 'electric', 'ground', 'grass', 'ice', 'dark', 'dragon','neutral')),
    PRIMARY KEY(skillName,elementName),
    FOREIGN KEY(skillName) REFERENCES SKILL(skillName),
    FOREIGN KEY(elementName) REFERENCES ELEMENT(elementName)
);

CREATE TABLE `PASSIVE`
(
	`skillID` INT AUTO_INCREMENT,
    `skillName` VARCHAR(50) NOT NULL,
	`isToSelf` BOOL DEFAULT 1,
    `isPositive` BOOL NOT NULL,
    `info` VARCHAR(100) DEFAULT "No decription.",
    PRIMARY KEY(skillName),
    FOREIGN KEY(skillID) REFERENCES SKILL(skillID)
);

CREATE TABLE `ACTIVE`
(	
	`skillID` INT AUTO_INCREMENT,
	`skillFruitName` VARCHAR(50) NOT NULL,
    `coordinate` DECIMAL(8,4) DEFAULT 0.0,
    `rarity` INT CHECK(rarity>0),
    `info` VARCHAR(100) DEFAULT "No decription.",
    PRIMARY KEY(skillFruitName),
    FOREIGN KEY(skillID) REFERENCES SKILL(skillID)
);

DELIMITER $$
CREATE TRIGGER CheckDisjointSpecializationInPASSIVE
BEFORE INSERT ON `PASSIVE`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM `ACTIVE` WHERE skillID = NEW.skillID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Skill cannot be both active and passive!';
    END IF;
END;
$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER CheckDisjointSpecializationInACTIVE
BEFORE INSERT ON `ACTIVE`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM `PASSIVE` WHERE skillID = NEW.skillID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Skill cannot be both active and passive!';
    END IF;
END;
$$
DELIMITER ;

CREATE TABLE `CONSTRUCTION`
(
	`constructID` INT AUTO_INCREMENT PRIMARY KEY,
    `constructName` VARCHAR(50) NOT NULL,
    `info` VARCHAR(100) DEFAULT "No decription.",
    UNIQUE(constructName)
);

CREATE TABLE `INFRASTRUCTURE`
(
	`infraID` INT AUTO_INCREMENT PRIMARY KEY,
    `infraName` VARCHAR(50) NOT NULL,
    `usage` VARCHAR(100) DEFAULT "Description null.",
    `techLevel` INT CHECK(techLevel>0),
    UNIQUE(infraName),
    FOREIGN KEY(infraID) REFERENCES CONSTRUCTION(constructID)
);

CREATE TABLE `SAN`
(
	`sanID` INT AUTO_INCREMENT PRIMARY KEY,
    `infraName` VARCHAR(50) NOT NULL,
    `recoverPoint` FLOAT DEFAULT 0.0,
    `info` VARCHAR(50) DEFAULT "null",
    FOREIGN KEY(infraName) REFERENCES INFRASTRUCTURE(infraName)
);

CREATE TABLE `HEAL`
(
	`healID` INT AUTO_INCREMENT PRIMARY KEY,
    `infraName` VARCHAR(50) NOT NULL,
    `recoverPoint` FLOAT DEFAULT 0.0,
    `info` VARCHAR(50) DEFAULT "null",
    FOREIGN KEY(infraName) REFERENCES INFRASTRUCTURE(infraName)
);

CREATE TABLE `MATERIAL`
(
	`materialName` VARCHAR(50) NOT NULL,
	`constructName` VARCHAR(50) NOT NULL,
    `amount` INT DEFAULT 0,
    `rarity` INT,
    PRIMARY KEY(materialName, constructName),
    FOREIGN KEY(constructName) REFERENCES CONSTRUCTION(constructName)
);

/*
CREATE TABLE `IS_COMPOSITE`
(
    `constructID1` INT NOT NULL,
    `constructID2` INT NOT NULL,
	`materialID1` INT NOT NULL,
	`materialID2` INT NOT NULL,
    PRIMARY KEY(constructID1, materialID1, constructID2, materialID2),
    CHECK(materialID1 != materialID2 and constructID1 != constructID2),
    FOREIGN KEY(materialID1, constructID1) REFERENCES MATERIAL(constructID, materialID),
    FOREIGN KEY(materialID2, constructID2) REFERENCES MATERIAL(constructID, materialID)
);
*/

CREATE TABLE `USE_INFRA`
(
	`palID` INT NOT NULL CHECK(palID>0),
	`infraID` INT CHECK(infraID>0),
    `info` VARCHAR(100) DEFAULT "No decription.",
    PRIMARY KEY(palID, infraID),
    FOREIGN KEY(palID) REFERENCES PAL(id),
    FOREIGN KEY(infraID) REFERENCES INFRASTRUCTURE(infraID)
);

CREATE TABLE `STORAGE`
(
	`storageID` INT,
    `storageName` VARCHAR(50) NOT NULL,
    `slot` INT DEFAULT 0,
    `techLevel` INT CHECK(techLevel>0),
    PRIMARY KEY(storageName),
    FOREIGN KEY(storageID) REFERENCES CONSTRUCTION(constructID)
);


/* insert */
-- 'fire', 'water', 'electric', 'ground', 'grass', 'ice', 'dark', 'dragon','neutral'
SET FOREIGN_KEY_CHECKS = 0;
INSERT INTO ELEMENT (elementID, elementName) 
VALUES (1,'fire'), (2,'water'), (3,'electric'), (4,'ground'), (5,'grass'), (6,'ice'), (7,'dark'), (8,'dragon'), (9,'neutral');

SET FOREIGN_KEY_CHECKS = 1;
UPDATE ELEMENT SET supperessID = 6 WHERE elementName = 'fire';
UPDATE ELEMENT SET supperessID = 1 WHERE elementName = 'water';
UPDATE ELEMENT SET supperessID = 2 WHERE elementName = 'electric';
UPDATE ELEMENT SET supperessID = 3 WHERE elementName = 'ground';
UPDATE ELEMENT SET supperessID = 4 WHERE elementName = 'grass';
UPDATE ELEMENT SET supperessID = 8 WHERE elementName = 'ice';
UPDATE ELEMENT SET supperessID = 9 WHERE elementName = 'dark';
UPDATE ELEMENT SET supperessID = 7 WHERE elementName = 'dragon';


INSERT INTO PAL VALUES (1, 'Lamball', 'women');
INSERT INTO PAL VALUES (2, 'Cattiva', 'men');
INSERT INTO PAL VALUES (11, 'Penking', 'men');
INSERT INTO PAL VALUES (71, 'Vanwyrm', 'women');

INSERT INTO PAL_BELONG_ELEMENT(palID,elementName)
VALUES (1,'neutral'),(2,'neutral'),(11,'water'), (11,'ice'), (71,'fire'), (71,'dark');

INSERT INTO SKILL(skillName,skillStatus) -- CT, power, range
VALUES ('Air Cannon','2,25,500'), ('Spirit Fire','7,45,1000'), ('Aqua Gun','4,40,500'), ('Sand Blast','4,40,500'), 
	('Serious','0,0,0'), ('Lucky','0,0,0'), ('Clumsy','0,0,0'), ('Coward','0,0,0');

INSERT INTO OBTAIN_SKILL(palID,skillName)
VALUES (1,'Air Cannon'), (2,'Air Cannon'), (2,'Sand Blast'), (11,'Aqua Gun'), (71,'Spirit Fire'),
	(1, 'Serious'), (71, 'Lucky'), (11, 'Coward');

INSERT INTO SKILL_BELONG_ELEMENT(skillName,elementName)
VALUES ('Air Cannon','neutral'), ('Sand Blast','ground'), ('Aqua Gun','water'), ('Spirit Fire','fire');

INSERT INTO `ACTIVE`(skillFruitName,coordinate,rarity)
VALUES ('Air Cannon', 123.345, 5), ('Sand Blast', 46.245, 5), ('Aqua Gun', 67.94, 4), ('Spirit Fire', 98.476, 3);

INSERT INTO `PASSIVE`(skillName,isToSelf,isPositive)
VALUES ('Serious',1,1), ('Lucky',1,1), ('Clumsy',1,0), ('Coward',1,0);

INSERT INTO CONSTRUCTION(constructName)
VALUES ('Straw Pal Bed'), ('Hot Spring'), ('Fluffy Pal Bed'), ('Wooden Chest'), ('Wooden Barrel');

INSERT INTO INFRASTRUCTURE(infraName, techLevel)
VALUES ('Straw Pal Bed',3), ('Hot Spring',9), ('Fluffy Pal Bed',24);

INSERT INTO SAN(infraName, recoverPoint)
VALUES ('Straw Pal Bed',0.05), ('Hot Spring',0.5), ('Fluffy Pal Bed',0.1);

INSERT INTO HEAL(infraName, recoverPoint)
VALUES ('Straw Pal Bed',1.5), ('Fluffy Pal Bed',2.5);

INSERT INTO `STORAGE`(storageName,slot,techLevel)
VALUES ('Wooden Chest',10,2), ('Wooden Barrel',8,8);

INSERT INTO USE_INFRA(palID,infraID)
SELECT p.id, i.infraID
FROM PAL p, INFRASTRUCTURE i;

INSERT INTO MATERIAL(materialName, constructName, amount, rarity)
VALUES ('Wood','Wooden Chest',15,5), ('Stone','Wooden Chest',5,5), ('Wood','Wooden Barrel',30,5), ('Stone','Wooden Barrel',5,5), 
('Cloth','Fluffy Pal Bed',10,5), ('Wood','Fluffy Pal Bed',30,5), ('Nail','Fluffy Pal Bed',5,4), ('Fiber','Fluffy Pal Bed',10,5),
('Wood','Straw Pal Bed',10,5), ('Fiber','Straw Pal Bed',5,5), 
('Wood','Hot Spring',30,5), ('Stone','Hot Spring',15,5), ('Paldium Fragment','Hot Spring',10,5), ('Pal Fluids','Hot Spring',10,5);


/* create two views*/
CREATE VIEW pal_skill_overview AS
SELECT p.id, p.`name`, o.skillName, s.skillStatus, b.elementName 'skillElement'
FROM PAL p
INNER JOIN OBTAIN_SKILL o ON p.id = o.palID
INNER JOIN SKILL s ON o.skillName = s.skillName
INNER JOIN SKILL_BELONG_ELEMENT b ON s.skillName = b.skillName;

CREATE VIEW all_construction_overview AS
SELECT m.constructName, i.techLevel 'infraTechLevel', s.techLevel 'storageTechLevel', m.materialName 'requiredMaterial', m.amount
FROM MATERIAL m
LEFT JOIN INFRASTRUCTURE i ON i.infraName = m.constructName
LEFT JOIN `STORAGE` s ON s.storageName = m.constructName
ORDER BY i.techLevel, s.techLevel, m.constructName;


/* select from all tables and views */
SELECT * FROM pal_skill_overview;
SELECT * FROM all_construction_overview;

SELECT * FROM `ACTIVE`;
SELECT * FROM CONSTRUCTION;
SELECT * FROM ELEMENT;
SELECT * FROM HEAL;
SELECT * FROM INFRASTRUCTURE;
SELECT * FROM MATERIAL;
SELECT * FROM OBTAIN_SKILL;
SELECT * FROM PAL;
SELECT * FROM PAL_BELONG_ELEMENT;
SELECT * FROM PASSIVE;
SELECT * FROM SAN;
SELECT * FROM SKILL;
SELECT * FROM SKILL_BELONG_ELEMENT;
SELECT * FROM `STORAGE`;
SELECT * FROM USE_INFRA;


/* drop database */
DROP DATABASE palworld;







