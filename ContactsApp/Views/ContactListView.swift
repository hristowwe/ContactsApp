import SwiftUI


struct ContactListView: View {
    @EnvironmentObject var store: ContactsStore
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.sections, id: \.key) { section in
                    Section(section.key) {
                        ForEach(section.value) { contact in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(contact.name).font(.body.weight(.semibold))
                                    Text(contact.phone ?? contact.email ?? "—")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Button {
                                    open(contact.telURL)
                                } label: {
                                    Label("Call", systemImage: "phone.fill").labelStyle(.iconOnly)
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(!contact.canCall)
                                .buttonStyle(.borderless)
                                .padding(.leading, 8)
                            }
                            .background(
                                NavigationLink("", destination: ContactDetailView(contactID: contact.id))
                                    .opacity(0)
                            )
                            .contextMenu{
                                Button {
                                    open(contact.smsURL)
                                } label: {
                                    Label("Message", systemImage: "message")
                                }.disabled(!contact.canMessage)
                                
                                Button {
                                    open(contact.mailURL)
                                } label: {
                                    Label("Mail", systemImage: "envelope")
                                }.disabled(!contact.canMail)
                                
                            }
                        }
                    }
                }
            }
            .navigationTitle("Contacts")
        }
    }
    
    private func open(_ url: URL?) {
        guard let url else { return }
        openURL(url)
    }
}
