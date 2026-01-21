<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List" %>
<%@page import="java.util.Set" %>
<%@page import="java.util.HashSet" %>
<%@page import="model.Permission" %>
<%@page import="model.Role" %>

<%
  Role role = (Role) request.getAttribute("role");
  List<Permission> permissions = (List<Permission>) request.getAttribute("permissions");
  List<Long> selectedPermissionIds = (List<Long>) request.getAttribute("selectedPermissionIds");
  String error = (String) request.getAttribute("error");
  
  if (role == null) {
    response.sendRedirect(request.getContextPath() + "/admin/role");
    return;
  }
  if (permissions == null) permissions = new java.util.ArrayList<>();
  if (selectedPermissionIds == null) selectedPermissionIds = new java.util.ArrayList<>();
  
  Set<Long> selectedSet = new HashSet<>(selectedPermissionIds);
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
              <i class="bi bi-person-badge me-2"></i>Cập nhật Role
            </h1>
            <a href="${pageContext.request.contextPath}/admin/role" class="btn btn-outline-secondary">
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
              <form method="POST" action="${pageContext.request.contextPath}/admin/role/update">
                <input type="hidden" name="id" value="${role.roleId}">

                <div class="mb-3">
                  <label for="name" class="form-label">
                    Tên Role <span class="text-danger">*</span>
                  </label>
                  <input type="text" class="form-control" id="name" name="name" required 
                         value="${role.name}" placeholder="Nhập tên role">
                </div>

                <div class="mb-3">
                  <label for="description" class="form-label">Mô tả</label>
                  <textarea class="form-control" id="description" name="description" rows="3" 
                            placeholder="Nhập mô tả cho role">${role.description}</textarea>
                </div>

                <div class="mb-4">
                  <label class="form-label">
                    Permissions <span class="text-danger">*</span>
                  </label>
                  <div class="border rounded p-3" style="max-height: 400px; overflow-y: auto;">
                    <c:choose>
                      <c:when test="${empty permissions}">
                        <p class="text-muted mb-0">Chưa có permission nào</p>
                      </c:when>
                      <c:otherwise>
                        <div class="row">
                          <c:forEach var="permission" items="${permissions}">
                            <div class="col-md-6 mb-2">
                              <div class="form-check">
                                <input class="form-check-input" type="checkbox" 
                                       name="permissionIds" value="${permission.permissionId}" 
                                       id="perm_${permission.permissionId}"
                                       <%= selectedSet.contains(permission.getPermissionId()) ? "checked" : "" %>>
                                <label class="form-check-label" for="perm_${permission.permissionId}">
                                  <strong>${permission.code}</strong> - ${permission.name}
                                </label>
                              </div>
                            </div>
                          </c:forEach>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <small class="text-muted">Chọn các permission mà role này được phép sử dụng</small>
                </div>

                <div class="d-flex justify-content-end gap-2">
                  <a href="${pageContext.request.contextPath}/admin/role" class="btn btn-secondary">
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