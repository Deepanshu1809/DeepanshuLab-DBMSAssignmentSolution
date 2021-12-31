
Drop database if Exists ECommerce ; 

create database ECommerce ;

use ECommerce ;

/* --------------------------------------------------- Q.No 1 ---------------------------------------------------*/

create table Supplier(SUPP_ID int primary key ,
					  SUPP_NAME varchar(20),
                      SUPP_CITY varchar(30),
                      SUPP_PHONE varchar(30));
                      
create table Customer(CUS__ID int primary key ,
					  CUS_NAME varchar(20),
                      CUS_PHONE varchar(30),
                      CUS_CITY varchar(30),
                      CUS_GENDER varchar(20));
                      
create table Category(CAT_ID int primary key ,
					  CAT_NAME varchar(30));
                      
create table Product(PRO_ID int primary key ,
					 PRO_NAME varchar(30),
                     PRO_DESC varchar (30) ,
                     CAT_ID int,
                     FOREIGN KEY(CAT_ID) REFERENCES Category(CAT_ID));
                     
create table ProductDetails(PROD_ID int primary key ,
							PRO_ID int ,
                            SUPP_ID int,
                            PRICE int,
                            FOREIGN KEY(PRO_ID) REFERENCES Product(PRO_ID),
                            FOREIGN KEY(SUPP_ID) REFERENCES Supplier(SUPP_ID));
                            
create table Orders(ORD_ID int primary key ,
					ORD_AMOUNT int ,
                    ORD_DATE date ,
                    CUS_ID int ,
                    PROD_ID int ,
                    FOREIGN KEY(CUS_ID) REFERENCES Customer(CUS__ID),
                    FOREIGN KEY(PROD_ID) REFERENCES ProductDetails(PROD_ID));
                    
create table Rating(RAT_ID int primary key ,
					CUS_ID int ,
                    SUPP_ID int,
                    RAT_RATSTARS int , 
                    FOREIGN KEY(CUS_ID) REFERENCES Customer(CUS__ID),
                    FOREIGN KEY(SUPP_ID) REFERENCES Supplier(SUPP_ID));



/* --------------------------------------------------- Q.No 2 ---------------------------------------------------*/

insert into Supplier values(1,"Rajesh Retails","Delhi","1234567890");
insert into Supplier values(2,"Appario Ltd.","Mumbai","2589631470");
insert into Supplier values(3,"Knome products","Banglore","9785462315");
insert into Supplier values(4,"Bansal Retails","Kochi","8975463285");
insert into Supplier values(5,"Mittal Ltd.","Lucknow","7898456532");

insert into Customer values (1,"AAKASH","9999999999","DELHI","M");
insert into Customer values (2,"AMAN","9785463215","NOIDA","M");
insert into Customer values (3,"NEHA","9999999999","MUMBAI","F");
insert into Customer values (4,"MEGHA","9994562399","KOLKATA","F");
insert into Customer values (5,"PULKIT","7895999999","LUCKNOW","M");

insert into category values (1,"BOOKS");
insert into category values (2,"GAMES");
insert into category values (3,"GROCERIES");
insert into category values (4,"ELECTRONICS");
insert into category values (5,"CLOTHES");

insert into Product values (1,"GTA V","DFJDJFDJFDJFDJFJF",2);
insert into Product values (2,"TSHIRT","DFDFJDFJDKFD",5);
insert into Product values (3,"ROG LAPTOP","DFNTTNTNTERND",4);
insert into Product values (4,"OATS"," REURENTBTOTH",3);
insert into Product values (5,"HARRY POTTER","NBEMCTHTJTH",1);

insert into ProductDetails values (1,1,2,1500);
insert into ProductDetails values (2,3,5,30000);
insert into ProductDetails values (3,5,1,3000);
insert into ProductDetails values (4,2,3,2500);
insert into ProductDetails values (5,4,1,1000);

insert into Orders values(50,2000,"2021-10-06",2,1);
insert into Orders values(20,1500,"2021-10-12",3,5);
insert into Orders values(25,30500,"2021-09-16",5,2);
insert into Orders values(26,2000,"2021-10-05",1,1);
insert into Orders values(30,3500,"2021-08-16",4,3);

