<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
  let productDetail2 = {

  }
</script>

<div class="col-sm-10">
  <h2>Product Detail2 Page(연습용)</h2>
  <form id="product_update_form">
    <img src="<c:url value ="/imgs/${product.productImg}"/>">
    <div class="form-group">
      <label for="id">Id:</label>
      <p id="id">${product.productId}</p>
      <input type="hidden" name="productId" value="${product.productId}">
    </div>
    <div class="form-group">
      <label for="name">Name:</label>
      <input type="text" value="${product.productName}" class="form-control" placeholder="Enter the name" id="name" name="productName">
    </div>
    <div class="form-group">
      <label for="price">Price:</label>
      <input type="text" value="${product.productPrice}" class="form-control" placeholder="Enter the price" id="price" name="price">
    </div>
    <div class="form-group">
      <label for="rate">DiscountRate:</label>
      <input type="text" value="${product.discountRate}" class="form-control" placeholder="Enter the discount" id="rate" name="discountRate">
    </div>
  </form>
</div>