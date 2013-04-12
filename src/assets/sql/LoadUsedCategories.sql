SELECT
  c.id,
  c.categoryId,
  c.name,
  c.header,
  c.direction,
  c.parentId
FROM categories AS c
  JOIN transactions AS t
    ON c.categoryId = t.categoryId
WHERE c.direction = "withdrawal" AND c.header = 0
GROUP BY c.name
ORDER BY c.name
  ASC;