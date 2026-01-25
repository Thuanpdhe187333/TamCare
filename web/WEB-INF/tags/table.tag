<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@attribute name="columns" type="java.util.List<String>"%>
<%@attribute name="head" fragment="true" required="false" %>
<%@attribute name="foot" fragment="true" required="false" %>

<div class="card shadow mb-4">
    <c:if test="${not empty head}">
        <div class="card-header py-3">
            <jsp:invoke fragment="head" />
        </div>
    </c:if>

    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered table-hover mb-0" id="dataTable" width="100%" cellspacing="0">
                <thead class="bg-dark text-light">
                    <tr>
                        <c:forEach var="th" items="${columns}">
                            <th>${th}</th>
                            </c:forEach>
                    </tr>
                </thead>
                <tbody>
                    <jsp:doBody/>
                </tbody>
            </table>
        </div>
    </div>

    <c:if test="${not empty foot}">
        <div class="card-footer py-3">
            <jsp:invoke fragment="foot" />
        </div>
    </c:if>
</div>