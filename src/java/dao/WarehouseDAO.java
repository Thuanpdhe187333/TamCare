<<<<<<< HEAD
package dao;

import context.DBContext;
import model.Warehouse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class WarehouseDAO extends DBContext {

    public List<Warehouse> getAllActiveWarehouses() throws Exception {
        List<Warehouse> list = new ArrayList<>();
        
        String sql = """
            SELECT 
                warehouse_id,
                code,
                name,
                address,
                status,
                created_at
            FROM warehouse
            WHERE status = 'ACTIVE'
            ORDER BY warehouse_id
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getLong("warehouse_id"));
                w.setCode(rs.getString("code"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                w.setStatus(rs.getString("status"));
                
                java.sql.Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    w.setCreatedAt(ts.toLocalDateTime());
                }
                
                list.add(w);
            }
        }
        
        return list;
    }

    public Warehouse getWarehouseById(Long warehouseId) throws Exception {
        String sql = """
            SELECT 
                warehouse_id,
                code,
                name,
                address,
                status,
                created_at
            FROM warehouse
            WHERE warehouse_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setLong(1, warehouseId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Warehouse w = new Warehouse();
                    w.setWarehouseId(rs.getLong("warehouse_id"));
                    w.setCode(rs.getString("code"));
                    w.setName(rs.getString("name"));
                    w.setAddress(rs.getString("address"));
                    w.setStatus(rs.getString("status"));
                    
                    java.sql.Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        w.setCreatedAt(ts.toLocalDateTime());
                    }
                    
                    return w;
                }
            }
        }
        
        return null;
    }
}
=======
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
>>>>>>> main
