-- ============================================================
-- Migration: PICK_WAVE, PICK_TASK (wave_id), PICK_TASK_LINE (from_slot_id, qty_to_pick, pick_status), PACKING
-- Run against your WMS database (e.g. warehouse_management).
-- If a column/table already exists, skip or comment out that statement.
-- ============================================================

-- 1. Create pick_wave table (ERD: wave_id, gdn_id, status, created_by, created_at)
CREATE TABLE IF NOT EXISTS pick_wave (
    wave_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    gdn_id BIGINT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'CREATED',
    created_by BIGINT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pick_wave_gdn FOREIGN KEY (gdn_id) REFERENCES goods_delivery_note(gdn_id),
    CONSTRAINT fk_pick_wave_created_by FOREIGN KEY (created_by) REFERENCES `user`(user_id),
    INDEX idx_pick_wave_status (status),
    INDEX idx_pick_wave_gdn (gdn_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Add wave_id to pick_task (skip if already added)
ALTER TABLE pick_task ADD COLUMN wave_id BIGINT NULL AFTER pick_task_id;
ALTER TABLE pick_task ADD CONSTRAINT fk_pick_task_wave FOREIGN KEY (wave_id) REFERENCES pick_wave(wave_id);
ALTER TABLE pick_task ADD INDEX idx_pick_task_wave (wave_id);

-- 3. Add from_slot_id, qty_to_pick, pick_status, note to pick_task_line (skip if already added)
ALTER TABLE pick_task_line ADD COLUMN from_slot_id BIGINT NULL AFTER gdn_line_id;
ALTER TABLE pick_task_line ADD CONSTRAINT fk_pick_task_line_slot FOREIGN KEY (from_slot_id) REFERENCES slot(slot_id);
ALTER TABLE pick_task_line ADD COLUMN qty_to_pick DECIMAL(18,4) NOT NULL DEFAULT 0 AFTER from_slot_id;
ALTER TABLE pick_task_line ADD COLUMN pick_status VARCHAR(50) NULL DEFAULT 'PENDING' AFTER qty_picked;
ALTER TABLE pick_task_line ADD COLUMN note VARCHAR(500) NULL AFTER pick_status;

-- Backfill qty_to_pick from qty_required where applicable
UPDATE pick_task_line SET qty_to_pick = COALESCE(qty_required, 0) WHERE (qty_to_pick = 0 OR qty_to_pick IS NULL);

-- 4. Create packing table
CREATE TABLE IF NOT EXISTS packing (
    pack_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    gdn_id BIGINT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    packed_by BIGINT NULL,
    packed_at DATETIME NULL,
    package_label VARCHAR(255) NULL,
    CONSTRAINT fk_packing_gdn FOREIGN KEY (gdn_id) REFERENCES goods_delivery_note(gdn_id),
    CONSTRAINT fk_packing_packed_by FOREIGN KEY (packed_by) REFERENCES `user`(user_id),
    INDEX idx_packing_gdn (gdn_id),
    INDEX idx_packing_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
