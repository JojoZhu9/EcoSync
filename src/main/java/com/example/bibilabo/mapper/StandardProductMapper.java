package com.example.bibilabo.mapper;

import com.example.bibilabo.entity.StandardProduct;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface StandardProductMapper {

    // 查：获取所有商品
    @Select("SELECT * FROM standard_products")
    List<StandardProduct> findAll();

    // 查：根据条码获取单个商品
    @Select("SELECT * FROM standard_products WHERE barcode = #{barcode}")
    StandardProduct findByBarcode(String barcode);

    // 增：录入新商品 (主键是手动输入的条码，所以不需要返回自增ID)
    @Insert("INSERT INTO standard_products(barcode, product_name, normal_price) VALUES(#{barcode}, #{productName}, #{normalPrice})")
    int insert(StandardProduct product);

    // 改：更新商品信息 (根据条码更新名称或价格)
    @Update("UPDATE standard_products SET product_name = #{productName}, normal_price = #{normalPrice} WHERE barcode = #{barcode}")
    int update(StandardProduct product);

    // 删：根据条码删除商品
    @Delete("DELETE FROM standard_products WHERE barcode = #{barcode}")
    int deleteByBarcode(String barcode);
}