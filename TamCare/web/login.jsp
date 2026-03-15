<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đăng nhập - TamCare</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>

:root{
--main-bg:#e0effa;
--main-blue:#3b82f6;
--main-blue-dark:#2563eb;
--text-main:#1e293b;
}

body{
height:100vh;
margin:0;
display:flex;
align-items:center;
justify-content:center;

background:
linear-gradient(rgba(224,239,250,0.85),rgba(224,239,250,0.9)),
url('${pageContext.request.contextPath}/assets/img/login-bg.png');

background-size:cover;
background-position:center;
background-attachment:fixed;

font-family:'Lexend',sans-serif;
overflow:hidden;
position:relative;
}

/* watermark giữ nguyên */

body::before{
content:'';
position:fixed;
top:0;
left:0;
width:100%;
height:100%;
z-index:1;
pointer-events:none;
opacity:0.07;
background-image:
url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='40' height='40' viewBox='0 0 24 24' fill='%233b82f6'%3E%3Cpath d='M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z'/%3E%3C/svg%3E");
background-repeat:repeat;
}

/* container */

.login-container{
position:relative;
width:100%;
max-width:450px;
padding:20px;
z-index:10;
}

/* card */

.login-card{
background:rgba(255,255,255,0.95);
backdrop-filter:blur(12px);
border-radius:24px;
border:1px solid rgba(255,255,255,0.5);
padding:40px;
box-shadow:0 20px 40px rgba(0,0,0,0.15);
text-align:center;
animation:fadeInUp 0.6s ease-out;
}

@keyframes fadeInUp{
from{opacity:0;transform:translateY(30px);}
to{opacity:1;transform:translateY(0);}
}

/* logo */

.login-logo{
width:70px;
height:70px;
background:var(--main-blue);
color:white;
border-radius:18px;
display:flex;
align-items:center;
justify-content:center;
font-size:35px;
margin:0 auto 20px;
box-shadow:0 8px 18px rgba(59,130,246,0.4);
}

/* header */

.login-header h2{
font-size:28px;
font-weight:700;
color:var(--text-main);
margin-bottom:8px;
}

.login-header p{
color:#64748b;
font-size:15px;
margin-bottom:30px;
}

/* back button */

.back-home{
position:fixed;
top:30px;
left:30px;
color:white;
font-weight:600;
display:flex;
align-items:center;
gap:10px;
text-decoration:none;

background:rgba(59,130,246,0.9);
padding:10px 20px;
border-radius:40px;

transition:all 0.3s;
z-index:20;
}

.back-home:hover{
background:var(--main-blue-dark);
transform:translateX(-5px);
}

/* error */

.error-box{
background:#fff5f5;
color:#e53e3e;
padding:12px;
border-radius:12px;
margin-bottom:20px;
font-size:14px;
display:flex;
align-items:center;
gap:10px;
border:1px solid #fed7d7;
text-align:left;
}

/* form */

.form-group{
text-align:left;
margin-bottom:20px;
}

.form-group label{
display:block;
font-size:14px;
font-weight:600;
color:#334155;
margin-bottom:8px;
}

.input-wrapper{
position:relative;
}

.input-wrapper i{
position:absolute;
left:15px;
top:50%;
transform:translateY(-50%);
color:var(--main-blue);
opacity:0.8;
}

.input-wrapper input{
width:100%;
padding:14px 14px 14px 45px;
border-radius:12px;
border:1px solid #cbd5e1;
background:white;
font-size:15px;
box-sizing:border-box;
transition:all 0.3s;
}

.input-wrapper input:focus{
outline:none;
border-color:var(--main-blue);
box-shadow:0 0 0 2px rgba(59,130,246,0.2);
}

/* button */

.btn-login{
width:100%;
padding:15px;
background:var(--main-blue);
color:white;
border:none;
border-radius:12px;
font-size:16px;
font-weight:700;
cursor:pointer;

display:flex;
align-items:center;
justify-content:center;
gap:10px;

transition:0.3s;
margin-top:10px;
}

.btn-login:hover{
background:var(--main-blue-dark);
}

/* register */

.register-link{
margin-top:25px;
color:#64748b;
font-size:14px;
}

.register-link a{
color:var(--main-blue);
text-decoration:none;
font-weight:700;
}

</style>
</head>

<body>

<a href="${pageContext.request.contextPath}/index.jsp" class="back-home">
<i class="fa-solid fa-arrow-left"></i> Trang chủ
</a>

<div class="login-container">

<div class="login-card">

<div class="login-logo">
<i class="fa-solid fa-hand-holding-heart"></i>
</div>

<div class="login-header">
<h2>Xin Chào!</h2>
<p>Đăng nhập để chăm sóc sức khỏe tốt hơn</p>
</div>

<%
String error=(String)request.getAttribute("error");
if(error!=null){
%>

<div class="error-box">
<i class="fa-solid fa-circle-exclamation"></i>
<span><%=error%></span>
</div>

<% } %>

<form action="${pageContext.request.contextPath}/login" method="POST">

<div class="form-group">
<label>Email</label>
<div class="input-wrapper">
<i class="fa-solid fa-envelope"></i>
<input type="email" name="email" placeholder="example@gmail.com" required>
</div>
</div>

<div class="form-group">
<label>Mật khẩu</label>
<div class="input-wrapper">
<i class="fa-solid fa-lock"></i>
<input type="password" name="password" placeholder="••••••••" required>
</div>
</div>

<button type="submit" class="btn-login">
Đăng Nhập <i class="fa-solid fa-arrow-right-to-bracket"></i>
</button>

</form>

<div class="register-link">
Chưa có tài khoản?
<a href="${pageContext.request.contextPath}/register.jsp">Đăng ký ngay</a>
</div>

</div>
</div>

</body>
</html>