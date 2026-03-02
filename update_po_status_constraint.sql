-- Script to update chk_po_status constraint to include 'CREATED'
-- This allows purchase orders to have status: IMPORTED, CANCELLED, CLOSED, or CREATED

-- Step 1: Drop the existing constraint
ALTER TABLE purchase_order DROP CONSTRAINT chk_po_status;

-- Step 2: Add the new constraint with CREATED included
ALTER TABLE purchase_order 
ADD CONSTRAINT chk_po_status 
CHECK (status IN ('IMPORTED', 'CANCELLED', 'CLOSED', 'CREATED'));

-- Verify the constraint was updated correctly
SELECT CONSTRAINT_NAME, CHECK_CLAUSE 
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS 
WHERE CONSTRAINT_NAME = 'chk_po_status';
