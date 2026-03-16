<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.CareTaskInstance" %>
<%
    User acc = (User) session.getAttribute("account");
    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int year = (Integer) request.getAttribute("year");
    int month = (Integer) request.getAttribute("month");
    int daysInMonth = (Integer) request.getAttribute("daysInMonth");
    int firstDayOfWeek = (Integer) request.getAttribute("firstDayOfWeek");
    LocalDate today = (LocalDate) request.getAttribute("today");
    LocalDate selectedDate = (LocalDate) request.getAttribute("selectedDate");
    Map<String, Integer> dayTaskCounts = (Map<String, Integer>) request.getAttribute("dayTaskCounts");
    Map<String, Boolean> dayHasCompleted = (Map<String, Boolean>) request.getAttribute("dayHasCompleted");
    List<CareTaskInstance> dayTasks = (List<CareTaskInstance>) request.getAttribute("dayTasks");

    String selectedDateStr = selectedDate.toString();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TamCare - Lịch chăm sóc</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&family=Lexend:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #0066cc;
            --primary-light: #eef6ff;
            --success: #16a34a;
            --danger: #ef4444;
            --white: #ffffff;
            --text-main: #1e293b;
            --sidebar-width: 300px;
        }
        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: #f0f7ff;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            color: var(--text-main);
        }
        .main-header {
            background-color: var(--white);
            height: 70px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 40px;
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 1001;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        .header-logo {
            font-size: 26px;
            font-weight: 800;
            color: var(--primary);
            text-decoration: none;
            font-family: 'Lexend', sans-serif;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .header-right-group {
            display: flex;
            align-items: center;
            gap: 35px;
        }
        .header-nav-links { display: flex; gap: 25px; align-items: center; }
        .nav-link-top { text-decoration: none; color: var(--text-main); font-weight: 700; font-size: 16px; transition: 0.3s; }
        .nav-link-top:hover { color: var(--primary); }

        .header-actions { display: flex; align-items: center; gap: 5px; }
        .header-item-wrapper { position: relative; height: 100%; display: flex; align-items: center; cursor: pointer; padding: 0 15px; }
        .dropdown-box {
            position: absolute; top: 70px; right: 0; width: 200px;
            background: white; border-radius: 0 0 15px 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            display: none; flex-direction: column;
            border: 1px solid #e2e8f0; z-index: 1002;
        }
        .header-item-wrapper:hover .dropdown-box { display: flex; }
        .noti-item { padding: 15px; border-bottom: 1px solid #f1f5f9; text-decoration: none; color: inherit; display: flex; gap: 10px; font-size: 14px; }
        .noti-item:hover { background: var(--primary-light); }

        .sidebar {
            width: var(--sidebar-width);
            background: var(--white);
            border-right: 2px solid #e0e6ed;
            padding: 25px;
            display: flex;
            flex-direction: column;
            position: fixed; top: 70px; bottom: 0; left: 0;
            box-sizing: border-box; z-index: 1000;
        }
        .menu-link {
            display: flex; align-items: center; gap: 12px; padding: 14px 18px;
            color: #475569; text-decoration: none; border-radius: 12px;
            margin-bottom: 5px; font-weight: 600; transition: 0.3s;
        }
        .menu-link:hover, .menu-link.active { background: var(--primary-light); color: var(--primary); }

        .sidebar-box {
            background: #f8f9fa; border-radius: 20px;
            padding: 20px; margin-top: 20px; border: 1px solid #dee2e6;
        }

        .main-wrapper { display: flex; flex: 1; margin-top: 70px; }
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 40px;
            box-sizing: border-box;
        }

        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .calendar-header h1 {
            margin: 0;
            font-size: 26px;
        }
        .month-nav button {
            border: none;
            background: var(--primary-light);
            color: var(--primary);
            padding: 8px 14px;
            border-radius: 999px;
            margin: 0 3px;
            cursor: pointer;
            font-weight: 600;
        }
        .month-nav button:hover { background: var(--primary); color: white; }

        .calendar-grid {
            background: var(--white);
            border-radius: 24px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        .calendar-weekdays, .calendar-days {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 6px;
        }
        .weekday {
            text-align: center;
            font-weight: 700;
            font-size: 13px;
            color: #64748b;
            padding-bottom: 6px;
            border-bottom: 1px solid #e2e8f0;
        }
        .day-cell {
            height: 70px;
            border-radius: 12px;
            position: relative;
            padding: 6px 8px;
            box-sizing: border-box;
            cursor: pointer;
            font-size: 14px;
            color: #0f172a;
            transition: 0.2s;
        }
        .day-cell.empty {
            cursor: default;
            background: transparent;
        }
        .day-number {
            font-weight: 600;
        }
        .day-cell.today {
            border: 2px solid var(--primary);
        }
        .day-cell.selected {
            background: var(--primary);
            color: white;
        }
        .day-cell.has-task:not(.selected) {
            background: #ecfeff;
            border: 1px solid #22c55e33;
        }
        .badge-count {
            position: absolute;
            bottom: 6px;
            right: 8px;
            background: var(--success);
            color: white;
            font-size: 10px;
            padding: 2px 6px;
            border-radius: 999px;
        }
        .dot-completed {
            position: absolute;
            bottom: 6px;
            left: 8px;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--success);
        }

        .day-cell a {
            color: inherit;
            text-decoration: none;
            display: block;
            width: 100%;
            height: 100%;
        }

        .tasks-panel {
            margin-top: 25px;
            background: var(--white);
            border-radius: 24px;
            padding: 20px 24px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        .tasks-panel h2 {
            margin: 0 0 12px 0;
            font-size: 20px;
        }
        .task-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e5e7eb;
        }
        .task-item:last-child { border-bottom: none; }
        .task-main {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }
        .task-time {
            font-weight: 700;
            color: var(--primary);
            font-size: 14px;
        }
        .task-title {
            font-weight: 600;
        }
        .task-desc {
            font-size: 13px;
            color: #64748b;
        }
        .task-meta {
            font-size: 12px;
            color: #6b7280;
        }
        .task-actions form {
            margin: 0;
        }
        .btn-complete {
            border: none;
            border-radius: 999px;
            padding: 6px 14px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
        }
        .btn-complete.done {
            background: #dcfce7;
            color: #15803d;
        }
        .btn-complete.todo {
            background: #fee2e2;
            color: #b91c1c;
        }
    </style>
</head>
<body>
<header class="main-header">
    <a href="home_elderly.jsp" class="header-logo">
        <i class="fa-solid fa-blind"></i> TamCare
    </a>
    <div class="header-right-group">
        <nav class="header-nav-links">
            <a href="home_elderly.jsp" class="nav-link-top">Tổng quan</a>
            <a href="blog.jsp" class="nav-link-top">Tin tức & Blog</a>
            <a href="products.jsp" class="nav-link-top">Cửa hàng y tế</a>
        </nav>
        <div class="header-actions">
            <div class="header-item-wrapper">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span style="font-weight: 700;"><%= acc.getFullName() %></span>
                    <div style="width: 38px; height: 38px; border-radius: 50%; background: var(--primary-light); display: flex; align-items: center; justify-content: center; border: 1px solid #d0e4ff;">
                        <i class="fa-solid fa-user-tie" style="color: var(--primary);"></i>
                    </div>
                </div>
                <div class="dropdown-box">
                    <a href="profile.jsp" class="noti-item"><i class="fa-solid fa-id-card"></i> Hồ sơ của bác</a>
                    <a href="logout" class="noti-item" style="color: var(--danger);"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
                </div>
            </div>
        </div>
    </div>
</header>

<div class="main-wrapper">
    <aside class="sidebar">
        <nav style="flex: 1;">
            <a href="home_elderly.jsp" class="menu-link"><i class="fa-solid fa-house"></i> Trang chủ</a>
            <a href="blog.jsp" class="menu-link"><i class="fa-solid fa-newspaper"></i> Blog sức khỏe</a>
            <a href="products.jsp" class="menu-link"><i class="fa-solid fa-cart-shopping"></i> Cửa hàng y tế</a>
            <a href="MedicalHistoryServlet?profileId=<%= acc.getUserID() %>" class="menu-link"><i class="fa-solid fa-file-medical"></i> Lịch sử bệnh án</a>
            <a href="elderly-calendar" class="menu-link active"><i class="fa-solid fa-calendar-days"></i> Lịch chăm sóc</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="calendar-header">
            <h1>Lịch chăm sóc của bác</h1>
            <div class="month-nav">
                <form action="elderly-calendar" method="get" style="display:inline;">
                    <input type="hidden" name="year" value="<%= (month == 1) ? (year - 1) : year %>">
                    <input type="hidden" name="month" value="<%= (month == 1) ? 12 : (month - 1) %>">
                    <input type="hidden" name="selectedDate" value="<%= selectedDateStr %>">
                    <button type="submit"><i class="fa-solid fa-chevron-left"></i> Tháng trước</button>
                </form>
                <span style="font-weight:600; margin:0 10px;">
                    Tháng <%= month %> / <%= year %>
                </span>
                <form action="elderly-calendar" method="get" style="display:inline;">
                    <input type="hidden" name="year" value="<%= (month == 12) ? (year + 1) : year %>">
                    <input type="hidden" name="month" value="<%= (month == 12) ? 1 : (month + 1) %>">
                    <input type="hidden" name="selectedDate" value="<%= selectedDateStr %>">
                    <button type="submit">Tháng sau <i class="fa-solid fa-chevron-right"></i></button>
                </form>
            </div>
        </div>

        <section class="calendar-grid">
            <div class="calendar-weekdays">
                <div class="weekday">Th 2</div>
                <div class="weekday">Th 3</div>
                <div class="weekday">Th 4</div>
                <div class="weekday">Th 5</div>
                <div class="weekday">Th 6</div>
                <div class="weekday">Th 7</div>
                <div class="weekday">CN</div>
            </div>
            <div class="calendar-days">
                <%
                    int startOffset = firstDayOfWeek - 1;
                    for (int i = 0; i < startOffset; i++) {
                %>
                <div class="day-cell empty"></div>
                <% } %>
                <%
                    for (int d = 1; d <= daysInMonth; d++) {
                        LocalDate date = LocalDate.of(year, month, d);
                        String dateKey = date.toString();
                        Integer count = dayTaskCounts.get(dateKey);
                        boolean hasTask = (count != null && count > 0);
                        boolean hasCompleted = Boolean.TRUE.equals(dayHasCompleted.get(dateKey));
                        boolean isToday = date.equals(today);
                        boolean isSelected = date.equals(selectedDate);
                        String cellClass = "day-cell";
                        if (isToday) cellClass += " today";
                        if (hasTask) cellClass += " has-task";
                        if (isSelected) cellClass += " selected";
                %>
                <div class="<%= cellClass %>">
                    <a href="elderly-calendar?year=<%= year %>&month=<%= month %>&selectedDate=<%= dateKey %>">
                        <div class="day-number"><%= d %></div>
                        <% if (hasTask) { %>
                        <div class="badge-count"><%= count %> việc</div>
                        <% } %>
                        <% if (hasCompleted) { %>
                        <div class="dot-completed"></div>
                        <% } %>
                    </a>
                </div>
                <% } %>
            </div>
        </section>

        <section class="tasks-panel">
            <h2>Nhiệm vụ ngày <%= selectedDate.getDayOfMonth() %> / <%= selectedDate.getMonthValue() %> / <%= selectedDate.getYear() %></h2>
            <% if (dayTasks == null || dayTasks.isEmpty()) { %>
            <p style="color:#6b7280; font-size:14px;">Hôm nay bác chưa có nhiệm vụ nào. Bác hãy nghỉ ngơi thư giãn nhé!</p>
            <% } else { %>
            <% for (CareTaskInstance t : dayTasks) { %>
            <div class="task-item">
                <div class="task-main">
                    <div class="task-time"><i class="fa-regular fa-clock"></i>
                        <%= t.getTimeOfDay() != null ? t.getTimeOfDay().toString().substring(0,5) : "" %>
                    </div>
                    <div class="task-title"><%= t.getTitle() %></div>
                    <% if (t.getShortDescription() != null && !t.getShortDescription().isEmpty()) { %>
                    <div class="task-desc"><%= t.getShortDescription() %></div>
                    <% } %>
                    <div class="task-meta">
                        Loại: <%= t.getTaskCategory() != null ? t.getTaskCategory() : t.getTaskType() %>
                        <% if (t.isCompleted()) { %>
                        · <span style="color:#16a34a;">Đã hoàn thành</span>
                        <% } else { %>
                        · <span style="color:#b91c1c;">Chưa hoàn thành</span>
                        <% } %>
                    </div>
                </div>
                <div class="task-actions">
                    <form action="toggle-task-completion" method="post">
                        <input type="hidden" name="taskId" value="<%= t.getTaskID() %>">
                        <input type="hidden" name="taskDate" value="<%= selectedDateStr %>">
                        <input type="hidden" name="year" value="<%= year %>">
                        <input type="hidden" name="month" value="<%= month %>">
                        <button class="btn-complete <%= t.isCompleted() ? "done" : "todo" %>" type="submit">
                            <%= t.isCompleted() ? "Bỏ hoàn thành" : "Đánh dấu hoàn thành" %>
                        </button>
                    </form>
                </div>
            </div>
            <% } %>
            <% } %>
        </section>
    </main>
</div>
</body>
</html>

