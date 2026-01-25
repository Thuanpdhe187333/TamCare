<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%> <%@taglib prefix="t"
tagdir="/WEB-INF/tags/" %>

<t:layout title="Permission Detail: ${permission.code}">
  <jsp:attribute name="actions">
    <t:link
      url="${pageContext.request.contextPath}/admin/permission"
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
        <div class="row align-items-center">
          <div class="col-auto">
            <div class="bg-primary-subtle text-primary p-4 rounded-circle">
              <i class="bi bi-shield-check fs-1"></i>
            </div>
          </div>
          <div class="col">
            <label class="text-muted small text-uppercase fw-bold mb-0"
              >Permission Code</label
            >
            <h3 class="fw-bold text-primary mb-1">${permission.code}</h3>
            <div class="fs-5 text-muted">${permission.name}</div>
          </div>
        </div>
      </div>
    </div>

    <c:set var="columns" value='${["Index", "Role Name", "Description"]}' />
    <t:table columns="${columns}">
      <jsp:attribute name="head">
        <div class="d-flex align-items-center justify-content-between">
          <h6 class="m-0 font-weight-bold text-primary">
            Roles Using This Permission
          </h6>
          <span class="badge bg-primary text-white">
            ${roles.size()} Total
          </span>
        </div>
      </jsp:attribute>
      <jsp:body>
        <c:choose>
          <c:when test="${empty roles}">
            <tr>
              <td colspan="3" class="text-center py-5">
                <i
                  class="bi bi-people-fill text-muted display-4 mb-2 d-block"
                ></i>
                <span class="text-muted italic"
                  >No roles currently assigned this permission</span
                >
              </td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="r" items="${roles}" varStatus="status">
              <tr>
                <td>${status.index + 1}</td>
                <td>
                  <div class="fw-bold">${r.name}</div>
                </td>
                <td>
                  <span class="text-muted small"
                    >${empty r.description ? 'No description' :
                    r.description}</span
                  >
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </jsp:body>
    </t:table>
  </jsp:body>
</t:layout>
