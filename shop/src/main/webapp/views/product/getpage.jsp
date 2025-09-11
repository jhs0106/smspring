<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
  #product_table > tbody > tr > td > img{
    width: 50px;
  }
</style>
<div class="col-sm-10">
  <h2>Product GetPage Page</h2>
  <table id="product_table" class="table table-bordered">
    <thead>
    <tr>
      <th>Img</th>
      <th>Id</th>
      <th>Name</th>
      <th>Price</th>
      <th>Rate</th>
      <th>Regdate</th>
      <th>Category</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="p" items="${plist.getList()}">
      <tr>
        <td><img src="/imgs/${p.productImg}"></td>
        <td><a href="/product/detail?id=${p.productId}">${p.productId}</a></td>
        <td>${p.productName}</td>
        <td><fmt:formatNumber type="number" pattern="###,###원" value="${p.productPrice}" /></td>
        <td>${p.discountRate}</td>
        <td>
          <fmt:parseDate value="${ p.productRegdate }"
                         pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
          <fmt:formatDate pattern="yyyy년MM월dd일 HH:mm" value="${ parsedDateTime }" />
        </td>
        <td>${p.cateName}</td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
  <jsp:include page="../page.jsp"/>
</div>