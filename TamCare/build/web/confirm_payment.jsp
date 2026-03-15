<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="header.jsp" %>
<div class="container" style="margin-top: 120px; max-width: 600px;">
    <div class="card" style="padding: 30px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
        <h2 style="color: var(--primary-text); text-align: center;">Xác nhận thanh toán</h2>
        <hr>
        <div style="margin: 20px 0;">
            <p><strong>Gói nâng cấp:</strong> ${packageId}</p>
            <p><strong>Số điểm thanh toán:</strong> 
                <span style="color: #ef4444; font-weight: bold;">
                    <fmt:formatNumber value="${pointCost}" type="number"/> pts
                </span>
            </p>
            <p><strong>Số dư hiện tại:</strong> 
                <fmt:formatNumber value="${totalPoints}" type="number"/> pts
            </p>
        </div>
        
        <form action="upgrade-membership" method="post">
            <input type="hidden" name="packageId" value="${packageId}">
            <input type="hidden" name="pointCost" value="${pointCost}">
            
            <button type="submit" class="btn-upgrade" style="width: 100%; padding: 15px; background: #22c55e; border: none; color: white; border-radius: 12px; font-weight: bold; cursor: pointer;">
                XÁC NHẬN TRỪ ĐIỂM & KÍCH HOẠT
            </button>
            <a href="membership.jsp" style="display: block; text-align: center; margin-top: 15px; color: #64748b; text-decoration: none;">Hủy giao dịch</a>
        </form>
    </div>
</div>