CREATE TRIGGER IF NOT EXISTS update_transactions AFTER UPDATE ON transactions
BEGIN
  INSERT INTO sync_update_elements
  (
    table_name,
    id
  )
    VALUES
    (
      "transactions",
      new.id
    );
END;