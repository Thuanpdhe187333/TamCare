
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.MedicalHistory"%>

<%
Integer profileId = (Integer) request.getAttribute("profileId");
if(profileId == null){
    profileId = Integer.parseInt(request.getParameter("profileId"));
}
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch sử bệnh án</title>

        <style>

            body{
                font-family: Arial;
                background:#f5f8ff;
                padding:40px;
            }

            .container{
                background:white;
                padding:30px;
                border-radius:10px;
                box-shadow:0 3px 10px rgba(0,0,0,0.1);
            }

            h2{
                color:#0066cc;
            }

            table{
                width:100%;
                border-collapse:collapse;
                margin-top:20px;
            }

            th{
                background:#0066cc;
                color:white;
                padding:10px;
            }

            td{
                padding:10px;
                border-bottom:1px solid #ddd;
                text-align:center;
            }

            tr:hover{
                background:#f2f6ff;
            }

            input{
                padding:6px;
                margin-right:10px;
            }

            button{
                padding:6px 12px;
                border:none;
                border-radius:5px;
                cursor:pointer;
            }

            .save-btn{
                background:#28a745;
                color:white;
            }

            .back-btn{
                background:#007bff;
                color:white;
            }

        </style>

    </head>

    <body>

        <div class="container">

            <h2>Lịch sử bệnh án</h2>

            <table>

                <tr>
                    <th>Mã bệnh</th>
                    <th>Bệnh</th>
                    <th>Loại bệnh</th>
                    <th>Trạng thái</th>
                </tr>

                <%
                List<MedicalHistory> list = (List<MedicalHistory>)request.getAttribute("histories");

                if(list != null && !list.isEmpty()){
                    for(MedicalHistory h : list){
                %>

                <tr>

                    <td><%= h.getDiseaseCode() %></td>

                    <td><%= h.getConditionName() %></td>

                    <td><%= h.getHistoryType() %></td>

                    <td><%= h.getCurrentStatus() %></td>

                </tr>

                <%
                }
                }else{
                %>

                <tr>
                    <td colspan="4">Chưa có bệnh án</td>
                </tr>

                <%
                }
                %>

            </table>

            <br><br>

            <h3>Thêm bệnh án</h3>

            <form method="post" action="MedicalHistoryServlet">

                <input type="hidden" name="profileId" value="<%=profileId%>">

                Tên bệnh:
                <input name="conditionName">

                Mã bệnh:
                <input name="diseaseCode">

                Loại bệnh:
                <input name="historyType">

                Trạng thái:
                <input name="currentStatus">

                <button class="save-btn" type="submit">Lưu</button>

            </form>

            <br>

            <!-- quay lại trang cá nhân -->
            <a href="home_elderly.jsp">
                <button class="back-btn">Quay lại trang cá nhân</button>
            </a>

        </div>

    </body>
</html>