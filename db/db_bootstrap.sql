-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database restaurant;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on restaurant.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use restaurant;

-- Put your DDL 

CREATE TABLE Restaurant (
	RestaurantId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(50) NOT NULL,
	Email VARCHAR(50) NOT NULL,
	State VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	Address VARCHAR(50) NOT NULL,
	PostalCode VARCHAR(50) NOT NULL,
	OwnerFirstName VARCHAR(50) NOT NULL,
	OwnerLastName VARCHAR(50) NOT NULL,
	OwnerPhoneNumber VARCHAR(50) NOT NULL,
	OwnerEmail VARCHAR(50) NOT NULL,
	Rent DECIMAL(6,2) NOT NULL,
	PRIMARY KEY (RestaurantId)
);
CREATE TABLE Supplier (
	SupplierId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(50) NOT NULL,
	PRIMARY KEY (SupplierId)
);
CREATE TABLE Ingredient (
	IngredientId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Quantity INT NOT NULL,
	UnitPrice DECIMAL(4,2) NOT NULL,
	OrderDate DATE NOT NULL,
	ShelfLife INT NOT NULL,
	ExpirationDate DATE NOT NULL,
	SupplierId INT NOT NULL,
	RestaurantId INT NOT NULL,
	PRIMARY KEY (IngredientId),
	FOREIGN KEY (SupplierId) REFERENCES Supplier(SupplierId),
	FOREIGN KEY (RestaurantId) REFERENCES Restaurant(RestaurantId)
);
CREATE TABLE Dish (
	MenuId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Price INT NOT NULL,
	Cuisine VARCHAR(50),
	PreparationTime INT NOT NULL,
	ServingSize INT NOT NULL,
	Calories INT NOT NULL,
	DescriptionText TEXT NOT NULL,
	RestaurantId INT NOT NULL,
	PRIMARY KEY (MenuId),
	FOREIGN KEY (RestaurantId) REFERENCES Restaurant(RestaurantId)
);
CREATE TABLE Beverage (
	DrinkId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Price INT NOT NULL,
	Region VARCHAR(50),
	Dscription TEXT NOT NULL,
	Alcoholic BOOLEAN NOT NULL,
	PRIMARY KEY (DrinkId)
);
CREATE TABLE Customer (
	CustomerId INT NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	DateOfBirth DATE NOT NULL,
	Age INT NOT NULL,
	Email VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(50) NOT NULL,
	PRIMARY KEY (CustomerId)
);
CREATE TABLE Employee (
	EmployeeId INT NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	DateOfBirth DATE NOT NULL,
	Age INT NOT NULL,
	JoinDate DATE NOT NULL,
	ExitDate DATE,
	CurrentEmployee BOOLEAN NOT NULL,
	Email VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(50) NOT NULL,
	Wage INT NOT NULL,
	Restaurant INT NOT NULL,
	PRIMARY KEY (EmployeeId),
	FOREIGN KEY (Restaurant) REFERENCES Restaurant(RestaurantId)
);
CREATE TABLE EmployeeRole (
	EmployeeId INT NOT NULL,
	title ENUM('server', 'host', 'chef', 'manager') NOT NULL,
	CONSTRAINT PK_StaffRole PRIMARY KEY (EmployeeId,title),
	FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId)
);
CREATE TABLE Orders (
	OrderId INT NOT NULL AUTO_INCREMENT,
	CustomerId INT NOT NULL,
	EmployeeId INT NOT NULL,
	RestaurantId INT NOT NULL,
	TotalPrice INT NOT NULL,
	TimePlaced DATE NOT NULL,
	PredictedTotalPrepTime INT NOT NULL,
	OrderStatus ENUM('cooking', 'ready', 'pending', 'done', 'cancelled') NOT NULL,
	PRIMARY KEY (OrderId),
	FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId),
	FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId),
	FOREIGN KEY (RestaurantId) REFERENCES Restaurant(RestaurantId)
);
CREATE TABLE Allergy (
	CustomerId INT NOT NULL,
	Allergy VARCHAR(50) NOT NULL,
	PRIMARY KEY (CustomerId,Allergy),
	FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
);
CREATE TABLE DishIngredient (
	MenuId INT NOT NULL,
	IngredientId INT NOT NULL,
	CONSTRAINT PK_DishIngr PRIMARY KEY (MenuId,IngredientId),
	FOREIGN KEY (MenuId) REFERENCES Dish(MenuId),
	FOREIGN KEY (IngredientId) REFERENCES Ingredient(IngredientId)
);
CREATE TABLE RestaurantBeverage (
	RestaurantId INT NOT NULL,
	DrinkId INT NOT NULL,
	CONSTRAINT PK_RestDrink PRIMARY KEY (RestaurantId,DrinkId),
	FOREIGN KEY (RestaurantId) REFERENCES Restaurant(RestaurantId),
	FOREIGN KEY (DrinkId) REFERENCES Beverage(DrinkId)
);
CREATE TABLE OrderDish (
	OrderId INT NOT NULL,
	MenuId INT NOT NULL,
	CONSTRAINT PK_OrderDish PRIMARY KEY (OrderId,MenuId),
	FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
	FOREIGN KEY (MenuId) REFERENCES Dish(MenuId)
);
CREATE TABLE OrderBeverage (
	OrderId INT NOT NULL,
	DrinkId INT NOT NULL,
	CONSTRAINT PK_OrderDrink PRIMARY KEY (OrderId,DrinkId),
	FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
	FOREIGN KEY (DrinkId) REFERENCES Beverage(DrinkId)
);

