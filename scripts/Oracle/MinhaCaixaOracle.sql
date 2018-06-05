CREATE TABLE Grupo
    (GrupoCodigo INT CONSTRAINT PK_Grupo PRIMARY KEY
    ,GrupoNome VARCHAR (50)
    ,GrupoRazaoSocial VARCHAR (50)
    ,GrupoCNPJ VARCHAR (20));

CREATE SEQUENCE seq_Grupo_GrupoCodigo NOCACHE;
    CREATE OR REPLACE TRIGGER seq_Grupo_GrupoCodigo
    BEFORE INSERT ON Grupo
    FOR EACH ROW
    BEGIN
    SELECT seq_Grupo_GrupoCodigo.nextval INTO :new.GrupoCodigo FROM DUAL;
    END;

INSERT INTO Grupo
    (GrupoNome 
    ,GrupoRazaoSocial
    ,GrupoCNPJ)
VALUES
    ('MyBank'
    ,'MyBank International SA' 
    ,'11.222.333/0001-44');

CREATE TABLE Clientes
    (ClienteCodigo INT CONSTRAINT PK_CLIENTES PRIMARY KEY
    ,ClienteNome VARCHAR (50)
    ,ClienteRua VARCHAR (50)
    ,ClienteCidade VARCHAR (50)
    ,ClienteNascimento DATE);

CREATE SEQUENCE seq_Clientes_ClienteCodigo NOCACHE;
    CREATE OR REPLACE TRIGGER seq_Clientes_ClienteCodigo
    BEFORE INSERT ON Clientes
    FOR EACH ROW
    BEGIN
    SELECT seq_Clientes_ClienteCodigo.nextval INTO:new.ClienteCodigo FROM DUAL;
    END;

INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Ana'
    , 'XV de Novembro'
    ,'Joinville'
    ,'06081980');
    
INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Laura'
    ,'07 de Setembro'
    ,'Blumenau'
    ,'08081981');
    
INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Vânia'
    ,'01 de Maio'
    ,'Blumenau'
    ,'06081982');

INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Franco'
    ,'Felipe Schmidt'
    ,'Florianopolis'
    ,'06081985');

INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Eduardo'
    ,'Beria Mar Norte'
    ,'Florianópolis'
    ,'10111970');

INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Bruno'
    ,'24 de maio'
    ,'Criciúma'
    ,'05071982');

INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Rodrigo'
    ,'06 de agosto'
    ,'Joinville'
    ,'06081981');

INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Ricardo'
    ,'João Colin'
    ,'Joinville'
    ,'15021980');

INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Alexandre'
    ,'Margem esquerda'
    ,'Blumenau'
    ,'07031980');

INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Luciana'
    ,'Estreito'
    ,'Florianópolis'
    ,'06091987');

INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Juliana'
    ,'Iririu'
    ,'Joinville'
    ,'06011970');

INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Pedro'
    ,'Aventureiro'
    ,'Joinville'
    ,'08061975');

INSERT INTO Clientes 
    (ClienteNome
    ,ClienteRua
    ,ClienteCidade
    ,ClienteNascimento) 
VALUES 
    ('Julia'
    ,'Nova Brasília'
    ,'Joinville'
    ,'19031985');

CREATE TABLE Agencias
    (AgenciaCodigo INT CONSTRAINT PK_Agencias PRIMARY KEY
    ,AgenciaNome VARCHAR (50)
    ,AgenciaCidade VARCHAR (50)
    ,AgenciaFundos NUMBER(19,4)
    ,GrupoCodigo INT);

CREATE SEQUENCE seq_Agenciass_AgenciaCodigo NOCACHE;
    CREATE OR REPLACE TRIGGER seq_Agenciass_AgenciaCodigo
    BEFORE INSERT ON Agencias
    FOR EACH ROW
    BEGIN
    SELECT seq_Agenciass_AgenciaCodigo.nextval INTO:new.AgenciaCodigo FROM DUAL;
    END;
    
ALTER TABLE Agencias 
    ADD CONSTRAINT FK_GRUPOS_AGENCIAS 
    FOREIGN KEY (GrupoCodigo) 
    REFERENCES Grupo;
    
