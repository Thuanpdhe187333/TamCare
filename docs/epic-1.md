# **Epic 1: Quản lý người dùng (User management)**

## **Story 1: Xem danh sách người dùng**

### **Description:**

**Là một** Quản trị viên (Admin), **Tôi muốn** xem danh sách toàn bộ người dùng trong hệ thống kèm theo các bộ lọc và công cụ tìm kiếm, **Để** tôi có cái nhìn tổng quan và nhanh chóng tìm được nhân viên cần quản lý.

### **Acceptance Criteria (AT):**

* **Happy Case (Kịch bản chuẩn):**  
  * **AT 1.1:** Hệ thống hiển thị bảng danh sách gồm các cột: Họ tên, Username, Email, Vai trò, Trạng thái (Hoạt động/Khóa), Ngày tạo.  
  * **AT 1.2:** Tìm kiếm theo Username hoặc Họ tên cho kết quả chính xác ngay lập tức hoặc sau khi nhấn nút "Tìm kiếm".  
  * **AT 1.3:** Lọc danh sách theo "Vai trò" (Admin, Warehouse Staff, Manager, Sale) hoặc "Trạng thái".  
* **Alternative Case (Kịch bản thay đổi):**  
  * **AT 1.4:** Phân trang: Nếu danh sách \> 20 người dùng, hệ thống phải phân trang để đảm bảo hiệu năng tải trang.  
  * **AT 1.5:** Sắp xếp: Cho phép sắp xếp tăng/giảm dần theo Họ tên hoặc Ngày tạo.  
* **Exception Case (Kịch bản lỗi/Ngoại lệ):**  
  * **AT 1.6:** Không tìm thấy dữ liệu: Hiển thị thông báo "Không tìm thấy người dùng phù hợp với tiêu chí tìm kiếm".  
  * **AT 1.7:** Lỗi kết nối server: Hiển thị thông báo "Không thể tải dữ liệu, vui lòng thử lại sau".

---

## **Story 2: Tạo mới người dùng**

### **Description:**

**Là một** Quản trị viên (Admin), **Tôi muốn** tạo tài khoản mới cho nhân viên, **Để** họ có quyền truy cập vào hệ thống làm việc.

### **Acceptance Criteria (AT):**

* **Happy Case:**  
  * **AT 2.1:** Admin nhập đầy đủ các trường bắt buộc (\*): Họ tên, Username, Email, Số điện thoại, Vai trò, Kho trực thuộc. Nhấn "Lưu" \-\> Hệ thống tạo thành công và hiển thị thông báo "Tạo người dùng thành công".  
  * **AT 2.2:** Hệ thống tự động gửi một email chứa mật khẩu tạm thời và link đăng nhập đến email của người dùng mới.  
* **Alternative Case:**  
  * **AT 2.3:** Admin có thể chọn trạng thái ban đầu là "Chưa kích hoạt" thay vì "Hoạt động".  
* **Exception Case:**  
  * **AT 2.4 (Trùng lặp):** Nhập Username hoặc Email đã tồn tại trong DB. Hệ thống báo lỗi đỏ tại trường đó: "Tên đăng nhập/Email đã được sử dụng".  
  * **AT 2.5 (Sai định dạng):** Nhập Email không có định dạng `@gmail.com` hoặc Số điện thoại có chứa chữ cái. Hệ thống chặn và báo lỗi "Định dạng không hợp lệ".  
  * **AT 2.6 (Bỏ trống):** Để trống các trường có dấu (\*). Hệ thống không cho phép nhấn "Lưu" và highlight các trường thiếu.

---

## **Story 3: Cập nhật thông tin người dùng**

### **Description:**

**Là một** Quản trị viên (Admin), **Tôi muốn** chỉnh sửa thông tin của một người dùng hiện có, **Để** cập nhật khi có thay đổi về chức vụ, thông tin liên lạc hoặc trạng thái làm việc.

### **Acceptance Criteria (AT):**

* **Happy Case:**  
  * **AT 3.1:** Admin nhấn vào nút "Chỉnh sửa" trên dòng của người dùng. Hệ thống hiển thị form với dữ liệu cũ. Admin sửa thông tin và nhấn "Cập nhật" \-\> Hệ thống lưu thành công.  
  * **AT 3.2:** Khóa/Mở khóa tài khoản: Admin chuyển đổi trạng thái từ "Hoạt động" sang "Khóa". Người dùng đó sẽ bị đẩy ra khỏi hệ thống ngay lập tức (nếu đang đăng nhập) và không thể đăng nhập lại.  
* **Alternative Case:**  
  * **AT 3.3:** Reset mật khẩu: Admin có chức năng "Gửi lại link đặt lại mật khẩu" cho người dùng trong trường hợp họ quên hoặc gặp sự cố.  
* **Exception Case:**  
  * **AT 3.4 (Read-only):** Trường "Username" không được phép chỉnh sửa để đảm bảo tính toàn vẹn của dữ liệu lịch sử (Audit Log).  
  * **AT 3.5 (Xung đột dữ liệu):** Hai Admin cùng sửa 1 user một lúc, người nhấn lưu sau sẽ nhận thông báo: "Dữ liệu đã được thay đổi bởi một người khác, vui lòng tải lại trang".

