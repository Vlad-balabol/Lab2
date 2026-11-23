DROP TABLE IF EXISTS New_table;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS Faculties;

CREATE TABLE Faculties (
    faculty_id SERIAL PRIMARY KEY,
    faculty_name VARCHAR(255) NOT NULL,
    foundation_date DATE NOT NULL,
    activity_type VARCHAR(255),
    max_students INT CHECK (max_students >= 0)
);

CREATE TABLE Groups (
    group_id SERIAL PRIMARY KEY,
    max_people INT CHECK (max_people >= 0),
    faculty_id INT NOT NULL,
    curator VARCHAR(255),
    CONSTRAINT fk_groups_faculties FOREIGN KEY (faculty_id) REFERENCES Faculties(faculty_id)
);

INSERT INTO Faculties (faculty_name, foundation_date, activity_type, max_students) VALUES 
('Факультет информатики', '2010-09-01', 'образовательная', 500),
('Факультет экономики', '2005-10-15', 'образовательная', 450),
('Факультет дизайна', '2018-03-01', 'творческая', 200),
('Медицинский факультет', '1999-11-20', 'образовательная', 600),
('Юридический факультет', '2001-09-05', 'образовательная', 350),
('Факультет лингвистики', '2012-07-10', 'образовательная', 280),
('Факультет психологии', '2008-02-28', 'образовательная', 320),
('Архитектурный факультет', '2015-09-01', 'творческая', 180),
('Факультет биотехнологий', '2019-04-15', 'научно-образовательная', 250),
('Факультет журналистики', '2003-10-01', 'образовательная', 300),
('Инженерный факультет', '1999-11-20', 'Технический', 600),
('Факультет теоретической физики', '2012-07-10', 'научная', 280);

INSERT INTO Groups (max_people, faculty_id, curator) VALUES 
(25, 1, 'Иванов И.И.'),
(30, 1, 'Петрова А.А.'),
(28, 2, 'Сидоров С.С.'),
(22, 3, 'Кузнецова К.К.'),
(35, 4, 'Смирнов С.М.'),
(27, 5, 'Васильев В.В.'),
(24, 6, 'Михайлова М.М.'),
(26, 7, 'Новиков Н.Н.'),
(20, 8, 'Федорова Ф.Ф.'),
(29, 9, 'Алексеев А.А.'),
(25, 11, 'Инженеров И.И.'),
(25, 12, 'Физиков Ф.Ф.'),
(10, 11, NULL),
(12, 11, 'Петров П.П.');

SELECT 'Таблицы созданы и заполнены' AS status;

--ЗАДАНИЕ 1
SELECT * FROM Faculties
WHERE activity_type = 'Технический' AND max_students > 200;

--ЗАДАНИЕ 2
SELECT g.* FROM Groups g
JOIN Faculties f ON g.faculty_id = f.faculty_id
WHERE f.faculty_name = 'Факультет теоретической физики' AND g.max_people > 20;

--ЗАДАНИЕ 3
CREATE TABLE New_table AS
SELECT f.faculty_id, f.faculty_name, f.activity_type, f.max_students, g.group_id, g.curator
FROM Faculties f
JOIN Groups g ON f.faculty_id = g.faculty_id
WHERE f.activity_type = 'Технический' AND f.max_students > 200;

SELECT * FROM New_table;

--ЗАДАНИЕ 4
INSERT INTO New_table (faculty_id, faculty_name, activity_type, max_students, group_id, curator)
SELECT f.faculty_id, f.faculty_name, f.activity_type, f.max_students, g.group_id, g.curator
FROM Groups g
JOIN Faculties f ON g.faculty_id = f.faculty_id
WHERE g.max_people < 15;

SELECT * FROM New_table;
--ЗАДАНИЕ 5
UPDATE New_table
SET group_id = CAST(CONCAT('9', SUBSTRING(CAST(group_id AS VARCHAR), 2)) AS INT)
WHERE activity_type = 'Технический';

SELECT * FROM New_table;
--ЗАДАНИЕ 6
DELETE FROM New_table WHERE curator IS NULL;

SELECT * FROM New_table;
--ЗАДАНИЕ 7
SELECT faculty_name, COUNT(group_id) AS count_groups, SUM(max_students) AS total_max_students
FROM New_table
GROUP BY faculty_name;