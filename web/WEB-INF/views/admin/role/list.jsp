<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%> <%@taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt"%> <%@taglib tagdir="/WEB-INF/tags/"
prefix="t" %>

<t:layout title="Role">
  <jsp:attribute name="actions">
    <t:link
      url="${pageContext.request.contextPath}/admin/role/create"
      color="primary"
      variant="split"
      icon="plus-lg"
    >
      Create
    </t:link>
  </jsp:attribute>

  <jsp:body>
    <c:set
      var="columns"
      value='${["Index", "Name", "Description", "Action"]}'
    />
    <t:table columns="${columns}">
      <jsp:attribute name="head">
        <form
          hx-get="${pageContext.request.contextPath}/admin/role"
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
          url="${pageContext.request.contextPath}/admin/role"
          include="[name='search'], [name='sort']"
        />
      </jsp:attribute>

      <jsp:body>
        <c:forEach var="role" items="${roles}" varStatus="status">
          <tr>
            <td>${status.index + 1 + (page - 1) * size}</td>
            <td><strong>${role.name}</strong></td>
            <td>${role.description}</td>
            <td>
              <a
                href="${pageContext.request.contextPath}/admin/role/update?id=${role.roleId}"
                class="btn btn-sm btn-circle btn-outline-primary me-1"
              >
                <i class="bi bi-pencil fab"></i>
              </a>

              <button
                type="button"
                class="btn btn-sm btn-circle btn-outline-danger"
                data-bs-toggle="modal"
                data-bs-target="#deleteModal${role.roleId}"
              >
                <i class="bi bi-trash fab"></i>
              </button>

              <t:alert id="deleteModal${role.roleId}">
                <jsp:attribute name="title"> Confirm Delete </jsp:attribute>
                <jsp:attribute name="desciption">
                  Are you sure you want to delete role
                  <strong>${role.name}</strong>? This action cannot be undone.
                </jsp:attribute>
                <jsp:attribute name="action">
                  <button
                    type="button"
                    class="btn btn-danger"
                    hx-delete="${pageContext.request.contextPath}/admin/role?id=${role.roleId}"
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
