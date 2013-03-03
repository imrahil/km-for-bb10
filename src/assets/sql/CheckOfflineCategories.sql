SELECT
  count(categoryId) AS counter
FROM categories
WHERE direction = :direction;