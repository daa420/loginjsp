<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login</title>
</head>
<body>
<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("user");
    String pwd = request.getParameter("pwd");

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        // Load MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Establish connection
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/app", "root", "root");

        // Prepare SQL statement to prevent SQL injection
        String query = "SELECT * FROM login WHERE username = ?";
        pst = con.prepareStatement(query);
        pst.setString(1, username);

        rs = pst.executeQuery();
        if (rs.next()) {
            if (rs.getString("password").equals(pwd)) { // Ensure column name matches your database schema
                session.setAttribute("user", rs.getString("username"));
                String name = (String) session.getAttribute("user");
                out.println("Welcome " + name);
            } else {
                out.println("Invalid password, try again.");
            }
        } else {
            out.println("Username not found.");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("Error closing resources: " + e.getMessage());
        }
    }
%>
</body>
</html>
