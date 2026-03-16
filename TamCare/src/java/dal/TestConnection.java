package dal;

import model.Product;
import java.util.List;

public class TestConnection {
    public static void main(String[] args) {
        // 1. Khởi tạo DAO
        ProductDAO dao = new ProductDAO();
        
        // 2. Gọi hàm lấy danh sách sản phẩm
        System.out.println("--- ĐANG KIỂM TRA KẾT NỐI DATABASE ---");
        List<Product> list = dao.getAllProducts();
        
        // 3. Kiểm tra kết quả
        if (list == null) {
            System.out.println("❌ LỖI: Danh sách trả về bị NULL. Kiểm tra lại DBContext!");
        } else if (list.isEmpty()) {
            System.out.println("⚠️ CẢNH BÁO: Kết nối thành công nhưng bảng 'Products' đang TRỐNG.");
            System.out.println("Hãy chạy câu lệnh INSERT trong SQL Server trước khi test.");
        } else {
            System.out.println("✅ THÀNH CÔNG! Đã tìm thấy " + list.size() + " sản phẩm.");
            System.out.println("----------------------------------------");
            
            // In thử thông tin sản phẩm đầu tiên
            for (Product p : list) {
                System.out.println("ID: " + p.getId());
                System.out.println("Tên: " + p.getProductName());
                System.out.println("Giá: " + p.getPrice());
                System.out.println("Ảnh: " + p.getImageUrl());
                System.out.println("Thong tin san pham: " + p.getProductDescription());
                System.out.println("----------------------------------------");
            }
        }
    }
}