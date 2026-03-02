<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<t:layout title="Pick Task Detail">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/pick-task?action=myTasks">My Tasks</a></li>
                    <li class="breadcrumb-item active">Task #${task.pickTaskId}</li>
                </ol>
            </nav>
            <span class="badge ${task.status == 'ASSIGNED' ? 'bg-info' : (task.status == 'IN_PROGRESS' ? 'bg-warning text-dark' : 'bg-success')} px-3 py-2">
                ${task.status}
            </span>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-primary text-white py-2">
                <h5 class="mb-0">Task #${task.pickTaskId} – ${task.gdnNumber} / ${task.soNumber}</h5>
            </div>
            <div class="card-body">
                <div class="row row-cols-2 row-cols-md-4 g-2 small">
                    <div class="col"><strong>GDN:</strong> ${task.gdnNumber}</div>
                    <div class="col"><strong>SO:</strong> ${task.soNumber}</div>
                    <div class="col"><strong>Assigned at:</strong> <c:out value="${task.assignedAt}" /></div>
                    <c:if test="${not empty task.completedAt}">
                        <div class="col"><strong>Completed at:</strong> <c:out value="${task.completedAt}" /></div>
                    </c:if>
                </div>
            </div>
        </div>

        <c:if test="${task.status == 'ASSIGNED'}">
            <form action="${pageContext.request.contextPath}/pick-task" method="post" class="mb-3">
                <input type="hidden" name="action" value="start"/>
                <input type="hidden" name="id" value="${task.pickTaskId}"/>
                <button type="submit" class="btn btn-success"><i class="fas fa-play me-1"></i> Start</button>
            </form>
        </c:if>

        <div class="card shadow-sm">
            <div class="card-header bg-dark text-white py-2">
                <h5 class="mb-0">Pick lines (Slot / Qty)</h5>
            </div>
            <div class="card-body p-0">
                <form action="${pageContext.request.contextPath}/pick-task" method="post" id="completeForm">
                    <input type="hidden" name="action" value="complete"/>
                    <input type="hidden" name="pickTaskId" value="${task.pickTaskId}"/>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr class="text-center">
                                    <th>Slot / Zone</th>
                                    <th>Variant / Product</th>
                                    <th>Qty to pick</th>
                                    <th>Qty picked</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="line" items="${task.lines}">
                                    <tr>
                                        <td class="text-center">${line.slotCode} / ${line.zoneCode}</td>
                                        <td>${line.variantSku} – ${line.productName} <c:if test="${not empty line.color or not empty line.size}"><small class="text-muted">(${line.color}, ${line.size})</small></c:if></td>
                                        <td class="text-center"><strong><fmt:formatNumber value="${line.qtyToPick}" maxFractionDigits="0"/></strong></td>
                                        <td class="text-center">
                                            <input type="hidden" name="lineIds" value="${line.pickTaskLineId}"/>
                                            <input type="number" name="qtyPicked" class="form-control form-control-sm text-center" min="0" step="1" value="${line.qtyPicked != null ? line.qtyPicked.stripTrailingZeros().toPlainString() : '0'}" style="max-width: 80px; margin: 0 auto;"/>
                                        </td>
                                        <td class="text-center">${line.pickStatus}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${task.status == 'IN_PROGRESS'}">
                        <div class="card-footer bg-light">
                            <button type="submit" class="btn btn-primary"><i class="fas fa-check me-1"></i> Complete</button>
                            <a href="${pageContext.request.contextPath}/pick-task?action=myTasks" class="btn btn-outline-secondary">Back</a>
                        </div>
                    </c:if>
                </form>
            </div>
        </div>
        <c:if test="${task.status != 'IN_PROGRESS' && task.status != 'ASSIGNED'}">
            <a href="${pageContext.request.contextPath}/pick-task?action=myTasks" class="btn btn-outline-secondary mt-2">Back to My Tasks</a>
        </c:if>
    </div>
</t:layout>
