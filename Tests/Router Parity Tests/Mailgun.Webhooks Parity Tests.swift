import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Webhooks_Types

@Suite("Mailgun.Webhooks Router Parity")
struct WebhooksParityTests {
    let router = Mailgun.Webhooks.API.Router()

    var routes: [(name: String, route: Mailgun.Webhooks.API)] {
        get throws {
            [
                ("list", .list(domain: try .init("parity.example.com"))),
                ("get", .get(domain: try .init("parity.example.com"), webhookName: .delivered)),
                (
                    "create",
                    .create(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            id: .opened,
                            url: ["https://parity.example.com/hooks/opened", "https://parity.example.com/hooks/opened-2"]
                        )
                    )
                ),
                (
                    "update",
                    .update(
                        domain: try .init("parity.example.com"),
                        webhookName: .clicked,
                        request: .init(url: ["https://parity.example.com/hooks/clicked"])
                    )
                ),
                ("delete", .delete(domain: try .init("parity.example.com"), webhookName: .permanentFail))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Webhooks")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}
