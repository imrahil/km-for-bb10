INSERT INTO categories
(
  categoryId,
  name,
  header,
  direction,
  parentId
)
  VALUES
  (
    :categoryId,
    :name,
    :header,
    :direction,
    :parentId
  )