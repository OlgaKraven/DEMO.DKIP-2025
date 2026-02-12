# Модуль 3. Создание запроса (MySQL через phpMyAdmin)

## 1. Подготовка тестовых данных (наполнение БД для расчёта стоимости заказа)

Чтобы запрос расчёта полной стоимости заказа работал, необходимо заполнить:

1. номенклатуру продукции и материалов (`item`);
2. спецификации продукции (`specification`);
3. материалы в спецификациях (`specification_material`);
4. цены на материалы (`price`);
5. заказ покупателя (`customer_order`) и строки заказа (`customer_order_line`).

---

## 2. Наполнение таблицы `item` (продукция и материалы)

⚠️ В таблице `item.id` используется **AUTO_INCREMENT**, поэтому `id` вручную **не заполняем** (оставляем пустым).

### Вариант A — через конструктор (phpMyAdmin)

1. В phpMyAdmin выберите БД `dairy_demo`.
2. Откройте таблицу **`item`**.
3. Перейдите на вкладку **Insert**.
4. Для каждой записи заполните поля:

   * `code`
   * `name`
   * `item_type` (выберите `material` или `product`)
   * `unit_default`
   * поле `id` **не трогайте** (пусто / NULL) — его заполнит MySQL.
5. Нажмите **Go** (или добавьте несколько строк и нажмите **Go** один раз).

**Материалы (3 строки):**

* `MAT-001` / `Молоко 3.2%` / `material` / `л`
* `MAT-002` / `Сахар` / `material` / `кг`
* `MAT-003` / `Какао` / `material` / `кг`

**Продукция (2 строки):**

* `PRD-001` / `Йогурт клубничный` / `product` / `шт`
* `PRD-002` / `Какао напиток` / `product` / `шт`

### Вариант B — через SQL

```sql
INSERT INTO item (code, name, item_type, unit_default) VALUES
('MAT-001', 'Молоко 3.2%', 'material', 'л'),
('MAT-002', 'Сахар',      'material', 'кг'),
('MAT-003', 'Какао',      'material', 'кг'),
('PRD-001', 'Йогурт клубничный', 'product', 'шт'),
('PRD-002', 'Какао напиток',     'product', 'шт');
```

### 2.3. Узнайте реальные `id` у вставленных позиций (обязательно)

**Через конструктор:**

* вкладка **Browse** в таблице `item` → посмотрите `id` напротив кодов `MAT-*`, `PRD-*`.

**Через SQL:**

```sql
SELECT id, code, name, item_type
FROM item
WHERE code IN ('MAT-001','MAT-002','MAT-003','PRD-001','PRD-002')
ORDER BY id;
```

> Дальше в примерах предполагаем:
> `MAT-001`→1, `MAT-002`→2, `MAT-003`→3, `PRD-001`→4, `PRD-002`→5.
> Если у вас другие — подставьте свои `id`.

---

## 3. Наполнение таблицы `specification` (спецификации продукции)

⚠️ `specification.id` — AUTO_INCREMENT, `id` не заполняем.
⚠️ `product_item_id` должен ссылаться на **реальный id** продукта из `item`.

### Вариант A — через конструктор (phpMyAdmin)

1. Откройте таблицу **`specification`** → вкладка **Insert**.
2. Заполните поля:

   * `name`
   * `product_item_id` (введите id продукта `PRD-001`, `PRD-002`)
   * `output_qty` = `1.000`
   * `output_unit` = `шт`
   * `manufacturer_id` оставьте пустым (`NULL`)
   * `id` не заполняйте
3. Нажмите **Go**.

Пример значений:

* `Спецификация: Йогурт клубничный` / `product_item_id = 4` / `1.000` / `шт` / `NULL`
* `Спецификация: Какао напиток` / `product_item_id = 5` / `1.000` / `шт` / `NULL`

### Вариант B — через SQL

```sql
INSERT INTO specification (name, product_item_id, output_qty, output_unit, manufacturer_id) VALUES
('Спецификация: Йогурт клубничный', 4, 1.000, 'шт', NULL),
('Спецификация: Какао напиток',     5, 1.000, 'шт', NULL);
```

**Проверка id спецификаций:**

* GUI: `specification` → **Browse**
* SQL:

```sql
SELECT id, name, product_item_id
FROM specification
ORDER BY id;
```

> Предполагаем: spec для PRD-001 → id=1, для PRD-002 → id=2.

---

## 4. Наполнение таблицы `specification_material` (нормы расхода материалов)

⚠️ `specification_material.id` — AUTO_INCREMENT, `id` не заполняем.
⚠️ `specification_id` — это id из `specification`.
⚠️ `material_item_id` — это id материала из `item`.

### Вариант A — через конструктор (phpMyAdmin)

