Bản thiết kế cơ sở dữ liệu (ERD) mà bạn cung cấp là một hệ thống Quản lý Kho hàng (Warehouse Management System - WMS) rất toàn diện và có cấu trúc chặt chẽ. Hệ thống này bao gồm đầy đủ các quy trình từ quản lý danh mục, nhập kho, xuất kho, điều chuyển nội bộ đến kiểm kê.

Dưới đây là phân tích chi tiết các phân hệ chính trong thiết kế này:

---

### 1. Phân hệ Quản trị Hệ thống (System & Security)

Đây là nền tảng để kiểm soát truy cập và theo dõi hoạt động của người dùng.

- **USER, ROLE, PERMISSION**: Sử dụng mô hình RBAC (Role-Based Access Control) để phân quyền chi tiết. Một người dùng có thể có nhiều vai trò, và mỗi vai trò có các quyền hạn cụ thể.

- **AUDIT_LOG**: Lưu lại mọi hoạt động thay đổi dữ liệu để phục vụ việc tra soát và bảo mật.

- **WAREHOUSE**: Thực thể gốc, quản lý danh sách các kho hàng trong hệ thống.

### 2. Quản lý Danh mục và Vị trí (Master Data & Location)

Hệ thống quản lý hàng hóa theo phân cấp và vị trí lưu trữ chính xác.

- **Cấu trúc kho**: `WAREHOUSE` -> `ZONE` (Khu vực) -> `SLOT` (Vị trí/Ô kệ). Điều này cho phép định vị chính xác hàng hóa đang nằm ở đâu.

- **Sản phẩm**: Được quản lý qua `CATEGORY` (Danh mục), `PRODUCT` (Sản phẩm tổng) và `PRODUCT_VARIANT` (Biến thể sản phẩm - ví dụ: cùng một mẫu áo nhưng khác size, màu).

- **UOM**: Đơn vị tính (kg, thùng, cái...) giúp chuẩn hóa định lượng.

### 3. Quy trình Nhập kho (Inbound Process)

Quy trình đi từ đơn mua hàng đến khi hàng nằm trên kệ.

- **PURCHASE_ORDER (PO)**: Đơn đặt hàng từ nhà cung cấp (`SUPPLIER`).

- **GOODS_RECEIPT (GRN)**: Phiếu nhập kho khi hàng về tới cổng kho. Hệ thống đối chiếu `GOODS_RECEIPT_LINE` với `PURCHASE_ORDER_LINE` để kiểm soát số lượng khớp hay lệch.

- **PUTAWAY_ORDER**: Lệnh cất hàng. Sau khi nhận hàng, hệ thống tạo lệnh để nhân viên di chuyển hàng từ khu vực nhận hàng vào các `SLOT` (vị trí) cụ thể.

### 4. Quy trình Xuất kho (Outbound Process)

Quy trình từ đơn bán hàng đến khi giao cho đơn vị vận chuyển.

- **SALES_ORDER (SO)**: Đơn đặt hàng từ khách hàng (`CUSTOMER`).

- **GOODS_DELIVERY_NOTE (GDN)**: Phiếu xuất kho, được tạo dựa trên SO.

- **Picking & Packing**:
- **PICK_WAVE & PICK_TASK**: Gom nhiều đơn hàng để đi lấy hàng một lần (Wave) và chia thành các nhiệm vụ lấy hàng cụ thể (`PICK_TASK`) tại các `SLOT`.

- **PACKING**: Sau khi lấy hàng xong, hàng được đóng gói và dán nhãn.

- **SHIPMENT**: Quản lý việc bàn giao cho đơn vị vận chuyển (`CARRIER`) và theo dõi mã vận đơn (tracking code).

### 5. Quản lý Tồn kho và Vận hành Nội bộ (Inventory & Internal)

Phần lõi để đảm bảo số liệu thực tế luôn khớp với hệ thống.

- **INVENTORY_BALANCE**: Bảng quan trọng nhất, lưu số lượng tồn thực tế của từng `PRODUCT_VARIANT` tại từng `SLOT` trong kho.

- **INVENTORY_RESERVATION**: Giữ chỗ hàng hóa cho các đơn xuất kho đang chờ xử lý, giúp tránh tình trạng bán quá số lượng thực tế (overselling).

- **INVENTORY_TXN**: Nhật ký giao dịch kho. Mọi biến động tăng/giảm, di chuyển hàng đều được ghi lại để truy xuất lịch sử.

- **Kiểm kê (Inventory Count)**: Quy trình tạo đợt kiểm kê (`INVENTORY_COUNT`), thực hiện đợt kiểm (`TASK`) và điều chỉnh số lượng (`STOCK_ADJUSTMENT`) nếu có sai lệch giữa số hệ thống và thực tế.

- **TRANSFER_ORDER**: Điều chuyển hàng hóa giữa các kho khác nhau (`from_warehouse` sang `to_warehouse`).

---

**Đánh giá chung:**
Thiết kế này rất chuyên nghiệp vì tách biệt được **Hàng hóa tổng quát (Product)** và **Hàng hóa thực tế tại vị trí (Inventory Balance)**. Việc quản lý theo `SLOT` và có quy trình `PICKING/PUTAWAY` riêng biệt cho thấy đây là hệ thống dành cho các kho có quy mô trung bình đến lớn, yêu cầu độ chính xác cao về vị trí.

Bạn có muốn tôi đi sâu vào giải thích logic của một quy trình cụ thể (ví dụ: Quy trình kiểm kê hoặc Quy trình xuất kho) không?
