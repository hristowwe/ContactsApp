import SwiftUI

struct EditContactView: View {
    @EnvironmentObject var store: ContactsStore
    @Environment(\.dismiss) private var dismiss

    @State private var draft: Contact
    @State private var nameLimit: Int = 40

    init(contact: Contact) {
        _draft = State(initialValue: contact)
    }

    private var isNameValid: Bool {
        !draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    private var isPhoneEdited: Bool { (draft.phone?.isEmpty == false) }
    private var isEmailEdited: Bool { (draft.email?.isEmpty == false) }

    private var isPhoneValid: Bool {
        guard let p = draft.phone, !p.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return true }
        return Self.isValidPhone(p)
    }
    private var isEmailValid: Bool {
        guard let e = draft.email, !e.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return true }
        return Self.isValidEmail(e)
    }
    private var canSave: Bool { isNameValid && isPhoneValid && isEmailValid }

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    TextField("Full name", text: $draft.name)
                        .textInputAutocapitalization(.words)
                        .onChange(of: draft.name) { newValue in
                            if newValue.count > nameLimit {
                                draft.name = String(newValue.prefix(nameLimit))
                            }
                        }
                    Text("\(draft.name.count)/\(nameLimit)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Phone") {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Picker("Type", selection: Binding($draft.phoneType, default: .mobile)) {
                            ForEach(PhoneType.allCases) { t in
                                Text(t.rawValue.capitalized).tag(t)
                            }
                        }
                        .pickerStyle(.menu)

                        TextField("Number", text: Binding($draft.phone, default: ""))
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                            .autocorrectionDisabled()
                    }
                    if isPhoneEdited && !isPhoneValid {
                        Text("Enter a valid phone number (7–15 digits, optionally starting with +).")
                            .font(.caption2)
                            .foregroundStyle(.red)
                    }
                }
            }

            Section("Email") {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Picker("Type", selection: Binding($draft.emailType, default: .work)) {
                            ForEach(EmailType.allCases) { t in
                                Text(t.rawValue.capitalized).tag(t)
                            }
                        }
                        .pickerStyle(.menu)

                        TextField("Email", text: Binding($draft.email, default: ""))
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(.emailAddress)
                }
                    if isEmailEdited && !isEmailValid {
                        Text("Enter a valid email address (e.g. name@example.com).")
                            .font(.caption2)
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Edit")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    store.upsert(draft)
                    dismiss()
                }
                .disabled(!canSave)
            }
        }
    }
}

private extension EditContactView {
    static func isValidPhone(_ input: String) -> Bool {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.allSatisfy({ "+0123456789 ()-.".contains($0) }) else { return false }
        if trimmed.dropFirst().contains("+") { return false }
        let digits = trimmed.filter(\.isNumber)
        return (7...15).contains(digits.count)
    }

    static func isValidEmail(_ input: String) -> Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", pattern)
        return predicate.evaluate(with: input.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}


extension Binding {
    init(_ source: Binding<Value?>, default defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}
