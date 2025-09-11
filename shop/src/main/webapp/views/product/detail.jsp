<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
    #product_img{
        width: 250px;
        height: 250px;
    }

</style>

<script>
    let productDetail = {
        init: function () {
            $('#update_btn').click(()=>{
                let c = confirm('수정 하시겠습니까 ?');
                if(c == true){
                    $('#product_update_form').attr('method', 'post');
                    $('#product_update_form').attr('enctype','multipart/form-data');
                    $('#product_update_form').attr('action','<c:url value="/product/update"/>');
                    $('#product_update_form').submit();
                }
            });
            $('#delete_btn').click(()=>{
                let d = confirm('정말 삭제하시겠습니까?');
                if(d==true){
                    location.href='<c:url value="/product/delete?id=${product.productId}"/>';
                }
            })
        }

    }
    $().ready(()=>{
        productDetail.init();
    })

</script>


<div class="col-sm-9">
    <h2>Product Detail Page</h2>
    <form id="product_update_form">
        <img id="product_img" src="<c:url value ="/imgs/${product.productImg}"/>">
        <div class="form-group">
            <label for="id">Id:</label>
            <p id="id">${product.productId}</p>
            <input type="hidden" name="productId" value="${product.productId}">
        </div>
        <div class="form-group">
            <label for="name">Name:</label>
            <input type="text" value="${product.productName}" class="form-control" placeholder="Enter name" id="name" name="productName">
        </div>
        <div class="form-group">
            <label for="price">Price:</label>
            <input type="text" value="${product.productPrice}" class="form-control" placeholder="Enter price" id="price" name="productPrice">
        </div>
        <div class="form-group">
            <label for="rate">DiscountRate:</label>
            <input type="text" value="${product.discountRate}" class="form-control" placeholder="Enter rate" id="rate" name="discountRate">
        </div>

        <input type="hidden"value="${product.productImg}" name="productImg">
        <div class="form-group">
            <label for="img">Img:</label>
            <input type="file" class="form-control" id="newpimg" name="productImgFile">
        </div>
        <div class="form-group">
            <label for="cateid">CateId:</label>
            <input type="text" value="${product.cateId}" class="form-control" placeholder="Enter cate id" id="cateid" name="cateId">
        </div>
        <label for="regdate">RegDate:</label>
        <p>
            <fmt:parseDate value="${ product.productRegdate }"
                           pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateTime" type="both" />
            <fmt:formatDate pattern="yyyy년MM월dd일" value="${ parsedDateTime }" />
        </p>
        <label for="update">update:</label>
        <p>
            <fmt:parseDate value="${ product.productUpdate }"
                           pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateTime" type="both" />
            <fmt:formatDate pattern="yyyy년MM월dd일" value="${ parsedDateTime }" />
        </p>
        <button type="button" class="btn btn-primary" id="update_btn">Update</button>
        <button type="button" class="btn btn-danger" id="delete_btn">Delete</button>
    </form>
</div>