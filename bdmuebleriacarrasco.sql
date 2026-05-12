/*
* Base de Datos: bdmuebleriacarrasco
* Descripción: Sistema de gestión para mueblería (Clientes, Pedidos, Inventario, Pagos)
*/

CREATE DATABASE IF NOT EXISTS bdmuebleriacarrasco;
USE bdmuebleriacarrasco;

-- 1. Tabla: CATEGORIA
CREATE TABLE CATEGORIA (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- 2. Tabla: PROVEEDOR
CREATE TABLE PROVEEDOR (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    pais VARCHAR(50)
);

-- 3. Tabla: CLIENTE
CREATE TABLE CLIENTE (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    direccion TEXT,
    fecha_registro DATE
);

-- 4. Tabla: EMPLEADO
CREATE TABLE EMPLEADO (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    cargo VARCHAR(50),
    telefono VARCHAR(20),
    fecha_contrato DATE
);

-- 5. Tabla: ALMACEN
CREATE TABLE ALMACEN (
    id_almacen INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    ubicacion TEXT,
    responsable VARCHAR(150)
);

-- 6. Tabla: PRODUCTO
CREATE TABLE PRODUCTO (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    id_categoria INT,
    id_proveedor INT,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    material VARCHAR(50),
    CONSTRAINT fk_prod_categoria FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id_categoria),
    CONSTRAINT fk_prod_proveedor FOREIGN KEY (id_proveedor) REFERENCES PROVEEDOR(id_proveedor)
);

-- 7. Tabla: INVENTARIO
CREATE TABLE INVENTARIO (
    id_inventario INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    id_almacen INT,
    stock_actual INT NOT NULL,
    stock_minimo INT,
    ultima_actualizacion DATE,
    CONSTRAINT fk_inv_producto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto),
    CONSTRAINT fk_inv_almacen FOREIGN KEY (id_almacen) REFERENCES ALMACEN(id_almacen)
);

-- 8. Tabla: PEDIDO
CREATE TABLE PEDIDO (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_empleado INT,
    fecha_pedido DATE NOT NULL,
    estado VARCHAR(50),
    total DECIMAL(10, 2),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente),
    CONSTRAINT fk_pedido_empleado FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado)
);

-- 9. Tabla: DETALLE_PEDIDO
CREATE TABLE DETALLE_PEDIDO (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_det_pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido),
    CONSTRAINT fk_det_producto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
);

-- 10. Tabla: FACTURA
CREATE TABLE FACTURA (
    id_factura INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    fecha_emision DATE NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    iva DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    rfc_cliente VARCHAR(20),
    CONSTRAINT fk_factura_pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido)
);

-- 11. Tabla: PAGO
CREATE TABLE PAGO (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_factura INT,
    fecha_pago DATE NOT NULL,
    metodo VARCHAR(50),
    monto DECIMAL(10, 2) NOT NULL,
    referencia VARCHAR(100),
    CONSTRAINT fk_pago_factura FOREIGN KEY (id_factura) REFERENCES FACTURA(id_factura)
);
