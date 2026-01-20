using System.Net.Http.Json;
using ClientValidationApp.Models;

namespace ClientValidationApp.Services;

public class SimulatorApiClient
{
    private readonly HttpClient _http;

    public SimulatorApiClient(string baseUrl)
    {
        // baseUrl должен оканчиваться на /TransferSimulator/
        if (!baseUrl.EndsWith("/")) baseUrl += "/";

        _http = new HttpClient
        {
            BaseAddress = new Uri(baseUrl),
            Timeout = TimeSpan.FromSeconds(10)
        };
    }

    public async Task<string> GetFullNameAsync()
    {
        // GET fullName -> { "value": "..." }
        using var response = await _http.GetAsync("fullName");

        // Явная обработка 5xx (как в условии)
        if ((int)response.StatusCode >= 500)
        {
            throw new HttpRequestException(
                $"Ошибка эмулятора: HttpStatusCode {(int)response.StatusCode} (5xx).",
                null,
                response.StatusCode);
        }

        if (!response.IsSuccessStatusCode)
        {
            throw new HttpRequestException(
                $"Ошибка запроса: {(int)response.StatusCode} {response.ReasonPhrase}",
                null,
                response.StatusCode);
        }

        var dto = await response.Content.ReadFromJsonAsync<FullNameResponse>();

        var fio = dto?.Value ?? "";
        return fio;
    }
}