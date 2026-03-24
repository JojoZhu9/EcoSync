package com.example.bibilabo.controller;

import com.example.bibilabo.entity.StandardProduct;
import com.example.bibilabo.service.StandardProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products") // 接口前缀定为 /api/products
public class StandardProductController {

    @Autowired
    private StandardProductService productService;

    @GetMapping
    public List<StandardProduct> getAll() {
        return productService.getAllProducts();
    }

    @GetMapping("/{barcode}")
    public StandardProduct getByBarcode(@PathVariable String barcode) {
        return productService.getProductByBarcode(barcode);
    }

    @PostMapping
    public String add(@RequestBody StandardProduct product) {
        productService.createProduct(product);
        return "商品添加成功，条码: " + product.getBarcode();
    }

    @PutMapping("/{barcode}")
    public String update(@PathVariable String barcode, @RequestBody StandardProduct product) {
        product.setBarcode(barcode);
        productService.updateProduct(product);
        return "商品更新成功";
    }

    @DeleteMapping("/{barcode}")
    public String delete(@PathVariable String barcode) {
        productService.deleteProduct(barcode);
        return "商品删除成功";
    }
}