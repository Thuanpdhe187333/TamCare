package service;

import dao.WarehouseDAO;
import java.sql.SQLException;
import java.util.List;
import model.Warehouse;

public class WarehouseService {
    private final WarehouseDAO warehouseDao = new WarehouseDAO();

    public List<Warehouse> getAll() throws SQLException {
        return warehouseDao.getAll();
    }
}
