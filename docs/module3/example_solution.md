# Модуль 3. Создание запроса 

## 1. Подготовка тестовых данных (наполнение БД для расчёта стоимости заказа)

Чтобы запрос расчёта полной стоимости заказа работал, необходимо заполнить:

1. номенклатуру продукции и материалов (`app.item`);
2. спецификации продукции (`app.specification`);
3. материалы в спецификациях (`app.specification_material`);
4. цены на материалы (`app.price`);
5. заказ покупателя (`app.customer_order`) и строки заказа (`app.customer_order_line`).

---

## 2. Наполнение таблицы `app.item` (продукция и материалы)

### 2.1. Добавьте материалы

```sql
INSERT INTO app.item (id, code, name, item_type, unit_default)
VALUES
(1001, 'MAT-001', 'Молоко 3.2%', 'material', 'л'),
(1002, 'MAT-002', 'Сахар',      'material', 'кг'),
(1003, 'MAT-003', 'Какао',      'material', 'кг');
```

### 2.2. Добавьте продукцию

```sql
INSERT INTO app.item (id, code, name, item_type, unit_default)
VALUES
(2001, 'PRD-001', 'Йогурт клубничный', 'product', 'шт'),
(2002, 'PRD-002', 'Какао напиток',     'product', 'шт');
```

---

## 3. Наполнение таблицы `app.specification` (спецификации продукции)

В примере используется `output_qty = 1`, чтобы нормы расхода считались максимально просто (на 1 единицу продукции).

```sql
INSERT INTO app.specification (id, name, product_item_id, output_qty, output_unit, manufacturer_id)
VALUES
(1, 'Спецификация: Йогурт клубничный', 2001, 1, 'шт', NULL),
(2, 'Спецификация: Какао напиток',     2002, 1, 'шт', NULL);
```

---

## 4. Наполнение таблицы `app.specification_material` (нормы расхода материалов)

### 4.1. Материалы для йогурта (product_item_id = 2001)

* Молоко: 0.25 л на 1 шт
* Сахар: 0.03 кг на 1 шт

```sql
INSERT INTO app.specification_material (id, specification_id, material_item_id, qty, unit)
VALUES
(1, 1, 1001, 0.25, 'л'),
(2, 1, 1002, 0.03, 'кг');
```

### 4.2. Материалы для какао-напитка (product_item_id = 2002)

* Молоко: 0.30 л на 1 шт
* Сахар: 0.02 кг на 1 шт
* Какао: 0.01 кг на 1 шт

```sql
INSERT INTO app.specification_material (id, specification_id, material_item_id, qty, unit)
VALUES
(3, 2, 1001, 0.30, 'л'),
(4, 2, 1002, 0.02, 'кг'),
(5, 2, 1003, 0.01, 'кг');
```

---

## 5. Наполнение таблицы `app.price` (цены на материалы)

```sql
INSERT INTO app.price (id, item_id, price, effective_from, effective_to)
VALUES
(1, 1001, 80.00,  '2025-01-01', NULL),  -- молоко 80 руб/л
(2, 1002, 65.00,  '2025-01-01', NULL),  -- сахар 65 руб/кг
(3, 1003, 500.00, '2025-01-01', NULL);  -- какао 500 руб/кг
```

---

## 6. Наполнение таблицы `app.customer_order` (шапка заказа)

Создадим один заказ с `id = 1`.

```sql
INSERT INTO app.customer_order (id, doc_no, doc_date, executor_id, customer_id, total_amount)
VALUES
(1, 'ORD-2025-001', '2025-03-15', '000000002', '000000003', 0.00);
```

> `total_amount` пока оставляем `0.00`, так как итог будем вычислять запросом.

---

## 7. Наполнение таблицы `app.customer_order_line` (строки заказа)

В заказ добавим:

* Йогурт — 10 шт
* Какао напиток — 5 шт

```sql
INSERT INTO app.customer_order_line (id, customer_order_id, product_item_id, qty, unit, unit_price, line_amount)
VALUES
(1, 1, 2001, 10, 'шт', NULL, NULL),
(2, 1, 2002,  5, 'шт', NULL, NULL);
```

---

## 8. Проверка наличия данных перед расчётом

```sql
SELECT *
FROM app.customer_order_line
WHERE customer_order_id = 1;
```

---

## 9. Выполнение расчёта (ваш запрос)

Выполните запрос, заменив значение в `сol.customer_order_id` на требуемое:

```sql
WITH material_cost_per_unit AS (
    SELECT
        s.product_item_id,
        SUM(
            (sm.qty / NULLIF(s.output_qty, 0)) * p.price
        ) AS cost_per_unit
    FROM app.specification s
    JOIN app.specification_material sm
        ON sm.specification_id = s.id
    JOIN app.price p
        ON p.item_id = sm.material_item_id
    GROUP BY s.product_item_id
)
SELECT
    col.customer_order_id           AS order_id,
    SUM(col.qty)                    AS total_product_qty,
    SUM(col.qty * m.cost_per_unit)  AS total_order_cost
FROM app.customer_order_line col
JOIN material_cost_per_unit m
    ON m.product_item_id = col.product_item_id
WHERE col.customer_order_id = 1
GROUP BY col.customer_order_id;
```

