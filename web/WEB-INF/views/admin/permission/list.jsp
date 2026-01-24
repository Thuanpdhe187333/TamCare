<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@taglib prefix="c"
                                                                 uri="http://java.sun.com/jsp/jstl/core"%> <%@taglib prefix="fmt"
                                                                 uri="http://java.sun.com/jsp/jstl/fmt"%> <%@taglib tagdir="/WEB-INF/tags/"
                                                                 prefix="t" %>

<t:layout title="Permission">
    <jsp:attribute name="actions">
        <t:link
          url="${pageContext.request.contextPath}/admin/permission/create"
          color="primary"
          variant="split"
          icon="plus-lg"
          >
            Create
        </t:link>
    </jsp:attribute>

    <jsp:body>
        <c:set var="columns" value='${["Index", "Code", "Name", "Action"]}' />
        <t:table columns="${columns}">
            <jsp:attribute name="head">
                <form
                  hx-get="${pageContext.request.contextPath}/admin/permission"
                  hx-target="#wrapper"
                  hx-select="#wrapper"
                  hx-swap="outerHTML"
                  hx-push-url="true"
                  class="input-group m-0"
                  >
                    <input
                      name="search"
                      class="form-control"
                      placeholder="Search"
                      value="${search}"
                      />
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search"></i>
                    </button>
                </form>
            </jsp:attribute>

            <jsp:attribute name="foot">
                <t:pagination
                  page="${page}"
                  pages="${pages}"
                  size="${size}"
                  total="${total}"
                  url="${pageContext.request.contextPath}/admin/permission"
                  include="[name='search'], [name='sort']"
                  />
            </jsp:attribute>

            <jsp:body>
                <c:forEach var="permission" items="${permissions}" varStatus="status">
                    <tr>
                        <td>${status.index + 1 + (page - 1) * size}</td>
                        <td>${permission.code}</td>
                        <td>${permission.name}</td>
                        <td>
                            <a
                              href="${pageContext.request.contextPath}/admin/permission/update?id=${permission.permissionId}"
                              class="btn btn-sm btn-circle btn-outline-primary me-1"
                              >
                                <i class="bi bi-pencil fab"></i>
                            </a>

                            <button
                              type="button"
                              class="btn btn-sm btn-circle btn-outline-danger"
                              data-bs-toggle="modal"
                              data-bs-target="#deleteModal${permission.permissionId}"
                              >
                                <i class="bi bi-trash fab"></i>
                            </button>

                            <t:alert id="deleteModal${permission.permissionId}">
                                <jsp:attribute name="title"> Confirm Delete </jsp:attribute>
                                <jsp:attribute name="desciption">
                                    Are you sure you want to delete permission
                                    <strong>${permission.name}</strong> (${permission.code})? This
                                    action cannot be undone.
                                </jsp:attribute>
                                <jsp:attribute name="action">
                                    <button
                                      type="button"
                                      class="btn btn-danger"
                                      hx-delete="${pageContext.request.contextPath}/admin/permission?id=${permission.permissionId}"
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
