use ecommerce_upgrade;

-- Inserindo dados ficiticios no banco
insert into clients (Fname, Address, Bdate, clientType) values
('Bruno', 'Rua A, 100', '1995-05-10', 'PF'),
('Empresa X', 'Av. Central, 500', null, 'PJ');


insert into clientPF (idClient, CPF) values
(1, '12345678901');

insert into clientPJ (idClient, CNPJ, SocialName) values
(2, '12345678000199', 'Empresa X LTDA');

insert into product (Pname, classification_kids, category, avaliation, size) values
('Notebook', false, 'Eletrônico', 4.5, 'Médio'),
('Camiseta', false, 'Vestimenta', 4.0, 'G'),
('Boneca', true, 'Brinquedos', 4.8, 'Pequeno');

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
(1, 'Confirmado', 'Compra de eletrônicos', 15, false),
(2, 'Em processamento', 'Compra corporativa', 20, true);

insert into paymentMethod (typePayment) values
('Cartão Crédito'),
('Pix'),
('Boleto');

insert into clientPayment 
(idClient, idPayment, cardNumber, cardHolder, expirationDate, limitAvailable) values
(1, 1, '4111111111111111', 'Bruno Rodrigues', '12/28', 5000),
(1, 2, null, null, null, null),
(2, 3, null, null, null, null);

insert into delivery (idOrder, deliveryStatus, trackingCode, deliveryDate) values
(1, 'Enviado', 'BR123456789', '2026-02-05'),
(2, 'Aguardando envio', null, null);

insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
(1, 1, 1, 'Disponível'),
(2, 1, 2, 'Disponível'),
(3, 2, 5, 'Disponível');

insert into productStorage (storageLocation, quantity) values
('Centro de Distribuição SP', 100),
('Centro de Distribuição RJ', 50);

insert into storageLocation (idLproduct, idLstorage, location) values
(1, 1, 'Corredor A'),
(2, 2, 'Corredor B'),
(3, 1, 'Corredor C');

insert into supplier (SocialName, CNPJ, contact) values
('Fornecedor Alpha', '11111111000199', '11999999999'),
('Fornecedor Beta', '22222222000199', '21988888888');

insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
(1, 1, 200),
(1, 2, 300),
(2, 3, 150);

insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
('Loja Central', 'Central Store', '33333333000199', null, 'São Paulo', '1133333333'),
('Vendedor João', null, null, '123456789', 'Rio de Janeiro', '21977777777');

insert into productSeller (idPseller, idProduct, prodQuantity) values
(1, 1, 10),
(1, 2, 20),
(2, 3, 15);

-- Queries

-- Liste o nome, categoria e avaliação de todos os produtos cadastrados.
select Pname, category, avaliation from product;

-- Liste os produtos da categoria Eletrônico com avaliação maior ou igual a 4.
select Pname, avaliation from product
	where category = 'Eletrônico'
	and avaliation >= 4;

-- Mostre o valor do frete e o valor total estimado do pedido (frete + valor base fixo de 100).
select idOrder, sendValue, sendValue + 100 as totalEstimatedValue from orders;

-- Liste os produtos ordenados pela avaliação, do maior para o menor.
desc product;
select Pname, category, avaliation from product
	order by avaliation;
    
-- Liste as categorias de produtos que possuem mais de um produto cadastrado.
select * from product;

select category from product
	group by category
    having count(*) > 1;
    
-- Liste os pedidos com o nome do cliente, status do pedido e status da entrega.
select c.Fname as ClientName, o.idOrder, o.orderStatus, d.deliveryStatus from orders o
	join clients c on o.idOrderClient = c.idClient
	join delivery d on o.idOrder = d.idOrder;
    
-- Liste os pedidos confirmados, com nome do cliente e código de rastreio, ordenados pelo código de rastreio.
select c.Fname, o.idOrder, o.orderStatus, d.trackingCode from orders o
	join clients c
    on o.idOrderClient = c.idClient
	join delivery d
    on o.idOrder = d.idOrder
	where o.orderStatus = 'Confirmado'
	order by d.trackingCode;
    
-- Liste os clientes que realizaram mais de um pedido.
select c.Fname, count(o.idOrder) as totalOrders from clients c
	join orders o
    on c.idClient = o.idOrderClient
	group by c.idClient, c.Fname
	having count(o.idOrder) > 1;


