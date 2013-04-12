CREATE TRIGGER IF NOT EXISTS delete_transactions AFTER DELETE ON transactions
BEGIN
  INSERT INTO sync_delete_elements
  (
    table_name,
    id
  )
    VALUES
    (
      "transactions",
      old.transactionId
    );
  DELETE FROM sync_insert_elements WHERE id = old.id;
  DELETE FROM sync_update_elements WHERE id = old.id;
END;