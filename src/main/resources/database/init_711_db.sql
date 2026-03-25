CREATE DATABASE IF NOT EXISTS 711ex DEFAULT CHARACTER SET utf8mb4;
USE 711ex;

-- ==========================================
-- 2. 清理可能存在的旧表 (按外键依赖顺序倒序删除)
-- ==========================================
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS shopping_cart;
DROP TABLE IF EXISTS expiring_products;
DROP TABLE IF EXISTS pricing_rules;
DROP TABLE IF EXISTS standard_products;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS stores;

-- ==========================================
-- 1. 基础信息模块 (门店与用户)
-- ==========================================

-- 1.1 门店表 (Stores)
CREATE TABLE stores (
                        store_id INT AUTO_INCREMENT PRIMARY KEY,
                        store_name VARCHAR(100) NOT NULL COMMENT '门店名称（如：7-11 科技园店）',
                        city VARCHAR(50) NOT NULL COMMENT '所在城市',
                        address VARCHAR(255) NOT NULL COMMENT '详细地址',
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='7-11门店表';

-- 1.2 用户表 (Users)
CREATE TABLE users (
                       user_id INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) NOT NULL UNIQUE COMMENT '登录用户名',
                       password_hash VARCHAR(255) NOT NULL COMMENT '加密后的密码',
                       role ENUM('CONSUMER', 'EMPLOYEE', 'ADMIN') NOT NULL DEFAULT 'CONSUMER' COMMENT '用户角色',
                       store_id INT DEFAULT NULL COMMENT '如果是员工，关联其所属门店',
                       points INT DEFAULT 0 COMMENT '会员积分（消费者用于支付）',
                       phone_number VARCHAR(20) COMMENT '默认联系电话（消费者用于收货）',
                       default_address VARCHAR(255) COMMENT '默认收货地址（送货上门）',
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
                       FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';


-- ==========================================
-- 2. 商品字典与降价规则模块 (SPU)
-- ==========================================

-- 2.1 系统内部商品品类表 (Standard Products)
CREATE TABLE standard_products (
                                   barcode VARCHAR(50) PRIMARY KEY COMMENT '商品条码（主键）',
                                   product_name VARCHAR(100) NOT NULL COMMENT '商品名称（如：照烧鸡排便当）',
                                   normal_price DECIMAL(10, 2) NOT NULL COMMENT '正常售价（初始价格）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统内部商品字典/品类表';

-- 2.2 降价规则表 (Pricing Rules)
CREATE TABLE pricing_rules (
                               rule_id INT AUTO_INCREMENT PRIMARY KEY,
                               barcode VARCHAR(50) NOT NULL COMMENT '适用商品的条码（关联标准商品表）',
                               hours_to_expiration INT NOT NULL COMMENT '距离过期的小时数（如 12 代表剩余12小时以内）',
                               discount_rate DECIMAL(4, 2) NOT NULL COMMENT '折扣率 (如 0.50 代表 5折)',
                               updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP,
                               FOREIGN KEY (barcode) REFERENCES standard_products(barcode) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='基于条码的特定商品降价规则表';


-- ==========================================
-- 3. 临期库存模块 (SKU/实例)
-- ==========================================

-- 3.1 临期商品上架表 (Expiring Products)
CREATE TABLE expiring_products (
                                   product_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '实际上架的商品ID（主键）',
                                   barcode VARCHAR(50) NOT NULL COMMENT '商品条码（读取标准库名称和原价）',
                                   store_id INT NOT NULL COMMENT '所属发货门店',
                                   expiration_time DATETIME NOT NULL COMMENT '精确到期的具体时间',
                                   remaining_stock INT NOT NULL DEFAULT 1 COMMENT '剩余存量',
                                   status ENUM('AVAILABLE', 'SOLD_OUT', 'DISCARDED') NOT NULL DEFAULT 'AVAILABLE' COMMENT '状态：在售、售罄、已报损',
                                   created_by INT COMMENT '录入该商品的员工ID',
                                   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP() COMMENT '录入时间',
                                   FOREIGN KEY (barcode) REFERENCES standard_products(barcode) ON UPDATE CASCADE,
                                   FOREIGN KEY (store_id) REFERENCES stores(store_id),
                                   FOREIGN KEY (created_by) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='员工录入的临期商品上架与库存表';


-- ==========================================
-- 4. 交易与配送模块 (购物车与订单)
-- ==========================================

-- 4.1 购物车表 (Shopping Cart)
CREATE TABLE shopping_cart (
                               cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
                               user_id INT NOT NULL COMMENT '消费者ID',
                               product_id INT NOT NULL COMMENT '购买的具体临期批次商品ID',
                               quantity INT NOT NULL DEFAULT 1 COMMENT '加入购物车的数量',
                               added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP() COMMENT '加入购物车的时间',
                               FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                               FOREIGN KEY (product_id) REFERENCES expiring_products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户购物车表';

-- 4.2 配送订单表 (Orders)
CREATE TABLE orders (
                        order_id INT AUTO_INCREMENT PRIMARY KEY,
                        user_id INT NOT NULL COMMENT '购买的消费者',
                        store_id INT NOT NULL COMMENT '负责配送的 7-11 门店',
                        total_points_spent INT NOT NULL COMMENT '支付的积分总额',
                        delivery_address VARCHAR(255) NOT NULL COMMENT '本单实际送货地址',
                        contact_phone VARCHAR(20) NOT NULL COMMENT '本单实际联系电话',
                        status ENUM('PENDING', 'DELIVERING', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING' COMMENT '状态：待发货、配送中、已送达、已取消',
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP() COMMENT '下单时间',
                        delivered_at DATETIME NULL COMMENT '实际送达时间',
                        FOREIGN KEY (user_id) REFERENCES users(user_id),
                        FOREIGN KEY (store_id) REFERENCES stores(store_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='送货上门订单表';

-- 4.3 订单明细表 (Order Items)
CREATE TABLE order_items (
                             item_id INT AUTO_INCREMENT PRIMARY KEY,
                             order_id INT NOT NULL COMMENT '所属订单',
                             product_id INT NOT NULL COMMENT '购买的具体临期批次商品ID',
                             quantity INT NOT NULL DEFAULT 1 COMMENT '购买数量',
                             points_price INT NOT NULL COMMENT '购买时系统动态计算出的单件实际扣除积分',
                             FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
                             FOREIGN KEY (product_id) REFERENCES expiring_products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单商品明细表';

INSERT INTO stores (store_id, store_name, city, address, created_at) VALUES
                                                                         (1, 'Store A', 'Beijing', '1 Chaoyang Road', '2026-01-01 08:00:00'),
                                                                         (2, 'Store B', 'Beijing', '2 Zhongguancun Street', '2026-01-01 08:00:00');

-- 导入用户数据
INSERT INTO users (user_id, username, password_hash, role, store_id, points, phone_number, default_address, created_at) VALUES
                                                                                                                            (1, 'admin', 'hash_123', 'ADMIN', NULL, 0, NULL, NULL, '2026-01-01 09:00:00'),
                                                                                                                            (2, 'emp_a', 'hash_123', 'EMPLOYEE', 1, 0, NULL, NULL, '2026-03-01 10:00:00'),
                                                                                                                            (3, 'emp_b', 'hash_123', 'EMPLOYEE', 2, 0, NULL, NULL, '2026-03-01 10:00:00'),
                                                                                                                            (4, 'alice', 'hash_123', 'CONSUMER', NULL, 5000, '555-0101', '100 Chaoyang Park', '2026-03-20 10:00:00'),
                                                                                                                            (5, 'bob', 'hash_123', 'CONSUMER', NULL, 3000, '555-0202', '200 Haidian Lane', '2026-03-21 11:00:00');

-- 导入标准商品数据
INSERT INTO standard_products (barcode, product_name, normal_price) VALUES
                                                                        ('1111', 'Chicken Bento', 10.00),
                                                                        ('2222', 'Tuna Onigiri', 3.00),
                                                                        ('3333', 'Fresh Milk', 4.00);

-- 导入降价规则数据
INSERT INTO pricing_rules (rule_id, barcode, hours_to_expiration, discount_rate, updated_at) VALUES
                                                                                                 (1, '1111', 12, 0.80, '2026-03-01 10:00:00'),
                                                                                                 (2, '1111', 4, 0.50, '2026-03-01 10:00:00'),
                                                                                                 (3, '2222', 6, 0.70, '2026-03-01 10:00:00'),
                                                                                                 (4, '3333', 24, 0.60, '2026-03-01 10:00:00');

-- 导入临期商品库存数据
INSERT INTO expiring_products (product_id, barcode, store_id, expiration_time, remaining_stock, status, created_by, created_at) VALUES
                                                                                                                                    (1, '1111', 1, '2026-03-25 08:00:00', 3, 'AVAILABLE', 2, '2026-03-24 10:00:00'),
                                                                                                                                    (2, '2222', 1, '2026-03-25 02:00:00', 5, 'AVAILABLE', 2, '2026-03-24 10:30:00'),
                                                                                                                                    (3, '3333', 2, '2026-03-24 23:59:00', 2, 'AVAILABLE', 3, '2026-03-24 11:00:00'),
                                                                                                                                    (4, '1111', 2, '2026-03-24 23:00:00', 1, 'AVAILABLE', 3, '2026-03-24 11:30:00');

-- 导入购物车数据
INSERT INTO shopping_cart (cart_item_id, user_id, product_id, quantity, added_at) VALUES
    (1, 4, 4, 1, '2026-03-24 20:00:00');

-- 导入订单数据
INSERT INTO orders (order_id, user_id, store_id, total_points_spent, delivery_address, contact_phone, status, created_at, delivered_at) VALUES
    (1, 5, 1, 210, '200 Haidian Lane', '555-0202', 'DELIVERING', '2026-03-24 21:00:00', NULL);

-- 导入订单明细数据
INSERT INTO order_items (item_id, order_id, product_id, quantity, points_price) VALUES
    (1, 1, 2, 1, 210);