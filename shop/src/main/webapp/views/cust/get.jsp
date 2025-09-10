<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
  #search_form{
    margin-bottom: 30px;
  }

</style>

<div class="col-sm-10">
  <h2>Cust Get Page</h2>
  <form action="/cust/search" method="get"  id="search_form" class="form-inline well" >
    <div class="form-group">
      <label for="id">Name:</label>
      <input type="text" name="custName" class="form-control" id="id">
    </div>
    <div class="form-group">
      <label for="sdate">Star:</label>
      <input type="date" name="startDate" class="form-control" id="sdate">
    </div>
    <div class="form-group">
      <label for="edate">End:</label>
      <input type="date" name="endDate" class="form-control" id="edate">
    </div>
    <div class="form-group">
      <button type="submit" class="btn btn-info">Search</button>
    </div>
  </form>


  <table class="table table-bordered">
    <thead>
    <tr>
      <th>Id</th>
      <th>Name</th>
      <th>Regdate</th>
      <th>Update</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="c" items="${clist}">
      <tr>
        <td><a href="<c:url value="/cust/detail?id=${c.custId}"/>">${c.custId}</a></td>
        <td>${c.custName}</td>
        <td><fmt:parseDate value="${ c.custRegdate }"
                           pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
          <fmt:formatDate pattern="yyyy년MM월dd일HH:MM" value="${ parsedDateTime }" /></td>
        <td><fmt:parseDate value="${ c.custUpdate }"
                           pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
          <fmt:formatDate pattern="yyyy년MM월dd일HH:MM" value="${ parsedDateTime }" /></td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>