---

## 10. Расчёт полной стоимости заказа **одним SQL-запросом (`SELECT`)**

В данном варианте расчёт выполняется **одним оператором `SELECT`**, без использования `WITH` (CTE).
Вся логика вычисления встроена во вложенный подзапрос в секции `FROM`.

---

### 10.1. SQL-запрос (один `SELECT`)

```sql
SELECT
    col.customer_order_id           AS order_id,
    SUM(col.qty)                    AS total_product_qty,
    SUM(
        col.qty *
        (
            SELECT
                SUM((sm.qty / NULLIF(s.output_qty, 0)) * p.price)
            FROM app.specification s
            JOIN app.specification_material sm
                ON sm.specification_id = s.id
            JOIN app.price p
                ON p.item_id = sm.material_item_id
            WHERE s.product_item_id = col.product_item_id
        )
    ) AS total_order_cost
FROM app.customer_order_line col
WHERE col.customer_order_id = 1   -- ← идентификатор заказа
GROUP BY col.customer_order_id;
```

---

### 10.2. Логика работы запроса

1. Основной запрос выбирает строки заказа из таблицы `customer_order_line`.
2. Для каждой строки заказа:

   * во вложенном подзапросе вычисляется **стоимость материалов на 1 единицу продукции**;
   * учитываются нормы расхода (`specification_material.qty`);
   * учитываются цены материалов (`price.price`).
3. Стоимость одной единицы продукции умножается на:

   * количество продукции в строке заказа (`col.qty`).
4. Итоговая стоимость заказа вычисляется как:

   * сумма по всем строкам заказа.

---

### 10.3. Как использовать запрос

1. Откройте **pgAdmin → Query Tool**.
2. Вставьте запрос из пункта **10.1**.
3. Замените значение в условии:

```sql
WHERE col.customer_order_id = 1
```

на нужный идентификатор заказа.
4. Выполните запрос (**Execute**).

---

### 10.4. Преимущества данного варианта

* используется **ровно один `SELECT`**;
* отсутствуют `WITH`, временные таблицы и переменные;
* подходит для учебных работ и демонстрации принципа расчёта;
* логика полностью читается в одном запросе.

 Ниже — исправленный блок **«Ожидаемая логика результата»** с учётом ваших фактических данных на скриншотах:

* `customer_order` содержит **3 заказа** (id: 1, 2, 3);
* `customer_order_line` содержит строки:

  * заказ **1**: продукт `2001` qty `10`, продукт `2002` qty `5`
  * заказ **2**: продукт `2001` qty `3`,  продукт `2002` qty `2`
  * заказ **3**: продукт `2001` qty `7`,  продукт `2002` qty `1`

---

## 11. Ожидаемая логика результата (контроль вручную)

Для контроля расчёта сначала определим **стоимость материалов на 1 единицу продукции**, затем посчитаем **итог по каждому заказу**.

---

### 11.1. Стоимость материалов на 1 единицу продукции

#### Продукт **Йогурт (product_item_id = 2001)**

* молоко: `0.25 × 80.00 = 20.00`
* сахар: `0.03 × 65.00 = 1.95`

**Итого на 1 шт:**
`20.00 + 1.95 = 21.95`

---

#### Продукт **Какао напиток (product_item_id = 2002)**

* молоко: `0.30 × 80.00 = 24.00`
* сахар: `0.02 × 65.00 = 1.30`
* какао:  `0.01 × 500.00 = 5.00`

**Итого на 1 шт:**
`24.00 + 1.30 + 5.00 = 30.30`

---

### 11.2. Итоговая стоимость заказа №1 (order_id = 1)

По таблице `customer_order_line`:

* `2001` (йогурт) — `qty = 10`
* `2002` (какао) — `qty = 5`

Расчёт:

* йогурт: `21.95 × 10 = 219.50`
* какао:  `30.30 × 5  = 151.50`

**Итого по заказу №1:**
`219.50 + 151.50 = 371.00`

---

### 11.3. Итоговая стоимость заказа №2 (order_id = 2)

По таблице `customer_order_line`:

* `2001` — `qty = 3`
* `2002` — `qty = 2`

Расчёт:

* йогурт: `21.95 × 3 = 65.85`
* какао:  `30.30 × 2 = 60.60`

**Итого по заказу №2:**
`65.85 + 60.60 = 126.45`

---

### 11.4. Итоговая стоимость заказа №3 (order_id = 3)

По таблице `customer_order_line`:

* `2001` — `qty = 7`
* `2002` — `qty = 1`

Расчёт:

* йогурт: `21.95 × 7 = 153.65`
* какао:  `30.30 × 1 = 30.30`

**Итого по заказу №3:**
`153.65 + 30.30 = 183.95`

---

### 11.5. Сводная таблица ожидаемых итогов

* Заказ **1** → **371.00**
* Заказ **2** → **126.45**
* Заказ **3** → **183.95**

 