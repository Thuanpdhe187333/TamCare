<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
  java.util.List<model.Role> roles = (java.util.List<model.Role>) request.getAttribute("roles");
  Integer currentPage = (Integer) request.getAttribute("currentPage");
  Integer totalPages = (Integer) request.getAttribute("totalPages");
  Long totalCount = (Long) request.getAttribute("totalCount");
  Boolean hasNext = (Boolean) request.getAttribute("hasNext");
  Boolean hasPrev = (Boolean) request.getAttribute("hasPrev");
  String error = (String) request.getAttribute("error");
  String success = request.getParameter("success");
  
  if (currentPage == null) currentPage = 1;
  if (totalPages == null) totalPages = 1;
  if (totalCount == null) totalCount = 0L;
  if (hasNext == null) hasNext = false;
  if (hasPrev == null) hasPrev = false;
  if (roles == null) roles = new java.util.ArrayList<>();
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
        <div class="col-12">
          <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 mb-0">
              <i class="bi bi-person-badge me-2"></i>Quản lý Role
            </h1>
            <a href="${pageContext.request.contextPath}/admin/role/create" class="btn btn-primary">
              <i class="bi bi-plus-circle me-1"></i>Tạo mới
            </a>
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
                  <i class="bi bi-check-circle me-2"></i>Tạo role thành công!
                </c:when>
                <c:when test="${success == 'update'}">
                  <i class="bi bi-check-circle me-2"></i>Cập nhật role thành công!
                </c:when>
                <c:when test="${success == 'delete'}">
                  <i class="bi bi-check-circle me-2"></i>Xóa role thành công!
                </c:when>
              </c:choose>
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>

          <div class="card shadow-sm">
            <div class="card-body">
              <c:choose>
                <c:when test="${empty roles}">
                  <div class="text-center py-5">
                    <i class="bi bi-inbox display-1 text-muted"></i>
                    <p class="text-muted mt-3">Chưa có role nào</p>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="table-responsive">
                    <table class="table table-hover align-middle">
                      <thead class="table-light">
                        <tr>
                          <th>ID</th>
                          <th>Tên Role</th>
                          <th>Mô tả</th>
                          <th class="text-end">Thao tác</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="role" items="${roles}">
                          <tr>
                            <td>${role.roleId}</td>
                            <td><strong>${role.name}</strong></td>
                            <td>${role.description}</td>
                            <td class="text-end">
                              <a href="${pageContext.request.contextPath}/admin/role/update?id=${role.roleId}" 
                                 class="btn btn-sm btn-outline-primary me-1">
                                <i class="bi bi-pencil"></i> Sửa
                              </a>
                              <form method="POST" action="${pageContext.request.contextPath}/admin/role/delete" class="d-inline" 
                                    onsubmit="return confirm('Bạn có chắc chắn muốn xóa role này?');">
                                <input type="hidden" name="id" value="${role.roleId}">
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

                  <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-3">
                      <ul class="pagination justify-content-center">
                        <li class="page-item <%= !hasPrev ? "disabled" : "" %>">
                          <a class="page-link" href="?page=<%= currentPage - 1 %>">Trước</a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                          <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}">${i}</a>
                          </li>
                        </c:forEach>
                        <li class="page-item <%= !hasNext ? "disabled" : "" %>">
                          <a class="page-link" href="?page=<%= currentPage + 1 %>">Sau</a>
                        </li>
                      </ul>
                    </nav>
                    <div class="text-center text-muted mt-2">
                      Hiển thị <%= roles.size() %> / ${totalCount} role
                    </div>
                  </c:if>
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