1. Откройте таблицу **`specification_material`** → вкладка **Insert**.
2. Для каждой строки заполните:

   * `specification_id` (например, 1 или 2)
   * `material_item_id` (например, 1/2/3)
   * `qty` (норма)
   * `unit` (`л` или `кг`)
   * `id` не заполняйте
3. Нажмите **Go**.

**Для йогурта (spec_id = 1):**

* (1, material 1, 0.25, `л`)
* (1, material 2, 0.03, `кг`)

**Для какао (spec_id = 2):**

* (2, material 1, 0.30, `л`)
* (2, material 2, 0.02, `кг`)
* (2, material 3, 0.01, `кг`)

### Вариант B — через SQL

```sql
INSERT INTO specification_material (specification_id, material_item_id, qty, unit) VALUES
(1, 1, 0.25, 'л'),
(1, 2, 0.03, 'кг'),
(2, 1, 0.30, 'л'),
(2, 2, 0.02, 'кг'),
(2, 3, 0.01, 'кг');
```

---

## 5. Наполнение таблицы `price` (цены на материалы)

⚠️ `price.id` — AUTO_INCREMENT, `id` не заполняем.
⚠️ `item_id` должен ссылаться на **материалы** (`MAT-*`).

### Вариант A — через конструктор (phpMyAdmin)

1. Откройте таблицу **`price`** → вкладка **Insert**.
2. Заполните:

   * `item_id` (id материалов 1/2/3)
   * `price`
   * `effective_from` = `2025-01-01`
   * `effective_to` оставьте пустым (NULL)
3. Нажмите **Go**.

Пример:

* (item_id=1, price=80.00)
* (item_id=2, price=65.00)
* (item_id=3, price=500.00)

### Вариант B — через SQL

```sql
INSERT INTO price (item_id, price, effective_from, effective_to) VALUES
(1,  80.00,  '2025-01-01', NULL),
(2,  65.00,  '2025-01-01', NULL),
(3, 500.00,  '2025-01-01', NULL);
```

---

## 6. Наполнение таблицы `customer_order` (шапка заказа)

⚠️ Здесь FK на `counterparty(id)` — значения `executor_id` и `customer_id` **обязаны существовать** в `counterparty`.

### 6.1. Убедитесь, что контрагенты есть

**Через конструктор:**

* `counterparty` → вкладка **Browse** → посмотрите какие `id` реально есть.

**Через SQL:**

```sql
SELECT id, name
FROM counterparty
ORDER BY id
LIMIT 20;
```

### 6.2. Создадим 3 заказа

⚠️ `customer_order.id` — AUTO_INCREMENT, `id` не заполняем.

#### Вариант A — через конструктор (phpMyAdmin)

1. Откройте таблицу **`customer_order`** → вкладка **Insert**.
2. Для каждого заказа заполните:

   * `doc_no`
   * `doc_date`
   * `executor_id` (существующий id контрагента)
   * `customer_id` (существующий id контрагента)
   * `total_amount` = `0.00`
   * `id` не заполняйте
3. Нажмите **Go**.

Пример (как у вас, но с существующими id клиентов):

* `ORD-2025-001` / `2025-03-15` / executor_id=1 / customer_id=1 / 0.00
* `ORD-2025-002` / `2025-03-16` / executor_id=1 / customer_id=2 / 0.00
* `ORD-2025-003` / `2025-03-17` / executor_id=1 / customer_id=3 / 0.00

#### Вариант B — через SQL

```sql
INSERT INTO customer_order (doc_no, doc_date, executor_id, customer_id, total_amount) VALUES
('ORD-2025-001', '2025-03-15', 1, 1, 0.00),
('ORD-2025-002', '2025-03-16', 1, 2, 0.00),
('ORD-2025-003', '2025-03-17', 1, 3, 0.00);
```

**Проверка id заказов:**

* GUI: `customer_order` → **Browse**
* SQL:

```sql
SELECT id, doc_no
FROM customer_order
ORDER BY id;
```

---

## 7. Наполнение таблицы `customer_order_line` (строки заказа)

⚠️ `customer_order_line.id` — AUTO_INCREMENT, `id` не заполняем.
⚠️ `customer_order_id` должен существовать в `customer_order`.
⚠️ `product_item_id` должен существовать в `item`.

### Вариант A — через конструктор (phpMyAdmin)

1. Откройте таблицу **`customer_order_line`** → вкладка **Insert**.
2. Заполните строки (6 записей):

   * `customer_order_id` (id заказа)
   * `product_item_id` (id продукта: PRD-001 и PRD-002)
   * `qty`
   * `unit` = `шт`
   * `unit_price` пусто (NULL)
   * `line_amount` пусто (NULL)
   * `id` не заполняйте
3. Нажмите **Go**.

Пример (если заказы id = 1..3, продукты id = 4..5):

