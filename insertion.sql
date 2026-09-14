USE EcommerceDB;

INSERT INTO Customers
(first_name, last_name, email, phone, password_hash)
VALUES
('Harsh','Sharma','harsh@example.com','9876543210','hash_001'),
('Aarav','Mehta','aarav@example.com','9876543211','hash_002'),
('Priya','Verma','priya@example.com','9876543212','hash_003'),
('Rohan','Singh','rohan@example.com','9876543213','hash_004'),
('Ananya','Patel','ananya@example.com','9876543214','hash_005');

INSERT INTO CustomerAddresses
(customer_id, address_line1, address_line2, city, state, postal_code, country, address_type, is_default)
VALUES
(1,'123 University Road',NULL,'Gwalior','Madhya Pradesh','474001','India','Home', 1),
(1,'ITM University Campus', NULL,'Gwalior','Madhya Pradesh','474015','India','Office', 0),

(2,'45 MG Road', NULL,'Indore','Madhya Pradesh','452001','India','Home', 1),

(3,'78 Civil Lines', NULL,'Bhopal','Madhya Pradesh','462001','India','Home', 1),

(4,'22 Nehru Nagar', NULL,'Delhi','Delhi','110008','India','Home', 1),

(5,'91 Park Street', NULL,'Mumbai','Maharashtra','400001','India','Home', 1);

INSERT INTO Categories
(name, description)
VALUES
('Electronics','Electronic devices and accessories'),
('Computers','Laptops, desktops and computer components'),
('Mobile Phones','Smartphones and mobile accessories'),
('Gaming','Gaming hardware and accessories'),
('Books','Books and educational material');

INSERT INTO Products
(name, description, price, sku, category_id, is_active)
VALUES
('Dell Inspiron 15',
 '15 inch laptop with Intel Core i5 processor',
 65000.00,
 'LAP-DELL-001',
 2,
 1),

('Logitech G102 Mouse',
 'Wired gaming mouse',
 1299.00,
 'MOU-LOG-001',
 4,
 1),

('Mechanical Keyboard',
 'RGB mechanical gaming keyboard',
 2499.00,
 'KEY-MEC-001',
 4,
 1),

('Samsung Galaxy S25',
 'Samsung flagship smartphone',
 74999.00,
 'SAM-S25-001',
 3,
 1),

('Sony WH-1000XM5',
 'Wireless noise cancelling headphones',
 29999.00,
 'SON-WH5-001',
 1,
 1),

('Arduino Uno',
 'Microcontroller development board',
 899.00,
 'ARD-UNO-001',
 1,
 1),

('Clean Code',
 'Software development book by Robert C. Martin',
 799.00,
 'BOOK-CC-001',
 5,
 1),

('Gaming Monitor 24"',
 '24 inch 144Hz gaming monitor',
 14999.00,
 'MON-GAM-001',
 4,
 1);

 INSERT INTO Inventory
(product_id, quantity_in_stock, reserved_quantity, reorder_level)
VALUES
(1, 25, 2, 5),
(2, 100, 5, 20),
(3, 60, 3, 10),
(4, 30, 4, 5),
(5, 40, 2, 8),
(6, 150, 10, 25),
(7, 75, 5, 15),
(8, 35, 1, 5);

INSERT INTO Orders
(customer_id, shipping_address_id, billing_address_id,
 order_date, status,
 subtotal, discount, shipping_fee, tax, total_amount)
VALUES

-- Order 1
(1, 1, 1,
 GETDATE(), 'Delivered',
 66298.00, 1000.00, 0.00, 11753.64, 67051.64),

-- Order 2
(2, 3, 3,
 GETDATE(), 'Shipped',
 29999.00, 500.00, 100.00, 5327.82, 34926.82),

-- Order 3
(3, 4, 4,
 GETDATE(), 'Processing',
 82498.00, 2000.00, 150.00, 14486.64, 95134.64),

