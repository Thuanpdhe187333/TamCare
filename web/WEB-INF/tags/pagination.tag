<%@tag description="Pagination component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@attribute name="page" required="true" type="java.lang.Long"%>
<%@attribute name="pages" required="true" type="java.lang.Long"%>
<%@attribute name="size" required="true" type="java.lang.Long"%>
<%@attribute name="total" required="true" type="java.lang.Long"%>
<%@attribute name="url" required="true" type="java.lang.String"%>
<%@attribute name="include" type="java.lang.String" %>

<c:set var="htmxBase" value='hx-get="${url}" hx-target="#wrapper" hx-select="#wrapper" hx-swap="outerHTML" hx-push-url="true"' />
<c:set var="includes" value="${not empty include ? ', '.concat(include) : ''}" />

<div class="d-flex align-items-center justify-content-between w-100">
    <div class="w-100 d-flex gap-2 align-items-center justify-content-start">
        <div class="text-black bg-white px-2 py-1 bg-light rounded-sm border small">
            <strong>${total}</strong> Items
        </div>
        <div class="text-black bg-white px-2 py-1 bg-light rounded-sm border small">
            Page <strong>${page}</strong> / <strong>${pages}</strong>
        </div>
    </div>

    <div class="w-100 d-flex justify-content-center">
        <nav aria-label="Page navigation">
            <ul class="pagination mb-0">
                <li class="page-item ${page le 1 ? 'disabled' : ''}">
                    <button class="page-link h-100 d-flex align-items-center" ${htmxBase} hx-vals='{"page": "1"}' hx-include="[name='size']${includes}">
                        <i class="bi bi-chevron-double-left"></i>
                    </button>
                </li>

                <li class="page-item ${page le 1 ? 'disabled' : ''}">
                    <button class="page-link h-100 d-flex align-items-center" ${htmxBase} hx-vals='{"page": "${page - 1}"}' hx-include="[name='size']${includes}">
                        <i class="bi bi-chevron-left"></i>
                    </button>
                </li>

                <li class="page-item">
                    <select name="page" class="form-select border-left-0 border-right-0 shadow-none rounded-0"
                            style="width: auto;"
                            ${htmxBase}
                            hx-include="[name='size']${includes}">
                        <c:forEach var="i" begin="1" end="${pages}">
                            <option value="${i}" ${i eq page ? 'selected' : ''}>Page ${i}</option>
                        </c:forEach>
                    </select>
                </li>

                <li class="page-item ${page ge pages ? 'disabled' : ''}">
                    <button class="page-link h-100 d-flex align-items-center" ${htmxBase} hx-vals='{"page": "${page + 1}"}' hx-include="[name='size']${includes}">
                        <i class="bi bi-chevron-right"></i>
                    </button>
                </li>

                <li class="page-item ${page ge pages ? 'disabled' : ''}">
                    <button class="page-link h-100 d-flex align-items-center" ${htmxBase} hx-vals='{"page": "${pages}"}' hx-include="[name='size']${includes}">
                        <i class="bi bi-chevron-double-right"></i>
                    </button>
                </li>
            </ul>
        </nav>
    </div>

    <div class="w-100 d-flex justify-content-end align-items-center gap-2">
        <select name="size" class="form-select shadow-none w-auto"
                ${htmxBase}
                hx-vals='{"page": "1"}'
                hx-include="${not empty include ? include : ''}">
            <c:forEach var="s" items="5,10,20,50">
                <option value="${s}" ${s eq size ? 'selected' : ''}>${s} Items / Page</option>
            </c:forEach>
        </select>
    </div>
</div>