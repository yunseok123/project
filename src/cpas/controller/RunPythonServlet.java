package cpas.controller;

import cpas.model.Food;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/asd/anywhere/RunPythonServlet")
public class RunPythonServlet extends HttpServlet {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/new_food_info";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "0000";
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to load the MySQL JDBC driver");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        String kakaoId = request.getParameter("kakao_id");
        String visitPurpose = request.getParameter("visit_purpose");
        String[] features = request.getParameterValues("features[]");

        // 파이썬 스크립트 실행
        String scriptPath = "C:\\Program Files\\ss\\last.py";
        String pythonPath = "C:\\Users\\sddd\\anaconda3\\envs\\myenv\\python.exe";
        List<String> cmdList = new ArrayList<>();
        cmdList.add(pythonPath);
        cmdList.add(scriptPath);
        cmdList.add(visitPurpose);
        if(features != null) {
            cmdList.addAll(Arrays.asList(features));
        }
        cmdList.add(kakaoId);
        ProcessBuilder processBuilder = new ProcessBuilder(cmdList);
        Process process = processBuilder.start();
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream(), "UTF-8"));
        StringBuilder pythonResult = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            pythonResult.append(line).append("\n");
        }
 

        String[] storeNames = pythonResult.toString().split("\n");

        List<Food> foods = new ArrayList<>();
        try (Connection connection = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD)) {
            for (String storeRatingPair : storeNames) {
                if (storeRatingPair.trim().isEmpty()) continue;

                String[] parts = storeRatingPair.split(":");
                String storeName = parts[0].trim();
                double predictedRating = parts.length > 1 ? Double.parseDouble(parts[1]) : 0.0;

                // 각각의 테이블을 조회
                String[] tables = {"store_ch", "store_han", "store_jp"};
                String[] descriptions = {"중식", "한식", "일식"};

                for (int i = 0; i < tables.length; i++) {
                    String table = tables[i];
                    String description = descriptions[i];

                    String sql = "SELECT store_namecol, store_menu, menu_price, store_address, food_pic " +  
                                    "FROM " + table + " WHERE store_namecol = ?";
                    try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                        preparedStatement.setString(1, storeName);
                        ResultSet resultSet = preparedStatement.executeQuery();

                        Food food = null;
                        while (resultSet.next()) {
                            if (food == null) {
                                food = new Food();
                                food.setStoreName(resultSet.getString("store_namecol"));
                                food.setStoreAddress(resultSet.getString("store_address"));
                                food.setOrigin(description);
                                food.setFoodPic(resultSet.getString("food_pic"));
                                food.setPredictedRating(predictedRating); // 예상 평점을 설정
                                foods.add(food);
                            }
                            food.addMenu(resultSet.getString("store_menu"), resultSet.getString("menu_price"));
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("foods", foods);
        request.getRequestDispatcher("/anywhere/View/result2.jsp").forward(request, response);
}
}