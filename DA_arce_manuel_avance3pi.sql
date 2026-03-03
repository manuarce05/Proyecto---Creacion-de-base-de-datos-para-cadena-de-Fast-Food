-- iniciamos creando la carpeta en C para luego crear la Base de Datos
CREATE DATABASE FastFoodDB
ON 
PRIMARY (
    NAME = FastFoodDB_Data,
    FILENAME = 'C:\FastFood\FastFoodDB_Data.mdf',
    SIZE = 50MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 10MB
)
LOG ON (
    NAME = FastFoodDB_Log,
    FILENAME = 'C:\FastFood\FastFoodDB_Log.ldf',
    SIZE = 20MB,
    MAXSIZE = 200MB,
    FILEGROWTH = 5MB
);

USE FastFoodDB
;

-- 1. Categorías de productos
CREATE TABLE Categorias (
    CategoriaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL
);

-- 2. Productos
CREATE TABLE Productos (
    ProductoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    CategoriaID INT NOT NULL,
    FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
);

-- 3. Orígenes de órdenes
CREATE TABLE Origenes (
    OrigenID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL
    );

    -- 4. Tipos de pago
CREATE TABLE TiposPago (
    TipoPagoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL
);

-- 5. Departamentos
CREATE TABLE Departamentos (
    DepartamentoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL
);
INSERT INTO Departamentos (Nombre) VALUES
('Administración'), ('Ventas'), ('Cocina'), ('Logística'), 
('Servicio'), ('Mantenimiento'), ('Restaurante');

-- 6. Sucursales
CREATE TABLE Sucursales (
    SucursalID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(150),
    Ciudad VARCHAR(100)
);

-- 7. Empleados
CREATE TABLE Empleados (
    EmpleadoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100),
    Puesto VARCHAR(50),
    Rol VARCHAR(50),
    DepartamentoID INT NOT NULL,
    SucursalID INT NOT NULL,
    FOREIGN KEY (DepartamentoID) REFERENCES Departamentos(DepartamentoID),
    FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID)
);

-- 8. Mensajeros
CREATE TABLE Mensajeros (
    MensajeroID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Tipo VARCHAR(20) NOT NULL CHECK (Tipo IN ('interno', 'externo')),
    EmpleadoID INT NULL, -- Solo si es interno
    FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID)
);

-- 9. Clientes
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100),
    Email VARCHAR(100),
    Telefono VARCHAR(20),
    Direccion VARCHAR(200)
);

-- 10. Órdenes
CREATE TABLE Ordenes (
    OrdenID INT PRIMARY KEY IDENTITY(1,1),
    ClienteID INT NOT NULL,
    VendedorID INT NOT NULL,           -- Empleado
    MensajeroID INT NULL,              -- Puede ser NULL si es para consumir en local
    SucursalID INT NOT NULL,
    OrigenID INT NOT NULL,
    TipoPagoID INT NOT NULL,
    HorarioVenta VARCHAR(20) CHECK (HorarioVenta IN ('mañana', 'tarde', 'noche')),
    TotalCompra DECIMAL(10,2) NOT NULL,
    KilometrosRecorrer DECIMAL(5,2) NULL,
    FechaDespacho DATETIME NULL,
    FechaEntrega DATETIME NULL,
    FechaOrdenTomada DATETIME NULL,
    FechaOrdenLista DATETIME NULL,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
    FOREIGN KEY (VendedorID) REFERENCES Empleados(EmpleadoID),
    FOREIGN KEY (MensajeroID) REFERENCES Mensajeros(MensajeroID),
    FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID),
    FOREIGN KEY (OrigenID) REFERENCES Origenes(OrigenID),
    FOREIGN KEY (TipoPagoID) REFERENCES TiposPago(TipoPagoID)
);

-- 11. Detalle de Orden (Productos comprados en la orden)
CREATE TABLE DetalleOrden (
    DetalleID INT PRIMARY KEY IDENTITY(1,1),
    OrdenID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrdenID) REFERENCES Ordenes(OrdenID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);

-- Insertar datos en Categorias
INSERT INTO Categorias (Nombre) VALUES
('Comida Rápida'), ('Postres'), ('Bebidas'), ('Ensaladas'), ('Desayunos'),
('Cafetería'), ('Helados'), ('Comida Vegana'), ('Carnes'), ('Pizzas');

SELECT * from Categorias

