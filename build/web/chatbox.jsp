<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    /* Nút chat nổi cực lớn */
    .chat-btn-floating {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 80px; /* To hơn */
        height: 80px;
        background-color: #0066cc;
        color: white;
        border-radius: 50%;
        text-align: center;
        line-height: 80px;
        font-size: 40px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        cursor: pointer;
        z-index: 9999;
        border: 4px solid white;
    }

    .chat-window {
        position: fixed;
        bottom: 120px;
        right: 30px;
        width: 350px; /* Rộng hơn */
        height: 500px; /* Cao hơn */
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        display: none;
        flex-direction: column;
        z-index: 9999;
        font-family: 'Segoe UI', sans-serif;
        border: 2px solid #0066cc;
    }

    .chat-header {
        background-color: #0066cc;
        color: white;
        padding: 20px;
        font-size: 20px;
        font-weight: bold;
        display: flex;
        justify-content: space-between;
    }

    .chat-body {
        flex: 1;
        padding: 20px;
        overflow-y: auto;
        background-color: #f9f9f9;
        font-size: 18px; /* Chữ chat to */
    }

    .message {
        padding: 12px 18px;
        border-radius: 20px;
        margin-bottom: 15px;
        max-width: 80%;
        line-height: 1.4;
    }
    .bot-message {
        background-color: #e1ecf4;
        color: #333;
        border: 1px solid #ccc;
    }
    .user-message {
        background-color: #0066cc;
        color: white;
        align-self: flex-end;
        margin-left: auto;
    }

    .chat-footer {
        padding: 15px;
        background: white;
        border-top: 1px solid #ddd;
        display: flex;
    }
    .chat-footer input {
        flex: 1;
        padding: 15px;
        border: 2px solid #ccc;
        border-radius: 30px;
        font-size: 16px;
    }
    .chat-footer button {
        background: #0066cc;
        color: white;
        border: none;
        padding: 10px 20px;
        margin-left: 10px;
        border-radius: 30px;
        font-weight: bold;
        cursor: pointer;
    }
</style>

<div class="chat-btn-floating" onclick="toggleChat()">💬</div>

<div class="chat-window" id="chatWindow">
    <div class="chat-header">
        <span>Trợ lý TamCare 🤖</span>
        <span style="cursor: pointer;" onclick="toggleChat()">❌</span>
    </div>
    <div class="chat-body" id="chatBody">
        <div class="message bot-message">Chào bác! Cháu là trợ lý ảo. Bác thấy trong người thế nào ạ?</div>
    </div>
    <div class="chat-footer">
        <input type="text" id="chatInput" placeholder="Nhập tin nhắn..." onkeypress="handleEnter(event)">
        <button onclick="sendMessage()">Gửi</button>
    </div>
</div>

<script>
    function toggleChat() {
        var cw = document.getElementById("chatWindow");
        cw.style.display = (cw.style.display === "flex") ? "none" : "flex";
    }
    function handleEnter(e) {
        if (e.key === 'Enter')
            sendMessage();
    }

    function sendMessage() {
        var input = document.getElementById("chatInput");
        var msg = input.value.trim();
        var body = document.getElementById("chatBody");
        if (msg) {
            var userDiv = document.createElement("div");
            userDiv.className = "message user-message";
            userDiv.textContent = msg;
            body.appendChild(userDiv);
            input.value = "";
            body.scrollTop = body.scrollHeight;

            setTimeout(function () {
                var botDiv = document.createElement("div");
                botDiv.className = "message bot-message";
                botDiv.textContent = "Dạ, cháu đã ghi nhận: \"" + msg + "\". Cháu sẽ báo lại cho bác sĩ ngay ạ.";
                body.appendChild(botDiv);
                body.scrollTop = body.scrollHeight;
            }, 1000);
        }
    }
</script>