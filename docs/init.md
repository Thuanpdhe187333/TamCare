## **1\. Xác định bài toán \+ luồng, nghiệp vụ chính**

### **1.1. Bối cảnh & bài toán**

* Doanh nghiệp có **kho hàng quần áo** lưu trữ sản phẩm (ví dụ: công ty bán lẻ / thương mại điện tử).

* Hiện đang quản lý kho bằng **Excel / sổ sách / phần mềm rời rạc**, dẫn tới:

  * Sai lệch tồn kho (trên sổ khác thực tế).

  * Khó truy vết nhập – xuất – tồn theo lô, ngày, vị trí.

  * Xử lý đơn hàng chậm, dễ soạn nhầm, giao thiếu/thừa.

  * Không có báo cáo realtime cho quản lý.

**Bài toán:** Xây dựng hệ thống WMS hỗ trợ quản lý toàn bộ vòng đời hàng hóa (quần áo) trong kho: **nhập – lưu – xuất – kiểm kê – điều chuyển**, đảm bảo dữ liệu chính xác theo **từng mã hàng, từng vị trí**.

---

### **1.2. Các luồng & nghiệp vụ chính**

#### **1\) Luồng nhập hàng (Inbound)**

1. Purchase staff  import file excel/csv PO vào hệ thống.   
- Trong PO: Nhà cung cấp, SKU, số lượng, giá,v.v  
2. Khi PO đến kho:  
- Nhân viên kho kiểm hàng (inspection: good/missing/damaged/extra)  
3. Nhân viên kho tạo phiếu nhập kho (GRN) status \= pending từ PO\_id  \+ nhập số nhận thực tế \+ ghi chú sai lệch  
- Điền các trường dữ liệu: Name, Quantity nhận (hỏng ,mất), bên nhận, bên gửi, ngày gửi, ngày nhận,.......   
- Sau khi điền các thông tin xong, Hệ thống hiển thị màn vị trí trống cho nhân viên kho điền vào.  
- Gán vị trí hàng trong kho

Note: Tồn kho chưa tăng vị trí, số lượng. Phiếu nhập kho với trạng thái pending

4. Quản lý kho approved/ rejected phiếu nhập kho  
5. Nhân viên kho sau khi thấy PHIẾU NHẬP KHO status \= approved

\=\> Sau khi gán vị trí xong,nhân viên mang hàng đã nhập vào kho

6. Hệ thống cập nhật hàng, số lượng, vị trí.

Hệ thống lưu:

- Ai tạo GRN  
- Ai duyệt GRN  
- Ai putaway  
- Thời  gian

#### **2\) Luồng xuất hàng (Outbound) 2 luồng outbound**

NOTE: SO đáp ứng các nhu cầu riêng của mỗi customer.  
Goods Delivery Note: Phiếu xuất kho

1. Xuất cho khách hàng   
   1. Sale staff import excel/csv SO vào hệ thống WMS.  
   2. Quản lý kho có thể thấy màn hình hiển thị danh sách SO đã được import vào hệ thống.  
   3. Quản lý kho chọn create Goods Delivery Note status \= draft/ongoing \=\> chọn SO\_id  
      1. Hệ thống sinh tự động pick list dựa theo SO\_id( CHỈ LẤY THÔNG TIN HÀNG CẦN PICK, SỐ LƯỢNG,..).  
      2. Quản lý kho assign warehouse staff để đi lấy hàng.  
      3. Warehouse staff thực hiện picking  
         1. Login hệ thống.  
         2. Truy cập “My task”.  
         3. Chỉ thấy những Pick Task được assign cho mình.  
         4. Pick xong thì confirm.  
      4. Confirm xong thì hàng trong kho sẽ giảm. (hệ thống cập nhật).  
   4. Từ GDN có status \= confirm ( pick đã đủ, pack đã xong).  
      1. Quản lý kho create shipment   
         1. Nhập SO\_id ( vì Sale Order có thông tin địa chỉ ngày giao cho khách, không nhập GDN\_id).  
         2. Hệ thống sẽ hiển thị thông tin khách hàng, địa chỉ ngày giao  
         3. Manager chọn đơn vị giao hàng.  
         4. Đơn vị giao hàng đến lấy hàng.  
         5. Warehouse staff update status.  
