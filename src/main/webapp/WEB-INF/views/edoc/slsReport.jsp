<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.empVO" var="empVO" />
	
	
<script src="/resources/ckeditor/ckeditor.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
						$("#browser").treeview(
								{
									toggle : function() {
										console.log("%s was toggled.", $(this)
												.find(">span").text());
									}
								});

						$("#add").click(function() {
							var branches = $(
									"<li><span class='folder'>New Sublist</span><ul>"
											+ "<li><span class='file'>Item1</span></li>"
											+ "<li><span class='file'>Item2</span></li></ul></li>")
									.appendTo("#browser");
							$("#browser").treeview({
								add : branches
							});
						});
					});
</script>
<!-- 조직도 스크립트 끝-->

<script type="text/javascript">
	$(function() {
		//잔여연차 자동으로 불러오기
		
		$('#cancel').on('click', function() {
			let result = confirm("취소하시겠습니까?");
			if (result > 0) {
				window.close();
			}
		});

		$("#approveLine").on("click", function(index, obj) {
			$("#atrzz").show();
			$("#atrzz22").hide();
		});

		$("#referenceLine").on("click", function(index, obj) {
			$("#atrzz").hide();
			let referLength =  $('#referenceEmp').find('tr').length;
			console.log("referenceEmp",referLength);
			
			if(referLength==0){
				$('#referenceEmp').html("<tr class='delete2'><td colspan='5'>참조자를 선택해주세요</td></tr>");
			}
			$("#atrzz22").show();
			
		});

		$("#btnApproveLine").on("click", function() {
			$(".moving-tab").css("width", "375px");
			
			let me = "${empVO.empNo}";
			console.log(me);
			let data = {"empNo" : me};
			
			
			//결재선 추가[나]
			$.ajax({
				url:"/org/empModal",
				type:"post",
				data: JSON.stringify(data),
				contentType:"application/json;charset=utf-8",
				beforeSend : function(xhr) {   // 데이터 전송 전  헤더에 csrf값 설정
	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
				},
				success:function(result){
				 	$('#approveEmp').empty();
					var trIndex = $("#approveEmp tr").length+1;
					console.log("나의 index",trIndex);
					
					code="";
				 	code += "<tr class='approveTr'><td>"+trIndex+"<input type='hidden' name='atrzVOList[0].empNo' value="+result.empNo+" /></td>"+"<td>"+result.empNm+"</td><td>"+result.deptNm+"</td><td>"+result.jbpsNm+
				 	"</td><td></td></tr>";
				 	
					$("#approveEmp").html(code);
			}
			
		});
			
			//결재선에서 결재자 삭제시
			$(document).on('click', '.deleteApprove', function() {
			    $(this).closest('tr').remove();
			});
			
			//참조자에서 참조자 삭제시
			$(document).on('click', '.deleteReference', function() {
			    $(this).closest('tr').remove();
			});
			
		});
		
		
		$('#modalHide').on('click',function(){
			$('#modal-default').modal('hide');
		});
		
		
		$('#check').on('click',function(){
			
			let check = confirm("결재 요청 하시겠습니까?")
			if(check>0){
				$('#frm').submit();
			}
			
		});
		
		
		//추가버튼을 누르면..
		$('#plusSls').on('click',function(){
			let rowIndex = $('.plusRow').length;
			console.log('rowIndex는?',rowIndex);
			
			code="";
			code +="<tr class='plusRow'>";
			code += "<td style='background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;''>";
			code += "<input type='text' size='50' name='edocVO.slsReportVO.slsInfoVOList["+rowIndex+"].slsGds'><br></td>";
			code += "<td style='background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;'>";
			code += "<input type='text' size='30' name='edocVO.slsReportVO.slsInfoVOList["+rowIndex+"].slsQuantity'><br></td>";
			code += "<td style='text-align: left; padding: 5px; border:1px solid black; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle; background: rgb(255, 255, 255);'>";
			code += "<input type='text' size='30'  name='edocVO.slsReportVO.slsInfoVOList["+rowIndex+"].slsAmt'><br></td>";
			code += "</tr>";
				
			
			$('.plusRow').filter(":last").after(code);
			
			let rowIndex2 = $('.plusRow').length;
			console.log('rowIndex는(추가후)?',rowIndex2);
			
		});
		
		
		$('#deleteSls').on('click',function(){
			
			let rowIndex = $('.plusRow').length;
			if(!(rowIndex==1)){
				$('.plusRow').filter(":last").remove();
			}
		});
	});
