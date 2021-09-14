CREATE DATABASE mercado;

USE mercado;

CREATE TABLE categoria (
idcategoria int not null primary key auto_increment,
descricao VARCHAR(45)
);

INSERT INTO categoria (descricao)
VALUES ('Higiene pessoal'),('Limpeza'),('Cama, mesa e banho'),('Frios'), ('Bazar');

/*ot 02*/

CREATE TABLE produto(
idproduto int not null primary key auto_increment,
descricao VARCHAR(45),
preco float,
idcategoria int,
CONSTRAINT fkcategoria FOREIGN KEY (idcategoria)
references categoria (idcategoria));

INSERT INTO produto (descricao, preco, idcategoria) 
VALUES ('Escova dental', 3.50, 1), ('Creme dental', 2.90, 1),
('Presunto', 4.99, 4),('Lençol 180 fios', 85.80, 3),
('Desinfetante', 6.99,2);

/*Selecione todos os campos da tabela produto e a descrição de sua categoria,
cujo produto seja da categoria “Higiene pessoal”;*/

use mercado;

SELECT produto.*, categoria.descricao FROM produto
INNER JOIN categoria
ON categoria.idcategoria = produto.idcategoria
WHERE categoria.idcategoria = 1;

/*Selecione apenas o preço de todos os produtos da tabela produto e a
descrição de sua categoria, cuja categoria seja “Limpeza”;*/

SELECT produto.preco, produto.descricao, categoria.descricao FROM produto
INNER JOIN categoria
ON categoria.idcategoria = produto.idcategoria
WHERE categoria.idcategoria = 2;

/*Selecione a descrição do produto, preço do produto e descrição da categoria
de todos os produtos da tabela produto;*/

SELECT produto.descricao, produto.preco, categoria.descricao FROM produto
LEFT JOIN categoria
ON categoria.idcategoria = produto.idcategoria;

/*Selecione todos os campos da tabela produto e a descrição de sua categoria,
cujo os produtos sejam da categoria “Higiene pessoal” e cuja descrição do
produto termine com a palavra “dental”*/

SELECT produto.*, categoria.descricao FROM produto
INNER JOIN categoria
ON categoria.idcategoria = produto.idcategoria
WHERE produto.descricao like '%dental' and categoria.idcategoria = 1;	

/*Selecione todos os produtos da categoria “higiene pessoal” ou “limpeza”;*/

SELECT produto.*, categoria.descricao FROM produto
INNER JOIN categoria
ON categoria.idcategoria = produto.idcategoria
WHERE categoria.idcategoria = 1 OR categoria.idcategoria = 2;


/*Selecione todos os produtos onde sua categoria seja diferente de “frios e
laticínios” ;*/

SELECT produto.*, categoria.descricao FROM produto
INNER JOIN categoria
ON categoria.idcategoria = produto.idcategoria
WHERE categoria.idcategoria != 4; /*'<>' tbm serve*/

/*Selecione os produtos que não estejam na categoria “cama, mesa e banho” e
“limpeza”*/

SELECT produto.* from produto
INNER JOIN categoria
ON categoria.idcategoria = produto.idcategoria
WHERE categoria.idcategoria <> 3 and categoria.idcategoria <> 2;

/*Selecione todas as categorias com todos seus produtos, inclusive aquelas que
não possuem produto*/

SELECT produto.* FROM produto
INNER JOIN categoria
ON categoria.idcategoria = produto.idcategoria;


/*  OT 03  */

USE mercado;

CREATE TABLE vendas (
idvenda int not null primary key auto_increment,data_venda date);

INSERT INTO vendas(data_venda)
VALUES ('2017-01-23'),('2017-11-04'),('2017-07-07'),('2017-07-08'),('2017-07-09'),('2017-07-10');

CREATE TABLE vendas_has_produto(
idvenda int,
idproduto int,
quantidade int,
CONSTRAINT fkvenda FOREIGN key (idvenda)
REFERENCES vendas (idvenda),
CONSTRAINT fkproduto FOREIGN KEY (idproduto)
REFERENCES produto(idproduto),
PRIMARY KEY (idvenda,idproduto));


INSERT INTO vendas_has_produto(idvenda,idproduto,quantidade)
VALUES (1,1,5),(1,2,2),(1,4,6),(2,1,2),(3,4,1),(3,1,4),(4,2,2),(4,1,3),(5,4,4),(6,2,1);


