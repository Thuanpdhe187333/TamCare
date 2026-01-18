<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
          <h1 class="mb-4">Dashboard</h1>
          <p>Welcome to the Admin Dashboard</p>
          <!-- Dashboard content goes here -->
        </div>
      </div>
    </main>
    
    <%@include file="/WEB-INF/admin/layout/footer.jspf"%>
    <%@include file="/WEB-INF/admin/layout/toast.jspf"%>
  </body>
</html>