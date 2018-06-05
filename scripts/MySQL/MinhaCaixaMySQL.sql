 DROP DATABASE IF EXISTS MinhaCaixa;
/*Create Database*/
CREATE DATABASE IF NOT EXISTS MinhaCaixa;

USE MinhaCaixa;

/*CREATE TABLES*/
CREATE TABLE IF NOT EXISTS Grupo
(
    GrupoCodigo INT auto_increment,
    GrupoNome VARCHAR(50),
    GrupoRazaoSocial VARCHAR(50),
    GrupoCNPJ varchar(20),
    constraint PK_Grupo primary key (GrupoCodigo)
);

CREATE TABLE IF NOT EXISTS Clientes
(
	ClienteCodigo int auto_increment,
	ClienteNome varchar (50),
	ClienteRua varchar (50),
	ClienteCidade varchar (50),
	ClienteNascimento datetime,
    CONSTRAINT PK_CLIENTES PRIMARY KEY (ClienteCodigo)

);

CREATE TABLE IF NOT EXISTS Agencias
(
    AgenciaCodigo INT auto_increment,
    AgenciaNome VARCHAR (50),
    AgenciaCidade varchar (50),
    AgenciaFundos decimal(10,2),
    GrupoCodigo int,
    CONSTRAINT PK_Agencias PRIMARY KEY (AgenciaCodigo)
);


CREATE TABLE IF NOT EXISTS Contas
(
    AgenciaCodigo int,
    ContaNumero VARCHAR (10),
    ClienteCodigo int,
    ContaSaldo DECIMAL(8,2),
    ContaAbertura datetime,
    CONSTRAINT PK_CONTA PRIMARY KEY (ContaNumero)
);

create table IF NOT EXISTS Emprestimos
(
    AgenciaCodigo INT,
    ClienteCodigo int,
    EmprestimoCodigo varchar (10),
    EmprestimoTotal DECIMAL(8,2),
    CONSTRAINT PK_EMPRESTIMOS PRIMARY KEY (EmprestimoCodigo)
);

CREATE TABLE IF NOT EXISTS Depositantes
(
	DepositanteCodigo int auto_increment,
    AgenciaCodigo INT,
    ContaNumero varchar( 10 ) ,
    ClienteCodigo int,
    DepositoValor DECIMAL( 8, 2 ) ,
    DepositoData DATETIME,
    CONSTRAINT PK_DEPOSITANTES PRIMARY KEY (DepositanteCodigo)
);

create table IF NOT EXISTS Devedores
(
	DevedorCodigo int auto_increment,
    AgenciaCodigo INT,
    ClienteCodigo int,
    EmprestimoCodigo varchar (10),
    DevedorSaldo DECIMAL(8,2),
    CONSTRAINT PK_DEVEDORES PRIMARY KEY (DevedorCodigo)
);


create table IF NOT EXISTS CartaoCredito
(
    AgenciaCodigo INT,
    ClienteCodigo int,
    CartaoCodigo varchar (20),
    CartaoLimite DECIMAL(8,2),
    CONSTRAINT PK_CARTAOCREDITO PRIMARY KEY (CartaoCodigo)
);

ALTER TABLE Agencias ADD CONSTRAINT FK_GRUPOS_AGENCIAS 
FOREIGN KEY ( GrupoCodigo ) REFERENCES Grupo (GrupoCodigo);

ALTER TABLE CartaoCredito ADD CONSTRAINT FK_CARTAOCREDITO_AGENGIA
FOREIGN KEY ( AgenciaCodigo ) REFERENCES Agencias(AgenciaCodigo);

ALTER TABLE CartaoCredito ADD CONSTRAINT FK_CARTAOCREDITO_CLIENTES 
FOREIGN KEY ( ClienteCodigo ) REFERENCES Clientes (ClienteCodigo);

ALTER TABLE Contas ADD CONSTRAINT FK_CLIENTES_CONTAS 
FOREIGN KEY  ( ClienteCodigo ) REFERENCES Clientes (ClienteCodigo);

ALTER TABLE Contas ADD CONSTRAINT FK_AGENCIA_CONTAS 
FOREIGN KEY  ( AgenciaCodigo ) REFERENCES Agencias (AgenciaCodigo);

ALTER TABLE Devedores ADD CONSTRAINT FK_DEVEDORES_EMPRESTIMO 
FOREIGN KEY ( EmprestimoCodigo ) REFERENCES Emprestimos (EmprestimoCodigo);

