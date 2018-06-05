\connect postgres


-- Exclui banco se existir

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_database WHERE datname = 'minha_caixa') THEN
    ALTER DATABASE minha_caixa CONNECTION LIMIT 0;
    PERFORM pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'minha_caixa' AND pid != pg_backend_pid();
  END IF;
END; $$;
DROP DATABASE IF EXISTS minha_caixa;


-- Cria banco de dados

CREATE DATABASE minha_caixa;

\connect minha_caixa


-- Cria tabela grupo

CREATE TABLE grupo (
  codigo serial NOT NULL CONSTRAINT pk_grupo PRIMARY KEY,
  nome varchar(50),
  razao_social varchar(50),
  cnpj varchar(20)
);

INSERT INTO grupo (nome, razao_social, cnpj) VALUES
  ('MyBank', 'MyBank International SA', '11.222.333/0001-44');


-- Cria tabela cliente

CREATE TABLE cliente (
  codigo serial NOT NULL CONSTRAINT pk_cliente PRIMARY KEY,
  nome varchar(50),
  rua varchar(50),
  cidade varchar(50),
  nascimento timestamp
);

INSERT INTO cliente (nome, rua, cidade, nascimento) VALUES
  ('Ana', 'XV de Novembro', 'Joinville', '1980-08-06'),
  ('Laura', '07 de Setembro', 'Blumenau', '1981-08-08'),
  ('Vânia', '01 de Maio', 'Blumenau', '1982-08-06'),
  ('Franco', 'Felipe Schmidt', 'Florianopolis', '1985-08-06'),
  ('Eduardo', 'Beria Mar Norte', 'Florianópolis', '1970-11-10'),
  ('Bruno', '24 de maio', 'Criciúma', '1982-07-05'),
  ('Rodrigo', '06 de agosto', 'Joinville', '1981-08-06'),
  ('Ricardo', 'João Colin', 'Joinville', '1980-02-15'),
  ('Alexandre', 'Margem esquerda', 'Blumenau', '1980-03-07'),
  ('Luciana', 'Estreito', 'Florianópolis', '1987-09-06'),
  ('Juliana', 'Iririu', 'Joinville', '1970-01-06'),
  ('Pedro', 'Aventureiro', 'Joinville', '1975-06-08'),
  ('Julia', 'Nova Brasília', 'Joinville', '1985-03-18');


-- Cria tabela agencia

CREATE TABLE agencia (
  codigo serial NOT NULL CONSTRAINT pk_agencia PRIMARY KEY,
  nome varchar(50),
  cidade varchar(50),
  fundos numeric(20,2),
  grupo_codigo integer CONSTRAINT fk_agencia_grupo REFERENCES grupo(codigo)
);

INSERT INTO agencia (nome, cidade, fundos, grupo_codigo) VALUES
  ('Verde Vale', 'Blumenau', 900000, 1),
  ('Cidade das Flores', 'Joinville', 800000, 1),
  ('Universitária', 'Florianópolis', 750000, 1),
  ('Joinville', 'Joinville', 950000, 1),
  ('Beira Mar', 'Florianópolis', 600000, 1),
  ('Criciúma', 'Criciúma', 500000, 1),
  ('Blumenau', 'Blumenau', 1100000, 1),
  ('Germânia', 'Blumenau', 400000, 1);


-- Cria tabela conta

CREATE TABLE conta (
  numero varchar(10) CONSTRAINT pk_conta PRIMARY KEY,
  saldo numeric(20,2),
  abertura timestamp,
  agencia_codigo integer CONSTRAINT fk_conta_agencia REFERENCES agencia(codigo),
  cliente_codigo integer CONSTRAINT fk_conta_cliente REFERENCES cliente(codigo)
);

