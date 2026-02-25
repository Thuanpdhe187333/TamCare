ALTER TABLE pick_task
ADD COLUMN gdn_id BIGINT UNSIGNED NULL AFTER wave_id;

ALTER TABLE pick_task
    ADD CONSTRAINT fk_pick_task_gdn
        FOREIGN KEY (gdn_id) REFERENCES goods_delivery_note(gdn_id);

CREATE INDEX idx_pick_task_gdn ON pick_task(gdn_id);

-- 

ALTER TABLE pick_task_line
    ADD COLUMN variant_id BIGINT UNSIGNED NULL AFTER gdn_line_id;

ALTER TABLE pick_task_line
    ADD CONSTRAINT fk_pick_task_line_variant
        FOREIGN KEY (variant_id) REFERENCES product_variant(variant_id);

CREATE INDEX idx_pick_task_line_variant ON pick_task_line(variant_id);

-- 

ALTER TABLE pick_task_line
    ADD COLUMN qty_required DECIMAL(18,4) NULL AFTER from_slot_id;

-- Nếu muốn, có thể khởi tạo qty_required = qty_to_pick cho các record hiện có:
UPDATE pick_task_line
SET qty_required = qty_to_pick
WHERE qty_required IS NULL;

-- 

ALTER TABLE pick_task_line
    CHANGE COLUMN pick_line_id pick_task_line_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT;