<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html lang="en">

<head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>Django Admin</title>
<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Nanum+Gothic&display=swap" rel="stylesheet">
<style>

		h1{
			font-family: 'Do Hyeon', sans-serif;
		}
		* {
		font-family: 'Do Hyeon', sans-serif;
		font-family: 'Nanum Gothic', sans-serif;
		}

		.uploadResult{
			width: 100%;
			background-color: #f8f9fc;
		}

		.uploadResult ul{
			display: flex;
			flex-flow: row;
			justify-content: center;
			align-items: center;
		}

		.uploadResult ul li {
			list-style: none;
			padding: 10px;
		}

		.uploadResult ul li img{
			width: 200px;
		}
		
		.bigPictureWrapper {
			position: absolute;
			display: none;
			justify-content: center;
			align-items: center;
			top: 0%;
			width: 100%;
			height: 100%;
			background-color: gray;
			z-index: 100;
			background: rgba(255, 255,255, 0.5);
		}

		.bigPicture {
			position: relative;
			display: flex;
			justify-content: center;
			align-items: center;
		}

		.bigPicture img {
			width: 600px;
		}

</style>

<!-- Custom fonts for this template -->
  <link href="/resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="/resources/css/sb-admin-2.min.css" rel="stylesheet">

  <!-- Custom styles for this pages -->
  <link href="/resources/vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">

</head>

<body id="page-top">

<!-- SET Security -->
<sec:authentication property="principal" var="pinfo"/>


  <!-- Page Wrapper -->
  <div id="wrapper">

    <!-- Sidebar -->
    <ul class="navbar-nav bg-primary sidebar sidebar-dark accordion" id="accordionSidebar">

      <!-- Sidebar - Brand -->
      <a class="sidebar-brand d-flex align-items-center justify-content-center" href="/board/list">
        <div class="sidebar-brand-icon rotate">
          <!-- <i class="fas fa-laugh-wink"></i> -->
          
        </div>
        <div class="sidebar-brand-text mx-3">Django</div>
      </a>

      <!-- Heading -->
      <div class="sidebar-heading">
        	관리
      </div>

     <!-- Nav Item - Tables -->
      <li class="nav-item active">
        <a class="nav-link" href="#">
          <i class="fas fa-fw fa-table"></i>
          <span>사용자 통계</span></a>
      </li>
      
      <!-- Nav Item - Tables -->
      <li class="nav-item active">
        <a class="nav-link" href="/notice/list">
          <i class="fas fa-fw fa-table"></i>
          <span>공지사항</span></a>
      </li>
      
      <!-- Nav Item - Charts -->
      <li class="nav-item">
        <a class="nav-link" href="/board/list">
          <i class="fas fa-fw fa-chart-area"></i>
          <span>자유 게시판</span></a>
      </li>

      <!-- Nav Item - Charts -->
      <li class="nav-item">
        <a class="nav-link" href="/admin/userinfo">
          <i class="fas fa-fw fa-chart-area"></i>
          <span>사용자 관리</span></a>
      </li>

      <!-- Nav Item - Tables -->
      <li class="nav-item active">
        <a class="nav-link" href="/admin/categoryList">
          <i class="fas fa-fw fa-table"></i>
          <span>식재료 관리</span></a>
      </li>
     <!-- Nav Item - Tables -->
      <li class="nav-item active">
        <a class="nav-link" href="/recipe/recipeList">
          <i class="fas fa-fw fa-table"></i>
          <span>레시피 관리</span></a>
      </li>

      <!-- Divider -->
      <hr class="sidebar-divider d-none d-md-block">

      <!-- Sidebar Toggler (Sidebar) -->
      <div class="text-center d-none d-md-inline">
        <button class="rounded-circle border-0" id="sidebarToggle"></button>
      </div>

    </ul>
    <!-- End of Sidebar -->

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

      <!-- Main Content -->
      <div id="content">

        <!-- Topbar -->
        <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

          <!-- Sidebar Toggle (Topbar) -->
         <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
            <i class="fa fa-bars"></i>
          </button>
          <!-- Topbar Navbar -->
          <ul class="navbar-nav ml-auto">

            <!-- Nav Item - Search Dropdown (Visible Only XS) -->
            <div class="topbar-divider d-none d-sm-block"></div>

            <!-- Nav Item - User Information -->
            <li class="nav-item dropdown no-arrow">
               <sec:authorize access="isAuthenticated()">
              <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                	<span class="mr-2 d-none d-lg-inline text-gray-600 small">관리자</span>
              </a>
                </sec:authorize>
            <sec:authorize access="isAnonymous()">
            	<a href="/customLogin" id="userDropdown" role="button" aria-haspopup="true" aria-expanded="false">
                	<span class="mr-2 d-none d-lg-inline text-gray-600 small">로그인</span>
            	</a>
			</sec:authorize>    
            
              <!-- Dropdown - User Information -->
              <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
                <a class="dropdown-item" href="#">
                  <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                  Profile
                </a>
                <a class="dropdown-item" href="#">
                  <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400"></i>
                  Settings
                </a>
                <a class="dropdown-item" href="#">
                  <i class="fas fa-list fa-sm fa-fw mr-2 text-gray-400"></i>
                  Activity Log
                </a>
                <div class="dropdown-divider"></div>
                <sec:authorize access="isAuthenticated()">
				<a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">	
				<i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                  Logout
                </a>
                </sec:authorize>
              </div>
            </li>

          </ul>

        </nav>
        <!-- End of Topbar -->
        
        <!-- Logout Modal -->
  <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">로그아웃</h5>
          <button class="close" type="button" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button> 	
        </div>
        <div class="modal-body">로그아웃 하겠습니까?</div>
        <div class="modal-footer">
			<form action="/customLogout" method="post">
				<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
				<button class="btn btn-secondary">로그아웃</button>
			</form>
          <button class="btn btn-secondary" type="button" data-dismiss="modal">취소</button>
        </div>
      </div>
    </div>
  </div>
        <!-- End Logout -->

        <!-- Begin Page Content -->
        <div class="container-fluid">

<!-- jQuery CDN -->
<script
  src="https://code.jquery.com/jquery-3.5.1.min.js"
  integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
  crossorigin="anonymous"></script>
        
        