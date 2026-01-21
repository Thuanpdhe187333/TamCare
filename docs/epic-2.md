# **Epic 2: Quản lý tài khoản (User Profile Management)**

### **Story 1: Xem profile cá nhân**

### **Description:**

**Là một** người dùng hệ thống (Nhân viên kho, Sale, Admin...), **Tôi muốn** truy cập vào trang thông tin cá nhân của mình, **Để** kiểm tra các thông tin hiện tại, vai trò và phạm vi quyền hạn mà tôi đang có.

### **Acceptance Criteria (AT):**

* **Happy Case (Kịch bản chuẩn):**  
  * **AT 1.1:** Sau khi đăng nhập, người dùng nhấn vào Avatar hoặc Tên hiển thị để chọn "Hồ sơ cá nhân". Hệ thống hiển thị đầy đủ các trường thông tin: Họ tên, Username, Email, Số điện thoại, Vai trò, Ngày tham gia, Kho đang làm việc.  
  * **AT 1.2:** Các thông tin nhạy cảm như Vai trò và Username chỉ hiển thị ở chế độ Read-only (Chỉ đọc).  
* **Alternative Case (Kịch bản thay đổi):**  
  * **AT 1.3:** Nếu người dùng chưa tải lên ảnh đại diện, hệ thống hiển thị ảnh mặc định theo chữ cái đầu của tên.  
  * **AT 1.4:** Hiển thị danh sách các quyền (Permissions) cụ thể mà người dùng được phép thực hiện (ví dụ: Được quyền nhập kho, không được quyền duyệt PO).  
* **Exception Case (Kịch bản lỗi/Ngoại lệ):**  
  * **AT 1.5:** Lỗi mất kết nối: Hệ thống không tải được thông tin cá nhân, hiển thị thông báo "Không thể lấy thông tin người dùng, vui lòng tải lại trang (F5)".

---

## **Story 2: Cập nhật thông tin profile cá nhân**

### **Description:**

**Là một** người dùng hệ thống, **Tôi muốn** tự cập nhật thông tin liên lạc và ảnh đại diện của mình, **Để** đảm bảo thông tin của tôi trên hệ thống luôn chính xác và dễ nhận diện.

### **Acceptance Criteria (AT):**

* **Happy Case (Kịch bản chuẩn):**  
  * **AT 2.1:** Người dùng thay đổi Họ tên hoặc Số điện thoại, nhấn "Lưu thay đổi".  Hệ thống cập nhật dữ liệu và hiển thị thông báo "Cập nhật hồ sơ thành công".  
  * **AT 2.2:** Người dùng tải lên ảnh đại diện mới (định dạng .jpg, .png, dung lượng \< 2MB). Hệ thống hiển thị bản xem trước (preview) và lưu thành công.  
* **Alternative Case (Kịch bản thay đổi):**  
  * **AT 2.3:** Thay đổi Email: Khi người dùng nhập Email mới, hệ thống gửi một mã OTP hoặc Link xác nhận đến Email mới. Email chỉ chính thức thay đổi sau khi người dùng xác nhận.  
  * **AT 2.4:** Người dùng nhấn "Hủy" sau khi đã chỉnh sửa nhưng chưa lưu \-\> Hệ thống hiển thị cảnh báo: "Các thay đổi chưa được lưu, bạn có chắc muốn thoát?".  
* **Exception Case (Kịch bản lỗi/Ngoại lệ):**  
  * **AT 2.5 (Sai định dạng):** Nhập Số điện thoại quá ngắn, quá dài hoặc chứa ký tự đặc biệt. Hệ thống báo lỗi: "Số điện thoại không hợp lệ".  
  * **AT 2.6 (Lỗi tệp tin):** Người dùng tải lên file không phải định dạng ảnh hoặc file quá lớn (\> 2MB). Hệ thống chặn và báo lỗi: "Chỉ hỗ trợ file ảnh JPG/PNG dưới 2MB".  
  * **AT 2.7 (Trùng dữ liệu):** Cập nhật Email mới nhưng Email này đã thuộc về một tài khoản khác trong hệ thống. Hệ thống báo lỗi: "Email đã tồn tại trên hệ thống".  
  * **AT 2.8 (Truy cập trái phép):** Người dùng cố tình thay đổi ID trên URL để sửa profile của người khác. Hệ thống phải chặn và trả về lỗi "403 Forbidden" hoặc quay về profile của chính họ.

