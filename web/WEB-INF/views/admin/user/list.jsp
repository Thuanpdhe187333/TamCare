<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@page import="model.User" %>

<t:layout title="User">
    <jsp:attribute name="actions">
        <t:link
          url="${pageContext.request.contextPath}/admin/user/create"
          color="primary"
          variant="split"
          icon="plus-lg"
          >
            Create
        </t:link>
    </jsp:attribute>

    <jsp:body>
        <c:set var="columns" value='${["Index", "Username", "Full Name", "Email", "Phone", "Role(s)", "Status", "Action"]}' />
        <t:table columns="${columns}">
            <jsp:attribute name="head">
                <form
                  hx-get="${pageContext.request.contextPath}/admin/user"
                  hx-target="#wrapper"
                  hx-select="#wrapper"
                  hx-swap="outerHTML"
                  hx-push-url="true"
                  hx-trigger="change from:select, submit"
                  class="d-flex align-items-center gap-2 m-0"
                  >
                    <select
                      name="roleId"
                      class="form-select w-auto"
                      aria-label="Filter by role"
                      >
                        <option value="">All Roles</option>
                        <c:forEach var="r" items="${availableRoles}">
                            <option value="${r.roleId}" ${roleId == r.roleId ? 'selected' : ''}>
                                ${r.name}
                            </option>
                        </c:forEach>
                    </select>

                    <select
                      name="status"
                      class="form-select w-auto"
                      aria-label="Filter by status"
                      >
                        <option value="">All Status</option>
                        <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                        <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                    </select>

                    <div class="input-group">
                        <input
                          name="search"
                          class="form-control"
                          placeholder="Search"
                          value="${search}"
                          />
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </form>
            </jsp:attribute>

            <jsp:attribute name="foot">
                <t:pagination
                  page="${page}"
                  pages="${pages}"
                  size="${size}"
                  total="${total}"
                  url="${pageContext.request.contextPath}/admin/user"
                  include="[name='search'], [name='sort'], [name='roleId'], [name='status']"
                  />
            </jsp:attribute>

            <jsp:body>
                <c:forEach var="user" items="${users}" varStatus="status">
                    <tr>
                        <td>${status.index + 1 + (page - 1) * size}</td>
                        <td><strong>${user.username}</strong></td>
                        <td>${user.fullName}</td>
                        <td><small>${user.email}</small></td>
                        <td><small>${user.phone}</small></td>
                        <td>
                            <small>${empty user.roleNames ? 'No roles' : user.roleNames}</small>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${user.status == 'ACTIVE'}">
                                    <span class="badge bg-success">Active</span>
                                </c:when>
                                <c:when test="${user.status == 'INACTIVE'}">
                                    <span class="badge bg-secondary">Inactive</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning">${user.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a
                              href="${pageContext.request.contextPath}/admin/user/detail?id=${user.userId}"
                              class="btn btn-sm btn-circle btn-outline-info me-1"
                              title="View Detail"
                              >
                                <i class="bi bi-eye fab"></i>
                            </a>

                            <a
                              href="${pageContext.request.contextPath}/admin/user/update?id=${user.userId}"
                              class="btn btn-sm btn-circle btn-outline-primary me-1"
                              title="Update"
                              >
                                <i class="bi bi-pencil fab"></i>
                            </a>

                            <button
                              type="button"
                              class="btn btn-sm btn-circle btn-outline-danger"
                              data-bs-toggle="modal"
                              data-bs-target="#deleteModal${user.userId}"
                              title="Delete"
                              >
                                <i class="bi bi-trash fab"></i>
                            </button>

                            <t:alert id="deleteModal${user.userId}">
                                <jsp:attribute name="title"> Confirm Delete </jsp:attribute>
                                <jsp:attribute name="desciption">
                                    Are you sure you want to delete user
                                    <strong>${user.username}</strong>? This
                                    will mark the user as deleted.
                                </jsp:attribute>
                                <jsp:attribute name="action">
                                    <button
                                      type="button"
                                      class="btn btn-danger"
                                      hx-delete="${pageContext.request.contextPath}/admin/user?id=${user.userId}"
                                      hx-target="#wrapper"
                                      hx-select="#wrapper"
                                      hx-swap="outerHTML"
                                      data-bs-dismiss="modal"
                                      >
                                        Delete
                                    </button>
                                </jsp:attribute>
                            </t:alert>
                        </td>
                    </tr>
                </c:forEach>
            </jsp:body>
        </t:table>
    </jsp:body>
</t:layout>
