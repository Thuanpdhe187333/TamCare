<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>

<html lang="vi">
  <head>
    <%@include file="/WEB-INF/admin/layout/head.jspf" %>
    <title>WMS | Dashboard</title>
  </head>

  <body id="page-top">
    <div id="wrapper">
      <%@include file="/WEB-INF/admin/layout/sidebar.jspf" %>

      <div id="content-wrapper" class="d-flex flex-column">
        <div id="content">
          <%@include file="/WEB-INF/admin/layout/header.jspf" %>

          <div class="container-fluid">
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
              <h1 class="h3 mb-0 text-gray-800">Permission</h1>
              <a href="#" class="d-none d-sm-inline-block btn btn-primary shadow-sm">
                <i class="fas fa-plus fa-sm text-white-50"></i>
                Create
              </a>
            </div>

            <div class="card shadow mb-4">
              <div class="card-header py-3">
                <div class="input-group">
                  <input type="text" class="form-control bg- border-1 small" placeholder="Search" />
                  <div class="input-group-append">
                    <button class="btn btn-primary" type="button">
                      <i class="fas fa-search fa-sm"></i>
                    </button>
                  </div>
                </div>
              </div>

              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                      <tr>
                        <th>Name</th>
                        <th>Position</th>
                        <th>Office</th>
                        <th>Age</th>
                        <th>Start date</th>
                        <th>Salary</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>Tiger Nixon</td>
                        <td>System Architect</td>
                        <td>Edinburgh</td>
                        <td>61</td>
                        <td>2011/04/25</td>
                        <td>$320,800</td>
                      </tr>
                    </tbody>
                    <tfoot>
                      <tr>
                        <th>Name</th>
                        <th>Position</th>
                        <th>Office</th>
                        <th>Age</th>
                        <th>Start date</th>
                        <th>Salary</th>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>

              <div class="card-footer py-3">

              </div>
            </div>
          </div>
        </div>

        <%@include file="/WEB-INF/admin/layout/footer.jspf" %>
      </div>
    </div>

    <%@include file="/WEB-INF/admin/layout/others.jspf" %>
    <%@include file="/WEB-INF/admin/layout/script.jspf" %>
  </body>
</html>
