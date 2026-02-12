
## 3. Архитектура WinForms-проекта (минимально, но чисто)

### 3.1. Создать проект

* Visual Studio → **Windows Forms App (.NET)** (лучше .NET 8/9)
* Имя: `DairyDemo.Auth` (или ваше)

### 3.2. NuGet пакеты (MySQL вместо PostgreSQL)

**Обязательно:**

* `MySqlConnector` (рекомендуемый драйвер для MySQL в .NET)
* `BCrypt.Net-Next`

**Опционально:**

* `Dapper`

❌ `Npgsql` больше не нужен.

---

## 4. Работа с проектом

### 4.1. Настройка картинок

(без изменений — это про WinForms/Assets)

---

### 4.2. Вывод и копирование хэша пароля (TextBox)

(код без изменений — это не зависит от СУБД)

---

### 4.3. Data: `Data/Db.cs` (MySQL)

Заменяем `NpgsqlConnection` на `MySqlConnection` и строку подключения.

```csharp
using MySqlConnector;

namespace DairyDemo.Auth.Data;

public static class Db
{
    // Пример для XAMPP:
    // user: root
    // password: (часто пустой, если вы не меняли)
    // host: localhost
    // database: dairy_demo
    public static string ConnectionString =
        "Server=localhost;Port=3306;Database=dairy_demo;Uid=root;Pwd=;SslMode=None;";

    public static MySqlConnection CreateConnection()
        => new MySqlConnection(ConnectionString);
}
```

> Если вы задали пароль root в MySQL — впишите его в `Pwd=...`.

---

### 4.4. Data Model: `Data/Models/User.cs`

(можно оставить без изменений)

---

### 4.5. Repository: `Data/Repositories/UserRepository.cs` (MySQL)

Ниже — ключевые правки, которые нужно внести:

1. `using MySqlConnector;` вместо `using Npgsql;`
2. SQL-запросы: убираем `app.users`, оставляем `users`
3. Параметры: в MySqlConnector обычно используют `@login`, `@id` (как у вас — ок)
4. `LIMIT 1` остаётся
5. Логика блокировки та же

Пример переписанного метода **GetByLoginAsync** (как эталон):

```csharp
using DairyDemo.Auth.Data.Models;
using MySqlConnector;

namespace DairyDemo.Auth.Data.Repositories;

public sealed class UserRepository
{
    public async Task<User?> GetByLoginAsync(string login)
    {
        await using var conn = Db.CreateConnection();
        await conn.OpenAsync();

        const string sql = @"
SELECT id, login, password_hash, role, failed_attempts, is_locked
FROM users
WHERE login = @login
LIMIT 1;
";
        await using var cmd = new MySqlCommand(sql, conn);
        cmd.Parameters.AddWithValue("@login", login);

        await using var r = await cmd.ExecuteReaderAsync();
        if (!await r.ReadAsync()) return null;

        return new User
        {
            Id = r.GetInt64(0),
            Login = r.GetString(1),
            PasswordHash = r.GetString(2),
            Role = r.GetString(3),
            FailedAttempts = r.GetInt32(4),
            IsLocked = r.GetBoolean(5)
        };
    }

    // Остальные методы переписываются аналогично:
    // - таблица users (без app.)
    // - MySqlCommand вместо NpgsqlCommand
    // - параметры @...
}
```

✅ Ваши `UPDATE` на increment/lock будут работать в MySQL без изменений по смыслу:

```sql
UPDATE users
SET failed_attempts = failed_attempts + 1,
    is_locked = CASE WHEN (failed_attempts + 1) >= 3 THEN 1 ELSE is_locked END
WHERE id = @id;
```

---

### 4.6. Services: `PasswordService.cs`

(без изменений)

---

### 4.7. Services: `AuthService.cs`

(без изменений)

---

### 4.8–4.12 UI (капча/формы/Program.cs)

(без изменений)

---

## 4.14. Важный момент по ТЗ: “3 попытки подряд”

(логика без изменений)

---

## Скачать пример приложения

Заменяем фразу (важно для методички):

> ⚠️ Внимание! Не заработает без базы данных и установленного **MySQL (XAMPP)**.

Если хотите — я могу:

* дать **полный переписанный `UserRepository.cs` целиком** под `MySqlConnector` (в одном блоке, готовый к вставке),
* и/или подготовить SQL-скрипт “миграции” (создать `users` + seed Admin) одним файлом под phpMyAdmin.