-- Add sample data. 
-- RESTAURANTS -------------------------------------------------------------------------------
INSERT INTO Restaurant (RestaurantId, Name, PhoneNumber, Email, State, City, Address, PostalCode, OwnerFirstName, OwnerLastName, OwnerPhoneNumber, OwnerEmail, Rent) VALUES (1, 'Bobs Burgers', '704-329-5723', 'tpughe0@pbs.org', 'North Carolina', 'Charlotte', '3592 Blackbird Terrace', '28278', 'Terrye', 'Pughe', '757-937-5573', 'tpughe0@digg.com', 2157.89);
INSERT INTO Restaurant (RestaurantId, Name, PhoneNumber, Email, State, City, Address, PostalCode, OwnerFirstName, OwnerLastName, OwnerPhoneNumber, OwnerEmail, Rent) VALUES (2, 'Charlies Chocolates', '864-263-2948', 'nhalling1@nhs.uk', 'South Carolina', 'Anderson', '0925 Sherman Park', '29625', 'Norry', 'Halling', '718-724-2768', 'nhalling1@posterous.com', 2075.66);
INSERT INTO Restaurant (RestaurantId, Name, PhoneNumber, Email, State, City, Address, PostalCode, OwnerFirstName, OwnerLastName, OwnerPhoneNumber, OwnerEmail, Rent) VALUES (3, 'Panera', '570-512-2166', 'cbartlet2@twitpic.com', 'Pennsylvania', 'Scranton', '195 Red Cloud Junction', '18514', 'Care', 'Bartlet', '503-356-9604', 'cbartlet2@printfriendly.com', 3487.77);

