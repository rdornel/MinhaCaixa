USE MinhaCaixa
GO
SELECT dbo.Clientes.ClienteNome,dbo.Clientes.ClienteBairro,
dbo.Agencias.AgenciaNome,dbo.Movimentos.MovimentoData,
dbo.TipoMovimento.TipoMovimentoDescricao,
(MovimentoValor * MovimentoTipo) AS Saldo,
MovimentoValor AS Valor
INTO MinhaCaixaDW.fact.FatosMovimentos
 FROM dbo.Contas INNER JOIN dbo.Movimentos ON Movimentos.ContaNumero = Contas.ContaNumero
INNER JOIN dbo.Clientes ON Clientes.ClienteCodigo = Contas.ClienteCodigo
INNER JOIN dbo.Agencias ON Agencias.AgenciaCodigo = Contas.AgenciaCodigo
INNER JOIN dbo.TipoMovimento ON TipoMovimento.TipoMovimentoCodigo = Movimentos.MovimentoTipo