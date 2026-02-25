<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<t:layout title="Pick Waves">
    <div class="container-fluid">
        <div class="card mb-4 shadow-sm">
            <div class="card-body">
                <form hx-get="${pageContext.request.contextPath}/pick-wave" hx-target="#wrapper" hx-select="#wrapper" hx-swap="outerHTML" hx-push-url="true" method="get" class="row g-3">
                    <input type="hidden" name="action" value="list"/>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">Status</label>
                        <select class="form-select" name="status">
                            <option value="">-- All --</option>
                            <option value="CREATED" ${param.status == 'CREATED' ? 'selected' : ''}>CREATED</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100"><i class="fas fa-search"></i> Filter</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="table-responsive shadow-sm rounded">
            <table class="table table-bordered table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr class="text-center">
                        <th>Wave ID</th>
                        <th>GDN Number</th>
                        <th>Status</th>
                        <th>Created at</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="w" items="${waves}">
                        <tr>
                            <td class="text-center">${w.waveId}</td>
                            <td><a href="${pageContext.request.contextPath}/goods-delivery-note?action=detail&id=${w.gdnId}">${w.gdnNumber}</a></td>
                            <td class="text-center"><span class="badge bg-secondary">${w.status}</span></td>
                            <td class="text-center">${w.createdAt}</td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/pick-task?action=assign&waveId=${w.waveId}" class="btn btn-sm btn-primary">Assign tasks</a>
                                <a href="${pageContext.request.contextPath}/pick-wave?action=detail&id=${w.waveId}" class="btn btn-sm btn-outline-secondary">Detail</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty waves}">
                        <tr><td colspan="5" class="text-center py-4 text-muted">No waves.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</t:layout>
