<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="header.jsp" %>

<style>
    :root {
        --primary-blue: #2c5282; --primary-light: #e0effa;
        --gold: #f39c12; --success: #16a34a; --accent: #ef4444;
    }
    .rewards-container { max-width: 1000px; margin: 40px auto; padding: 0 20px; min-height: 80vh; }
    
    .points-summary {
        background: linear-gradient(135deg, var(--primary-blue), #1a365d);
        border-radius: 24px; padding: 40px; color: white; text-align: center;
        margin-bottom: 40px; box-shadow: 0 10px 25px rgba(44, 82, 130, 0.2);
    }
    .points-summary .big-points { font-size: 64px; font-weight: 800; margin: 10px 0; display: block; color: #fbd38d; }
    
    .history-card {
        background: white; border-radius: 24px; padding: 30px;
        border: 1px solid var(--primary-light); box-shadow: 0 4px 15px rgba(0,0,0,0.02);
    }
    .reward-table { width: 100%; border-collapse: collapse; }
    .reward-table th { text-align: left; padding: 15px; color: var(--text-muted); font-size: 14px; }
    .reward-table td { padding: 20px 15px; border-bottom: 1px solid #f1f5f9; }
    
    .source-icon {
        width: 45px; height: 45px; border-radius: 12px;
        display: flex; align-items: center; justify-content: center; font-size: 20px;
        background: var(--primary-light); color: var(--primary-blue);
    }
    .point-plus { color: var(--success); font-weight: 700; }
    .point-minus { color: var(--accent); font-weight: 700; }
</style>

<div class="main-content">
    <div class="rewards-container">
        <div style="margin-bottom: 20px;">
            <a href="profile.jsp" style="text-decoration: none; color: var(--primary-blue); font-weight: 600;">
                <i class="fa-solid fa-arrow-left"></i> Quay lại Hồ sơ
            </a>
        </div>

        <div class="points-summary">
            <h2>Số điểm tích lũy hiện tại</h2>
            <span class="big-points">
                <fmt:formatNumber value="${totalPoints}" pattern="#,###"/>
            </span>
            <p style="opacity: 0.8; font-size: 14px;">Bạn có thể dùng điểm để nhận các ưu đãi đặc biệt.</p>
        </div>

        <div class="history-card">
            <h3 style="margin-bottom: 25px; color: var(--primary-blue);">
                <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử nhận điểm
            </h3>

            <table class="reward-table">
                <thead>
                    <tr>
                        <th>Nguồn nhận</th>
                        <th>Nội dung chi tiết</th>
                        <th>Ngày nhận</th>
                        <th style="text-align: right;">Số lượng</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${rewardList}" var="h">
                        <tr>
                            <td>
                                <div class="source-icon">
                                    <c:choose>
                                        <c:when test="${h.source == 'Điểm danh'}"><i class="fa-solid fa-calendar-check"></i></c:when>
                                        <c:when test="${h.source == 'Mua sắm'}"><i class="fa-solid fa-bag-shopping"></i></c:when>
                                        <c:when test="${h.source == 'Kết nối'}"><i class="fa-solid fa-user-plus"></i></c:when>
                                        <c:otherwise><i class="fa-solid fa-star"></i></c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                            <td>
                                <strong>${h.source}</strong>
                                <div style="font-size: 12px; color: #94a3b8;">${h.description}</div>
                            </td>
                            <td><fmt:formatDate value="${h.transactionDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td style="text-align: right;">
                                <span class="${h.pointAmount > 0 ? 'point-plus' : 'point-minus'}">
                                    ${h.pointAmount > 0 ? '+' : ''}${h.pointAmount} pts
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty rewardList}">
                        <tr><td colspan="4" style="text-align:center; padding:50px;">Bạn chưa có giao dịch nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>