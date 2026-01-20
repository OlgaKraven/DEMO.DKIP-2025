using ClientValidationApp.Services;
using ClientValidationApp.Validation;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using System.Text;

namespace ClientValidationApp
{
    public partial class Form1 : Form
    {
        private readonly SimulatorApiClient _api;
        private readonly WordTestCaseWriter _writer;

        // Укажите путь к ТестКейс.docx (можно хранить рядом с exe)
        private readonly string _testCaseDocPath =
            Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ТестКейс.docx");

        //private string DumpBookmarks(string docPath)
        //{
        //    using var doc = WordprocessingDocument.Open(docPath, false);
        //    var body = doc.MainDocumentPart?.Document.Body;
        //    if (body == null) return "Body не найден.";

        //    var sb = new StringBuilder();
        //    foreach (var b in body.Descendants<BookmarkStart>())
        //        sb.AppendLine(b.Name?.Value);

        //    return sb.Length == 0 ? "Закладок не найдено." : sb.ToString();
        //}
        public Form1()
        {
            InitializeComponent();

            // Реальный baseUrl (локальный)
            _api = new SimulatorApiClient("http://localhost:4444/TransferSimulator/");

            // Резервный baseUrl (если Linux/не настроен локальный)
            // _api = new SimulatorApiClient("http://prb.sylas.ru/TransferSimulator/");

            _writer = new WordTestCaseWriter();
        }
        private async void btnGetData_Click(object sender, EventArgs e)
        {
            try
            {
                lblStatus.Text = "Статус: Получение данных...";
                txtErrors.Clear();

                var fio = await _api.GetFullNameAsync();

                txtFio.Text = fio;
                lblStatus.Text = "Статус: Данные получены.";
            }
            catch (HttpRequestException ex)
            {
                lblStatus.Text = "Статус: Ошибка получения данных.";
                txtErrors.Text = ex.Message;
            }
            catch (TaskCanceledException)
            {
                lblStatus.Text = "Статус: Ошибка получения данных.";
                txtErrors.Text = "Превышено время ожидания ответа от API (Timeout).";
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Статус: Ошибка получения данных.";
                txtErrors.Text = ex.Message;
            }
        }
        private void btnRunTest_Click(object sender, EventArgs e)
        {

            try
            {
                //lblStatus.Text = DumpBookmarks(_testCaseDocPath);
                //return;

                lblStatus.Text = "Статус: Проверка данных...";
                txtErrors.Clear();

                var fio = txtFio.Text ?? "";

                // TC-01: запрещённые символы
                var (ok1, err1) = FioValidator.CheckForbiddenSymbols(fio);
                var tc01 = ok1 ? "Успешно" : "Не успешно";

                // TC-02: структура из 3 частей
                var (ok2, err2) = FioValidator.CheckThreeParts(fio);
                var tc02 = ok2 ? "Успешно" : "Не успешно";

                // Вывод на форму
                var errors = new List<string>();
                if (!ok1) errors.Add($"TC-01: {err1}");
                if (!ok2) errors.Add($"TC-02: {err2}");
                txtErrors.Text = errors.Count == 0
                    ? "Ошибок не обнаружено."
                    : string.Join(Environment.NewLine, errors);

                // Запись в Word (в столбец «Результат» по закладкам)
                _writer.WriteBookmarkText(_testCaseDocPath, "TC_01_Result", tc01);
                _writer.WriteBookmarkText(_testCaseDocPath, "TC_02_Result", tc02);

                lblStatus.Text = "Статус: Результат сформирован и сохранён.";
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Статус: Ошибка проверки/записи.";
                txtErrors.Text = ex.Message;
            }
        }
    }
}
