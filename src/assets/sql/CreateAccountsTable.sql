CREATE TABLE accounts
(
  id                INTEGER PRIMARY KEY AUTOINCREMENT,
  accountId         INTEGER,
  balance           REAL,
  bankName          STRING,
  bankPluginName    STRING DEFAULT '',
  currencyBalance   REAL,
  currencyName      STRING,
  displayName       STRING,
  iban              STRING,
  ibanChecksum      STRING,
  is_default_wallet INTEGER DEFAULT 0
);
