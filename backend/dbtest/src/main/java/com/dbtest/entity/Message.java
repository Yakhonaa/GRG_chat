package com.dbtest.entity;

public class Message {
    private Integer Id;
    private int chatId;
    private String senderId;
    private String content;
    private String sentAt;

    // A default constructor is required for Spring to create the object.
    public Message() {}

    // Getters and setters for all fields.
    public int getId() { return Id; }
    public void setId(int Id) { this.Id = Id; }

    public int getChatId() { return chatId; }
    public void setChatId(int chatId) { this.chatId = chatId; }

    public String getSenderId() { return senderId; }
    public void setSenderId(String senderId) { this.senderId = senderId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getSentAt() { return sentAt; }
    public void setSentAt(String sentAt) {
    System.out.println("SETTED");
    String convertedHour;
    String convertedMinute;
    int indexOfColon = sentAt.indexOf(':', 0);
    String hour = sentAt.substring(0, indexOfColon); 
    String minute = sentAt.substring(indexOfColon+1);
    convertedHour = hour.length() > 1 ? hour : '0' + hour;
    convertedMinute = minute.length() > 1 ? minute : '0' + minute;
    sentAt = convertedHour + ":" + convertedMinute;
    System.out.println(sentAt);
    //"17:3" -> "17:03"
    this.sentAt = sentAt; }
}