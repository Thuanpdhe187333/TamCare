package service;

import dao.SupplierDAO;
import dto.SupplierDTO;
import java.util.List;

public class SupplierService {
    private final SupplierDAO supplierDao;

    public SupplierService() {
        this.supplierDao = new SupplierDAO();
    }

    public List<SupplierDTO> getActiveSuppliers() throws Exception {
        return supplierDao.getActiveSuppliers();
    }

    /** Returns supplier_id for the given code, or null if not found. */
    public Long findIdByCode(String code) throws Exception {
        return supplierDao.findIdByCode(code);
    }
}
