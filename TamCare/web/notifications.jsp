<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông báo - TamCare</title>
    <style>
        .noti-container { max-width: 800px; margin: 100px auto; min-height: 500px; padding: 0 20px; }
        .noti-item { background: white; padding: 20px; border-radius: 15px; margin-bottom: 15px; border-left: 5px solid #2c5282; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .pagination { display: flex; justify-content: center; gap: 10px; margin-top: 30px; }
        .page-link { padding: 8px 16px; border: 1px solid #ddd; border-radius: 8px; text-decoration: none; color: #2c5282; }
        .page-link.active { background: #2c5282; color: white; border-color: #2c5282; }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="noti-container">
        <h2 style="color: #2c5282; margin-bottom: 30px;"><i class="fa-solid fa-bell"></i> Lịch sử thông báo</h2>

        <c:choose>
            <c:when test="${empty notiList}">
                <div style="text-align: center; padding: 50px;">
                    <img src="https://cdn-icons-png.flaticon.com/512/4076/4076549.png" width="100" style="opacity: 0.3;">
                    <p style="color: #64748b; margin-top: 20px;">Bác chưa có thông báo nào.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${notiList}" var="n">
                    <div class="noti-item">
                        <h4 style="margin: 0 0 10px 0; color: #1e293b;">${n.title}</h4>
                        <p style="margin: 0; color: #475569; font-size: 14px;">${n.message}</p>
                        <small style="color: #94a3b8; display: block; margin-top: 10px;">
                            <i class="fa-regular fa-clock"></i> 
                            <fmt:formatDate value="${n.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </small>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <div class="pagination">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="notifications?page=${i}" class="page-link ${i == currentPage ? 'active' : ''}">${i}</a>
            </c:forEach>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>