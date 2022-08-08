DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Fones_Clientes;
DROP TABLE IF EXISTS Funcionarios;
DROP TABLE IF EXISTS Ordens_servicos;
DROP TABLE IF EXISTS Vendas;
DROP TABLE IF EXISTS Contas_Receber;
DROP TABLE IF EXISTS Itens;
DROP TABLE IF EXISTS Vendas_Itens;
DROP TABLE IF EXISTS Ordens_itens;
DROP TABLE IF EXISTS Fornecedores;
DROP TABLE IF EXISTS Compras;
DROP TABLE IF EXISTS Compras_Itens;
DROP TABLE IF EXISTS Despesas;
DROP TABLE IF EXISTS Contas_pagar;

CREATE TABLE Clientes (
  cod_cliente INTEGER NOT NULL CHECK(cod_cliente > 0),
  nome VARCHAR(50) NOT NULL,
  endereco VARCHAR(50) NOT NULL,
  tipo CHAR(1) CHECK(tipo = 'F' OR tipo = 'J'),
  RG CHAR(15),
  CPF CHAR(11),
  CNPJ CHAR(14),
  Obs TEXT,
  PRIMARY KEY (cod_cliente)
);

CREATE TABLE Fones_Clientes (
  cod_cliente INTEGER NOT NULL,
  num_telefone CHAR(10),
  PRIMARY KEY (cod_cliente, num_telefone),
  FOREIGN KEY (cod_cliente) REFERENCES Clientes
);

CREATE TABLE Funcionarios (
  cod_funcionario INTEGER NOT NULL,
  nome VARCHAR(50) NOT NULL,
  endereco VARCHAR(50) NOT NULL,
  CPF char(11) UNIQUE NOT NULL,
  tipo char(1) CHECK (tipo = '1' OR tipo = '2' OR tipo = '3'),
  PRIMARY KEY (cod_funcionario)
);

CREATE TABLE Ordens_servicos (
  num_ordServico INTEGER NOT NULL,
  data_ordServico DATE NOT NULL,
  valor_total NUMERIC(10,2) NOT NULL,
  status_ordServico CHAR(1) CHECK (status_ordServico = 'A' OR status_ordServico = 'F'),
  cod_funcionario INTEGER NOT NULL,
  cod_cliente INTEGER NOT NULL,
  PRIMARY KEY (num_ordServico),
  FOREIGN KEY (cod_funcionario) REFERENCES Funcionarios,
  FOREIGN KEY (cod_cliente) REFERENCES Clientes
);

CREATE TABLE Vendas (
  cod_venda INTEGER NOT NULL,
  valor_total NUMERIC(10,2) NOT NULL,
  dt_venda DATE NOT NULL,
  cod_funcionario INTEGER,
  cod_cliente INTEGER,
  num_ordServico INTEGER,
  PRIMARY KEY (cod_venda),
  FOREIGN KEY (cod_funcionario) REFERENCES Funcionarios,
  FOREIGN KEY (cod_cliente) REFERENCES Clientes,
  FOREIGN KEY (num_ordServico) REFERENCES Ordens_servicos
);

CREATE TABLE Contas_Receber (
  cod_contReceber INTEGER NOT NULL,
  data_lancamento DATE NOT NULL,
  data_vencimento DATE NOT NULL,
  valor_receber NUMERIC(10,2) NOT NULL,
  data_pagamento DATE,
  valor_pagamento NUMERIC(10,2),
  cod_venda INTEGER NOT NULL,
  PRIMARY KEY (cod_contReceber),
  FOREIGN KEY (cod_venda) REFERENCES Vendas
);

CREATE TABLE Itens (
  cod_item INTEGER NOT NULL,
  valor NUMERIC(10,2) NOT NULL,
  custo NUMERIC(10,2) NOT NULL,
  descricao VARCHAR(100),
  desconto NUMERIC(4,2),
  tipo CHAR(1) CHECK (tipo = 'P' OR tipo = 'S'),
  estoque INTEGER,
  PRIMARY KEY (cod_item)
);

CREATE TABLE Vendas_Itens (
  sequencial_vendItem INTEGER NOT NULL,
  cod_venda INTEGER NOT NULL,
  cod_item INTEGER NOT NULL,
  quant REAL NOT NULL,
  valor NUMERIC(10,2) NOT NULL,
  PRIMARY KEY (sequencial_vendItem, cod_venda),
  FOREIGN KEY (cod_venda) REFERENCES Vendas,
  FOREIGN KEY (cod_item) REFERENCES Itens
);

CREATE TABLE Ordens_itens (
  sequencial_ordItem SERIAL NOT NULL,
  num_ordServico INTEGER NOT NULL,
  cod_item INTEGER NOT NULL,
  desconto NUMERIC(4,2) NOT NULL,
  PRIMARY KEY (sequencial_ordItem),
  FOREIGN KEY (num_ordServico) REFERENCES Ordens_servicos,
  FOREIGN KEY (cod_item) REFERENCES Itens
);

CREATE TABLE Fornecedores (
  cod_fornecedor INTEGER NOT NULL,
  descricao VARCHAR(100),
  endereco VARCHAR(50),
  contato VARCHAR(50),
  CNPJ VARCHAR(14) UNIQUE,
  PRIMARY KEY (cod_fornecedor)
);

CREATE TABLE Compras (
  cod_compra INTEGER NOT NULL,
  cod_fornecedor INTEGER NOT NULL,
  data_compra DATE NOT NULL,
  valor_total NUMERIC(10,2) NOT NULL,
  numero_nota INTEGER NOT NULL,
  PRIMARY KEY (cod_compra),
  FOREIGN KEY (cod_fornecedor) REFERENCES Fornecedores
);

CREATE TABLE Compras_Itens (
  sequencial_compItem SERIAL NOT NULL,
  cod_compra INTEGER NOT NULL,
  cod_item INTEGER NOT NULL,
  desconto NUMERIC(4,2) NOT NULL,
  quant REAL NOT NULL,
  valor NUMERIC (10,2) NOT NULL,
  valor_total NUMERIC (10,2) NOT NULL,
  PRIMARY KEY (sequencial_compItem),
  FOREIGN KEY (cod_compra) REFERENCES Compras,
  FOREIGN KEY (cod_item) REFERENCES Itens
);

CREATE TABLE Despesas (
  cod_despesa INTEGER NOT NULL,
  descricao VARCHAR(50) NOT NULL,
  PRIMARY KEY (cod_despesa)
);

CREATE TABLE Contas_pagar (
  numero_contPagar INTEGER NOT NULL,
  num_boleto VARCHAR(30),
  tipo INTEGER NOT NULL CHECK(tipo BETWEEN 1 AND 2),
  data_vencimento DATE NOT NULL,
  data_pagamento DATE,
  valor_pago NUMERIC(10,2) NOT NULL,
  valor NUMERIC(10,2) NOT NULL,
  data_lancamento DATE NOT NULL,
  desconto NUMERIC(10,2),
  cod_compra INTEGER NOT NULL,
  cod_despesa INTEGER NOT NULL,
  PRIMARY KEY (numero_contPagar),
  FOREIGN KEY (cod_compra) REFERENCES Compras,
  FOREIGN KEY (cod_despesa) REFERENCES Despesas
);
