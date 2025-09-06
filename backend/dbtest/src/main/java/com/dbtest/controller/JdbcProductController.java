package com.dbtest.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.dbtest.entity.Message;
import java.sql.Statement;


@RestController
public class JdbcProductController {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/login")
    public ArrayList<String> Login(@RequestParam String  username, @RequestParam String password) throws Exception{
        ArrayList<String> contacts = new ArrayList<>();
        boolean exists;
        String verificationSql = "SELECT 1 FROM users Where username = ? and password = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(verificationSql)) {
                pstmt.setString(1, username); 
                pstmt.setString(2, password); 
                ResultSet rs = pstmt.executeQuery();       
                exists = rs.next();
             }
        if (exists) {
        String sql = "SELECT contact_name from contacts\n" + //
                        "WHERE person_id = (select users.id from users where \n" + //
                        "users.username = ? and users.password = ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username); 
            pstmt.setString(2, password); 
            
            ResultSet rs = pstmt.executeQuery();
            contacts.add("UserDoesExists");
            while (rs.next()){
                String contact_name = rs.getString(1);
                contacts.add(contact_name);
            }         
            return contacts;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception (e);
        }
    } 
    else {
        contacts.add("UserDoesNotExists"); 
        return contacts;    
    }
    }

    
     @GetMapping("/searchForContact")
    public String contactSearch(@RequestParam String username) {
        String sql = "SELECT username FROM users where username = ?";
        try (Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);

            ResultSet rs = pstmt.executeQuery(); // ✅ Use executeUpdate

            if (rs.next()) {
                return rs.getString(1);
            } else {
                return "User does not exist";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }
    @GetMapping("/getChatId")
    public String getChatId(@RequestParam String user1, @RequestParam String user2) throws Exception {   
        boolean exists;
        String chatId = "";
        String checkSql = "SELECT id FROM chats WHERE chat_name = ? or chat_name = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
                String statement1 = user1 + user2;
                String statement2 = user2 + user1;
                pstmt.setString(1, statement1); 
                pstmt.setString(2, statement2); 
                ResultSet rs = pstmt.executeQuery();       
                exists = rs.next();
                if (exists) {chatId = rs.getString(1);};
             }
        if (!exists) {
        String insertSql = "INSERT INTO chats (chat_name) Values (?)";
        try (Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            String chat_name = user1 + user2;
            pstmt.setString(1, chat_name); 
            pstmt.executeUpdate();
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
            rs.next();
            chatId = rs.getString(1); // ✅ This works both on insert & duplicate
            return chatId;
    }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception (e);
        }
    } else {return chatId;}
    }     
     
    @GetMapping("/register")
    public String registration(@RequestParam String username, @RequestParam String password) {
        String sql = "INSERT IGNORE INTO users (username, password) VALUES (?, ?)";
        try (Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            pstmt.setString(2, password);

            int rows = pstmt.executeUpdate(); // ✅ Use executeUpdate

            if (rows == 1) {
                return "User registered successfully";
            } else {
                return "Username already exists";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }

    @GetMapping("/getUserId")
    public String getUserId(@RequestParam String username) {
        String sql = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery(); // ✅ Use executeUpdate
            rs.next();

            return rs.getString(1);
            
        } catch (SQLException e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }

    @GetMapping("/addNewContact")
    public String addNewContact(@RequestParam String username, @RequestParam String contactName) {
        String sql = "INSERT INTO contacts (contact_id, person_id, contact_name)\n" + 
                     "SELECT u1.id, u2.id, ? FROM users u1\n" +
                        "JOIN users u2 ON u1.username = ? AND u2.username = ?;";
        try (Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, contactName);
            pstmt.setString(2, contactName);
            pstmt.setString(3, username);
            pstmt.executeUpdate(); // ✅ Use executeUpdate


            return "User registered successfully";
            
        } catch (SQLException e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }

    @GetMapping("/getHistory")
    public List<Message> getName(@RequestParam Integer chatIdParam) throws Exception {
        String sql = "SELECT * FROM messages WHERE chat_id = ?";
        List<Message> messages = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);) {
            
            pstmt.setInt(1, chatIdParam);
            // INSERTS INTO QUERY ^^^^^^
            ResultSet rs = pstmt.executeQuery();
            //EXECUTES
            while (rs.next()){
                Message message = new Message();
                message.setId(rs.getInt("id"));
                message.setChatId(rs.getInt("chat_id"));
                message.setSenderId(rs.getString("sender_id"));
                message.setContent(rs.getString("content"));
                message.setSentAt(rs.getString("sent_at"));
                messages.add(message);
            }
            
            return messages;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception(e);
        }
    }

    @DeleteMapping("/clearChat")
    public String clearChat(@RequestParam Integer chatIdParam) throws Exception {
        String sql = "DELETE FROM messages WHERE chat_id = ?";
        try (Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);) {
            pstmt.setInt(1, chatIdParam);
            pstmt.executeUpdate();
            return "successfull deletion";
        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception(e);
        }
    } 


}