INSERT INTO Agencias
    (AgenciaNome
    ,AgenciaCidade
    ,AgenciaFundos
    ,GrupoCodigo) 
VALUES 
    ('Verde Vale'
    ,'Blumenau'
    , 900000
    ,1);

INSERT INTO Agencias
    (AgenciaNome
    ,AgenciaCidade
    ,AgenciaFundos
    ,GrupoCodigo) 
VALUES 
    ('Cidade das Flores'
    ,'Joinville'
    ,800000
    ,1);

INSERT INTO Agencias
    (AgenciaNome
    ,AgenciaCidade
    ,AgenciaFundos
    ,GrupoCodigo) 
VALUES 
    ('Universitária'
    ,'Florianópolis'
    ,750000
    ,1);

INSERT INTO Agencias
    (AgenciaNome
    ,AgenciaCidade
    ,AgenciaFundos
    ,GrupoCodigo) 
VALUES 
    ('Joinville'
    ,'Joinville'
    ,950000
    ,1);

INSERT INTO Agencias
    (AgenciaNome
    ,AgenciaCidade
    ,AgenciaFundos
    ,GrupoCodigo) 
VALUES 
    ('Beira Mar'
    ,'Florianópolis'
    ,600000
    ,1);

INSERT INTO Agencias
    (AgenciaNome
    ,AgenciaCidade
    ,AgenciaFundos
    ,GrupoCodigo) 
VALUES 
    ('Criciúma'
    ,'Criciúma'
    ,500000
    ,1);

INSERT INTO Agencias
    (AgenciaNome
    ,AgenciaCidade
    ,AgenciaFundos
    ,GrupoCodigo) 
VALUES 
    ('Blumenau'
    ,'Blumenau'
    ,1100000
    ,1);

INSERT INTO Agencias
    (AgenciaNome
    ,AgenciaCidade
    ,AgenciaFundos
    ,GrupoCodigo) 
VALUES 
    ('Germânia'
    ,'Blumenau'
    ,400000
    ,1);

CREATE TABLE Contas
    (AgenciaCodigo INT
    ,ContaNumero VARCHAR (10) CONSTRAINT PK_CONTA PRIMARY KEY
    ,ClienteCodigo INT
    ,ContaSaldo NUMBER(19,4)
    ,ContaAbertura DATE);

ALTER TABLE Contas 
    ADD CONSTRAINT FK_CLIENTES_CONTAS 
    FOREIGN KEY (ClienteCodigo) 
    REFERENCES Clientes;
    
ALTER TABLE Contas 
    ADD CONSTRAINT FK_AGENCIA_CONTAS 
    FOREIGN KEY (AgenciaCodigo) 
    REFERENCES Agencias;
    
INSERT INTO Contas
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,ContaSaldo
    ,ContaAbertura) 
VALUES 
    (4
    ,'C-401'
    ,1
    ,500
    ,'01012014');

INSERT INTO Contas
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,ContaSaldo
    ,ContaAbertura) 
VALUES 
    (4
    ,'C-402'
    ,2
    ,200
    ,'27022014');

INSERT INTO Contas
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,ContaSaldo
    ,ContaAbertura) 
VALUES 
    (4
    ,'C-403'
    ,3
    ,350
    ,'21072013');

INSERT INTO Contas
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,ContaSaldo
    ,ContaAbertura) 
VALUES 
    (4
    ,'C-404'
    ,7
    ,870
    ,'11082013');

INSERT INTO Contas
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,ContaSaldo
    ,ContaAbertura) 
VALUES 
    (1
    ,'C-101'
    ,11
    ,800
    ,'03082013');

INSERT INTO Contas
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,ContaSaldo
    ,ContaAbertura) 
VALUES 
    (2
    ,'C-201'
    ,4
    ,800
    ,'12042013');

INSERT INTO Contas
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,ContaSaldo
    ,ContaAbertura) 
VALUES 
    (3
    ,'C-301'
    ,5
    ,400
    ,'04072014');

INSERT INTO Contas
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,ContaSaldo
    ,ContaAbertura) 
VALUES 
    (5
    ,'C-501'
    ,6
    ,300
    ,'23032011');

