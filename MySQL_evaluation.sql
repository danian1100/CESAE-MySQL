CREATE DATABASE vendas_online;
USE vendas_online;

CREATE TABLE produtos(
id_produto int primary key auto_increment,
nome varchar(150),
descricao text,
preco decimal(10,2),
stock int
);

INSERT INTO produtos (nome, descricao, preco, stock)
VALUES 
("Smartphone X200", "Smartphone com ecrã AMOLED de 6.5 polegadas, 128GB de armazenamento e câmara tripla.", 499.99, 25),
("Cadeira Gamer Ultra", "Cadeira ergonómica para jogos com apoio lombar e ajuste de altura.", 109.90, 10),
("Portátil ProBook 15", "Portátil com processador Intel i7, 16GB RAM e SSD de 512GB.", 949.50, 8),
("Auriculares Bluetooth BassX", "Auriculares sem fios com cancelamento de ruído e autonomia de 30 horas.", 59.99, 40),
("Monitor 27 - LED 4K", "Monitor com resolução 4K UHD, taxa de atualização de 144Hz e entrada HDMI.", 329.00, 12);

CREATE TABLE clientes(
id_cliente int primary key auto_increment,
nome varchar(150),
email varchar(150),
telefone varchar(15),
endereco varchar(150)
);

INSERT INTO clientes (nome, email, telefone, endereco)
VALUES 
("Ana Silva", "ana.silva@email.com", "912345678", "Rua das Flores, 123, Lisboa"),
("Bruno Costa", "bruno.costa@email.com", "934567891", "Avenida Central, 45, Porto"),
("Carla Mendes", "carla.mendes@email.com", "968112233", "Travessa da Escola, 10, Coimbra"),
("Daniel Rocha", "daniel.rocha@email.com", "926789321", "Rua do Sol, 88, Faro");

CREATE TABLE pedidos(
id_pedido int primary key auto_increment,
id_cliente int,
data_pedido date,
total decimal(10,2),
foreign key (id_cliente) references clientes(id_cliente)
);

INSERT INTO pedidos (id_cliente, data_pedido, total)
VALUES 
(1, "2024-05-01", 169.89),
(2, "2024-05-01", 999.98),
(1, "2024-05-10", 329.00),
(3, "2024-05-15", 119.98);

CREATE TABLE detalhes_pedido(
id_detalhe int primary key auto_increment,
id_pedido int,
id_produto int,
quantidade int,
preco_unitario decimal(10,2),
foreign key (id_pedido) references pedidos(id_pedido),
foreign key (id_produto) references produtos(id_produto)
);

INSERT INTO detalhes_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES 
(1, 4, 1, 59.99),      
(1, 2, 1, 109.90),     
/* A cliente Ana comprou 1 Auriculares e 1 Cadeira Gamer no pedido 1, como são produtos != há 2 values com o mesmo id_detalhe */
(2, 1, 2, 499.99),  /* Bruno comprou 2 Smartphone no mesmo dia, preco_unitario é o preço de 1 unidade */
(3, 5, 1, 329.00),   /* Ana comprou 1 Monitor */
(4, 4, 2, 59.99); 	/* A Carla comprou 2 Auriculares */


SELECT * FROM produtos WHERE stock < 20;

SELECT * FROM pedidos WHERE id_cliente = 1;

SELECT 
  DATE_FORMAT(pedidos.data_pedido, '%Y-%m') AS mes,
  DAY(pedidos.data_pedido) AS dia,
  detalhes_pedido.id_produto,
  SUM(detalhes_pedido.quantidade * detalhes_pedido.preco_unitario) AS total_vendas
FROM pedidos
JOIN detalhes_pedido 
ON pedidos.id_pedido = detalhes_pedido.id_pedido
GROUP BY mes, dia, detalhes_pedido.id_produto
ORDER BY mes, dia, detalhes_pedido.id_produto;


SELECT id_produto AS id_product, SUM(quantidade) AS quantidade_total
FROM detalhes_pedido
GROUP BY id_produto
ORDER BY id_produto;

SELECT pedidos.id_pedido, detalhes_pedido.quantidade
FROM pedidos
JOIN detalhes_pedido
ON pedidos.id_pedido = detalhes_pedido.id_pedido;

SELECT p.id_pedido, dp.quantidade
FROM  pedidos p
JOIN detalhes_pedido dp
ON p.id_pedido = dp.id_pedido
WHERE dp.preco_unitario = 59.99;

SELECT p.nome, dp.id_pedido ,dp.quantidade, pedidos.id_cliente
FROM produtos p
JOIN detalhes_pedido dp
ON dp.id_produto = p.id_produto
JOIN pedidos 
ON pedidos.id_pedido = dp.id_pedido;

SELECT p.data_pedido AS data, c.nome
FROM pedidos p
JOIN clientes c
ON c.id_cliente = p.id_cliente
ORDER BY data
