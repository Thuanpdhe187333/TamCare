package service;

import dto.POLineCreateDTO;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

public class PurchaseOrderImportService {
    private final PurchaseOrderService poService = new PurchaseOrderService();
    private final SupplierService supplierService = new SupplierService();
    private final ProductVariantService productVariantService = new ProductVariantService();
    private static final DataFormatter DATA_FORMATTER = new DataFormatter();
    public static class ImportResult {
        private final Map<String, String> fieldErrors;
        private final String poNumber;

        public ImportResult(Map<String, String> fieldErrors, String poNumber) {
            this.fieldErrors = fieldErrors;
            this.poNumber = poNumber;
        }

        public Map<String, String> getFieldErrors() {
            return fieldErrors;
        }

        public String getPoNumber() {
            return poNumber;
        }

        public boolean hasErrors() {
            return fieldErrors != null && !fieldErrors.isEmpty();
        }
    }

    public ImportResult importFromExcel(Part filePart, Long userId) throws Exception {
        try (InputStream is = filePart.getInputStream();
             Workbook workbook = WorkbookFactory.create(is)) {
            Sheet sheet = workbook.getSheetAt(0);
            Map<String, String> fieldErrors = new LinkedHashMap<>();

            int rowCount = sheet.getPhysicalNumberOfRows();
            if (rowCount <= 1) {
                fieldErrors.put("file", "Excel file is empty or missing data rows.");
                return new ImportResult(fieldErrors, null);
            }

            // ---- Row 1 (index 1): header - PO Number, Supplier Code, Expected Date, Note ----
            Row headerRow = sheet.getRow(1);
            String poNumber = getCellValueAsString(headerRow != null ? headerRow.getCell(0) : null);
            String supplierCode = getCellValueAsString(headerRow != null ? headerRow.getCell(1) : null);
            Date expectedDate = parseDateFromCell(headerRow != null ? headerRow.getCell(2) : null);
            String note = getCellValueAsString(headerRow != null ? headerRow.getCell(3) : null);

            // ---- Collect all variant SKUs from column E (index 4) for batch lookup ----
            Set<String> allVariantSkus = new TreeSet<>();
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                String sku = getCellValueAsString(row.getCell(4));
                if (sku != null && !sku.isBlank()) {
                    allVariantSkus.add(sku.trim());
                }
            }

            // ---- Batch lookups (one query each) ----
            Long supplierId = supplierCode != null && !supplierCode.isBlank()
                    ? supplierService.findIdByCode(supplierCode.trim())
                    : null;
            Map<String, Long> skuToVariantId = allVariantSkus.isEmpty()
                    ? Collections.emptyMap()
                    : productVariantService.findIdsBySkus(allVariantSkus);

            // ---- Build lines and collect per-row errors ----
            List<POLineCreateDTO> lines = new ArrayList<>();
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                String variantSku = getCellValueAsString(row.getCell(4));
                String qtyStr = getCellValueAsString(row.getCell(5));
                String priceStr = getCellValueAsString(row.getCell(6));

                if (variantSku.isBlank() && qtyStr.isBlank() && priceStr.isBlank()) {
                    continue;
                }

                int rowNum = i + 1; // 1-based for user message

                if (variantSku == null || variantSku.isBlank()) {
                    fieldErrors.put("lines_row_" + rowNum, "Row " + rowNum + ": Variant SKU is required");
                    continue;
                }
                variantSku = variantSku.trim();
                Long variantId = skuToVariantId.get(variantSku);
                if (variantId == null) {
                    fieldErrors.put("lines_row_" + rowNum, "Row " + rowNum + ": Variant SKU '" + variantSku + "' not found");
                    continue;
                }

                BigDecimal qty;
                BigDecimal price;
                try {
                    if (qtyStr == null || qtyStr.isBlank()) {
                        fieldErrors.put("lines_row_" + rowNum, "Row " + rowNum + ": Invalid qty/price");
                        continue;
                    }
                    qty = new BigDecimal(qtyStr.trim());
                    if (qty.compareTo(BigDecimal.ZERO) <= 0) {
                        fieldErrors.put("lines_row_" + rowNum, "Row " + rowNum + ": Invalid qty/price");
                        continue;
                    }
                } catch (Exception e) {
                    fieldErrors.put("lines_row_" + rowNum, "Row " + rowNum + ": Invalid qty/price");
                    continue;
                }
                try {
                    if (priceStr == null || priceStr.isBlank()) {
                        fieldErrors.put("lines_row_" + rowNum, "Row " + rowNum + ": Invalid qty/price");
                        continue;
                    }
                    price = new BigDecimal(priceStr.trim());
                    if (price.compareTo(BigDecimal.ZERO) <= 0) {
                        fieldErrors.put("lines_row_" + rowNum, "Row " + rowNum + ": Invalid qty/price");
                        continue;
                    }
                } catch (Exception e) {
                    fieldErrors.put("lines_row_" + rowNum, "Row " + rowNum + ": Invalid qty/price");
                    continue;
                }

                lines.add(new POLineCreateDTO(variantId, qty, price, "VND"));
            }

