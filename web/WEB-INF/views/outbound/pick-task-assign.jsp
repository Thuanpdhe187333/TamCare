<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<t:layout title="Assign Pick Tasks">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/pick-wave?action=list">Pick Wave</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/goods-delivery-note?action=detail&id=${wave.gdnId}">${wave.gdnNumber}</a></li>
                    <li class="breadcrumb-item active">Assign tasks</li>
                </ol>
            </nav>
            <a href="${pageContext.request.contextPath}/goods-delivery-note?action=detail&id=${wave.gdnId}" class="btn btn-outline-secondary">Back to GDN</a>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <p class="mb-0"><strong>Wave #${wave.waveId}</strong> – GDN ${wave.gdnNumber} (${wave.status})</p>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-dark text-white py-2">
                <h5 class="mb-0">Tasks – assign to warehouse staff</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr class="text-center">
                                <th>Task ID</th>
                                <th>GDN / SO</th>
                                <th>Status</th>
                                <th>Lines</th>
                                <th>Assigned to</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${tasks}">
                                <tr>
                                    <td class="text-center">${t.pickTaskId}</td>
                                    <td>${t.gdnNumber} / ${t.soNumber}</td>
                                    <td class="text-center">
                                        <span class="badge ${t.status == 'CREATED' ? 'bg-secondary' : (t.status == 'ASSIGNED' ? 'bg-info' : (t.status == 'IN_PROGRESS' ? 'bg-warning text-dark' : 'bg-success'))}">${t.status}</span>
                                    </td>
                                    <td class="text-center">${t.lines != null ? t.lines.size() : 0}</td>
                                    <td class="text-center">${t.assignedToName != null ? t.assignedToName : '–'}</td>
                                    <td>
                                        <c:if test="${t.status == 'CREATED' || t.status == 'ASSIGNED'}">
                                            <form action="${pageContext.request.contextPath}/pick-task" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="assign"/>
                                                <input type="hidden" name="pickTaskId" value="${t.pickTaskId}"/>
                                                <input type="hidden" name="waveId" value="${wave.waveId}"/>
                                                <select name="assignedTo" class="form-select form-select-sm" style="width: auto; display: inline-block;" required>
                                                    <option value="">-- Choose --</option>
                                                    <c:forEach var="u" items="${warehouseStaff}">
                                                        <option value="${u.userId}" ${t.assignedTo != null && t.assignedTo == u.userId ? 'selected' : ''}>${u.fullName}</option>
                                                    </c:forEach>
                                                </select>
                                                <button type="submit" class="btn btn-sm btn-primary ms-1">Assign</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${t.status == 'ASSIGNED' || t.status == 'IN_PROGRESS'}">
                                            <a href="${pageContext.request.contextPath}/pick-task?action=detail&id=${t.pickTaskId}" class="btn btn-sm btn-info text-white">View</a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</t:layout>