2. Xuất cho kho nội bộ  
   1. Quản lý kho tạo transfer order bao gồm thông tin ( from , to, product, quantity, date, reason,....). CRUD (THÀNH)  
   2. Quản lý kho tạo GDN từ transfer\_order\_id  
      1. Hệ thống sinh pick list tự động,  
      2. Quản lý kho assign warehouse staff để đi lấy hàng.  
      3. Warehouse staff thực hiện picking  
         1. Login hệ thống.  
         2. Truy cập “My task”.  
         3. Chỉ thấy những Pick Task được assign cho mình.  
         4. Pick xong thì confirm.  
   3. Confirm xong thì hàng trong kho sẽ giảm.  
   4. Từ GDN có status \= confirm ( pick đã đủ, pack đã xong).  
      1. Quản lý kho create shipment (xe tải nội bộ công ty)  
         1. Nhập SO\_id ( vì Sale Order có thông tin địa chỉ ngày giao cho khách, không nhập GDN\_id).  
         2. Hệ thống sẽ hiển thị thông tin khách hàng, địa chỉ ngày giao  
         3. Manager chọn đơn vị giao hàng.  
         4. Đơn vị giao hàng đến lấy hàng.  
         5. Warehouse staff update status.

      

            

**3\) Luồng điều chuyển nội bộ**

**4\) Luồng kiểm kê kho (Inventory/ Stock Taking)**

**Mục tiêu:**Đối soát tồn kho trên hệ thống với tồn kho thực tế, phát hiện và xử lý chênh lệch (thừa/ thiếu/ hỏng), đảm bảo dữ liệu tồn kho chính xác theo SKU – lô – vị trí.

**1\. Khởi tạo kế hoạch kiểm kê**

1. Quản lý kho tạo Inventory Count trên hệ thống:  
* Phạm vi kiểm kê:Toàn bộ kho / theo khu vực / theo vị trí / theo SKU  
* Loại kiểm kê:  
- Định kỳ (tháng/quý/năm)  
- Đột xuất  
* Thời gian bắt đầu – kết thúc  
* Ghi chú lý do kiểm kê  
2. Hệ thống sinh Inventory Count ID với status \= draft.

**2\. Chuẩn bị dữ liệu kiểm kê**

1. Khi Inventory Count được activate, hệ thống:  
* Lưu trạng thái số tồn hiện tại theo:  
- SKU  
- Lô (batch)  
- Vị trí (location)  
- Số lượng hệ thống  
* Tạo danh sách Count List (danh sách cần kiểm).  
2. Quản lý kho assign warehouse staff thực hiện kiểm kê: Mỗi staff chỉ thấy các vị trí/SKU được phân công.

**3\. Thực hiện kiểm kê thực tế**

1. Warehouse staff:  
* Login hệ thống  
* Truy cập My Task → Inventory Count

2. Tại từng vị trí:  
* Đếm số lượng thực tế  
* Nhập:  
- Quantity thực tế  
- Tình trạng hàng:  
+ good  
+ damaged  
+ expired (hết mùa)  
- Note

3. Sau khi nhập xong:  
* Staff bấm Submit Count  
* Status của dòng kiểm kê \= counted

**4\. Đối chiếu & phát hiện sai lệch**

**A.** Hệ thống tự động đối chiếu dữ liệu:

* Quantity hệ thống (snapshot)

* Quantity thực tế do warehouse staff nhập

**B.** Hệ thống phân loại kết quả kiểm kê:

* Match (khớp)  
* Shortage (thiếu)  
* Over (thừa)

**C.** Đối với các dòng có sai lệch:

* Hệ thống sinh **Discrepancy Report**  
* Ghi nhận chi tiết sai lệch theo:  
- SKU  
- Vị trí (location)  
- Lô (batch)  
- Số lượng chênh lệch

**5\. Duyệt kết quả kiểm kê**

**A.** Quản lý kho truy cập màn hình **Inventory Count Review**.

**B.** Quản lý kho xem chi tiết từng dòng kiểm kê:

* SKU  
* Vị trí (location)  
* Số lượng hệ thống  
* Số lượng thực tế  
* Chênh lệch  
* Ghi chú của warehouse staff

**C.** Quản lý kho thực hiện:

* Approve  
* Reject (yêu cầu kiểm kê lại)

**D.** Inventory Count Plan status:

* approved  
* rejected

**6\. Điều chỉnh tồn kho (Inventory Adjustment)**

**A.** Khi Inventory Count Plan được **approved**:

* Hệ thống tự động tạo **Inventory Adjustment Document**

**B.** Hệ thống thực hiện điều chỉnh tồn kho:

* Tăng tồn kho (over)  
* Giảm tồn kho (shortage / damaged)

**C.** Cập nhật tồn kho theo:

* SKU  
* Vị trí (location)  
* Lô (batch)

