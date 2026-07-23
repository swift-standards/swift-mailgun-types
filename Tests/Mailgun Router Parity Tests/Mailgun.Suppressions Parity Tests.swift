//
//  Mailgun.Suppressions Parity Tests.swift
//  swift-mailgun-types
//
//  Batch-0 parity corpus for the four Suppressions leaf routers:
//  Bounces, Complaints, Unsubscribe, Allowlist. The umbrella
//  Suppressions.API composes these leaves and is intentionally not
//  tested here.
//
//  SKIPPED: <router>.list(request: nil) variants — an absent query string
//  parses back as a Request with all-nil fields (the routers' `Optionally`
//  wraps a query of all-optional fields, which succeeds on empty input),
//  so `nil` does not value-round-trip. The equivalent wire shape is
//  covered by the "list-empty" entries using `.init()`.
//

import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Suppressions_Types

@Suite("Mailgun.Suppressions.Bounces Router Parity")
struct BouncesParityTests {
    let router = Mailgun.Suppressions.Bounces.API.Router()

    var routes: [(name: String, route: Mailgun.Suppressions.Bounces.API)] {
        get throws {
            [
                (
                    "importList",
                    .importList(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            file: Data("address\nbounced@parity.example.com\n".utf8)
                        )
                    )
                ),
                (
                    "get",
                    .get(
                        domain: try .init("parity.example.com"),
                        address: try .init("user@parity.example.com")
                    )
                ),
                (
                    "delete",
                    .delete(
                        domain: try .init("parity.example.com"),
                        address: try .init("user@parity.example.com")
                    )
                ),
                (
                    "list",
                    .list(
                        domain: try .init("parity.example.com"),
                        request: .init(limit: 25, page: "next-page-token", term: "parity-term")
                    )
                ),
                (
                    "list-empty",
                    .list(
                        domain: try .init("parity.example.com"),
                        request: .init()
                    )
                ),
                (
                    "create",
                    .create(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            address: try .init("user@parity.example.com"),
                            code: "550",
                            error: "Mailbox does not exist",
                            createdAt: "Thu, 01 Jan 2026 00:00:00 UTC"
                        )
                    )
                ),
                ("deleteAll", .deleteAll(domain: try .init("parity.example.com")))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Suppressions.Bounces")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["importList"])
    }
}

@Suite("Mailgun.Suppressions.Complaints Router Parity")
struct ComplaintsParityTests {
    let router = Mailgun.Suppressions.Complaints.API.Router()

    var routes: [(name: String, route: Mailgun.Suppressions.Complaints.API)] {
        get throws {
            [
                (
                    "importList",
                    .importList(
                        domain: try .init("parity.example.com"),
                        request: .init(file: Data("address\ncomplained@parity.example.com\n".utf8))
                    )
                ),
                (
                    "get",
                    .get(
                        domain: try .init("parity.example.com"),
                        address: try .init("user@parity.example.com")
                    )
                ),
                (
                    "delete",
                    .delete(
                        domain: try .init("parity.example.com"),
                        address: try .init("user@parity.example.com")
                    )
                ),
                (
                    "list",
                    .list(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            address: try .init("user@parity.example.com"),
                            term: "parity-term",
                            limit: 25,
                            page: "next-page-token"
                        )
                    )
                ),
                (
                    "list-empty",
                    .list(
                        domain: try .init("parity.example.com"),
                        request: .init()
                    )
                ),
                (
                    "create",
                    .create(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            address: try .init("user@parity.example.com"),
                            createdAt: "Thu, 01 Jan 2026 00:00:00 UTC"
                        )
                    )
                ),
                ("deleteAll", .deleteAll(domain: try .init("parity.example.com")))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Suppressions.Complaints")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["importList"])
    }
}

@Suite("Mailgun.Suppressions.Unsubscribe Router Parity")
struct UnsubscribeParityTests {
    let router = Mailgun.Suppressions.Unsubscribe.API.Router()

    var routes: [(name: String, route: Mailgun.Suppressions.Unsubscribe.API)] {
        get throws {
            [
                (
                    "importList",
                    .importList(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            file: Data("address\nunsubscribed@parity.example.com\n".utf8)
                        )
                    )
                ),
                (
                    "get",
                    .get(
                        domain: try .init("parity.example.com"),
                        address: try .init("user@parity.example.com")
                    )
                ),
                (
                    "delete",
                    .delete(
                        domain: try .init("parity.example.com"),
                        address: try .init("user@parity.example.com")
                    )
                ),
                (
                    "list",
                    .list(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            address: try .init("user@parity.example.com"),
                            term: "parity-term",
                            limit: 25,
                            page: "next-page-token"
                        )
                    )
                ),
                (
                    "list-empty",
                    .list(
                        domain: try .init("parity.example.com"),
                        request: .init()
                    )
                ),
                (
                    "create",
                    .create(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            address: try .init("user@parity.example.com"),
                            tags: ["newsletter", "promotions"],
                            createdAt: "Thu, 01 Jan 2026 00:00:00 UTC"
                        )
                    )
                ),
                ("deleteAll", .deleteAll(domain: try .init("parity.example.com")))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Suppressions.Unsubscribe")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["importList"])
    }
}

@Suite("Mailgun.Suppressions.Allowlist Router Parity")
struct AllowlistParityTests {
    let router = Mailgun.Suppressions.Allowlist.API.Router()

    var routes: [(name: String, route: Mailgun.Suppressions.Allowlist.API)] {
        get throws {
            [
                (
                    "get",
                    .get(
                        domain: try .init("parity.example.com"),
                        value: "user@parity.example.com"
                    )
                ),
                (
                    "delete",
                    .delete(
                        domain: try .init("parity.example.com"),
                        value: "user@parity.example.com"
                    )
                ),
                (
                    "list",
                    .list(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            address: try .init("user@parity.example.com"),
                            term: "parity-term",
                            limit: 25,
                            page: "next-page-token"
                        )
                    )
                ),
                (
                    "list-empty",
                    .list(
                        domain: try .init("parity.example.com"),
                        request: .init()
                    )
                ),
                (
                    "create-address",
                    .create(
                        domain: try .init("parity.example.com"),
                        request: .address(try .init("user@parity.example.com"))
                    )
                ),
                (
                    "create-domain",
                    .create(
                        domain: try .init("parity.example.com"),
                        request: .domain(try .init("allowed.parity.example.com"))
                    )
                ),
                ("deleteAll", .deleteAll(domain: try .init("parity.example.com"))),
                (
                    "importList",
                    .importList(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            file: Data("address\nallowed@parity.example.com\n".utf8)
                        )
                    )
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Suppressions.Allowlist")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["importList"])
    }
}
