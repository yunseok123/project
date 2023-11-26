package cpas.controller;

import cpas.model.Food;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/asd/anywhere/SearchServlet")
public class SearchServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/new_food_info";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "0000";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String searchQuery = request.getParameter("searchQuery");
        if (searchQuery != null) {
            List<Food> foods = getFoodsFromDB(searchQuery);
            request.setAttribute("foods", foods);
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/anywhere/View/result.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }

    private List<Food> getFoodsFromDB(String query) {
        List<Food> foods = new ArrayList<>();
        String[] tableNames = new String[]{"store_han", "store_jp", "store_ch"};

        String JDBC_URL_FOOD_KEYWORD = "jdbc:mysql://localhost:3306/food_keyword"; 
        List<String> matchingStoreNames = new ArrayList<>();
        List<String> keywords = new ArrayList<>();
        for (int i = 0; i < query.length(); i++) {
            for (int j = i + 1; j <= query.length(); j++) {
                keywords.add(query.substring(i, j));
            }
        }
        
        try (Connection connection = DriverManager.getConnection(JDBC_URL_FOOD_KEYWORD, DB_USER, DB_PASSWORD)) {
            for (String keyword : keywords) {  // 각 키워드에 대해 검색 수행
                String sql = "SELECT store_namecol FROM store_info WHERE text LIKE ?";
                try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                    preparedStatement.setString(1, "%" + keyword + "%");
                    ResultSet resultSet = preparedStatement.executeQuery();
                    while (resultSet.next()) {
                        matchingStoreNames.add(resultSet.getString("store_namecol"));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // `new_food_info` 데이터베이스에서 검색
        try (Connection connection = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD)) {
            for (String tableName : tableNames) {
                // 새로운 기능: text 기반 검색
                for (String storeName : matchingStoreNames) {
                    String sqlForKeywordMatch = "SELECT store_namecol, store_menu, menu_price, store_address, store_tell, food_pic FROM " 
                                + tableName 
                                + " WHERE store_namecol = ?";
                    try (PreparedStatement preparedStatement = connection.prepareStatement(sqlForKeywordMatch)) {
                        preparedStatement.setString(1, storeName);
                        ResultSet resultSet = preparedStatement.executeQuery();
                        while (resultSet.next()) {
                            Food food = new Food();
                            food.setStoreName(resultSet.getString("store_namecol"));
                            food.setStoreAddress(resultSet.getString("store_address"));
                            food.setStoreTell(resultSet.getString("store_tell"));
                            food.addMenu(resultSet.getString("store_menu"), resultSet.getString("menu_price"));
                            
                            // 추가된 부분
                            food.setFoodPic(resultSet.getString("food_pic"));
                            
                            foods.add(food);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                // 기존 기능: 메뉴 및 가게 이름 검색
                String sqlForOriginalSearch = "SELECT store_namecol, store_menu, menu_price, store_address, store_tell, food_pic FROM " 
                            + tableName 
                            + " WHERE store_menu LIKE ? OR store_namecol LIKE ?";
                try (PreparedStatement preparedStatement = connection.prepareStatement(sqlForOriginalSearch)) {
                    preparedStatement.setString(1, "%" + query + "%");
                    preparedStatement.setString(2, "%" + query + "%");
                    ResultSet resultSet = preparedStatement.executeQuery();
                    while (resultSet.next()) {
                        Food food = new Food();
                        food.setStoreName(resultSet.getString("store_namecol"));
                        food.setStoreAddress(resultSet.getString("store_address"));
                        food.setStoreTell(resultSet.getString("store_tell"));
                        food.addMenu(resultSet.getString("store_menu"), resultSet.getString("menu_price"));
                        
                        // 추가된 부분
                        food.setFoodPic(resultSet.getString("food_pic"));
                        
                        foods.add(food);
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return foods;
    }
}