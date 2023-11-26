<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="cpas.model.Food" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedHashSet" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <title>추천결과</title>
    <meta charset="UTF-8">

    <!-- Kakao SDK -->
    <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
    
    
     <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link href="https://fonts.googleapis.com/css?family=Poppins:100,200,300,400,500,600,700,800,900&display=swap" rel="stylesheet">

    <title>ANYWHERE</title>


    <!-- Additional CSS Files -->
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/anywhere/assets/css/bootstrap.min.css">

    <link rel="stylesheet" type="text/css" href="http://localhost:8080/anywhere/assets/css/font-awesome.css">

    <link rel="stylesheet" href="http://localhost:8080/anywhere/assets/css/templatemo-hexashop.css">

    <link rel="stylesheet" href="http://localhost:8080/anywhere/assets/css/owl-carousel.css">

    <link rel="stylesheet" href="http://localhost:8080/anywhere/assets/css/lightbox.css">
    
    
    
    
    
    

    <style>
  @import url('https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap');

    
    
    
    
        #flexx {
            margin-top: 50px;  
            display: flex;
        }
        
        
        
        #flqb{
             font-family: 'Black Han Sans', sans-serif;
             text-align: center;   
             border: 2px solid #000;
             background-color: #bdd7ee;
             color: #000;
             font-size: 20px;
        }
        
        #flqb:hover{
             background-color: #71b7f5;
        }
        
        
        
        
        #eovy, #wnth {
             font-family: 'Black Han Sans', sans-serif;
             color: #000;
             font-size: 25px;
        }
        
        #rkrp {
                font-family: 'Black Han Sans', sans-serif;
                color: #000;
                font-size: 45px;
        }

        #lef-content, #righ-content {
            margin-top: 20px;  
        }
        #lef-content {
            flex: 1;
            padding: 20px;
            overflow-y: scroll;
            max-height: 100vh;
        }
        #righ-content {
            flex: 1;
            padding: 20px; 
            border-left: 1px solid #ccc;
        }
        iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        .store-item {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .store-item:hover {
            background-color: #e3e3e3;
        }

        .store-info {
            display: flex;
            align-items: center; 
        }

        .store-info img {
            border: 0.2px solid #000;
            margin-right: 20px; /* 이미지와 텍스트 간격 조정 */
            max-width: 250px;
            max-height: 250px;
           
        }

        .store-info-content {
            flex: 1;
        }
    </style>
</head>
<body>

    <!-- ***** Preloader Start ***** -->
    <div id="preloader">
        <div class="jumper">
            <div></div>
            <div></div>
            <div></div>
        </div>
    </div>  
    <!-- ***** Preloader End ***** -->
    
    
        <!-- ***** Header Area Start ***** -->
    <header class="header-area header-sticky">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <nav class="main-nav">
                        <!-- ***** Logo Start ***** -->
                        <a href="http://localhost:8080/anywhere/index.html" class="logo">
                        &nbsp 
                            <img src="http://localhost:8080/anywhere/assets/images/foodlogo.jpg">
                        </a>
                        <!-- ***** Logo End ***** -->
                        <!-- ***** Menu Start ***** -->
                        <ul class="nav">
                      <li class="scroll-to-section" id="loginItem">
                       <a href="#login" onclick="kakaoLogin()" id="loginLink">
                         로그인
                      </a></li>            
    <li class="scroll-to-section"> <a href="http://localhost:8080/anywhere/index.html">Home</a></li>
        <li class="scroll-to-section"> <a href="javascript:location.reload();">다시 추천</a></li>
    
                    </nav>
                </div>
            </div>
        </div>
    </header>
    <!-- ***** Header Area End ***** -->
    
    
    
        <div class="page-heading" id="top">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="inner-content">
                        <h2>추천 목록</h2>
                        <span>가게 이름을 눌러보세요!</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 메인베너임 -->
    
    
    
    
    
    
    
    
    


<section id="flexx">    

<div id="lef-content">

<% 
    List<Food> foods = (List<Food>) request.getAttribute("foods");
    List<Food> uniqueFoods = new ArrayList<>();

    Set<String> storeNames = new HashSet<>();
    
    for (Food food : foods) {
        if (storeNames.add(food.getStoreName())) {
            uniqueFoods.add(food);
        }
    }
    
    if (uniqueFoods != null && !uniqueFoods.isEmpty()) {
        for (Food food : uniqueFoods) {
%>

<!-- 정봉ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ -->
    <section class="section" id="social">

                
                
<div class="store-item">

    <br><h2 id="rkrp"><a id="rkrp" href="#" class="food-link" onclick="selectFood(this);loadStore('<%= food.getStoreAddress() %>', 
    '<%= food.getStoreName() %>'); return false;"><%= food.getStoreName() %></a></h2><br>
    <div class="store-info">
        <% if (food.getFoodPic() != null && !food.getFoodPic().trim().isEmpty()) { %>
            <img src="<%= food.getFoodPic() %>" alt="<%= food.getStoreName() %> 이미지">
        <% } %>
        <div class="store-info-content">
            <% if (!food.getMenus().isEmpty()) { %>
                <p id="eovy">대표메뉴: <%= food.getMenus().get(0).getName() %> - <%= food.getMenus().get(0).getPrice() %></p><br>
            <% } %>
            <p id="wnth">주소: <%= food.getStoreAddress() %></p><br>
            <button id="flqb" href="#" onclick="openReviewsWindow('<%= food.getStoreName() %>'); return false;">&nbsp 리뷰 하기 &nbsp</button><br>
              
            
        </div>
    </div>
</div>


</section>
<!-- 정봉ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ -->

<%
        }
    } else {
%>
    <p>검색 결과가 없습니다.</p>
<% 
    }
