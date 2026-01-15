# Warehouse management system
## Technology
- JDK17
- Tomcat 10.1.50
- Netbean 17
- Database MySQl
## Coding Convention
- Variable, Function = CamelCase
- const = caplock
- class, interface = PascalCase
## folder structure
- common: Lưu trữ các biến toàn cục
- entity : Reflect các bảng trong DB không được tùy ý sửa đổi các trường trong entity
- controller: Xử lý logic 
- DAO: tương tác với database, khai báo interface đồng bộ code trong các DAO
- Context: Kết nối DB
- util: chứa các hàm tiện ích (validate,...)
- service: Xử lý logic nghiệp vụ