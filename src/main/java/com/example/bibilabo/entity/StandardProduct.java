package com.example.bibilabo.entity;

import java.math.BigDecimal;

public class StandardProduct {
    private String barcode; // 主键是条码，所以用 String
    private String productName;
    private BigDecimal normalPrice; // 涉及到金额，推荐使用 BigDecimal 或者 Double

    // --- 下面是 Getter 和 Setter ---
    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getNormalPrice() { return normalPrice; }
    public void setNormalPrice(BigDecimal normalPrice) { this.normalPrice = normalPrice; }
}