-- Order 4
(4, 5, 5,
 GETDATE(), 'Confirmed',
 16997.00, 0.00, 100.00, 3077.46, 20174.46);

 INSERT INTO OrderItems
(order_id, product_id, quantity, unit_price, discount, subtotal)
VALUES

-- Order 1
(1, 1, 1, 65000.00, 1000.00, 64000.00),
(1, 2, 1, 1299.00, 0.00, 1299.00),
(1, 3, 1, 2499.00, 0.00, 2499.00),

-- Order 2
(2, 5, 1, 29999.00, 500.00, 29499.00),

-- Order 3
(3, 4, 1, 74999.00, 2000.00, 72999.00),
(3, 7, 1, 799.00, 0.00, 799.00),
(3, 6, 1, 899.00, 0.00, 899.00),

-- Order 4
(4, 8, 1, 14999.00, 0.00, 14999.00),
(4, 3, 1, 2499.00, 0.00, 2499.00);

INSERT INTO Payments
(order_id, payment_method, amount, payment_status,
 transaction_id, payment_date)
VALUES
(1, 'UPI', 67051.64, 'Completed', 'TXN10001', GETDATE()),
(2, 'Card', 34926.82, 'Completed', 'TXN10002', GETDATE()),
(3, 'UPI', 95134.64, 'Completed', 'TXN10003', GETDATE()),
(4, 'Card', 20174.46, 'Pending', NULL, NULL);

INSERT INTO Shipments
(order_id, carrier, tracking_number,
 shipped_at, estimated_delivery, delivered_at, status)
VALUES

(1, 'BlueDart', 'BD100001',
 DATEADD(DAY, -3, GETDATE()),
 DATEADD(DAY, -1, GETDATE()),
 DATEADD(DAY, -1, GETDATE()),
 'Delivered'),

(2, 'Delhivery', 'DL100002',
 DATEADD(DAY, -1, GETDATE()),
 DATEADD(DAY, 2, GETDATE()),
 NULL,
 'InTransit'),

(3, 'Ecom Express', 'EC100003',
 NULL,
 DATEADD(DAY, 4, GETDATE()),
 NULL,
 'Packed'),

(4, NULL, NULL,
 NULL,
 NULL,
 NULL,
 'Pending');

 INSERT INTO OrderStatusHistory
(order_id, status, changed_at, notes)
VALUES

-- Order 1
(1, 'Pending', DATEADD(HOUR, -72, GETDATE()), 'Order placed'),
(1, 'Confirmed', DATEADD(HOUR, -70, GETDATE()), 'Payment confirmed'),
(1, 'Processing', DATEADD(HOUR, -65, GETDATE()), 'Order being prepared'),
(1, 'Packed', DATEADD(HOUR, -60, GETDATE()), 'Package packed'),
(1, 'Shipped', DATEADD(DAY, -3, GETDATE()), 'Handed to BlueDart'),
(1, 'Delivered', DATEADD(DAY, -1, GETDATE()), 'Delivered successfully'),

-- Order 2
(2, 'Pending', DATEADD(HOUR, -48, GETDATE()), 'Order placed'),
(2, 'Confirmed', DATEADD(HOUR, -46, GETDATE()), 'Payment confirmed'),
(2, 'Processing', DATEADD(HOUR, -42, GETDATE()), 'Order being prepared'),
(2, 'Shipped', DATEADD(DAY, -1, GETDATE()), 'Shipped through Delhivery'),

-- Order 3
(3, 'Pending', DATEADD(HOUR, -12, GETDATE()), 'Order placed'),
(3, 'Confirmed', DATEADD(HOUR, -10, GETDATE()), 'Payment confirmed'),
(3, 'Processing', DATEADD(HOUR, -8, GETDATE()), 'Order is being processed'),

-- Order 4
(4, 'Pending', DATEADD(HOUR, -4, GETDATE()), 'Order placed'),
(4, 'Confirmed', DATEADD(HOUR, -3, GETDATE()), 'Order confirmed');

