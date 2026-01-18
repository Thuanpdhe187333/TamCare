-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: wms_db
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carrier`
--

DROP TABLE IF EXISTS `carrier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrier` (
  `carrier_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `carrier_type` varchar(50) NOT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `note` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`carrier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrier`
--

LOCK TABLES `carrier` WRITE;
/*!40000 ALTER TABLE `carrier` DISABLE KEYS */;
/*!40000 ALTER TABLE `carrier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `category_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `parent_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  KEY `idx_category_parent` (`parent_id`),
  CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods_delivery_line`
--

DROP TABLE IF EXISTS `goods_delivery_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods_delivery_line`
--

LOCK TABLES `goods_delivery_line` WRITE;
/*!40000 ALTER TABLE `goods_delivery_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `goods_delivery_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods_delivery_note`
--

DROP TABLE IF EXISTS `goods_delivery_note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods_delivery_note`
--

LOCK TABLES `goods_delivery_note` WRITE;
/*!40000 ALTER TABLE `goods_delivery_note` DISABLE KEYS */;
/*!40000 ALTER TABLE `goods_delivery_note` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods_receipt`
--

DROP TABLE IF EXISTS `goods_receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods_receipt`
--

LOCK TABLES `goods_receipt` WRITE;
/*!40000 ALTER TABLE `goods_receipt` DISABLE KEYS */;
/*!40000 ALTER TABLE `goods_receipt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods_receipt_line`
--

DROP TABLE IF EXISTS `goods_receipt_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods_receipt_line`
--

LOCK TABLES `goods_receipt_line` WRITE;
/*!40000 ALTER TABLE `goods_receipt_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `goods_receipt_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_balance`
--

DROP TABLE IF EXISTS `inventory_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_balance`
--

LOCK TABLES `inventory_balance` WRITE;
/*!40000 ALTER TABLE `inventory_balance` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_balance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_count`
--

DROP TABLE IF EXISTS `inventory_count`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_count`
--

LOCK TABLES `inventory_count` WRITE;
/*!40000 ALTER TABLE `inventory_count` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_count` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_count_line`
--

DROP TABLE IF EXISTS `inventory_count_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_count_line`
--

LOCK TABLES `inventory_count_line` WRITE;
/*!40000 ALTER TABLE `inventory_count_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_count_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_count_task`
--

DROP TABLE IF EXISTS `inventory_count_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_count_task`
--

LOCK TABLES `inventory_count_task` WRITE;
/*!40000 ALTER TABLE `inventory_count_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_count_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_reservation`
--

DROP TABLE IF EXISTS `inventory_reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_reservation`
--

LOCK TABLES `inventory_reservation` WRITE;
/*!40000 ALTER TABLE `inventory_reservation` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_txn`
--

DROP TABLE IF EXISTS `inventory_txn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_txn`
--

LOCK TABLES `inventory_txn` WRITE;
/*!40000 ALTER TABLE `inventory_txn` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_txn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packing`
--

DROP TABLE IF EXISTS `packing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packing`
--

LOCK TABLES `packing` WRITE;
/*!40000 ALTER TABLE `packing` DISABLE KEYS */;
/*!40000 ALTER TABLE `packing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission` (
  `permission_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(120) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `uk_permission_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pick_task`
--

DROP TABLE IF EXISTS `pick_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pick_task`
--

LOCK TABLES `pick_task` WRITE;
/*!40000 ALTER TABLE `pick_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `pick_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pick_task_line`
--

DROP TABLE IF EXISTS `pick_task_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pick_task_line`
--

LOCK TABLES `pick_task_line` WRITE;
/*!40000 ALTER TABLE `pick_task_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `pick_task_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pick_wave`
--

DROP TABLE IF EXISTS `pick_wave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pick_wave`
--

LOCK TABLES `pick_wave` WRITE;
/*!40000 ALTER TABLE `pick_wave` DISABLE KEYS */;
/*!40000 ALTER TABLE `pick_wave` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_variant`
--

DROP TABLE IF EXISTS `product_variant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variant`
--

LOCK TABLES `product_variant` WRITE;
/*!40000 ALTER TABLE `product_variant` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_variant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_order`
--

DROP TABLE IF EXISTS `purchase_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order`
--

LOCK TABLES `purchase_order` WRITE;
/*!40000 ALTER TABLE `purchase_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_order_line`
--

DROP TABLE IF EXISTS `purchase_order_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order_line`
--

LOCK TABLES `purchase_order_line` WRITE;
/*!40000 ALTER TABLE `purchase_order_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `putaway_line`
--

DROP TABLE IF EXISTS `putaway_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `putaway_line`
--

LOCK TABLES `putaway_line` WRITE;
/*!40000 ALTER TABLE `putaway_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `putaway_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `putaway_order`
--

DROP TABLE IF EXISTS `putaway_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `putaway_order`
--

LOCK TABLES `putaway_order` WRITE;
/*!40000 ALTER TABLE `putaway_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `putaway_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `role_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uk_role_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permission`
--

DROP TABLE IF EXISTS `role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permission` (
  `role_id` bigint unsigned NOT NULL,
  `permission_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `idx_role_permission_permission` (`permission_id`),
  CONSTRAINT `fk_role_permission_permission` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`permission_id`),
  CONSTRAINT `fk_role_permission_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permission`
--

LOCK TABLES `role_permission` WRITE;
/*!40000 ALTER TABLE `role_permission` DISABLE KEYS */;
/*!40000 ALTER TABLE `role_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order`
--

DROP TABLE IF EXISTS `sales_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order`
--

LOCK TABLES `sales_order` WRITE;
/*!40000 ALTER TABLE `sales_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_line`
--

DROP TABLE IF EXISTS `sales_order_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_line`
--

LOCK TABLES `sales_order_line` WRITE;
/*!40000 ALTER TABLE `sales_order_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment`
--

DROP TABLE IF EXISTS `shipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment`
--

LOCK TABLES `shipment` WRITE;
/*!40000 ALTER TABLE `shipment` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slot`
--

DROP TABLE IF EXISTS `slot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slot`
--

LOCK TABLES `slot` WRITE;
/*!40000 ALTER TABLE `slot` DISABLE KEYS */;
/*!40000 ALTER TABLE `slot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_adjustment`
--

DROP TABLE IF EXISTS `stock_adjustment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_adjustment`
--

LOCK TABLES `stock_adjustment` WRITE;
/*!40000 ALTER TABLE `stock_adjustment` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_adjustment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_adjustment_line`
--

DROP TABLE IF EXISTS `stock_adjustment_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_adjustment_line`
--

LOCK TABLES `stock_adjustment_line` WRITE;
/*!40000 ALTER TABLE `stock_adjustment_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_adjustment_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_move`
--

DROP TABLE IF EXISTS `stock_move`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_move`
--

LOCK TABLES `stock_move` WRITE;
/*!40000 ALTER TABLE `stock_move` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_move` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_move_line`
--

DROP TABLE IF EXISTS `stock_move_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_move_line`
--

LOCK TABLES `stock_move_line` WRITE;
/*!40000 ALTER TABLE `stock_move_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_move_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transfer_order`
--

DROP TABLE IF EXISTS `transfer_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transfer_order`
--

LOCK TABLES `transfer_order` WRITE;
/*!40000 ALTER TABLE `transfer_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfer_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transfer_order_line`
--

DROP TABLE IF EXISTS `transfer_order_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transfer_order_line`
--

LOCK TABLES `transfer_order_line` WRITE;
/*!40000 ALTER TABLE `transfer_order_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfer_order_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uom`
--

DROP TABLE IF EXISTS `uom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uom` (
  `uom_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL,
  `name` varchar(120) NOT NULL,
  PRIMARY KEY (`uom_id`),
  UNIQUE KEY `uk_uom_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uom`
--

LOCK TABLES `uom` WRITE;
/*!40000 ALTER TABLE `uom` DISABLE KEYS */;
/*!40000 ALTER TABLE `uom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role` (
  `user_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `assigned_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `idx_user_role_role` (`role_id`),
  CONSTRAINT `fk_user_role_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  CONSTRAINT `fk_user_role_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouse`
--

DROP TABLE IF EXISTS `warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouse` (
  `warehouse_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(500) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`warehouse_id`),
  UNIQUE KEY `uk_warehouse_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warehouse`
--

LOCK TABLES `warehouse` WRITE;
/*!40000 ALTER TABLE `warehouse` DISABLE KEYS */;
/*!40000 ALTER TABLE `warehouse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zone`
--

DROP TABLE IF EXISTS `zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zone`
--

LOCK TABLES `zone` WRITE;
/*!40000 ALTER TABLE `zone` DISABLE KEYS */;
/*!40000 ALTER TABLE `zone` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/* =========================
   CHECK CONSTRAINTS (ALL-IN-ONE)
   Place this block near the end of dump (after all CREATE TABLEs)
   ========================= */

