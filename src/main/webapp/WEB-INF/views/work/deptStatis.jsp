<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<script type="text/javascript">
$(function(){
	//현재 날짜 기준 달 구하기 
	 todayy = new Date();   

	 year = todayy.getFullYear(); // 년도


	// 달의 마지막 날짜 구하기
	var lastDay = new Date(todayy.getFullYear(), todayy.getMonth() + 1, 0).getDate();
	
	
	month = $('#hiddenMonth').val(); 
	
	
	//처음 페이지 요청 시 오늘 날짜기준의 달을 가져옴
	if(month == ""){
		month = todayy.getMonth() + 1;
	}

	month = parseInt(month); 
	
	if(month<10){
		month = '0'+month;
	}
	
	
	if(month>12){
		month=1;
		year+=1;
	}
	
// 	alert(year+month); 
		
	let datee = year+month;
	
	let data = {"month" : datee}; 
	
	var deptCount; // 전역변수 선언
	
	//해당 부서의 총 인원수 
	$.ajax({
		url:"/work/getDeptPerson",
		type:"post",
		async:false,
		beforeSend : function(xhr) {   // 데이터 전송 전  헤더에 csrf값 설정
               xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		},
		success:function(result){
			console.log("리저트 : " + result.RESULT); 
			
			deptCount = result.RESULT; 
			
			$('#getDeptPerson').text("인원수  | "+result.RESULT); 
			
		}
	});
	
	
	//부서 월별 근태 통계 
	$.ajax({
		url:"/work/TeamMonthCNT",
		type:"post",
		data: JSON.stringify(data),
		dataType: "json",
		contentType:"application/json;charset=utf-8",
		beforeSend : function(xhr) {   // 데이터 전송 전  헤더에 csrf값 설정
               xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		},
		success:function(result){
			
		cnt1 = parseInt(result.NORMAL);
		cnt2 = parseInt(result.LATE);
		cnt3 = parseInt(result.EARLY);
		cnt4 = parseInt(result.EMPTY);
		cnt5 = parseInt(result.HOLI);
		
		// 지각3번(지각수/3으로 나눈 몫을 조퇴에 +1) => 조퇴 +1
		// 조퇴3번(조퇴수/3으로 나눈 몫을 결근에 +1) => 결근 +1
		cnt3 += Math.floor(cnt2 / 3);
		cnt4 += Math.floor(cnt3 / 3);
			
			$('#cnt1').text(cnt1); 
			$('#cnt2').text(cnt2); 
			$('#cnt3').text(cnt3); 
			$('#cnt4').text(cnt4); 
			$('#cnt5').text(cnt5); 
			
			
		//근태 현황 그래프(비율 나타내는거 )
		// 	(100 / 한달의 마지막날 * 지각 등등의 개수) / 부서의 총 인원수  

		//text 
		$('#ct1').text(Math.floor((100/lastDay*cnt1)/deptCount)+"%");   	
		$('#ct2').text(Math.floor((100/lastDay*cnt2)/deptCount)+"%");   	
		$('#ct3').text(Math.floor((100/lastDay*cnt3)/deptCount)+"%");   	
		$('#ct4').text(Math.floor((100/lastDay*cnt4)/deptCount)+"%");   	
		$('#ct5').text(Math.floor((100/lastDay*cnt5)/deptCount)+"%");   	
		
		let rate1 = Math.floor((100/lastDay*cnt1)/deptCount); 
		if (rate1 >= 10) {
		  rate1 = Math.floor(rate1 / 10) * 10;
		} else if (rate1 === 0) {
		  rate1 = "0";
		}
		
		let rate2 = Math.floor((100/lastDay*cnt2)/deptCount);
		if (rate2 >= 10) {
			rate2 = Math.floor(rate2 / 10) * 10;
		} else if (rate2 === 0) {
			rate2 = "0";
		}
		
		let rate3 = Math.floor((100/lastDay*cnt3)/deptCount);
		if (rate3 >= 10) {
		  rate3 = Math.floor(rate3 / 10) * 10;
		} else if (rate3 === 0) {
		  rate3 = "0";
		}
		
		let rate4 = Math.floor((100/lastDay*cnt4)/deptCount);
		if (rate4 >= 10) {
			rate4 = Math.floor(rate4 / 10) * 10;
		} else if (rate4 === 0) {
			rate4 = "0";
		}
		
		let rate5 = Math.floor((100/lastDay*cnt5)/deptCount);
		if (rate5 >= 10) {
			rate5 = Math.floor(rate5 / 10) * 10;
		} else if (rate5 === 0) {
			rate5 = "0";
		}
		
		
		//근무상세 그래프 
		$('#c1').append("<div class='progress-bar bg-gradient-info w-"+rate1+"' role='progressbar' aria-valuenow='60' aria-valuemin='0' aria-valuemax='100'></div>")
		$('#c2').append("<div class='progress-bar bg-gradient-danger w-"+rate2+"' role='progressbar' aria-valuenow='10' aria-valuemin='0' aria-valuemax='100'></div>")
		$('#c3').append("<div class='progress-bar bg-gradient-danger w-"+rate3+"' role='progressbar' aria-valuenow='10' aria-valuemin='0' aria-valuemax='100'></div>")
		$('#c4').append("<div class='progress-bar bg-gradient-dark w-"+rate4+"' role='progressbar' aria-valuenow='10' aria-valuemin='0' aria-valuemax='100'></div>")
		$('#c5').append("<div class='progress-bar bg-gradient-green w-"+rate5+"' role='progressbar' aria-valuenow='10' aria-valuemin='0' aria-valuemax='100'></div>")
			
		}
	});
	

	//달력 다음 버튼 누를경우 다음 달로 
	$('#nextMonth').on('click', function(){
		
		month = $('#hiddenMonth').val(); 
		
		if(month == ""){
			month = todayy.getMonth() + 1;
		}
		
		month = parseInt(month)+1; 
		
		if(month<10){
			month = '0'+month;
		}
		
		if(month>12){
			month=1;
			year+=1;
		}
		
		
		console.log('현재 선택한 달 : '+ month); //month는 문자열 '01'형태 //이걸 ajax로 불러와야하지 않을까
		
		
		console.log('data로 보낼 날짜 : '+ year+month); //month는 문자열 '01'형태 
		
		
		let datee = year+month;

// 		alert(datee); 
		
		location.href = "/work/deptStatis?month="+datee;
	})
	
	//달력 이전 버튼 누를경우 이전 달로 
	$('#lastMonth').on('click', function(){
		
		
		month = $('#hiddenMonth').val();
		
		if(month == ""){
			month = todayy.getMonth() + 1;
		}
		
		month = parseInt(month)-1; 
		
		if(month<10){
			month = '0'+month;
		}
		
		if(month<1){
			month=12;
			year-=1;
		}
		
		let datee = year+month;
		
		location.href = "/work/deptStatis?month="+datee;
	})
	
})
</script>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.empVO" var="empVO" />
</sec:authorize>