/*Selecione todos campos das vendas, onde o produto “Escova dental” tenha
sido vendido;*/

SELECT vendas.*,produto.descricao FROM vendas
INNER JOIN vendas_has_produto on vendas.idvenda = vendas_has_produto.idvenda 
INNER JOIN produto on vendas_has_produto.idproduto = produto.idproduto
WHERE produto.idproduto = 1;

/*Selecione a data das vendas onde o produto “Creme dental” tenha sido
vendido;*/

SELECT vendas.data_venda,produto.descricao from vendas
INNER JOIN vendas_has_produto on vendas.idvenda = vendas_has_produto.idvenda 
INNER JOIN produto on vendas_has_produto.idproduto = produto.idproduto
WHERE vendas_has_produto.idproduto = 2;

/*Selecione todas as descrições dos produtos da venda que ocorreu no dia
“23/01”;*/

SELECT vendas.*, produto.descricao from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
WHERE vendas.idvenda=1;

/*Selecione a descrição todas as categorias de produtos que foram vendidos;*/

SELECT categoria.descricao FROM categoria
INNER JOIN produto ON categoria.idcategoria=produto.idproduto
INNER JOIN vendas_has_produto ON vendas_has_produto.idproduto = produto.idproduto; /* era para buscar pela categoria, e não a venda...*/


/*Selecione todas as vendas que não sejam da categoria “Higiene pessoal’;*/

SELECT vendas.*, produto.descricao FROM vendas
INNER JOIN vendas_has_produto on vendas.idvenda = vendas_has_produto.idvenda 
INNER JOIN produto on vendas_has_produto.idproduto = produto.idproduto
WHERE produto.idcategoria != 1 /*diferente de 1 higiene pessoal*/;

/*OT 04*/

/*Mostre o total de vendas em que o produto “Escova dental” foi vendido.
Chame o resultado dessa consulta de “total_venda_escovas”;*/

SELECT COUNT(vendas.idvenda) AS total_venda_escovas FROM vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
WHERE produto.idproduto = 1; /* tã tã tã consegui !!!!*/ /*poderia pegar diretamente pela vendas_has_produto*/

/*Mostre o valor total da venda de id “2” (considere o preço dos produtos
vendidos e sua quantidade);*/

		/*ADENDO NÃO PODE DAR ESPAÇO NO COUNT E O PARENTESES, SE NÃO NEM FUNCIONA E DA ERRO 1630*/
SELECT SUM(produto.preco) AS qtSomaIdDois from vendas /*faltou calcular o preço do produto*/
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda 
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
WHERE vendas.idvenda =2; /*retorna 3,50 apenas 1 item deste foi vendido, correspondente a escova dental de 3,50*/

/*Mostre o valor total da venda do dia 23/01;*/

SELECT SUM(produto.preco) as qtVendaDia23 from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda 
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
WHERE vendas.data_venda = '2017-01-23';

/*Mostre a média dos valores dos produtos da venda do dia 23/01. Chame o
resultado dessa consulta de “media_produtos”;*/

SELECT AVG(produto.preco) as media_produtos from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda 
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
WHERE vendas.data_venda = '2017-01-23';

/*Selecione a descrição do produto e seu valor, do produto com maior preço
cadastrado (sem join);*/ 

SELECT descricao, preco from produto
ORDER BY preco DESC
LIMIT 1; /*really que dava pra colocar sozinho essa instrução*/

/*Mostre os produtos da venda do dia 07/07. Porém, apenas dos produtos que
tenha valor acima de R$4,00;*/

SELECT vendas.*, produto.descricao, produto.preco FROM vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
WHERE produto.preco > 4 and vendas.idvenda = 3;

/*Verifique qual foi o produto mais vendido;*//*FIXED*/

SELECT SUM(vendas_has_produto.quantidade) as vendasQt, descricao,produto.idproduto from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
group by vendas.idvenda
ORDER BY vendas_has_produto.quantidade desc
LIMIT 1; /*seria id 1, arrumar pois pego apenas os dados de uma venda ... */ /*FIXED*/

/*Selecione o produto mais barato no sistema;*/

SELECT produto.preco, descricao from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
ORDER BY preco ASC
LIMIT 1; /*talvez não precisasse de tanto dava pra colocar a pesquisa só no produto sem muita frescura :)*/

