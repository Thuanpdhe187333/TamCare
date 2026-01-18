<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="model.Permission" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
  <head>
    <%@include file="/WEB-INF/admin/layout/head.jspf"%>
  </head>

  <body class="d-flex flex-column min-h-screen">
    <%@include file="/WEB-INF/admin/layout/header.jspf"%>
    <%@include file="/WEB-INF/admin/layout/sidebar.jspf"%>

    <main class="flex-grow-1 container-fluid py-4">
      <%-- content --%>
    </main>

    <%@include file="/WEB-INF/admin/layout/footer.jspf"%>
    <%@include file="/WEB-INF/admin/layout/toast.jspf"%>

    <!-- Include Form Dialog -->
    <%@include file="/WEB-INF/admin/views/permission/form.jsp"%>
  </body>
</html>
