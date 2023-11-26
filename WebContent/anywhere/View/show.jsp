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
    <style>
      @import url('https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap');
      @import url('https://fonts.googleapis.com/css2?family=Hahmlet&display=swap');
      @import url('https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding&display=swap');
      @import url('https://fonts.googleapis.com/css2?family=Dongle:wght@700&display=swap');
      @import url('https://fonts.googleapis.com/css2?family=Orbit&display=swap');
      
    
   
        p {
            margin: 0.3% 0;
            font-family: 'Orbit', sans-serif;
            color: #000;            
            font-size: 20px;
        } 
        
        h3{
           font-family: 'Hahmlet', serif;
           font-size:25px;
        }
    
        h2 {
                font-family: 'Hahmlet', serif;
                color: #000;
                font-size: 35px;
        }
    

        body, html {
            height: 100%;
            margin: 0;
        }

      #map {
    height: 40%; /* 지도의 높이를 줄입니다. */
    margin-bottom: 1%;
}


     #store-info {
    padding: 2%; /* 상세 정보 창의 패딩을 조절합니다. */
    margin-bottom: 1%;
    border: 1px solid #ddd;
    background-color: #fff;
    border-radius: 5px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    min-height: 300px; /* 상세 정보 창의 최소 높이를 지정합니다. */
}
        h3, h4, h2 {
            margin: 0.5% 0;
        }

    .roadview-button {
        display: inline-block;
        margin-top: 5px;
        padding: 3px 10px;
        background-color: #1781d1;
        color: #fff;
        text-decoration: none;
        border-radius: 3px;
    }

    .roadview-button:hover {
        background-color: #1368a5; /* 클릭 시 배경색 변경 */
    }
</style>
</head>
<body>
<div id="map"></div>

<div id="store-info"> 

<% 
String address = (String) request.getAttribute("address");
String storeName = (String) request.getAttribute("name");
String storeDistance = ""; // Added for store_distance
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
                storeInfo = "<h2>" + resultSet.getString("store_namecol") + "</h2><br>" +
                            "<p>address: " + resultSet.getString("store_address") + "</p>" +
                            "<p>Tel: " + resultSet.getString("store_tell") + "</p>";
                storeDistance = resultSet.getString("store_distance"); // Get the store_distance
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
</div><br>

<div class="info-box">
    <h3>메뉴</h3>
    <% 
    for (Map.Entry<String, String> entry : menus.entrySet()) {
        out.println("<p>" + entry.getKey() + " - " + entry.getValue() + "</p>");
    }
    %>
</div><br>

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

         var roadViewUrl = 'https://map.kakao.com/link/to/' + encodeURIComponent('<%= storeName %>') + ',' + result[0].y + ',' + result[0].x;

      var infowindowContent = '<div style="width:auto;text-align:center;padding-bottom:-20px;">'
                         
                              + '<br><a href="#" onclick="openKakaoMap(\'' + roadViewUrl 
                              + '\')" class="roadview-button">길찾기</a>'
                              + '</div>';
        
      var infowindow = new kakao.maps.InfoWindow({
         content : infowindowContent,
            removable : true // Add this line to make the info window removable
      });
        
      kakao.maps.event.addListener(marker, 'click', function() {
         if (infowindow.getMap()) {
            infowindow.close();
         } else { 
            infowindow.open(map, marker);
         }
      });
      
         map.setCenter(coords);
   }
});
function openKakaoMap(url) {
    window.open(url, 'Kakao Map', 'width=500, height=800');
}

</script>

   </body>
   </html>