/*Selecione o dia que que houve a menor quantidade de produtos vendidos
(menos se vendeu);*/

SELECT data_venda, vendas.idvenda,SUM(vendas_has_produto.quantidade) as soma from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
GROUP BY vendas.idvenda
ORDER BY vendas_has_produto.quantidade ASC
LIMIT 1;

/*Selecione o nome das categorias que tiveram produtos vendidos;*/

SELECT DISTINCT categoria.descricao from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
INNER JOIN categoria on categoria.idcategoria = produto.idcategoria
WHERE vendas_has_produto.quantidade > 0;

/*Selecione quantas vendas foram realizadas e nomeie de total_qtd_vendas;*//*FIXED*/

SELECT COUNT(vendas_has_produto.idvenda) as total_qtd_vendas from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto;/* selecionar pelas vendas, nao por itens */ /*FIXED*/

/*Selecione o total de vendas entre os dias 08-07 e 10-07;*/

SELECT SUM(vendas_has_produto.quantidade) as qtVendas from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
WHERE vendas.data_venda BETWEEN '2017-07-08' AND '2017-07-10'; /*fixed*/

/*Selecione todas as vendas com o total por dia e ordene do dia mais atual ao
mais antigo;*/

SELECT SUM(vendas_has_produto.quantidade) as totalVendasDia, data_venda from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
GROUP BY data_venda
ORDER BY data_venda DESC;

/*Selecione todas as vendas com seus totais e o dia, ordene pelo dia mais
lucrativo;*/

/*SELECT SUM(produto.preco) as totalValorVenda, data_venda from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
GROUP BY data_venda
ORDER BY totalValorVenda DESC;/*ignorei a qtd, :(*/  /*FIXED*/

SELECT vendas.idvenda, SUM(produto.preco) as totalValorVenda, data_venda from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
GROUP BY idvenda
ORDER BY totalValorVenda DESC;


/*OT 05*/

CREATE TABLE endereco(
idendereco int not null primary key auto_increment,
rua VARCHAR(45),
bairro VARCHAR(45),
numero INT,
cidade VARCHAR(45));

CREATE TABLE vendedor(
idvendedor int not null primary key auto_increment,
nome VARCHAR(45),
salario FLOAT,
data_nasc DATE,
idendereco int,
CONSTRAINT fkendereco FOREIGN key (idendereco)
REFERENCES endereco (idendereco));

/*ot 06*/

INSERT INTO endereco(rua,bairro,numero,cidade)
VALUES ('Rua 1','bairro 1',1,'cidade 1'),('Rua 2','bairro 2',2,'cidade 2'),('Rua 3','bairro 3',3,'cidade 3');

INSERT INTO vendedor(nome,salario,data_nasc,idendereco)
VALUES('Sergio',100,'1990-01-01',1),('claudislau',90,'1992-02-02',2),('Irineu vc nao sabe nem eu',85,'1993-03-03',3);

select * from vendedor
inner JOIN endereco on vendedor.idendereco = endereco.idendereco;


CREATE VIEW view_usuario as SELECT vendedor.idvendedor, vendedor.nome, vendedor.data_nasc, vendedor.idendereco FROM vendedor;

SELECT * FROM view_usuario;

CREATE VIEW view_adm as SELECT vendedor.* FROM vendedor
INNER JOIN endereco on endereco.idendereco = vendedor.idendereco;

ALTER VIEW view_adm as SELECT vendedor.*, endereco.rua,endereco.bairro,endereco.cidade FROM vendedor
INNER JOIN endereco on endereco.idendereco = vendedor.idendereco;/* da erro se colocar dentro do select endereco.* em vez dos campos descritos*/

SELECT * FROM view_adm;

CREATE VIEW view_estoque as SELECT categoria.descricao as descri_cat, produto.descricao as descri_prod, produto.preco from produto
INNER JOIN categoria on categoria.idcategoria = produto.idcategoria;

select * from view_estoque;


/*1- Agora, crie uma trigger para que quando o salário de um vendedor seja
alterado, ele não possa ser menor do que o já cadastrado.*/

DELIMITER $$

CREATE TRIGGER salario_alteracao BEFORE UPDATE ON vendedor
FOR EACH ROW 
begin
	if (new.salario < old.salario) THEN
		SET NEW.salario = OLD.salario;
	end if;
