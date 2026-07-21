//
//  Mailgun.IPAllowlist Parity Tests.swift
//  swift-mailgun-types
//
//  Batch-0 parity corpus for the Mailgun IPAllowlist router.
//

import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_IPAllowlist_Types

@Suite("Mailgun.IPAllowlist Router Parity")
struct IPAllowlistParityTests {
    let router = Mailgun.IPAllowlist.API.Router()

    var routes: [(name: String, route: Mailgun.IPAllowlist.API)] {
        get throws {
            [
                ("list", .list),
                (
                    "update",
                    .update(
                        request: .init(
                            address: "203.0.113.10/32",
                            description: "Parity updated allowlist entry"
                        )
                    )
                ),
                (
                    "add",
                    .add(
                        request: .init(
                            address: "203.0.113.10/32",
                            description: "Parity allowlist entry"
                        )
                    )
                ),
                (
                    "delete",
                    .delete(request: .init(address: "203.0.113.10/32"))
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "IPAllowlist")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}
