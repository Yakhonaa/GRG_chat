package com.dbtest.websocket;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.dbtest.entity.EditMessage;
import com.dbtest.entity.Message;

@Controller
public class WebSocketController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private MessageService messageService; // Autowire the service here

    @MessageMapping("/chat/{chatID}")
    public void sendMessage(@Payload Message message, @DestinationVariable String chatID) {
        // Delegate the saving logic to the service
        System.out.println("MESSAGE CHAT ID:" + message.getChatId());
        System.out.println("MESSAGE CONTENT:" + message.getContent());
        System.out.println("MESSAGE SENDER ID:" + message.getSenderId());
        System.out.println("MESSAGE SENT AT:" + message.getSentAt());
        Message savedMessage = messageService.saveMessage(message);

        // Check if the save was successful before broadcasting
        if (savedMessage != null) {
            messagingTemplate.convertAndSend("/topic/chat/" + chatID, savedMessage);
        }
    }
    @MessageMapping("/chat/{chatID}/delete")
    public void deleteMessage(@Payload int messageId, @DestinationVariable int chatID) {

        messageService.deleteMessage(messageId, chatID);
        System.out.println("DELETE" + chatID + " " + messageId);
        // Check if the save was successful before broadcasting
            messagingTemplate.convertAndSend("/topic/chat/" + chatID, messageId);
        
    }
    @MessageMapping("/chat/{chatID}/edit")
    public void editMessage(@Payload EditMessage editMessage, @DestinationVariable int chatID) {
        messageService.editMessage(editMessage, chatID);
        List<Object> response = new ArrayList<>();
        response.add(editMessage.getMessageId());
        response.add(editMessage.getNewText());
        // Check if the save was successful before broadcasting
        messagingTemplate.convertAndSend("/topic/chat/" + chatID, response);
        
    }
}