-- Insertar datos en Productos
INSERT INTO Productos (Nombre, CategoriaID, Precio) VALUES
('Hamburguesa Deluxe', 1, 9.99), ('Cheeseburger', 1, 7.99), ('Pizza Margarita', 10, 11.99), ('Pizza Pepperoni', 10, 12.99), ('Helado de Chocolate', 7, 2.99),
('Helado de Vainilla', 7, 2.99), ('Ensalada César', 4, 5.99), ('Ensalada Griega', 4, 6.99), ('Pastel de Zanahoria', 2, 3.99), ('Brownie', 2, 2.99);

SELECT * from Productos

-- Insertar datos en Sucursales
INSERT INTO Sucursales (Nombre, Direccion) VALUES
('Sucursal Central', '1234 Main St'), ('Sucursal Norte', '5678 North St'), ('Sucursal Este', '9101 East St'), ('Sucursal Oeste', '1121 West St'), ('Sucursal Sur', '3141 South St'),
('Sucursal Playa', '1516 Beach St'), ('Sucursal Montaña', '1718 Mountain St'), ('Sucursal Valle', '1920 Valley St'), ('Sucursal Lago', '2122 Lake St'), ('Sucursal Bosque', '2324 Forest St');

-- Insertar datos en Empleados
INSERT INTO Empleados (Nombre, Apellido, Puesto, Rol, DepartamentoID, SucursalID) VALUES
('John', 'Doe', 'Gerente', 'Vendedor', 1, 1),
('Jane', 'Smith', 'Subgerente', 'Vendedor', 2, 1),
('Bill', 'Jones', 'Cajero', 'Vendedor', 2, 1),
('Alice', 'Johnson', 'Cocinero', 'Vendedor', 3, 1),
('Tom', 'Brown', 'Barista', 'Vendedor', 3, 1),
('Emma', 'Davis', 'Repartidor', 'Mensajero', 4, 1),
('Lucas', 'Miller', 'Atención al Cliente', 'Vendedor', 5, 1),
('Olivia', 'García', 'Encargado de Turno', 'Vendedor', 1, 1),
('Ethan', 'Martinez', 'Mesero', 'Vendedor', 7, 1),
('Sophia', 'Rodriguez', 'Auxiliar de Limpieza', 'Vendedor', 6, 1);

SELECT * FROM Empleados

-- Insertar datos en Clientes
INSERT INTO Clientes (Nombre, Direccion) VALUES
('Cliente Uno', '1000 A Street'), ('Cliente Dos', '1001 B Street'), ('Cliente Tres', '1002 C Street'), ('Cliente Cuatro', '1003 D Street'), ('Cliente Cinco', '1004 E Street'),
('Cliente Seis', '1005 F Street'), ('Cliente Siete', '1006 G Street'), ('Cliente Ocho', '1007 H Street'), ('Cliente Nueve', '1008 I Street'), ('Cliente Diez', '1009 J Street');

-- Insertar datos en OrigenesOrden
INSERT INTO Origenes VALUES
('En línea'), ('Presencial'), ('Teléfono'), ('Drive Thru'), ('App Móvil'),
('Redes Sociales'), ('Correo Electrónico'), ('Publicidad'), ('Recomendación'), ('Evento');

SELECT * FROM origenes

-- Insertar datos en Categorias
INSERT INTO Categorias (Nombre) VALUES
('Comida Rápida'), ('Postres'), ('Bebidas'), ('Ensaladas'), ('Desayunos'),
('Cafetería'), ('Helados'), ('Comida Vegana'), ('Carnes'), ('Pizzas');

Select * from Categorias

-- Insertar datos en Productos
INSERT INTO Productos (Nombre, CategoriaID, Precio) VALUES
('Hamburguesa Deluxe', 1, 9.99), ('Cheeseburger', 1, 7.99), ('Pizza Margarita', 10, 11.99), ('Pizza Pepperoni', 10, 12.99), ('Helado de Chocolate', 7, 2.99),
('Helado de Vainilla', 7, 2.99), ('Ensalada César', 4, 5.99), ('Ensalada Griega', 4, 6.99), ('Pastel de Zanahoria', 2, 3.99), ('Brownie', 2, 2.99);

Select * from Productos

-- Insertar datos en Sucursales
INSERT INTO Sucursales (Nombre, Direccion) VALUES
('Sucursal Central', '1234 Main St'), ('Sucursal Norte', '5678 North St'), ('Sucursal Este', '9101 East St'), ('Sucursal Oeste', '1121 West St'), ('Sucursal Sur', '3141 South St'),
('Sucursal Playa', '1516 Beach St'), ('Sucursal Montaña', '1718 Mountain St'), ('Sucursal Valle', '1920 Valley St'), ('Sucursal Lago', '2122 Lake St'), ('Sucursal Bosque', '2324 Forest St');