insert into Rating values(1,2,2,4);
insert into Rating values(2,3,4,3);
insert into Rating values(3,5,1,5);
insert into Rating values(4,1,3,2);
insert into Rating values(5,4,5,4);

/* --------------------------------------------------- Q.No 3 ---------------------------------------------------*/

select Customer.CUS_GENDER,count(Customer.CUS_GENDER) as count from Customer inner join Orders on Customer.CUS__ID=Orders.CUS_ID where Orders.ORD_AMOUNT>=3000 group by Customer.CUS_GENDER;

/* --------------------------------------------------- Q.No 4 ---------------------------------------------------*/

select Orders.*,product.pro_name from Orders ,productDetails,product where Orders.cus_id=2 and Orders.prod_id=ProductDetails.prod_id and ProductDetails.prod_id=product.pro_id;

/* --------------------------------------------------- Q.No 5 ---------------------------------------------------*/

select Supplier.* from Supplier, ProductDetails where Supplier.Supp_Id in (select ProductDetails.SUPP_ID from ProductDetails group by ProductDetails.Supp_ID having count(ProductDetails.SUPP_ID) > 1) group by Supplier.SUPP_ID;

/* --------------------------------------------------- Q.No 6 ---------------------------------------------------*/
/*Method 1 : -*/
SELECT 
   Category.*
FROM
    Orders
        INNER JOIN
    productdetails ON Orders.prod_id = productdetails.prod_id
        INNER JOIN
    product ON product.pro_id = productdetails.pro_id
        INNER JOIN
    category ON category.cat_id = product.cat_id where Ord_Amount= (Select min(ord_amount) from Orders);
 
 /* Method 2 : -*/
SELECT 
   category.*
FROM
    Category
        INNER JOIN
    product ON category.cat_id = product.cat_id
       INNER JOIN 
    productDetails On ProductDetails.pro_id=product.pro_id 
    where productDetails.prod_id = (Select Prod_id from Orders where Ord_Amount= (Select min(ord_amount) from Orders));
/* --------------------------------------------------- Q.No 7 ---------------------------------------------------*/

SELECT 
    product.pro_id, product.pro_name
FROM
    Orders
        INNER JOIN
    productdetails ON productdetails.prod_id = Orders.prod_id
        INNER JOIN
    product ON product.pro_id = productdetails.pro_id
WHERE
    Orders.ord_date > '2021-10-05';
    
/* --------------------------------------------------- Q.No 8 ---------------------------------------------------*/

SELECT 
    supplier.supp_id,
    supplier.supp_name,
    customer.cus_name,
    rating.rat_ratstars
FROM
    rating
        INNER JOIN
    supplier ON rating.supp_id = supplier.supp_id
        INNER JOIN
    customer ON rating.cus_id = customer.cus__id
ORDER BY rating.rat_ratstars DESC
LIMIT 3;

/* --------------------------------------------------- Q.No 9 ---------------------------------------------------*/

SELECT 
    customer.cus_name, customer.cus_gender
FROM
    customer
WHERE
    customer.cus_name LIKE 'A%'
        OR customer.cus_name LIKE '%A';

/* --------------------------------------------------- Q.No 10 ---------------------------------------------------*/

SELECT 
    SUM(Orders.ord_amount) AS Amount
FROM
    Orders
        INNER JOIN
    customer ON Orders.cus_id = customer.cus__id
WHERE
    customer.cus_gender = 'M';

/* --------------------------------------------------- Q.No 11 ---------------------------------------------------*/

select *  from customer left outer join Orders on customer.cus__id=Orders.cus_id; 

/* --------------------------------------------------- Q.No 12 ---------------------------------------------------*/

DELIMITER &&  
CREATE PROCEDURE proc()
BEGIN
select supplier.supp_id,supplier.supp_name,rating.rat_ratstars,
CASE
    WHEN rating.rat_ratstars >4 THEN 'Genuine Supplier'
    WHEN rating.rat_ratstars>2 THEN 'Average Supplier'
    ELSE 'Supplier should not be considered'
END AS verdict from rating inner join supplier on supplier.supp_id=rating.supp_id;
END &&  
DELIMITER ;  

call proc();