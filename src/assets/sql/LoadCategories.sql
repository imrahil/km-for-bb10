SELECT
  id,
  categoryId,
  name,
  header,
  direction,
  parentId
FROM categories
WHERE direction = :direction
ORDER BY header
  DESC;