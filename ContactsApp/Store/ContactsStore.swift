

import Foundation
import SwiftUI

@MainActor
final class ContactsStore: ObservableObject {
    @Published private(set) var contacts: [Contact]

    init(contacts: [Contact] = SampleData.contacts) {
        self.contacts = contacts.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    func contact(withID id: Int) -> Contact? {
        contacts.first { $0.id == id }
    }

    func upsert(_ updated: Contact) {
        if let idx = contacts.firstIndex(where: { $0.id == updated.id }) {
            contacts[idx] = updated
        } else {
            contacts.append(updated)
        }
        contacts.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var sections: [(key: String, value: [Contact])] {
        let groups = Dictionary(grouping: contacts, by: { $0.initial })
        let sortedKeys = groups.keys.sorted { a, b in
            if a == "#" { return false }
            if b == "#" { return true }
            return a < b
        }
        return sortedKeys.map { key in
            (key, groups[key]!.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })
        }
    }
}
