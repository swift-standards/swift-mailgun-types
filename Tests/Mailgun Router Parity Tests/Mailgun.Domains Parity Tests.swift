//
//  Mailgun.Domains Parity Tests.swift
//  swift-mailgun-types
//
//  Batch-0 parity corpus for the Mailgun Domains module's four leaf routers.
//  Mailgun.Domains.API is an umbrella composing these leaves and is not
//  tested separately.
//

import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Domains_Types

@Suite("Mailgun.Domains Router Parity")
struct DomainsDomainsParityTests {
    let router = Mailgun.Domains.Domains.API.Router()

    var routes: [(name: String, route: Mailgun.Domains.Domains.API)] {
        get throws {
            [
                ("list-nil", .list(request: nil)),
                (
                    "list-full",
                    .list(
                        request: .init(
                            authority: "authority.example.com",
                            state: .active,
                            limit: 25,
                            skip: 5
                        )
                    )
                ),
                (
                    "create",
                    .create(
                        request: .init(
                            name: "parity.example.com",
                            smtpPassword: "parity-smtp-password",
                            spamAction: .tag,
                            wildcard: true,
                            forceDkimAuthority: false,
                            dkimKeySize: 2048,
                            ips: "203.0.113.1,203.0.113.2",
                            poolId: "pool-parity-1",
                            webScheme: "https"
                        )
                    )
                ),
                ("get", .get(domain: try .init("parity.example.com"))),
                (
                    "update",
                    .update(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            spamAction: .block,
                            webScheme: "https",
                            wildcard: false
                        )
                    )
                ),
                ("delete", .delete(domain: try .init("parity.example.com"))),
                ("verify", .verify(domain: try .init("parity.example.com")))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Domains")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["list-nil"])
    }
}

@Suite("Mailgun.Domains.Tracking Router Parity")
struct DomainTrackingParityTests {
    let router = Mailgun.Domains.Domains.Tracking.API.Router()

    var routes: [(name: String, route: Mailgun.Domains.Domains.Tracking.API)] {
        get throws {
            [
                ("get", .get(domain: try .init("parity.example.com"))),
                (
                    "updateClick",
                    .updateClick(
                        domain: try .init("parity.example.com"),
                        request: .init(active: true)
                    )
                ),
                (
                    "updateOpen",
                    .updateOpen(
                        domain: try .init("parity.example.com"),
                        request: .init(active: false)
                    )
                ),
                (
                    "updateUnsubscribe",
                    .updateUnsubscribe(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            active: true,
                            htmlFooter: "<p>Unsubscribe <a href=\"%unsubscribe_url%\">here</a></p>",
                            textFooter: "Unsubscribe: %unsubscribe_url%"
                        )
                    )
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Domains.Tracking")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}

@Suite("Mailgun.Domains.DKIM_Security Router Parity")
struct DKIMSecurityParityTests {
    let router = Mailgun.Domains.DKIM_Security.API.Router()

    var routes: [(name: String, route: Mailgun.Domains.DKIM_Security.API)] {
        get throws {
            [
                (
                    "updateRotation",
                    .updateRotation(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            rotationEnabled: true,
                            rotationInterval: "5d"
                        )
                    )
                ),
                ("rotateManually", .rotateManually(domain: try .init("parity.example.com")))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Domains.DKIMSecurity")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}

@Suite("Mailgun.Domains.Keys Router Parity")
struct DomainKeysParityTests {
    let router = Mailgun.Domains.DomainKeys.API.Router()

    var routes: [(name: String, route: Mailgun.Domains.DomainKeys.API)] {
        get throws {
            [
                ("list-nil", .list(request: nil)),
                (
                    "list-full",
                    .list(
                        request: .init(
                            page: "next-page-token",
                            limit: 10,
                            signingDomain: "parity.example.com",
                            selector: "parity-selector"
                        )
                    )
                ),
                (
                    "create",
                    .create(
                        request: .init(
                            signingDomain: "parity.example.com",
                            selector: "parity-selector",
                            bits: 2048,
                            pem: "-----BEGIN PRIVATE KEY-----PARITYFIXTURE-----END PRIVATE KEY-----"
                        )
                    )
                ),
                (
                    "delete",
                    .delete(
                        request: .init(
                            signingDomain: "parity.example.com",
                            selector: "parity-selector"
                        )
                    )
                ),
                (
                    "activate",
                    .activate(authorityName: "parity.example.com", selector: "parity-selector")
                ),
                ("listDomainKeys", .listDomainKeys(authorityName: "parity.example.com")),
                (
                    "deactivate",
                    .deactivate(authorityName: "parity.example.com", selector: "parity-selector")
                ),
                (
                    "setDkimAuthority",
                    .setDkimAuthority(
                        domainName: "parity.example.com",
                        request: .init(dkimAuthority: "authority.example.com")
                    )
                ),
                (
                    "setDkimSelector",
                    .setDkimSelector(
                        domainName: "parity.example.com",
                        request: .init(dkimSelector: "parity-selector")
                    )
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Domains.Keys")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["list-nil"])
    }
}
