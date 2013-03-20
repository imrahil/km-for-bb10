CREATE TRIGGER IF NOT EXISTS insert_transactions AFTER INSERT ON transactions
BEGIN
  INSERT INTO sync_insert_elements
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