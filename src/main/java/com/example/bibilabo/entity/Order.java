package com.example.bibilabo.entity;

import java.util.Date;

public class Order {
    private Integer orderId;
    private Integer userId;
    private Integer storeId;
    private Integer totalPointsSpent;
    private String deliveryAddress;
    private String contactPhone;
    private String status; // 对应 ENUM('PENDING', 'DELIVERING', 'COMPLETED', 'CANCELLED')
    private Date createdAt;
    private Date deliveredAt;

    public Date getDeliveredAt() {
        return deliveredAt;
    }

    public void setDeliveredAt(Date deliveredAt) {
        this.deliveredAt = deliveredAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public Integer getTotalPointsSpent() {
        return totalPointsSpent;
    }

    public void setTotalPointsSpent(Integer totalPointsSpent) {
        this.totalPointsSpent = totalPointsSpent;
    }

    public Integer getStoreId() {
        return storeId;
    }

    public void setStoreId(Integer storeId) {
        this.storeId = storeId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    // 请务必在这里生成 Getter 和 Setter !
}