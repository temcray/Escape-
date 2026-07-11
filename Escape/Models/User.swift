import Foundation
import SwiftData

 @Model
final class User: Identifiable {
    var id: UUID
    var fullName: String
    var email: String
    var password: String
    
    init( fullName: String, email: String, password: String) {
        self.id = UUID()
        self.fullName = fullName
        self.email = email
        self.password = password
    }
}