**7\. Hoàn tất & lưu vết hệ thống**

**A.** Inventory Count Plan status \= completed

**B.** Hệ thống lưu log:

* Ai tạo kế hoạch kiểm kê  
* Ai thực hiện kiểm kê  
* Ai duyệt kết quả  
* Thời gian  
* Tồn kho trước và sau điều chỉnh

**C.** Dữ liệu được sử dụng cho:

* Báo cáo sai lệch tồn kho  
* Đánh giá hiệu quả vận hành kho

#### **5\) Luồng hỗ trợ / quản trị**

* Quản lý **danh mục**:

  * Sản phẩm (SKU). (Stock Keeping Unit \- Mã đơn vị lưu kho)

  * Kho, khu, kệ, ô (location).

  * Nhà cung cấp, khách hàng.

* Xem **báo cáo**:

  * Tồn kho theo mã hàng / vị trí.

  * Nhập – xuất – tồn theo khoảng thời gian.

  * Hàng chậm luân chuyển, gần hết hạn (nếu có quản lý hạn).

* Phân quyền **người dùng**, cấu hình hệ thống.

---

## **2\. Xác định các nhóm người dùng sản phẩm (phần mềm)**

##  Các **role** chính:

1. **Nhân viên kho (Warehouse Staff / Picker-Packer)**

   * Người trực tiếp thao tác nhập hàng, xuất hàng, kiểm kê, điều chuyển.

2. **Quản lý kho (Warehouse Manager / Supervisor)**

   * Quản lý hoạt động kho, duyệt phiếu, xem báo cáo, phân công công việc.

3. **Bộ phận mua hàng /Purchase staff**

   * Tạo/sửa đơn mua hàng, đối chiếu nhập, xem báo cáo tồn để lập kế hoạch nhập.

4. **Bộ phận bán hàng / Sale staff**

   * Tạo đơn bán, xem tồn kho khả dụng để tư vấn khách đỡ bị “hết hàng”.

5. **Quản trị hệ thống / IT Admin**

   * Quản lý tài khoản, phân quyền truy cập, cấu hình chung, backup dữ liệu.  
6. **Custermer**  
     
7. **Supplier**

---

## **3\. Xác định các chức năng mà người dùng (ở bước 2\) cần có**

**Use Case theo từng Actor**.

### **3.1. Nhân viên kho**

* Đăng nhập hệ thống.

* Xem danh sách **phiếu nhập** cần xử lý.

* Tạo mới / cập nhật:

  * Phiếu nhập kho.

  * Phiếu xuất kho.

  * Phiếu điều chuyển nội bộ.

* Thao tác putaway:

  * Gán vị trí lưu trữ cho hàng nhập.

* Thực hiện **picking**:

  * Xem danh sách pick theo đơn.

  * Xác nhận đã lấy đủ số lượng.

* Thực hiện **kiểm kê**:

  * Nhận khu vực / danh sách mã cần kiểm.

  * Nhập kết quả kiểm kê.

* Tra cứu nhanh:

  * Tồn kho theo mã hàng / vị trí.

  * Lịch sử nhập – xuất của một mã.

### **3.2. Quản lý kho**

* Quản lý phiếu:

  * Duyệt / từ chối phiếu nhập, phiếu xuất, phiếu điều chuyển.

  * Khóa / mở kỳ nhập xuất (theo tháng).

* Lập kế hoạch **kiểm kê**:

  * Tạo đợt kiểm kê mới.

  * Phân công cho nhân viên.

* Theo dõi hoạt động kho:

  * Xem dashboard lượng nhập – xuất trong ngày.

  * Xem các phiếu đang chờ xử lý.

* Xem và xuất **báo cáo**:

  * Báo cáo tồn kho chi tiết / tổng hợp.

  * Báo cáo lệch kiểm kê.

  * Báo cáo hàng chậm luân chuyển, hàng gần hết.

### **3.3. Bộ phận mua hàng / kế toán kho**

* Tạo / cập nhật **đơn đặt hàng (PO)**.

* Xem tình trạng thực hiện PO (đã nhập đủ chưa, còn thiếu bao nhiêu).

* Xem báo cáo:

  * Tồn kho theo nhóm hàng.

  * Lịch sử nhập theo nhà cung cấp, theo thời gian.

* In / xuất các báo cáo phục vụ kế toán.

### **3.4. Bộ phận bán hàng / CS**

* Tạo **đơn hàng bán**.

* Tra cứu **tồn kho khả dụng** theo mã hàng, kho.

