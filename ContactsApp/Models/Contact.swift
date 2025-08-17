
import Foundation


struct Contact: Identifiable, Hashable, Codable {
    var id: Int
    var name: String
    var phoneType: PhoneType?
    var phone: String?
    var emailType: EmailType?
    var email: String?
}

extension Contact {
    var initial: String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let first = trimmed.first else { return "#" }

        let initial = String(first).uppercased(with: .current)
        let isLetter = initial.unicodeScalars.allSatisfy { CharacterSet.letters.contains($0) }

        return isLetter ? initial : "#"
    }
    var canCall: Bool { (phone?.isEmpty == false) }
    var canMessage: Bool { canCall }
    var canMail: Bool { (email?.isEmpty == false) }
    
    var sanitizedPhone: String? {
        guard let p = phone, !p.isEmpty else { return nil }
        let allowed = CharacterSet(charactersIn: "+0123456789")
        let filtered = String(p.unicodeScalars.filter(allowed.contains))
        return filtered.isEmpty ? nil : filtered
    }

    var telURL: URL? {
        guard let n = sanitizedPhone else { return nil }
        return URL(string: "tel://\(n)")
    }

    var smsURL: URL? {
        guard let n = sanitizedPhone else { return nil }
        return URL(string: "sms:\(n)")
    }

    var mailURL: URL? {
        guard let e = email, !e.isEmpty else { return nil }
        return URL(string: "mailto:\(e)")
    }
    
}
