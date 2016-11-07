SET DATEFORMAT YMD
GO
USE master
go
IF EXISTS (SELECT * FROM SYS.databases WHERE NAME = 'MinhaCaixa')
ALTER DATABASE MinhaCaixa SET SINGLE_USER WITH ROLLBACK IMMEDIATE
IF EXISTS (SELECT * FROM SYS.databases WHERE NAME = 'MinhaCaixa')
DROP database MinhaCaixa
go
CREATE DATABASE MinhaCaixa
GO
USE MinhaCaixa
GO
CREATE TABLE Grupo
(
GrupoCodigo INT IDENTITY(1,1) CONSTRAINT PK_Grupo PRIMARY KEY,
GrupoNome VARCHAR(50),
GrupoRazaoSocial VARCHAR(50),
GrupoCNPJ varchar(20),
)
GO
CREATE TABLE Filial
(
GrupoCodigo INT,
FilialCodigo INT IDENTITY(1,1) CONSTRAINT PK_Filial PRIMARY KEY,
FilialNome VARCHAR(50),
FilialRazaoSocial VARCHAR(50),
FilialCNPJ varchar(20),
)
CREATE table Clientes
(
ClienteCodigo int CONSTRAINT PK_CLIENTES PRIMARY KEY IDENTITY(1,1),
ClienteCPF varchar (50),
ClienteNome varchar (50),
ClienteSobrenome varchar (50),
ClienteSexo CHAR(1),
ClienteNascimento DATETIME,
ClienteEstadoCivil CHAR(1),
ClienteRua varchar(1000),
ClienteNumero INT,
ClienteBairro VARCHAR(50),
ClienteCEP VARCHAR(25),
ClienteCidade VARCHAR(50),
ClienteEstado CHAR(50),
ClientePais VARCHAR(50),
ClienteRendaAnual MONEY,
ClienteTelefone VARCHAR(50),
ClienteEmail VARCHAR(80)
) 
GO
CREATE TABLE Agencias
(
GrupoCodigo INT,
FilialCodigo INT,
AgenciaCodigo INT IDENTITY CONSTRAINT PK_Agencias PRIMARY KEY,
AgenciaNome VARCHAR (50),
AgenciaRua varchar(1000),
AgenciaNumero INT,
AgenciaBairro VARCHAR(50),
AgenciaCEP VARCHAR(25),
AgenciaCidade VARCHAR(50),
AgenciaEstado CHAR(2),
AgenciaPais VARCHAR(50)
)
GO
CREATE TABLE Contas
(
AgenciaCodigo int,
ContaNumero VARCHAR (10) CONSTRAINT PK_Conta PRIMARY KEY,
ClienteCodigo int,
ContaAbertura DATETIME,
ContaTipo int
)
CREATE TABLE Movimentos
(
ContaNumero VARCHAR (10),
MovimentoData DATETIME,
MovimentoValor MONEY,
MovimentoTipo INT,
MovimentoCodigo int
)
CREATE TABLE TipoContas
(
TipoContaCodigo INT CONSTRAINT PK_TipoContas PRIMARY KEY,
TipoContaDescição VARCHAR (25)
)
create table CartaoCredito
(
AgenciaCodigo INT,
ContaNumero VARCHAR (10) NULL,
ClienteCodigo int,
CartaoCodigo varchar (20),
CartaoLimite MONEY,
CartaoExpira DATETIME,
CartaoCodigoSeguranca int
)
INSERT dbo.CartaoCredito VALUES  (1,'001905-9',142,'1111-2222-3333-4444',1000, '2020-10-10',724)
GO
