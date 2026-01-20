using System.Text.RegularExpressions;

namespace ClientValidationApp.Validation;

public static class FioValidator
{
    // Разрешаем: буквы (рус/лат), пробел, дефис
    private static readonly Regex AllowedCharsRegex =
        new(@"^[A-Za-zА-Яа-яЁё\s\-]+$");

    public static (bool ok, string error) CheckForbiddenSymbols(string fio)
    {
        if (string.IsNullOrWhiteSpace(fio))
            return (false, "ФИО не заполнено.");

        if (!AllowedCharsRegex.IsMatch(fio))
            return (false, "ФИО содержит запрещённые символы (разрешены буквы, пробел, дефис).");

        return (true, "");
    }

    public static (bool ok, string error) CheckThreeParts(string fio)
    {
        fio = fio.Trim();

        // Если хотите считать множественные пробелы ошибкой — оставьте так.
        // Если хотите нормализовать — замените Regex.Replace(fio, @"\s+", " ")
        var parts = fio.Split(' ', StringSplitOptions.RemoveEmptyEntries);

        if (parts.Length != 3)
            return (false, "ФИО должно состоять из 3 частей: Фамилия Имя Отчество.");

        if (parts.Any(p => p.Length < 2))
            return (false, "Каждая часть ФИО должна содержать минимум 2 символа.");

        return (true, "");
    }
}