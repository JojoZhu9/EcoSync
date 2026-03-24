package com.example.bibilabo.service;

import com.example.bibilabo.entity.StandardProduct;
import java.util.List;

public interface StandardProductService {
    List<StandardProduct> getAllProducts();
    StandardProduct getProductByBarcode(String barcode);
    void createProduct(StandardProduct product);
    void updateProduct(StandardProduct product);
    void deleteProduct(String barcode);
}