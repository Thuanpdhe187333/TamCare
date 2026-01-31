<%@tag description="Modal component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>

<%@attribute name="media" fragment="true"%>
<%@attribute name="title" fragment="true"%>
<%@attribute name="description" fragment="true"%>
<%@attribute name="action" fragment="true"%>

<div class="d-flex gap-2">
    <c:if test="${not empty media}">
        <div>
            ${media}
        </div>
    </c:if>
    <div class="d-flex flex-column flex-grow-1">
        <c:if test="${not empty title}">
            <div>
                ${title}
            </div>
        </c:if>
        <c:if test="${not empty description}">
            <div>
                ${description}
            </div>
        </c:if>
    </div>
    <c:if test="${not empty action}">
        <div>
            ${action}
        </div>
    </c:if>
</div>