ALTER TABLE Emprestimos ADD CONSTRAINT FK_EMPRESTIMOS_AGENGIA
FOREIGN KEY (AgenciaCodigo) REFERENCES Agencias(AgenciaCodigo);

ALTER TABLE Emprestimos ADD CONSTRAINT FK_EMPRESTIMOS_CLIENTES 
FOREIGN KEY  (ClienteCodigo) REFERENCES Clientes (ClienteCodigo);

ALTER TABLE Depositantes ADD CONSTRAINT FK_CONTA_AGENGIA 
FOREIGN KEY  (AgenciaCodigo) REFERENCES Agencias (AgenciaCodigo);

ALTER TABLE Depositantes ADD CONSTRAINT FK_DEPOSITANTES_CONTAS 
FOREIGN KEY  (ContaNumero) REFERENCES Contas (ContaNumero);

ALTER TABLE Depositantes ADD CONSTRAINT FK_DEPOSITANTES_CLIENTES 
FOREIGN KEY  (ClienteCodigo) REFERENCES Clientes (ClienteCodigo);

ALTER TABLE Devedores ADD CONSTRAINT FK_DEVEDORES_AGENGIA 
FOREIGN KEY  (AgenciaCodigo) REFERENCES Agencias (AgenciaCodigo);

ALTER TABLE Devedores ADD CONSTRAINT FK_DEVEDORES_CONTAS 
FOREIGN KEY  (ClienteCodigo) REFERENCES Clientes (ClienteCodigo);


INSERT INTO Grupo(GrupoNome, GrupoRazaoSocial, GrupoCNPJ)
VALUES ('MyBank',
        'MyBank International SA',
        '11.222.333/0001-44');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Ana',
        'XV de Novembro',
        'Joinville',
        '1980-08-06');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Laura',
        '07 de Setembro',
        'Blumenau',
        '1981-08-08');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Vânia',
        '01 de Maio',
        'Blumenau',
        '1982-08-06');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Franco',
        'Felipe Schmidt',
        'Florianopolis',
        '1985-08-06');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Eduardo',
        'Beria Mar Norte',
        'Florianópolis',
        '1970-11-10');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Bruno',
        '24 de maio',
        'Criciúma',
        '1982-07-05');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Rodrigo',
        '06 de agosto',
        'Joinville',
        '1981-08-06');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Ricardo',
        'João Colin',
        'Joinville',
        '1980-02-15');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Alexandre',
        'Margem esquerda',
        'Blumenau',
        '1980-03-07');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Luciana',
        'Estreito',
        'Florianópolis',
        '1987-09-06');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Juliana',
        'Iririu',
        'Joinville',
        '1970-01-06');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Pedro',
        'Aventureiro',
        'Joinville',
        '1975-06-08');


INSERT INTO Clientes
VALUES (DEFAULT,
        'Julia',
        'Nova Brasília',
        'Joinville',
        '1985-03-18');

INSERT INTO Agencias 
VALUES (DEFAULT,
		'Verde Vale',
		'Blumenau', 
		 900000,
		 1);

INSERT INTO Agencias 
VALUES (DEFAULT,
		'Cidade das Flores',
		'Joinville', 
		 800000,
		 1);

INSERT INTO Agencias 
VALUES (DEFAULT,
		'Universitária', 
		'Florianópolis', 
	 	 750000,
		 1);

INSERT INTO Agencias 
VALUES (DEFAULT,
		'Joinville', 
		'Joinville', 
		 950000,
		 1);

INSERT INTO Agencias 
VALUES (DEFAULT,
		'Beira Mar', 
		'Florianópolis',
		 600000,
		 1);

INSERT INTO Agencias 
VALUES (DEFAULT,
		'Criciúma', 
		'Criciúma', 
		 500000,
		 1);

INSERT INTO Agencias 
VALUES (DEFAULT,
		'Blumenau', 
		'Blumenau', 
		 1100000,
	     1);

INSERT INTO Agencias 
VALUES (DEFAULT,
		'Germânia', 
		'Blumenau', 
		 400000,
		 1);

INSERT INTO Contas 
VALUES(4,
	   'C-401',
	   1,
	   500,
	   '2014-01-01');
	   
INSERT INTO Contas
VALUES(4,
	   'C-402',
	   2,
	   200,
	   '2014-02-27');
	   
INSERT INTO Contas
VALUES(4,
	   'C-403',
	   3,350,
	   '2013-07-21');
	   
INSERT INTO Contas
VALUES(4,
	   'C-404',
	   7,870,
	   '2013-08-11');
	   
