package com.example.bibilabo.entity;

import java.math.BigDecimal;
import java.util.Date;

public class PricingRule {
    private Integer ruleId;
    private String barcode;
    private Integer hoursToExpiration;
    private BigDecimal discountRate;
    private Date updatedAt;

    public Integer getRuleId() {
        return ruleId;
    }

    public void setRuleId(Integer ruleId) {
        this.ruleId = ruleId;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public Integer getHoursToExpiration() {
        return hoursToExpiration;
    }

    public void setHoursToExpiration(Integer hoursToExpiration) {
        this.hoursToExpiration = hoursToExpiration;
    }

    public BigDecimal getDiscountRate() {
        return discountRate;
    }

    public void setDiscountRate(BigDecimal discountRate) {
        this.discountRate = discountRate;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    // 请务必在这里生成 Getter 和 Setter !
}