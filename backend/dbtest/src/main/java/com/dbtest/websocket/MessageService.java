package com.dbtest.websocket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dbtest.entity.EditMessage;
import com.dbtest.entity.Message;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.sql.DataSource;

@Service
public class MessageService {

    @Autowired
    private DataSource dataSource;

    public Message saveMessage(Message message) {
        String sql = "INSERT INTO messages (chat_id, sender_id, content, sent_at) VALUES (?,?,?,?)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, message.getChatId());
            pstmt.setString(2, message.getSenderId());
            pstmt.setString(3, message.getContent());
            pstmt.setString(4, message.getSentAt());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating message failed, no rows affected.");
            }

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    message.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating message failed, no ID obtained.");
                }
            }
            return message;
        } catch (SQLException e) {
            e.printStackTrace();
            return null; // Handle error gracefully
        }
    }

    public void deleteMessage(int messageId, int chatId) {
        String sql = "DELETE FROM messages WHERE chat_id = ? and id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, chatId);
            pstmt.setInt(2, messageId);

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating message failed, no rows affected.");
            }
        } catch (SQLException e) {
            e.printStackTrace(); 
        }
    }
    public void editMessage(EditMessage editMessage, int chatID) {
        System.out.println("EDIT MESSAGE JAVA");
        String sql = "UPDATE messages SET content = ? WHERE id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, editMessage.getNewText());
            pstmt.setInt(2, editMessage.getMessageId());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating message failed, no rows affected.");
            }
        } catch (SQLException e) {
            e.printStackTrace(); 
        }
    }
}

