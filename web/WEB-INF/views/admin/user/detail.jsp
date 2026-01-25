<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%> <%@taglib prefix="t"
tagdir="/WEB-INF/tags/" %>

<t:layout title="User Detail: ${user.username}">
  <jsp:attribute name="actions">
    <t:link
      url="${pageContext.request.contextPath}/admin/user"
      variant="split"
      color="dark"
      icon="chevron-left"
    >
      Go back
    </t:link>
  </jsp:attribute>

  <jsp:body>
    <div class="card shadow-sm border-0 d-flex flex-column gap-4">
      <div class="card-body mb-4">
        <div class="row">
          <div class="col-md-6 mb-3">
            <label class="text-muted small text-uppercase fw-bold"
              >Username</label
            >
            <p class="mb-0 fs-5 fw-bold text-primary">${user.username}</p>
          </div>
          <div class="col-md-6 mb-3">
            <label class="text-muted small text-uppercase fw-bold"
              >Full Name</label
            >
            <p class="mb-0 fs-5">${user.fullName}</p>
          </div>
          <div class="col-md-6 mb-3">
            <label class="text-muted small text-uppercase fw-bold">Email</label>
            <p class="mb-0">${user.email}</p>
          </div>
          <div class="col-md-6 mb-3">
            <label class="text-muted small text-uppercase fw-bold">Phone</label>
            <p class="mb-0 text-muted">
              ${empty user.phone ? 'Not provided' : user.phone}
            </p>
          </div>
          <div class="col-md-6 mb-3">
            <label class="text-muted small text-uppercase fw-bold"
              >Status</label
            >
            <p class="mb-0">
              <c:choose>
                <c:when test="${user.status == 'ACTIVE'}">
                  <span class="badge bg-success">Active</span>
                </c:when>
                <c:otherwise>
                  <span class="badge bg-secondary">Inactive</span>
                </c:otherwise>
              </c:choose>
            </p>
          </div>
          <div class="col-md-6 mb-3">
            <label class="text-muted small text-uppercase fw-bold"
              >Created At</label
            >
            <p class="mb-0 text-muted">${user.createdAt}</p>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <!-- Assigned Roles Table -->
      <div class="col-md-12">
        <c:set var="roleColumns" value='${["Index", "Role Name"]}' />
        <t:table columns="${roleColumns}">
          <jsp:attribute name="head">
            <div class="d-flex align-items-center justify-content-between">
              <h6 class="m-0 font-weight-bold text-primary">Assigned Roles</h6>
              <span class="badge bg-primary text-white"
                >${roles.size()} Total</span
              >
            </div>
          </jsp:attribute>
          <jsp:body>
            <c:choose>
              <c:when test="${empty roles}">
                <tr>
                  <td colspan="2" class="text-center py-4 text-muted italic">
                    No roles assigned
                  </td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="r" items="${roles}" varStatus="status">
                  <tr>
                    <td style="width: 50px">${status.index + 1}</td>
                    <td>
                      <div class="fw-bold">${r.name}</div>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </jsp:body>
        </t:table>
      </div>

      <!-- Inherited Permissions Table -->
      <div class="col-md-12">
        <c:set var="permColumns" value='${["Index", "Permission Code"]}' />
        <t:table columns="${permColumns}">
          <jsp:attribute name="head">
            <div class="d-flex align-items-center justify-content-between">
              <h6 class="m-0 font-weight-bold text-primary">
                Inherited Permissions
              </h6>
              <span class="badge bg-primary text-white"
                >${permissions.size()} Total</span
              >
            </div>
          </jsp:attribute>
          <jsp:body>
            <c:choose>
              <c:when test="${empty permissions}">
                <tr>
                  <td colspan="2" class="text-center py-4 text-muted italic">
                    No permissions inherited
                  </td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="p" items="${permissions}" varStatus="status">
                  <tr>
                    <td style="width: 50px">${status.index + 1}</td>
                    <td>
                      <div class="d-flex align-items-center">
                        <div class="fw-bold text-info">${p.code}</div>
                        <div class="ms-2 small text-muted">(${p.name})</div>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </jsp:body>
        </t:table>
      </div>
    </div>
  </jsp:body>
</t:layout>
