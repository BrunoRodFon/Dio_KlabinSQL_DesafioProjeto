create database ecommerce_upgrade;

use ecommerce_upgrade;

-- tabela cliente modificada

create table clients(
	idClient int auto_increment primary key,
    Fname varchar(30),
    Address varchar(65),
    Bdate date,
    clientType enum('PF', 'PJ') not null
);

-- tabela pessoa fisica
create table clientPF(
	idClient int primary key,
    CPF char(11) not null,
    constraint unique_cpf unique (CPF),
    constraint fk_pf_client foreign key (idClient) references clients(idClient)
);

-- tabela pessoa juridica
create table clientPJ(
	idClient int primary key,
    CNPJ char(14) not null,
    SocialName varchar(255) not null,
    constraint unique_cnpj unique (CNPJ),
    constraint fk_pj_client foreign key (idClient) references clients(idClient)
);

-- tabela produtos
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    classification_kids bool default false,
    category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis'),
    avaliation float default 0,
    size varchar(10)
);

-- tabela meio de pagamento
create table paymentMethod(
	idPayment int auto_increment primary key,
    typePayment enum('Boleto', 'Cartão Crédito', 'Cartão Débito', 'Pix') not null
);

-- tabela de pagamentos cadastrados para os clientes
create table clientPayment(
	idClient int,
    idPayment int,
    cardNumber char(16),
    cardHolder varchar(255),
    expirationDate char(5),
    limitAvailable float,
    primary key (idClient, idPayment),
    constraint fk_client_payment_client foreign key (idClient) references clients(idClient),
    constraint fk_client_payment_payment foreign key (idPayment) references paymentMethod(idPayment)
);

-- tabela orders
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool default false,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
);

-- tabela delivery
create table delivery(
	idDelivery int auto_increment primary key,
    idOrder int,
    deliveryStatus enum('Aguardando envio', 'Enviado', 'Em transporte', 'Entregue', 'Devolvido') 
        default 'Aguardando envio',
    trackingCode varchar(50),
    deliveryDate date,
    constraint fk_delivery_order foreign key (idOrder) references orders(idOrder)
);

create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

alter table productStorage auto_increment=1;

-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

alter table supplier auto_increment=1;

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
	constraint unique_cpf_seller unique (CPF)
);

alter table seller auto_increment=1;

-- criar tabela produto vendedor
create table productSeller(
	idPseller int,
    idProduct int,
    prodQuantity int default 1,
    primary key (idPseller, idProduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idProduct) references product(idProduct)
);

-- criar tabela pedido produto

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)

);

-- criando tabela local do estoque
create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

-- criando tabela produto fornecedor
create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_prodcut foreign key (idPsProduct) references product(idProduct)
);




