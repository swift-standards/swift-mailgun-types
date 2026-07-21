import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Routes_Types

@Suite("Mailgun.Routes Router Parity")
struct RoutesParityTests {
    let router = Mailgun.Routes.API.Router()

    var routes: [(name: String, route: Mailgun.Routes.API)] {
        get throws {
            [
                (
                    "create",
                    .create(
                        request: .init(
                            priority: 1,
                            description: "Parity corpus route",
                            expression: "match_recipient(\".*@parity.example.com\")",
                            action: ["forward(\"https://parity.example.com/inbound\")", "stop()"]
                        )
                    )
                ),
                ("list", .list(limit: 25, skip: 5)),
                ("list-empty", .list(limit: nil, skip: nil)),
                ("get", .get(id: "route-id-123")),
                (
                    "update",
                    .update(
                        id: "route-id-123",
                        request: .init(
                            id: "route-id-123",
                            priority: 2,
                            description: "Updated parity route",
                            expression: "match_header(\"subject\", \".*parity.*\")",
                            action: ["store()", "stop()"]
                        )
                    )
                ),
                ("delete", .delete(id: "route-id-123")),
                ("match", .match(address: "someone@parity.example.com"))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Routes")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["update", "match"])
    }
}
