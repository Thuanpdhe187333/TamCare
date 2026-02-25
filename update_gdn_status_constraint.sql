-- ============================================================
-- XÓA HẲN CHECK CONSTRAINT trên goods_delivery_note.status
-- Chạy trong đúng database mà app dùng (vd: warehouse_management)
-- ============================================================

-- Bước 1: Xem tên constraint (chạy trước để biết tên chính xác)
SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'goods_delivery_note'
  AND CONSTRAINT_TYPE = 'CHECK';

-- Bước 2: Xóa constraint - CHỈ CHẠY MỘT LỆNH SAU, cái nào chạy được thì dùng:

-- Cách A (MySQL thường dùng):
ALTER TABLE goods_delivery_note DROP CHECK chk_gdn_status;

-- Cách B (nếu A báo lỗi, bỏ comment ở dòng dưới và chạy):
-- ALTER TABLE goods_delivery_note DROP CONSTRAINT chk_gdn_status;

-- Nếu tên constraint khác (xem từ Bước 1), thay chk_gdn_status bằng tên đó, ví dụ:
-- ALTER TABLE goods_delivery_note DROP CHECK <tên_từ_bước_1>;
