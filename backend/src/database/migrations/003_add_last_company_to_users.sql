ALTER TABLE users
ADD CONSTRAINT fk_users_last_company
FOREIGN KEY (last_company_id)
REFERENCES companies(id)
ON UPDATE CASCADE
ON DELETE SET NULL;
