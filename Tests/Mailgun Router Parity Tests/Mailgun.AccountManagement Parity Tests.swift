import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_AccountManagement_Types

@Suite("Mailgun.AccountManagement Router Parity")
struct AccountManagementParityTests {
    let router = Mailgun.AccountManagement.API.Router()

    var routes: [(name: String, route: Mailgun.AccountManagement.API)] {
        get throws {
            [
                (
                    "updateAccount",
                    .updateAccount(
                        request: .init(
                            name: "Parity Account",
                            inactiveSessionTimeout: 900,
                            absoluteSessionTimeout: 86400,
                            logoutRedirectUrl: "https://parity.example.com/logout"
                        )
                    )
                ),
                ("getHttpSigningKey", .getHttpSigningKey),
                ("regenerateHttpSigningKey", .regenerateHttpSigningKey),
                ("getSandboxAuthRecipients", .getSandboxAuthRecipients),
                (
                    "addSandboxAuthRecipient",
                    .addSandboxAuthRecipient(
                        request: .init(email: try .init("recipient@parity.example.com"))
                    )
                ),
                (
                    "deleteSandboxAuthRecipient",
                    .deleteSandboxAuthRecipient(email: try .init("recipient@parity.example.com"))
                ),
                ("resendActivationEmail", .resendActivationEmail),
                ("getSAMLOrganization", .getSAMLOrganization),
                (
                    "addSAMLOrganization",
                    .addSAMLOrganization(
                        request: .init(userId: "user-1234", domain: "parity.example.com")
                    )
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(
            try Parity.corpus(of: routes, via: router),
            area: "AccountManagement"
        )
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}