-- USER STATUS
ALTER TABLE `user`
  DROP CHECK IF EXISTS `chk_user_status`,
  ADD CONSTRAINT `chk_user_status`
  CHECK (`status` IN ('ACTIVE','INACTIVE','LOCKED'));

-- CUSTOMER STATUS
ALTER TABLE `customer`
  DROP CHECK IF EXISTS `chk_customer_status`,
  ADD CONSTRAINT `chk_customer_status`
  CHECK (`status` IN ('ACTIVE','INACTIVE'));

-- SUPPLIER STATUS
ALTER TABLE `supplier`
  DROP CHECK IF EXISTS `chk_supplier_status`,
  ADD CONSTRAINT `chk_supplier_status`
  CHECK (`status` IN ('ACTIVE','INACTIVE'));

-- WAREHOUSE STATUS
ALTER TABLE `warehouse`
  DROP CHECK IF EXISTS `chk_warehouse_status`,
  ADD CONSTRAINT `chk_warehouse_status`
  CHECK (`status` IN ('ACTIVE','INACTIVE'));

-- ZONE TYPE + STATUS
ALTER TABLE `zone`
  DROP CHECK IF EXISTS `chk_zone_type`,
  DROP CHECK IF EXISTS `chk_zone_status`,
  ADD CONSTRAINT `chk_zone_type`
  CHECK (`zone_type` IN ('INBOUND','QC','STORAGE','PICKING','PACKING','DAMAGE')),
  ADD CONSTRAINT `chk_zone_status`
  CHECK (`status` IN ('ACTIVE','INACTIVE'));

