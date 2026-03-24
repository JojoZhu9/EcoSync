package com.example.bibilabo.service.impl;

import com.example.bibilabo.entity.StandardProduct;
import com.example.bibilabo.mapper.StandardProductMapper;
import com.example.bibilabo.service.StandardProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class StandardProductServiceImpl implements StandardProductService {

    @Autowired
    private StandardProductMapper productMapper;

    @Override
    public List<StandardProduct> getAllProducts() {
        return productMapper.findAll();
    }

    @Override
    public StandardProduct getProductByBarcode(String barcode) {
        return productMapper.findByBarcode(barcode);
    }

    @Override
    public void createProduct(StandardProduct product) {
        productMapper.insert(product);
    }

    @Override
    public void updateProduct(StandardProduct product) {
        productMapper.update(product);
    }

    @Override
    public void deleteProduct(String barcode) {
        productMapper.deleteByBarcode(barcode);
    }
}