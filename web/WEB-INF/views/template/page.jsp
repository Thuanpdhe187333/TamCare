<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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

            <!-- YOUR PAGE CONTENT GOES HERE -->
          </div>
        </div>

        <%@include file="/WEB-INF/admin/layout/footer.jspf" %>
      </div>
    </div>

    <%@include file="/WEB-INF/admin/layout/others.jspf" %>
    <%@include file="/WEB-INF/admin/layout/script.jspf" %>
  </body>
</html>
