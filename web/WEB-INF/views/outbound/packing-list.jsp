<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<t:layout title="Packing">
    <div class="container-fluid">
        <div class="card mb-4 shadow-sm">
            <div class="card-body">
                <form hx-get="${pageContext.request.contextPath}/packing" hx-target="#wrapper" hx-select="#wrapper" hx-swap="outerHTML" hx-push-url="true" method="get" class="row g-3">
                    <input type="hidden" name="action" value="list"/>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">Status</label>
                        <select class="form-select" name="status">
                            <option value="">-- All --</option>
                            <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                            <option value="DONE" ${param.status == 'DONE' ? 'selected' : ''}>DONE</option>
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
                        <th>Pack ID</th>
                        <th>GDN Number</th>
                        <th>Status</th>
                        <th>Packed by / at</th>
                        <th>Label</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${packings}">
                        <tr>
                            <td class="text-center">${p.packId}</td>
                            <td>${p.gdnNumber}</td>
                            <td class="text-center"><span class="badge ${p.status == 'DONE' ? 'bg-success' : 'bg-warning text-dark'}">${p.status}</span></td>
                            <td class="text-center">
                                ${p.packedByName}
                                <c:if test="${not empty p.packedAt}">
                                    / <c:out value="${p.packedAt}" />
                                </c:if>
                            </td>
                            <td>${p.packageLabel}</td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/packing?action=form&gdnId=${p.gdnId}" class="btn btn-sm btn-primary">Open</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty packings}">
                        <tr><td colspan="6" class="text-center py-4 text-muted">No packing records.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</t:layout>