-- SLOT STATUS
ALTER TABLE `slot`
  DROP CHECK IF EXISTS `chk_slot_status`,
  ADD CONSTRAINT `chk_slot_status`
  CHECK (`status` IN ('ACTIVE','INACTIVE','BLOCKED'));

-- PURCHASE ORDER STATUS
ALTER TABLE `purchase_order`
  DROP CHECK IF EXISTS `chk_po_status`,
  ADD CONSTRAINT `chk_po_status`
  CHECK (`status` IN ('IMPORTED','CANCELLED','CLOSED'));

-- GOODS RECEIPT (GRN) STATUS
ALTER TABLE `goods_receipt`
  DROP CHECK IF EXISTS `chk_grn_status`,
  ADD CONSTRAINT `chk_grn_status`
  CHECK (`status` IN ('DRAFT','PENDING','APPROVED','REJECTED','CANCELLED'));

-- PUTAWAY ORDER STATUS
ALTER TABLE `putaway_order`
  DROP CHECK IF EXISTS `chk_putaway_status`,
  ADD CONSTRAINT `chk_putaway_status`
  CHECK (`status` IN ('CREATED','IN_PROGRESS','DONE','CANCELLED'));

-- SALES ORDER STATUS (same as PO)
ALTER TABLE `sales_order`
  DROP CHECK IF EXISTS `chk_so_status`,
  ADD CONSTRAINT `chk_so_status`
  CHECK (`status` IN ('IMPORTED','CANCELLED','CLOSED'));

-- GOODS DELIVERY NOTE (GDN) TYPE + STATUS
ALTER TABLE `goods_delivery_note`
  DROP CHECK IF EXISTS `chk_gdn_type`,
  DROP CHECK IF EXISTS `chk_gdn_status`,
  ADD CONSTRAINT `chk_gdn_type`
  CHECK (`gdn_type` IN ('CUSTOMER','TRANSFER')),
  ADD CONSTRAINT `chk_gdn_status`
  CHECK (`status` IN ('CREATED','PICKING','PACKING','CONFIRMED','CANCELLED','DONE'));

-- PICK WAVE STATUS
ALTER TABLE `pick_wave`
  DROP CHECK IF EXISTS `chk_pick_wave_status`,
  ADD CONSTRAINT `chk_pick_wave_status`
  CHECK (`status` IN ('CREATED','RELEASED','IN_PROGRESS','DONE','CANCELLED'));

-- PICK TASK STATUS
ALTER TABLE `pick_task`
  DROP CHECK IF EXISTS `chk_pick_task_status`,
  ADD CONSTRAINT `chk_pick_task_status`
  CHECK (`status` IN ('ASSIGNED','IN_PROGRESS','DONE','CANCELLED'));

