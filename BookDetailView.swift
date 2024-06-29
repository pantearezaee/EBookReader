import SwiftUI

struct BookDetailView: View {
    let book: Book
    
    var body: some View {
        if let pdfURL = book.pdfURL {
            PDFViewUI(url: pdfURL)
                .navigationTitle(book.title ?? "Untitled")
        } else {
            ScrollView {
                Text(book.content ?? "No content")
                    .padding()
            }
            .navigationTitle(book.title ?? "Untitled")
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let newBook = Book(context: context)
        newBook.title = "Sample Book"
        newBook.content = "This is a sample book content."
        
        return BookDetailView(book: newBook)
    }
}
