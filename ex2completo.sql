CREATE TABLE Filme(
id					INT				NOT NULL	PRIMARY KEY,
titulo				VARCHAR(40)		NOT NULL,
ano					INT				NULL		CHECK(ano <= 2021)
)

CREATE TABLE Estrela(
id					INT				NOT NULL	PRIMARY KEY,
nome				VARCHAR(50)		NOT NULL
)

CREATE TABLE Cliente(
num_cadastro		INT				NOT NULL	PRIMARY KEY,
nome				VARCHAR(70)		NOT NULL,
logradouro			VARCHAR(150)	NOT NULL,
num					INT				NOT NULL	CHECK (num > 0),
cep					CHAR(8)			NULL		CHECK (LEN(cep) = 8)
)

CREATE TABLE DVD(
num					INT				NOT NULL	PRIMARY KEY,
data_fabricacao		DATE			NOT NULL	CHECK (data_fabricacao < GETDATE()),
filmeId				INT				NOT NULL,

CONSTRAINT FK_filmeIdDvd 
	FOREIGN KEY(filmeId) 
	REFERENCES Filme(id)
)

CREATE TABLE Filme_Estrela(
filmeid				INT				NOT NULL,
estrelaid			INT				NOT NULL,

CONSTRAINT FK_filmeidEstrela 
	FOREIGN KEY (filmeid) 
	REFERENCES Filme(id),
CONSTRAINT FK_estrelaid 
	FOREIGN KEY (estrelaid) 
	REFERENCES Estrela(id),

CONSTRAINT PK_filme_estrela 
	PRIMARY KEY(filmeid, estrelaid)
)

CREATE TABLE Locacao(
dvdNum				INT				NOT NULL,
clienteNum_Cadastro INT				NOT NULL,
data_locacao		DATE			NOT NULL	DEFAULT(GETDATE()),
data_devolucao		DATE			NOT NULL,
valor				DECIMAL(7,2)	NOT NULL	CHECK (valor > 0),

CONSTRAINT chk_dt 
	CHECK (data_devolucao > data_locacao),

CONSTRAINT FK_dvdNum 
	FOREIGN KEY (dvdNum) 
	REFERENCES  DVD(num),
CONSTRAINT FK_clienteNum_Cadastro 
	FOREIGN KEY (clienteNum_Cadastro) 
	REFERENCES  Cliente(num_cadastro),

CONSTRAINT PK_Locacao 
	PRIMARY KEY (dvdNum, clienteNum_Cadastro, data_locacao)
)

ALTER TABLE Estrela 
	ADD nome_real VARCHAR(50) 

ALTER TABLE Filme
	ALTER COLUMN titulo VARCHAR(80)

