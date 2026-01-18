-- Tắt kiểm tra khóa ngoại để đảm bảo quá trình DROP và CREATE diễn ra suôn sẻ
SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------------
-- 1. Nhóm Danh mục Cơ bản (Master Data - No Dependencies)
-- ------------------------------------------------------

CREATE TABLE `uom` (
  `uom_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL,
  `name` varchar(120) NOT NULL,
  PRIMARY KEY (`uom_id`),
  UNIQUE KEY `uk_uom_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `category` (
  `category_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `parent_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  KEY `idx_category_parent` (`parent_id`),
  CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `warehouse` (
  `warehouse_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(500) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`warehouse_id`),
  UNIQUE KEY `uk_warehouse_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `carrier` (
  `carrier_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `carrier_type` varchar(50) NOT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `note` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`carrier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `customer` (
  `customer_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `uk_customer_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `supplier` (
  `supplier_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  PRIMARY KEY (`supplier_id`),
  UNIQUE KEY `uk_supplier_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------
-- 2. Nhóm Phân quyền & Người dùng
-- ------------------------------------------------------

CREATE TABLE `role` (
  `role_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uk_role_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `permission` (
  `permission_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(120) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `uk_permission_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `role_permission` (
  `role_id` bigint unsigned NOT NULL,
  `permission_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `idx_role_permission_permission` (`permission_id`),
  CONSTRAINT `fk_role_permission_permission` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`permission_id`),
  CONSTRAINT `fk_role_permission_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `user` (
  `user_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(80) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `status` varchar(30) NOT NULL,
  `warehouse_id` bigint unsigned DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login_at` datetime DEFAULT NULL,
  `last_login_ip` varchar(64) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_user_username` (`username`),
  UNIQUE KEY `uk_user_email` (`email`),
  KEY `idx_user_warehouse` (`warehouse_id`),
  KEY `idx_user_created_by` (`created_by`),
  CONSTRAINT `fk_user_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_user_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `user_role` (
  `user_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `assigned_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `idx_user_role_role` (`role_id`),
  CONSTRAINT `fk_user_role_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  CONSTRAINT `fk_user_role_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------
-- 3. Nhóm Sản phẩm & Cấu trúc Kho
-- ------------------------------------------------------

CREATE TABLE `product` (
  `product_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(80) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category_id` bigint unsigned DEFAULT NULL,
  `base_uom_id` bigint unsigned NOT NULL,
  `barcode` varchar(120) DEFAULT NULL,
  `weight` decimal(18,4) DEFAULT NULL,
  `length` decimal(18,4) DEFAULT NULL,
  `width` decimal(18,4) DEFAULT NULL,
  `height` decimal(18,4) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `uk_product_sku` (`sku`),
  KEY `idx_product_category` (`category_id`),
  KEY `idx_product_uom` (`base_uom_id`),
  CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`),
  CONSTRAINT `fk_product_uom` FOREIGN KEY (`base_uom_id`) REFERENCES `uom` (`uom_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `product_variant` (
  `variant_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint unsigned NOT NULL,
  `variant_sku` varchar(80) NOT NULL,
  `color` varchar(60) DEFAULT NULL,
  `size` varchar(60) DEFAULT NULL,
  `barcode` varchar(120) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  PRIMARY KEY (`variant_id`),
  UNIQUE KEY `uk_variant_sku` (`variant_sku`),
  KEY `idx_variant_product` (`product_id`),
  CONSTRAINT `fk_variant_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `zone` (
  `zone_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `warehouse_id` bigint unsigned NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `zone_type` varchar(50) NOT NULL,
  `status` varchar(30) NOT NULL,
  PRIMARY KEY (`zone_id`),
  KEY `idx_zone_warehouse` (`warehouse_id`),
  CONSTRAINT `fk_zone_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `slot` (
  `slot_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `zone_id` bigint unsigned NOT NULL,
  `code` varchar(80) NOT NULL,
  `row_no` int DEFAULT NULL,
  `col_no` int DEFAULT NULL,
  `max_capacity` decimal(18,4) DEFAULT NULL,
  `capacity_uom` varchar(20) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  PRIMARY KEY (`slot_id`),
  UNIQUE KEY `uk_slot_code` (`code`),
  KEY `idx_slot_zone` (`zone_id`),
  CONSTRAINT `fk_slot_zone` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------
-- 4. Nhóm Đơn hàng (PO, SO, Transfer)
-- ------------------------------------------------------

CREATE TABLE `purchase_order` (
  `po_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_number` varchar(80) NOT NULL,
  `supplier_id` bigint unsigned NOT NULL,
  `expected_delivery_date` date DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `imported_by` bigint unsigned DEFAULT NULL,
  `imported_at` datetime DEFAULT NULL,
  `source_file_name` varchar(255) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`po_id`),
  UNIQUE KEY `uk_po_number` (`po_number`),
  KEY `idx_po_supplier` (`supplier_id`),
  KEY `idx_po_imported_by` (`imported_by`),
  CONSTRAINT `fk_po_imported_by` FOREIGN KEY (`imported_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_po_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `purchase_order_line` (
  `po_line_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `qty_ordered` decimal(18,4) NOT NULL,
  `unit_price` decimal(18,4) DEFAULT NULL,
  `tax_rate` decimal(9,4) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`po_line_id`),
  KEY `idx_po_line_po` (`po_id`),
  KEY `idx_po_line_variant` (`variant_id`),
  CONSTRAINT `fk_po_line_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`),
  CONSTRAINT `fk_po_line_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sales_order` (
  `so_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `so_number` varchar(80) NOT NULL,
  `customer_id` bigint unsigned NOT NULL,
  `requested_ship_date` date DEFAULT NULL,
  `ship_to_address` varchar(500) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `imported_by` bigint unsigned DEFAULT NULL,
  `imported_at` datetime DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`so_id`),
  UNIQUE KEY `uk_so_number` (`so_number`),
  KEY `idx_so_customer` (`customer_id`),
  KEY `idx_so_imported_by` (`imported_by`),
  CONSTRAINT `fk_so_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `fk_so_imported_by` FOREIGN KEY (`imported_by`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sales_order_line` (
  `so_line_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `so_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `qty_ordered` decimal(18,4) NOT NULL,
  `unit_price` decimal(18,4) DEFAULT NULL,
  `discount` decimal(18,4) DEFAULT NULL,
  PRIMARY KEY (`so_line_id`),
  KEY `idx_so_line_so` (`so_id`),
  KEY `idx_so_line_variant` (`variant_id`),
  CONSTRAINT `fk_so_line_so` FOREIGN KEY (`so_id`) REFERENCES `sales_order` (`so_id`),
  CONSTRAINT `fk_so_line_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `transfer_order` (
  `transfer_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `transfer_number` varchar(80) NOT NULL,
  `from_warehouse_id` bigint unsigned NOT NULL,
  `to_warehouse_id` bigint unsigned NOT NULL,
  `planned_date` date DEFAULT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `approved_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `approved_at` datetime DEFAULT NULL,
  PRIMARY KEY (`transfer_id`),
  UNIQUE KEY `uk_transfer_number` (`transfer_number`),
  KEY `idx_transfer_from_wh` (`from_warehouse_id`),
  KEY `idx_transfer_to_wh` (`to_warehouse_id`),
  KEY `idx_transfer_created_by` (`created_by`),
  KEY `idx_transfer_approved_by` (`approved_by`),
  CONSTRAINT `fk_transfer_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_transfer_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_transfer_from_wh` FOREIGN KEY (`from_warehouse_id`) REFERENCES `warehouse` (`warehouse_id`),
  CONSTRAINT `fk_transfer_to_wh` FOREIGN KEY (`to_warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `transfer_order_line` (
  `transfer_line_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `transfer_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `qty_requested` decimal(18,4) NOT NULL,
  `qty_dispatched` decimal(18,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`transfer_line_id`),
  KEY `idx_transfer_line_transfer` (`transfer_id`),
  KEY `idx_transfer_line_variant` (`variant_id`),
  CONSTRAINT `fk_transfer_line_transfer` FOREIGN KEY (`transfer_id`) REFERENCES `transfer_order` (`transfer_id`),
  CONSTRAINT `fk_transfer_line_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------
-- 5. Nhóm Nghiệp vụ Nhập kho (Inbound)
-- ------------------------------------------------------

CREATE TABLE `goods_receipt` (
  `grn_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `grn_number` varchar(80) NOT NULL,
  `po_id` bigint unsigned NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `status` varchar(30) NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `approved_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `approved_at` datetime DEFAULT NULL,
  `delivered_by` varchar(255) DEFAULT NULL,
  `received_at` datetime DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`grn_id`),
  UNIQUE KEY `uk_grn_number` (`grn_number`),
  KEY `idx_grn_po` (`po_id`),
  KEY `idx_grn_wh` (`warehouse_id`),
  KEY `idx_grn_created_by` (`created_by`),
  KEY `idx_grn_approved_by` (`approved_by`),
  CONSTRAINT `fk_grn_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_grn_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_grn_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`),
  CONSTRAINT `fk_grn_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `goods_receipt_line` (
  `grn_line_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `grn_id` bigint unsigned NOT NULL,
  `po_line_id` bigint unsigned DEFAULT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `qty_expected` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `qty_received` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `qty_good` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `qty_missing` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `qty_damaged` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `qty_extra` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `note` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`grn_line_id`),
  KEY `idx_grn_line_grn` (`grn_id`),
  KEY `idx_grn_line_po_line` (`po_line_id`),
  KEY `idx_grn_line_variant` (`variant_id`),
  CONSTRAINT `fk_grn_line_grn` FOREIGN KEY (`grn_id`) REFERENCES `goods_receipt` (`grn_id`),
  CONSTRAINT `fk_grn_line_po_line` FOREIGN KEY (`po_line_id`) REFERENCES `purchase_order_line` (`po_line_id`),
  CONSTRAINT `fk_grn_line_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `putaway_order` (
  `putaway_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `grn_id` bigint unsigned NOT NULL,
  `status` varchar(30) NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`putaway_id`),
  KEY `idx_putaway_grn` (`grn_id`),
  KEY `idx_putaway_created_by` (`created_by`),
  CONSTRAINT `fk_putaway_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_putaway_grn` FOREIGN KEY (`grn_id`) REFERENCES `goods_receipt` (`grn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `putaway_line` (
  `putaway_line_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `putaway_id` bigint unsigned NOT NULL,
  `grn_line_id` bigint unsigned NOT NULL,
  `to_slot_id` bigint unsigned NOT NULL,
  `qty_putaway` decimal(18,4) NOT NULL,
  `performed_by` bigint unsigned DEFAULT NULL,
  `performed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`putaway_line_id`),
  KEY `idx_putaway_line_putaway` (`putaway_id`),
  KEY `idx_putaway_line_grn_line` (`grn_line_id`),
  KEY `idx_putaway_line_to_slot` (`to_slot_id`),
  KEY `idx_putaway_line_performed_by` (`performed_by`),
  CONSTRAINT `fk_putaway_line_grn_line` FOREIGN KEY (`grn_line_id`) REFERENCES `goods_receipt_line` (`grn_line_id`),
  CONSTRAINT `fk_putaway_line_performed_by` FOREIGN KEY (`performed_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_putaway_line_putaway` FOREIGN KEY (`putaway_id`) REFERENCES `putaway_order` (`putaway_id`),
  CONSTRAINT `fk_putaway_line_to_slot` FOREIGN KEY (`to_slot_id`) REFERENCES `slot` (`slot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------
-- 6. Nhóm Nghiệp vụ Xuất kho (Outbound)
-- ------------------------------------------------------

CREATE TABLE `goods_delivery_note` (
  `gdn_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `gdn_number` varchar(80) NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `so_id` bigint unsigned DEFAULT NULL,
  `transfer_id` bigint unsigned DEFAULT NULL,
  `gdn_type` varchar(30) NOT NULL,
  `status` varchar(30) NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `confirmed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`gdn_id`),
  UNIQUE KEY `uk_gdn_number` (`gdn_number`),
  KEY `idx_gdn_wh` (`warehouse_id`),
  KEY `idx_gdn_so` (`so_id`),
  KEY `idx_gdn_transfer` (`transfer_id`),
  KEY `idx_gdn_created_by` (`created_by`),
  CONSTRAINT `fk_gdn_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_gdn_so` FOREIGN KEY (`so_id`) REFERENCES `sales_order` (`so_id`),
  CONSTRAINT `fk_gdn_transfer` FOREIGN KEY (`transfer_id`) REFERENCES `transfer_order` (`transfer_id`),
  CONSTRAINT `fk_gdn_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `goods_delivery_line` (
  `gdn_line_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `gdn_id` bigint unsigned NOT NULL,
  `so_line_id` bigint unsigned DEFAULT NULL,
  `transfer_line_id` bigint unsigned DEFAULT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `qty_required` decimal(18,4) NOT NULL,
  `qty_picked` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `qty_packed` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `qty_shipped` decimal(18,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`gdn_line_id`),
  KEY `idx_gdn_line_gdn` (`gdn_id`),
  KEY `idx_gdn_line_so_line` (`so_line_id`),
  KEY `idx_gdn_line_transfer_line` (`transfer_line_id`),
  KEY `idx_gdn_line_variant` (`variant_id`),
  CONSTRAINT `fk_gdn_line_gdn` FOREIGN KEY (`gdn_id`) REFERENCES `goods_delivery_note` (`gdn_id`),
  CONSTRAINT `fk_gdn_line_so_line` FOREIGN KEY (`so_line_id`) REFERENCES `sales_order_line` (`so_line_id`),
  CONSTRAINT `fk_gdn_line_transfer_line` FOREIGN KEY (`transfer_line_id`) REFERENCES `transfer_order_line` (`transfer_line_id`),
  CONSTRAINT `fk_gdn_line_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `pick_wave` (
  `wave_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `gdn_id` bigint unsigned NOT NULL,
  `status` varchar(30) NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`wave_id`),
  KEY `idx_wave_gdn` (`gdn_id`),
  KEY `idx_wave_created_by` (`created_by`),
  CONSTRAINT `fk_wave_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_wave_gdn` FOREIGN KEY (`gdn_id`) REFERENCES `goods_delivery_note` (`gdn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `pick_task` (
  `pick_task_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `wave_id` bigint unsigned NOT NULL,
  `assigned_to` bigint unsigned DEFAULT NULL,
  `assigned_by` bigint unsigned DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `assigned_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`pick_task_id`),
  KEY `idx_pick_task_wave` (`wave_id`),
  KEY `idx_pick_task_assigned_to` (`assigned_to`),
  KEY `idx_pick_task_assigned_by` (`assigned_by`),
  CONSTRAINT `fk_pick_task_assigned_by` FOREIGN KEY (`assigned_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_pick_task_assigned_to` FOREIGN KEY (`assigned_to`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_pick_task_wave` FOREIGN KEY (`wave_id`) REFERENCES `pick_wave` (`wave_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `pick_task_line` (
  `pick_line_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pick_task_id` bigint unsigned NOT NULL,
  `gdn_line_id` bigint unsigned NOT NULL,
  `from_slot_id` bigint unsigned NOT NULL,
  `qty_to_pick` decimal(18,4) NOT NULL,
  `qty_picked` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `pick_status` varchar(30) NOT NULL,
  `note` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`pick_line_id`),
  KEY `idx_pick_line_task` (`pick_task_id`),
  KEY `idx_pick_line_gdn_line` (`gdn_line_id`),
  KEY `idx_pick_line_from_slot` (`from_slot_id`),
  CONSTRAINT `fk_pick_line_from_slot` FOREIGN KEY (`from_slot_id`) REFERENCES `slot` (`slot_id`),
  CONSTRAINT `fk_pick_line_gdn_line` FOREIGN KEY (`gdn_line_id`) REFERENCES `goods_delivery_line` (`gdn_line_id`),
  CONSTRAINT `fk_pick_line_task` FOREIGN KEY (`pick_task_id`) REFERENCES `pick_task` (`pick_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `packing` (
  `pack_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `gdn_id` bigint unsigned NOT NULL,
  `status` varchar(30) NOT NULL,
  `packed_by` bigint unsigned DEFAULT NULL,
  `packed_at` datetime DEFAULT NULL,
  `package_label` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pack_id`),
  KEY `idx_packing_gdn` (`gdn_id`),
  KEY `idx_packing_packed_by` (`packed_by`),
  CONSTRAINT `fk_packing_gdn` FOREIGN KEY (`gdn_id`) REFERENCES `goods_delivery_note` (`gdn_id`),
  CONSTRAINT `fk_packing_packed_by` FOREIGN KEY (`packed_by`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `shipment` (
  `shipment_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `shipment_number` varchar(80) NOT NULL,
  `gdn_id` bigint unsigned NOT NULL,
  `carrier_id` bigint unsigned DEFAULT NULL,
  `shipment_type` varchar(30) NOT NULL,
  `status` varchar(30) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `picked_up_at` datetime DEFAULT NULL,
  `delivered_at` datetime DEFAULT NULL,
  `tracking_code` varchar(120) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`shipment_id`),
  UNIQUE KEY `uk_shipment_number` (`shipment_number`),
  KEY `idx_shipment_gdn` (`gdn_id`),
  KEY `idx_shipment_carrier` (`carrier_id`),
  CONSTRAINT `fk_shipment_carrier` FOREIGN KEY (`carrier_id`) REFERENCES `carrier` (`carrier_id`),
  CONSTRAINT `fk_shipment_gdn` FOREIGN KEY (`gdn_id`) REFERENCES `goods_delivery_note` (`gdn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------
-- 7. Nhóm Kiểm kê & Điều chỉnh (Inventory Audit)
-- ------------------------------------------------------

CREATE TABLE `inventory_count` (
  `count_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `count_number` varchar(80) NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `scope_type` varchar(50) NOT NULL,
  `status` varchar(30) NOT NULL,
  `planned_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `freeze_transactions` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` bigint unsigned NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`count_id`),
  UNIQUE KEY `uk_count_number` (`count_number`),
  KEY `idx_count_wh` (`warehouse_id`),
  KEY `idx_count_created_by` (`created_by`),
  CONSTRAINT `fk_count_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_count_wh` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `inventory_count_task` (
  `count_task_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `count_id` bigint unsigned NOT NULL,
  `assigned_to` bigint unsigned DEFAULT NULL,
  `assigned_by` bigint unsigned DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `assigned_at` datetime DEFAULT NULL,
  `done_at` datetime DEFAULT NULL,
  PRIMARY KEY (`count_task_id`),
  KEY `idx_count_task_count` (`count_id`),
  KEY `idx_count_task_assigned_to` (`assigned_to`),
  KEY `idx_count_task_assigned_by` (`assigned_by`),
  CONSTRAINT `fk_count_task_assigned_by` FOREIGN KEY (`assigned_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_count_task_assigned_to` FOREIGN KEY (`assigned_to`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_count_task_count` FOREIGN KEY (`count_id`) REFERENCES `inventory_count` (`count_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `inventory_count_line` (
  `count_line_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `count_task_id` bigint unsigned NOT NULL,
  `slot_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `condition` varchar(30) NOT NULL,
  `qty_system` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `qty_actual` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `qty_diff` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `note` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`count_line_id`),
  KEY `idx_count_line_task` (`count_task_id`),
  KEY `idx_count_line_slot` (`slot_id`),
  KEY `idx_count_line_variant` (`variant_id`),
  CONSTRAINT `fk_count_line_slot` FOREIGN KEY (`slot_id`) REFERENCES `slot` (`slot_id`),
  CONSTRAINT `fk_count_line_task` FOREIGN KEY (`count_task_id`) REFERENCES `inventory_count_task` (`count_task_id`),
  CONSTRAINT `fk_count_line_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `stock_adjustment` (
  `adj_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `adj_number` varchar(80) NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `count_id` bigint unsigned DEFAULT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `approved_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `approved_at` datetime DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`adj_id`),
  UNIQUE KEY `uk_adj_number` (`adj_number`),
  KEY `idx_adj_wh` (`warehouse_id`),
  KEY `idx_adj_count` (`count_id`),
  KEY `idx_adj_created_by` (`created_by`),
  KEY `idx_adj_approved_by` (`approved_by`),
  CONSTRAINT `fk_adj_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_adj_count` FOREIGN KEY (`count_id`) REFERENCES `inventory_count` (`count_id`),
  CONSTRAINT `fk_adj_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_adj_wh` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `stock_adjustment_line` (
  `adj_line_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `adj_id` bigint unsigned NOT NULL,
  `slot_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `condition` varchar(30) NOT NULL,
  `qty_delta` decimal(18,4) NOT NULL,
  PRIMARY KEY (`adj_line_id`),
  KEY `idx_adj_line_adj` (`adj_id`),
  KEY `idx_adj_line_slot` (`slot_id`),
  KEY `idx_adj_line_variant` (`variant_id`),
  CONSTRAINT `fk_adj_line_adj` FOREIGN KEY (`adj_id`) REFERENCES `stock_adjustment` (`adj_id`),
  CONSTRAINT `fk_adj_line_slot` FOREIGN KEY (`slot_id`) REFERENCES `slot` (`slot_id`),
  CONSTRAINT `fk_adj_line_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------
-- 8. Nhóm Tồn kho & Giao dịch kho (Inventory Core)
-- ------------------------------------------------------

CREATE TABLE `inventory_balance` (
  `inv_balance_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `warehouse_id` bigint unsigned NOT NULL,
  `slot_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `condition` varchar(30) NOT NULL,
  `qty_on_hand` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `qty_reserved` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `qty_available` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inv_balance_id`),
  UNIQUE KEY `uk_inv_balance` (`warehouse_id`,`slot_id`,`variant_id`,`condition`),
  KEY `idx_inv_balance_slot` (`slot_id`),
  KEY `idx_inv_balance_variant` (`variant_id`),
  CONSTRAINT `fk_inv_balance_slot` FOREIGN KEY (`slot_id`) REFERENCES `slot` (`slot_id`),
  CONSTRAINT `fk_inv_balance_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`),
  CONSTRAINT `fk_inv_balance_wh` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `inventory_reservation` (
  `reservation_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `warehouse_id` bigint unsigned NOT NULL,
  `gdn_line_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `qty_reserved` decimal(18,4) NOT NULL,
  `status` varchar(30) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reservation_id`),
  KEY `idx_res_wh` (`warehouse_id`),
  KEY `idx_res_gdn_line` (`gdn_line_id`),
  KEY `idx_res_variant` (`variant_id`),
  CONSTRAINT `fk_res_gdn_line` FOREIGN KEY (`gdn_line_id`) REFERENCES `goods_delivery_line` (`gdn_line_id`),
  CONSTRAINT `fk_res_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`),
  CONSTRAINT `fk_res_wh` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `inventory_txn` (
  `txn_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `txn_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `txn_type` varchar(50) NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `from_slot_id` bigint unsigned DEFAULT NULL,
  `to_slot_id` bigint unsigned DEFAULT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `condition` varchar(30) NOT NULL,
  `qty_delta` decimal(18,4) NOT NULL,
  `ref_doc_type` varchar(50) DEFAULT NULL,
  `ref_doc_id` bigint unsigned DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`txn_id`),
  KEY `idx_txn_wh` (`warehouse_id`),
  KEY `idx_txn_variant` (`variant_id`),
  KEY `idx_txn_from_slot` (`from_slot_id`),
  KEY `idx_txn_to_slot` (`to_slot_id`),
  KEY `idx_txn_ref` (`ref_doc_type`,`ref_doc_id`),
  KEY `idx_txn_created_by` (`created_by`),
  CONSTRAINT `fk_txn_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_txn_from_slot` FOREIGN KEY (`from_slot_id`) REFERENCES `slot` (`slot_id`),
  CONSTRAINT `fk_txn_to_slot` FOREIGN KEY (`to_slot_id`) REFERENCES `slot` (`slot_id`),
  CONSTRAINT `fk_txn_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`),
  CONSTRAINT `fk_txn_wh` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------
-- 9. Nhóm Di chuyển & Log (Movement & Logs)
-- ------------------------------------------------------

CREATE TABLE `stock_move` (
  `move_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `move_number` varchar(80) NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `status` varchar(30) NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`move_id`),
  UNIQUE KEY `uk_move_number` (`move_number`),
  KEY `idx_move_wh` (`warehouse_id`),
  KEY `idx_move_created_by` (`created_by`),
  CONSTRAINT `fk_move_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_move_wh` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `stock_move_line` (
  `move_line_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `move_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `from_slot_id` bigint unsigned NOT NULL,
  `to_slot_id` bigint unsigned NOT NULL,
  `qty_moved` decimal(18,4) NOT NULL,
  `moved_at` datetime DEFAULT NULL,
  `moved_by` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`move_line_id`),
  KEY `idx_move_line_move` (`move_id`),
  KEY `idx_move_line_variant` (`variant_id`),
  KEY `idx_move_line_from_slot` (`from_slot_id`),
  KEY `idx_move_line_to_slot` (`to_slot_id`),
  KEY `idx_move_line_moved_by` (`moved_by`),
  CONSTRAINT `fk_move_line_from_slot` FOREIGN KEY (`from_slot_id`) REFERENCES `slot` (`slot_id`),
  CONSTRAINT `fk_move_line_move` FOREIGN KEY (`move_id`) REFERENCES `stock_move` (`move_id`),
  CONSTRAINT `fk_move_line_moved_by` FOREIGN KEY (`moved_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_move_line_to_slot` FOREIGN KEY (`to_slot_id`) REFERENCES `slot` (`slot_id`),
  CONSTRAINT `fk_move_line_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `audit_log` (
  `audit_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `action` varchar(120) NOT NULL,
  `entity_name` varchar(120) NOT NULL,
  `entity_id` bigint unsigned DEFAULT NULL,
  `metadata_json` json DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`audit_id`),
  KEY `idx_audit_user` (`user_id`),
  KEY `idx_audit_entity` (`entity_name`,`entity_id`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bật lại kiểm tra khóa ngoại
SET FOREIGN_KEY_CHECKS = 1;