INSERT INTO conta (numero, saldo, abertura, agencia_codigo, cliente_codigo) VALUES
  ('C-401', 500, '2014-01-01', 4, 1),
  ('C-402', 200, '2014-02-27', 4, 2),
  ('C-403', 350, '2014-07-21', 4, 3),
  ('C-404', 870, '2013-08-11', 4, 7),
  ('C-101', 800, '2013-08-03', 1, 11),
  ('C-201', 800, '2013-04-12', 2, 4),
  ('C-301', 400, '2014-07-04', 4, 5),
  ('C-501', 300, '2011-03-23', 5, 6),
  ('C-601', 900, '2013-10-12', 6, 8),
  ('C-701', 550, '2011-09-02', 7, 9),
  ('C-801', 1000, '2007-08-01', 8, 10);


-- Cria tabela emprestimo

CREATE TABLE emprestimo (
  agencia_codigo integer CONSTRAINT fk_emprestimo_agencia REFERENCES agencia(codigo),
  cliente_codigo integer CONSTRAINT fk_emprestimo_cliente REFERENCES cliente(codigo),
  codigo varchar(10),
  total numeric(20, 2)
);


-- Insere na tabela emprestimo

INSERT INTO emprestimo VALUES
  (4, 1, 'L-10', 2000),
  (2, 4, 'L-20', 1500),
  (4, 2, 'L-15', 1800),
  (4, 3, 'L-30', 2500),
  (6, 8, 'L-40', 3000),
  (1, 11, 'L-35', 2800),
  (4, 7 , 'L-50', 2300);


-- Cria tabela devedor

CREATE TABLE devedor (
  saldo numeric(20,2),
  emprestimo_codigo integer CONSTRAINT fk_devedor_emprestimo REFERENCES emprestimo(codigo),
  agencia_codigo integer CONSTRAINT fk_devedor_agencia REFERENCES agencia(codigo),
  cliente_codigo integer CONSTRAINT fk_devedor_cliente REFERENCES cliente(codigo)
);

-- Insere na tabela devedor

INSERT INTO devedor (saldo, emprestimo_codigo, agencia_codigo, cliente_codigo) VALUES
  (1000, 'L-10', 4, 1),
  (500, 'L-20', 2, 4),
  (800, 'L-15', 4, 2),
  (2000, 'L-30', 4, 3),
  (2000, 'L-40', 6, 8),
  (2600, 'L-35', 1, 11),
  (2300, 'L-50', 4, 7);


-- Cria tabela cartao_credito

CREATE TABLE cartao_credito (
  agencia_codigo integer CONSTRAINT fk_cartao_credito_agencia REFERENCES agencia(codigo),
  cliente_codigo integer CONSTRAINT fk_cartao_credito_cliente REFERENCES cliente(codigo),
  codigo integer CONSTRAINT pk_cartao_credito_codigo PRIMARY KEY,
  limite numeric(20,2)
);


-- Cria tabela depositante

CREATE TABLE depositante (
  valor numeric(20,2),
  deposito timestamp,
  conta_numero integer CONSTRAINT fk_depositante_conta REFERENCES conta(numero),
  agencia_codigo integer CONSTRAINT fk_depositante_agencia REFERENCES agencia(codigo),
  cliente_codigo integer CONSTRAINT fk_depositante_cliente REFERENCES cliente(codigo)
);

-- Insere na tabela depositante

INSERT INTO depositante (valor,deposito,conta_numero,agencia_codigo,cliente_codigo) VALUES
  (500, '2014-01-01', 'C-401', 4, 1),
  (200, '2014-02-27', 'C-402', 4, 2),
  (350, '2013-07-21', 'C-403', 4, 3),
  (870, '2013-08-11', 'C-404', 4, 7),
  (800, '2013-08-03', 'C-101', 1, 11),
  (800, '2013-04-12', 'C-201', 2, 4),
  (400, '2014-07-04', 'C-301', 3, 5),
  (300, '2011-03-23', 'C-501', 5, 6),
  (900, '2013-10-12', 'C-601', 6, 8),
  (550, '2011-09-02', 'C-701', 7, 9),
  (1000, '2017-08-01', 'C-801', 8, 10);