-- PICK TASK LINE STATUS
ALTER TABLE `pick_task_line`
  DROP CHECK IF EXISTS `chk_pick_line_status`,
  ADD CONSTRAINT `chk_pick_line_status`
  CHECK (`pick_status` IN ('OPEN','PICKED','SHORT','CANCELLED'));

-- PACKING STATUS
ALTER TABLE `packing`
  DROP CHECK IF EXISTS `chk_packing_status`,
  ADD CONSTRAINT `chk_packing_status`
  CHECK (`status` IN ('CREATED','IN_PROGRESS','DONE','CANCELLED'));

-- SHIPMENT TYPE + STATUS
ALTER TABLE `shipment`
  DROP CHECK IF EXISTS `chk_shipment_type`,
  DROP CHECK IF EXISTS `chk_shipment_status`,
  ADD CONSTRAINT `chk_shipment_type`
  CHECK (`shipment_type` IN ('CUSTOMER','TRANSFER')),
  ADD CONSTRAINT `chk_shipment_status`
  CHECK (`status` IN ('CREATED','PICKED_UP','IN_TRANSIT','DELIVERED','CANCELLED'));

-- INVENTORY BALANCE CONDITION
ALTER TABLE `inventory_balance`
  DROP CHECK IF EXISTS `chk_inv_condition`,
  ADD CONSTRAINT `chk_inv_condition`
  CHECK (`condition` IN ('GOOD','DAMAGED','HOLD','MISSING'));

-- INVENTORY TRANSACTION TYPE + CONDITION
ALTER TABLE `inventory_txn`
  DROP CHECK IF EXISTS `chk_txn_type`,
  DROP CHECK IF EXISTS `chk_txn_condition`,
  ADD CONSTRAINT `chk_txn_type`
  CHECK (`txn_type` IN ('RECEIPT','PUTAWAY','PICK','PACK','SHIP','MOVE','ADJUST','RESERVE','UNRESERVE')),
  ADD CONSTRAINT `chk_txn_condition`
  CHECK (`condition` IN ('GOOD','DAMAGED','HOLD','MISSING'));

-- INVENTORY RESERVATION STATUS
ALTER TABLE `inventory_reservation`
  DROP CHECK IF EXISTS `chk_res_status`,
  ADD CONSTRAINT `chk_res_status`
  CHECK (`status` IN ('ACTIVE','RELEASED','CANCELLED'));

-- INVENTORY COUNT SCOPE + STATUS
ALTER TABLE `inventory_count`
  DROP CHECK IF EXISTS `chk_count_scope`,
  DROP CHECK IF EXISTS `chk_count_status`,
  ADD CONSTRAINT `chk_count_scope`
  CHECK (`scope_type` IN ('FULL','ZONE','SLOT','SKU')),
  ADD CONSTRAINT `chk_count_status`
  CHECK (`status` IN ('DRAFT','PLANNED','IN_PROGRESS','DONE','CANCELLED'));

-- INVENTORY COUNT TASK STATUS
ALTER TABLE `inventory_count_task`
  DROP CHECK IF EXISTS `chk_count_task_status`,
  ADD CONSTRAINT `chk_count_task_status`
  CHECK (`status` IN ('ASSIGNED','IN_PROGRESS','DONE','CANCELLED'));

-- STOCK ADJUSTMENT STATUS
ALTER TABLE `stock_adjustment`
  DROP CHECK IF EXISTS `chk_adj_status`,
  ADD CONSTRAINT `chk_adj_status`
  CHECK (`status` IN ('DRAFT','PENDING','APPROVED','REJECTED','CANCELLED'));

-- STOCK MOVE STATUS
ALTER TABLE `stock_move`
  DROP CHECK IF EXISTS `chk_move_status`,
  ADD CONSTRAINT `chk_move_status`
  CHECK (`status` IN ('DRAFT','IN_PROGRESS','DONE','CANCELLED'));

-- STOCK ADJUSTMENT LINE CONDITION
ALTER TABLE `stock_adjustment_line`
  DROP CHECK IF EXISTS `chk_adj_line_condition`,
  ADD CONSTRAINT `chk_adj_line_condition`
  CHECK (`condition` IN ('GOOD','DAMAGED','HOLD','MISSING'));

-- CARRIER TYPE
ALTER TABLE `carrier`
  DROP CHECK IF EXISTS `chk_carrier_type`,
  ADD CONSTRAINT `chk_carrier_type`
  CHECK (`carrier_type` IN ('THIRD_PARTY','INTERNAL'));

-- Dump completed on 2026-01-16 17:57:25
