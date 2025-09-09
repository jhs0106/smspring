<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- register Page --%>
<div class="col-sm-9">
    <h2>Register Page</h2>
    <form action="/registerimpl" method="post">
        <div class="form-group">
            <label for="id">Id:</label>
            <input type="text" class="form-control" placeholder="Enter id" id="id" name="custId">
        </div>
        <div class="form-group">
            <label for="pwd">Password:</label>
            <input type="password" class="form-control" placeholder="Enter password" id="pwd" name="custPwd">
        </div>
        <div class="form-group">
            <label for="name">Name:</label>
            <input type="text" class="form-control" placeholder="Enter name" id="name" name="custName">
        </div>
        <div class="form-group">
            <label for="addr">Address:</label>
            <input type="text" name="custAddr"  class="form-control" placeholder="Enter name" id="addr">
        </div>
        <button type="submit" class="btn btn-primary">Register</button>
    </form>
</div>

<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>

<%--&lt;%&ndash; Left Page &ndash;%&gt;--%>
<%--<div class="col-sm-9">--%>
<%--    <h2>Register Page</h2>--%>
<%--    <h5>Input Id, Password, Name, E-mail</h5>--%>
<%--    <div class="row">--%>
<%--        <div class="col-sm-7">--%>
<%--            <form action="/registermpl" method="post">--%>
<%--                <div class="form-group">--%>
<%--                    <label for="id">Id:</label>--%>
<%--                    <input type="text" class="form-control" placeholder="Enter id" id="id" name="id">--%>
<%--                </div>--%>
<%--                <div class="form-group">--%>
<%--                    <label for="pwd">Password:</label>--%>
<%--                    <input type="password" class="form-control" placeholder="Enter password" id="pwd" name="pwd">--%>
<%--                </div>--%>
<%--                <div class="form-group">--%>
<%--                    <label for="name">Name:</label>--%>
<%--                    <input type="text" class="form-control" placeholder="Enter name" id="name" name="name">--%>
<%--                </div>--%>
<%--                <div class="form-group">--%>
<%--                    <label for="email">E-mail:</label>--%>
<%--                    <input type="text" class="form-control" placeholder="Enter the E-mail" id="email" name="email">--%>
<%--                </div>--%>


<%--                <button type="submit" class="btn btn-primary">register</button>--%>
<%--            </form>--%>
<%--        </div>--%>
<%--        <div class="col-sm-5">--%>
<%--            <h3>회원가입을 진행하세요</h3>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--</div>--%>