* (1, 4, 10, 'шт', NULL, NULL)
* (1, 5,  5, 'шт', NULL, NULL)
* (2, 4,  3, 'шт', NULL, NULL)
* (2, 5,  2, 'шт', NULL, NULL)
* (3, 4,  7, 'шт', NULL, NULL)
* (3, 5,  1, 'шт', NULL, NULL)

### Вариант B — через SQL (универсальный, без угадывания id)

```sql
INSERT INTO customer_order_line
(customer_order_id, product_item_id, qty, unit, unit_price, line_amount)
SELECT co.id, i.id, x.qty, 'шт', NULL, NULL
FROM (
    SELECT 'ORD-2025-001' AS doc_no, 'PRD-001' AS code, 10 AS qty
    UNION ALL SELECT 'ORD-2025-001', 'PRD-002', 5
    UNION ALL SELECT 'ORD-2025-002', 'PRD-001', 3
    UNION ALL SELECT 'ORD-2025-002', 'PRD-002', 2
    UNION ALL SELECT 'ORD-2025-003', 'PRD-001', 7
    UNION ALL SELECT 'ORD-2025-003', 'PRD-002', 1
) x
JOIN customer_order co ON co.doc_no = x.doc_no
JOIN item i ON i.code = x.code;
```

---

## 8. Проверка наличия данных перед расчётом

**GUI:**

* `customer_order_line` → **Browse** → фильтр по `customer_order_id`.

**SQL:**

```sql
SELECT *
FROM customer_order_line
WHERE customer_order_id = 1;
```

---

## 9. Выполнение расчёта (вариант с `WITH`, MySQL 8+)

```sql
WITH material_cost_per_unit AS (
    SELECT
        s.product_item_id,
        SUM((sm.qty / NULLIF(s.output_qty, 0)) * p.price) AS cost_per_unit
    FROM specification s
    JOIN specification_material sm
        ON sm.specification_id = s.id
    JOIN price p
        ON p.item_id = sm.material_item_id
    GROUP BY s.product_item_id
)
SELECT
    col.customer_order_id           AS order_id,
    SUM(col.qty)                    AS total_product_qty,
    ROUND(SUM(col.qty * m.cost_per_unit), 2) AS total_order_cost
FROM customer_order_line col
JOIN material_cost_per_unit m
    ON m.product_item_id = col.product_item_id
WHERE col.customer_order_id = 1
GROUP BY col.customer_order_id;
```

---

## 10. Расчёт полной стоимости заказа одним `SELECT` (без `WITH`)

```sql
SELECT
    col.customer_order_id AS order_id,
    SUM(col.qty)          AS total_product_qty,
    ROUND(
      SUM(
        col.qty *
        (
            SELECT SUM((sm.qty / NULLIF(s.output_qty, 0)) * p.price)
            FROM specification s
            JOIN specification_material sm
                ON sm.specification_id = s.id
            JOIN price p
                ON p.item_id = sm.material_item_id
            WHERE s.product_item_id = col.product_item_id
        )
      ),
    2) AS total_order_cost
FROM customer_order_line col
WHERE col.customer_order_id = 1
GROUP BY col.customer_order_id;
```

---

## 10.3. Как использовать запрос в phpMyAdmin

1. Откройте **phpMyAdmin**.
2. Выберите базу данных `dairy_demo`.
3. Перейдите во вкладку **SQL**.
4. Вставьте запрос из пункта **9** или **10**.
5. Замените:

```sql
WHERE col.customer_order_id = 1
```

на нужный `id` заказа.
6. Нажмите **Go**.

---

## 11. Ожидаемая логика результата (контроль вручную)

### 11.1. Стоимость материалов на 1 единицу продукции

#### Продукт **Йогурт (product_item_id = PRD-001)**

* молоко: `0.25 × 80.00 = 20.00`
* сахар: `0.03 × 65.00 = 1.95`

Итого на 1 шт: `21.95`

---

#### Продукт **Какао напиток (product_item_id = PRD-002)**

* молоко: `0.30 × 80.00 = 24.00`
* сахар: `0.02 × 65.00 = 1.30`
* какао:  `0.01 × 500.00 = 5.00`

Итого на 1 шт: `30.30`

---

### 11.2. Итоги по заказам (как у вас в примере)

* Заказ **1**:
  `21.95 × 10 + 30.30 × 5 = 219.50 + 151.50 = 371.00`

* Заказ **2**:
  `21.95 × 3 + 30.30 × 2 = 65.85 + 60.60 = 126.45`

* Заказ **3**:
  `21.95 × 7 + 30.30 × 1 = 153.65 + 30.30 = 183.95`

---

### 11.5. Сводная таблица ожидаемых итогов

* Заказ **1** → **371.00**
* Заказ **2** → **126.45**
* Заказ **3** → **183.95**

## 12. Скачать пример готовой базы данных

- `dairy_demo.sql`

👉 [dairy_demo.sql](../assets/files//dairy_demo%20(2).sql)
 