Select * from Sucursales

-- Insertar datos en Empleados
INSERT INTO Empleados (Nombre, Posicion, Departamento, SucursalID, Rol) VALUES
('John Doe', 'Gerente', 'Administración', 1, 'Vendedor'), ('Jane Smith', 'Subgerente', 'Ventas', 1, 'Vendedor'), ('Bill Jones', 'Cajero', 'Ventas', 1, 'Vendedor'), ('Alice Johnson', 'Cocinero', 'Cocina', 1, 'Vendedor'), ('Tom Brown', 'Barista', 'Cafetería', 1, 'Vendedor'),
('Emma Davis', 'Repartidor', 'Logística', 1, 'Mensajero'), ('Lucas Miller', 'Atención al Cliente', 'Servicio', 1, 'Vendedor'), ('Olivia García', 'Encargado de Turno', 'Administración', 1, 'Vendedor'), ('Ethan Martinez', 'Mesero', 'Restaurante', 1, 'Vendedor'), ('Sophia Rodriguez', 'Auxiliar de Limpieza', 'Mantenimiento', 1, 'Vendedor');

Select * from Empleados

-- Insertar datos en Clientes
INSERT INTO Clientes (Nombre, Direccion) VALUES
('Cliente Uno', '1000 A Street'), ('Cliente Dos', '1001 B Street'), ('Cliente Tres', '1002 C Street'), ('Cliente Cuatro', '1003 D Street'), ('Cliente Cinco', '1004 E Street'),
('Cliente Seis', '1005 F Street'), ('Cliente Siete', '1006 G Street'), ('Cliente Ocho', '1007 H Street'), ('Cliente Nueve', '1008 I Street'), ('Cliente Diez', '1009 J Street');

Select * from Clientes

-- Insertar datos en OrigenesOrden
INSERT INTO OrigenesOrden (Descripcion) VALUES
('En línea'), ('Presencial'), ('Teléfono'), ('Drive Thru'), ('App Móvil'),
('Redes Sociales'), ('Correo Electrónico'), ('Publicidad'), ('Recomendación'), ('Evento');

Select * from OrigenesOrden

-- Insertar datos en TiposPago
INSERT INTO TiposPago VALUES
('Efectivo'), ('Tarjeta de Crédito'), ('Tarjeta de Débito'), ('PayPal'), ('Transferencia Bancaria'),
('Criptomonedas'), ('Cheque'), ('Vale de Comida'), ('Cupón de Descuento'), ('Pago Móvil');

Select * from TiposPago

-- insertamos los datos de los mensajeros
INSERT INTO Mensajeros (Nombre, Tipo) VALUES
('Mensajero Uno', 'interno'),
('Mensajero Dos', 'externo'),
('Mensajero Tres', 'interno'),
('Mensajero Cuatro', 'externo'),
('Mensajero Cinco', 'interno'),
('Mensajero Seis', 'externo'),
('Mensajero Siete', 'interno'),
('Mensajero Ocho', 'externo'),
('Mensajero Nueve', 'interno'),
('Mensajero Diez', 'externo');
;

