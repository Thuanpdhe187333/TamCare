<%@tag description="Modal component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>

<%@attribute name="id" required="true" type="java.lang.String"%>
<%@attribute name="title" type="java.lang.String"%>
<%@attribute name="icon" type="java.lang.String"%>
<%@attribute name="size" type="java.lang.String"%> <!-- sm, lg, xl -->
<%@attribute name="centered" type="java.lang.Boolean"%>
<%@attribute name="scrollable" type="java.lang.Boolean"%>
<%@attribute name="staticBackdrop" type="java.lang.Boolean"%>
<%@attribute name="confirmLabel" type="java.lang.String"%>
<%@attribute name="confirmColor" type="java.lang.String"%>
<%@attribute name="confirmId" type="java.lang.String"%>
<%@attribute name="confirmType" type="java.lang.String"%> <!-- button, submit -->
<%@attribute name="confirmForm" type="java.lang.String"%>
<%@attribute name="cancelLabel" type="java.lang.String"%>
<%@attribute name="footer" fragment="true" %>

<div class="modal fade" id="${id}" 
     ${staticBackdrop ? 'data-bs-backdrop="static" data-bs-keyboard="false"' : ''} 
     tabindex="-1" aria-labelledby="${id}Label" aria-hidden="true">
    <div class="modal-dialog ${not empty size ? 'modal-'.concat(size) : ''} ${centered ? 'modal-dialog-centered' : ''} ${scrollable ? 'modal-dialog-scrollable' : ''}">
        <div class="modal-content shadow">
            <div class="modal-header">
                <h5 class="modal-title d-flex align-items-center" id="${id}Label">
                    <c:if test="${not empty icon}">
                        <i class="bi bi-${icon} me-2"></i>
                    </c:if>
                    ${title}
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <jsp:doBody/>
            </div>
            <div class="modal-footer">
                <c:choose>
                    <c:when test="${not empty footer}">
                        <jsp:invoke fragment="footer" />
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            ${empty cancelLabel ? 'Close' : cancelLabel}
                        </button>
                        <c:if test="${not empty confirmLabel}">
                            <button type="${empty confirmType ? 'button' : confirmType}" 
                                    id="${confirmId}"
                                    form="${confirmForm}"
                                    class="btn btn-${empty confirmColor ? 'primary' : confirmColor}">
                                ${confirmLabel}
                            </button>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>