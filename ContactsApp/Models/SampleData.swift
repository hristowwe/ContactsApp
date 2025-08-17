
import Foundation


enum SampleData {
    static let contacts: [Contact] = [
        .init(id: 1, name: "Alice Martin",  phoneType: .mobile, phone: "+359888123456", emailType: .work,  email: nil),
        .init(id: 2, name: "Борис Петров",  phoneType: nil,      phone: nil,            emailType: .home,  email: "boris@example.com"),
        .init(id: 3, name: "Charlie Stone", phoneType: .work,   phone: "028901234",    emailType: nil,    email: nil),
        .init(id: 4, name: "Деница Георгиева", phoneType: nil,  phone: nil,            emailType: .school,email: "deni@uni.bg"),
        .init(id: 5, name: "Eva Novak",     phoneType: .home,   phone: "070012345",    emailType: .other, email: "eva@somewhere.net"),
        .init(id: 6, name: "Иван Стоянов",  phoneType: .mobile, phone: "0888123123",   emailType: nil,    email: nil),
        .init(id: 7, name: "Zoe Quinn",     phoneType: nil,      phone: nil,            emailType: .work,  email: "zoe@company.com"),
        .init(id: 8, name: "Zii",     phoneType: nil,      phone: nil,            emailType: .work,  email: "zii@company.com")
        ]
}