</script>
<style>
ul {
	list-style: none;
}
</style>


	<form:form modelAttribute="AtrzLineInfoVO" id="frm"
	action="/edoc/edocPost?${_csrf.parameterName}=${_csrf.token}"
	enctype="multipart/form-data" method="post">
					
					
	<table class="m-2"
		style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 100px; font-family: malgun gothic, dotum, arial, tahoma; margin-top: 1px; border-collapse: collapse;">
		<tr>
			<td><button type="button" class="btn btn-outline-dark"
					id="btnApproveLine" style="width: 100px;" data-bs-toggle="modal"
					data-bs-target="#modal-default">결재정보</button></td>
			<td><button type="button" class="btn btn-outline-dark" id="check"
					style="width: 100px;">결재올림</button></td>
			<td><button type="button" class="btn btn-outline-dark"
					style="width: 100px;">미리보기</button></td>
			<td><button type="button" class="btn btn-outline-dark"
					style="width: 100px;">임시저장</button></td>
			<td><button type="button" class="btn btn-outline-dark"
					style="width: 100px;" id="cancel">취소</button></td>
		</tr>
	</table>



	<div class="card m-2 mb-5 pb-7">


				<!-- 문서 내용 표시 테스트 -->
					<table class="px-5 mx-5 mx-auto" style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 800px; 
					font-family: malgun gothic, dotum, arial, tahoma; margin-top: 1px; border-collapse: collapse;">
						<!-- Header -->
						<colgroup>
							<col width="310">
							<col width="490">
						</colgroup>
						<tbody>
							<tr>
								<td
									style="background: white; padding: 0px !important; border: 0px currentColor; height: 180px; text-align: center; color: black; font-size: 36px; font-weight: bold; vertical-align: middle;"
									colspan="2">매출보고서</td>
							</tr>
							<tr>
								<td
									style="background: white; padding: 0px !important; border: currentColor; border-image: none; text-align: left; color: black; font-size: 12px; font-weight: normal; vertical-align: top;">
									<div id="agreementWrap" class="sign_type1 sign_type_new"></div>

									<table
										style="border: 1px solid rgb(0, 0, 0); border-image: none; font-family: malgun gothic, dotum, arial, tahoma; margin-top: 1px; border-collapse: collapse;">
										<!-- User -->
										<colgroup>
											<col width="90">
											<col width="220">
										</colgroup>
										<tbody>
											<tr>
												<td
													style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; border-image: none; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">기안자</td>
												<td
													style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; border-image: none; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;">
													&nbsp${name}
												</td>
											</tr>
											<tr>
												<td
													style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; border-image: none; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
													소속</td>
												<td
													style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; border-image: none; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;">
													&nbsp${dept}
												</td>
											</tr>
											<tr>
												<td
													style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; border-image: none; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
													기안일</td>
												<td
													style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; border-image: none; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;">
													&nbsp${today}
												</td>
											</tr>
											<tr>
												<td
													style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; border-image: none; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
													문서번호</td>
												<td
													style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; border-image: none; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;">
													<input type="text"
													style="vertical-align: middle; width: 100%; border: 0px; box-shadow: inset 0px 0px 0px rgba(150, 150, 150, 0.2)">
												</td>
											</tr>
										</tbody>
									</table>
								</td>
						</tbody>
					</table>


					<table class="px-5 mx-5 mx-auto" style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 800px; 
					font-family: malgun gothic, dotum, arial, tahoma; margin-top: 1px; border-collapse: collapse;">
						<colgroup>
							<col width="140">
							<col width="140">
							<col width="120">
							<col width="140">
							<col width="260">
						</colgroup>
						<tbody>
							<br />
							<tr>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 0px solid black; border-image: none; 
									height: 25px; text-align: left; color: rgb(0, 0, 0); font-size: 15px; font-weight: bold; vertical-align: middle;"
									colspan="4">1.계약사항</td>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 0px solid black; border-image: none; text-align: right; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: bottom;">
								</td>
							</tr>

							<tr>
								<td
									style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; border-image: none; height: 22px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
									계약명</td>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; border-image: none; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;"
									colspan="4"><input type="text" name="edocVO.slsReportVO.slsCtrtNm" size="80"><br></td>
							</tr>
							<tr>
								<td
									style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; border-image: none; height: 22px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
									거래처명</td>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; border-image: none; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;"
									colspan="4"><input type="text" name="edocVO.slsReportVO.slsCnpt" size="80"><br></td>
							</tr>
							<tr>
								<td
									style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; border-image: none; height: 22px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
									거래처 법인번호</td>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; border-image: none; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;"
									colspan="4"><input type="text" name="edocVO.slsReportVO.slsCorpNo" size="80"><br></td>
							</tr>

							<tr>
								<td
									style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; border-image: none; height: 22px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
									계산서 발행일</td>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; border-image: none; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;"
									colspan="4"><input type="date" name="edocVO.slsReportVO.slsYmd"></td>
							</tr>

							<tr>
								<td
									style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; border-image: none; height: 150px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
									비고</td>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; border-image: none; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: top;"
									colspan="4"><textarea name="edocVO.slsReportVO.slsExt"
										style="height: 150px; width: 100%;"></textarea><br></td>
							</tr>
					</table>

					<br />
					<br />
								
					<table class="px-5 mx-5 mx-auto" style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 800px; 
					font-family: malgun gothic, dotum, arial, tahoma; margin-top: 1px; border-collapse: collapse;">
						<colgroup>
							<col width="560">
							<col width="200">
							<col width="200">
						</colgroup>

						<tbody>
						<tr>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 0px solid black; border-image: none; 
									height: 25px; text-align: left; color: rgb(0, 0, 0); font-size: 16px; font-weight: bold; vertical-align: middle;"
									colspan="1">2.매출정보</td>
								<td 
									style="background: rgb(255, 255, 255); padding: 5px; border: 0px solid black; border-image: none;  
  									height: 25px; text-align: right; color: rgb(0, 0, 0); font-size: 14px; font-weight: bold; vertical-align: middle;" >
								</td>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 0px solid black; border-image: none; 
									height: 25px; text-align: right; color: rgb(0, 0, 0); font-size: 14px; font-weight: bold; vertical-align: middle;"
									><input type="button" value="추가" id="plusSls"/>&nbsp<input type="button" value="삭제" id="deleteSls"/></td>
						</tr>
						
							<tr>
								<td
									style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; 
									height: 24px; text-align: center; color: black; font-size: 12px; font-weight: bold; vertical-align: top;"
									class="">품&nbsp;&nbsp;&nbsp;&nbsp;목</td>
								<td
									style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; 
									height: 24px; text-align: center; color: black; font-size: 12px; font-weight: bold; vertical-align: top;"
									class="">수&nbsp;&nbsp;&nbsp;&nbsp;량</td>
								<td
									style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 24px; text-align: center; color: black; font-size: 12px; 
									font-weight: bold; vertical-align: top;"
									class="">매&nbsp;출&nbsp;금&nbsp;액</td>
							</tr>
							
							
							
							
							<tr class="plusRow">
								<td style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;"
									class="">
									<input type="text" size="50" name="edocVO.slsReportVO.slsInfoVOList[0].slsGds"><br>
								</td>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;"
									class="">
									<input type="text" size="30" name="edocVO.slsReportVO.slsInfoVOList[0].slsQuantity"><br></td>
								<td
									style="text-align: left; padding: 5px; border:1px solid black;
									color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle; background: rgb(255, 255, 255);"
									class="">
									<input type="text" size="30"  name="edocVO.slsReportVO.slsInfoVOList[0].slsAmt"><br></td>
							</tr>
							
							<tr>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; 
									text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;"
									colspan="2" class="">총 매출 합계</td>
								<td
									style="text-align: left; padding: 5px; border-bottom-width: 2px; border: 1px solid black;
									color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle; "
									class="">
									<input type="text" size="30" name="edocVO.slsReportVO.totalSlsAmt"><br></td>
							</tr>
						</tbody>
					</table>
					
					
					
					<table class="px-5 mx-5 mx-auto" style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 800px; 
					font-family: malgun gothic, dotum, arial, tahoma; margin-top: 1px; border-collapse: collapse;">
						<colgroup>
							<col width="140">
							<col width="140">
							<col width="120">
							<col width="140">
							<col width="260">
						</colgroup>
						<tbody>
							<br />
							<tr>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 0px solid black; border-image: none; 
									height: 25px; text-align: left; color: rgb(0, 0, 0); font-size: 15px; font-weight: bold; vertical-align: middle;"
									colspan="4">3.관련문서</td>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 0px solid black; border-image: none; text-align: right; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: bottom;">
								</td>
							</tr>

							<tr>
								<td
									style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; border-image: none; height: 22px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
									첨부파일</td>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; border-image: none; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;"
									colspan="4"><input type="file" name="edocVO.uploadFile" /><br></td>
							</tr>
							<tr>
								<td
									style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; border-image: none; height: 22px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
									관련문서</td>
								<td
									style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; border-image: none; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;"
									colspan="4"></td>
							</tr>
					</table>
					</div>
			<input type="hidden" name="edocVO.edocTtl" value="매출보고서" />
			<input type="hidden" name="edocVO.edocFormClsf" value="${param.edoFormClsf}" />
			
			
	<!-- 결재정보 모달창 -->