INSERT INTO Contas
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,ContaSaldo
    ,ContaAbertura) 
VALUES 
    (6
    ,'C-601'
    ,8
    ,900
    ,'12102013');

INSERT INTO Contas
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,ContaSaldo
    ,ContaAbertura) 
VALUES  
    (7
    ,'C-701'
    ,9
    ,550
    ,'02092011');

INSERT INTO Contas
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,ContaSaldo
    ,ContaAbertura) 
VALUES 
    (8
    ,'C-801'
    ,10
    ,1000
    ,'01082007');

CREATE TABLE Emprestimos
    (AgenciaCodigo INT
    ,ClienteCodigo INT
    ,EmprestimoCodigo VARCHAR (10)
    ,EmprestimoTotal NUMBER(19,4));

ALTER TABLE Emprestimos 
    ADD CONSTRAINT FK_EMPRESTIMOS_CLIENTES 
    FOREIGN KEY (ClienteCodigo) 
    REFERENCES Clientes;
    
ALTER TABLE Emprestimos 
    ADD CONSTRAINT FK_EMPRESTIMOS_AGENGIA 
    FOREIGN KEY (AgenciaCodigo) 
    REFERENCES Agencias;
    
INSERT INTO Emprestimos
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,EmprestimoTotal) 
VALUES 
    (4
    ,1
    ,'L-10'
    ,2000);

INSERT INTO Emprestimos
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,EmprestimoTotal) 
VALUES 
    (2
    ,4
    ,'L-20'
    ,1500);

INSERT INTO Emprestimos
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,EmprestimoTotal) 
VALUES 
    (4
    ,2
    ,'L-15'
    ,1800);

INSERT INTO Emprestimos
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,EmprestimoTotal) 
VALUES 
    (4
    ,3
    ,'L-30'
    ,2500);

INSERT INTO Emprestimos
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,EmprestimoTotal) 
VALUES 
    (6
    ,8
    ,'L-40'
    ,3000);

INSERT INTO Emprestimos
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,EmprestimoTotal) 
VALUES 
    (1
    ,11
    ,'L-35'
    ,2800);

INSERT INTO Emprestimos
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,EmprestimoTotal) 
VALUES 
    (4
    ,7
    ,'L-50'
    ,2300);

CREATE TABLE Depositantes
    (AgenciaCodigo INT
    ,ContaNumero VARCHAR (10)
    ,ClienteCodigo INT
    ,DepositoValor NUMBER(19,4)
    ,DepositoData DATE);

ALTER TABLE Depositantes 
    ADD CONSTRAINT FK_CONTA_AGENGIA 
    FOREIGN KEY (AgenciaCodigo) 
    REFERENCES Agencias;
    
ALTER TABLE Depositantes 
    ADD CONSTRAINT FK_DEPOSITANTES_CONTAS 
    FOREIGN KEY (ContaNumero) 
    REFERENCES Contas;

ALTER TABLE Depositantes 
    ADD CONSTRAINT FK_DEPOSITANTES_CLIENTES 
    FOREIGN KEY (ClienteCodigo) 
    REFERENCES Clientes;

INSERT INTO Depositantes 
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,DepositoValor
    ,DepositoData) 
VALUES 
    (4
    ,'C-401'
    ,1
    ,500
    ,'01012014');

INSERT INTO Depositantes 
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,DepositoValor
    ,DepositoData) 
VALUES 
    (4
    ,'C-402'
    ,2
    ,200
    ,'27022014');

INSERT INTO Depositantes 
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,DepositoValor
    ,DepositoData) 
VALUES 
    (4
    ,'C-403'
    ,3
    ,350
    ,'21072013');

INSERT INTO Depositantes 
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,DepositoValor
    ,DepositoData) 
VALUES 
    (2
    ,'C-201'
    ,4
    ,800
    ,'12042014');

INSERT INTO Depositantes 
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,DepositoValor
    ,DepositoData) 
VALUES 
    (3
    ,'C-301'
    ,5
    ,400
    ,'04072014');

INSERT INTO Depositantes 
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,DepositoValor
    ,DepositoData) 
VALUES 
    (4
    ,'C-404'
    ,7
    ,870
    ,'11082013');

