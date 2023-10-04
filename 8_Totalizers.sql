-- Totalizers

select *
from (
    select B.Ds_Categoria,
           B.Ds_Produto,
           COUNT(*) as Qt_Vendas,
           SUM(B.Preco) as Vl_Total
    from #Vendas A
    join #Produtos B on B.Codigo = A.Cd_Produto
    group by B.Ds_Categoria, B.Ds_Produto

    union all
    
    select B.Ds_Categoria,
           'Subtotal' as Ds_Produto,
           COUNT(*) as Qt_Vendas,
           SUM(B.Preco) as Vl_Total
    from #Vendas A
    join #Produtos B on B.Codigo = A.Cd_Produto
    group by B.Ds_Categoria

    union all

    select 'Total' as Ds_Categoria,
           'Total' as Ds_Produto,
           COUNT(*) as Qt_Vendas,
           SUM(B.Preco) as Vl_Total
    from #Vendas A
    join #Produtos B on B.Codigo = A.Cd_Produto
) A
order by
    (case when A.Ds_Categoria = 'Total' then 1 else 0 end),
    A.Ds_Categoria,
    (case when A.Ds_Produto = 'Subtotal' then 1 else 0 end),
    A.Ds_Produto

-- Using ROLLUP

select isnull(B.Ds_Categoria, 'Total') as Ds_Categoria,
       isnull(B.Ds_Produto, 'Subtotal') as Ds_Produto,
       count(*) as Qt_Vendas,
       sum(B.Preco) as Vl_Total
from #Vendas A
join #Produtos B on B.Codigo = A.Cd_Produto
group by rollup(B.Ds_Categoria, B.Ds_Produto)

-- Breaking per month

select isnull(convert(varchar(10), month(A.Dt_Venda)), 'Total') as Mes_Venda,
       isnull(B.Ds_Categoria, 'Subtotal') as Ds_Categoria,
       count(*) as Qt_Vendas,
       sum(B.Preco) as Vl_Total
from #Vendas A
join #Produtos B on B.Codigo = A.Cd_Produto
group by rollup(month(A.Dt_Venda), B.Ds_Categoria)

-- Grouping by cube

select isnull(convert(varchar(10), month(A.Dt_Venda)), 'Total') as Mes_Venda,
       isnull(B.Ds_Categoria, 'Subtotal') as Ds_Categoria,
       count(*) as Qt_Vendas,
       sum(B.Preco) as Vl_Total
from #Vendas A
join #Produtos B on B.Codigo = A.Cd_Produto
group by cube(month(A.Dt_Venda), B.Ds_Categoria)

-- Using Grouping Sets

select month(A.Dt_Venda) as Mes_Venda,
       B.Ds_Categoria,
       B.Ds_Produto,
       count(*) as Qt_Vendas,
       sum(B.Preco) as Vl_Total
from #Vendas A
join #Produtos B on B.Codigo = A.Cd_Produto
group by grouping sets(month(A.Dt_Venda), B.Ds_Categoria, B.Ds_Produto)