* Xem trạng thái thực hiện đơn hàng:

  * Đã picking, đã đóng gói, đã giao cho vận chuyển chưa.

* In phiếu xuất, phiếu giao hàng cho khách (nếu được phân quyền).

### **3.5. Quản trị hệ thống / IT Admin**

* Quản lý **tài khoản người dùng**:

  * Tạo, sửa, khóa, reset mật khẩu.

* Quản lý **vai trò & phân quyền**:

  * Gán role cho user (nhân viên kho, quản lý kho, mua hàng, bán hàng…).

* Cấu hình hệ thống:

  * Danh sách kho, khu, kệ.

  * Cài đặt chuẩn mã hóa (SKU, mã vị trí).

* Backup / restore dữ liệu.

---

## **4\. Xác định các chức năng mà phần mềm phải có để làm được việc ở bước 3**

**các module hệ thống** 

### **4.1. Module Quản lý người dùng & phân quyền**

* Đăng nhập / đăng xuất, xác thực.

* Quản lý user (CRUD).

* Quản lý role & permission:

  * Mỗi role có danh sách chức năng được phép dùng.

* Log hoạt động người dùng (audit log cơ bản).

### **4.2. Module Quản lý danh mục (Master Data)**

* Danh mục **Sản phẩm**:

  * Mã hàng, tên, đơn vị tính, barcode, kích thước, trọng lượng…

* Danh mục **Kho – Khu – Kệ – Ô (Location)**:

  * Cấu trúc sơ đồ kho.

* Danh mục **Nhà cung cấp, khách hàng**.

* Danh mục **Đơn vị tính, nhóm hàng**, v.v.

### **4.3. Module Nhập kho (Inbound Management)**

* Quản lý **Đơn đặt hàng (PO)**:

  * Tạo, sửa, xóa, xem.

* Tạo & xử lý **phiếu nhập kho**:

  * Tạo phiếu nhập từ PO hoặc nhập độc lập.

  * Ghi nhận số lượng nhận thực tế.

* Luồng **putaway**:

  * Gợi ý vị trí lưu trữ (theo cấu hình).

  * Cập nhật vị trí thực tế đã đặt hàng vào.

* Cập nhật tồn kho:

  * Cộng tồn theo mã hàng – vị trí.

  * Ghi lịch sử nhập.

### **4.4. Module Xuất kho (Outbound Management)**

* Quản lý **đơn hàng bán**:

  * Tạo, sửa, theo dõi trạng thái.

* Sinh **phiếu xuất kho** từ đơn hàng.

* Quản lý **picking**:

  * Sinh danh sách pick (theo tối ưu đường đi nếu muốn nâng cao).

  * Cập nhật số lượng đã pick.

* Quản lý **đóng gói & vận chuyển**:

  * Ghi nhận đóng gói xong.

  * Ghi nhận bàn giao cho ship / đối tác vận chuyển.

* Cập nhật tồn kho:

  * Trừ tồn theo vị trí.

  * Ghi lịch sử xuất.

### **4.5. Module Quản lý tồn kho & điều chuyển**

* Theo dõi **tồn kho**:

  * Tồn hiện tại theo mã hàng, kho, vị trí.

  * Tồn khả dụng (tồn – đã giữ cho đơn hàng).

* Quản lý **phiếu điều chuyển nội bộ**:

  * Từ vị trí A → B, hoặc kho 1 → kho 2\.

* Xử lý **hàng hỏng, hàng trả về**:

  * Ghi nhận loại điều chỉnh tồn kho (giảm do hỏng, tăng do khách trả…).

### **4.6. Module Kiểm kê**

* Tạo **kế hoạch kiểm kê** (theo kho, khu vực, danh sách SKU).

* Giao nhiệm vụ kiểm kê cho nhân viên.

* Giao diện nhập kết quả đếm (trên web/mobile).

* So sánh tồn sổ – tồn thực tế.

* Sinh **phiếu điều chỉnh tồn kho** (tăng/giảm) sau kiểm kê.

### **4.7. Module Báo cáo & Dashboard**

* Báo cáo **nhập – xuất – tồn** theo ngày / tháng.

* Báo cáo tồn kho:

  * Theo mã hàng, nhóm hàng, vị trí, kho.

* Báo cáo **lịch sử giao dịch** của 1 sản phẩm.

* Dashboard cho quản lý:

  * Tổng nhập, tổng xuất trong ngày.

  * Số phiếu chưa xử lý.

  * Các cảnh báo (tồn dưới min, hàng gần hết… nếu có).

