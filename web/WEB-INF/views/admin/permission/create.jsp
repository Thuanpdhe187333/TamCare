<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags/" %>

<t:layout title="Create Permission">
    <jsp:attribute name="actions">
        <t:link url="${pageContext.request.contextPath}/admin/permission" variant="split" color="dark" icon="chevron-left">
            Go back
        </t:link>
    </jsp:attribute>

    <jsp:body>
        <div class="card shadow-sm">
            <div class="card-body">
                <form method="POST" action="${pageContext.request.contextPath}/admin/permission/create" class="m-0">

                    <div class="mb-3">
                        <label for="code" class="form-label">
                            Code <span class="text-danger">*</span>
                        </label>

                        <input type="text" class="form-control" id="code" name="code" required
                               placeholder="Example: USER_VIEW, PRODUCT_CREATE">
                        <small class="text-muted">Code must be unique, uppercase, and separated by underscores.</small>
                    </div>

                    <div class="mb-3">
                        <label for="name" class="form-label">
                            Permission Name <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control" id="name" name="name" required
                               placeholder="Example: View User, Create Product">
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <t:link url="${pageContext.request.contextPath}/admin/permission"
                                icon="x-circle" color="dark" variant="split">
                            Cancel
                        </t:link>

                        <t:button type="submit" variant="split" icon="check-circle">
                            Save
                        </t:button>
                    </div>
                </form>
            </div>
        </div>
    </jsp:body>
</t:layout>
