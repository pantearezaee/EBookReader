import Foundation
import CoreData

@objc(Book)
public class Book: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var pdfURL: URL?
}
