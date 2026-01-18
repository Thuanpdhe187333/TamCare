<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
  String error = (String) request.getAttribute("error");
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
        <div class="col-12 col-md-8 col-lg-6 mx-auto">
          <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 mb-0">
              <i class="bi bi-shield-lock me-2"></i>Tạo mới Permission
            </h1>
            <a href="${pageContext.request.contextPath}/admin/permission" class="btn btn-outline-secondary">
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
              <form method="POST" action="${pageContext.request.contextPath}/admin/permission">
                <input type="hidden" name="action" value="create">

                <div class="mb-3">
                  <label for="code" class="form-label">
                    Code <span class="text-danger">*</span>
                  </label>
                  <input type="text" class="form-control" id="code" name="code" required 
                         placeholder="Ví dụ: USER_VIEW, PRODUCT_CREATE">
                  <small class="text-muted">Code phải là duy nhất và viết hoa, cách nhau bằng dấu gạch dưới</small>
                </div>

                <div class="mb-3">
                  <label for="name" class="form-label">
                    Tên Permission <span class="text-danger">*</span>
                  </label>
                  <input type="text" class="form-control" id="name" name="name" required 
                         placeholder="Ví dụ: Xem người dùng, Tạo sản phẩm">
                </div>

                <div class="d-flex justify-content-end gap-2">
                  <a href="${pageContext.request.contextPath}/admin/permission" class="btn btn-secondary">
                    <i class="bi bi-x-circle me-1"></i>Hủy
                  </a>
                  <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-circle me-1"></i>Lưu
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