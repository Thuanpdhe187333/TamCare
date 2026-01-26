<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%> <%@taglib prefix="t"
tagdir="/WEB-INF/tags/" %>

<t:layout title="User Detail">
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
    <div class="card shadow-sm border-0 d-flex flex-column mb-4">
      <div class="card-body">
        <div class="row row-cols-2 g-2">
          <div class="col">
            <label class="text-muted small text-uppercase fw-bold"
              >Username</label
            >
            <p class="mb-0 fs-5 fw-bold text-primary">${user.username}</p>
          </div>
          <div class="col">
            <label class="text-muted small text-uppercase fw-bold"
              >Full Name</label
            >
            <p class="mb-0 fs-5">${user.fullName}</p>
          </div>
          <div class="col">
            <label class="text-muted small text-uppercase fw-bold">Email</label>
            <p class="mb-0">${user.email}</p>
          </div>
          <div class="col">
            <label class="text-muted small text-uppercase fw-bold">Phone</label>
            <p class="mb-0 text-muted">
              ${empty user.phone ? 'Not provided' : user.phone}
            </p>
          </div>
          <div class="col">
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
          <div class="col">
            <label class="text-muted small text-uppercase fw-bold"
              >Created At</label
            >
            <p class="mb-0 text-muted">${user.createdAt}</p>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <!-- Roles and Permissions Accordion -->
      <div class="col-md-12">
        <div class="card shadow-sm border-0">
          <div class="card-header bg-white">
            <div class="d-flex align-items-center justify-content-between">
              <h6 class="m-0 font-weight-bold text-primary">
                Roles & Permissions
              </h6>
              <span class="badge bg-primary text-white"
                >${rolePermissionsMap.size()} Role(s)</span
              >
            </div>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${empty rolePermissionsMap}">
                <div class="text-center py-4 text-muted italic">
                  No roles assigned to this user
                </div>
              </c:when>
              <c:otherwise>
                <div class="accordion" id="rolesAccordion">
                  <c:forEach
                    var="entry"
                    items="${rolePermissionsMap}"
                    varStatus="status"
                  >
                    <div class="accordion-item border">
                      <h2 class="accordion-header" id="heading${status.index}">
                        <button
                          class="accordion-button collapsed"
                          type="button"
                          data-bs-toggle="collapse"
                          data-bs-target="#collapse${status.index}"
                          aria-expanded="false"
                          aria-controls="collapse${status.index}"
                        >
                          <div
                            class="d-flex align-items-center justify-content-between w-100 me-3"
                          >
                            <span class="fw-bold text-primary"
                              >${entry.key.name}</span
                            >
                            <span class="badge bg-info text-white ms-2"
                              >${entry.value.size()} Permission(s)</span
                            >
                          </div>
                        </button>
                      </h2>
                      <div
                        id="collapse${status.index}"
                        class="accordion-collapse collapse"
                        aria-labelledby="heading${status.index}"
                        data-bs-parent="#rolesAccordion"
                      >
                        <div class="accordion-body p-0">
                          <c:choose>
                            <c:when test="${empty entry.value}">
                              <div class="text-center py-3 text-muted italic">
                                No permissions assigned to this role
                              </div>
                            </c:when>
                            <c:otherwise>
                              <t:table
                                columns="${['Index', 'Permission Code', 'Permission Name']}"
                              >
                                <c:forEach
                                  var="perm"
                                  items="${entry.value}"
                                  varStatus="permStatus"
                                >
                                  <tr>
                                    <td>${permStatus.index + 1}</td>
                                    <td>
                                      <span class="badge bg-secondary"
                                        >${perm.code}</span
                                      >
                                    </td>
                                    <td class="text-muted">${perm.name}</td>
                                  </tr>
                                </c:forEach>
                              </t:table>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>
  </jsp:body>
</t:layout>
