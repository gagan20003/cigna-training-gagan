-- USAGE EXAMPLES
-----------------------------------------------------------------------------------------
--  place an order for customer 2 (Rahul) -- items: product_id 1 qty 2, product_id 2 qty 1
-----------------------------------------------------------------------------------------
DECLARE
  v_ids order_pkg.t_num_tab := order_pkg.t_num_tab(1,2);
  v_qties order_pkg.t_num_tab := order_pkg.t_num_tab(2,1);
  v_order_id NUMBER;
BEGIN
  order_pkg.place_order(p_customer_id => 2, p_product_ids => v_ids, p_quantities => v_qties, p_payment_method => 'CARD', p_out_order_id => v_order_id);
  DBMS_OUTPUT.PUT_LINE('Order placed: ' || v_order_id);
END;
/
-----------------------------------------------------------------------------------------
--  cancel order
-----------------------------------------------------------------------------------------
BEGIN
  order_pkg.cancel_order(1001);
END;
/

-----------------------------------------------------------------------------------------
-- Total sales per product (by amount)
-----------------------------------------------------------------------------------------
SELECT p.product_id, p.sku, p.name, SUM(oi.line_total) AS total_sales, SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id AND o.status <> 'CANCELLED'
GROUP BY p.product_id, p.sku, p.name
ORDER BY total_sales DESC;
-----------------------------------------------------------------------------------------
-- Monthly revenue (last 12 months)
-----------------------------------------------------------------------------------------
SELECT TO_CHAR(o.order_date, 'YYYY-MM') AS year_month,
       SUM(o.total_amt) AS revenue,
       COUNT(o.order_id) AS orders_count
FROM orders o
WHERE o.status <> 'CANCELLED' AND o.order_date >= ADD_MONTHS(TRUNC(SYSDATE,'MM'), -11)
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY year_month;
-----------------------------------------------------------------------------------------
-- Top customers by lifetime spend
-----------------------------------------------------------------------------------------
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name, SUM(o.total_amt) AS lifetime_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status <> 'CANCELLED'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY lifetime_spend DESC;

-----------------------------------------------------------------------------------------
-- Stock alert: products with low stock
-----------------------------------------------------------------------------------------
SELECT product_id, sku, name, stock_qty FROM products WHERE stock_qty <= 10 ORDER BY stock_qty;


-----------------------------------------------------------------------------------------
-- ORDER DETAILS REPORT
-- Shows full details of each order, including customer and product info.
-----------------------------------------------------------------------------------------
SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    p.name AS product_name,
    oi.quantity,
    oi.unit_price,
    oi.line_total,
    o.subtotal,
    o.discount_amt,
    o.tax_amt,
    o.total_amt,
    o.status,
    TO_CHAR(o.order_date, 'DD-MON-YYYY') AS order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_date DESC, o.order_id;

-----------------------------------------------------------------------------------------
-- DAILY SALES SUMMARY
-- Summarizes revenue, number of orders, and total items sold for each day.
-----------------------------------------------------------------------------------------
SELECT 
    TRUNC(o.order_date) AS order_day,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_items_sold,
    SUM(o.total_amt) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY TRUNC(o.order_date)
ORDER BY order_day DESC;

-----------------------------------------------------------------------------------------
-- CUSTOMER PURCHASE FREQUENCY
-- Lists customers by how many orders they’ve placed and total amount spent.
-----------------------------------------------------------------------------------------
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amt) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status <> 'CANCELLED'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC, total_spent DESC;

-----------------------------------------------------------------------------------------
-- PRODUCT INVENTORY REPORT
-- Displays current stock, total units sold, and estimated initial stock levels.
-----------------------------------------------------------------------------------------
SELECT 
    p.product_id,
    p.name,
    p.sku,
    p.stock_qty,
    NVL(SUM(oi.quantity), 0) AS total_sold,
    p.stock_qty + NVL(SUM(oi.quantity), 0) AS initial_stock
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status <> 'CANCELLED'
GROUP BY p.product_id, p.name, p.sku, p.stock_qty
ORDER BY total_sold DESC;

-----------------------------------------------------------------------------------------
-- ORDERS AWAITING PAYMENT
-- Lists orders that have been placed but have no associated payment record.
-----------------------------------------------------------------------------------------
SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    o.total_amt,
    o.status,
    o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_id IS NULL
  AND o.status <> 'CANCELLED'
ORDER BY o.order_date DESC;

-----------------------------------------------------------------------------------------
-- ORDER COUNT BY STATUS
-- Provides a quick overview of order pipeline (e.g., Pending, Confirmed, Shipped).
-----------------------------------------------------------------------------------------
SELECT 
    status,
    COUNT(order_id) AS num_orders
FROM orders
GROUP BY status
ORDER BY num_orders DESC;

-----------------------------------------------------------------------------------------
-- TOP-SELLING CATEGORIES
-- If the Products table is extended with a 'category' column, this shows category sales.
-----------------------------------------------------------------------------------------
SELECT 
    category,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.line_total) AS total_sales
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY category
ORDER BY total_sales DESC;

-----------------------------------------------------------------------------------------
-- AVERAGE ORDER VALUE (AOV)
-- Measures how much revenue is earned per completed order.
-----------------------------------------------------------------------------------------
SELECT 
    ROUND(SUM(total_amt) / COUNT(order_id), 2) AS avg_order_value
FROM orders
WHERE status <> 'CANCELLED';

-----------------------------------------------------------------------------------------
-- PRODUCTS NEVER ORDERED
-- Finds products that have never appeared in any order.
-----------------------------------------------------------------------------------------
SELECT 
    p.product_id,
    p.name,
    p.sku,
    p.stock_qty
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id
);

-----------------------------------------------------------------------------------------
-- REVENUE GROWTH MONTH-OVER-MONTH
-- Calculates monthly revenue and growth percentage from previous month.
-----------------------------------------------------------------------------------------
WITH monthly AS (
    SELECT 
        TO_CHAR(order_date, 'YYYY-MM') AS month,
        SUM(total_amt) AS revenue
    FROM orders
    WHERE status <> 'CANCELLED'
    GROUP BY TO_CHAR(order_date, 'YYYY-MM')
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(((revenue - LAG(revenue) OVER (ORDER BY month)) / 
           LAG(revenue) OVER (ORDER BY month)) * 100, 2) AS growth_percent
FROM monthly
ORDER BY month;

-----------------------------------------------------------------------------------------
-- TOP 5 PRODUCTS BY REVENUE
-- Quickly identifies the best-selling products based on total revenue.
-----------------------------------------------------------------------------------------
SELECT 
    p.product_id,
    p.name,
    SUM(oi.line_total) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY p.product_id, p.name
ORDER BY total_revenue DESC
FETCH FIRST 5 ROWS ONLY;