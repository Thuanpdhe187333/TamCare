<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="model.Permission" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
  List<Permission> permissions = (List<Permission>) request.getAttribute("permissions");
  Long totalCount = (Long) request.getAttribute("totalCount");
  String error = (String) request.getAttribute("error");
  String success = request.getParameter("success");
  
  if (permissions == null) permissions = new java.util.ArrayList<>();
  if (totalCount == null) totalCount = 0L;
%>

<html>
  <head>
    <%@include file="/WEB-INF/admin/layout/head.jspf"%>
  </head>

  <body class="d-flex flex-column min-h-screen">
    <%@include file="/WEB-INF/admin/layout/header.jspf"%>
    <%@include file="/WEB-INF/admin/layout/sidebar.jspf"%>

    <main class="flex-grow-1 container-fluid py-4">
      <div class="row">
        <div class="col-12">
          <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 mb-0">
              <i class="bi bi-shield-lock me-2"></i>Quản lý Permission
            </h1>
            <form method="POST" action="${pageContext.request.contextPath}/admin/permission" class="mb-0">
              <input type="hidden" name="action" value="new">
              <button type="submit" class="btn btn-primary">
                <i class="bi bi-plus-circle me-1"></i>Tạo mới
              </button>
            </form>
          </div>

          <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <i class="bi bi-exclamation-triangle me-2"></i>${error}
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>

          <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
              <c:choose>
                <c:when test="${success == 'create'}">
                  <i class="bi bi-check-circle me-2"></i>Tạo permission thành công!
                </c:when>
                <c:when test="${success == 'update'}">
                  <i class="bi bi-check-circle me-2"></i>Cập nhật permission thành công!
                </c:when>
                <c:when test="${success == 'delete'}">
                  <i class="bi bi-check-circle me-2"></i>Xóa permission thành công!
                </c:when>
              </c:choose>
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>

          <div class="card shadow-sm">
            <div class="card-body">
              <c:choose>
                <c:when test="${empty permissions}">
                  <div class="text-center py-5">
                    <i class="bi bi-inbox display-1 text-muted"></i>
                    <p class="text-muted mt-3">Chưa có permission nào</p>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="table-responsive">
                    <table class="table table-hover align-middle">
                      <thead class="table-light">
                        <tr>
                          <th>ID</th>
                          <th>Code</th>
                          <th>Tên Permission</th>
                          <th class="text-end">Thao tác</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="permission" items="${permissions}">
                          <tr>
                            <td>${permission.permissionId}</td>
                            <td><code class="text-primary">${permission.code}</code></td>
                            <td><strong>${permission.name}</strong></td>
                            <td class="text-end">
                              <form method="POST" action="${pageContext.request.contextPath}/admin/permission" class="d-inline">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${permission.permissionId}">
                                <button type="submit" class="btn btn-sm btn-outline-primary me-1">
                                  <i class="bi bi-pencil"></i> Sửa
                                </button>
                              </form>
                              <form method="POST" action="${pageContext.request.contextPath}/admin/permission" class="d-inline" 
                                    onsubmit="return confirm('Bạn có chắc chắn muốn xóa permission này?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${permission.permissionId}">
                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                  <i class="bi bi-trash"></i> Xóa
                                </button>
                              </form>
                            </td>
                          </tr>
                        </c:forEach>
                      </tbody>
                    </table>
                  </div>
                  <div class="text-center text-muted mt-3">
                    Tổng cộng: ${totalCount} permission
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </div>
    </main>

    <%@include file="/WEB-INF/admin/layout/footer.jspf"%>
    <%@include file="/WEB-INF/admin/layout/toast.jspf"%>
  </body>
</html>