            // ---- Header validation (order: header first, then line errors) ----
            if (poNumber == null || poNumber.isBlank()) {
                fieldErrors.put("poNumber", "PO Number is required");
            } else if (poNumber.length() > 20) {
                fieldErrors.put("poNumber", "PO Number must be at most 20 characters");
            } else if (poService.existsByPoNumber(poNumber)) {
                fieldErrors.put("poNumber", "PO Number already exists");
            }
            if (supplierCode == null || supplierCode.isBlank()) {
                fieldErrors.put("supplierCode", "Supplier Code is required");
            } else if (supplierId == null) {
                fieldErrors.put("supplierCode", "Supplier code not found");
            }
            if (expectedDate == null) {
                fieldErrors.put("expectedDeliveryDate", "Expected Delivery Date is invalid or missing");
            } else if (!expectedDate.toLocalDate().isAfter(java.time.LocalDate.now())) {
                fieldErrors.put("expectedDeliveryDate", "Expected Delivery Date must be after today");
            }
            if (lines.isEmpty()) {
                fieldErrors.putIfAbsent("lines", "At least one valid line is required");
            }

            if (!fieldErrors.isEmpty()) {
                return new ImportResult(fieldErrors, null);
            }

            // Import => status = IMPORTED
            poService.createImportedPO(poNumber, supplierId, expectedDate, note != null ? note : "", userId, lines);
            return new ImportResult(Collections.emptyMap(), poNumber);
        }
    }

    private String getCellValueAsString(Cell cell) {
        if (cell == null) {
            return "";
        }
        CellType type = cell.getCellType();
        if (type == CellType.STRING) {
            String s = cell.getStringCellValue();
            return s == null ? "" : s.trim();
        }
        if (type == CellType.NUMERIC) {
            if (DateUtil.isCellDateFormatted(cell)) {
                try {
                    java.util.Date d = cell.getDateCellValue();
                    if (d == null) return "";
                    return new java.text.SimpleDateFormat("yyyy-MM-dd").format(d);
                } catch (Exception e) {
                    return DATA_FORMATTER.formatCellValue(cell);
                }
            }
            return DATA_FORMATTER.formatCellValue(cell);
        }
        if (type == CellType.BOOLEAN) {
            return String.valueOf(cell.getBooleanCellValue());
        }
        if (type == CellType.FORMULA) {
            return DATA_FORMATTER.formatCellValue(cell);
        }
        return "";
    }

    private Date parseDateFromCell(Cell cell) {
        if (cell == null) return null;
        try {
            if (cell.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(cell)) {
                java.util.Date utilDate = cell.getDateCellValue();
                return utilDate != null ? new Date(utilDate.getTime()) : null;
            }
            String dStr = getCellValueAsString(cell);
            if (dStr == null || dStr.isBlank()) return null;
            return Date.valueOf(dStr.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
