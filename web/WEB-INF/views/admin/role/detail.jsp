<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%> <%@taglib prefix="t"
tagdir="/WEB-INF/tags/" %>

<t:layout title="Role Detail: ${role.name}">
  <jsp:attribute name="actions">
    <t:link
      url="${pageContext.request.contextPath}/admin/role"
      variant="split"
      color="dark"
      icon="chevron-left"
    >
      Go back
    </t:link>
  </jsp:attribute>

  <jsp:body>
    <div class="card shadow-sm mb-4 border-0">
      <div class="card-body">
        <div class="mb-0">
          <label class="text-muted small text-uppercase fw-bold mb-1"
            >Role Name</label
          >
          <h4 class="fw-bold text-primary mb-1">${role.name}</h4>
          <p class="text-muted mb-0 fs-5">
            ${empty role.description ? 'No description available.' :
            role.description}
          </p>
        </div>
      </div>
    </div>

    <c:set var="columns" value='${["Index", "Permission Code", "Name"]}' />
    <t:table columns="${columns}">
      <jsp:attribute name="head">
        <div class="d-flex align-items-center justify-content-between">
          <h6 class="m-0 font-weight-bold text-primary">
            Assigned Permissions
          </h6>
          <span class="badge bg-primary text-white">
            ${permissions.size()} Total
          </span>
        </div>
      </jsp:attribute>
      <jsp:body>
        <c:choose>
          <c:when test="${empty permissions}">
            <tr>
              <td colspan="3" class="text-center py-5">
                <i
                  class="bi bi-shield-slash text-muted display-4 mb-2 d-block"
                ></i>
                <span class="text-muted italic"
                  >No permissions assigned to this role</span
                >
              </td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="p" items="${permissions}" varStatus="status">
              <tr>
                <td>${status.index + 1}</td>
                <td>
                  <div class="fw-bold fs-6 text-info">${p.code}</div>
                </td>
                <td>
                  <span class="text-muted">${p.name}</span>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </jsp:body>
    </t:table>
  </jsp:body>
</t:layout>
