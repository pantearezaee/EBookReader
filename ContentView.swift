import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true)],
        animation: .default)
    private var books: FetchedResults<Book>

    @State private var showingImporter = false

    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        Text(book.title ?? "Untitled")
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingImporter = true
                    }) {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .fileImporter(
                isPresented: $showingImporter,
                allowedContentTypes: [.plainText, .pdf],
                allowsMultipleSelection: false
            ) { result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    if selectedFile.pathExtension == "pdf" {
                        addPDFBook(title: selectedFile.deletingPathExtension().lastPathComponent, url: selectedFile)
                    } else {
                        let content = try String(contentsOf: selectedFile)
                        addTextBook(title: selectedFile.deletingPathExtension().lastPathComponent, content: content)
                    }
                } catch {
                    print("Failed to read the file: \(error.localizedDescription)")
                }
            }
        }
    }

    private func addTextBook(title: String, content: String) {
        withAnimation {
            let newBook = Book(context: viewContext)
            newBook.title = title
            newBook.content = content

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func addPDFBook(title: String, url: URL) {
        withAnimation {
            let newBook = Book(context: viewContext)
            newBook.title = title
            newBook.pdfURL = url

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            offsets.map { books[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
