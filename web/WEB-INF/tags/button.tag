<%@tag description="button" pageEncoding="UTF-8"%> <%@taglib prefix="c"
                                                             uri="http://java.sun.com/jsp/jstl/core" %> <%@attribute name="type"%>
<!-- button | submit -->
<%@attribute name="name"%> <%@attribute name="value"%> <%@attribute name="color"
                                                                    %>
<!--primary | success | info | warning | danger | secondary | light | dark-->
<%@attribute name="variant" %>
<!-- outline | split -->
<%@attribute name="size" %>
<!-- sm | lg -->
<%@attribute name="shape" %>
<!-- circle -->
<%@attribute name="icon" %>
<!--bootstrap icon-->
<%@attribute name="cssClass" %>
<!--others class-->

<c:set var="finalType" value="${empty type ? 'button' : type}" />
<c:set var="finalColor" value="${empty color ? 'primary' : color}" />
<c:set var="finalClass" value="${empty cssClass ? '' : cssClass}" />
<c:set var="sizeClass" value="${empty size ? '' : 'btn-'.concat(size)}" />
<c:set var="shapeClass" value="${empty shape ? '' : 'btn-'.concat(shape)}" />
<c:set
  var="colorClass"
  value="${variant == 'outline' ? 'btn-'.concat(variant).concat('-').concat(finalColor) : 'btn-'.concat(finalColor)}"
  />
<c:set var="splitClass" value="${variant == 'split' ? 'btn-icon-split' : ''}" />
<c:set
  var="splitIconClass"
  value="${variant == 'split' ? 'btn-icon-split' : ''}"
  />

<button
  type="${finalType}"
  name="${name}"
  value="${value}"
  class="btn ${colorClass} ${sizeClass} ${shapeClass} ${splitClass} shadow-sm ${finalClass}"
  >
    <c:if test="${not empty icon}">
        <span class="icon d-flex align-items-center">
            <i class="bi bi-${icon}"></i>
        </span>
    </c:if>

    <span class="text">
        <jsp:doBody />
    </span>
</button>
