package dao;

import context.DBContext;
import model.Carrier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarrierDAO extends DBContext {

    /**
     * Get all carriers
     */
    public List<Carrier> getAll() throws Exception {
        String sql = """
                SELECT carrier_id, name, carrier_type, phone, note
                FROM carrier
                ORDER BY name
            """;

        List<Carrier> list = new ArrayList<>();
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Carrier carrier = new Carrier();
                carrier.setCarrierId(rs.getLong("carrier_id"));
                carrier.setName(rs.getString("name"));
                carrier.setCarrierType(rs.getString("carrier_type"));
                carrier.setPhone(rs.getString("phone"));
                carrier.setNote(rs.getString("note"));
                list.add(carrier);
            }
        }
        return list;
    }
}