---

## **Story 4: Xóa người dùng**

### **Description:**

**Là một** Quản trị viên (Admin), **Tôi muốn** xóa một tài khoản ra khỏi danh sách, **Để** dọn dẹp dữ liệu khi nhân viên nghỉ việc hoặc tài khoản tạo sai.

### **Acceptance Criteria (AT):**

* **Happy Case:**  
  * **AT 4.1:** Admin nhấn "Xóa", hệ thống hiển thị popup xác nhận: "Bạn có chắc chắn muốn xóa người dùng \[Tên\] không? Hành động này không thể hoàn tác". Nhấn "Xác nhận" \-\> Xóa thành công.  
* **Alternative Case (Soft Delete \- Khuyên dùng cho WMS):**  
  * **AT 4.2:** Thay vì xóa cứng người dùng khỏi Database, hệ thống sẽ thực hiện xoá mềm bằng cách đánh dấu một flag vào user cần xoá (ví dụ **isDelete \= true**). Người dùng không còn xuất hiện trên UI nhưng dữ liệu lịch sử nhập/xuất kho của họ vẫn được lưu vết để đối soát.  
* **Exception Case:**  
  * **AT 4.3 (Ràng buộc dữ liệu):** Nếu người dùng đang là người chịu trách nhiệm chính của một Phiếu nhập kho (GRN) hoặc Phiếu xuất kho chưa hoàn tất, hệ thống không cho xóa và báo lỗi: "Không thể xóa người dùng đang có giao dịch dở dang. Vui lòng chuyển nhượng công việc trước".  
  * **AT 4.4 (Tự xóa chính mình):** Admin không được phép tự xóa tài khoản của chính mình đang đăng nhập. Nút "Xóa" cho chính bản thân phải bị ẩn hoặc báo lỗi khi thực hiện.

---

## **Story 5: Xem chi tiết người dùng**

### **Description:**

**Là một** Quản trị viên (Admin), **Tôi muốn** truy cập vào trang chi tiết của một tài khoản người dùng, **Để** kiểm tra toàn bộ thông tin cá nhân, lịch sử hoạt động và các phân quyền cụ thể của nhân viên đó.

### **Acceptance Criteria (AT):**

#### **1\. Happy Case (Kịch bản chuẩn)**

* **AT 5.1:** Khi Admin nhấn vào Username hoặc nút "Xem chi tiết" tại danh sách người dùng, hệ thống chuyển hướng đến trang chi tiết của người dùng đó.  
* **AT 5.2:** Hệ thống hiển thị đầy đủ các nhóm thông tin:  
  * **Thông tin cơ bản:** Ảnh đại diện, Họ tên, Username, Email, Số điện thoại.  
  * **Thông tin công việc:** Vai trò (Role), Kho đang làm việc, Ngày tham gia, Trạng thái (Hoạt động/Khóa).  
  * **Thông tin hệ thống:** Người tạo tài khoản, Ngày tạo, Lần đăng nhập cuối cùng, IP đăng nhập gần nhất.  
* **AT 5.3:** Trang chi tiết có các nút điều hướng nhanh: "Chỉnh sửa thông tin", "Reset mật khẩu" và "Quay lại danh sách".

#### **2\. Alternative Case (Kịch bản thay đổi)**

* **AT 5.4 (Lịch sử hoạt động):** Hiển thị danh sách 10 giao dịch gần nhất mà người dùng này đã thực hiện (ví dụ: các phiếu nhập/xuất kho đã tạo hoặc duyệt) để Admin dễ dàng truy vết.  
* **AT 5.5 (Phân quyền chi tiết):** Hiển thị danh sách các quyền cụ thể (Permissions) mà vai trò của người dùng này đang sở hữu dưới dạng bảng hoặc danh sách tích chọn (Chế độ Read-only).

#### **3\. Exception Case (Kịch bản lỗi/Ngoại lệ)**

* **AT 5.6 (Dữ liệu không tồn tại):** Admin cố tình truy cập qua URL bằng một ID người dùng không tồn tại (ví dụ: `/users/999999`). Hệ thống phải hiển thị trang lỗi 404 hoặc thông báo "Người dùng không tồn tại" và nút "Quay lại danh sách".  
* **AT 5.7 (Mất quyền truy cập):** Nếu trong lúc Admin đang xem chi tiết, tài khoản Admin đó bị hạ quyền hoặc tài khoản người dùng đang xem bị xóa bởi một Admin khác, hệ thống phải thông báo: "Bạn không có quyền thực hiện thao tác này hoặc dữ liệu đã bị xóa" khi Admin nhấn các nút chức năng bên trong.  
* **AT 5.8 (Lỗi tải dữ liệu):** Nếu kết nối API bị ngắt quãng, hệ thống hiển thị hiệu ứng Loading và sau đó báo lỗi "Không thể tải dữ liệu chi tiết, vui lòng kiểm tra kết nối mạng".

# 

