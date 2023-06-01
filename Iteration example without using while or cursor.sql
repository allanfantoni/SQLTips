-- Iteration example without using while or cursor

if (object_id('tempdb..#Produtos') is not null) drop table #Produtos
create table #Produtos (
	Codigo int identity(1, 1) not null primary key,
	Ds_Produto varchar(50) not null,
	Ds_Categoria varchar(50) not null,
	Preco numeric(18, 2) not null
)

if (object_id('tempdb..#Vendas') is not null) drop table #Vendas
create table #Vendas (
	Codigo int identity(1, 1) not null primary key,
	Dt_Venda datetime not null,
	Cd_Produto int not null
)

insert into #Produtos (Ds_Produto, Ds_Categoria, Preco )
values
	('Processador i7', 'Informática', 1500.00 ),
	('Processador i5', 'Informática', 1000.00 ),
	('Processador i3', 'Informática', 500.00 ),
	('Placa de Vídeo Nvidia', 'Informática', 2000.00 ),
	('Placa de Vídeo Radeon', 'Informática', 1500.00 ),
	('Celular Apple', 'Celulares', 10000.00 ),
	('Celular Samsung', 'Celulares', 2500.00 ),
	('Celular Sony', 'Celulares', 4200.00 ),
	('Celular LG', 'Celulares', 1000.00 ),
	('Cama', 'Utilidades do Lar', 2000.00 ),
	('Toalha', 'Utilidades do Lar', 40.00 ),
	('Lençol', 'Utilidades do Lar', 60.00 ),
	('Cadeira', 'Utilidades do Lar', 200.00 ),
	('Mesa', 'Utilidades do Lar', 1000.00 ),
	('Talheres', 'Utilidades do Lar', 50.00 )

declare @Contador int = 1, @Total int = 100

while(@Contador <= @Total)
begin
	insert into #Vendas ( Cd_Produto, Dt_Venda )
	select
		(select top 1 Codigo from #Produtos order by NEWID()) as Cd_Produto,
		dateadd(day, (cast(rand() * 364 as int)), '2017-01-01') as Dt_Venda

	set @Contador += 1
end

select * from #Vendas

if (object_id('tempdb..#Vendas_Agrupadas') is not null) drop table #Vendas_Agrupadas
select
	convert(varchar(6), Dt_Venda, 112) as Periodo,
	count(*) as Qt_Vendas_No_Mes,
	null as Qt_Vendas_Acumuladas
into
	#Vendas_Agrupadas
from
	#Vendas
group by
	convert(varchar(6), Dt_Venda, 112)

select * from #Vendas_Agrupadas

select
	Periodo,
	Qt_Vendas_No_Mes,
	sum(Qt_Vendas_No_Mes) over(order by Periodo rows between unbounded preceding and current row) as Qt_Vendas_Acumuladas
from
	#Vendas_Agrupadas