import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Users_Types

@Suite("Mailgun.Users Router Parity")
struct UsersParityTests {
    let router = Mailgun.Users.API.Router()

    var routes: [(name: String, route: Mailgun.Users.API)] {
        get throws {
            [
                (
                    "list",
                    .list(request: .init(role: .admin, limit: 25, skip: 5))
                ),
                ("list-nil", .list(request: nil)),
                ("get", .get(userId: "parity-user-id")),
                ("me", .me),
                ("addToOrganization", .addToOrganization(userId: "parity-user-id", orgId: "parity-org-id")),
                ("removeFromOrganization", .removeFromOrganization(userId: "parity-user-id", orgId: "parity-org-id"))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Users")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["list-nil"])
    }
}
