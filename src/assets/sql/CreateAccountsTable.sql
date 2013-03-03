CREATE TABLE accounts
(
  accountId         INTEGER PRIMARY KEY,
  balance           REAL,
  bankName          STRING,
  bankPluginName    STRING,
  currencyBalance   REAL,
  currencyName      STRING,
  displayName       STRING,
  iban              STRING,
  ibanChecksum      STRING,
  is_default_wallet INTEGER
);
