using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using DocumentFormat.OpenXml;

namespace ClientValidationApp.Services;

public class WordTestCaseWriter
{
    public void WriteBookmarkText(string docPath, string bookmarkName, string text)
    {
        using var doc = WordprocessingDocument.Open(docPath, true);
        var body = doc.MainDocumentPart?.Document.Body;
        if (body == null) return;

        var bookmarkStart = body.Descendants<BookmarkStart>()
            .FirstOrDefault(b => b.Name == bookmarkName);

        if (bookmarkStart == null)
            throw new InvalidOperationException($"Закладка '{bookmarkName}' не найдена.");

        // По стандарту у BookmarkStart есть Id; конец — BookmarkEnd с тем же Id
        var bookmarkId = bookmarkStart.Id?.Value;
        var bookmarkEnd = body.Descendants<BookmarkEnd>()
            .FirstOrDefault(b => b.Id?.Value == bookmarkId);

        if (bookmarkEnd == null)
            throw new InvalidOperationException($"Конец закладки '{bookmarkName}' не найден.");

        // Удаляем всё между start и end (если было)
        var current = bookmarkStart.NextSibling();
        while (current != null && current != bookmarkEnd)
        {
            var next = current.NextSibling();
            current.Remove();
            current = next;
        }

        // Вставляем новый текст
        bookmarkStart.Parent!.InsertAfter(
            new Run(new Text(text) { Space = SpaceProcessingModeValues.Preserve }),
            bookmarkStart
        );

        doc.MainDocumentPart!.Document.Save();
    }
}