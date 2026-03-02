-- Update constraint for sales_order table to allow 'CREATED' status
-- This script will drop the existing constraint and create a new one

-- Step 1: Drop the existing constraint (if it exists)
ALTER TABLE sales_order DROP CONSTRAINT IF EXISTS chk_so_status;

-- Step 2: Create new constraint that allows 'CREATED', 'IMPORTED', 'CANCELLED', 'CLOSED'
ALTER TABLE sales_order 
ADD CONSTRAINT chk_so_status 
CHECK (status IN ('CREATED', 'IMPORTED', 'CANCELLED', 'CLOSED'));

-- Verify the constraint
-- You can run this query to check:
-- SHOW CREATE TABLE sales_order;
