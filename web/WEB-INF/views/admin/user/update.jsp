<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags/" %>

<t:layout title="Update User">
    <jsp:attribute name="actions">
        <t:link url="${pageContext.request.contextPath}/admin/user" variant="split" color="dark" icon="chevron-left">
            Go back
        </t:link>
    </jsp:attribute>

    <jsp:body>
        <div class="card shadow-sm">
            <div class="card-body">
                <form hx-put="${pageContext.request.contextPath}/admin/user?id=${user.userId}" class="m-0">
                    <input type="hidden" name="id" value="${user.userId}">

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control bg-light" id="username" value="${user.username}" readonly disabled>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName" required 
                                   value="${user.fullName}" placeholder="Example: John Doe">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email" required 
                                   value="${user.email}" placeholder="Example: john@example.com">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="phone" class="form-label">Phone</label>
                            <input type="text" class="form-control" id="phone" name="phone" 
                                   value="${user.phone}" placeholder="Example: 0987654321">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="status" class="form-label">Status</label>
                            <select class="form-select" id="status" name="status">
                                <option value="ACTIVE" <c:if test="${user.status == 'ACTIVE'}">selected</c:if>>Active</option>
                                <option value="INACTIVE" <c:if test="${user.status == 'INACTIVE'}">selected</c:if>>Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="warehouseId" class="form-label">Warehouse</label>
                            <select class="form-select" id="warehouseId" name="warehouseId">
                                <option value="">-- No Warehouse --</option>
                                <c:forEach var="w" items="${warehouses}">
                                    <option value="${w.warehouseId}" <c:if test="${user.warehouseId == w.warehouseId}">selected</c:if>>
                                        ${w.name} (${w.code})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Roles <span class="text-danger">*</span></label>
                        <div class="border rounded p-3 bg-light" style="max-height: 200px; overflow-y: auto;">
                            <c:choose>
                                <c:when test="${empty roles}">
                                    <p class="text-muted mb-0">No roles available</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="row">
                                        <c:forEach var="role" items="${roles}">
                                            <div class="col-md-4 mb-2">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" 
                                                           name="roleIds" value="${role.roleId}" 
                                                           id="role_${role.roleId}"
                                                           <c:if test="${selectedRoleIds.contains(role.roleId)}">checked</c:if>>
                                                    <label class="form-check-label" for="role_${role.roleId}">
                                                        ${role.name}
                                                    </label>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <t:link url="${pageContext.request.contextPath}/admin/user"
                                icon="x-circle" color="dark" variant="split">
                            Cancel
                        </t:link>
                        <t:button type="submit" variant="split" icon="check-circle" color="primary">
                            Update
                        </t:button>
                    </div>
                </form>
            </div>
        </div>
    </jsp:body>
</t:layout>