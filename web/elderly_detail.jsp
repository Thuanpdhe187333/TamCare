<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User, dal.UserDAO"%>
<%
    User acc = (User) session.getAttribute("account");
    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    User info = null;
    UserDAO dao = new UserDAO();

    if (idStr != null) {
        try {
            int id = Integer.parseInt(idStr);
            info = dao.getUserById(id); 
            if (info != null) {
                request.setAttribute("gender", info.getGender());
                request.setAttribute("birthYear", info.getBirthYear());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    if (info == null) {
        out.print("<script>alert('Không tìm thấy hồ sơ!'); window.location='my_relatives.jsp';</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TamCare - Chi tiết hồ sơ <%= info.getFullName() %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2c5282;          /* Xanh đậm để làm điểm nhấn chữ/nút */
            --primary-bg: #e0effa;       /* MÀU CHỦ ĐẠO BÁC YÊU CẦU */
            --white: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --bg-body: #f8fafc;
            --accent: #ef4444;           /* Màu đỏ cho nút ngắt kết nối */
            --transition: all 0.3s ease;
        }

        body { 
            font-family: 'Lexend', sans-serif; 
            background: var(--bg-body); 
            margin: 0; 
            padding-top: 100px; 
            color: var(--text-main); 
        }
        
        /* Cập nhật Navbar theo tông màu mới */
        .navbar { 
            height: 75px; 
            background: var(--primary-bg); 
            display: flex; 
            align-items: center; 
            padding: 0 40px; 
            position: fixed; 
            top: 0; 
            width: 100%; 
            z-index: 1001; 
            box-sizing: border-box; 
            box-shadow: 0 2px 15px rgba(0,0,0,0.05); 
        }
        .logo { font-size: 20px; font-weight: 800; color: var(--primary); text-decoration: none; display: flex; align-items: center; gap: 10px; }

        .container { max-width: 1000px; margin: 0 auto; padding: 20px; }
        
        /* Profile Header */
        .profile-card {
            background: white; border-radius: 24px; padding: 35px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03); margin-bottom: 25px;
            border: 1px solid var(--primary-bg);
        }
        .user-meta { display: flex; align-items: center; gap: 25px; }
        .large-avatar { 
            width: 90px; height: 90px; border-radius: 50%; 
            background: var(--primary-bg); color: var(--primary); 
            display: flex; align-items: center; justify-content: center; 
            font-size: 36px; font-weight: 800; border: 3px solid white; 
            box-shadow: 0 5px 15px rgba(44, 82, 130, 0.1); 
        }

        /* Action Buttons */
        .action-group { display: flex; gap: 12px; }
        .btn { padding: 12px 24px; border-radius: 12px; font-weight: 700; cursor: pointer; border: none; transition: var(--transition); display: flex; align-items: center; gap: 8px; font-size: 14px; text-decoration: none; }
        
        .btn-edit { background: var(--primary-bg); color: var(--primary); }
        .btn-edit:hover { background: var(--primary); color: white; transform: translateY(-2px); }
        
        .btn-delete { background: #fee2e2; color: var(--accent); }
        .btn-delete:hover { background: var(--accent); color: white; transform: translateY(-2px); }

        /* Tabs System */
        .tabs { display: flex; gap: 10px; margin-bottom: 25px; background: white; padding: 8px; border-radius: 16px; width: fit-content; border: 1px solid var(--primary-bg); }
        .tab-btn { padding: 10px 25px; border-radius: 10px; border: none; background: none; color: var(--text-muted); cursor: pointer; font-weight: 700; transition: 0.3s; }
        .tab-btn.active { background: var(--primary); color: white; box-shadow: 0 4px 12px rgba(44, 82, 130, 0.2); }

        /* Section Content */
        .section-card { background: white; border-radius: 24px; padding: 35px; box-shadow: 0 10px 30px rgba(0,0,0,0.03); margin-bottom: 20px; display: none; border: 1px solid var(--primary-bg); }
        .section-card.active { display: block; animation: fadeIn 0.4s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; }
        .info-item { border-bottom: 1px dashed var(--primary-bg); padding: 15px 0; }
        .info-label { font-size: 13px; color: var(--text-muted); margin-bottom: 5px; font-weight: 600; }
        .info-value { font-weight: 700; font-size: 16px; color: var(--text-main); }

        /* Health Stats Specific */
        .stat-box { background: var(--primary-bg); padding: 25px; border-radius: 20px; border: 1px solid #c3dafe; }
        .stat-label { color: var(--primary); font-weight: 700; font-size: 15px; }
        .stat-value { font-size: 32px; font-weight: 800; color: var(--primary); margin-top: 10px; }

        /* Modal */
        .modal { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); display: none; align-items: center; justify-content: center; z-index: 1002; backdrop-filter: blur(4px); }
        .modal-content { background: white; padding: 35px; border-radius: 24px; width: 450px; box-shadow: 0 20px 50px rgba(0,0,0,0.15); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-size: 14px; font-weight: 700; color: var(--text-main); }
        .form-group input { width: 100%; padding: 14px; border-radius: 12px; border: 1px solid #cbd5e1; box-sizing: border-box; font-family: 'Lexend'; outline: none; }
        .form-group input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(44, 82, 130, 0.1); }
    </style>
</head>
<body>
    <header class="navbar">
        <a href="my_relatives.jsp" class="logo"><i class="fa-solid fa-chevron-left"></i> Quay lại danh sách người thân</a>
    </header>

    <div class="container">
        <div class="profile-card">
            <div class="user-meta">
                <div class="large-avatar"><%= info.getFullName().substring(0,1).toUpperCase() %></div>
                <div>
                    <h1 style="margin:0; font-size: 28px; color: var(--primary);"><%= info.getFullName() %></h1>
                    <p style="color: var(--text-muted); margin: 8px 0; font-size: 15px;">
                        Mã kết nối: <span style="background: var(--primary-bg); color: var(--primary); padding: 4px 12px; border-radius: 8px; font-weight: 800; margin-left: 5px;"><%= info.getLinkKey() %></span>
                    </p>
                </div>
            </div>
            <div class="action-group">
                <button class="btn btn-edit" onclick="openModal()"><i class="fa-solid fa-user-pen"></i> Chỉnh sửa</button>
                <button class="btn btn-delete" onclick="handleDelete()"><i class="fa-solid fa-link-slash"></i> Ngắt kết nối</button>
            </div>
        </div>

        <div class="tabs">
            <button class="tab-btn active" onclick="switchTab(event, 'basic')">Thông tin cơ bản</button>
            <button class="tab-btn" onclick="switchTab(event, 'health')">Chỉ số sức khỏe</button>
            <button class="tab-btn" onclick="switchTab(event, 'medicine')">Lịch uống thuốc</button>
        </div>

        <div id="basic" class="section-card active">
            <h3 style="color: var(--primary); margin-top: 0; font-size: 20px; border-bottom: 2px solid var(--primary-bg); padding-bottom: 15px; margin-bottom: 20px;">
                <i class="fa-solid fa-address-card"></i> Thông tin cá nhân
            </h3>
            <div class="info-grid">
                <div class="info-item"><div class="info-label">Họ và tên</div><div class="info-value"><%= info.getFullName() %></div></div>
                <div class="info-item"><div class="info-label">Email đăng ký</div><div class="info-value"><%= info.getEmail() %></div></div>
                <div class="info-item"><div class="info-label">Số điện thoại</div><div class="info-value"><%= info.getPhoneNumber() %></div></div>
                <div class="info-item"><div class="info-label">Giới tính</div><div class="info-value"><%= request.getAttribute("gender") != null ? request.getAttribute("gender") : "Chưa cập nhật" %></div></div>
                <div class="info-item"><div class="info-label">Năm sinh</div><div class="info-value"><%= request.getAttribute("birthYear") != null ? request.getAttribute("birthYear") : "Chưa cập nhật" %></div></div>
                <div class="info-item"><div class="info-label">Cấp độ tài khoản</div><div class="info-value" style="color: #059669;">Hội viên Ông Bà</div></div>
            </div>
        </div>

        <div id="health" class="section-card">
            <h3 style="color: var(--primary); margin-top: 0; font-size: 20px; border-bottom: 2px solid var(--primary-bg); padding-bottom: 15px; margin-bottom: 25px;">
                <i class="fa-solid fa-heart-pulse"></i> Chỉ số sức khỏe thời gian thực
            </h3>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 25px;">
                <div class="stat-box">
                    <span class="stat-label">Huyết áp trung bình</span>
                    <div class="stat-value">125/80 <small style="font-size: 16px; font-weight: 400; opacity: 0.7;">mmHg</small></div>
                </div>
                <div class="stat-box">
                    <span class="stat-label">Nhịp tim hiện tại</span>
                    <div class="stat-value">78 <small style="font-size: 16px; font-weight: 400; opacity: 0.7;">bpm</small></div>
                </div>
            </div>
            <div style="margin-top: 25px; padding: 20px; background: #fffbeb; border-radius: 15px; border: 1px solid #fde68a; color: #92400e; font-size: 14px;">
                <i class="fa-solid fa-circle-exclamation"></i> <b>Lưu ý:</b> Các chỉ số này được đồng bộ từ thiết bị đeo của người thân.
            </div>
        </div>

        <div id="medicine" class="section-card">
            <h3 style="color: var(--primary); margin-top: 0; font-size: 20px; border-bottom: 2px solid var(--primary-bg); padding-bottom: 15px; margin-bottom: 20px;">
                <i class="fa-solid fa-pills"></i> Nhắc nhở uống thuốc
            </h3>
            <div style="text-align: center; padding: 60px 20px;">
                <i class="fa-solid fa-calendar-plus" style="font-size: 50px; color: var(--primary-bg); margin-bottom: 20px;"></i>
                <p style="color: var(--text-muted); font-size: 16px; font-weight: 600;">Hiện chưa có lịch uống thuốc nào được thiết lập.</p>
                <button class="btn" style="background: var(--primary); color: white; margin: 20px auto;">+ Thêm lịch mới</button>
            </div>
        </div>
    </div>

    <div id="editModal" class="modal">
        <div class="modal-content">
            <h2 style="margin-top: 0; color: var(--primary); font-size: 24px; margin-bottom: 25px;">Chỉnh sửa thông tin</h2>
            <form action="edit-elderly" method="POST">
                <input type="hidden" name="id" value="<%= info.getUserID() %>">
                <div class="form-group">
                    <label>Họ và tên</label>
                    <input type="text" name="fullname" value="<%= info.getFullName() %>" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại liên hệ</label>
                    <input type="text" name="phone" value="<%= info.getPhoneNumber() %>" required>
                </div>
                <div style="display: flex; gap: 12px; margin-top: 30px;">
                    <button type="submit" class="btn" style="background: var(--primary); color: white; flex: 2; justify-content: center;">Cập nhật hồ sơ</button>
                    <button type="button" class="btn" style="background: #f1f5f9; color: var(--text-muted); flex: 1; justify-content: center;" onclick="closeModal()">Hủy</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function switchTab(evt, tabName) {
            var i, cards, tablinks;
            cards = document.getElementsByClassName("section-card");
            for (i = 0; i < cards.length; i++) cards[i].className = cards[i].className.replace(" active", "");
            tablinks = document.getElementsByClassName("tab-btn");
            for (i = 0; i < tablinks.length; i++) tablinks[i].className = tablinks[i].className.replace(" active", "");
            document.getElementById(tabName).className += " active";
            evt.currentTarget.className += " active";
        }

        function openModal() { document.getElementById('editModal').style.display = 'flex'; }
        function closeModal() { document.getElementById('editModal').style.display = 'none'; }

        function handleDelete() {
            if(confirm('Hành động này sẽ ngắt kết nối hoàn toàn với <%= info.getFullName() %>. Bạn có chắc chắn không?')) {
                window.location.href = 'delete-link?id=<%= info.getUserID() %>';
            }
        }
    </script>
</body>
</html>