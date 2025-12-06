-- SELECT. 


-- 1. Mostrar todos los campos de la tabla Person.Person.
SELECT * FROM Person.Person;

-- 2. Seleccionar los nombres y apellidos de la tabla Person.Person.
SELECT FirstName, LastName FROM Person.Person;

-- 3. Mostrar el nombre del producto y su precio de la tabla Production.Product.
SELECT Name, ListPrice FROM Production.Product;

-- 4. Obtener el número de orden y la fecha de pedido de Sales.SalesOrderHeader.
SELECT SalesOrderNumber, OrderDate FROM Sales.SalesOrderHeader;

-- 5. Listar los nombres y correos electrónicos de los empleados.
SELECT p.FirstName, p.LastName, e.EmailAddress
FROM HumanResources.Employee AS h
JOIN Person.Person AS p ON h.BusinessEntityID = p.BusinessEntityID
JOIN Person.EmailAddress AS e ON p.BusinessEntityID = e.BusinessEntityID;

-- 6. Mostrar el nombre y modelo de los productos.
SELECT Name, ProductModelID FROM Production.Product;

-- 7. Ciudades y estados de los clientes.
SELECT City, StateProvinceID FROM Person.Address;

-- 8. Listar transacciones con cantidad y fecha.
SELECT ProductID, Quantity, TransactionDate
FROM Production.TransactionHistory;

-- 9. Detalles de contacto de proveedores.
SELECT VendorID, Name, CreditRating, PurchasingWebServiceURL
FROM Purchasing.Vendor;

-- 10. ID y nombre de departamentos.
SELECT DepartmentID, Name FROM HumanResources.Department;


-- WHERE.

-- 1. Productos con precio > 100
SELECT Name, ListPrice
FROM Production.Product
WHERE ListPrice > 100;

-- 2. Empleados del departamento de ventas
SELECT * FROM HumanResources.EmployeeDepartmentHistory
WHERE DepartmentID = (
    SELECT DepartmentID FROM HumanResources.Department
    WHERE Name = 'Sales'
);

-- 3. Órdenes después del 1/1/2022
SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate > '2022-01-01';

-- 4. Clientes que viven en "Seattle"
SELECT * FROM Person.Address
WHERE City = 'Seattle';

-- 5. Productos que contienen "Mountain"
SELECT * FROM Production.Product
WHERE Name LIKE '%Mountain%';

-- 6. Transacciones con cantidad > 500
SELECT * FROM Production.TransactionHistory
WHERE Quantity > 500;

-- 7. Empleados contratados en 2020
SELECT * FROM HumanResources.Employee
WHERE YEAR(HireDate) = 2020;

-- 8. Órdenes con subtotal > 1000
SELECT * FROM Sales.SalesOrderHeader
WHERE SubTotal > 1000;

-- 9. Proveedores con calificación mayor a 3
SELECT * FROM Purchasing.Vendor
WHERE CreditRating > 3;

-- 10. Productos sin precio asignado
SELECT * FROM Production.Product
WHERE ListPrice IS NULL OR ListPrice = 0;


-- GROUP BY.

-- 1. Total de productos por categoría
SELECT ProductSubcategoryID, COUNT(*) AS TotalProductos
FROM Production.Product
GROUP BY ProductSubcategoryID;

-- 2. Total de ventas por año
SELECT YEAR(OrderDate) AS Año, SUM(TotalDue) AS TotalVentas
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate);

-- 3. Empleados por departamento
SELECT DepartmentID, COUNT(*) AS TotalEmpleados
FROM HumanResources.EmployeeDepartmentHistory
GROUP BY DepartmentID;

-- 4. Precio promedio por categoría
SELECT ProductSubcategoryID, AVG(ListPrice) AS PrecioPromedio
FROM Production.Product
GROUP BY ProductSubcategoryID;

-- 5. Total de transacciones por producto
SELECT ProductID, COUNT(*) AS TotalTransacciones
FROM Production.TransactionHistory
GROUP BY ProductID;

-- 6. Promedio de subtotal por estado
SELECT ShipToAddressID, AVG(SubTotal) AS SubtotalPromedio
FROM Sales.SalesOrderHeader
GROUP BY ShipToAddressID;

-- 7. Cantidad de clientes por ciudad
SELECT City, COUNT(*) AS TotalClientes
FROM Person.Address
GROUP BY City;

-- 8. Total de empleados por título de trabajo
SELECT JobTitle, COUNT(*) AS TotalEmpleados
FROM HumanResources.Employee
GROUP BY JobTitle;

