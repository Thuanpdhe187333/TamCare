<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>

<html lang="vi">
  <head>
    <%@include file="/WEB-INF/admin/layout/head.jspf" %>
  </head>

  <body id="page-top">
    <div id="wrapper">
      <%@include file="/WEB-INF/admin/layout/sidebar.jspf" %>

      <div id="content-wrapper" class="d-flex flex-column">
        <div id="content">
          <%@include file="/WEB-INF/admin/layout/header.jspf" %>

          <div class="container-fluid">
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
              <h1 class="h3 mb-0 text-gray-800">Permission</h1>
              <a href="/warehouse-management/admin/permission/create" class="d-none d-sm-inline-block btn btn-primary shadow-sm">
                <i class="fas fa-plus fa-sm text-white-50"></i>
                <span>Create</span>
              </a>
            </div>

            <div class="card shadow-sm">
              <div class="card-body">
                <form method="POST" action="${pageContext.request.contextPath}/admin/permission/create">

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

        <%@include file="/WEB-INF/admin/layout/footer.jspf" %>
      </div>
    </div>

    <%@include file="/WEB-INF/admin/layout/others.jspf" %>
    <%@include file="/WEB-INF/admin/layout/script.jspf" %>
  </body>
</html>