end$$

DELIMITER ;

SELECT * FROM view_adm;

UPDATE vendedor 
set salario = 9
where idvendedor = 3;
    
/*2- Crie uma trigger para que quando seja inserido um novo vendedor altere
o salário dele para R$998,00*/

DELIMITER $$

CREATE TRIGGER salario_novo BEFORE INSERT ON vendedor
FOR EACH ROW 
begin
    SET new.salario = 998;
end$$

DELIMITER ;

INSERT INTO vendedor(nome,data_nasc,idendereco)
VALUES('JOCATECIRKLAUDIO BRUNO','1990-04-04',4);


SELECT * FROM view_adm;

/*3- Crie uma trigger para que quando um vendedor for deletado do banco
seja inserido um novo vendedor com o salário igual a R$10,00;*/

/*DROP TRIGGER delete_vendedor;
DELIMITER $$
CREATE TRIGGER delete_vendedor BEFORE DELETE ON vendedor
for each row
BEGIN
SET new.nome= 'teste';
set new.salario = '10';
end$$
DELIMITER ;
DELETE FROM vendedor
WHERE idvendedor = 10;*/ 

/*ESTA TRIGGER NÃO PODE SER FEITA, não passa de uma linda pegadinha dos professores*/

SELECT * FROM view_adm;


/*4- Imagine alguma outra situação onde seja interessante criar uma trigger, dentro
da proposta em que estamos trabalhando e faça-a.*/

DELIMITER $$

CREATE TRIGGER salario_teto BEFORE UPDATE ON vendedor
FOR EACH ROW 
begin
	if (new.salario > 5000) THEN
		SET NEW.salario = OLD.salario;
	end if;
end$$

DELIMITER ;

INSERT INTO vendedor(nome,data_nasc,idendereco)
VALUES('bruno','1990-04-04',4);

UPDATE vendedor
SET salario = 5001
where idvendedor = 11;

SELECT * FROM view_adm;

/*OT 08*/

/*1-Agora, crie uma procedure para atualizar o preço de um produto. Para
isso, a procedure deve receber o id do produto e o novo preço dele.*/

DELIMITER $$

CREATE PROCEDURE atualizar_preco_produto(IN novo_valor FLOAT, IN idproduto_ INT)
BEGIN 
UPDATE produto
SET preco = novo_valor
where idproduto = idproduto_;
END$$

DELIMITER ;

CALL atualizar_preco_produto (350,1);

select * from view_estoque;

/*2- Crie uma procedure onde aumente o valor de todos os produtos em 10%;*/

DELIMITER $$

CREATE PROCEDURE aumento10_p()
BEGIN
SET SQL_SAFE_UPDATES = 0;
UPDATE produto
set preco = preco*1.1; /*10%*/
SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;

select * from view_estoque;

call aumento10_p;


/*3- Crie uma procedure onde some a quantidade vendida de um produto e
aumente o valor do mesmo utilizando a soma da quantidade como
porcentagem, ou seja, se foram vendidas 15 escovas de dente o valor de
escova de dente deve aumentar em 15%;*/

DELIMITER $$

CREATE PROCEDURE aumento_preco_perc(IN idproduto_ INT)
BEGIN

UPDATE produto ,(SELECT SUM(vendas_has_produto.quantidade) as totalVendas from vendas
INNER JOIN vendas_has_produto on vendas_has_produto.idvenda = vendas.idvenda
INNER JOIN produto on produto.idproduto = vendas_has_produto.idproduto
WHERE produto.idproduto = idproduto_) as totalVendas
SET preco = preco+(preco*(totalVendas/100))
WHERE idproduto = idproduto_;

END$$

DELIMITER ;

CALL aumento_preco_perc(1);

select * from view_estoque;


/*4- Da mesma forma que você fez para view e trigger, imagine alguma outra
situação onde seja interessante criar uma procedure, dentro da proposta em
que estamos trabalhando e faça-a.*/

DELIMITER $$

CREATE PROCEDURE promocaoVendedor_pct10(IN idvendedor_ INT)
BEGIN
UPDATE vendedor
set salario = salario*1.1
WHERE idvendedor = idvendedor_;
END$$

DELIMITER ;

SELECT * FROM view_adm;

call promocaoVendedor_pct10(2);


