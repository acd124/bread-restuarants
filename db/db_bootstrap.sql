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
	PRIMARY KEY (MenuId)
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
	OrderId INT NOT NULL,
	CustomerId INT NOT NULL,
	EmployeeId INT NOT NULL,
	RestaurantId INT NOT NULL,
	TotalPrice INT NOT NULL,
	TimePlaced DATE NOT NULL,
	PredictedTotalPrepTime INT NOT NULL,
	OrderStatus ENUM('cooking', 'ready', 'pending', 'done') NOT NULL,
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
CREATE TABLE RestaurantDish (
	RestaurantId INT NOT NULL,
	MenuId INT NOT NULL,
	CONSTRAINT PK_RestDish PRIMARY KEY (RestaurantId,MenuId),
	FOREIGN KEY (RestaurantId) REFERENCES Restaurant(RestaurantId),
	FOREIGN KEY (MenuId) REFERENCES Dish(MenuId)
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
INSERT INTO Restaurant (RestaurantId, Name, PhoneNumber, Email, State, City, Address, PostalCode, OwnerFirstName, OwnerLastName, OwnerPhoneNumber, OwnerEmail, Rent) VALUES (1, 'Greenholt, Ward and Schimmel', '704-329-5723', 'tpughe0@pbs.org', 'North Carolina', 'Charlotte', '3592 Blackbird Terrace', '28278', 'Terrye', 'Pughe', '757-937-5573', 'tpughe0@digg.com', 2157.89);
INSERT INTO Restaurant (RestaurantId, Name, PhoneNumber, Email, State, City, Address, PostalCode, OwnerFirstName, OwnerLastName, OwnerPhoneNumber, OwnerEmail, Rent) VALUES (2, 'Shields and Sons', '864-263-2948', 'nhalling1@nhs.uk', 'South Carolina', 'Anderson', '0925 Sherman Park', '29625', 'Norry', 'Halling', '718-724-2768', 'nhalling1@posterous.com', 2075.66);
INSERT INTO Restaurant (RestaurantId, Name, PhoneNumber, Email, State, City, Address, PostalCode, OwnerFirstName, OwnerLastName, OwnerPhoneNumber, OwnerEmail, Rent) VALUES (3, 'Okuneva Inc', '570-512-2166', 'cbartlet2@twitpic.com', 'Pennsylvania', 'Scranton', '195 Red Cloud Junction', '18514', 'Care', 'Bartlet', '503-356-9604', 'cbartlet2@printfriendly.com', 3487.77);
INSERT INTO Restaurant (RestaurantId, Name, PhoneNumber, Email, State, City, Address, PostalCode, OwnerFirstName, OwnerLastName, OwnerPhoneNumber, OwnerEmail, Rent) VALUES (4, 'Pouros, Bednar and Kreiger', '646-303-5054', 'mcaskey3@twitpic.com', 'New York', 'New York City', '63296 Sullivan Court', '10019', 'Moss', 'Caskey', '323-325-1945', 'mcaskey3@patch.com', 4689.56);
INSERT INTO Restaurant (RestaurantId, Name, PhoneNumber, Email, State, City, Address, PostalCode, OwnerFirstName, OwnerLastName, OwnerPhoneNumber, OwnerEmail, Rent) VALUES (5, 'Huel-Stiedemann', '315-891-7395', 'gbaudouin4@berkeley.edu', 'New York', 'Syracuse', '0939 Pennsylvania Drive', '13210', 'Gilli', 'Baudouin', '813-928-8155', 'gbaudouin4@canalblog.com', 4104.63);
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (1, 'Lynch-Gerlach', 'bfoulds0@dmoz.org', '523-259-1049');
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (2, 'Trantow, Ryan and Price', 'pallitt1@hp.com', '313-963-5206');
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (3, 'Hegmann-Price', 'bleitch2@craigslist.org', '112-314-3783');
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (4, 'Hegmann, Kilback and Mills', 'mlamkin3@fastcompany.com', '398-442-9822');
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (5, 'Fisher, Kautzer and Haag', 'gmacmenamy4@reference.com', '327-132-9546');
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (6, 'Padberg-Kessler', 'dtripe5@histats.com', '456-413-7689');
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (7, 'Pacocha-Vandervort', 'awithams6@flavors.me', '567-788-7226');
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (8, 'Dibbert-Mayert', 'fchecchetelli7@xinhuanet.com', '287-458-7029');
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (9, 'Schowalter, Keeling and Cummerata', 'khearley8@mac.com', '137-606-7270');
INSERT INTO Supplier (SupplierId, Name, email, PhoneNumber) VALUES (10, 'Blanda-Yundt', 'jlamberto9@virginia.edu', '450-557-6542');
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (1, 'onion', 9, 23.05, '2021-11-24', 204, '2023-09-04', 7, 2);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (2, 'pepper', 1, 11.87, '2022-03-26', 139, '2023-11-01', 8, 2);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (3, 'mushroom', 68, 28.16, '2021-12-29', 100, '2023-03-04', 7, 1);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (4, 'chicken', 9, 25.9, '2022-08-25', 334, '2023-07-20', 6, 5);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (5, 'garlic', 71, 17.11, '2022-02-17', 252, '2022-12-19', 8, 1);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (6, 'potato', 57, 21.82, '2022-07-02', 207, '2023-11-10', 2, 3);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (7, 'garlic', 88, 16.29, '2022-08-02', 147, '2022-12-22', 8, 2);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (8, 'pepper', 46, 29.89, '2022-06-23', 173, '2023-11-09', 9, 1);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (9, 'carrot', 26, 2.56, '2022-01-30', 159, '2023-01-03', 1, 3);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (10, 'potato', 77, 27.46, '2022-11-04', 48, '2023-08-08', 6, 2);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (11, 'pepper', 89, 21.64, '2022-10-15', 123, '2023-01-15', 9, 3);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (12, 'garlic', 74, 9.32, '2022-05-09', 298, '2023-02-22', 7, 4);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (13, 'garlic', 61, 4.06, '2022-09-18', 333, '2023-05-09', 8, 3);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (14, 'cabbage', 51, 4.06, '2022-07-03', 215, '2023-09-29', 4, 5);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (15, 'pepper', 91, 9.84, '2022-06-20', 206, '2023-11-17', 2, 4);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (16, 'pepper', 34, 8.1, '2022-07-12', 281, '2023-04-21', 5, 5);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (17, 'garlic', 95, 7.9, '2022-08-13', 88, '2023-11-07', 2, 5);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (18, 'cabbage', 63, 8.4, '2022-03-02', 201, '2023-02-18', 9, 1);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (19, 'onion', 63, 21.51, '2022-08-27', 38, '2023-07-19', 5, 4);
INSERT INTO Ingredient (IngredientId, Name, Quantity, UnitPrice, OrderDate, ShelfLife, ExpirationDate, SupplierId, RestaurantId) VALUES (20, 'onion', 55, 1.39, '2022-06-25', 95, '2023-09-11', 10, 3);
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (1, 'customer loyalty', 8, 'frame', 14, 3, 126, 'et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (2, 'application', 44, 'Assimilated', 20, 2, 2, 'sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (3, 'next generation', 48, 'application', 29, 3, 280, 'ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (4, 'Focused', 26, 'Triple-buffered', 30, 2, 232, 'nulla tellus in sagittis dui vel nisl duis ac nibh fusce');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (5, 'encoding', 21, 'local', 29, 1, 341, 'vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (6, 'Enterprise-wide', 44, 'Face to face', 4, 1, 178, 'curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (7, 'User-centric', 20, 'zero tolerance', 30, 2, 282, 'lectus vestibulum quam sapien varius ut blandit non interdum in');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (8, 'Re-contextualized', 41, 'support', 8, 2, 159, 'sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (9, 'multi-tasking', 24, 'workforce', 18, 2, 51, 'odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (10, 'benchmark', 48, 'Persistent', 30, 3, 163, 'ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (11, 'Reverse-engineered', 22, 'time-frame', 30, 2, 55, 'ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (12, 'Organic', 13, 'Secured', 9, 3, 158, 'quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (13, 'transitional', 9, 'Re-engineered', 11, 1, 294, 'erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (14, 'Cross-platform', 14, 'definition', 18, 3, 379, 'sit amet sem fusce consequat nulla nisl nunc nisl duis');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (15, 'parallelism', 42, 'Innovative', 2, 2, 373, 'erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (16, 'reciprocal', 27, 'system-worthy', 2, 2, 218, 'dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (17, 'foreground', 18, 'modular', 6, 2, 273, 'felis donec semper sapien a libero nam dui proin leo odio porttitor');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (18, 'productivity', 3, 'emulation', 19, 1, 422, 'malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (19, 'pricing structure', 28, 'dynamic', 7, 1, 480, 'id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla');
INSERT INTO Dish (MenuId, Name, Price, Cuisine, PreparationTime, ServingSize, Calories, DescriptionText) VALUES (20, 'analyzing', 46, 'frame', 18, 2, 375, 'dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae');
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (1, 'attitude-oriented', 89, 'migration', "lorem ipsum dolor", false);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (2, 'exuding', 57, 'contingency', "lorem ipsum dolor", true);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (3, 'Persistent', 49, 'installation', "lorem ipsum dolor", true);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (4, 'Right-sized', 54, 'emulation', "lorem ipsum dolor", true);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (5, 'challenge', 82, 'utilisation', "lorem ipsum dolor", false);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (6, 'orchestration', 21, 'demand-driven', "lorem ipsum dolor", true);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (7, 'Centralized', 30, 'Graphic Interface', "lorem ipsum dolor", true);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (8, 'clear-thinking', 1, 'neutral', "lorem ipsum dolor", false);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (9, 'Realigned', 36, 'help-desk', "lorem ipsum dolor", false);
INSERT INTO Beverage (DrinkId, Name, Price, Region, Dscription, Alcoholic) VALUES (10, 'Total', 34, 'foreground', "lorem ipsum dolor", true);
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
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (11, 'Shaine', 'Smallsman', '1993-10-12', 59, 'ssmallsmana@gmpg.org', '214-268-6062');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (12, 'Tally', 'Albutt', '2016-05-16', 54, 'talbuttb@thetimes.co.uk', '898-147-7489');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (13, 'George', 'Swannell', '1953-01-19', 58, 'gswannellc@unc.edu', '450-961-0289');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (14, 'Maura', 'Luno', '1955-03-20', 33, 'mlunod@gov.uk', '407-812-8954');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (15, 'Mata', 'Rizzardo', '1997-06-11', 3, 'mrizzardoe@columbia.edu', '494-990-9295');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (16, 'Orv', 'Potebury', '1954-04-16', 43, 'opoteburyf@flavors.me', '552-554-2726');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (17, 'Ella', 'Romayne', '2021-10-09', 63, 'eromayneg@livejournal.com', '953-827-2346');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (18, 'Becka', 'Leap', '2020-03-08', 81, 'bleaph@ox.ac.uk', '717-271-7231');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (19, 'Gabriellia', 'Scowen', '1963-10-20', 29, 'gscoweni@cisco.com', '918-332-8515');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (20, 'Michel', 'Pudsey', '1974-09-03', 43, 'mpudseyj@stumbleupon.com', '449-793-5102');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (21, 'Goldina', 'Genney', '2013-07-05', 92, 'ggenneyk@deliciousdays.com', '365-685-6279');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (22, 'Corrinne', 'Lere', '1977-12-05', 38, 'clerel@pcworld.com', '285-561-8168');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (23, 'Lianna', 'Stood', '1993-11-13', 49, 'lstoodm@multiply.com', '416-610-6001');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (24, 'Betsy', 'Klimushev', '1991-08-22', 91, 'bklimushevn@opera.com', '415-677-2783');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (25, 'Esmeralda', 'McCurdy', '1954-09-15', 24, 'emccurdyo@nbcnews.com', '673-984-7345');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (26, 'Charleen', 'Bale', '1961-10-24', 40, 'cbalep@eepurl.com', '499-178-7600');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (27, 'Napoleon', 'Poge', '1979-08-01', 52, 'npogeq@etsy.com', '714-842-4270');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (28, 'Shayne', 'Ygoe', '1970-12-08', 90, 'sygoer@bloglovin.com', '772-955-0079');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (29, 'Eden', 'Murrey', '2002-10-02', 37, 'emurreys@irs.gov', '386-850-9876');
INSERT INTO Customer (CustomerId, FirstName, LastName, DateOfBirth, Age, Email, PhoneNumber) VALUES (30, 'Alwyn', 'Gabbatiss', '1997-10-24', 80, 'agabbatisst@answers.com', '139-224-1040');
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (1, 'Debby', 'Courtier', '1997-05-16', 71, '1997-10-14', NULL, true, 'dcourtier0@alibaba.com', '646-177-7460', 27, 5);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (2, 'Georgeanne', 'Lowseley', '1980-11-16', 76, '1994-06-08', NULL, true, 'glowseley1@typepad.com', '202-264-7482', 29, 4);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (3, 'Alameda', 'Branchett', '2009-11-28', 50, '1956-09-04', '2001-01-13', false, 'abranchett2@tinyurl.com', '846-964-0997', 30, 1);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (4, 'My', 'Cathrae', '1971-05-20', 70, '1999-09-27', NULL, true, 'mcathrae3@oakley.com', '315-123-9381', 21, 2);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (5, 'Augustine', 'Beadle', '1979-09-17', 79, '2014-12-06', '2001-01-13', false, 'abeadle4@163.com', '269-821-9508', 24, 5);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (6, 'Pauline', 'Hazelton', '2014-01-19', 65, '1972-02-19', NULL, true, 'phazelton5@bbc.co.uk', '842-842-6785', 15, 3);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (7, 'Jilly', 'Noell', '1981-05-17', 78, '1976-02-17', '2001-01-13', false, 'jnoell6@weather.com', '205-841-8208', 20, 3);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (8, 'Byram', 'MacIlory', '2015-11-05', 70, '2000-12-12', '2001-01-13', false, 'bmacilory7@phpbb.com', '992-887-3255', 19, 5);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (9, 'Noemi', 'Libermore', '2007-04-26', 32, '1970-01-29', NULL, true, 'nlibermore8@goo.ne.jp', '621-228-0589', 21, 1);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (10, 'Amandie', 'Yuryatin', '2012-10-20', 79, '1970-11-12', '2001-01-13', false, 'ayuryatin9@baidu.com', '638-383-4754', 23, 4);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (11, 'Eugenio', 'McKeachie', '2017-02-07', 16, '1993-07-25', NULL, true, 'emckeachiea@flavors.me', '274-742-2142', 27, 2);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (12, 'Ker', 'Anelay', '1978-01-19', 32, '1950-12-10', NULL, true, 'kanelayb@google.de', '818-620-3166', 25, 1);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (13, 'Ian', 'Waterstone', '1954-11-15', 28, '1993-02-08', NULL, true, 'iwaterstonec@devhub.com', '993-594-1536', 23, 3);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (14, 'Sly', 'Splaven', '1965-01-31', 11, '1953-03-30', NULL, true, 'ssplavend@springer.com', '945-631-5219', 21, 2);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (15, 'Vivyan', 'Flockhart', '2021-12-18', 37, '1978-07-28', '2001-01-13', false, 'vflockharte@vistaprint.com', '584-536-9883', 26, 1);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (16, 'Rudiger', 'Drohan', '1965-11-16', 30, '1976-03-05', NULL, true, 'rdrohanf@spiegel.de', '891-703-7819', 23, 5);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (17, 'Thacher', 'Blenkinsop', '2012-09-17', 73, '1953-03-28', NULL, true, 'tblenkinsopg@latimes.com', '972-336-3932', 30, 3);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (18, 'Sherm', 'Smallman', '2019-01-17', 1, '1964-07-19', NULL, true, 'ssmallmanh@globo.com', '757-283-9161', 18, 2);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (19, 'Vita', 'Ciccotto', '1965-06-11', 5, '1993-12-01', NULL, true, 'vciccottoi@bandcamp.com', '675-832-8498', 15, 3);
INSERT INTO Employee (EmployeeId, FirstName, LastName, DateOfBirth, Age, JoinDate, ExitDate, CurrentEmployee, Email, PhoneNumber, Wage, Restaurant) VALUES (20, 'Jdavie', 'Axtonne', '1982-03-04', 47, '2017-01-11', '2001-01-13', false, 'jaxtonnej@adobe.com', '548-484-3741', 28, 1);
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (1, 'chef');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (2, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (3, 'chef');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (4, 'host');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (5, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (6, 'manager');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (7, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (8, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (9, 'chef');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (10, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (11, 'manager');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (12, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (13, 'chef');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (14, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (15, 'manager');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (16, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (17, 'host');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (18, 'server');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (19, 'chef');
INSERT INTO EmployeeRole (EmployeeId, title) VALUES (20, 'server');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (1, 9, 17, 3, 51, '2022-09-05 08:26:20', 34, 'Ready');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (2, 21, 6, 1, 76, '2022-04-06 09:11:42', 21, 'Cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (3, 28, 18, 2, 19, '2022-03-26 15:09:13', 23, 'Cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (4, 23, 6, 2, 79, '2022-08-31 11:01:35', 13, 'Cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (5, 5, 12, 3, 71, '2022-05-01 15:13:34', 34, 'Cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (6, 7, 14, 5, 47, '2021-12-15 13:25:48', 59, 'Ready');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (7, 4, 5, 3, 80, '2022-10-24 20:55:29', 19, 'Cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (8, 11, 11, 2, 36, '2022-02-19 00:42:07', 56, 'Pending');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (9, 6, 7, 2, 9, '2022-01-02 05:15:00', 6, 'Done');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (10, 3, 5, 5, 1, '2021-12-18 07:02:08', 11, 'Cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (11, 3, 19, 4, 66, '2022-06-01 21:12:42', 7, 'Cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (12, 21, 18, 5, 47, '2022-10-06 19:51:40', 41, 'Cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (13, 7, 8, 2, 10, '2022-01-10 13:26:24', 54, 'Done');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (14, 11, 3, 2, 82, '2022-01-27 07:44:30', 25, 'Pending');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (15, 25, 11, 1, 29, '2022-04-26 00:57:48', 26, 'Cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (16, 7, 12, 1, 30, '2022-03-07 15:42:45', 58, 'Pending');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (17, 12, 11, 1, 39, '2022-01-29 02:16:42', 12, 'Cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (18, 2, 19, 3, 19, '2022-01-15 10:15:33', 53, 'Cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (19, 1, 6, 3, 45, '2022-07-27 23:02:54', 20, 'Cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (20, 10, 12, 5, 73, '2022-09-16 17:19:51', 52, 'Pending');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (21, 17, 6, 1, 43, '2022-07-27 21:36:17', 57, 'Done');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (22, 5, 17, 5, 68, '2021-12-20 07:32:03', 56, 'Pending');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (23, 30, 12, 1, 48, '2022-02-26 16:20:14', 37, 'Cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (24, 23, 8, 3, 35, '2022-01-02 01:08:17', 13, 'Ready');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (25, 3, 10, 1, 28, '2022-06-27 14:13:52', 33, 'Ready');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (26, 30, 2, 2, 63, '2022-08-01 01:05:43', 22, 'Cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (27, 7, 10, 2, 68, '2022-07-05 14:03:19', 41, 'Ready');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (28, 28, 15, 5, 64, '2022-11-17 01:32:43', 56, 'Cancelled');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (29, 5, 8, 5, 66, '2022-11-03 23:22:07', 16, 'Cooking');
INSERT INTO Orders (OrderId, CustomerId, EmployeeId, RestaurantId, TotalPrice, TimePlaced, TotalPreparationTime, OrderStatus) VALUES (30, 13, 2, 3, 60, '2022-07-07 16:39:35', 51, 'Cancelled');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (2, 'asynchronous');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (16, 'responsive');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (10, 'leading edge');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (21, 'value-added');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (3, 'methodical');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (30, 'data-warehouse');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (3, 'Horizontal');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (25, 'info-mediaries');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (9, 'value-added');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (21, 'extranet');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (6, 'Inverse');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (25, 'Compatible');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (19, 'Re-contextualized');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (30, '24/7');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (12, 'Devolved');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (14, 'system-worthy');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (9, 'complexity');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (12, 'application');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (6, 'explicit');
INSERT INTO Allergy (CustomerId, Allergy) VALUES (17, 'actuating');
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (1, 1);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (2, 14);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (11, 17);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (12, 17);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (5, 3);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (15, 8);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (3, 9);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (4, 10);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (3, 11);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (11, 18);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (8, 20);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (7, 20);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (6, 6);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (11, 4);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (3, 13);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (15, 20);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (2, 17);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (4, 4);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (6, 2);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (3, 16);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (16, 12);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (2, 12);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (17, 19);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (7, 1);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (4, 5);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (13, 13);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (10, 3);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (18, 12);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (7, 2);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (14, 4);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (6, 4);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (9, 13);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (12, 15);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (18, 8);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (13, 10);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (19, 5);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (11, 9);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (10, 4);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (2, 11);
INSERT INTO DishIngredient (MenuId, IngredientId) VALUES (20, 6);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (3, 4);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (5, 7);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (2, 9);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (2, 15);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (5, 8);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (1, 11);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (5, 16);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (3, 1);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (3, 18);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (2, 13);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (1, 19);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (1, 10);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (5, 9);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (1, 20);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (2, 2);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (1, 9);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (4, 12);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (2, 20);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (1, 8);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (2, 6);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (4, 19);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (3, 2);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (5, 18);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (5, 14);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (2, 12);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (2, 17);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (3, 7);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (3, 3);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (4, 5);
INSERT INTO RestaurantDish (RestaurantId, MenuId) VALUES (1, 2);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (4, 1);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (2, 4);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (3, 6);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (2, 5);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (3, 2);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (5, 6);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (3, 5);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (1, 8);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (4, 2);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (4, 10);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (2, 6);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (2, 8);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (3, 3);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (5, 7);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (2, 7);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (2, 9);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (5, 9);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (5, 1);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (2, 3);
INSERT INTO RestaurantBeverage (RestaurantId, DrinkId) VALUES (1, 3);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (1, 7);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (2, 3);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (4, 3);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (5, 3);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (7, 5);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (6, 12);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (9, 19);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (3, 7);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (10, 15);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (8, 9);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (12, 12);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (11, 2);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (13, 1);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (15, 5);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (17, 13);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (18, 17);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (16, 7);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (20, 6);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (19, 13);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (14, 19);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (24, 15);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (21, 13);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (22, 11);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (23, 3);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (25, 17);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (30, 4);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (28, 15);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (27, 17);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (26, 9);
INSERT INTO OrderDish (OrderId, MenuId) VALUES (29, 12);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (9, 1);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (28, 10);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (25, 9);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (5, 4);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (24, 1);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (20, 3);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (17, 1);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (20, 8);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (17, 6);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (24, 4);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (24, 5);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (12, 9);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (21, 4);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (7, 7);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (2, 3);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (21, 9);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (15, 4);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (29, 10);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (27, 2);
INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES (4, 1);