INSERT INTO Filme(id, titulo, ano)
VALUES (1001, 'Whiplash', 2015),
	   (1002, 'Birdman', 2015),
       (1003, 'Interestelar', 2014),
	   (1004, 'A Culpa é das estrelas', 2014),
	   (1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroso', 2014),
	   (1006, 'Sing', 2016)

INSERT INTO Estrela(id, nome, nome_real)
VALUES (9901, 'Michael Keaton', 'Michael John Douglas'),
	   (9902, 'Emma Stone', 'Emily Jean Stone'),
   	   (9903, 'Miles Teller', NULL),
	   (9904, 'Steve Carell', 'Steven John Carell'),
	   (9905, 'Jennifer Garner', 'Jennifer Anne Garner')

INSERT INTO Filme_Estrela(filmeid, estrelaid)
VALUES (1002, 9901),
	   (1002, 9902),
	   (1001, 9903),
       (1005, 9904),
	   (1005, 9905)

INSERT INTO DVD(num, data_fabricacao, filmeId)
VALUES (10001, '2020-12-02', 1001),
		(10002, '2019-10-18', 1002),
		(10003, '2020-04-03', 1003),
		(10004, '2020-12-02', 1001),
		(10005, '2019-10-18', 1004),
		(10006, '2020-04-03', 1002),
		(10007, '2020-12-02', 1005),
		(10008, '2019-10-18', 1002),
		(10009, '2020-04-03', 1003)

INSERT INTO Cliente(num_cadastro, nome, logradouro, num, cep)
VALUES (5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
	(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
	(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
    (5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
	(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

INSERT INTO Locacao(dvdNum, clienteNum_Cadastro, data_locacao, data_devolucao, valor)
VALUES(10001, 5502,'2021-02-18', '2021-02-21', 3.50),
	  (10009, 5502, '2021-02-18', '2021-02-21', 3.50),
	  (10002, 5503, '2021-02-18', '2021-02-19', 3.50),
	  (10002, 5505, '2021-02-20', '2021-02-23', 3.00),
	  (10004, 5505, '2021-02-20', '2021-02-23', 3.00),
	  (10005, 5505, '2021-02-20', '2021-02-23', 3.00),
	  (10001, 5501, '2021-02-24', '2021-02-26', 3.50),
	  (10008, 5501, '2021-02-24', '2021-02-26', 3.50)

UPDATE Cliente	
	SET cep = '08411150'
	WHERE num_cadastro = '5503'
	
UPDATE Cliente
	SET cep = '02918190'
	WHERE num_cadastro = '5504'

UPDATE Locacao	
	SET valor = 3.25
	WHERE clienteNum_Cadastro = 5502 And data_locacao = '2021-02-18'

UPDATE Locacao	
	SET valor = 3.10
	WHERE clienteNum_Cadastro = 5501 And data_locacao = '2021-02-24'

UPDATE DVD	
	SET data_fabricacao = '2019-07-14'
	WHERE num = 10005

UPDATE Estrela	
	SET nome_real = 'Miles Alexander Teller'
	WHERE nome = 'Miles Teller'

DELETE FROM Filme
	WHERE titulo = 'Sing'

SELECT * FROM Filme 
WHERE ano = 2014

SELECT id, ano FROM Filme 
WHERE titulo = 'Birdman'

SELECT id, ano FROM Filme 
WHERE titulo like '%plash' 

SELECT id, nome, nome_real FROM Estrela 
WHERE nome like 'Steve%'

SELECT filmeId,
CONVERT(CHAR(10), data_fabricacao, 103) as data_fabricacao 
FROM DVD
WHERE data_fabricacao like '%2020%'
	
SELECT dvdNum, data_locacao, data_devolucao,
valor + 2 
FROM Locacao 
WHERE clienteNum_Cadastro = 5505

SELECT logradouro, num, cep 
FROM Cliente 
WHERE nome like 'Matilde Luz'

SELECT nome_real 
FROM Estrela 
WHERE nome like 'Michael Keaton'

SELECT id, ano, 
	CASE 
		WHEN LEN(titulo) >= 10 THEN
			SUBSTRING(titulo, 1, 10) + '....'
		ELSE
			titulo
	END as titulo
FROM Filme
WHERE id IN 
(
	SELECT filmeId
	FROM DVD	
	WHERE DATEDIFF(DAY, '01/01/2020', data_fabricacao) >= 0  
)

SELECT num, data_fabricacao,
	DATEDIFF(MONTH, data_fabricacao, GETDATE()) as qtd_meses_desde_fabricacao
FROM DVD
WHERE filmeId IN
(
	SELECT id 
	FROM Filme 
	WHERE titulo like 'Interestelar'
)

SELECT dvdNum, data_locacao, data_devolucao,	
		DATEDIFF(DAY, data_locacao, data_devolucao) as dias_alugado,
		valor
FROM Locacao 
WHERE clienteNum_Cadastro IN
(
	SELECT num_cadastro 
	FROM Cliente 
	WHERE nome like '%Rosa%'
)

SELECT nome, 
	logradouro + ',' + CAST(num as VARCHAR(5)) AS endereco_completo,
	SUBSTRING(cep, 1, 5)+'-'+ SUBSTRING(cep, 6, 3) AS cep
FROM Cliente 
WHERE num_cadastro IN 
(
	SELECT clienteNum_Cadastro
	FROM Locacao
	WHERE dvdNum = 10002
)
