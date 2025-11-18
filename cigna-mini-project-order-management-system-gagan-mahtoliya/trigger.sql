-- 4) TRIGGERS
-- Reduce product stock when an order_item is inserted
CREATE OR REPLACE TRIGGER trg_order_item_after_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock_qty = stock_qty - :NEW.quantity
  WHERE product_id = :NEW.product_id;
END;
/
-- Prevent negative stock via trigger (double-check)
CREATE OR REPLACE TRIGGER trg_products_stock_check
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  IF :NEW.stock_qty < 0 THEN
    RAISE_APPLICATION_ERROR(-20020, 'Stock cannot be negative for product ' || :NEW.product_id);
  END IF;
END;
/