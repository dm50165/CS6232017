create table Product(prod_id char(10), pname varchar(30), price decimal);
alter table Product add constraint pk_product primary key (prod_id);
alter table Product add constraint ck_product_price check (price > 0);
insert into Product values('p1','tape',2.5);
insert into Product values('p2','tv',250);
insert into Product values('p3','vcr',80);

create table Depot(dep_id char(10), addr varchar(100), volume integer); 
Alter table Depot add constraint pk_depot primary key (dep_id);
Alter table Depot add constraint ck_depot_volume check (volume > 0);
insert into Depot values('d1','New york',9000);
insert into Depot values('d2','Syracude',6000);
insert into Depot values('d4','New York',2000);

create table Stock(prod_id char(10), dep_id char(10), quantity integer);
Alter table Stock add constraint pk_stock primary key (prod_id,dep_id);
Alter table Stock add constraint fk_stock_product foreign key (prod_id) references product (prod_id);
Alter table Stock add constraint fk_stock_depot foreign key (dep_id) references depot (dep_id); 
insert into Stock values('p1','d1',1000);
insert into Stock values('p1','d2',-100);
insert into Stock values('p1','d4',1200);
insert into Stock values('p3','d1',3000);
insert into Stock values('p3','d4',2000);
insert into Stock values('p2','d4',1500);
insert into Stock values('p2','d1',-400);
insert into Stock values('p2','d2',2000);

--1. What are the #prods whose name begins with a 'p' and are less than $300.00?
SELECT prod_id FROM Product WHERE prod_id LIKE 'p%' AND price<300; 
                                              
--2. Names of the products stocked in 'd2'.          
--(a) without in/not in                                      
SELECT pname FROM Product,Stock WHERE Product.prod_id=Stock.prod_id AND dep_id='d2';
--(b) with in/not in
SELECT pname FROM Product WHERE prod_id IN (SELECT prod_id FROM Stock WHERE dep_id='d2');

-- 3. #prod and names of the products that are out of stock.
--(a) without in/not in
SELECT Product.prod_id,pname FROM Product,Stock WHERE Product.prod_id=Stock.prod_id AND quantity<0;
--(b) with in/not in
SELECT prod_id,pname FROM Product WHERE prod_id IN (SELECT prod_id FROM Stock WHERE quantity<0);

--4. Addresses of the depots where the product 'p1' is stocked.
--(a) without exists/not exists and without in/not in
SELECT addr FROM Depot,Stock WHERE Depot.dep_id=Stock.dep_id AND prod_id='p1';
--(b) with in/not in
SELECT addr FROM Depot WHERE dep_id IN (SELECT dep_id FROM Stock WHERE prod_id='p1');
--(c) with exists/not exists                      
SELECT addr FROM Depot WHERE EXISTS (SELECT dep_id FROM Depot INTERSECT SELECT dep_id FROM Stock WHERE prod_id='p1');
--MINUS is not available in the PostgreSQL.

--5. #prods whose price is between $250.00 and $400.00.                                                        
--(a) using intersect.                                       
SELECT prod_id FROM Product INTERSECT SELECT prod_id FROM Product WHERE price BETWEEN 250 AND 400;                          
--(b) without intersect.
SELECT prod_id FROM Product WHERE price BETWEEN 250 AND 400;

--6. How many products are out of stock?
SELECT COUNT(prod_id) FROM Stock WHERE quantity<0; 

--7. Average of the prices of the products stocked in the 'd2' depot.                                          
SELECT AVG(price) FROM Product,Stock WHERE Product.prod_id=Stock.prod_id AND dep_id='d2';

--8. #deps of the depot(s) with the largest capacity (volume).                                                 
SELECT dep_id FROM Depot WHERE volume IN (SELECT MAX(volume) FROM Depot);

--9. Sum of the stocked quantity of each product.
SELECT prod_id,SUM(quantity) FROM Stock GROUP BY prod_id;

--10. Products names stocked in at least 3 depots.                                                             
--(a) using count                                            
SELECT pname FROM Product WHERE prod_id IN (SELECT prod_id FROM Stock GROUP BY prod_id HAVING COUNT(dep_id)>=3); 
--(b) without using count                         
SELECT pname FROM Product WHERE prod_id IN (SELECT DISTINCT T1.prod_id FROM Stock T1, Stock T2, Stock T3 WHERE T1.prod_id=T2.prod_id AND T2.prod_id=T3.prod_id AND T1.dep_id<>T2.dep_id AND T2.dep_id<>T3.dep_id AND T1.dep_id<>T3.dep_id);

--11. #prod stocked in all depots.                
--(a) using count                                            
SELECT prod_id FROM Stock,Depot WHERE Stock.dep_id=Depot.dep_id GROUP BY prod_id HAVING COUNT (Stock.dep_id)=(SELECT COUNT(Depot.dep_id) FROM Depot);
--(b) using exists/not exists                     
SELECT Product.prod_id FROM Product WHERE NOT EXISTS (SELECT Depot.dep_id FROM Depot INTERSECT SELECT Stock.dep_id FROM Depot,Stock WHERE Depot.dep_id=Stock.dep_id AND Stock.prod_id=Product.prod_id);
--MINUS is not available in the PostgreSQL