%>
</div>


<div id="righ-content">
    <iframe id="storeFrame" src=""></iframe>
</div>


<script type="text/javascript">
    // 카카오 초기화
    Kakao.init('f5fb468455abb768835f1cae5f631b25');

    function kakaoLogin() {
        Kakao.Auth.login({
            success: function(authObj) {
                updateLoginStatus();
            },
            fail: function(err) {
                console.error(err);
            }
        });
    }

    function kakaoLogout() {
        Kakao.Auth.logout(function() {
            alert('로그아웃 되었습니다.');
            const loginLink = document.getElementById('loginLink');
            loginLink.textContent = '로그인';
            loginLink.onclick = kakaoLogin;
        });
    }

    function updateLoginStatus() {
        if (Kakao.Auth.getAccessToken()) {
            Kakao.API.request({
                url: '/v2/user/me',
                success: function(res) {
                    const loginLink = document.getElementById('loginLink');
                    loginLink.textContent = res.properties.nickname;
                    loginLink.onclick = () => {
                        if (confirm('로그아웃 하시겠습니까?')) {
                            kakaoLogout();
                        }
                    };
                },
                fail: function(error) {
                    console.error(error);
                }
            });
        }
    }

    window.onload = function() {
        <% if (foods != null && foods.size() > 0) { %>
            loadStore('<%= foods.get(0).getStoreAddress() %>', '<%= foods.get(0).getStoreName() %>');
        <% } else { %>
            var iframe = document.getElementById("storeFrame");
            iframe.src = ""; // src를 빈 문자열로 설정
        <% } %>

        // 로그인 상태 업데이트
        updateLoginStatus();
    };
</script>
<script>
    function loadStore(address, name) {
        var iframe = document.getElementById("storeFrame");
        iframe.src = "showStore?address=" + encodeURIComponent(address) + "&name=" + encodeURIComponent(name);
    }

    function loadReviews(storeName) {
        window.location.href = "/anywhere/review.html?storeName=" + encodeURIComponent(storeName);
    }

    // 페이지 로드가 완료되면 첫 번째 가게 정보를 아이프레임에 로드
   // 페이지 로드가 완료되면 첫 번째 가게 정보를 아이프레임에 로드