INSERT INTO Ordenes 
(ClienteID, VendedorID, SucursalID, MensajeroID, TipoPagoID, OrigenID, HorarioVenta, TotalCompra, KilometrosRecorrer, FechaDespacho, FechaEntrega, FechaOrdenTomada, FechaOrdenLista) 
VALUES
(1, 1, 1, 1, 1, 1, 'Mañana', 1053.51, 5.5, '2023-01-10 08:30:00', '2023-01-10 09:00:00', '2023-01-10 08:00:00', '2023-01-10 08:15:00'),
(2, 2, 2, 2, 2, 2, 'Tarde', 1075.00, 10.0, '2023-02-15 14:30:00', '2023-02-15 15:00:00', '2023-02-15 13:30:00', '2023-02-15 14:00:00'),
(3, 3, 3, 3, 3, 3, 'Noche', 920.00, 2.0, '2023-03-20 19:30:00', '2023-03-20 20:00:00', '2023-03-20 19:00:00', '2023-03-20 19:15:00'),
(4, 4, 4, 4, 4, 4, 'Mañana', 930.00, 0.5, '2023-04-25 09:30:00', '2023-04-25 10:00:00', '2023-04-25 09:00:00', '2023-04-25 09:15:00'),
(5, 5, 5, 5, 5, 5, 'Tarde', 955.00, 8.0, '2023-05-30 15:30:00', '2023-05-30 16:00:00', '2023-05-30 15:00:00', '2023-05-30 15:15:00'),
(6, 6, 6, 6, 6, 1, 'Noche', 945.00, 12.5, '2023-06-05 20:30:00', '2023-06-05 21:00:00', '2023-06-05 20:00:00', '2023-06-05 20:15:00'),
(7, 7, 7, 7, 7, 2, 'Mañana', 1065.00, 7.5, '2023-07-10 08:30:00', '2023-07-10 09:00:00', '2023-07-10 08:00:00', '2023-07-10 08:15:00'),
(8, 8, 8, 8, 8, 3, 'Tarde', 1085.00, 9.5, '2023-08-15 14:30:00', '2023-08-15 15:00:00', '2023-08-15 14:00:00', '2023-08-15 14:15:00'),
(9, 9, 9, 9, 9, 4, 'Noche', 1095.00, 3.0, '2023-09-20 19:30:00', '2023-09-20 20:00:00', '2023-09-20 19:00:00', '2023-09-20 19:15:00'),
(10, 10, 10, 10, 10, 5, 'Mañana', 900.00, 15.0, '2023-10-25 09:30:00', '2023-10-25 10:00:00', '2023-10-25 09:00:00', '2023-10-25 09:15:00');

SELECT * FROM Ordenes

-- Insertar datos en DetalleOrdenes
INSERT INTO DetalleOrden (OrdenID, ProductoID, Cantidad, SubTotal) VALUES
(1, 1, 3, 23.44),
(1, 2, 5, 45.14),
(1, 3, 4, 46.37),
(1, 4, 4, 42.34),
(1, 5, 1, 18.25),
(1, 6, 4, 20.08),
(1, 7, 2, 13.31),
(1, 8, 2, 20.96),
(1, 9, 4, 30.13),
(1, 10, 3, 38.34);

-- cual es la cantidad de registros unicos en la tabla ordenes?
SELECT COUNT(DISTINCT OrdenID) AS CantidadOrdenesUnicas
FROM Ordenes; -- la respuesta es 10

-- cuantos empleados existen en cada departamento?
SELECT d.Nombre AS Departamento, COUNT(e.EmpleadoID) AS CantidadEmpleados
FROM Empleados e
JOIN Departamentos d ON e.DepartamentoID = d.DepartamentoID
GROUP BY d.Nombre
ORDER BY CantidadEmpleados DESC;

-- cuantos productos hay por codigo de categoria?
SELECT c.CategoriaID, c.Nombre AS Categoria, COUNT(p.ProductoID) AS CantidadProductos
FROM Productos p
JOIN Categorias c ON p.CategoriaID = c.CategoriaID
GROUP BY c.CategoriaID, c.Nombre
ORDER BY c.CategoriaID;

-- cuantos clientes se han importado en la tabla clientes?
SELECT COUNT(*) AS TotalClientes
FROM Clientes;

-- analisis de desempeño de sucursales
SELECT 
    s.SucursalID,
    s.Nombre AS Sucursal,
    AVG(o.TotalCompra) AS PromedioFacturacion,
    AVG(o.KilometrosRecorrer) AS PromedioKmRecorridos
FROM Ordenes o
JOIN Sucursales s ON o.SucursalID = s.SucursalID
GROUP BY s.SucursalID, s.Nombre
HAVING AVG(o.TotalCompra) > 1000
ORDER BY PromedioKmRecorridos ASC;

-- total ventas globales
SELECT SUM(TotalCompra) AS TotalVentasGlobales
FROM Ordenes;

-- promedio de precios por producto por categoria 
SELECT c.Nombre AS Categoria, AVG(p.Precio) AS PrecioPromedio
FROM Productos p
JOIN Categorias c ON p.CategoriaID = c.CategoriaID
GROUP BY c.Nombre;

-- orden minima y maxima por sucursal
SELECT s.Nombre AS Sucursal,
       MIN(o.TotalCompra) AS OrdenMinima,
       MAX(o.TotalCompra) AS OrdenMaxima
FROM Ordenes o
JOIN Sucursales s ON o.SucursalID = s.SucursalID
GROUP BY s.Nombre;

