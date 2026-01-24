<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags/" %>
<%@page import="java.util.*" %>

<%
  List<Long> selectedPermissionIds = (List<Long>) request.getAttribute("selectedPermissionIds");
  Set<Long> selectedSet = new HashSet<>(selectedPermissionIds != null ? selectedPermissionIds : Collections.emptyList());
  request.setAttribute("selectedSet", selectedSet);
%>

<t:layout title="Update Role">
    <jsp:attribute name="actions">
        <t:link url="${pageContext.request.contextPath}/admin/role" variant="split" color="dark" icon="chevron-left">
            Go back
        </t:link>
    </jsp:attribute>

    <jsp:body>
        <div class="card shadow-sm">
            <div class="card-body">
                <form hx-put="${pageContext.request.contextPath}/admin/role?id=${role.roleId}" class="m-0">
                    <input type="hidden" name="id" value="${role.roleId}">

                    <div class="mb-3">
                        <label for="name" class="form-label">
                            Role Name <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control" id="name" name="name" required 
                               value="${role.name}" placeholder="Example: ADMIN, WAREHOUSE_MANAGER">
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3" 
                                  placeholder="Role responsibilities and access level">${role.description}</textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">
                            Permissions <span class="text-danger">*</span>
                        </label>
                        <div class="border rounded p-3 bg-light" style="max-height: 300px; overflow-y: auto;">
                            <c:choose>
                                <c:when test="${empty permissions}">
                                    <p class="text-muted mb-0">No permissions available</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="row">
                                        <c:forEach var="permission" items="${permissions}">
                                            <div class="col-md-6 mb-2">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" 
                                                           name="permissionIds" value="${permission.permissionId}" 
                                                           id="perm_${permission.permissionId}"
                                                           <c:if test="${selectedSet.contains(permission.permissionId)}">checked</c:if>>
                                                    <label class="form-check-label" for="perm_${permission.permissionId}">
                                                        <strong>${permission.code}</strong> - ${permission.name}
                                                    </label>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <small class="text-muted">Select the capabilities assigned to this role</small>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <t:link url="${pageContext.request.contextPath}/admin/role"
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