window.onload = function() {
    updateLoginStatus();

    <% if (foods != null && foods.size() > 0) { %>
    loadStore('<%= foods.get(0).getStoreAddress() %>', '<%= foods.get(0).getStoreName() %>');
    // 첫 번째 음식점의 배경색을 변경하는 코드 추가
    var firstFoodLink = document.querySelector(".store-item .food-link");
    if(firstFoodLink) {
        firstFoodLink.closest(".store-item").style.backgroundColor = "#bdd7ee"; // 파란색으로 변경
    }
<% } else { %>
    var iframe = document.getElementById("storeFrame");
    iframe.src = ""; // src를 빈 문자열로 설정
<% } %>
};

function openReviewsWindow(storeName) {
    // 카카오톡 로그인 상태 확인
    Kakao.Auth.getStatusInfo(function (statusInfo) {
        if (statusInfo.status === 'connected') {
            // 이미 로그인된 경우 리뷰 창을 열기
            var url = "/anywhere/review.html?storeName=" + encodeURIComponent(storeName);
            var reviewWindow = window.open(url, '리뷰 하기', 'width=600,height=300');

            // 리뷰 창을 저장한 변수를 부모 창에 전달
            if (reviewWindow) {
                reviewWindow.opener = window;
            }
        } else {
            // 로그인 상태가 아닌 경우 메시지 표시
            alert("카카오톡 계정으로 로그인해 주세요.");
        }
    });
}
function selectFood(element) {
    // 모든 음식점 구역의 배경색 초기화
    var allFoodLinks = document.querySelectorAll(".store-item .food-link");
    allFoodLinks.forEach(function (foodLink) {
        foodLink.closest(".store-item").style.backgroundColor = ""; // 기본 배경색으로 초기화
    });

    // 선택한 음식점 구역의 배경색 변경
    var storeItem = element.closest(".store-item");
    storeItem.style.backgroundColor = "#bdd7ee"; // 파란색으로 변경

    // 선택한 음식점 구역으로 스크롤
    storeItem.scrollIntoView({behavior: "smooth", block: "start"});

    // 스무스 스크롤이 일어난 후 조금만 올리기 위한 setTimeout
    setTimeout(function() {
        window.scrollBy(0, -60); // 예시로 60px만큼 위로 올립니다.
    }, 500); // 500ms 후에 실행
}

</script>
</section>


    <!-- jQuery -->
    <script src="http://localhost:8080/anywhere/assets/js/jquery-2.1.0.min.js"></script>

    <!-- Bootstrap -->
    <script src="http://localhost:8080/anywhere/assets/js/popper.js"></script>
    <script src="http://localhost:8080/anywhere/assets/js/bootstrap.min.js"></script>

    <!-- Plugins -->
    <script src="http://localhost:8080/anywhere/assets/js/owl-carousel.js"></script>
    <script src="http://localhost:8080/anywhere/assets/js/accordions.js"></script>
    <script src="http://localhost:8080/anywhere/assets/js/datepicker.js"></script>
    <script src="http://localhost:8080/anywhere/assets/js/scrollreveal.min.js"></script>
    <script src="http://localhost:8080/anywhere/assets/js/waypoints.min.js"></script>
    <script src="http://localhost:8080/anywhere/assets/js/jquery.counterup.min.js"></script>
    <script src="http://localhost:8080/anywhere/assets/js/imgfix.min.js"></script> 
    <script src="http://localhost:8080/anywhere/assets/js/slick.js"></script> 
    <script src="http://localhost:8080/anywhere/assets/js/lightbox.js"></script> 
    <script src="http://localhost:8080/anywhere/assets/js/isotope.js"></script>
    <script src="http://localhost:8080/anywhere/assets/js/quantity.js"></script>
    
    <!-- Global Init -->
    <script src="http://localhost:8080/anywhere/assets/js/custom.js"></script>

    <script>

        $(function() {
            var selectedClass = "";
            $("p").click(function(){
            selectedClass = $(this).attr("data-rel");
            $("#portfolio").fadeTo(50, 0.1);
                $("#portfolio div").not("."+selectedClass).fadeOut();
            setTimeout(function() {
              $("."+selectedClass).fadeIn();
              $("#portfolio").fadeTo(50, 1);
            }, 500);
                
            });
        });

    </script>
</body>
</html>
	