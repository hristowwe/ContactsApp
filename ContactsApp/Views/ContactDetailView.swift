import SwiftUI

struct ContactDetailView: View {
    @EnvironmentObject var store: ContactsStore
    @Environment(\.openURL) private var openURL
    let contactID: Int
    @Environment(\.dismiss) private var dismiss
    private var contact: Contact? { store.contact(withID: contactID) }
    
    var body: some View {
        Group {
            
            if let c = contact {
                VStack(spacing: 0) {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.title3.weight(.semibold))
                        }
                        Spacer()
                        NavigationLink { EditContactView(contact: c) } label: {
                            Text("Edit")
                                .font(.body.weight(.semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.black.opacity(0.1))
                                )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(Color.gray)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            Circle()
                                .fill(Color.indigo)
                                .frame(width: 100, height: 100, alignment: .center)
                                .overlay {
                                    Text(String(c.name.trimmingCharacters(in: .whitespacesAndNewlines).prefix(1)).uppercased())
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            Text(c.name)
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                            
                            HStack(spacing: 12) {
                                Button {
                                    open(c.telURL)
                                } label: { Label("Call", systemImage: "phone.fill") }
                                    .disabled(c.phone?.isEmpty ?? true)
                                
                                Button {
                                    open(c.smsURL)
                                } label: { Label("Message", systemImage: "message.fill") }
                                    .disabled(c.phone?.isEmpty ?? true)
                                
                                Button {
                                    open(c.mailURL)
                                } label: { Label("Mail", systemImage: "envelope.fill") }
                                    .disabled(c.email?.isEmpty ?? true)
                            }
                            .buttonStyle(.borderedProminent)
                            
                            
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color.gray)
                        
                        VStack(spacing: 12) {
                            if let phone = c.phone, let type = c.phoneType {
                                InfoCard(title: type.rawValue.capitalized,
                                         value: phone,
                                         systemImage: "phone")
                            }
                            if let email = c.email, let type = c.emailType {
                                InfoCard(title: type.rawValue.capitalized,
                                         value: email,
                                         systemImage: "envelope")
                            }
                        }
                        .padding()
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .navigationBarBackButtonHidden(true)
                    .toolbar(.hidden, for: .navigationBar)
                }
                
            } else {
                ContentUnavailableView("Contact not found",
                                       systemImage: "person.crop.circle.badge.xmark",
                                       description: Text("This contact no longer exists."))
                .padding()
            }
        }
    }
    
    private struct InfoCard: View {
        let title: String
        let value: String
        let systemImage: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: systemImage)
                    .imageScale(.large)
                    .foregroundStyle(.secondary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(value)
                        .font(.body)
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private func open(_ url: URL?) {
        guard let url else { return }
        openURL(url)
    }
    
}
