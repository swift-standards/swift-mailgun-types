import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Credentials_Types

@Suite("Mailgun.Credentials Router Parity")
struct CredentialsParityTests {
    let router = Mailgun.Credentials.API.Router()

    var routes: [(name: String, route: Mailgun.Credentials.API)] {
        get throws {
            let domain: Domain = try .init("parity.example.com")
            return [
                ("list-nil", .list(domain: domain, request: nil)),
                ("list-full", .list(domain: domain, request: .init(skip: 10, limit: 25))),
                (
                    "create",
                    .create(
                        domain: domain,
                        request: .init(
                            login: "alice@parity.example.com",
                            mailbox: "alice",
                            password: "fixed-parity-password",
                            system: false
                        )
                    )
                ),
                ("deleteAll", .deleteAll(domain: domain)),
                (
                    "update",
                    .update(
                        domain: domain,
                        login: "alice@parity.example.com",
                        request: .init(password: "new-fixed-password")
                    )
                ),
                ("delete", .delete(domain: domain, login: "alice@parity.example.com")),
                (
                    "updateMailbox",
                    .updateMailbox(
                        domain: domain,
                        login: "alice@parity.example.com",
                        request: .init(password: "mailbox-fixed-password")
                    )
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Credentials")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["list-nil"])
    }
}
