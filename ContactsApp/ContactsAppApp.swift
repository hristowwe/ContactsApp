
import SwiftUI

@main
struct ContactsAppApp: App {
    @StateObject private var store = ContactsStore()

    var body: some Scene {
        WindowGroup {
            ContactListView()
                .environmentObject(store)
        }
    }
}