-- EMPLOYEES -------------------------------------------------------------------------------
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (1, 'Debby', 'Courtier', '1997-05-16', 25, '2010-10-14', NULL, true, 'dcourtier0@alibaba.com', '646-177-7460', 27, 1);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (2, 'Georgeanne', 'Lowseley', '1980-11-16', 52, '1994-06-08', NULL, true, 'glowseley1@typepad.com', '202-264-7482', 29, 1);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (3, 'Alameda', 'Branchett', '2001-11-28', 21, '2017-09-04', NULL, true, 'abranchett2@tinyurl.com', '846-964-0997', 30, 1);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (4, 'My', 'Cathrae', '1971-05-20', 51, '1999-09-27', NULL, true, 'mcathrae3@oakley.com', '315-123-9381', 21, 1);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (5, 'Augustine', 'Beadle', '1979-09-17', 43, '2014-12-06', '2020-01-13', false, 'abeadle4@163.com', '269-821-9508', 24, 1);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (6, 'Pauline', 'Hazelton', '2000-01-19', 22, '2017-02-19', NULL, true, 'phazelton5@bbc.co.uk', '842-842-6785', 15, 2);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (7, 'Jilly', 'Noell', '1981-05-17', 41, '1999-02-17', NULL, true, 'jnoell6@weather.com', '205-841-8208', 20, 2);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (8, 'Byram', 'MacIlory', '1973-11-05', 49, '2000-12-12', NULL, true, 'bmacilory7@phpbb.com', '992-887-3255', 19, 2);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (9, 'Noemi', 'Libermore', '1995-04-26', 27, '1970-01-29', NULL, true, 'nlibermore8@goo.ne.jp', '621-228-0589', 21, 2);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (10, 'Amandie', 'Yuryatin', '2002-10-20', 20, '2021-11-12', '2022-01-13', false, 'ayuryatin9@baidu.com', '638-383-4754', 23, 2);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (11, 'Eugenio', 'McKeachie', '1996-02-07', 26, '2019-07-25', NULL, true, 'emckeachiea@flavors.me', '274-742-2142', 27, 3);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (12, 'Ker', 'Anelay', '1978-01-19', 44, '1998-12-10', NULL, true, 'kanelayb@google.de', '818-620-3166', 25, 3);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (13, 'Ian', 'Waterstone', '1954-11-15', 68, '1993-02-08', NULL, true, 'iwaterstonec@devhub.com', '993-594-1536', 23, 3);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (14, 'Sly', 'Splaven', '1965-01-31', 57, '1983-03-30', NULL, true, 'ssplavend@springer.com', '945-631-5219', 21, 3);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (15, 'Vivyan', 'Flockhart', '1989-12-18', 33, '2010-07-28', '2011-01-13', false, 'vflockharte@vistaprint.com', '584-536-9883', 26, 3);
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (1, 'chef');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (2, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (3, 'host');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (4, 'manager');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (5, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (6, 'manager');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (7, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (8, 'chef');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (9, 'host');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (10, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (11, 'manager');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (12, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (13, 'chef');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (14, 'host');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (15, 'chef');

-- SUPPLIER -------------------------------------------------------------------------------
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (1, 'Farmers Market', 'bfoulds0@dmoz.org', '523-259-1049');
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (2, 'Whole Foods', 'pallitt1@hp.com', '313-963-5206');
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (3, 'Trader Joes', 'bleitch2@craigslist.org', '112-314-3783');

-- INGREDIENTS -------------------------------------------------------------------------------
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (1, 'onion', 9, 23.05, '2021-11-24', 20, '2023-09-04', 3, 1);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (2, 'pepper', 1, 11.87, '2022-03-26', 13, '2023-11-01', 2, 1);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (3, 'mushroom', 68, 28.16, '2021-12-29', 10, '2023-03-04', 3, 1);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (4, 'chicken', 9, 25.9, '2022-08-25', 33, '2023-07-20', 3, 1);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (5, 'garlic', 71, 17.11, '2022-02-17', 25, '2022-12-19', 2, 1);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (6, 'potato', 57, 21.82, '2022-07-02', 20, '2023-11-10', 1, 2);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (7, 'garlic', 88, 16.29, '2022-08-02', 14, '2022-12-22', 1, 2);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (8, 'pepper', 46, 29.89, '2022-06-23', 17, '2023-11-09', 3, 2);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (9, 'carrot', 26, 2.56, '2022-01-30', 15, '2023-01-03', 2, 2);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (10, 'onion', 77, 27.46, '2022-11-04', 48, '2023-08-08', 2, 2);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (11, 'pepper', 89, 21.64, '2022-10-15', 12, '2023-01-15', 2, 3);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (12, 'garlic', 74, 9.32, '2022-05-09', 29, '2023-02-22', 3, 3);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (13, 'potato', 61, 4.06, '2022-09-18', 33, '2023-05-09', 1, 3);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (14, 'cabbage', 51, 4.06, '2022-07-03', 21, '2023-09-29', 1, 3);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (15, 'beef', 91, 9.84, '2022-06-20', 20, '2023-11-17', 1, 3);

-- DISHES -------------------------------------------------------------------------------
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (1, 'Rissoto', 8, 'Italian', 14, 3, 126, 'fancy pasta dish with lots of stuff', 1);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (2, 'Chicken Noodle Soup', 44, NULL, 20, 2, 2, 'Made from a traditional Chicken broth with buckwheat noodles', 1);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (3, 'Corndog', 48, 'American', 29, 3, 280, 'A cafeteria favorite, nice and simply made', 1);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (4, 'Spaghetti and Meatballs', 26, 'Italian', 30, 2, 232, 'Almost like mother made it, but only she could get it right', 1);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (5, 'Biryani', 21, 'Indian', 29, 1, 341, 'A mixed rice dish made with love and a little bit of something special', 1);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (6, 'Ceasar Salad', 44, 'Italian', 4, 1, 178, 'curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis', 2);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (7, 'Hambuger', 20, 'zero tolerance', 30, 2, 282, 'lectus vestibulum quam sapien varius ut blandit non interdum in', 2);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (8, 'Nachos', 41, 'support', 8, 2, 159, 'sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique', 2);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (9, 'Hot Wings', 24, 'workforce', 18, 2, 51, 'odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique', 2);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (10, 'Vegtable Soup', 48, 'Persistent', 30, 3, 163, 'ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', 2);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (11, 'Green Salad', 22, 'time-frame', 30, 2, 55, 'ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis', 3);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (12, 'Organic Smoothie', 13, 'Secured', 9, 3, 158, 'quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse', 3);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (13, 'Roasted Brussel Sprouts', 9, 'Re-engineered', 11, 1, 294, 'erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris', 3);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (14, 'Slammin Salmon', 14, 'definition', 18, 3, 379, 'sit amet sem fusce consequat nulla nisl nunc nisl duis', 3);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText, RestaurantId) VALUES (15, 'Irish Pudding', 42, 'Innovative', 2, 2, 373, 'erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi', 3);

-- DISH INGREDIENTS -------------------------------------------------------------------------------
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (1, 1);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (1, 3);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (2, 5);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (2, 2);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (3, 1);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (3, 2);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (4, 5);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (4, 3);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (5, 2);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (5, 4);

INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (6, 8);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (6, 10);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (7, 6);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (7, 9);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (8, 9);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (8, 6);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (9, 8);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (9, 7);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (10, 10);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (10, 6);

INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (11, 11);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (11, 12);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (12, 14);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (12, 15);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (13, 12);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (13, 11);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (13, 14);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (14, 12);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (14, 15);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (15, 13);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (15, 14);

-- BEVERAGE -------------------------------------------------------------------------------
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (1, 'water', 87, NULL, "A nice refreshing glass", false);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (2, 'milk', 44, NULL, "Straight from the udder", false);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (3, 'orange juice', 29, NULL, "Right off the tree", false);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (4, 'martini', 8, 'Italy', "A simple mix", true);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (5, 'cutwater', 3, 'United States', "As the brand is always", true);

-- BEVERAGE RESTAURANTS -------------------------------------------------------------------------------
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (1, 1);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (1, 2);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (1, 4);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (1, 5);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (2, 1);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (2, 3);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (2, 5);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (3, 1);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (3, 2);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (3, 3);

-- CUSTOMERS -------------------------------------------------------------------------------
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (1, 'Bobinette', 'Blampy', '2003-09-12', 87, 'bblampy0@nymag.com', '406-820-6743');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (2, 'Cathi', 'Yankin', '2014-01-20', 46, 'cyankin1@jalbum.net', '972-986-0284');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (3, 'Boris', 'Garrat', '1968-07-02', 29, 'bgarrat2@blogs.com', '375-804-7978');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (4, 'Tracy', 'Izzatt', '2000-07-13', 39, 'tizzatt3@ihg.com', '222-371-1135');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (5, 'Selia', 'Hrus', '1962-04-21', 69, 'shrus4@1und1.de', '762-670-3684');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (6, 'Franny', 'Josskovitz', '1991-06-09', 57, 'fjosskovitz5@sitemeter.com', '592-242-4834');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (7, 'Franciskus', 'Rabbe', '2001-04-02', 36, 'frabbe6@eepurl.com', '696-942-5089');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (8, 'Charmian', 'Cullum', '1984-10-14', 60, 'ccullum7@cargocollective.com', '107-890-2345');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (9, 'Kaile', 'Cooksey', '1960-04-13', 77, 'kcooksey8@tamu.edu', '481-329-7904');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (10, 'Auria', 'Godson', '1980-11-28', 28, 'agodson9@miitbeian.gov.cn', '983-977-0776');

-- CUSTOMERS ALLERGIES -------------------------------------------------------------------------------
INSERT INTO Allergy (CustomerId, Allergy) VALUES (1, 'pepper');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (1, 'milk');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (4, 'onion');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (7, 'potato');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (5, 'pepper');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (1, 'garlic');

-- Orders -------------------------------------------------------------------------------
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (1, 1, 14, 3, 51, '2022-09-05 08:26:20', 34, 'ready');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (2, 1, 4, 1, 76, '2022-04-06 09:11:42', 21, 'cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (3, 2, 9, 2, 19, '2022-03-26 15:09:13', 23, 'cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (4, 3, 6, 2, 79, '2022-08-31 11:01:35', 13, 'cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (5, 4, 12, 3, 71, '2022-05-01 15:13:34', 34, 'cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (6, 5, 7, 2, 47, '2021-12-15 13:25:48', 59, 'ready');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (7, 6, 13, 3, 80, '2022-10-24 20:55:29', 19, 'cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (8, 7, 8, 2, 36, '2022-02-19 00:42:07', 56, 'pending');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (9, 1, 7, 2, 9, '2022-01-02 05:15:00', 6, 'done');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (10, 9, 1, 1, 1, '2021-12-18 07:02:08', 11, 'cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (11, 8, 13, 3, 66, '2022-06-01 21:12:42', 7, 'cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (12, 1, 2, 1, 47, '2022-10-06 19:51:40', 41, 'cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (13, 10, 3, 2, 10, '2022-01-10 13:26:24', 54, 'done');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (14, 1, 3, 2, 82, '2022-01-27 07:44:30', 25, 'pending');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (15, 2, 1, 1, 29, '2022-04-26 00:57:48', 26, 'cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (16, 3, 2, 1, 30, '2022-03-07 15:42:45', 58, 'pending');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (17, 4, 1, 1, 39, '2022-01-29 02:16:42', 12, 'cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (18, 5, 11, 3, 19, '2022-01-15 10:15:33', 53, 'cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (19, 6, 14, 3, 45, '2022-07-27 23:02:54', 20, 'cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (20, 7, 8, 2, 73, '2022-09-16 17:19:51', 52, 'pending');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (21, 4, 4, 1, 43, '2022-07-27 21:36:17', 57, 'done');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (22, 2, 14, 3, 68, '2021-12-20 07:32:03', 56, 'pending');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (23, 3, 3, 1, 48, '2022-02-26 16:20:14', 37, 'cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (24, 7, 12, 3, 35, '2022-01-02 01:08:17', 13, 'ready');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (25, 9, 1, 1, 28, '2022-06-27 14:13:52', 33, 'ready');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (26, 10, 9, 2, 63, '2022-08-01 01:05:43', 22, 'cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (27, 8, 11, 2, 68, '2022-07-05 14:03:19', 41, 'ready');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (28, 4, 13, 3, 64, '2022-11-17 01:32:43', 56, 'cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (29, 3, 8, 2, 66, '2022-11-03 23:22:07', 16, 'cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, PredictedTotalPrepTime, OrderStatus) VALUES (30, 1, 12, 3, 60, '2022-07-07 16:39:35', 51, 'cancelled');

-- ORDER DISHES -------------------------------------------------------------------------------
INSERT INTO OrderDish (OrderId, MenuId) VALUES (1, 14);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (1, 12);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (1, 13);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (2, 4);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (2, 5);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (2, 1);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (3, 9);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (3, 6);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (4, 6);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (4, 10);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (5, 12);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (5, 14);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (6, 7);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (6, 8);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (7, 13);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (7, 14);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (8, 8);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (8, 9);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (9, 6);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (9, 7);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (10, 1);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (10, 5);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (11, 15);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (11, 13);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (12, 4);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (12, 2);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (13, 1);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (13, 3);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (14, 4);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (15, 1);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (16, 2);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (16, 3);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (17, 1);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (18, 11);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (18, 12);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (19, 14);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (20, 8);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (21, 3);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (21, 4);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (22, 12);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (22, 14);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (23, 3);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (24, 12);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (25, 1);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (26, 9);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (27, 11);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (28, 13);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (29, 8);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (30, 12);

-- ORDER DRINK -------------------------------------------------------------------------------
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (1, 1);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (2, 5);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (4, 3);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (5, 1);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (7, 2);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (10, 4);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (12, 3);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (14, 5);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (17, 2);