-- mayor numero de kilometros recorridos para entrega
SELECT MAX(KilometrosRecorrer) AS MaxKilometrosRecorridos
FROM Ordenes;

-- promedio de cantidad de productos por orden
SELECT AVG(CantidadTotal) AS PromedioProductosPorOrden
FROM (
    SELECT OrdenID, SUM(Cantidad) AS CantidadTotal
    FROM DetalleOrden
    GROUP BY OrdenID
) AS ProductosPorOrden;


-- total de ventas por tipo de pago
SELECT tp.Nombre AS TipoPago, SUM(o.TotalCompra) AS TotalFacturado
FROM Ordenes o
JOIN TiposPago tp ON o.TipoPagoID = tp.TipoPagoID
GROUP BY tp.Nombre;

-- sucursal con la venta promedio mas alta
SELECT TOP 1 s.Nombre AS Sucursal, AVG(o.TotalCompra) AS PromedioVentas
FROM Ordenes o
JOIN Sucursales s ON o.SucursalID = s.SucursalID
GROUP BY s.Nombre
ORDER BY PromedioVentas DESC;

-- sucursal con la mayor cantidad de ventas por encima de $1000
SELECT s.Nombre AS Sucursal, COUNT(*) AS VentasMayoresA1000
FROM Ordenes o
JOIN Sucursales s ON o.SucursalID = s.SucursalID
WHERE o.TotalCompra > 1000
GROUP BY s.Nombre
ORDER BY VentasMayoresA1000 DESC;

-- comparacion de ventas promedio antes y despues del 1 de julio de 2023
SELECT 
    CASE 
        WHEN FechaOrdenTomada < '2023-07-01' THEN 'Antes del 1-Jul-2023'
        ELSE 'Después del 1-Jul-2023'
    END AS Periodo,
    AVG(TotalCompra) AS PromedioVentas
FROM Ordenes
GROUP BY 
    CASE 
        WHEN FechaOrdenTomada < '2023-07-01' THEN 'Antes del 1-Jul-2023'
        ELSE 'Después del 1-Jul-2023'
    END;

    -- analisis de actividad de ventas por horario
    SELECT HorarioVenta,
       COUNT(*) AS CantidadVentas,
       AVG(TotalCompra) AS IngresoPromedio,
       MAX(TotalCompra) AS ImporteMaximo
FROM Ordenes
GROUP BY HorarioVenta
ORDER BY CantidadVentas DESC;


-- Como puedo obtener una lista de todos los productos junto con sus categorias?
SELECT 
    p.Nombre AS Producto,
    c.Nombre AS Categoria
FROM Productos p
LEFT JOIN Categorias c ON p.CategoriaID = c.CategoriaID;

-- como puedo saber a que sucursal esta asignado cada empleado?
SELECT 
    e.Nombre AS Empleado,
    s.Nombre AS Sucursal
FROM Empleados e
JOIN Sucursales s ON e.SucursalID = s.SucursalID;


-- existen productos que no tienen una categoria asignada?
SELECT 
    p.ProductoID,
    p.Nombre AS Producto
FROM Productos p
LEFT JOIN Categorias c ON p.CategoriaID = c.CategoriaID
WHERE c.CategoriaID IS NULL;

-- como puedo obtener un detalle completo de las ordenes, incluyendo  el nombre del cliente, del vendedor y del mensajero?
SELECT 
    o.OrdenID,
    c.Nombre AS Cliente,
    e.Nombre AS Vendedor,
    m.Nombre AS Mensajero,
    o.TotalCompra,
    o.FechaOrdenTomada
FROM Ordenes o
JOIN Clientes c ON o.ClienteID = c.ClienteID
JOIN Empleados e ON o.VendedorID = e.EmpleadoID
JOIN Mensajeros m ON o.MensajeroID = m.MensajeroID;

-- productos vendidos por sucursal y por categoria
    SELECT 
    s.Nombre AS Sucursal,
    c.Nombre AS Categoria,
    SUM(do.Cantidad) AS TotalArticulosVendidos
FROM DetalleOrden do
JOIN Productos p ON do.ProductoID = p.ProductoID
JOIN Categorias c ON p.CategoriaID = c.CategoriaID
JOIN Ordenes o ON do.OrdenID = o.OrdenID
JOIN Sucursales s ON o.SucursalID = s.SucursalID
GROUP BY s.Nombre, c.Nombre
ORDER BY s.Nombre, c.Nombre;




