INSERT INTO Depositantes 
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,DepositoValor
    ,DepositoData) 
VALUES 
    (5
    ,'C-501'
    ,6
    ,300
    ,'23032011');

INSERT INTO Depositantes 
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,DepositoValor
    ,DepositoData) 
VALUES 
    (6
    ,'C-601'
    ,8
    ,900
    ,'12102013');

INSERT INTO Depositantes 
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,DepositoValor
    ,DepositoData) 
VALUES 
    (7
    ,'C-701'
    ,9
    ,550
    ,'02092011');

INSERT INTO Depositantes 
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,DepositoValor
    ,DepositoData) 
VALUES 
    (8
    ,'C-801'
    ,10
    ,1000
    ,'01082007');

INSERT INTO Depositantes 
    (AgenciaCodigo
    ,ContaNumero
    ,ClienteCodigo
    ,DepositoValor
    ,DepositoData) 
VALUES 
    (1
    ,'C-101'
    ,11
    ,800
    ,'03082013');

CREATE TABLE Devedores
    (AgenciaCodigo INT
    ,ClienteCodigo INT
    ,EmprestimoCodigo VARCHAR (10)
    ,DevedorSaldo NUMBER(19,4));

ALTER TABLE Devedores 
    ADD CONSTRAINT FK_DEVEDORES_AGENGIA 
    FOREIGN KEY (AgenciaCodigo) 
    REFERENCES Agencias;
    
ALTER TABLE Devedores 
    ADD CONSTRAINT FK_DEVEDORES_CONTAS 
    FOREIGN KEY (ClienteCodigo) 
    REFERENCES Clientes;
    
INSERT INTO Devedores
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,DevedorSaldo) 
VALUES 
    (4
    ,1
    ,'L-10'
    ,1000);

INSERT INTO Devedores
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,DevedorSaldo) 
VALUES 
    (2
    ,4
    ,'L-20'
    ,500);

INSERT INTO Devedores
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,DevedorSaldo) 
VALUES 
    (4
    ,2
    ,'L-15'
    ,800);

INSERT INTO Devedores
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,DevedorSaldo) 
VALUES 
    (4
    ,3
    ,'L-30'
    ,2000);

INSERT INTO Devedores
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,DevedorSaldo) 
VALUES 
    (6
    ,8
    ,'L-40'
    ,2000);

INSERT INTO Devedores
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,DevedorSaldo) 
VALUES 
    (1
    ,11
    ,'L-35'
    ,2600);

INSERT INTO Devedores
    (AgenciaCodigo
    ,ClienteCodigo
    ,EmprestimoCodigo
    ,DevedorSaldo) 
VALUES 
    (4
    ,7
    ,'L-50'
    ,2300);

CREATE TABLE CartaoCredito
    (AgenciaCodigo INT
    ,ClienteCodigo INT
    ,CartaoCodigo VARCHAR (20)
    ,CartaoLimite NUMBER(19,4));

ALTER TABLE CartaoCredito 
    ADD CONSTRAINT FK_CARTAOCREDITO_AGENGIA 
    FOREIGN KEY (AgenciaCodigo) 
    REFERENCES Agencias;

ALTER TABLE CartaoCredito 
    ADD CONSTRAINT FK_CARTAOCREDITO_CLIENTES 
    FOREIGN KEY (ClienteCodigo) 
    REFERENCES Clientes;

INSERT INTO dbo.CartaoCredito
    (AgenciaCodigo
    ,ClienteCodigo
    ,CartaoCodigo
    ,CartaoLimite) 
VALUES 
    (1
    ,12
    ,'1111-2222-3333-4444'
    ,1000);

INSERT INTO dbo.CartaoCredito
    (AgenciaCodigo
    ,ClienteCodigo
    ,CartaoCodigo
    ,CartaoLimite) 
VALUES 
    (4
    ,13
    ,'1234-4567-8910-1112'
    ,1000);

INSERT INTO dbo.CartaoCredito
    (AgenciaCodigo
    ,ClienteCodigo
    ,CartaoCodigo
    ,CartaoLimite) 
VALUES 
    (4
    ,7
    ,'2222-3333-4444-5555'
    ,2000);