<div class="row">
	<div class="col-md-2">
		<div class="modal fade" id="modal-default" tabindex="-1" role="dialog"
			aria-labelledby="modal-default" aria-hidden="true">
			<div class="modal-dialog modal- modal-dialog-centered modal-xl"
				role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title" id="modal-title-default">결재정보</h4>
						<button type="button" class="btn-close text-dark"
							data-bs-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">×</span>
						</button>
					</div>
					<div class="modal-body" style="height: 600px;">
						<div class="nav-wrapper position-relative end-0 mb-3">
							<ul class="nav nav-pills nav-fill p-1 mb-3" role="tablist">
								<li class="nav-item"><a
									class="nav-link mb-0 px-0 py-1 active" id="approveLine"
									data-bs-toggle="tab" href="#atrzz" role="tab"
									aria-controls="profile" aria-selected="true"> 결재선추가 </a></li>
								<li class="nav-item"><a class="nav-link mb-0 px-0 py-1"
									id="referenceLine" data-bs-toggle="tab" href="#atrzz22"
									role="tab" aria-controls="dashboard" aria-selected="false">참조자추가
								</a></li>
							</ul>
							<div class="row" id="atrzz">
								<div class="col-lg-4 col-4">
									<div
										class="border-dashed border-1 border-secondary border-radius-md py-3">
										<h5 class="text-dark text-gradient mb-0">조직도</h5>
										<div id="orgList" style="overflow: scroll; height: 500px;">
											<ul id="browser" class="filetree treeview-famfamfam">
												<li class="dropdownLi" style="margin-left: -20px;">
												<i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
													class="folder">그루IT</span>
													<ul id="folder21" class="adminEmp">
													</ul>
													<ul>
														<li class="closed dropdownLi">
														<i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;
														<span class="folder">경영지원본부</span>
															<ul>
																<li class="closed empList dropdownLi">
																<i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT003">재무팀</span>
																	<ul id="folder21">
																	</ul></li>
																<li class="closed empList dropdownLi">
																<i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT004">인사팀</span>
																	<ul id="folder21">
																	</ul></li>
																<li class="closed empList dropdownLi">
																<i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT005">총무팀</span>
																	<ul id="folder21">
																	</ul></li>
															</ul></li>
														<li class="closed dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
															class="folder">영업본부</span>
															<ul>
																<li class="closed empList dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT011">영업팀</span>
																	<ul id="folder21"></ul></li>
																<li class="closed empList dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT012">마케팅팀</span>
																	<ul id="folder21">
																	</ul></li>
																<li class="closed empList dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT013">CS팀</span>
																	<ul id="folder21">
																	</ul></li>
															</ul></li>
														<li class="closed"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
															class="folder">개발본부</span>
															<ul>
																<li class="closed empList"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT007">서비스개발팀</span>
																	<ul id="folder21">
																	</ul></li>
																<li class="closed empList"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT008">플랫폼운영팀</span>
																	<ul id="folder21">
																	</ul></li>
																<li class="closed empList"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT009">디자인팀</span>
																	<ul id="folder21">
																	</ul></li>
															</ul></li>
													</ul></li>
											</ul>
										</div>
									</div>
								</div>
								<div class="col-lg-8 col-8">
									<div class="border-1 border-secondary border-radius-md py-3">
										<div class="card-body">
											<div class="row">
												<div class="col-12">
													<div class="table-responsive">
														<table class="table text-right">
															<thead class="">
																<tr class="text-center">
																	<th style="width:18%;">순번</th>
																	<th style="width:10%;">성명</th>
																	<th style="width:18%;">직위</th>
																	<th style="width:18%;">부서</th>
																	<th style="width:5%;"><img src="/resources/image/trash3.svg"></th>
																</tr>
															</thead>
															<tbody class="text-center" id="approveEmp">
																 <tr>
																	<td colspan="5">결재자를 선택해주세요</td>
																</tr>
															</tbody>
														</table>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>

							<div class="row" id="atrzz22" style="display: none;">
								<div class="col-lg-4 col-4">
									<div
										class="border-dashed border-1 border-secondary border-radius-md py-3">
										<h5 class="text-dark text-gradient mb-0">조직도1111</h5>

										<div id="orgList" style="overflow: scroll; height: 500px;">
											<ul id="browser" class="filetree treeview-famfamfam">
												<li class="dropdownLi" style="margin-left: -20px;"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
													class="folder">그루IT</span>
													<ul id="folder21" class="adminEmp2">
													</ul>
													<ul>
														<li class="closed dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
															class="folder">경영지원본부</span>
															<ul>
																<li class="closed empList2 dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT003">재무팀</span>
																	<ul id="folder21">
																	</ul></li>
																<li class="closed empList2 dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT004">인사팀</span>
																	<ul id="folder21">
																	</ul></li>
																<li class="closed empList2 dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT005">총무팀</span>
																	<ul id="folder21">
																	</ul></li>
															</ul></li>
														<li class="closed dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
															class="folder">영업본부</span>
															<ul>
																<li class="closed empList2 dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT011">영업팀</span>
																	<ul id="folder21"></ul></li>
																<li class="closed empList2 dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT012">마케팅팀</span>
																	<ul id="folder21">
																	</ul></li>
																<li class="closed empList2 dropdownLi"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT013">CS팀</span>
																	<ul id="folder21">
																	</ul></li>
															</ul></li>
														<li class="closed"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
															class="folder">개발본부</span>
															<ul>
																<li class="closed empList2"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT007">서비스개발팀</span>
																	<ul id="folder21">
																	</ul></li>
																<li class="closed empList2"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT008">플랫폼운영팀</span>
																	<ul id="folder21">
																	</ul></li>
																<li class="closed empList2"><i class="ni ni-zoom-split-in" style="color: #088ff7;"></i>&nbsp;<span
																	class="folder" data-deptno="DEPT009">디자인팀</span>
																	<ul id="folder21">
																	</ul></li>
															</ul></li>
													</ul></li>
											</ul>
										</div>
									</div>
								</div>
								<div class="col-lg-8 col-8">
									<div class="border-1 border-secondary border-radius-md py-3">
										<div class="card-body">
											<div class="row">
												<div class="col-12">
													<div class="table-responsive">
														<table class="table text-right">
															<thead class="">
																<tr class="text-center">
																	<th style="width:18%;">순번</th>
																	<th style="width:10%;">성명</th>
																	<th style="width:18%;">직위</th>
																	<th style="width:18%;">부서</th>
																	<th style="width:5%;"><img src="/resources/image/trash3.svg"></th>
																</tr>
															</thead>
															<tbody class="text-center" id="referenceEmp">
															
															</tbody>
														</table>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-outline-dark" id="reset">초기화</button>
						<button type="button" class="btn btn-outline-dark" id="modalHide">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>		
