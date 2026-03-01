package service;

import dto.SOLineCreateDTO;
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

/**
 * Import Sale Orders from Excel.
 *
 * Expected columns (row 1, index 0..6):
 *  A: SO Number
 *  B: Customer Code
 *  C: Ship To Address
 *  D: Requested Ship Date (yyyy-MM-dd or Excel date)
 *  E: Variant SKU
 *  F: Quantity
 *  G: Unit Price
 */
public class SaleOrderImportService {

    private final SaleOrderService soService = new SaleOrderService();
    private final CustomerService customerService = new CustomerService();
    private final ProductVariantService productVariantService = new ProductVariantService();
    private static final DataFormatter DATA_FORMATTER = new DataFormatter();

    public static class ImportResult {
        private final Map<String, String> fieldErrors;
        private final String soNumber;

        public ImportResult(Map<String, String> fieldErrors, String soNumber) {
            this.fieldErrors = fieldErrors;
            this.soNumber = soNumber;
        }

        public Map<String, String> getFieldErrors() {
            return fieldErrors;
        }

        public String getSoNumber() {
            return soNumber;
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

            // Row 1: header data for SO
            Row headerRow = sheet.getRow(1);
            String soNumber = getCellValueAsString(headerRow != null ? headerRow.getCell(0) : null);
            String customerCode = getCellValueAsString(headerRow != null ? headerRow.getCell(1) : null);
            String shipToAddress = getCellValueAsString(headerRow != null ? headerRow.getCell(2) : null);
            Date requestedShipDate = parseDateFromCell(headerRow != null ? headerRow.getCell(3) : null);

            // Collect all Variant SKUs from column E for batch lookup
            Set<String> allVariantSkus = new TreeSet<>();
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                String sku = getCellValueAsString(row.getCell(4));
                if (sku != null && !sku.isBlank()) {
                    allVariantSkus.add(sku.trim());
                }
            }

            Long customerId = customerCode != null && !customerCode.isBlank()
                    ? customerService.findIdByCode(customerCode.trim())
                    : null;
            Map<String, Long> skuToVariantId = allVariantSkus.isEmpty()
                    ? Collections.emptyMap()
                    : productVariantService.findIdsBySkus(allVariantSkus);

            // Build lines
            List<SOLineCreateDTO> lines = new ArrayList<>();
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                String variantSku = getCellValueAsString(row.getCell(4));
                String qtyStr = getCellValueAsString(row.getCell(5));
                String priceStr = getCellValueAsString(row.getCell(6));

                if ((variantSku == null || variantSku.isBlank())
                        && (qtyStr == null || qtyStr.isBlank())
                        && (priceStr == null || priceStr.isBlank())) {
                    continue;
                }

                int rowNum = i + 1; // for user-facing messages

                if (variantSku == null || variantSku.isBlank()) {
                    fieldErrors.put("lines_row_" + rowNum, "Row " + rowNum + ": Variant SKU is required");
                    continue;
                }
                variantSku = variantSku.trim();
                Long variantId = skuToVariantId.get(variantSku);
                if (variantId == null) {
                    fieldErrors.put("lines_row_" + rowNum,
                            "Row " + rowNum + ": Variant SKU '" + variantSku + "' not found");
                    continue;
                }

                BigDecimal qty;
                try {
                    if (qtyStr == null || qtyStr.isBlank()) {
                        fieldErrors.put("lines_row_" + rowNum, "Row " + rowNum + ": Quantity is required");
                        continue;
                    }
                    qty = new BigDecimal(qtyStr.trim());
                    if (qty.compareTo(BigDecimal.ZERO) <= 0) {
                        fieldErrors.put("lines_row_" + rowNum,
                                "Row " + rowNum + ": Quantity must be > 0");
                        continue;
                    }
                } catch (Exception e) {
                    fieldErrors.put("lines_row_" + rowNum,
                            "Row " + rowNum + ": Quantity is invalid");
                    continue;
                }

                BigDecimal unitPrice = null;
                if (priceStr != null && !priceStr.isBlank()) {
                    try {
                        unitPrice = new BigDecimal(priceStr.trim());
                        if (unitPrice.compareTo(BigDecimal.ZERO) <= 0) {
                            fieldErrors.put("lines_row_" + rowNum,
                                    "Row " + rowNum + ": Unit Price must be > 0");
                            continue;
                        }
                    } catch (Exception e) {
                        fieldErrors.put("lines_row_" + rowNum,
                                "Row " + rowNum + ": Unit Price is invalid");
                        continue;
                    }
                }

                lines.add(new SOLineCreateDTO(variantId, qty, unitPrice, null));
            }

            // Header validation
            if (soNumber == null || soNumber.isBlank()) {
                fieldErrors.put("soNumber", "SO Number is required");
            } else if (soNumber.length() > 20) {
                fieldErrors.put("soNumber", "SO Number must be at most 20 characters");
            } else if (soService.existsBySoNumber(soNumber)) {
                fieldErrors.put("soNumber", "SO Number already exists");
            }

            if (customerCode == null || customerCode.isBlank()) {
                fieldErrors.put("customerCode", "Customer Code is required");
            } else if (customerId == null) {
                fieldErrors.put("customerCode", "Customer code not found");
            }

            if (shipToAddress == null || shipToAddress.isBlank()) {
                fieldErrors.put("shipToAddress", "Ship To Address is required");
            } else if (shipToAddress.length() >= 200) {
                fieldErrors.put("shipToAddress", "Ship To Address is too long");
            }

            if (requestedShipDate == null) {
                fieldErrors.put("requestedShipDate", "Requested Ship Date is invalid or missing");
            } else if (!requestedShipDate.toLocalDate().isAfter(java.time.LocalDate.now())) {
                fieldErrors.put("requestedShipDate", "Requested Ship Date must be after today");
            }

            if (lines.isEmpty()) {
                fieldErrors.putIfAbsent("lines", "At least one valid line is required");
            }

            if (!fieldErrors.isEmpty()) {
                return new ImportResult(fieldErrors, null);
            }

            soService.createImportedSO(
                    soNumber,
                    customerId,
                    requestedShipDate,
                    shipToAddress,
                    userId,
                    lines
            );

            return new ImportResult(Collections.emptyMap(), soNumber);
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
                    if (d == null) {
                        return "";
                    }
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
        if (cell == null) {
            return null;
        }
        try {
            if (cell.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(cell)) {
                java.util.Date utilDate = cell.getDateCellValue();
                return utilDate != null ? new Date(utilDate.getTime()) : null;
            }
            String dStr = getCellValueAsString(cell);
            if (dStr == null || dStr.isBlank()) {
                return null;
            }
            return Date.valueOf(dStr.trim());
        } catch (Exception e) {
            return null;
        }
    }
}

