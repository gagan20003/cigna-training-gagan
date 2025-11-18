-- 3) PACKAGE: types, exceptions, procedures, functions
CREATE OR REPLACE PACKAGE order_pkg IS
  -- Collection types for passing arrays of product ids and quantities
  TYPE t_num_tab IS TABLE OF NUMBER;

  -- Custom exceptions
  e_stock_unavailable EXCEPTION;

  -- Functions
  FUNCTION calc_discount(p_customer_id NUMBER, p_subtotal NUMBER) RETURN NUMBER;
  FUNCTION calc_tax(p_amount NUMBER) RETURN NUMBER;

  -- Procedures
  PROCEDURE place_order(
    p_customer_id NUMBER,
    p_product_ids IN t_num_tab,
    p_quantities  IN t_num_tab,
    p_payment_method VARCHAR2 DEFAULT NULL,
    p_out_order_id OUT NUMBER
  );

  PROCEDURE cancel_order(p_order_id NUMBER);
END order_pkg;
/

CREATE OR REPLACE PACKAGE BODY order_pkg IS
  -- Discount policy:
  -- VIP customers get 10% discount, regular customers get 0% by default.
  FUNCTION calc_discount(p_customer_id NUMBER, p_subtotal NUMBER) RETURN NUMBER IS
    v_type customers.customer_type%TYPE;
    v_disc NUMBER := 0;
  BEGIN
    SELECT customer_type INTO v_type FROM customers WHERE customer_id = p_customer_id;
    IF v_type = 'VIP' THEN
      v_disc := ROUND(p_subtotal * 0.10,2); -- 10% VIP discount
    ELSIF p_subtotal >= 200 THEN
      v_disc := ROUND(p_subtotal * 0.05,2); -- 5% bulk order discount
    END IF;
    RETURN v_disc;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
  END calc_discount;

  -- Tax calculation (GST-like): flat 18% on taxable amount
  FUNCTION calc_tax(p_amount NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN ROUND(p_amount * 0.18,2);
  END calc_tax;

  PROCEDURE place_order(
    p_customer_id NUMBER,
    p_product_ids IN t_num_tab,
    p_quantities  IN t_num_tab,
    p_payment_method VARCHAR2 DEFAULT NULL,
    p_out_order_id OUT NUMBER
  ) IS
    v_order_id NUMBER;
    v_subtotal NUMBER := 0;
    v_discount NUMBER := 0;
    v_tax NUMBER := 0;
    v_total NUMBER := 0;
    v_unit_price NUMBER;
    v_line_total NUMBER;
  BEGIN
    -- Basic validation
    IF p_product_ids.COUNT = 0 OR p_product_ids.COUNT != p_quantities.COUNT THEN
      RAISE_APPLICATION_ERROR(-20001, 'Product IDs and quantities must be provided and have the same length');
    END IF;

    -- Check stock availability for each item before creating order
    FOR i IN 1 .. p_product_ids.COUNT LOOP
      DECLARE
        v_stock NUMBER;
      BEGIN
        SELECT stock_qty INTO v_stock FROM products WHERE product_id = p_product_ids(i) FOR UPDATE;
        IF v_stock < p_quantities(i) THEN
          RAISE e_stock_unavailable;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20002, 'Product not found: ' || p_product_ids(i));
      END;
    END LOOP;

    -- Create order header
    INSERT INTO orders (customer_id, order_date, status)
    VALUES (p_customer_id, SYSDATE, 'CONFIRMED')
    RETURNING order_id INTO v_order_id;

    -- Insert order items (do not update stock here; trigger will handle stock decrement on insert)
    FOR i IN 1 .. p_product_ids.COUNT LOOP
      SELECT price INTO v_unit_price FROM products WHERE product_id = p_product_ids(i);
      v_line_total := ROUND(v_unit_price * p_quantities(i), 2);

      INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_total)
      VALUES (v_order_id, p_product_ids(i), p_quantities(i), v_unit_price, v_line_total);

      v_subtotal := v_subtotal + v_line_total;
    END LOOP;

    -- Calculate discounts & tax
    v_discount := calc_discount(p_customer_id, v_subtotal);
    v_tax := calc_tax(v_subtotal - v_discount);
    v_total := ROUND(v_subtotal - v_discount + v_tax,2);

    -- Update order totals
    UPDATE orders SET subtotal = v_subtotal, discount_amt = v_discount, tax_amt = v_tax, total_amt = v_total
      WHERE order_id = v_order_id;

    -- Record payment (simple model: full payment captured at order time)
    IF p_payment_method IS NOT NULL THEN
      INSERT INTO payments (order_id, paid_amount, paid_date, payment_method)
      VALUES (v_order_id, v_total, SYSDATE, p_payment_method);
    END IF;

    COMMIT;

    p_out_order_id := v_order_id;

  EXCEPTION
    WHEN e_stock_unavailable THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20003, 'One or more items are out of stock for requested quantities');
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END place_order;

  PROCEDURE cancel_order(p_order_id NUMBER) IS
    v_status orders.status%TYPE;
  BEGIN
    SELECT status INTO v_status FROM orders WHERE order_id = p_order_id FOR UPDATE;

    IF v_status = 'CANCELLED' THEN
      RAISE_APPLICATION_ERROR(-20010, 'Order is already cancelled');
    END IF;

    -- Set order status to CANCELLED
    UPDATE orders SET status = 'CANCELLED' WHERE order_id = p_order_id;

    -- Restock items (reverse of trigger which reduced stock on insert)
    FOR rec IN (SELECT product_id, quantity FROM order_items WHERE order_id = p_order_id) LOOP
      UPDATE products SET stock_qty = stock_qty + rec.quantity WHERE product_id = rec.product_id;
    END LOOP;

    -- Optionally record refund or negative payment
    INSERT INTO payments (order_id, paid_amount, paid_date, payment_method)
    VALUES (p_order_id, 0, SYSDATE, 'REFUND_PENDING');

    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20011, 'Order not found: ' || p_order_id);
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END cancel_order;
END order_pkg;