INSERT INTO Contas 
VALUES(1,
	   'C-101',
	   11,
	   800,
	   '2013-08-03');
	   
INSERT INTO Contas 
VALUES(2,
	   'C-201',
	   4,
	   800,
	   '2013-04-12');
	   
INSERT INTO Contas 
VALUES(3,
	   'C-301',
	   5,
	   400,
	   '2014-07-04');
	   
INSERT INTO Contas 
VALUES(5,
	   'C-501',
	   6,
	   300,
	   '2011-03-23');
	   
INSERT INTO Contas 
VALUES(6,
	   'C-601',
	   8,
	   900,
	   '2013-10-12');
	   
INSERT INTO Contas 
VALUES(7,
	   'C-701',
	   9,
	   550,
	   '2011-09-02');
	   
INSERT INTO Contas 
VALUES(8,
	   'C-801',
	   10,
	   1000,
	   '2007-08-01');


INSERT INTO Emprestimos 
VALUES (4,
	     1,
		 'L-10',
		 2000);
		 
INSERT INTO Emprestimos 
VALUES (2,
		4,
		'L-20',
		1500);
		
INSERT INTO Emprestimos 
VALUES (4,
		2,
		'L-15',
		1800);
		
INSERT INTO Emprestimos 
VALUES (4,
		3,
		'L-30',
		2500);
		
INSERT INTO Emprestimos 
VALUES (6,
		8,
		'L-40',
		3000);
		
INSERT INTO Emprestimos 
VALUES (1,
		11,
		'L-35',
		2800);
		
INSERT INTO Emprestimos 
VALUES (4,
		7,
		'L-50',
		2300);
		
INSERT INTO Depositantes 
VALUES (DEFAULT,
		4,
		'C-401',
		1,
		500,
		'2014-01-01');
		
INSERT INTO Depositantes 
VALUES (DEFAULT,
		4,
		'C-402',
		2,
		200,
		'2014-02-27');
		
INSERT INTO Depositantes 
VALUES (DEFAULT,
		4,
		'C-403',
		3,
		350,
		'2013-07-21');
		
INSERT INTO Depositantes 
VALUES (DEFAULT,
		2,
		'C-201',
		4,
		800,
		'2013-04-12');
		
INSERT INTO Depositantes 
VALUES (DEFAULT,
		3,
		'C-301',
		5,
		400,
		'2014-07-04');
		
INSERT INTO Depositantes 
VALUES (DEFAULT,
		4,
		'C-404',
		7,
		870,
		'2013-08-11');
		
INSERT INTO Depositantes 
VALUES (DEFAULT,
		5,
		'C-501',
		6,
		300,
		'2011-03-23');
		
INSERT INTO Depositantes 
VALUES (DEFAULT,
		6,
		'C-601',
		8,
		900,
		'2013-10-12');
		
INSERT INTO Depositantes 
VALUES (DEFAULT,
		7,
		'C-701',
		9,
		550,
		'2011-09-02');
		
INSERT INTO Depositantes 
VALUES (DEFAULT,
		8,
		'C-801',
		10,
		1000,
		'2007-08-01');
		
INSERT INTO Depositantes 
VALUES (DEFAULT,
		1,
		'C-101',
		11,
		800,
		'2013-08-03');

INSERT INTO Devedores 
VALUES (DEFAULT,
		4,
		1,
		'L-10',
		1000);
		
INSERT INTO Devedores 
VALUES (DEFAULT,
		2,
		4,
		'L-20',
		500);
		
INSERT INTO Devedores 
VALUES (DEFAULT,
		4,
		2,
		'L-15',
		800);
		
INSERT INTO Devedores 
VALUES (DEFAULT,
		4,
		3,
		'L-30',
		2000);
		
INSERT INTO Devedores 
VALUES (DEFAULT,
		6,
		8,
		'L-40',
		2000);
		
INSERT INTO Devedores 
VALUES (DEFAULT,
		1,
		11,
		'L-35',
		2600);
		
INSERT INTO Devedores 
VALUES (DEFAULT,
		4,
		7,
		'L-50',
		2300);

INSERT INTO CartaoCredito 
VALUES (1,
		12,
		'1111-2222-3333-4444',
		1000);
		
INSERT INTO CartaoCredito 
VALUES	(4,
		13,
		'1234-4567-8910-1112',
		1000);
		
INSERT INTO CartaoCredito 
VALUES	(4,
		7,
		'2222-3333-4444-5555',2000);

