package cpas.controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/asd/anywhere/showStore")
public class ShowStoreServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String address = request.getParameter("address");
        String name = request.getParameter("name");

        request.setAttribute("address", address);
        request.setAttribute("name", name);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/anywhere/View/show.jsp");
        dispatcher.forward(request, response);
    }
}
