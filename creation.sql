USE EcommerceDB;

CREATE TABLE Customers
(
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE CustomerAddresses
(
    address_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    address_line1 VARCHAR(200) NOT NULL,
    address_line2 VARCHAR(200),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'India',
    address_type VARCHAR(20) NOT NULL DEFAULT 'Home',
    is_default BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_CustomerAddresses_Customers
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    CONSTRAINT CK_AddressType
        CHECK (address_type IN ('Home', 'Office', 'Other'))
);

CREATE TABLE Categories
(
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500)
);

CREATE TABLE Products
(
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(1000),
    price DECIMAL(10,2) NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    category_id INT NOT NULL,
    is_active BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (category_id)
        REFERENCES Categories(category_id),

    CONSTRAINT CK_ProductPrice
        CHECK (price >= 0)
);

CREATE TABLE Inventory
(
    product_id INT PRIMARY KEY,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    reserved_quantity INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Inventory_Products
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id),

    CONSTRAINT CK_InventoryQuantity
        CHECK (quantity_in_stock >= 0),

    CONSTRAINT CK_ReservedQuantity
        CHECK (reserved_quantity >= 0),

    CONSTRAINT CK_ReorderLevel
        CHECK (reorder_level >= 0),

    CONSTRAINT CK_ReservedNotGreaterThanStock
        CHECK (reserved_quantity <= quantity_in_stock)
);

CREATE TABLE Orders
(
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    shipping_address_id INT NOT NULL,
    billing_address_id INT NOT NULL,

    order_date DATETIME2 NOT NULL DEFAULT GETDATE(),

    status VARCHAR(30) NOT NULL DEFAULT 'Pending',

    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
    discount DECIMAL(12,2) NOT NULL DEFAULT 0,
    shipping_fee DECIMAL(12,2) NOT NULL DEFAULT 0,
    tax DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    CONSTRAINT FK_Orders_ShippingAddress
        FOREIGN KEY (shipping_address_id)
        REFERENCES CustomerAddresses(address_id),

    CONSTRAINT FK_Orders_BillingAddress
        FOREIGN KEY (billing_address_id)
        REFERENCES CustomerAddresses(address_id),

    CONSTRAINT CK_OrderStatus
        CHECK
        (
            status IN
            ('Pending','Confirmed','Processing','Packed','Shipped','Delivered','Cancelled','Returned')
        ),

    CONSTRAINT CK_OrderAmounts
        CHECK
        (
            subtotal >= 0
            AND discount >= 0
            AND shipping_fee >= 0
            AND tax >= 0
            AND total_amount >= 0
        )
);

CREATE TABLE OrderItems
(
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,

    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) NOT NULL DEFAULT 0,
    subtotal DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id),

    CONSTRAINT CK_OrderItemQuantity
        CHECK (quantity > 0),

    CONSTRAINT CK_OrderItemPrice
        CHECK (unit_price >= 0),

    CONSTRAINT CK_OrderItemDiscount
        CHECK (discount >= 0),

    CONSTRAINT CK_OrderItemSubtotal
        CHECK (subtotal >= 0)
);

CREATE TABLE Payments
(
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,

    payment_method VARCHAR(30) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_status VARCHAR(30) NOT NULL DEFAULT 'Pending',

    transaction_id VARCHAR(150) UNIQUE,
    payment_date DATETIME2,

    CONSTRAINT FK_Payments_Orders
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT CK_PaymentMethod
        CHECK
        (
            payment_method IN
            (
                'Cash',
                'Card',
                'UPI',
                'NetBanking',
                'Wallet'
            )
        ),

    CONSTRAINT CK_PaymentStatus
        CHECK
        (
            payment_status IN
            (
                'Pending',
                'Completed',
                'Failed',
                'Refunded',
                'PartiallyRefunded'
            )
        ),

    CONSTRAINT CK_PaymentAmount
        CHECK (amount >= 0)
);

CREATE TABLE Shipments
(
    shipment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,

    carrier VARCHAR(100),
    tracking_number VARCHAR(100) UNIQUE,

    shipped_at DATETIME2,
    estimated_delivery DATETIME2,
    delivered_at DATETIME2,

    status VARCHAR(30) NOT NULL DEFAULT 'Pending',

    CONSTRAINT FK_Shipments_Orders
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT CK_ShipmentStatus
        CHECK
        (
            status IN
            (
                'Pending',
                'Packed',
                'Shipped',
                'InTransit',
                'OutForDelivery',
                'Delivered',
                'Returned'
            )
        )
);

CREATE TABLE OrderStatusHistory
(
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,

    status VARCHAR(30) NOT NULL,
    changed_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    notes VARCHAR(500),

    CONSTRAINT FK_OrderStatusHistory_Orders
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT CK_StatusHistoryStatus
        CHECK
        (
            status IN
            (
                'Pending',
                'Confirmed',
                'Processing',
                'Packed',
                'Shipped',
                'Delivered',
                'Cancelled',
                'Returned'
            )
        )
);

CREATE INDEX IX_Orders_Customer
ON Orders(customer_id);

CREATE INDEX IX_Orders_Status
ON Orders(status);

CREATE INDEX IX_Orders_OrderDate
ON Orders(order_date);

CREATE INDEX IX_OrderItems_Order
ON OrderItems(order_id);

CREATE INDEX IX_OrderItems_Product
ON OrderItems(product_id);

CREATE INDEX IX_Products_Category
ON Products(category_id);

CREATE INDEX IX_OrderStatusHistory_Order
ON OrderStatusHistory(order_id);

CREATE INDEX IX_Payments_Order
ON Payments(order_id);

CREATE INDEX IX_Shipments_Order
ON Shipments(order_id);