<div class="row">
	<div class="col-2">
		<jsp:include page="/WEB-INF/views/aside/workAside.jsp" />
	</div>
	<div class="col-10">
		<div class="d-flex mt-4 pt-2" style="text-align: center; margin-left: 570px;">
			<button class="btn btn-outline-black rounded-circle p-2 mb-0" type="button"  id="lastMonth" style="background: white; margin-top: -10px; ">
			<i class="fas fa-backward p-2" aria-hidden="true"></i>
			</button>
			&nbsp;&nbsp;&nbsp;<h4 id="month">${date}</h4><input id="hiddenMonth" type="hidden" value="${month }">&nbsp;&nbsp;&nbsp;
			<button class="btn btn-outline-black rounded-circle p-2 mb-0" type="button" id="nextMonth" style="background: white; margin-top: -10px;">
			<i class="fas fa-forward p-2" aria-hidden="true"></i>
			</button>
		</div>
		<div class="container-fluid py-4">
			<div class="row">
				<div class="col-lg-4 col-md-4 col-12">
					<div class="card"
						style="background-image: url('/resources/soft-dashboard/assets/img/curved-images/white-curved.jpeg')">
						<span class="mask bg-gradient-dark opacity-9 border-radius-xl"></span>
						<div class="card-body p-3 position-relative"
							style="height: 158px;">
							<div class="row" style="margin-top: 30px;">
								<div class="col-5 text-end" style="margin-top: 17px;">
									<img alt="Image placeholder" class="avatar rounded-circle me-3"
										src="/resources/soft-dashboard/assets/img/people.png"
										style="width: 80px; height: 80px; margin-top: -20px;">
								</div>
								<div class="col-7 text-start">
									<h3 class="text-white font-weight-bolder mb-0 mt-3">${empVO.deptNm }</h3>
								</div>
							</div>
						</div>
					</div>
					<div class="card"
						style="background-image: url('/resources/soft-dashboard/assets/img/curved-images/white-curved.jpeg'); margin-top: 10px;">
						<span
							class="mask bg-gradient-secondary opacity-9 border-radius-xl"></span>
						<div class="card-body p-3 position-relative"
							style="height: 158px;">
							<div class="row" style="margin-top: 10px;">
								<div class="col-3 text-center"
									style="margin-top: 30px; margin-left: 30px;">
									<img alt="Image placeholder" class="avatar rounded-circle me-3"
										src="/resources/soft-dashboard/assets/img/leadership.png"
										style="width: 50px; height: 50px; margin-top: -20px;">
								</div>
								<div class="col-9 text-start" style="margin-left: -30px;">
									<h3 class="text-white font-weight-border mb-0 mt-3"
										style="font-size: 1.3em;">부서장 &nbsp&nbsp | ${empVO.empNm }&nbsp${empVO.jbpsNm }</h3>
									<h3 class="text-white font-weight-light mb-0 mt-3"
										style="font-size: 1.3em;" id="getDeptPerson"></h3>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-8 col-12 mt-4 mt-lg-0">
					<div class="card h-100">
						<div class="card-header pb-0 p-3">
							<h4 class="mb-0">${empVO.deptNm} &nbsp근태통계</h4>
							<button type="button" style="margin-top:-30px; right-margin: -50px;" 
											class="btn btn-icon-only btn-rounded btn-outline-secondary mb-2 ms-2 btn-sm d-flex align-items-center justify-content-center ms-auto"
											data-bs-toggle="tooltip" data-bs-placement="bottom"
											aria-label="지각 3번은 조퇴 1번 , 조퇴3번은 결근 1번으로 집계됩니다."
											data-bs-original-title="지각 3번은 조퇴 1번, 조퇴3번은 결근 1번으로 집계됩니다.">
											<i class="fas fa-info" aria-hidden="true"></i>
										</button>
						</div>
						<div class="card-body pb-0 p-3">
							<ul class="list-group">
								<li class="list-group-item border-0 d-flex align-items-center px-0 mb-0">
									<div class="w-100">
										<div class="d-flex mb-2">
											<span class="me-2 font-weight-bold text-capitalize" style="font-size:1.1em;">정상근무</span>
											<span class="ms-auto text-sm font-weight-bold" id="ct1"></span>
										</div>
										<div>
											<div class="progress progress-md" id="c1">
												<!-- 												<div class="progress-bar bg-gradient-info w-80" 그래프는 w-80의 숫자를 변경해서 코딩></div> -->
											</div>
										</div>
									</div>
								</li>
								<li class="list-group-item border-0 d-flex align-items-center px-0">
									<div class="w-100">
										<div class="d-flex mb-2">
											<span class="me-2 font-weight-bold text-capitalize" style="font-size:1.1em;">지각
											</span> <span class="ms-auto text-sm font-weight-bold" id="ct2"></span>
										</div>
										<div>
											<div class="progress progress-md" id="c2">
											</div>
										</div>
									</div>
								</li>
								<li class="list-group-item border-0 d-flex align-items-center px-0">
									<div class="w-100">
										<div class="d-flex mb-2">
											<span class="me-2 font-weight-bold text-capitalize" style="font-size:1.1em;">조퇴
											</span> <span class="ms-auto text-sm font-weight-bold" id="ct3"></span>
										</div>
										<div>
											<div class="progress progress-md" id="c3">
											</div>
										</div>
									</div>
								</li>
								<li class="list-group-item border-0 d-flex align-items-center px-0">
									<div class="w-100">
										<div class="d-flex mb-2">
											<span class="me-2 font-weight-bold text-capitalize" style="font-size:1.1em;">결근
											</span> <span class="ms-auto text-sm font-weight-bold" id="ct4"></span>
										</div>
										<div>
											<div class="progress progress-md" id="c4">
											</div>
										</div>
									</div>
								</li>
								<li class="list-group-item border-0 d-flex align-items-center px-0">
									<div class="w-100">
										<div class="d-flex mb-2">
											<span class="me-2 font-weight-bold text-capitalize" style="font-size:1.1em;">휴가
											</span> <span class="ms-auto text-sm font-weight-bold" id="ct5"></span>
										</div>
										<div>
											<div class="progress progress-md" id="c5">
											</div>
										</div>
									</div>
								</li>
							</ul>
						</div>
				</div>
			</div>

			<div class="row" style="margin-top: 20px;">
				<div class="col-lg-2 col-md-2 col-12" style="margin-left: 70px;">
					<div class="card"
						style="background-image: url('/resources/soft-dashboard/assets/img/curved-images/white-curved.jpeg')">
						<span class="mask bg-gradient-dark opacity-9 border-radius-xl"></span>
						<div class="card-body p-3 position-relative"
							style="height: 158px;">
							<div class="row">
								<div class="col-12 text-center" id="count1">
									<h4 class="text-white font-weight-bolder mb-0 mt-3">정상근무</h4>
									<span id="state1" countTo=${map.NORMAL }  class="text-white"
										style="font-size: 2.5em; font-weight: lighter;"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-12">
					<div class="card"
						style="background-image: url('/resources/soft-dashboard/assets/img/curved-images/white-curved.jpeg')">
						<span class="mask bg-gradient-dark opacity-9 border-radius-xl"></span>
						<div class="card-body p-3 position-relative"
							style="height: 158px;">
							<div class="row">
								<div class="col-12 text-center">
									<h4 class="text-white font-weight-bolder mb-0 mt-3">지각</h4>
									<span id="state2" countTo=${map.LATE } class="text-white"
										style="font-size: 2.5em; font-weight: lighter;"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-12">
					<div class="card"
						style="background-image: url('/resources/soft-dashboard/assets/img/curved-images/white-curved.jpeg')">
						<span class="mask bg-gradient-dark opacity-9 border-radius-xl"></span>
						<div class="card-body p-3 position-relative"
							style="height: 158px;">
							<div class="row">
								<div class="col-12 text-center">
									<h4 class="text-white font-weight-bolder mb-0 mt-3">조퇴</h4>
								<span id="state3" countTo=${map.EARLY } class="text-white"
										style="font-size: 2.5em; font-weight: lighter;"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-12">
					<div class="card"
						style="background-image: url('/resources/soft-dashboard/assets/img/curved-images/white-curved.jpeg')">
						<span class="mask bg-gradient-dark opacity-9 border-radius-xl"></span>
						<div class="card-body p-3 position-relative"
							style="height: 158px;">
							<div class="row">
								<div class="col-12 text-center">
									<h4 class="text-white font-weight-bolder mb-0 mt-3">결근</h4>
									<span id="state4" countTo=${map.EMPTY } class="text-white"
										style="font-size: 2.5em; font-weight: lighter;"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-12">
					<div class="card"
						style="background-image: url('/resources/soft-dashboard/assets/img/curved-images/white-curved.jpeg')">
						<span class="mask bg-gradient-dark opacity-9 border-radius-xl"></span>
						<div class="card-body p-3 position-relative"
							style="height: 158px;">
							<div class="row">
								<div class="col-12 text-center">
									<h4 class="text-white font-weight-bolder mb-0 mt-3">휴가</h4>
									<span id="state5" countTo=${map.HOLI } class="text-white"
										style="font-size: 2.5em; font-weight: lighter;"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="container-fluid py-4">
				<div class="d-sm-flex justify-content-between" style="margin-left:1000px; width:300px;">
					<div class="d-flex">
						<button class="btn btn-icon btn-outline-dark ms-2 export"
							data-type="csv" type="button">
							<span class="btn-inner--icon"><i class="ni ni-archive-2"></i></span>
							<span class="btn-inner--text">EXCEL download</span>
						</button>
					</div>
				</div>
				<div class="row">
					<div class="col-12">
						<div class="card">
							<div class="table-responsive">
								<table class="table table-flush" id="datatable-search">
									<thead class="thead-light">
										<tr>
											<th data-sortable=""
												style="width: 13%; font-size: 1.3em; text-align: center;"><a
												href="#" class="dataTable-sorter">부서원</a></th>
											<th data-sortable=""
												style="width: 13%; font-size: 1.3em; text-align: center;"><a
												href="#" class="dataTable-sorter">부서명</a></th>
											<th data-sortable=""
												style="width: 20%; font-size: 1.3em; text-align: center;"><a
												href="#" class="dataTable-sorter">날짜</a></th>
											<th data-sortable=""
												style="width: 13%; font-size: 1.3em; text-align: center;"><a
												href="#" class="dataTable-sorter">출근</a></th>
											<th data-sortable=""
												style="width: 13%; font-size: 1.3em; text-align: center;"><a
												href="#" class="dataTable-sorter">퇴근</a></th>
											<th data-sortable=""
												style="width: 13%; font-size: 1.3em; text-align: center;"><a
												href="#" class="dataTable-sorter">근무상태</a></th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="workVO" items="${workList }" varStatus="">
										<tr>
											<td>
												<div class="d-flex align-items-center"
													style="margin-left: 20px;">
													<div class="form-check"></div>
													<p class="font-weight-bold ms-2 mb-0" style="font-size:1.2em;">${workVO.empNm} &nbsp ${workVO.jbpsNm} </p>
												</div>
											</td>
											<td class="font-weight-bold" style="text-align: center;"><span class="my-2"
												style="font-size:1.2em;">${workVO.deptNm}</span></td>
											<td class="text-md font-weight-bold" style="text-align: center;">
												<div class="d-flex align-items-center">
													<button style="margin-left: 10px;"
														class="btn btn-icon-only btn-rounded btn-outline-success mb-0 me-2 btn-sm d-flex align-items-center justify-content-center">
														<i class="fas fa-check" aria-hidden="true"></i>
													</button>
													<span style="font-size:1.2em;">${workVO.workMngRegYmd}</span>
												</div>
											</td>
											<td class="text-md font-weight-bold" >
												<div class="d-flex align-items-center" style="margin-left: 20px;">
													<span style="font-size:1.2em;">${workVO.workMngBgngDt}</span>
												</div>
											</td>
											<td class="text-md font-weight-bold" style="text-align: center;"><span
												class="my-2" style="font-size:1.2em;">
													${workVO.workMngEndDt } </span></td>
											<td class="text-md font-weight-bold" style="text-align: center;"><span
												class="my-2" style="font-size:1.2em;">${workVO.workMngDtlCn}</span></td>
										</tr>
										</c:forEach>
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
</div>

