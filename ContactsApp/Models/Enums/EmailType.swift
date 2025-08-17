
import Foundation

enum EmailType: String, CaseIterable, Identifiable, Codable {
    case work, home, school, other
    var id: String { rawValue }
}