-- 9. Proveedores por país
SELECT CountryRegionCode, COUNT(*) AS TotalProveedores
FROM Purchasing.Vendor
GROUP BY CountryRegionCode;

-- 10. Ventas por mes
SELECT YEAR(OrderDate) AS Año, MONTH(OrderDate) AS Mes, SUM(TotalDue) AS TotalVentas
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate);

-- 11. Precio máximo y mínimo por categoría
SELECT ProductSubcategoryID, MAX(ListPrice) AS MaxPrecio, MIN(ListPrice) AS MinPrecio
FROM Production.Product
GROUP BY ProductSubcategoryID;

-- 12. Total de órdenes por cliente
SELECT CustomerID, COUNT(*) AS TotalOrdenes
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;

-- 13. Precio promedio por modelo
SELECT ProductModelID, AVG(ListPrice) AS Promedio
FROM Production.Product
GROUP BY ProductModelID;

-- 14. Cantidad de direcciones por tipo
SELECT AddressTypeID, COUNT(*) AS TotalDirecciones
FROM Person.AddressType
GROUP BY AddressTypeID;

-- 15. Total de ventas por producto y año
SELECT ProductID, YEAR(TransactionDate) AS Año, SUM(Quantity) AS TotalVentas
FROM Production.TransactionHistory
GROUP BY ProductID, YEAR(TransactionDate);


-- HAVING.

-- 1. Categorías con más de 10 productos
SELECT ProductSubcategoryID, COUNT(*) AS Total
FROM Production.Product
GROUP BY ProductSubcategoryID
HAVING COUNT(*) > 10;

-- 2. Años con ventas mayores a 1,000,000
SELECT YEAR(OrderDate) AS Año, SUM(TotalDue) AS TotalVentas
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
HAVING SUM(TotalDue) > 1000000;

-- 3. Departamentos con más de 5 empleados
SELECT DepartmentID, COUNT(*) AS Total
FROM HumanResources.EmployeeDepartmentHistory
GROUP BY DepartmentID
HAVING COUNT(*) > 5;

-- 4. Categorías con precio promedio > 500
SELECT ProductSubcategoryID, AVG(ListPrice) AS Promedio
FROM Production.Product
GROUP BY ProductSubcategoryID
HAVING AVG(ListPrice) > 500;

-- 5. Ciudades con más de 20 clientes
SELECT City, COUNT(*) AS Total
FROM Person.Address
GROUP BY City
HAVING COUNT(*) > 20;

-- 6. Títulos de trabajo con ≥ 3 empleados
SELECT JobTitle, COUNT(*) AS Total
FROM HumanResources.Employee
GROUP BY JobTitle
HAVING COUNT(*) >= 3;

-- 7. Países con más de 5 proveedores
SELECT CountryRegionCode, COUNT(*) AS Total
FROM Purchasing.Vendor
GROUP BY CountryRegionCode
HAVING COUNT(*) > 5;

-- 8. Meses con ventas mayores a 500,000
SELECT YEAR(OrderDate) AS Año, MONTH(OrderDate) AS Mes, SUM(TotalDue) AS Total
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
HAVING SUM(TotalDue) > 500000;

-- 9. Productos con más de 50 transacciones
SELECT ProductID, COUNT(*) AS Total
FROM Production.TransactionHistory
GROUP BY ProductID
HAVING COUNT(*) > 50;

-- 10. Estados con subtotal promedio > 2000
SELECT ShipToAddressID, AVG(SubTotal) AS Promedio
FROM Sales.SalesOrderHeader
GROUP BY ShipToAddressID
HAVING AVG(SubTotal) > 2000;

-- 11. Categorías con precio mínimo > 100
SELECT ProductSubcategoryID, MIN(ListPrice) AS MinPrecio
FROM Production.Product
GROUP BY ProductSubcategoryID
HAVING MIN(ListPrice) > 100;

-- 12. Modelos con precio promedio > 1,000
SELECT ProductModelID, AVG(ListPrice) AS Promedio
FROM Production.Product
GROUP BY ProductModelID
HAVING AVG(ListPrice) > 1000;

-- 13. Clientes con +10 órdenes
SELECT CustomerID, COUNT(*) AS Total
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(*) > 10;

-- 14. Años con más de 100,000 transacciones
SELECT YEAR(TransactionDate) AS Año, COUNT(*) AS Total
FROM Production.TransactionHistory
GROUP BY YEAR(TransactionDate)
HAVING COUNT(*) > 100000;

-- 15. Direcciones repetidas más de 5 veces
SELECT AddressID, COUNT(*) AS Veces
FROM Person.Address
GROUP BY AddressID
HAVING COUNT(*) > 5;