</form:form>

</sec:authorize>


				
			
<script>
	//결재자선택
	$(function() {
		//회사 바로 밑에 대표/이사 사원 출력 
		$.ajax({url : "/org/orgAdminEmp",
					type : "post",
					beforeSend : function(xhr) { // 데이터 전송 전  헤더에 csrf값 설정
						xhr.setRequestHeader("${_csrf.headerName}",
								"${_csrf.token}");
					},
					success : function(result) {
						//result : List<empVO> empVOList
						let str = "";
						console.log(result);

						$.each(result,function(i, v) {
							str += "<li><i class='fas fa-user text-secondary text-sm' data-bs-toggle='tooltip' data-bs-placement='top' aria-hidden='true' aria-label='Edit Profile' data-bs-original-title='Edit Profile'></i>&nbsp;<a class='file file1' data-empno='"+v.empNo+"' >"
									+ v.empNm
									+ " "
									+ v.jbpsNm
									+ "</a></li>"
							});

						$(".adminEmp").append(str);
					}
				});

		//.empList를 선택하면 (this) 아작스 호출해서 해당 태그 자식에 요소 append 
		$('.empList').on('click',function() {
							//부서 번호 변수에 담기 
							let deptNo = $(this).children('span')
									.data('deptno');
							let $_target = $(this);
							let data = {
								"deptNo" : deptNo
							};

							$.ajax({
										url : "/org/orgEmp",
										type : "post",
										data : JSON.stringify(data),
										contentType : "application/json;charset=utf-8",
										beforeSend : function(xhr) { // 데이터 전송 전  헤더에 csrf값 설정
											xhr.setRequestHeader(
													"${_csrf.headerName}",
													"${_csrf.token}");
										},
										success : function(result) {
											//result : List<empVO> empVOList
											let str = "";
											console.log(result);

											$.each(result,function(i, v) {
											str += "<li><i class='fas fa-user text-secondary text-sm' data-bs-toggle='tooltip' data-bs-placement='top' aria-hidden='true' aria-label='Edit Profile' data-bs-original-title='Edit Profile'></i>&nbsp;<a class='file file1' data-empno='"+v.empNo+"' >"
													+ v.empNm
													+ " "
													+ v.jbpsNm
													+ "</a></li>"
															});

											//		 				console.log("str : " + str);
											//.html() : 새로고침 / .append() : 누적

											$($_target).find('ul').html(str);
										}
									});

						});
						
		$(document).on('click', '.file1', function() {
			  //사원 번호 변수에 담기 
			  let empNo = $(this).data('empno');
			  let data = {"empNo": empNo};
			  
			  // 이미 추가된 사원인지 확인
			  if ($("#approveEmp input[value='" + empNo + "']").length > 0) {
			    alert("이미 추가된 사원입니다.");
			    return;
			  }

			  $.ajax({
			    url: "/org/empModal",
			    type: "post",
			    data: JSON.stringify(data),
			    contentType: "application/json;charset=utf-8",
			    beforeSend: function(xhr) { // 데이터 전송 전  헤더에 csrf값 설정
			      xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			    },
			    success: function(result) {
			      var trIndex = $("#approveEmp tr").length;
			      console.log("결재자의index:",trIndex)
			      
			      code = "";
			      code += "<tr class='approveTr'><td>" + (trIndex + 1) + "<input type='hidden' name='atrzVOList[" + trIndex + "].empNo' value=" + result.empNo + " /></td>" + "<td>" + result.empNm + "</td><td>" + result.deptNm + "</td><td>" + result.jbpsNm +
			        "</td><td><img src='/resources/image/trash3.svg' class='deleteApprove'></td></tr>";
			        
			      $("#approveEmp").append(code);

			      $('.deleteApprove').off('click').on('click', function() {
			    	  // Get the current row and index
			    	  var currentRow = $(this).closest('tr');
			    	  var currentIndex = currentRow.index();
			    	  
			    	  //내가누른tr을 업애줌
			    	  currentRow.remove();
			    	  
			    	  //삭제된 row의 input 태그의 name 값 바꾸기
			    	  $('.approveTr').each(function(index) {
			    	    var hiddenInput = $(this).find('input[type="hidden"]');
			    	    if (hiddenInput.attr('name')) {
			    	      var oldIndex = hiddenInput.attr('name').match(/\[(.*?)\]/)[1];
			    	      if (oldIndex > currentIndex) {
			    	        hiddenInput.attr('name', 'atrzVOList[' + (oldIndex - 1) + '].empNo');
			    	      }
			    	    }
			    	    
			    	    
			    	  });
			    	});
			    }
			  });
			});


	})
