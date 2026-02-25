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

public class PurchaseOrderImportService {

    private final PurchaseOrderService poService = new PurchaseOrderService();

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
             org.apache.poi.ss.usermodel.Workbook workbook = org.apache.poi.ss.usermodel.WorkbookFactory.create(is)) {

            org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(0);

            String poNumber = null;
            long supplierId = 0;
            Date expectedDate = null;
            String note = "";

            List<POLineCreateDTO> lines = new ArrayList<>();
            Map<String, String> fieldErrors = new LinkedHashMap<>();

            int rowCount = sheet.getPhysicalNumberOfRows();
            if (rowCount <= 1) {
                fieldErrors.put("file", "Excel file is empty or missing data rows.");
            }

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                org.apache.poi.ss.usermodel.Row row = sheet.getRow(i);
                if (row == null) {
                    continue;
                }

                if (i == 1) {
                    poNumber = getCellValueAsString(row.getCell(0));
                    String suppIdStr = getCellValueAsString(row.getCell(1));
                    if (!suppIdStr.isEmpty()) {
                        try {
                            supplierId = (long) Double.parseDouble(suppIdStr);
                        } catch (Exception e) {
                            // ignore, will be caught by validation below
                        }
                    }

                    org.apache.poi.ss.usermodel.Cell dateCell = row.getCell(2);
                    if (dateCell != null) {
                        if (dateCell.getCellType() == org.apache.poi.ss.usermodel.CellType.NUMERIC
                                && org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(dateCell)) {
                            java.util.Date utilDate = dateCell.getDateCellValue();
                            expectedDate = new Date(utilDate.getTime());
                        } else {
                            String dStr = getCellValueAsString(dateCell);
                            try {
                                expectedDate = Date.valueOf(dStr);
                            } catch (Exception e) {
                                // ignore, will be validated below
                            }
                        }
                    }

                    note = getCellValueAsString(row.getCell(3));
                }

                String varIdStr = getCellValueAsString(row.getCell(4));
                String qtyStr = getCellValueAsString(row.getCell(5));
                String priceStr = getCellValueAsString(row.getCell(6));

                if (varIdStr.isEmpty() && qtyStr.isEmpty() && priceStr.isEmpty()) {
                    continue;
                }

                try {
                    long variantId = (long) Double.parseDouble(varIdStr);
                    BigDecimal qty = new BigDecimal(qtyStr);
                    BigDecimal price = new BigDecimal(priceStr);
                    lines.add(new POLineCreateDTO(variantId, qty, price, "VND"));
                } catch (Exception ex) {
                    fieldErrors.put("lines", "Invalid number format in lines at row " + (i + 1));
                }
            }

            if (poNumber == null || poNumber.isBlank()) {
                fieldErrors.put("poNumber", "PO Number is required");
            } else if (poNumber.length() > 20) {
                fieldErrors.put("poNumber", "PO Number must be at most 20 characters");
            } else if (poService.existsByPoNumber(poNumber)) {
                fieldErrors.put("poNumber", "PO Number already exists");
            }

            if (supplierId <= 0) {
                fieldErrors.put("supplierId", "Supplier ID is invalid or missing");
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

            poService.createManualPO(poNumber, supplierId, expectedDate, note, userId, lines);
            return new ImportResult(Collections.emptyMap(), poNumber);
        }
    }

    private String getCellValueAsString(org.apache.poi.ss.usermodel.Cell cell) {
        if (cell == null) {
            return "";
        }
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                if (org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                }
                return String.valueOf(cell.getNumericCellValue());
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                return cell.getCellFormula();
            default:
                return "";
        }
    }
}

