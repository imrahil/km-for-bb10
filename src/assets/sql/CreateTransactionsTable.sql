CREATE TABLE transactions
(
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  transactionId  INTEGER,
  userAccountId  INTEGER,
  currencyAmount REAL DEFAULT 0,
  currencyName   STRING DEFAULT '',
  amount         REAL DEFAULT 0,
  transactionOn  STRING DEFAULT '',
  bookedOn       STRING DEFAULT '',
  description    STRING DEFAULT '',
  categoryName   STRING DEFAULT '',
  categoryId     INTEGER,
  tagString      STRING DEFAULT '',

  direction      STRING DEFAULT '',
  isWallet       INTEGER DEFAULT 0
);