<script src="/resources/soft-dashboard/assets/js/plugins/countup.min.js"></script>
<script src="/resources/soft-dashboard/assets/js/plugins/datatables.js"></script>

<script>
if (document.getElementById('state1')) {
    const countUp = new CountUp('state1', document.getElementById("state1").getAttribute("countTo"));
    if (!countUp.error) {
      countUp.start();
    } else {
      console.error(countUp.error);
    }
  }
  if (document.getElementById('state2')) {
    const countUp = new CountUp('state2', document.getElementById("state2").getAttribute("countTo"));
    if (!countUp.error) {
      countUp.start();
    } else {
      console.error(countUp.error);
    }
  }
  if (document.getElementById('state3')) {
    const countUp = new CountUp('state3', document.getElementById("state3").getAttribute("countTo"));
    if (!countUp.error) {
      countUp.start();
    } else {
      console.error(countUp.error);
    }
  }
  if (document.getElementById('state4')) {
    const countUp = new CountUp('state4', document.getElementById("state4").getAttribute("countTo"));
    if (!countUp.error) {
      countUp.start();
    } else {
      console.error(countUp.error);
    }
  }
  if (document.getElementById('state5')) {
	    const countUp = new CountUp('state5', document.getElementById("state5").getAttribute("countTo"));
	    if (!countUp.error) {
	      countUp.start();
	    } else {
	      console.error(countUp.error);
	    }
	  }
</script>
<script type="text/javascript">
const dataTableSearch = new simpleDatatables.DataTable("#datatable-search", {
    searchable: true,
    fixedHeight: false,
    perPageSelect: false
  });

  document.querySelectorAll(".export").forEach(function(el) {
    el.addEventListener("click", function(e) {
      var type = el.dataset.type;

      var data = {
        type: type,
        filename: "근태현황",
      };

      if (type === "csv") {
        data.columnDelimiter = "|";
      }

      dataTableSearch.export(data);
    });
  });
  </script>
  <script>
		var win = navigator.platform.indexOf('Win') > -1;
		if (win && document.querySelector('#sidenav-scrollbar')) {
			var options = {
				damping : '0.5'
			}
			Scrollbar.init(document.querySelector('#sidenav-scrollbar'),
					options);
		}
	</script>