<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List" %>
<%@page import="java.util.Set" %>
<%@page import="java.util.HashSet" %>
<%@page import="model.Role" %>
<%@page import="model.User" %>

<%
  User user = (User) request.getAttribute("user");
  List<Role> roles = (List<Role>) request.getAttribute("roles");
  List<Long> selectedRoleIds = (List<Long>) request.getAttribute("selectedRoleIds");
  String error = (String) request.getAttribute("error");
  
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/admin/user");
    return;
  }
  if (roles == null) roles = new java.util.ArrayList<>();
  if (selectedRoleIds == null) selectedRoleIds = new java.util.ArrayList<>();
  
  Set<Long> selectedSet = new HashSet<>(selectedRoleIds);
%>

<html>
  <head>
    <%@include file="/WEB-INF/admin/layout/head.jspf"%>
  </head>

  <body class="d-flex flex-column" style="min-height: 100vh;">
    <%@include file="/WEB-INF/admin/layout/header.jspf"%>
    
    <%@include file="/WEB-INF/admin/layout/sidebar.jspf"%>
    
    <main class="flex-grow-1 container-fluid py-4">
      <div class="row">
        <div class="col-12 col-md-10 col-lg-8 mx-auto">
          <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 mb-0">
              <i class="bi bi-person-gear me-2"></i>Cập nhật User
            </h1>
            <a href="${pageContext.request.contextPath}/admin/user" class="btn btn-outline-secondary">
              <i class="bi bi-arrow-left me-1"></i>Quay lại
            </a>
          </div>

          <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <i class="bi bi-exclamation-triangle me-2"></i>${error}
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>

          <div class="card shadow-sm">
            <div class="card-body">
              <form method="POST" action="${pageContext.request.contextPath}/admin/user/update">
                <input type="hidden" name="id" value="${user.userId}">

                <div class="row">
                  <div class="col-md-6 mb-3">
                    <label for="username" class="form-label">
                      Username <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" id="username" name="username" 
                           value="${user.username}" readonly>
                    <small class="text-muted">Username không thể thay đổi</small>
                  </div>

                  <div class="col-md-6 mb-3">
                    <label for="fullName" class="form-label">
                      Họ tên <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" id="fullName" name="fullName" required 
                           value="${user.fullName}" placeholder="Nhập họ tên">
                  </div>
                </div>

                <div class="row">
                  <div class="col-md-6 mb-3">
                    <label for="email" class="form-label">
                      Email <span class="text-danger">*</span>
                    </label>
                    <input type="email" class="form-control" id="email" name="email" required 
                           value="${user.email}" placeholder="example@email.com">
                  </div>

                  <div class="col-md-6 mb-3">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <input type="tel" class="form-control" id="phone" name="phone" 
                           value="${user.phone}" placeholder="0123456789">
                  </div>
                </div>

                <div class="row">
                  <div class="col-md-6 mb-3">
                    <label for="status" class="form-label">Trạng thái</label>
                    <select class="form-select" id="status" name="status">
                      <option value="ACTIVE" <%= "ACTIVE".equals(user.getStatus()) ? "selected" : "" %>>Hoạt động</option>
                      <option value="INACTIVE" <%= "INACTIVE".equals(user.getStatus()) ? "selected" : "" %>>Khóa</option>
                    </select>
                  </div>

                  <div class="col-md-6 mb-3">
                    <label for="warehouseId" class="form-label">Kho</label>
                    <input type="number" class="form-control" id="warehouseId" name="warehouseId" 
                           value="${user.warehouseId}" placeholder="ID kho (tùy chọn)">
                    <small class="text-muted">Để trống nếu không cần gán kho</small>
                  </div>
                </div>

                <div class="mb-4">
                  <label class="form-label">Roles</label>
                  <div class="border rounded p-3" style="max-height: 300px; overflow-y: auto;">
                    <c:choose>
                      <c:when test="${empty roles}">
                        <p class="text-muted mb-0">Chưa có role nào</p>
                      </c:when>
                      <c:otherwise>
                        <div class="row">
                          <c:forEach var="role" items="${roles}">
                            <div class="col-md-6 mb-2">
                              <div class="form-check">
                                <input class="form-check-input" type="checkbox" 
                                       name="roleIds" value="${role.roleId}" 
                                       id="role_${role.roleId}"
                                       <%= selectedSet.contains(role.getRoleId()) ? "checked" : "" %>>
                                <label class="form-check-label" for="role_${role.roleId}">
                                  <strong>${role.name}</strong>
                                  <c:if test="${not empty role.description}">
                                    <br><small class="text-muted">${role.description}</small>
                                  </c:if>
                                </label>
                              </div>
                            </div>
                          </c:forEach>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <small class="text-muted">Chọn các role mà user này được phép sử dụng</small>
                </div>

                <div class="d-flex justify-content-end gap-2">
                  <a href="${pageContext.request.contextPath}/admin/user" class="btn btn-secondary">
                    <i class="bi bi-x-circle me-1"></i>Hủy
                  </a>
                  <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-circle me-1"></i>Cập nhật
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </main>
    
    <%@include file="/WEB-INF/admin/layout/footer.jspf"%>
    <%@include file="/WEB-INF/admin/layout/toast.jspf"%>
  </body>
</html>