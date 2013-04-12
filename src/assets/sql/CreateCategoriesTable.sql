CREATE TABLE categories
(
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  categoryId INTEGER,
  name       STRING,
  header     INTEGER,
  direction  STRING,
  parentId   INTEGER
);
