<%@tag description="alert dialog" pageEncoding="UTF-8"%> <%@attribute name="id"
required="true"%> <%@attribute name="title" required="true" fragment="true"%>
<%@attribute name="desciption" required="true" fragment="true"%> <%@attribute
name="action" required="true" fragment="true"%>

<div
  class="modal fade"
  id="${id}"
  tabindex="-1"
  aria-labelledby="${id}Label"
  aria-hidden="true"
>
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content shadow">
      <div class="modal-header">
        <h5 class="modal-title" id="${id}Label">
          <jsp:invoke fragment="title" />
        </h5>
        <button
          type="button"
          class="btn-close"
          data-bs-dismiss="modal"
          aria-label="Close"
        ></button>
      </div>
      <div class="modal-body">
        <jsp:invoke fragment="desciption" />
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">
          Cancel
        </button>

        <jsp:invoke fragment="action" />
      </div>
    </div>
  </div>
</div>
