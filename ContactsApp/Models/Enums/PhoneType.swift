
import Foundation


enum PhoneType: String, CaseIterable, Identifiable, Codable {
    
    case mobile, work, home, other
    
    var id: String {rawValue}
}