</script>




<script>

	//참조자 선택
	$(function() {
		//회사 바로 밑에 대표/이사 사원 출력 
		$.ajax({url : "/org/orgAdminEmp",
					type : "post",
					beforeSend : function(xhr) { // 데이터 전송 전  헤더에 csrf값 설정
						xhr.setRequestHeader("${_csrf.headerName}",
								"${_csrf.token}");
					},
					success : function(result) {
						//result : List<empVO> empVOList
						let str = "";
						console.log(result);

						$.each(result,function(i, v) {
							str += "<li><i class='fas fa-user text-secondary text-sm' data-bs-toggle='tooltip' data-bs-placement='top' aria-hidden='true' aria-label='Edit Profile' data-bs-original-title='Edit Profile'></i>&nbsp;<a class='file file2' data-empno='"+v.empNo+"' >"
									+ v.empNm
									+ " "
									+ v.jbpsNm
									+ "</a></li>"
							});

						$(".adminEmp2").append(str);
					}
				});

		//.empList를 선택하면 (this) 아작스 호출해서 해당 태그 자식에 요소 append 
		$('.empList2').on('click',function() {
							//부서 번호 변수에 담기 
							let deptNo = $(this).children('span')
									.data('deptno');
							let $_target = $(this);
							let data = {
								"deptNo" : deptNo
							};

							$.ajax({
										url : "/org/orgEmp",
										type : "post",
										data : JSON.stringify(data),
										contentType : "application/json;charset=utf-8",
										beforeSend : function(xhr) { // 데이터 전송 전  헤더에 csrf값 설정
											xhr.setRequestHeader(
													"${_csrf.headerName}",
													"${_csrf.token}");
										},
										success : function(result) {
											//result : List<empVO> empVOList
											let str = "";
											console.log(result);

											$.each(result,function(i, v) {
											str += "<li><i class='fas fa-user text-secondary text-sm' data-bs-toggle='tooltip' data-bs-placement='top' aria-hidden='true' aria-label='Edit Profile' data-bs-original-title='Edit Profile'></i>&nbsp;<a class='file file2' data-empno='"+v.empNo+"' >"
													+ v.empNm
													+ " "
													+ v.jbpsNm
													+ "</a></li>"
															});

											//		 				console.log("str : " + str);
											//.html() : 새로고침 / .append() : 누적

											$($_target).find('ul').html(str);
										}
									});

						});
						
		$(document).on('click', '.file2', function() {
			  //사원 번호 변수에 담기 
			  let empNo = $(this).data('empno');
			  let data = {"empNo": empNo};
			  
			  
//  			  $('#referenceEmp').empty();
			  
			// 이미 추가된 사원인지 확인
			  if ($("#referenceEmp input[value='" + empNo + "']").length > 0) {
			  alert("이미 추가된 사원입니다.");
			  return;
			  }

			  $.ajax({
			    url: "/org/empModal",
			    type: "post",
			    data: JSON.stringify(data),
			    contentType: "application/json;charset=utf-8",
			    beforeSend: function(xhr) { // 데이터 전송 전  헤더에 csrf값 설정
			      xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			    },
			    success: function(result) {
			      var trIndex = $("#referenceEmp tr").length;
			      console.log('trIndex는머다?',trIndex);
			      var trContent = $($("#referenceEmp tr").get(0)).text().trim();
			      
			      if(trIndex==1 && trContent=="참조자를 선택해주세요"){
			    	  trIndex = 0;
			    	  $("#referenceEmp").empty();
			      }
			      console.log("참조자index",trIndex);

			      code = "";
			      code += "<tr class='referenceEmp'><td>" + (trIndex + 1) + "<input type='hidden' name='atrzRfrncVOList[" + trIndex + "].empNo' value=" + result.empNo + " /></td>" + "<td>" + result.empNm + "</td><td>" + result.deptNm + "</td><td>" + result.jbpsNm +
			        "</td><td><img src='/resources/image/trash3.svg' class='deleteReference'></td></tr>";
					
			        
			      $("#referenceEmp").append(code);

			      
			      
			      $(document).on('click', '.deleteReference', function() {
			    	  // Get the current row and index
			    	  var currentRow = $(this).closest('tr');
			    	  var currentIndex = currentRow.index();
			    	  
			    	  //내가누른tr을 업애줌
			    	  currentRow.remove();

			    	  // 남아있는 참조자가 없을 경우 "참조자를 선택해주세요" 메시지 추가
			    	  if ($('#referenceEmp tr').length === 0) {
			    	    $('#referenceEmp').append('<tr><td colspan="5">참조자를 선택해주세요</td></tr>');
			    	  } else {
			    	    // 남아있는 참조자 인덱스 순서대로 재정렬
			    	    $('#referenceEmp tr').each(function(index) {
			    	    var hiddenInput2 = $(this).find('input[type="hidden"]');
			    	    $(this).find('input[type="hidden"]').attr('name', 'atrzRfrncVO[' + index + '].empNo');
			    	    hiddenInput2.val($(this).find('input[type="hidden"]').val());
			    	    $(this).find('td:first-child').text(index + 1);
			    	    });
			    	  }
			    	});
			    }
			  });
			});
		
		
		//리셋버튼 클릭시
		$('#reset').on('click',function(){
			
			
			
		});


	})
</script>	
				
				
				
