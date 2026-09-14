USE EcommerceDB;

SELECT * FROM Customers;

SELECT
    p.name AS product,
    p.price,
    c.name AS category
FROM Products p
JOIN Categories c
    ON p.category_id = c.category_id;

SELECT
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    p.name AS product,
    oi.quantity,
    oi.unit_price,
    o.status AS order_status,
    pay.payment_status,
    s.status AS shipping_status
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
JOIN OrderItems oi
    ON o.order_id = oi.order_id
JOIN Products p
    ON oi.product_id = p.product_id
LEFT JOIN Payments pay
    ON o.order_id = pay.order_id
LEFT JOIN Shipments s
    ON o.order_id = s.order_id
ORDER BY o.order_id;