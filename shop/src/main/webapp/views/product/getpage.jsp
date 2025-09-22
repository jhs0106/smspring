<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
  #product_table > tbody > tr > td > img{
    width: 50px;
  }
</style>
<div class="col-sm-9">
  <h2>Product GetPage Page</h2>

  <form action="<c:url value="/product/searchpage"/>" method="get"  id="search_form" class="form-inline well" >
    <div class="form-group">
      <label for="id">Name:</label>
      <input type="text" name="productName" class="form-control" id="id"
      <c:if test="${productName != null}">
             value="${productName}"
      </c:if>
      >
    </div>
    <div class="form-group">
      <label for="mnprice">Min:</label>
      <input type="number" name="minPrice" class="form-control" placeholder="최소 가격" step="1000" id="mnprice"
      <c:if test="${minPrice != null}">
             value="${minPrice}"
      </c:if>
      >
    </div>
    <div class="form-group">
      <label for="mxprice">Max:</label>
      <input type="number" name="maxPrice" class="form-control" placeholder="최대 가격" step="1000" id="mxprice"
      <c:if test="${maxPrice != null}">
             value="${maxPrice}"
      </c:if>
      >
    </div>
    <div class="form-group">
      <label for="cate">Category:</label>
      <select class="form-control" name="cateId" id="cate">
        <option value="0" ${productSearch.cateId == 0 ? 'selected' : ''}>전체</option>
        <option value="10" ${productSearch.cateId == 10 ? 'selected' : ''}>하의</option>
        <option value="20" ${productSearch.cateId == 20 ? 'selected' : ''}>상의</option>
        <option value="30" ${productSearch.cateId == 30 ? 'selected' : ''}>신발</option>
      </select>
    </div>
    <div class="form-group">
      <button type="submit" class="btn btn-info">Search</button>
    </div>
  </form>

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
    <c:forEach var="p" items="${ppage.getList()}">
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
  <jsp:include page="pagination.jsp"/>
</div>