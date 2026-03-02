<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<t:layout title="My Pick Tasks">
    <div class="container-fluid">
        <div class="card mb-4 shadow-sm">
            <div class="card-body">
                <form hx-get="${pageContext.request.contextPath}/pick-task" hx-target="#wrapper" hx-select="#wrapper" hx-swap="outerHTML" hx-push-url="true" method="get" class="row g-3">
                    <input type="hidden" name="action" value="myTasks">
                    <div class="col-md-3">
                        <label class="form-label font-weight-bold">Status</label>
                        <select class="form-control" name="status">
                            <option value="">-- All --</option>
                            <option value="ASSIGNED" ${param.status=='ASSIGNED' ? 'selected' : '' }>ASSIGNED</option>
                            <option value="IN_PROGRESS" ${param.status=='IN_PROGRESS' ? 'selected' : '' }>IN_PROGRESS</option>
                            <option value="COMPLETED" ${param.status=='COMPLETED' ? 'selected' : '' }>COMPLETED</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search"></i> Filter
                        </button>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <a href="${pageContext.request.contextPath}/pick-task?action=myTasks"
                            class="btn btn-secondary w-100">Reset</a>
                    </div>
                </form>
            </div>
        </div>

        <div class="table-responsive shadow-sm rounded">
            <table class="table table-bordered table-hover table-striped align-middle mb-0">
                <thead class="thead-dark">
                    <tr class="text-center">
                        <th>Pick Task ID</th>
                        <th>GDN Number</th>
                        <th>Sales Order</th>
                        <th>Status</th>
                        <th>Assigned At</th>
                        <th>Completed At</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="task" items="${tasks}">
                        <tr>
                            <td class="text-center">${task.pickTaskId}</td>
                            <td class="font-weight-bold text-primary">${task.gdnNumber}</td>
                            <td>${task.soNumber}</td>
                            <td class="text-center">
                                <span class="badge badge-pill ${task.status == 'ASSIGNED' ? 'badge-info' : (task.status == 'IN_PROGRESS' ? 'badge-warning' : 'badge-success')}">
                                    ${task.status}
                                </span>
                            </td>
                            <td class="text-center">
                                <c:out value="${task.assignedAt}" />
                            </td>
                            <td class="text-center">
                                <c:if test="${not empty task.completedAt}">
                                    <c:out value="${task.completedAt}" />
                                </c:if>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/pick-task?action=detail&id=${task.pickTaskId}"
                                    class="btn btn-sm btn-info shadow-sm text-white">
                                    <i class="fas fa-eye me-1"></i> View
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty tasks}">
                        <tr>
                            <td colspan="7" class="text-center py-4 text-muted">No pick tasks assigned to you.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</t:layout>
