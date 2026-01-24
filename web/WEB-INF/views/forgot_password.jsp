<%-- 
    Document   : forgot_password
    Created on : Jan 22, 2026, 9:19:09 PM
    Author     : chaua
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <%@include file="/WEB-INF/views/layout/head.jspf" %>
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">
  <%@include file="/WEB-INF/views/layout/header.jspf" %>

  <main class="flex-grow-1 container">
    <h3>Quên mật khẩu</h3>

    <!--Submit email -->
    <form action="${pageContext.request.contextPath}/authen" method="post">
      <input type="hidden" name="action" value="forgot">

      <div class="mb-3">
        <label>Email</label>
        <input class="form-control" type="email" name="email" required>
      </div>

      <button class="btn btn-primary" type="submit">Gửi link đặt lại mật khẩu</button>
    </form>

    <!-- Step 2: Thông báo chung -->
    <% if (request.getAttribute("msg") != null) { %>
      <p class="mt-3"><%= request.getAttribute("msg") %></p>
    <% } %>

    <!-- DEV ONLY: show reset link để test khi chưa gửi email thật -->
    <% if (request.getAttribute("resetLink") != null) { %>
      <p class="mt-2">
        <a href="<%= request.getAttribute("resetLink") %>">Reset link (dev)</a>
      </p>
    <% } %>

    <p class="mt-3">
      <a href="${pageContext.request.contextPath}/authen">Quay lại đăng nhập</a>
    </p>
  </main>

  <%@include file="/WEB-INF/views/layout/footer.jspf" %>
</body>
</html>