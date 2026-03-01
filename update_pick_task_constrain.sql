-- MIGRATION 1

-- 1. Xóa ràng buộc cũ
ALTER TABLE pick_task DROP CONSTRAINT chk_pick_task_status;

-- 2. Thêm lại ràng buộc mới bao gồm 'CREATED'
ALTER TABLE pick_task 
ADD CONSTRAINT chk_pick_task_status 
CHECK (status IN ('CREATED', 'PENDING', 'ASSIGNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'));

-- MIGRATION 2

-- 1. Xóa ràng buộc cũ trên bảng chi tiết
ALTER TABLE pick_task_line DROP CONSTRAINT chk_pick_line_status;

-- 2. Thêm lại ràng buộc mới bao gồm 'PENDING' và các trạng thái cần thiết
ALTER TABLE pick_task_line 
ADD CONSTRAINT chk_pick_line_status 
CHECK (pick_status IN ('PENDING', 'PICKED', 'COMPLETED', 'CANCELLED', 'DONE'));
