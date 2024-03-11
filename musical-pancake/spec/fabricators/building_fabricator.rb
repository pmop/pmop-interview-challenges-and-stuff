Fabricator(:building) do
  internal_number  1
  number           1
  code_multiple    "MyString"
  postal_number_fk "MyString"
  street_fk        1
end