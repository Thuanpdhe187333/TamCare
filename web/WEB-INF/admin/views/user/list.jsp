<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="model.User" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
  List<User> users = (List<User>) request.getAttribute("users");
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
  if (users == null) users = new java.util.ArrayList<>();
  
  // Load DAOs for role names
  dao.UserDAO userDAO = new dao.UserDAO();
  dao.RoleDAO roleDAO = new dao.RoleDAO();
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
              <i class="bi bi-people me-2"></i>Quản lý User
            </h1>
            <form method="POST" action="${pageContext.request.contextPath}/admin/user" class="mb-0">
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
                  <i class="bi bi-check-circle me-2"></i>Tạo user thành công!
                </c:when>
                <c:when test="${success == 'update'}">
                  <i class="bi bi-check-circle me-2"></i>Cập nhật user thành công!
                </c:when>
                <c:when test="${success == 'delete'}">
                  <i class="bi bi-check-circle me-2"></i>Xóa user thành công!
                </c:when>
              </c:choose>
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>

          <div class="card shadow-sm">
            <div class="card-body">
              <c:choose>
                <c:when test="${empty users}">
                  <div class="text-center py-5">
                    <i class="bi bi-inbox display-1 text-muted"></i>
                    <p class="text-muted mt-3">Chưa có user nào</p>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="table-responsive">
                    <table class="table table-hover align-middle">
                      <thead class="table-light">
                        <tr>
                          <th>ID</th>
                          <th>Username</th>
                          <th>Họ tên</th>
                          <th>Email</th>
                          <th>Số điện thoại</th>
                          <th>Role(s)</th>
                          <th>Trạng thái</th>
                          <th class="text-end">Thao tác</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="user" items="${users}">
                          <tr>
                            <td>${user.userId}</td>
                            <td><strong>${user.username}</strong></td>
                            <td>${user.fullName}</td>
                            <td>${user.email}</td>
                            <td>${user.phone}</td>
                            <td>
                              <%
                                User u = (User) pageContext.getAttribute("user");
                                List<Long> roleIds = userDAO.getRolesByUserId(u.getUserId());
                                List<String> roleNames = new java.util.ArrayList<>();
                                for (Long roleId : roleIds) {
                                  model.Role role = roleDAO.getById(roleId);
                                  if (role != null) {
                                    roleNames.add(role.getName());
                                  }
                                }
                                String rolesStr = String.join(", ", roleNames);
                                pageContext.setAttribute("rolesStr", rolesStr.isEmpty() ? "Chưa gán" : rolesStr);
                              %>
                              <small>${rolesStr}</small>
                            </td>
                            <td>
                              <c:choose>
                                <c:when test="${user.status == 'ACTIVE'}">
                                  <span class="badge bg-success">Hoạt động</span>
                                </c:when>
                                <c:when test="${user.status == 'INACTIVE'}">
                                  <span class="badge bg-secondary">Khóa</span>
                                </c:when>
                                <c:otherwise>
                                  <span class="badge bg-warning">${user.status}</span>
                                </c:otherwise>
                              </c:choose>
                            </td>
                            <td class="text-end">
                              <form method="POST" action="${pageContext.request.contextPath}/admin/user" class="d-inline">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${user.userId}">
                                <button type="submit" class="btn btn-sm btn-outline-primary me-1">
                                  <i class="bi bi-pencil"></i> Sửa
                                </button>
                              </form>
                              <form method="POST" action="${pageContext.request.contextPath}/admin/user" class="d-inline" 
                                    onsubmit="return confirm('Bạn có chắc chắn muốn xóa user này?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${user.userId}">
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
                      Hiển thị <%= users.size() %> / ${totalCount} user
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