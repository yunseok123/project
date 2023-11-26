<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Show Store Location</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f5fb468455abb768835f1cae5f631b25&libraries=services"></script>
    <script src="https://developers.kakao.com/sdk/js/kakao.js"></script> 
    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Arial', sans-serif;
        }

        #map {
            height: 50%;
            margin-bottom: 1%;
        }

        #store-info {
            padding: 1%;
            margin-bottom: 1%;
            border: 1px solid #ddd;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        h3, h4 {
            margin: 0.5% 0;
        }

        p {
            margin: 0.3% 0;
        }
      #navbar {
            display: flex;
            justify-content: flex-end; /* 오른쪽 정렬 */
            padding: 10px 20px;
            background-color: #f5f5f5;
            border-bottom: 1px solid #ddd;
        }

      .nav a {
        text-decoration: none;
        color: #333;
        padding: 5px 10px;
        border: 1px solid #007BFF;
        border-radius: 5px;
        margin-left: 5px;
        background-color: #fff;
        transition: background-color 0.2s;
    }
     #navbar a {
            margin-left: 10px; /* 간격 조정 */
            padding: 5px 10px;
            text-decoration: none;
            color: #333;
            border: 1px solid #ccc;
            border-radius: 3px;
            transition: background-color 0.3s;
        }

        #navbar a:hover {
            background-color: #ddd;
        }
    </style>
</head>
<body>
<body>
<!-- 네비게이션 추가 -->
<div id="navbar">
    <a href="http://localhost:8080/anywhere/index.html">Home</a>
    <a href="http://localhost:8080/asd/anywhere/SearchServlet">뒤로가기</a>
    <!-- 로그인 버튼 아이디와 href 수정 -->
    <a href="#" id="loginLink" onclick="kakaoLogin(); return false;">로그인</a>
    <a href="#">마이페이지</a>
</div>



<div id="map"></div>

<div id="store-info">
<%
String address = (String) request.getAttribute("address");
String storeName = (String) request.getAttribute("name");
String storeDistance = "";
String JDBC_URL_NEW_FOOD = "jdbc:mysql://localhost:3306/new_food_info";
String JDBC_URL_FOOD_KEYWORD = "jdbc:mysql://localhost:3306/food_keyword";
String JDBC_URL_REVIEW = "jdbc:mysql://localhost:3306/review";
String DB_USER = "root";
String DB_PASSWORD = "0000";

Connection connection = null;
Connection connectionKeyword = null;
PreparedStatement preparedStatement = null;
ResultSet resultSet = null;
String storeInfo = "";
Map<String, String> menus = new HashMap<>();
String storeFeatures = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    connection = DriverManager.getConnection(JDBC_URL_NEW_FOOD, DB_USER, DB_PASSWORD);
    String[] tables = {"store_ch", "store_han", "store_jp"};
    for (String table : tables) {
        String sql = "SELECT store_namecol, store_menu, menu_price, store_address, store_tell, store_distance " +
                     "FROM " + table + " WHERE store_namecol=?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, storeName);
        resultSet = preparedStatement.executeQuery();

        while (resultSet.next()) {
            if (storeInfo.isEmpty()) {
                storeInfo = "<h1>" + resultSet.getString("store_namecol") + "</h1>" +
                            "<p>주소: " + resultSet.getString("store_address") + "</p>" +
                            "<p>전화 번호: " + resultSet.getString("store_tell") + "</p>";
                storeDistance = resultSet.getString("store_distance");
            }
            menus.put(resultSet.getString("store_menu"), resultSet.getString("menu_price"));
        }
    }

    connectionKeyword = DriverManager.getConnection(JDBC_URL_FOOD_KEYWORD, DB_USER, DB_PASSWORD);
    String sqlFeature = "SELECT text FROM store_info WHERE store_namecol=?";
    preparedStatement = connectionKeyword.prepareStatement(sqlFeature);
    preparedStatement.setString(1, storeName);
    resultSet = preparedStatement.executeQuery();

    List<String> allowedFeatures = Arrays.asList("단체이용", "포장", "예약", "주차");
    while (resultSet.next()) {
        String featureText = resultSet.getString("text");
        if (allowedFeatures.contains(featureText)) {
            if (!storeFeatures.isEmpty()) {
                storeFeatures += ", ";
            }
            storeFeatures += "#" + featureText;
        }
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (resultSet != null) try { resultSet.close(); } catch (SQLException e) {}
    if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) {}
    if (connection != null) try { connection.close(); } catch (SQLException e) {}
    if (connectionKeyword != null) try { connectionKeyword.close(); } catch (SQLException e) {}
}
%>

<div class="info-box">
    <% out.println(storeInfo); %>
    <% if (!storeDistance.isEmpty()) { %>
        <p>거리: <%= storeDistance %></p>
    <% } %>
    <% if (!storeFeatures.isEmpty()) { %>
        <p>특징: <%= storeFeatures %></p>
    <% } %>
</div>

<div class="info-box">
    <h3>메뉴</h3>
    <%
    for (Map.Entry<String, String> entry : menus.entrySet()) {
        out.println("<p>" + entry.getKey() + " - " + entry.getValue() + "</p>");
    }
    %>
</div>

<div id="reviews">
    <h3>리뷰 목록</h3>
    <%
    Connection connectionReview = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connectionReview = DriverManager.getConnection(JDBC_URL_REVIEW, DB_USER, DB_PASSWORD);

        String reviewSql = "SELECT user_id, user_review, user_rating, store_namecol FROM user_review1 WHERE store_namecol=?";
        preparedStatement = connectionReview.prepareStatement(reviewSql);
        preparedStatement.setString(1, storeName);
        resultSet = preparedStatement.executeQuery();

        while (resultSet.next()) {
    %>
        <div class="info-box">
            <h4>User ID: <%= resultSet.getString("user_id") %></h4>
            <p>리뷰 내용: <%= resultSet.getString("user_review") %></p>
            <p>평점: <%= resultSet.getString("user_rating") %></p>
        </div>
    <%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (resultSet != null) try { resultSet.close(); } catch (SQLException e) {}
        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) {}
        if (connectionReview != null) try { connectionReview.close(); } catch (SQLException e) {}
    }
    %>
</div>

</div>

<script>
var mapContainer = document.getElementById('map');
var mapOption = {
    center: new kakao.maps.LatLng(37.566826, 126.9786567),
    level: 3
};

var map = new kakao.maps.Map(mapContainer, mapOption);
var geocoder = new kakao.maps.services.Geocoder();

geocoder.addressSearch('<%= address %>', function(result, status) {
    if (status === kakao.maps.services.Status.OK) {
        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

        var marker = new kakao.maps.Marker({
            map: map,
            position: coords
        });

        var infowindow = new kakao.maps.InfoWindow({
            content: '<div style="width:150px;text-align:center;padding:6px 0;"><%= storeName %></div>'
        });
        infowindow.open(map, marker);

        map.setCenter(coords);
    }
});

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
    } else {
        const loginLink = document.getElementById('loginLink');
        loginLink.textContent = '로그인';
        loginLink.onclick = kakaoLogin;
    }
}

window.onload = function() {
    updateLoginStatus();
};
</script>
</script>
</body>
</html>