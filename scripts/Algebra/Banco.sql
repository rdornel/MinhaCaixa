USE master
go
IF EXISTS (SELECT * FROM SYS.databases WHERE NAME = 'Bancos')
drop database bancos
go
CREATE DATABASE Bancos
go
USE Bancos
go
CREATE TABLE Conta
(
Nome_agencia VARCHAR (50), 
Numero_conta VARCHAR (10),
saldo MONEY
)
go
INSERT dbo.Conta
        ( Nome_agencia, Numero_conta, saldo )
VALUES  ('Joinville','C-100', 500),
('Blumenau', 'C-200', 800),
('Beira Mar', 'C250', 400),
('Universit�ria', 'C-300', 300),
('Crici�ma', 'C-400', 900),
('Verde Vale', 'C-800', 550),
('Cidade das Flores', 'C-900', 1000)
go
CREATE TABLE Agencia
(
Nome_agencia VARCHAR (50),
Cidade_agencia varchar (50),
fundos money
)
go
INSERT dbo.Agencia
        ( Nome_agencia ,
          Cidade_agencia ,
          fundos
        )
VALUES  ('Verde Vale','Blumenau', 900000),
('Cidade das Flores','Joinville', 800000),
('Universitária', 'Florianópolis', 750000),
('Joinville', 'Joinville', 950000),
('Beira Mar', 'Florianópolis', 600000),
('Criciúma', 'Criciúma', 500000),
('Blumenau', 'Blumenau', 1100000),
('Germânia', 'Blumenau', 400000)
go
create table Cliente
(
Nome_cliente varchar (50),
Rua_Cliente varchar (50),
Cidade_Cliente varchar (50)
)
go
insert cliente values
('Ana', 'XV de Novembro','Joinville'),
('Laura','07 de Setembro','Blumenau'),
('Vânia','01 de Maio','Blumenau'),
('Franco','Felipe Schmidt','Florianopolis'),
('Eduardo', 'Beria Mar Norte', 'Florianópolis'),
('Bruno', '24 de maio','Criciúma'),
('Rodrigo','06 de agosto','Joinville'),
('Ricardo','João Colin','Joinville'),
('Alexandre','Margem esquerda','Blumenau'),
('Luciana','Estreito','Florianópolis'),
('Juliana','Iririu','Joinville')
go
create table Depositante
(
Nome_cliente varchar(50),
Numero_conta varchar(10)
)
insert depositante values
('Ana','C-100'),
('Laura','C-200'),
('Eduardo','C-250'),
('Bruno','C-400'),
('Rodrigo','C-900'),
('Vânia','C-800'),
('Luciana','C-300')
go
create table Emprestimo
(
Nome_agencia varchar (50),
Numero_emprestimo varchar (10),
Total money
)
go
insert Emprestimo values
('Joinville','L-10','2000'),
('Blumenau','L-20','1500'),
('Beira Mar','L-15','1800'),
('Criciúma','L-30','2500'),
('Cidade das Flores','L-40','3000'),
('Verde Vale','L-35','2800'),
('Universitária','L-50','2300')
go
create table Devedor
(
Nome_cliente varchar (50),
Numero_emprestimo varchar (10)
)
insert Devedor values
('Ana','L-10'),
('Laura','L-20'),
('Eduardo','L-15'),
('Bruno','L-30'),
('Rodrigo','L-40'),
('Vânia','L-35'),
('Luciana','L-50')
