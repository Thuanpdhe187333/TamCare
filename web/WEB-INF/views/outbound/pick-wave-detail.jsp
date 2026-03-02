<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<t:layout title="Wave Detail">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/pick-wave?action=list">Pick Wave</a></li>
                    <li class="breadcrumb-item active">Wave #${wave.waveId}</li>
                </ol>
            </nav>
            <a href="${pageContext.request.contextPath}/pick-task?action=assign&waveId=${wave.waveId}" class="btn btn-primary">Assign tasks</a>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <p class="mb-0">
                    <strong>Wave #${wave.waveId}</strong>
                    – GDN
                    <a href="${pageContext.request.contextPath}/goods-delivery-note?action=detail&id=${wave.gdnId}">
                        ${wave.gdnNumber}
                    </a>
                    | Status: ${wave.status}
                    | Created: ${wave.createdAt}
                </p>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-dark text-white py-2"><h5 class="mb-0">Tasks</h5></div>
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr class="text-center">
                            <th>Task ID</th>
                            <th>GDN / SO</th>
                            <th>Status</th>
                            <th>Assigned to</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="t" items="${tasks}">
                            <tr>
                                <td class="text-center">${t.pickTaskId}</td>
                                <td>${t.gdnNumber} / ${t.soNumber}</td>
                                <td class="text-center"><span class="badge bg-info">${t.status}</span></td>
                                <td>${t.assignedToName != null ? t.assignedToName : '–'}</td>
                                <td><a href="${pageContext.request.contextPath}/pick-task?action=detail&id=${t.pickTaskId}" class="btn btn-sm btn-outline-primary">View</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</t:layout>
