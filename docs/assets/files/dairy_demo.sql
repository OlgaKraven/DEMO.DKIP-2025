-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Фев 12 2026 г., 02:45
-- Версия сервера: 10.4.32-MariaDB
-- Версия PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `dairy_demo`
--

-- --------------------------------------------------------

--
-- Структура таблицы `cost_calculation`
--

CREATE TABLE `cost_calculation` (
  `id` bigint(20) NOT NULL,
  `calc_date` date DEFAULT NULL,
  `product_item_id` bigint(20) NOT NULL,
  `product_qty` decimal(12,3) NOT NULL DEFAULT 1.000,
  `total_cost` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `cost_calculation`
--

INSERT INTO `cost_calculation` (`id`, `calc_date`, `product_item_id`, `product_qty`, `total_cost`) VALUES
(1, '2026-02-01', 1, 1.000, 62.00),
(2, '2026-02-01', 2, 1.000, 68.00),
(3, '2026-02-02', 3, 1.000, 28.00),
(4, '2026-02-02', 4, 1.000, 95.00),
(5, '2026-02-03', 5, 1.000, 88.00),
(6, '2026-02-03', 1, 1.000, 60.00),
(7, '2026-02-04', 2, 1.000, 70.00),
(8, '2026-02-04', 3, 1.000, 30.00),
(9, '2026-02-05', 4, 1.000, 92.00),
(10, '2026-02-05', 5, 1.000, 90.00);

-- --------------------------------------------------------

--
-- Структура таблицы `cost_calculation_line`
--

CREATE TABLE `cost_calculation_line` (
  `id` bigint(20) NOT NULL,
  `cost_calculation_id` bigint(20) NOT NULL,
  `material_item_id` bigint(20) NOT NULL,
  `qty` decimal(12,3) NOT NULL,
  `unit` varchar(32) DEFAULT NULL,
  `unit_cost` decimal(12,2) DEFAULT NULL,
  `line_cost` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `cost_calculation_line`
--

INSERT INTO `cost_calculation_line` (`id`, `cost_calculation_id`, `material_item_id`, `qty`, `unit`, `unit_cost`, `line_cost`) VALUES
(1, 1, 6, 1.050, 'л', 45.00, 47.25),
(2, 2, 6, 1.050, 'л', 45.00, 47.25),
(3, 2, 7, 2.000, 'г', 0.80, 1.60),
(4, 3, 6, 0.180, 'л', 45.00, 8.10),
(5, 3, 8, 1.500, 'г', 0.90, 1.35),
(6, 3, 10, 1.000, 'шт', 2.50, 2.50),
(7, 4, 6, 0.300, 'л', 45.00, 13.50),
(8, 4, 9, 2.000, 'г', 0.10, 0.20),
(9, 5, 6, 0.250, 'л', 45.00, 11.25),
(10, 5, 9, 1.000, 'г', 0.10, 0.10);

-- --------------------------------------------------------

--
-- Структура таблицы `counterparty`
--

CREATE TABLE `counterparty` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `inn` int(32) NOT NULL,
  `address` int(255) NOT NULL,
  `phone` int(64) NOT NULL,
  `is_salesman` tinyint(1) NOT NULL,
  `is_buyer` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `counterparty`
--

INSERT INTO `counterparty` (`id`, `name`, `inn`, `address`, `phone`, `is_salesman`, `is_buyer`) VALUES
(1, 'ООО \"Поставка\"', 0, 0, 2147483647, 1, 1),
(2, 'ООО \"Кинотеатр Квант\"', 2147483647, 0, 2147483647, 1, 0),
(3, 'ООО \"Ромашка\"', 2147483647, 0, 2147483647, 0, 1),
(8, 'ООО \"Новый JDTO\"', 2147483647, 0, 2147483647, 1, 0),
(9, 'name', 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `counterparty_import`
--

CREATE TABLE `counterparty_import` (
  `id` bigint(20) NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`payload`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer_order`
--

CREATE TABLE `customer_order` (
  `id` bigint(20) NOT NULL,
  `doc_no` varchar(64) NOT NULL,
  `doc_date` date DEFAULT NULL,
  `executor_id` bigint(20) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `total_amount` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `customer_order`
--

INSERT INTO `customer_order` (`id`, `doc_no`, `doc_date`, `executor_id`, `customer_id`, `total_amount`) VALUES
(41, 'CO-2026-0001', '2026-02-01', 1, 1, 49950.00),
(42, 'CO-2026-0002', '2026-02-01', 1, 2, 32970.00),
(43, 'CO-2026-0003', '2026-02-02', 2, 3, 47920.00),
(44, 'CO-2026-0004', '2026-02-02', 2, 1, 41967.90),
(45, 'CO-2026-0005', '2026-02-03', 3, 2, 56916.50),
(46, 'CO-2026-0006', '2026-02-03', 3, 3, 29013.60),
(47, 'CO-2026-0007', '2026-02-04', 1, 1, 36018.80),
(48, 'CO-2026-0008', '2026-02-04', 2, 2, 23960.00),
(49, 'CO-2026-0009', '2026-02-05', 3, 3, 37980.00),
(50, 'CO-2026-0010', '2026-02-05', 1, 1, 26973.00);

-- --------------------------------------------------------

--
-- Структура таблицы `customer_order_line`
--

CREATE TABLE `customer_order_line` (
  `id` bigint(20) NOT NULL,
  `customer_order_id` bigint(20) NOT NULL,
  `product_item_id` bigint(20) NOT NULL,
  `qty` decimal(12,3) NOT NULL,
  `unit` varchar(32) DEFAULT NULL,
  `unit_price` decimal(12,2) DEFAULT NULL,
  `line_amount` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `customer_order_line`
--

INSERT INTO `customer_order_line` (`id`, `customer_order_id`, `product_item_id`, `qty`, `unit`, `unit_price`, `line_amount`) VALUES
(21, 41, 1, 500.000, 'л', 99.90, 49950.00),
(22, 42, 2, 300.000, 'л', 109.90, 32970.00),
(23, 43, 3, 800.000, 'шт', 59.90, 47920.00),
(24, 44, 4, 221.000, 'шт', 189.90, 41967.90),
(25, 45, 5, 335.000, 'шт', 169.90, 56916.50),
(26, 46, 2, 264.000, 'л', 109.90, 29013.60),
(27, 47, 5, 212.000, 'шт', 169.90, 36018.80),
(28, 48, 3, 400.000, 'шт', 59.90, 23960.00),
(29, 49, 4, 200.000, 'шт', 189.90, 37980.00),
(30, 50, 1, 270.000, 'л', 99.90, 26973.00);

-- --------------------------------------------------------

--
-- Структура таблицы `item`
--

CREATE TABLE `item` (
  `id` bigint(20) NOT NULL,
  `code` varchar(64) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `item_type` enum('product','material') NOT NULL,
  `unit_default` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `item`
--

INSERT INTO `item` (`id`, `code`, `name`, `item_type`, `unit_default`) VALUES
(1, 'PRD-MLK-1L', 'Молоко 1 л', 'product', 'л'),
(2, 'PRD-KEF-1L', 'Кефир 1 л', 'product', 'л'),
(3, 'PRD-YOG-150', 'Йогурт 150 г', 'product', 'шт'),
(4, 'PRD-CHS-200', 'Сыр 200 г', 'product', 'шт'),
(5, 'PRD-BTR-180', 'Масло сливочное 180 г', 'product', 'шт'),
(6, 'MAT-RAW-MLK', 'Молоко-сырьё', 'material', 'л'),
(7, 'MAT-FERM-KEF', 'Закваска кефирная', 'material', 'г'),
(8, 'MAT-FERM-YOG', 'Закваска йогуртная', 'material', 'г'),
(9, 'MAT-SALT', 'Соль пищевая', 'material', 'г'),
(10, 'MAT-PACK-150', 'Упаковка 150 г', 'material', 'шт');

-- --------------------------------------------------------

--
-- Структура таблицы `price`
--

CREATE TABLE `price` (
  `id` bigint(20) NOT NULL,
  `item_id` bigint(20) NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `effective_from` date DEFAULT NULL,
  `effective_to` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `price`
--

INSERT INTO `price` (`id`, `item_id`, `price`, `effective_from`, `effective_to`) VALUES
(1, 1, 99.90, '2026-01-01', NULL),
(2, 2, 109.90, '2026-01-01', NULL),
(3, 3, 59.90, '2026-01-01', NULL),
(4, 4, 189.90, '2026-01-01', NULL),
(5, 5, 169.90, '2026-01-01', NULL),
(6, 6, 45.00, '2026-01-01', NULL),
(7, 7, 0.80, '2026-01-01', NULL),
(8, 8, 0.90, '2026-01-01', NULL),
(9, 9, 0.10, '2026-01-01', NULL),
(10, 10, 2.50, '2026-01-01', NULL),
(11, 1, 99.90, '2026-01-01', NULL),
(12, 2, 109.90, '2026-01-01', NULL),
(13, 3, 59.90, '2026-01-01', NULL),
(14, 4, 189.90, '2026-01-01', NULL),
(15, 5, 169.90, '2026-01-01', NULL),
(16, 6, 45.00, '2026-01-01', NULL),
(17, 7, 0.80, '2026-01-01', NULL),
(18, 8, 0.90, '2026-01-01', NULL),
(19, 9, 0.10, '2026-01-01', NULL),
(20, 10, 2.50, '2026-01-01', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `production_material_line`
--

CREATE TABLE `production_material_line` (
  `id` bigint(20) NOT NULL,
  `production_order_id` bigint(20) NOT NULL,
  `material_item_id` bigint(20) NOT NULL,
  `qty` decimal(12,3) NOT NULL,
  `unit` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `production_material_line`
--

INSERT INTO `production_material_line` (`id`, `production_order_id`, `material_item_id`, `qty`, `unit`) VALUES
(1, 1, 6, 525.000, 'л'),
(2, 2, 6, 472.500, 'л'),
(3, 3, 6, 315.000, 'л'),
(4, 3, 7, 600.000, 'г'),
(5, 4, 6, 144.000, 'л'),
(6, 4, 8, 1200.000, 'г'),
(7, 4, 10, 800.000, 'шт'),
(8, 5, 6, 180.000, 'л'),
(9, 5, 9, 1200.000, 'г'),
(10, 6, 6, 137.500, 'л');

-- --------------------------------------------------------

--
-- Структура таблицы `production_order`
--

CREATE TABLE `production_order` (
  `id` bigint(20) NOT NULL,
  `doc_no` varchar(64) NOT NULL,
  `doc_date` date DEFAULT NULL,
  `manufacturer_id` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `production_order`
--

INSERT INTO `production_order` (`id`, `doc_no`, `doc_date`, `manufacturer_id`, `note`) VALUES
(1, 'PO-2026-0001', '2026-02-01', 1, 'Смена 1'),
(2, 'PO-2026-0002', '2026-02-01', 1, 'Смена 2'),
(3, 'PO-2026-0003', '2026-02-02', 2, 'Партия кефира'),
(4, 'PO-2026-0004', '2026-02-02', 2, 'Партия йогурта'),
(5, 'PO-2026-0005', '2026-02-03', 3, 'Партия сыра'),
(6, 'PO-2026-0006', '2026-02-03', 3, 'Партия масла'),
(7, 'PO-2026-0007', '2026-02-04', 1, 'Доп. выпуск'),
(8, 'PO-2026-0008', '2026-02-04', 2, 'Эксперимент'),
(9, 'PO-2026-0009', '2026-02-05', 3, 'Срочный заказ'),
(10, 'PO-2026-0010', '2026-02-05', 1, 'Плановый выпуск');

-- --------------------------------------------------------

--
-- Структура таблицы `production_product_line`
--

CREATE TABLE `production_product_line` (
  `id` bigint(20) NOT NULL,
  `production_order_id` bigint(20) NOT NULL,
  `product_item_id` bigint(20) NOT NULL,
  `qty` decimal(12,3) NOT NULL,
  `unit` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `production_product_line`
--

INSERT INTO `production_product_line` (`id`, `production_order_id`, `product_item_id`, `qty`, `unit`) VALUES
(1, 1, 1, 500.000, 'л'),
(2, 2, 1, 450.000, 'л'),
(3, 3, 2, 300.000, 'л'),
(4, 4, 3, 800.000, 'шт'),
(5, 5, 4, 600.000, 'шт'),
(6, 6, 5, 550.000, 'шт'),
(7, 7, 2, 250.000, 'л'),
(8, 8, 3, 700.000, 'шт'),
(9, 9, 4, 500.000, 'шт'),
(10, 10, 5, 450.000, 'шт');

-- --------------------------------------------------------

--
-- Структура таблицы `specification`
--

CREATE TABLE `specification` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `product_item_id` bigint(20) NOT NULL,
  `output_qty` decimal(12,3) NOT NULL DEFAULT 1.000,
  `output_unit` varchar(32) DEFAULT NULL,
  `manufacturer_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `specification`
--

INSERT INTO `specification` (`id`, `name`, `product_item_id`, `output_qty`, `output_unit`, `manufacturer_id`) VALUES
(1, 'Рецептура: Молоко 1 л (пастеризация)', 1, 1.000, 'л', 1),
(2, 'Рецептура: Кефир 1 л (брожение)', 2, 1.000, 'л', 1),
(3, 'Рецептура: Йогурт 150 г (ферментация)', 3, 1.000, 'шт', 2),
(4, 'Рецептура: Сыр 200 г (созревание)', 4, 1.000, 'шт', 2),
(5, 'Рецептура: Масло 180 г (взбивание)', 5, 1.000, 'шт', 3),
(6, 'Рецептура: Молоко 1 л (ультрапастер.)', 1, 1.000, 'л', 3),
(7, 'Рецептура: Кефир 1 л (другая закваска)', 2, 1.000, 'л', 2),
(8, 'Рецептура: Йогурт 150 г (плотный)', 3, 1.000, 'шт', 1),
(9, 'Рецептура: Сыр 200 г (соль усил.)', 4, 1.000, 'шт', 3),
(10, 'Рецептура: Масло 180 г (солёное)', 5, 1.000, 'шт', 1),
(11, 'Рецептура: Молоко 1 л (пастеризация)', 1, 1.000, 'л', 1),
(12, 'Рецептура: Кефир 1 л (брожение)', 2, 1.000, 'л', 1),
(13, 'Рецептура: Йогурт 150 г (ферментация)', 3, 1.000, 'шт', 2),
(14, 'Рецептура: Сыр 200 г (созревание)', 4, 1.000, 'шт', 2),
(15, 'Рецептура: Масло 180 г (взбивание)', 5, 1.000, 'шт', 3),
(16, 'Рецептура: Молоко 1 л (ультрапастер.)', 1, 1.000, 'л', 3),
(17, 'Рецептура: Кефир 1 л (другая закваска)', 2, 1.000, 'л', 2),
(18, 'Рецептура: Йогурт 150 г (плотный)', 3, 1.000, 'шт', 1),
(19, 'Рецептура: Сыр 200 г (соль усил.)', 4, 1.000, 'шт', 3),
(20, 'Рецептура: Масло 180 г (солёное)', 5, 1.000, 'шт', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `specification_material`
--

CREATE TABLE `specification_material` (
  `id` bigint(20) NOT NULL,
  `specification_id` bigint(20) NOT NULL,
  `material_item_id` bigint(20) NOT NULL,
  `qty` decimal(12,3) NOT NULL,
  `unit` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `specification_material`
--

INSERT INTO `specification_material` (`id`, `specification_id`, `material_item_id`, `qty`, `unit`) VALUES
(1, 1, 6, 1.050, 'л'),
(2, 2, 6, 1.050, 'л'),
(3, 2, 7, 2.000, 'г'),
(4, 3, 6, 0.180, 'л'),
(5, 3, 8, 1.500, 'г'),
(6, 3, 10, 1.000, 'шт'),
(7, 4, 6, 0.300, 'л'),
(8, 4, 9, 2.000, 'г'),
(9, 5, 6, 0.250, 'л'),
(10, 5, 9, 1.000, 'г');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `cost_calculation`
--
ALTER TABLE `cost_calculation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_costcalc_product` (`product_item_id`);

--
-- Индексы таблицы `cost_calculation_line`
--
ALTER TABLE `cost_calculation_line`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_costline_calc` (`cost_calculation_id`),
  ADD KEY `idx_costline_item` (`material_item_id`);

--
-- Индексы таблицы `counterparty`
--
ALTER TABLE `counterparty`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `counterparty_import`
--
ALTER TABLE `counterparty_import`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `customer_order`
--
ALTER TABLE `customer_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_custorder_executor` (`executor_id`),
  ADD KEY `idx_custorder_customer` (`customer_id`);

--
-- Индексы таблицы `customer_order_line`
--
ALTER TABLE `customer_order_line`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_custline_order` (`customer_order_id`),
  ADD KEY `idx_custline_item` (`product_item_id`);

--
-- Индексы таблицы `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Индексы таблицы `price`
--
ALTER TABLE `price`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_price_item` (`item_id`);

--
-- Индексы таблицы `production_material_line`
--
ALTER TABLE `production_material_line`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_prodmat_order` (`production_order_id`),
  ADD KEY `idx_prodmat_item` (`material_item_id`);

--
-- Индексы таблицы `production_order`
--
ALTER TABLE `production_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_prodorder_manufacturer` (`manufacturer_id`);

--
-- Индексы таблицы `production_product_line`
--
ALTER TABLE `production_product_line`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_prodprod_order` (`production_order_id`),
  ADD KEY `idx_prodprod_item` (`product_item_id`);

--
-- Индексы таблицы `specification`
--
ALTER TABLE `specification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_spec_product` (`product_item_id`),
  ADD KEY `idx_spec_manufacturer` (`manufacturer_id`);

--
-- Индексы таблицы `specification_material`
--
ALTER TABLE `specification_material`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_spec_material` (`specification_id`,`material_item_id`),
  ADD KEY `idx_specmat_material` (`material_item_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `cost_calculation`
--
ALTER TABLE `cost_calculation`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `cost_calculation_line`
--
ALTER TABLE `cost_calculation_line`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `counterparty`
--
ALTER TABLE `counterparty`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `counterparty_import`
--
ALTER TABLE `counterparty_import`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer_order`
--
ALTER TABLE `customer_order`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT для таблицы `customer_order_line`
--
ALTER TABLE `customer_order_line`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT для таблицы `item`
--
ALTER TABLE `item`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT для таблицы `price`
--
ALTER TABLE `price`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT для таблицы `production_material_line`
--
ALTER TABLE `production_material_line`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `production_order`
--
ALTER TABLE `production_order`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `production_product_line`
--
ALTER TABLE `production_product_line`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `specification`
--
ALTER TABLE `specification`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT для таблицы `specification_material`
--
ALTER TABLE `specification_material`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `cost_calculation`
--
ALTER TABLE `cost_calculation`
  ADD CONSTRAINT `fk_costcalc_product` FOREIGN KEY (`product_item_id`) REFERENCES `item` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `cost_calculation_line`
--
ALTER TABLE `cost_calculation_line`
  ADD CONSTRAINT `fk_costline_calc` FOREIGN KEY (`cost_calculation_id`) REFERENCES `cost_calculation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_costline_item` FOREIGN KEY (`material_item_id`) REFERENCES `item` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `customer_order`
--
ALTER TABLE `customer_order`
  ADD CONSTRAINT `fk_custorder_customer` FOREIGN KEY (`customer_id`) REFERENCES `counterparty` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_custorder_executor` FOREIGN KEY (`executor_id`) REFERENCES `counterparty` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `customer_order_line`
--
ALTER TABLE `customer_order_line`
  ADD CONSTRAINT `fk_custline_item` FOREIGN KEY (`product_item_id`) REFERENCES `item` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_custline_order` FOREIGN KEY (`customer_order_id`) REFERENCES `customer_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `price`
--
ALTER TABLE `price`
  ADD CONSTRAINT `fk_price_item` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `production_material_line`
--
ALTER TABLE `production_material_line`
  ADD CONSTRAINT `fk_prodmat_item` FOREIGN KEY (`material_item_id`) REFERENCES `item` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prodmat_order` FOREIGN KEY (`production_order_id`) REFERENCES `production_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `production_order`
--
ALTER TABLE `production_order`
  ADD CONSTRAINT `fk_prodorder_manufacturer` FOREIGN KEY (`manufacturer_id`) REFERENCES `counterparty` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `production_product_line`
--
ALTER TABLE `production_product_line`
  ADD CONSTRAINT `fk_prodprod_item` FOREIGN KEY (`product_item_id`) REFERENCES `item` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prodprod_order` FOREIGN KEY (`production_order_id`) REFERENCES `production_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `specification`
--
ALTER TABLE `specification`
  ADD CONSTRAINT `fk_spec_manufacturer` FOREIGN KEY (`manufacturer_id`) REFERENCES `counterparty` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_spec_product` FOREIGN KEY (`product_item_id`) REFERENCES `item` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `specification_material`
--
ALTER TABLE `specification_material`
  ADD CONSTRAINT `fk_specmat_material` FOREIGN KEY (`material_item_id`) REFERENCES `item` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_specmat_spec` FOREIGN KEY (`specification_id`) REFERENCES `specification` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
