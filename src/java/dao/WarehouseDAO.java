package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import context.DBContext;
import model.Warehouse;

public class WarehouseDAO extends DBContext {
  private final Connection conn = DBContext.getConnection();

  public List<Warehouse> getAll() throws SQLException {
    String sql = "SELECT * FROM warehouse";
    PreparedStatement ps = conn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
    List<Warehouse> warehouses = new ArrayList<Warehouse>();
    while (rs.next()) {
      Warehouse warehouse = new Warehouse();
      warehouse.setWarehouseId(rs.getLong("warehouse_id"));
      warehouse.setCode(rs.getString("code"));
      warehouse.setName(rs.getString("name"));
      warehouse.setAddress(rs.getString("address"));
      warehouse.setStatus(rs.getString("status"));
      warehouses.add(warehouse);
    }
    return warehouses;
  }
}
