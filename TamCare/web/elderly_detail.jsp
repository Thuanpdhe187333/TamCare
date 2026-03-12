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
    <style>
        :root {
            --primary: #008080;
            --primary-dark: #006666;
            --primary-light: #e6f2f2;
            --white: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --bg-body: #f1f5f9;
            --accent: #ef4444;
            --transition: all 0.3s ease;
        }

        body { font-family: 'Lexend', sans-serif; background: var(--bg-body); margin: 0; padding-top: 80px; color: var(--text-main); }
        
        .navbar { height: 70px; background: var(--primary); display: flex; align-items: center; padding: 0 40px; position: fixed; top: 0; width: 100%; z-index: 1001; box-sizing: border-box; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .logo { font-size: 22px; font-weight: 800; color: white; text-decoration: none; display: flex; align-items: center; gap: 10px; }

        .container { max-width: 1000px; margin: 0 auto; padding: 20px; }
        
        /* Profile Header */
        .profile-card {
            background: white; border-radius: 24px; padding: 35px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03); margin-bottom: 25px;
        }
        .user-meta { display: flex; align-items: center; gap: 25px; }
        .large-avatar { width: 90px; height: 90px; border-radius: 50%; background: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 36px; font-weight: 800; border: 3px solid white; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }

        /* Action Buttons */
        .action-group { display: flex; gap: 12px; }
        .btn { padding: 10px 20px; border-radius: 12px; font-weight: 600; cursor: pointer; border: none; transition: 0.3s; display: flex; align-items: center; gap: 8px; font-size: 14px; text-decoration: none; }
        .btn-edit { background: var(--primary-light); color: var(--primary); }
        .btn-edit:hover { background: var(--primary); color: white; }
        .btn-delete { background: #fee2e2; color: var(--accent); }
        .btn-delete:hover { background: var(--accent); color: white; }

        /* Tabs System */
        .tabs { display: flex; gap: 10px; margin-bottom: 20px; background: white; padding: 8px; border-radius: 16px; width: fit-content; box-shadow: 0 2px 10px rgba(0,0,0,0.02); }
        .tab-btn { padding: 10px 25px; border-radius: 10px; border: none; background: none; color: var(--text-muted); cursor: pointer; font-weight: 600; transition: 0.3s; }
        .tab-btn.active { background: var(--primary); color: white; }

        .section-card { background: white; border-radius: 24px; padding: 30px; box-shadow: 0 4px 20px rgba(0,0,0,0.03); margin-bottom: 20px; display: none; animation: fadeIn 0.4s ease; }
        .section-card.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-item { border-bottom: 1px solid #f1f5f9; padding: 15px 0; }
        .info-label { font-size: 13px; color: var(--text-muted); margin-bottom: 5px; }
        .info-value { font-weight: 600; font-size: 16px; }

        /* Modal Simple */
        .modal { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: none; align-items: center; justify-content: center; z-index: 1002; }
        .modal-content { background: white; padding: 30px; border-radius: 24px; width: 450px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-size: 14px; }
        .form-group input { width: 100%; padding: 12px; border-radius: 10px; border: 1px solid #ddd; box-sizing: border-box; }
    </style>
</head>
<body>
    <header class="navbar">
        <a href="my_relatives.jsp" class="logo"><i class="fa-solid fa-arrow-left"></i> Quay lại danh sách</a>
    </header>

    <div class="container">
        <div class="profile-card">
            <div class="user-meta">
                <div class="large-avatar"><%= info.getFullName().substring(0,1).toUpperCase() %></div>
                <div>
                    <h1 style="margin:0; font-size: 26px;"><%= info.getFullName() %></h1>
                    <p style="color: var(--text-muted); margin: 5px 0;">Mã kết nối: <span style="color: var(--primary); font-weight: 700;"><%= info.getLinkKey() %></span></p>
                </div>
            </div>
            <div class="action-group">
                <button class="btn btn-edit" onclick="openModal()"><i class="fa-solid fa-user-pen"></i> Sửa thông tin</button>
                <button class="btn btn-delete" onclick="handleDelete()"><i class="fa-solid fa-link-slash"></i> Ngắt kết nối</button>
            </div>
        </div>

        <div class="tabs">
            <button class="tab-btn active" onclick="switchTab(event, 'basic')">Thông tin cơ bản</button>
            <button class="tab-btn" onclick="switchTab(event, 'health')">Chỉ số sức khỏe</button>
            <button class="tab-btn" onclick="switchTab(event, 'medicine')">Lịch uống thuốc</button>
        </div>

        <div id="basic" class="section-card active">
            <h3 style="color: var(--primary); margin-top: 0;"><i class="fa-solid fa-circle-info"></i> Chi tiết hồ sơ</h3>
            <div class="info-grid">
                <div class="info-item"><div class="info-label">Họ và tên</div><div class="info-value"><%= info.getFullName() %></div></div>
                <div class="info-item"><div class="info-label">Email</div><div class="info-value"><%= info.getEmail() %></div></div>
                <div class="info-item"><div class="info-label">Số điện thoại</div><div class="info-value"><%= info.getPhoneNumber() %></div></div>
                <div class="info-item"><div class="info-label">Vai trò</div><div class="info-value">Người cao tuổi</div></div>
            </div>
        </div>

        <div id="health" class="section-card">
            <h3 style="color: var(--primary); margin-top: 0;"><i class="fa-solid fa-heart-pulse"></i> Theo dõi sức khỏe</h3>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div style="background: #f8fafc; padding: 20px; border-radius: 16px;">
                    <span style="color: var(--text-muted);">Huyết áp gần nhất</span>
                    <div style="font-size: 28px; font-weight: 800; color: var(--primary); margin-top: 10px;">125/80 <small style="font-size: 14px; font-weight: 400;">mmHg</small></div>
                </div>
                <div style="background: #f8fafc; padding: 20px; border-radius: 16px;">
                    <span style="color: var(--text-muted);">Nhịp tim</span>
                    <div style="font-size: 28px; font-weight: 800; color: var(--primary); margin-top: 10px;">78 <small style="font-size: 14px; font-weight: 400;">bpm</small></div>
                </div>
            </div>
        </div>

        <div id="medicine" class="section-card">
            <h3 style="color: var(--primary); margin-top: 0;"><i class="fa-solid fa-capsules"></i> Danh sách thuốc cần uống</h3>
            <p style="text-align: center; padding: 40px; color: var(--text-muted);">Tính năng cập nhật lịch uống thuốc đang được phát triển...</p>
        </div>
    </div>

    <div id="editModal" class="modal">
        <div class="modal-content">
            <h2 style="margin-top: 0; color: var(--primary);">Chỉnh sửa hồ sơ</h2>
            <form action="edit-elderly" method="POST">
                <input type="hidden" name="id" value="<%= info.getUserID() %>">
                <div class="form-group">
                    <label>Họ và tên</label>
                    <input type="text" name="fullname" value="<%= info.getFullName() %>" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" value="<%= info.getPhoneNumber() %>" required>
                </div>
                <div style="display: flex; gap: 10px; margin-top: 20px;">
                    <button type="submit" class="btn" style="background: var(--primary); color: white; flex: 1; justify-content: center;">Lưu thay đổi</button>
                    <button type="button" class="btn" style="background: #eee; flex: 1; justify-content: center;" onclick="closeModal()">Hủy</button>
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
            if(confirm('Bạn có chắc chắn muốn ngắt kết nối với người thân này?')) {
                // Chuyển hướng đến servlet xử lý Delete
                window.location.href = 'delete-link?id=<%= info.getUserID() %>';
            }
        }
    </script>
</body>
</html>