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
  
  if (currentPage == null) currentPage = 1;
  if (totalPages == null) totalPages = 1;
  if (totalCount == null) totalCount = 0L;
  if (hasNext == null) hasNext = false;
  if (hasPrev == null) hasPrev = false;
%>

<html>
  <head>
    <%@include file="/WEB-INF/admin/layout/head.jspf"%>
  </head>

  <body class="d-flex flex-column" style="min-height: 100vh;">
    <%@include file="/WEB-INF/admin/layout/header.jspf"%>
    
    <%@include file="/WEB-INF/admin/layout/sidebar.jspf"%>
    
    <main class="flex-grow-1 container-fluid py-4">
      <%-- content --%>
    </main>
    
    <%@include file="/WEB-INF/admin/layout/footer.jspf"%>
    <%@include file="/WEB-INF/admin/layout/toast.jspf"%>
  </body>
</html>
