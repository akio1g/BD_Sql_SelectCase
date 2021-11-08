CREATE DATABASE EXSELECTCASE

use EXSELECTCASE

CREATE TABLE users(
	id INT NOT NULL PRIMARY KEY IDENTITY (1, 1),
	name VARCHAR(45) NOT NULL, 
	username VARCHAR(45) NOT NULL UNIQUE,
	password VARCHAR(45) NOT NULL DEFAULT '123mudar',
	email VARCHAR(45) NOT NULL
)

CREATE TABLE projects(
	id INT NOT NULL PRIMARY KEY IDENTITY (10001, 1),
	name VARCHAR(45) NOT NULL,
	description VARCHAR(45),
	date VARCHAR(45) NOT NULL CHECK (CONVERT(DATE, date, 103) > '01/09/2014')
)

CREATE TABLE users_has_projects( 
	users_id INT NOT NULL,
	projects_id INT NOT NULL

	CONSTRAINT FK_users_id FOREIGN KEY (users_id) REFERENCES users(id),
	CONSTRAINT FK_projects_id FOREIGN KEY (projects_id) REFERENCES projects(id),

	CONSTRAINT PK_users_has_projects PRIMARY KEY (users_id, projects_id)
)

ALTER TABLE users
	ALTER COLUMN username VARCHAR(10)

ALTER TABLE users
	ALTER COLUMN password VARCHAR(8)

INSERT INTO users(name, username, password, email)
	VALUES ('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
		   ('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
		   ('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
		   ('Clara', 'Ti_clara','123mudar', 'clara@empresa.com'),
		   ('Aparecido', 'Rh_cido', '55@!cido', 'aparecido@empresa.com')

INSERT INTO projects( name, description, date)
	VALUES ('Re-folha', 'Refatoração das folhas', '05/09/2014'),
		   ('Manutenção PC´s', 'Manutenção PC´s', '06/09/2014'),
		   ('Auditoria', NULL, '07/09/2014')

INSERT INTO users_has_projects(users_id, projects_id)
	VALUES (1,10001),
		   (5,10001),
		   (3,10003),
		   (4,10002),
		   (2,10002)

UPDATE projects
	SET date = '12/09/2014'
	WHERE name like 'Manutenção %'

UPDATE users
	SET username = 'Rh_cido'
	WHERE name = 'Aparecido'

UPDATE users
	SET password = '888@*'
	WHERE username = 'Rh_maria' and password = '123mudar'

DELETE FROM users_has_projects
	WHERE users_id = 2 AND projects_id = 10002

SELECT id, name, email, username,
	CASE
		WHEN (password = '123mudar') THEN
			password
		ELSE 
			'********'
	END AS password
FROM users
	
SELECT name, description, date,
	CONVERT(VARCHAR(10),(DATEADD(DAY, 15,date)), 103) as data_final
FROM projects 
WHERE id IN 
(
	SELECT projects_id
	FROM users_has_projects 
	WHERE users_id IN
	(
		SELECT id 
		FROM users 
		WHERE email = 'aparecido@empresa.com'
	)
)

SELECT name, email 
FROM users
WHERE id IN 
(
	SELECT users_id 
	FROM users_has_projects 
	WHERE projects_id IN
	(
		SELECT id 
		FROM projects 
		WHERE name = 'Auditoria'
	)
)

SELECT name, description, date, 
		'16/09/2014' as data_final,
		DATEDIFF(DAY, date, '16/09/2014')*79.85 as custo_total
FROM projects 
WHERE name like '%Manutenção%'
