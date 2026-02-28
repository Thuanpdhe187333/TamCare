-- ============================================================
-- Migration: add gdn_id to pick_task for pick wave / pick task feature
-- Run this against your WMS database (e.g. wms_db).
-- ============================================================

-- 1) Add gdn_id column to pick_task (nullable, used together with wave_id)
ALTER TABLE pick_task
    ADD COLUMN IF NOT EXISTS gdn_id BIGINT NULL AFTER wave_id;

-- 2) Add foreign key from pick_task.gdn_id -> goods_delivery_note.gdn_id
ALTER TABLE pick_task
    ADD CONSTRAINT fk_pick_task_gdn
        FOREIGN KEY (gdn_id) REFERENCES goods_delivery_note(gdn_id);

-- 3) Index to speed up lookups by gdn_id
CREATE INDEX IF NOT EXISTS idx_pick_task_gdn ON pick_task(gdn_id);

